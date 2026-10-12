USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @RenewalSeed TABLE
    (
        Username NVARCHAR(256) NOT NULL,
        ISBN NVARCHAR(20) NOT NULL,
        RequestDaysAgo INT NOT NULL,
        ProposedExtensionDays INT NOT NULL,
        Status INT NOT NULL,
        ApproverUsername NVARCHAR(256) NULL,
        ProcessedDaysAgo INT NULL,
        ApproverNotes NVARCHAR(500) NULL
    );

    /*
        RenewalStatus:
        0 = Pending
        1 = Approved
        2 = Rejected

        Existing loan statuses:
        1 = Borrowed
        3 = Overdue
    */

    INSERT INTO @RenewalSeed
    (
        Username,
        ISBN,
        RequestDaysAgo,
        ProposedExtensionDays,
        Status,
        ApproverUsername,
        ProcessedDaysAgo,
        ApproverNotes
    )
    VALUES
    -- 1. Pending renewal for a currently borrowed book
    (
        'member01', '9780000000187',
        1, 14, 0,
        NULL, NULL, NULL
    ),

    -- 2. Approved renewal for a currently borrowed book
    (
        'member02', '9780000000194',
        2, 14, 1,
        'librarian01', 1,
        N'Yêu cầu gia hạn được chấp thuận thêm 14 ngày.'
    ),

    -- 3. Rejected renewal for a currently borrowed book
    (
        'member03', '9780000000200',
        3, 14, 2,
        'librarian02', 2,
        N'Từ chối gia hạn theo quy định của thư viện.'
    ),

    -- 4. Pending renewal for an overdue book
    (
        'member04', '9780000000231',
        1, 14, 0,
        NULL, NULL, NULL
    ),

    -- 5. Rejected renewal for an overdue book
    (
        'member05', '9780000000040',
        2, 14, 2,
        'librarian01', 1,
        N'Không chấp thuận gia hạn; vui lòng liên hệ thư viện.'
    );


    -- Validate the number and status distribution
    IF (SELECT COUNT(*) FROM @RenewalSeed) <> 5
    BEGIN
        ;THROW 50200, 'Renewal seed must contain exactly 5 records.', 1;
    END;

    IF (SELECT COUNT(*) FROM @RenewalSeed WHERE Status = 0) <> 2
       OR (SELECT COUNT(*) FROM @RenewalSeed WHERE Status = 1) <> 1
       OR (SELECT COUNT(*) FROM @RenewalSeed WHERE Status = 2) <> 2
    BEGIN
        ;THROW 50201, 'Unexpected renewal status distribution.', 1;
    END;


    -- Validate members, books, and loan ownership/status
    IF EXISTS
    (
        SELECT 1
        FROM @RenewalSeed s
        LEFT JOIN dbo.Users u
            ON u.Username = s.Username
           AND u.Role = 2
        LEFT JOIN dbo.Books b
            ON b.ISBN = s.ISBN
        LEFT JOIN dbo.LoanTransactions l
            ON l.MemberId = u.UserID
           AND l.BookId = b.BookID
           AND l.Status IN (1, 3)
        WHERE u.UserID IS NULL
           OR b.BookID IS NULL
           OR l.LoanID IS NULL
    )
    BEGIN
        ;THROW 50202, 'A member, book, or eligible loan was not found.', 1;
    END;


    -- Validate approver accounts for processed requests
    IF EXISTS
    (
        SELECT 1
        FROM @RenewalSeed s
        LEFT JOIN dbo.Users a
            ON a.Username = s.ApproverUsername
           AND a.Role = 1
        WHERE
            (s.Status IN (1, 2) AND a.UserID IS NULL)
            OR
            (s.Status = 0 AND
                (s.ApproverUsername IS NOT NULL
                 OR s.ProcessedDaysAgo IS NOT NULL))
    )
    BEGIN
        ;THROW 50203, 'Invalid approver or processing details.', 1;
    END;


    -- Insert only missing renewal requests.
    -- Existing renewals for the same loan and request date are skipped.
    INSERT INTO dbo.LoanRenewals
    (
        LoanId,
        MemberId,
        RequestDate,
        ProposedDueDate,
        Status,
        ApproverId,
        ProcessedDate,
        ApproverNotes
    )
    SELECT
        l.LoanID,
        u.UserID,
        DATEADD(DAY, -s.RequestDaysAgo, GETDATE()),

        -- Extend the loan's original due date by the requested period.
        DATEADD(DAY, s.ProposedExtensionDays, l.DueDate),

        s.Status,
        a.UserID,

        CASE
            WHEN s.ProcessedDaysAgo IS NULL THEN NULL
            ELSE DATEADD(DAY, -s.ProcessedDaysAgo, GETDATE())
        END,

        s.ApproverNotes
    FROM @RenewalSeed s
    INNER JOIN dbo.Users u
        ON u.Username = s.Username
       AND u.Role = 2
    INNER JOIN dbo.Books b
        ON b.ISBN = s.ISBN
    INNER JOIN dbo.LoanTransactions l
        ON l.MemberId = u.UserID
       AND l.BookId = b.BookID
       AND l.Status IN (1, 3)
    LEFT JOIN dbo.Users a
        ON a.Username = s.ApproverUsername
       AND a.Role = 1
    WHERE l.DueDate IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.LoanRenewals existing
          WHERE existing.LoanId = l.LoanID
            AND existing.RequestDate >=
                DATEADD(DAY, -s.RequestDaysAgo, CONVERT(date, GETDATE()))
            AND existing.RequestDate <
                DATEADD(DAY, 1 - s.RequestDaysAgo, CONVERT(date, GETDATE()))
      );

    COMMIT TRANSACTION;

    PRINT N'Loan renewal seed completed successfully.';

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Loan renewal seed failed and was rolled back.';
    THROW;
END CATCH;
GO


-- Verify renewal records
SELECT
    r.RenewalID,
    member.Username AS MemberUsername,
    b.Title AS BookTitle,
    l.LoanID,
    l.Status AS LoanStatus,
    l.DueDate AS OriginalDueDate,
    r.RequestDate,
    r.ProposedDueDate,
    r.Status AS RenewalStatusCode,
    CASE r.Status
        WHEN 0 THEN N'Pending'
        WHEN 1 THEN N'Approved'
        WHEN 2 THEN N'Rejected'
        ELSE N'Unknown'
    END AS RenewalStatus,
    approver.Username AS ApprovedBy,
    r.ProcessedDate,
    r.ApproverNotes
FROM dbo.LoanRenewals r
INNER JOIN dbo.LoanTransactions l
    ON l.LoanID = r.LoanId
INNER JOIN dbo.Users member
    ON member.UserID = r.MemberId
INNER JOIN dbo.Books b
    ON b.BookID = l.BookId
LEFT JOIN dbo.Users approver
    ON approver.UserID = r.ApproverId
ORDER BY r.RenewalID;
GO


-- Count renewal requests by status
SELECT
    Status,
    CASE Status
        WHEN 0 THEN N'Pending'
        WHEN 1 THEN N'Approved'
        WHEN 2 THEN N'Rejected'
        ELSE N'Unknown'
    END AS RenewalStatus,
    COUNT(*) AS Total
FROM dbo.LoanRenewals
GROUP BY Status
ORDER BY Status;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @FineRate DECIMAL(18, 2);

    -- Get the daily fine rate from the active library policy.
    SELECT TOP (1)
        @FineRate = DailyFineRate
    FROM dbo.LibraryPolicies
    WHERE IsActive = 1
    ORDER BY CreatedAt DESC, PolicyID DESC;

    IF @FineRate IS NULL
    BEGIN
        ;THROW 50300, 'No active library policy with a fine rate was found.', 1;
    END;

    -- Ensure overdue loans have valid due dates.
    IF EXISTS
    (
        SELECT 1
        FROM dbo.LoanTransactions
        WHERE Status = 3
          AND DueDate IS NULL
    )
    BEGIN
        ;THROW 50301, 'An overdue loan has no DueDate.', 1;
    END;

    -- Insert one fine for each overdue loan that has no fine yet.
    INSERT INTO dbo.Fines
    (
        LoanId,
        MemberId,
        FineRatePerDay,
        OverdueDays,
        FineAmount,
        Status,
        CreatedAt
    )
    SELECT
        l.LoanID,
        l.MemberId,
        @FineRate,
        DATEDIFF(DAY, CONVERT(date, l.DueDate), CONVERT(date, GETDATE())),
        @FineRate * DATEDIFF(
            DAY,
            CONVERT(date, l.DueDate),
            CONVERT(date, GETDATE())
        ),
        0, -- Unpaid
        GETDATE()
    FROM dbo.LoanTransactions l
    WHERE l.Status = 3
      AND l.DueDate < CONVERT(date, GETDATE())
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.Fines f
          WHERE f.LoanId = l.LoanID
      );

    COMMIT TRANSACTION;

    PRINT N'Fine seed completed successfully.';

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Fine seed failed and was rolled back.';
    THROW;
END CATCH;
GO


-- Verify fine records
SELECT
    f.FineID,
    u.Username,
    b.Title AS BookTitle,
    l.LoanID,
    l.DueDate,
    f.FineRatePerDay,
    f.OverdueDays,
    f.FineAmount,
    f.Status AS FineStatusCode,
    CASE f.Status
        WHEN 0 THEN N'Unpaid'
        WHEN 1 THEN N'Partially Paid'
        WHEN 2 THEN N'Paid'
        ELSE N'Unknown'
    END AS FineStatus,
    f.CreatedAt
FROM dbo.Fines f
INNER JOIN dbo.LoanTransactions l
    ON l.LoanID = f.LoanId
INNER JOIN dbo.Users u
    ON u.UserID = f.MemberId
INNER JOIN dbo.Books b
    ON b.BookID = l.BookId
ORDER BY f.FineID;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @PaymentSeed TABLE
    (
        Username NVARCHAR(256) NOT NULL,
        ISBN NVARCHAR(20) NOT NULL,
        AmountPaid DECIMAL(18, 2) NULL,
        DaysAgo INT NOT NULL,
        ApproverUsername NVARCHAR(256) NOT NULL,
        PaymentMethod INT NOT NULL
    );

    /*
        PaymentMethod:
        0 = Cash
        1 = CreditCard
        2 = DebitCard
        3 = OnlineBanking

        AmountPaid:
        NULL = pay the full outstanding fine
        A value = partial payment
    */

    INSERT INTO @PaymentSeed
    (
        Username,
        ISBN,
        AmountPaid,
        DaysAgo,
        ApproverUsername,
        PaymentMethod
    )
    VALUES
    -- Partial payment: 25,000 VND
    ('member01', '9780000000057', 25000.00, 2, 'librarian01', 0),

    -- Full payment
    ('member02', '9780000000064', NULL, 1, 'librarian02', 1),

    -- Partial payment: 50,000 VND
    ('member03', '9780000000095', 50000.00, 3, 'librarian01', 3),

    -- Full payment
    ('member04', '9780000000101', NULL, 2, 'librarian02', 2),

    -- Full payment
    ('member05', '9780000000026', NULL, 1, 'librarian01', 0);


    -- Validate that all five fine records exist.
    IF EXISTS
    (
        SELECT 1
        FROM @PaymentSeed s
        LEFT JOIN dbo.Users u
            ON u.Username = s.Username
           AND u.Role = 2
        LEFT JOIN dbo.Books b
            ON b.ISBN = s.ISBN
        LEFT JOIN dbo.LoanTransactions l
            ON l.MemberId = u.UserID
           AND l.BookId = b.BookID
           AND l.Status = 3
        LEFT JOIN dbo.Fines f
            ON f.LoanId = l.LoanID
           AND f.MemberId = u.UserID
        LEFT JOIN dbo.Users a
            ON a.Username = s.ApproverUsername
           AND a.Role = 1
        WHERE u.UserID IS NULL
           OR b.BookID IS NULL
           OR l.LoanID IS NULL
           OR f.FineID IS NULL
           OR a.UserID IS NULL
    )
    BEGIN
        ;THROW 50310, 'A member, overdue loan, fine, or librarian was not found. Run the Fines script first.', 1;
    END;


    -- Validate payment amounts and payment methods.
    IF EXISTS
    (
        SELECT 1
        FROM @PaymentSeed s
        INNER JOIN dbo.Users u
            ON u.Username = s.Username
           AND u.Role = 2
        INNER JOIN dbo.Books b
            ON b.ISBN = s.ISBN
        INNER JOIN dbo.LoanTransactions l
            ON l.MemberId = u.UserID
           AND l.BookId = b.BookID
           AND l.Status = 3
        INNER JOIN dbo.Fines f
            ON f.LoanId = l.LoanID
           AND f.MemberId = u.UserID
        WHERE
            (s.AmountPaid IS NOT NULL AND
                (s.AmountPaid <= 0 OR s.AmountPaid > f.FineAmount))
            OR s.PaymentMethod NOT IN (0, 1, 2, 3)
    )
    BEGIN
        ;THROW 50311, 'Invalid payment amount or payment method.', 1;
    END;


    -- Insert payments only if that fine has no existing payment.
    -- This keeps this seed script from duplicating its own payments.
    INSERT INTO dbo.FinePayments
    (
        FineId,
        ApproverId,
        AmountPaid,
        PaymentDate,
        PaymentMethod
    )
    SELECT
        f.FineID,
        a.UserID,
        COALESCE(s.AmountPaid, f.FineAmount),
        DATEADD(DAY, -s.DaysAgo, GETDATE()),
        s.PaymentMethod
    FROM @PaymentSeed s
    INNER JOIN dbo.Users u
        ON u.Username = s.Username
       AND u.Role = 2
    INNER JOIN dbo.Books b
        ON b.ISBN = s.ISBN
    INNER JOIN dbo.LoanTransactions l
        ON l.MemberId = u.UserID
       AND l.BookId = b.BookID
       AND l.Status = 3
    INNER JOIN dbo.Fines f
        ON f.LoanId = l.LoanID
       AND f.MemberId = u.UserID
    INNER JOIN dbo.Users a
        ON a.Username = s.ApproverUsername
       AND a.Role = 1
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.FinePayments existing
        WHERE existing.FineId = f.FineID
    );


    -- Recalculate fine status using all recorded payments.
    UPDATE f
    SET f.Status =
        CASE
            WHEN COALESCE(p.TotalPaid, 0) >= f.FineAmount THEN 2
            WHEN COALESCE(p.TotalPaid, 0) > 0 THEN 1
            ELSE 0
        END
    FROM dbo.Fines f
    OUTER APPLY
    (
        SELECT SUM(fp.AmountPaid) AS TotalPaid
        FROM dbo.FinePayments fp
        WHERE fp.FineId = f.FineID
    ) p;

    COMMIT TRANSACTION;

    PRINT N'Fine payment seed completed successfully.';

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Fine payment seed failed and was rolled back.';
    THROW;
END CATCH;
GO


-- Verify payments and their associated fines
SELECT
    fp.PaymentID,
    u.Username,
    b.Title AS BookTitle,
    f.FineID,
    f.FineAmount,
    fp.AmountPaid,
    fp.PaymentDate,
    fp.PaymentMethod,
    CASE fp.PaymentMethod
        WHEN 0 THEN N'Cash'
        WHEN 1 THEN N'Credit Card'
        WHEN 2 THEN N'Debit Card'
        WHEN 3 THEN N'Online Banking'
        ELSE N'Unknown'
    END AS PaymentMethodName,
    approver.Username AS ApprovedBy,
    f.Status AS FineStatusCode,
    CASE f.Status
        WHEN 0 THEN N'Unpaid'
        WHEN 1 THEN N'Partially Paid'
        WHEN 2 THEN N'Paid'
        ELSE N'Unknown'
    END AS FineStatus
FROM dbo.FinePayments fp
INNER JOIN dbo.Fines f
    ON f.FineID = fp.FineId
INNER JOIN dbo.LoanTransactions l
    ON l.LoanID = f.LoanId
INNER JOIN dbo.Users u
    ON u.UserID = f.MemberId
INNER JOIN dbo.Books b
    ON b.BookID = l.BookId
INNER JOIN dbo.Users approver
    ON approver.UserID = fp.ApproverId
ORDER BY fp.PaymentID;
GO