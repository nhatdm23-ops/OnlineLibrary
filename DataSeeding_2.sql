USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.LibraryPolicies
        WHERE PolicyName = N'Standard Library Policy'
    )
    BEGIN
        INSERT INTO dbo.LibraryPolicies
        (
            PolicyName,
            MaxBooksAllowedPerMember,
            DefaultBorrowDurationDays,
            DailyFineRate,
            MaxRenewalLimit,
            IsActive,
            CreatedAt,
            UpdatedAt
        )
        VALUES
        (
            N'Standard Library Policy',
            5,
            14,
            5000.00,
            2,
            1,
            GETDATE(),
            NULL
        );
    END;

    COMMIT TRANSACTION;
    PRINT N'Library policy transaction committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Library policy transaction failed.';
    THROW;
END CATCH;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @PolicyID INT;
    DECLARE @AdminID INT;
    DECLARE @EffectiveDate DATETIME = '2026-10-10T00:00:00';

    SELECT @PolicyID = PolicyID
    FROM dbo.LibraryPolicies
    WHERE PolicyName = N'Standard Library Policy';

    IF @PolicyID IS NULL
        THROW 50020, 'Standard Library Policy was not found.', 1;

    SELECT @AdminID = UserID
    FROM dbo.Users
    WHERE Username = N'admin';

    IF @AdminID IS NULL
        THROW 50021, 'Administrator account was not found.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.LibraryPolicyHistories
        WHERE PolicyID = @PolicyID
          AND EffectiveFrom = @EffectiveDate
    )
    BEGIN
        INSERT INTO dbo.LibraryPolicyHistories
        (
            PolicyID,
            MaxBooksAllowedPerMember,
            DefaultBorrowDurationDays,
            DailyFineRate,
            MaxRenewalLimit,
            EffectiveFrom,
            EffectiveTo,
            ChangedAt,
            ChangedBy,
            ChangeReason
        )
        SELECT
            PolicyID,
            MaxBooksAllowedPerMember,
            DefaultBorrowDurationDays,
            DailyFineRate,
            MaxRenewalLimit,
            @EffectiveDate,
            NULL,
            GETDATE(),
            @AdminID,
            N'Initial library policy configuration.'
        FROM dbo.LibraryPolicies
        WHERE PolicyID = @PolicyID;
    END;

    COMMIT TRANSACTION;
    PRINT N'Policy history transaction committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Policy history transaction failed.';
    THROW;
END CATCH;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @LoanSeed TABLE
    (
        ISBN NVARCHAR(13) NOT NULL,
        MemberUsername NVARCHAR(50) NOT NULL,
        Status INT NOT NULL,
        BorrowDaysAgo INT NULL,
        DueDaysOffset INT NULL,
        ReturnDaysAgo INT NULL,
        ApproverUsername NVARCHAR(50) NULL
    );

    /*
        LoanStatus:
        Reserved  = 0
        Borrowed  = 1
        Returned  = 2
        Overdue   = 3
        Cancelled = 4

        Reserved, Borrowed and Overdue each consume one copy.
    */

    INSERT INTO @LoanSeed
    (
        ISBN, MemberUsername, Status,
        BorrowDaysAgo, DueDaysOffset, ReturnDaysAgo,
        ApproverUsername
    )
    VALUES
    -- =========================================
    -- 1-10: Overdue
    -- =========================================
    (N'9780000000057', N'member01', 3, 35, -21, NULL, N'librarian01'),
    (N'9780000000064', N'member02', 3, 32, -18, NULL, N'librarian01'),
    (N'9780000000095', N'member03', 3, 30, -16, NULL, N'librarian01'),
    (N'9780000000101', N'member04', 3, 29, -15, NULL, N'librarian01'),
    (N'9780000000026', N'member05', 3, 40, -26, NULL, N'librarian01'),
    (N'9780000000125', N'member06', 3, 33, -19, NULL, N'librarian01'),
    (N'9780000000132', N'member07', 3, 31, -17, NULL, N'librarian01'),
    (N'9780000000156', N'member08', 3, 37, -23, NULL, N'librarian01'),
    (N'9780000000163', N'member09', 3, 34, -20, NULL, N'librarian01'),
    (N'9780000000033', N'nhutt23', 3, 36, -22, NULL, N'librarian01'),

    -- =========================================
    -- 11-20: Borrowed
    -- =========================================
    (N'9780000000187', N'member01', 1,  3, 11, NULL, N'librarian01'),
    (N'9780000000194', N'member02', 1,  4, 10, NULL, N'librarian01'),
    (N'9780000000200', N'member03', 1,  5,  9, NULL, N'librarian01'),
    (N'9780000000231', N'member04', 1,  6,  8, NULL, N'librarian01'),
    (N'9780000000040', N'member05', 1,  2, 12, NULL, N'librarian01'),
    (N'9780000000248', N'member06', 1,  7,  7, NULL, N'librarian01'),
    (N'9780000000255', N'member07', 1,  8,  6, NULL, N'librarian01'),
    (N'9780000000279', N'member08', 1,  9,  5, NULL, N'librarian01'),
    (N'9780000000286', N'member09', 1, 10,  4, NULL, N'librarian01'),
    (N'9780000000293', N'nhutt23', 1,  3, 11, NULL, N'librarian01'),

    -- =========================================
    -- 21-30: Reserved
    -- =========================================
    (N'9780000000323', N'member10', 0, NULL, NULL, NULL, NULL),
    (N'9780000000330', N'member11', 0, NULL, NULL, NULL, NULL),
    (N'9780000000347', N'member12', 0, NULL, NULL, NULL, NULL),
    (N'9780000000354', N'member13', 0, NULL, NULL, NULL, NULL),
    (N'9780000000385', N'member14', 0, NULL, NULL, NULL, NULL),
    (N'9780000000408', N'member15', 0, NULL, NULL, NULL, NULL),
    (N'9780000000439', N'member16', 0, NULL, NULL, NULL, NULL),
    (N'9780000000446', N'member17', 0, NULL, NULL, NULL, NULL),
    (N'9780000000460', N'member18', 0, NULL, NULL, NULL, NULL),
    (N'9780000000484', N'nhutt23', 0, NULL, NULL, NULL, NULL),

    -- =========================================
    -- 31-35: Returned
    -- These are historical transactions.
    -- =========================================
    (N'9780000000019', N'member10', 2, 20, -13, 3, N'librarian01'),
    (N'9780000000071', N'member11', 2, 22, -15, 5, N'librarian01'),
    (N'9780000000118', N'member12', 2, 24, -17, 7, N'librarian01'),
    (N'9780000000149', N'member13', 2, 26, -19, 9, N'librarian01'),
    (N'9780000000217', N'member14', 2, 28, -21, 11, N'librarian01'),

    -- =========================================
    -- 36-40: Cancelled
    -- =========================================
    (N'9780000000019', N'member15', 4, NULL, NULL, NULL, N'librarian02'),
    (N'9780000000071', N'member16', 4, NULL, NULL, NULL, N'librarian02'),
    (N'9780000000118', N'member17', 4, NULL, NULL, NULL, N'librarian02'),
    (N'9780000000149', N'member18', 4, NULL, NULL, NULL, N'librarian02'),
    (N'9780000000217', N'member01', 4, NULL, NULL, NULL, N'librarian02');

    -- =========================================
    -- 1. Validate the seed before insertion
    -- =========================================
    IF (SELECT COUNT(*) FROM @LoanSeed) <> 40
    BEGIN
        ;THROW 50100, 'Loan seed must contain exactly 40 rows.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM @LoanSeed
        WHERE Status NOT IN (0, 1, 2, 3, 4)
    )
    BEGIN
        ;THROW 50101, 'Invalid LoanStatus value.', 1;
    END;

    IF EXISTS (SELECT 1 FROM dbo.LoanTransactions)
    BEGIN
        ;THROW 50102,
            'LoanTransactions is not empty. Use a fresh database or clear existing test transactions first.',
            1;
    END;

    -- Confirm that all ISBNs and user accounts exist.
    IF EXISTS
    (
        SELECT 1
        FROM @LoanSeed S
        LEFT JOIN dbo.Books B
            ON B.ISBN = S.ISBN
        LEFT JOIN dbo.Users M
            ON M.Username = S.MemberUsername
        LEFT JOIN dbo.Users A
            ON A.Username = S.ApproverUsername
        WHERE B.BookID IS NULL
           OR M.UserID IS NULL
           OR M.Role <> 2
           OR
           (
               S.ApproverUsername IS NOT NULL
               AND (A.UserID IS NULL OR A.Role NOT IN (0, 1))
           )
    )
    BEGIN
        ;THROW 50103,
            'A book or user is missing, or a user has an invalid role.',
            1;
    END;

    -- Validate the status distribution.
    IF (SELECT COUNT(*) FROM @LoanSeed WHERE Status = 3) <> 10
       OR (SELECT COUNT(*) FROM @LoanSeed WHERE Status = 1) <> 10
       OR (SELECT COUNT(*) FROM @LoanSeed WHERE Status = 0) <> 10
       OR (SELECT COUNT(*) FROM @LoanSeed WHERE Status = 2) <> 5
       OR (SELECT COUNT(*) FROM @LoanSeed WHERE Status = 4) <> 5
    BEGIN
        ;THROW 50104, 'Unexpected loan status distribution.', 1;
    END;

    -- =========================================
    -- 2. Verify current Books inventory
    -- =========================================
    IF
    (
        SELECT SUM(TotalCopies - AvailableCopies)
        FROM dbo.Books
    ) <> 30
    BEGIN
        ;THROW 50105,
            'Current Books inventory does not contain exactly 30 unavailable copies.',
            1;
    END;

    -- Each book's unavailable count must match its planned active loans.
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Books B
        OUTER APPLY
        (
            SELECT COUNT(*) AS PlannedActiveLoans
            FROM @LoanSeed S
            WHERE S.ISBN = B.ISBN
              AND S.Status IN (0, 1, 3)
        ) P
        WHERE B.TotalCopies - B.AvailableCopies <> P.PlannedActiveLoans
    )
    BEGIN
        ;THROW 50106,
            'The planned active loans do not match one or more books inventory counts.',
            1;
    END;

    -- =========================================
    -- 3. Insert the 40 transactions
    -- =========================================
    INSERT INTO dbo.LoanTransactions
    (
        MemberId,
        BookId,
        ApproverId,
        BorrowDate,
        DueDate,
        ReturnDate,
        Status
    )
    SELECT
        M.UserID,
        B.BookID,
        A.UserID,
        CASE
            WHEN S.BorrowDaysAgo IS NOT NULL
            THEN DATEADD(
                DAY, -S.BorrowDaysAgo,
                CONVERT(DATE, GETDATE())
            )
            ELSE NULL
        END,
        CASE
            WHEN S.DueDaysOffset IS NOT NULL
            THEN DATEADD(
                DAY, S.DueDaysOffset,
                CONVERT(DATE, GETDATE())
            )
            ELSE NULL
        END,
        CASE
            WHEN S.ReturnDaysAgo IS NOT NULL
            THEN DATEADD(
                DAY, -S.ReturnDaysAgo,
                CONVERT(DATE, GETDATE())
            )
            ELSE NULL
        END,
        S.Status
    FROM @LoanSeed S
    INNER JOIN dbo.Books B
        ON B.ISBN = S.ISBN
    INNER JOIN dbo.Users M
        ON M.Username = S.MemberUsername
    LEFT JOIN dbo.Users A
        ON A.Username = S.ApproverUsername;

    IF @@ROWCOUNT <> 40
    BEGIN
        ;THROW 50107, 'Expected to insert exactly 40 transactions.', 1;
    END;

    -- =========================================
    -- 4. Verify inventory after insertion
    -- =========================================
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Books B
        OUTER APPLY
        (
            SELECT COUNT(*) AS ActiveLoans
            FROM dbo.LoanTransactions L
            WHERE L.BookId = B.BookID
              AND L.Status IN (0, 1, 3)
        ) L
        WHERE B.TotalCopies - B.AvailableCopies <> L.ActiveLoans
    )
    BEGIN
        ;THROW 50108,
            'Post-insert inventory validation failed.',
            1;
    END;

    COMMIT TRANSACTION;

    PRINT N'Loan seed committed successfully: 40 transactions.';

    -- Show the inserted transactions.
    SELECT
        L.LoanID,
        M.Username AS MemberUsername,
        B.Title,
        B.ISBN,
        L.BorrowDate,
        L.DueDate,
        L.ReturnDate,
        CASE L.Status
            WHEN 0 THEN N'Reserved'
            WHEN 1 THEN N'Borrowed'
            WHEN 2 THEN N'Returned'
            WHEN 3 THEN N'Overdue'
            WHEN 4 THEN N'Cancelled'
        END AS LoanStatus,
        A.Username AS ApproverUsername
    FROM dbo.LoanTransactions L
    INNER JOIN dbo.Users M
        ON M.UserID = L.MemberId
    INNER JOIN dbo.Books B
        ON B.BookID = L.BookId
    LEFT JOIN dbo.Users A
        ON A.UserID = L.ApproverId
    ORDER BY L.LoanID;

    -- Show the inventory reconciliation.
    SELECT
        B.BookID,
        B.Title,
        B.TotalCopies,
        B.AvailableCopies,
        B.TotalCopies - B.AvailableCopies AS UnavailableCopies,
        SUM(
            CASE WHEN L.Status IN (0, 1, 3)
                 THEN 1 ELSE 0 END
        ) AS ActiveInventoryConsumingLoans
    FROM dbo.Books B
    LEFT JOIN dbo.LoanTransactions L
        ON L.BookId = B.BookID
    GROUP BY
        B.BookID, B.Title,
        B.TotalCopies, B.AvailableCopies
    ORDER BY B.BookID;

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Loan seed failed and was rolled back.';
    THROW;
END CATCH;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @ReservationSeed TABLE
    (
        Username NVARCHAR(256) NOT NULL,
        ISBN NVARCHAR(20) NOT NULL,
        RequestDaysAgo INT NOT NULL,
        ExpirationDaysFromNow INT NULL,
        ApproverUsername NVARCHAR(256) NULL,
        ProcessedDaysAgo INT NULL,
        ApproverNotes NVARCHAR(500) NULL,
        Status INT NOT NULL
    );

    /*
        Reservation status:
        0 = Pending
        1 = Confirmed
        2 = Fulfilled
        3 = Expired
        4 = Cancelled

        Loan status:
        0 = Reserved
        1 = Borrowed
        2 = Returned
        3 = Overdue
        4 = Cancelled
    */

    INSERT INTO @ReservationSeed
    (
        Username, ISBN, RequestDaysAgo,
        ExpirationDaysFromNow, ApproverUsername,
        ProcessedDaysAgo, ApproverNotes, Status
    )
    VALUES
    -- ==========================================
    -- 10 CONFIRMED reservations
    -- Each matches an existing Reserved loan.
    -- ==========================================
    ('member10', '9780000000323', 3, 4,
        'librarian01', 2, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member11', '9780000000330', 4, 3,
        'librarian01', 3, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member12', '9780000000347', 2, 5,
        'librarian02', 1, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member13', '9780000000354', 5, 2,
        'librarian02', 4, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member14', '9780000000385', 3, 4,
        'librarian01', 2, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member15', '9780000000408', 2, 5,
        'librarian02', 1, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member16', '9780000000439', 4, 3,
        'librarian01', 3, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member17', '9780000000446', 3, 4,
        'librarian02', 2, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('member18', '9780000000460', 2, 5,
        'librarian01', 1, N'Đã xác nhận yêu cầu đặt sách.', 1),

    ('nhutt23', '9780000000484', 4, 3,
        'librarian02', 3, N'Đã xác nhận yêu cầu đặt sách.', 1),

    -- ==========================================
    -- 5 FULFILLED reservations
    -- Each matches an existing Borrowed loan.
    -- ==========================================
    ('member01', '9780000000187', 5, NULL,
        'librarian01', 3, N'Đã giao sách cho thành viên.', 2),

    ('member02', '9780000000194', 6, NULL,
        'librarian02', 4, N'Đã giao sách cho thành viên.', 2),

    ('member03', '9780000000200', 7, NULL,
        'librarian01', 5, N'Đã giao sách cho thành viên.', 2),

    ('member04', '9780000000231', 8, NULL,
        'librarian02', 6, N'Đã giao sách cho thành viên.', 2),

    ('member05', '9780000000040', 4, NULL,
        'librarian01', 2, N'Đã giao sách cho thành viên.', 2),

    -- ==========================================
    -- 1 PENDING reservation
    -- No matching LoanTransactions record.
    -- ==========================================
    ('member19', '9780000000019', 0, NULL,
        NULL, NULL, NULL, 0),

    -- ==========================================
    -- 1 EXPIRED reservation
    -- No matching LoanTransactions record.
    -- ==========================================
    ('member20', '9780000000071', 8, -2,
        'librarian02', 2,
        N'Yêu cầu đặt sách đã hết hạn nhận sách.', 3),

    -- ==========================================
    -- 1 CANCELLED reservation
    -- No matching LoanTransactions record.
    -- ==========================================
    ('member19', '9780000000118', 6, NULL,
        'librarian01', 4,
        N'Thành viên đã hủy yêu cầu đặt sách.', 4);


    -- ------------------------------------------
    -- Validate seed size and status distribution
    -- ------------------------------------------
    IF (SELECT COUNT(*) FROM @ReservationSeed) <> 18
    BEGIN
        ;THROW 50100, 'Reservation seed must contain exactly 18 records.', 1;
    END;

    IF (SELECT COUNT(*) FROM @ReservationSeed WHERE Status = 1) <> 10
       OR (SELECT COUNT(*) FROM @ReservationSeed WHERE Status = 2) <> 5
       OR (SELECT COUNT(*) FROM @ReservationSeed WHERE Status = 0) <> 1
       OR (SELECT COUNT(*) FROM @ReservationSeed WHERE Status = 3) <> 1
       OR (SELECT COUNT(*) FROM @ReservationSeed WHERE Status = 4) <> 1
    BEGIN
        ;THROW 50101, 'Unexpected reservation status distribution.', 1;
    END;


    -- ------------------------------------------
    -- Validate all referenced members and books
    -- ------------------------------------------
    IF EXISTS
    (
        SELECT 1
        FROM @ReservationSeed s
        LEFT JOIN dbo.Users u
            ON u.Username = s.Username
           AND u.Role = 2
        LEFT JOIN dbo.Books b
            ON b.ISBN = s.ISBN
        WHERE u.UserID IS NULL
           OR b.BookID IS NULL
    )
    BEGIN
        ;THROW 50102, 'A member username or book ISBN was not found.', 1;
    END;


    -- ------------------------------------------
    -- Confirmed must match a Reserved loan.
    -- Fulfilled must match a Borrowed loan.
    -- Other statuses must not match any loan
    -- for the same member and book.
    -- ------------------------------------------
    IF EXISTS
    (
        SELECT 1
        FROM @ReservationSeed s
        INNER JOIN dbo.Users u
            ON u.Username = s.Username
        INNER JOIN dbo.Books b
            ON b.ISBN = s.ISBN
        WHERE
            (
                s.Status = 1
                AND NOT EXISTS
                (
                    SELECT 1
                    FROM dbo.LoanTransactions l
                    WHERE l.MemberId = u.UserID
                      AND l.BookId = b.BookID
                      AND l.Status = 0
                )
            )
            OR
            (
                s.Status = 2
                AND NOT EXISTS
                (
                    SELECT 1
                    FROM dbo.LoanTransactions l
                    WHERE l.MemberId = u.UserID
                      AND l.BookId = b.BookID
                      AND l.Status = 1
                )
            )
            OR
            (
                s.Status IN (0, 3, 4)
                AND EXISTS
                (
                    SELECT 1
                    FROM dbo.LoanTransactions l
                    WHERE l.MemberId = u.UserID
                      AND l.BookId = b.BookID
                )
            )
    )
    BEGIN
        ;THROW 50103, 'Reservation status does not match LoanTransactions.', 1;
    END;


    -- ------------------------------------------
    -- Insert new records only.
    -- Existing member/book pairs are not duplicated.
    -- ------------------------------------------
    INSERT INTO dbo.Reservations
    (
        MemberId,
        BookId,
        RequestDate,
        ExpirationDate,
        ApproverId,
        ProcessedDate,
        ApproverNotes,
        Status
    )
    SELECT
        u.UserID,
        b.BookID,
        DATEADD(DAY, -s.RequestDaysAgo, GETDATE()),
        CASE
            WHEN s.ExpirationDaysFromNow IS NULL THEN NULL
            ELSE DATEADD(DAY, s.ExpirationDaysFromNow, GETDATE())
        END,
        approver.UserID,
        CASE
            WHEN s.ProcessedDaysAgo IS NULL THEN NULL
            ELSE DATEADD(DAY, -s.ProcessedDaysAgo, GETDATE())
        END,
        s.ApproverNotes,
        s.Status
    FROM @ReservationSeed s
    INNER JOIN dbo.Users u
        ON u.Username = s.Username
       AND u.Role = 2
    INNER JOIN dbo.Books b
        ON b.ISBN = s.ISBN
    LEFT JOIN dbo.Users approver
        ON approver.Username = s.ApproverUsername
       AND approver.Role = 1
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Reservations existing
        WHERE existing.MemberId = u.UserID
          AND existing.BookId = b.BookID
    );

    COMMIT TRANSACTION;

    PRINT N'Reservation seed completed successfully.';

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Reservation seed failed and was rolled back.';
    THROW;
END CATCH;
GO


-- ==============================================
-- Verify inserted reservations
-- ==============================================
SELECT
    r.ReservationID,
    u.Username,
    u.FullName,
    b.Title,
    b.ISBN,
    r.RequestDate,
    r.ExpirationDate,
    approver.Username AS ApprovedBy,
    r.ProcessedDate,
    r.ApproverNotes,
    r.Status,
    CASE r.Status
        WHEN 0 THEN N'Pending'
        WHEN 1 THEN N'Confirmed'
        WHEN 2 THEN N'Fulfilled'
        WHEN 3 THEN N'Expired'
        WHEN 4 THEN N'Cancelled'
        ELSE N'Unknown'
    END AS ReservationStatus,
    l.Status AS MatchingLoanStatus
FROM dbo.Reservations r
INNER JOIN dbo.Users u
    ON u.UserID = r.MemberId
INNER JOIN dbo.Books b
    ON b.BookID = r.BookId
LEFT JOIN dbo.Users approver
    ON approver.UserID = r.ApproverId
LEFT JOIN dbo.LoanTransactions l
    ON l.MemberId = r.MemberId
   AND l.BookId = r.BookId
ORDER BY r.ReservationID;


-- Count reservations by status
SELECT
    Status,
    CASE Status
        WHEN 0 THEN N'Pending'
        WHEN 1 THEN N'Confirmed'
        WHEN 2 THEN N'Fulfilled'
        WHEN 3 THEN N'Expired'
        WHEN 4 THEN N'Cancelled'
    END AS ReservationStatus,
    COUNT(*) AS Total
FROM dbo.Reservations
GROUP BY Status
ORDER BY Status;
GO