--Users
USE OnlineLibrary;
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Users
        (Username, PasswordHash, Email, FullName, PhoneNumber,
         Address, Role, IsActive, CreatedAt)
    VALUES
        -- Administrator (Role = 0)
        (N'admin', N'Admin123!', N'admin@example.com',
         N'Quản trị viên', N'09000000001',
         N'Phường Sài Gòn, TP. Hồ Chí Minh', 0, 1, GETDATE()),

        -- Librarians (Role = 1)
        (N'librarian01', N'Librarian123!', N'librarian01@example.com',
         N'Nguyễn Minh Anh', N'09000000002',
         N'Phường Bến Thành, TP. Hồ Chí Minh', 1, 1, GETDATE()),

        (N'librarian02', N'Librarian123!', N'librarian02@example.com',
         N'Trần Quốc Bảo', N'09000000003',
         N'Phường Tân Định, TP. Hồ Chí Minh', 1, 1, GETDATE()),

        -- Members (Role = 2)
        (N'member01', N'Member123!', N'member01@example.com',
         N'Nguyễn Văn An', N'09000000004',
         N'Phường Cầu Ông Lãnh, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member02', N'Member123!', N'member02@example.com',
         N'Trần Thị Bình', N'09000000005',
         N'Phường Bàn Cờ, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member03', N'Member123!', N'member03@example.com',
         N'Lê Minh Châu', N'09000000006',
         N'Phường Xuân Hòa, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member04', N'Member123!', N'member04@example.com',
         N'Phạm Quốc Dũng', N'09000000007',
         N'Phường Nhiêu Lộc, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member05', N'Member123!', N'member05@example.com',
         N'Hoàng Thu Hà', N'09000000008',
         N'Phường Xóm Chiếu, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member06', N'Member123!', N'member06@example.com',
         N'Võ Thành Hưng', N'09000000009',
         N'Phường Khánh Hội, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member07', N'Member123!', N'member07@example.com',
         N'Đặng Ngọc Lan', N'09000000010',
         N'Phường Vĩnh Hội, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member08', N'Member123!', N'member08@example.com',
         N'Bùi Đức Long', N'09000000011',
         N'Phường Chợ Quán, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member09', N'Member123!', N'member09@example.com',
         N'Đỗ Phương Mai', N'09000000012',
         N'Phường An Đông, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member10', N'Member123!', N'member10@example.com',
         N'Phan Tuấn Nam', N'09000000013',
         N'Phường Chợ Lớn, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member11', N'Member123!', N'member11@example.com',
         N'Nguyễn Thùy Nga', N'09000000014',
         N'Phường Bình Tây, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member12', N'Member123!', N'member12@example.com',
         N'Trần Hoàng Phúc', N'09000000015',
         N'Phường Bình Tiên, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member13', N'Member123!', N'member13@example.com',
         N'Lê Thanh Quân', N'09000000016',
         N'Phường Bình Phú, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member14', N'Member123!', N'member14@example.com',
         N'Phạm Ngọc Sơn', N'09000000017',
         N'Phường Phú Lâm, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member15', N'Member123!', N'member15@example.com',
         N'Hoàng Minh Tâm', N'09000000018',
         N'Phường Tân Thuận, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member16', N'Member123!', N'member16@example.com',
         N'Vũ Thị Uyên', N'09000000019',
         N'Phường Tân Mỹ, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member17', N'Member123!', N'member17@example.com',
         N'Đặng Anh Việt', N'09000000020',
         N'Phường Tân Hưng, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member18', N'Member123!', N'member18@example.com',
         N'Bùi Khánh Vy', N'09000000021',
         N'Phường Gia Định, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member19', N'Member123!', N'member19@example.com',
         N'Đỗ Hải Yến', N'09000000022',
         N'Phường Bình Thạnh, TP. Hồ Chí Minh', 2, 1, GETDATE()),

        (N'member20', N'Member123!', N'member20@example.com',
         N'Phan Gia Huy', N'09000000023',
         N'Phường Tăng Nhơn Phú, TP. Hồ Chí Minh', 2, 1, GETDATE());

    -- Confirm that all 23 accounts were inserted.
    IF @@ROWCOUNT <> 23
        THROW 50002, 'Expected to insert exactly 23 user accounts.', 1;

    SELECT UserID, Username, Email, FullName,
           PhoneNumber, Address, Role, IsActive
    FROM dbo.Users
    WHERE Username IN (
        N'admin',
        N'librarian01', N'librarian02',
        N'member01', N'member02', N'member03', N'member04',
        N'member05', N'member06', N'member07', N'member08',
        N'member09', N'member10', N'member11', N'member12',
        N'member13', N'member14', N'member15', N'member16',
        N'member17', N'member18', N'member19', N'member20'
    )
    ORDER BY Role, UserID;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO



SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Users
        (Username, PasswordHash, Email, FullName, PhoneNumber,
         Address, Role, IsActive, CreatedAt)
    VALUES
        (
            N'nhutt23', N'123456', N'nhutt23@uef.edu.vn',
            N'Trần Tuyết Như', N'09000000024',
            N'Phường Bến Nghé, TP. Hồ Chí Minh', 2, 1, GETDATE()
        );

    IF @@ROWCOUNT <> 1
        THROW 50002, 'Expected to insert exactly 1 user account.', 1;

    SELECT UserID, Username, Email, FullName,
           PhoneNumber, Address, Role, IsActive
    FROM dbo.Users
    WHERE Username = N'nhutt23';

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO


SET XACT_ABORT ON;

--Genres
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Genres ([Name], [Description])
    SELECT V.[Name], V.[Description]
    FROM (VALUES
        (N'Kỹ năng sống',
         N'Sách phát triển bản thân, giao tiếp và kỹ năng sống.'),
        (N'Tiểu thuyết',
         N'Tác phẩm văn học hư cấu trong nước và quốc tế.'),
        (N'Lịch sử',
         N'Sách lịch sử thế giới, Việt Nam và văn minh nhân loại.'),
        (N'Công nghệ',
         N'Sách lập trình, phần mềm, máy tính và công nghệ thông tin.'),
        (N'Khoa học',
         N'Sách khoa học tự nhiên, vật lý, sinh học và khám phá.'),
        (N'Kinh tế',
         N'Sách kinh doanh, quản trị, tài chính và kinh tế học.'),
        (N'Tâm lý học',
         N'Sách tâm lý, hành vi con người và sức khỏe tinh thần.'),
        (N'Thiếu nhi',
         N'Truyện và sách giáo dục dành cho trẻ em.')
    ) AS V([Name], [Description])
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Genres AS G
        WHERE G.[Name] = V.[Name]
    );

    IF (
        SELECT COUNT(*)
        FROM dbo.Genres
        WHERE [Name] IN (
            N'Kỹ năng sống', N'Tiểu thuyết', N'Lịch sử',
            N'Công nghệ', N'Khoa học', N'Kinh tế',
            N'Tâm lý học', N'Thiếu nhi'
        )
    ) <> 8
        THROW 50001, 'Genre validation failed.', 1;

    COMMIT TRANSACTION;
    PRINT N'Genres: transaction committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Genres: transaction failed and was rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO


--Authors
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Authors (AuthorName)
    SELECT V.AuthorName
    FROM (VALUES
        (N'Dale Carnegie'),
        (N'Paulo Coelho'),
        (N'Yuval Noah Harari'),
        (N'Robert C. Martin'),
        (N'Nguyễn Nhật Ánh'),
        (N'Nam Cao'),
        (N'Tô Hoài'),
        (N'Nguyễn Du'),
        (N'Nguyễn Hiến Lê'),
        (N'Nguyễn Duy Cần'),
        (N'James Clear'),
        (N'Stephen R. Covey'),
        (N'Daniel Kahneman'),
        (N'Adam Grant'),
        (N'Cal Newport'),
        (N'Robert T. Kiyosaki'),
        (N'Napoleon Hill'),
        (N'George Orwell'),
        (N'J. K. Rowling'),
        (N'Harper Lee'),
        (N'Ernest Hemingway'),
        (N'Fyodor Dostoevsky'),
        (N'Victor Hugo'),
        (N'Antoine de Saint-Exupéry'),
        (N'Jules Verne'),
        (N'Isaac Asimov'),
        (N'Carl Sagan'),
        (N'Stephen Hawking'),
        (N'Charles Darwin'),
        (N'Richard Feynman'),
        (N'Andrew S. Tanenbaum'),
        (N'Brian W. Kernighan'),
        (N'Donald E. Knuth'),
        (N'Martin Fowler'),
        (N'Joshua Bloch'),
        (N'Eric Matthes'),
        (N'Robert C. Seacord'),
        (N'Bjarne Stroustrup'),
        (N'Peter Thiel'),
        (N'Philip Kotler'),
        (N'Peter F. Drucker'),
        (N'Thomas H. Cormen'),
        (N'Jon Duckett'),
        (N'Nguyễn Văn Tuấn')
    ) AS V(AuthorName)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Authors AS A
        WHERE A.AuthorName = V.AuthorName
    );

    IF (
        SELECT COUNT(*)
        FROM dbo.Authors
        WHERE AuthorName IN (
            N'Dale Carnegie', N'Paulo Coelho',
            N'Yuval Noah Harari', N'Robert C. Martin'
        )
    ) <> 4
        THROW 50002, 'Author validation failed.', 1;

    COMMIT TRANSACTION;
    PRINT N'Authors: transaction committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Authors: transaction failed and was rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO


--Publishers
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Publishers (PublisherName, ContactEmail)
    SELECT V.PublisherName, V.ContactEmail
    FROM (VALUES
        (N'NXB Trẻ', N'contact@nxbtre.example.com'),
        (N'NXB Văn Học', N'contact@vanhoc.example.com'),
        (N'NXB Thế Giới', N'contact@thegioi.example.com'),
        (N'NXB Lao Động', N'contact@laodong.example.com'),
        (N'NXB Tổng hợp TP. Hồ Chí Minh',
         N'contact@tonghop.example.com'),
        (N'NXB Tri Thức', N'contact@trithuc.example.com'),
        (N'NXB Kim Đồng', N'contact@kimdong.example.com'),
        (N'NXB Giáo Dục Việt Nam',
         N'contact@nxbgd.example.com'),
        (N'NXB Chính trị quốc gia Sự thật',
         N'contact@chinhtri.example.com'),
        (N'NXB Phụ Nữ Việt Nam',
         N'contact@phunu.example.com'),
        (N'NXB Thanh Niên', N'contact@thanhnien.example.com'),
        (N'NXB Công Thương', N'contact@congthuong.example.com'),
        (N'NXB Bách Khoa Hà Nội',
         N'contact@bachkhoa.example.com'),
        (N'NXB Đại học Quốc gia TP. Hồ Chí Minh',
         N'contact@vnuhcm.example.com'),
        (N'NXB Thông Tin và Truyền Thông',
         N'contact@mic.example.com')
    ) AS V(PublisherName, ContactEmail)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Publishers AS P
        WHERE P.PublisherName = V.PublisherName
    );

    IF (
        SELECT COUNT(*)
        FROM dbo.Publishers
        WHERE PublisherName IN (
            N'NXB Trẻ', N'NXB Văn Học',
            N'NXB Thế Giới', N'NXB Lao Động'
        )
    ) <> 4
        THROW 50003, 'Publisher validation failed.', 1;

    COMMIT TRANSACTION;
    PRINT N'Publishers: transaction committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Publishers: transaction failed and was rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO



USE [OnlineLibrary];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @Books TABLE
    (
        Title NVARCHAR(200) NOT NULL,
        AuthorName NVARCHAR(100) NOT NULL,
        GenreName NVARCHAR(50) NOT NULL,
        PublisherName NVARCHAR(100) NOT NULL,
        ISBN NVARCHAR(13) NOT NULL,
        PublicationYear INT NULL,
        Description NVARCHAR(2000) NULL,
        CoverImageUrl NVARCHAR(1000) NULL,
        TotalCopies INT NOT NULL,
        AvailableCopies INT NOT NULL,
        Status INT NOT NULL
    );

    INSERT INTO @Books
    (
        Title, AuthorName, GenreName, PublisherName, ISBN,
        PublicationYear, Description, CoverImageUrl,
        TotalCopies, AvailableCopies, Status
    )
    VALUES
    -- 1-7: Kỹ năng sống
    (N'Đắc Nhân Tâm', N'Dale Carnegie', N'Kỹ năng sống', N'NXB Trẻ',
     N'9780000000019', 2019,
     N'Sách về nghệ thuật giao tiếp, ứng xử và xây dựng mối quan hệ.',
     N'/Resources/bookcover/dacnhantam.jpg', 3, 3, 0),

    (N'Đời Thay Đổi Khi Chúng Ta Thay Đổi', N'Nguyễn Hiến Lê',
     N'Kỹ năng sống', N'NXB Tổng hợp TP. Hồ Chí Minh',
     N'9780000000057', 2018,
     N'Sách về tư duy tích cực và hoàn thiện bản thân.',
     NULL, 3, 2, 0),

    (N'7 Thói Quen Hiệu Quả', N'Stephen R. Covey',
     N'Kỹ năng sống', N'NXB Trẻ', N'9780000000064', 2020,
     N'Các nguyên tắc quản lý bản thân và nâng cao hiệu quả.',
     NULL, 1, 0, 1),

    (N'Atomic Habits', N'James Clear', N'Kỹ năng sống',
     N'NXB Thế Giới', N'9780000000071', 2022,
     N'Phương pháp xây dựng thói quen tốt bằng những thay đổi nhỏ.',
     NULL, 4, 4, 0),

    (N'Đắc Nhân Tâm Trong Giao Tiếp', N'Dale Carnegie',
     N'Kỹ năng sống', N'NXB Thanh Niên', N'9780000000088', 2021,
     N'Sách tham khảo về giao tiếp và ứng xử trong đời sống.',
     NULL, 0, 0, 2),

    (N'Tư Duy Nhanh Và Chậm', N'Daniel Kahneman',
     N'Kỹ năng sống', N'NXB Thế Giới', N'9780000000095', 2020,
     N'Khám phá hai hệ thống tư duy và những sai lệch trong phán đoán.',
     NULL, 2, 1, 0),

    (N'Khéo Ăn Nói Sẽ Có Được Thiên Hạ', N'Nguyễn Duy Cần',
     N'Kỹ năng sống', N'NXB Phụ Nữ Việt Nam', N'9780000000101', 2019,
     N'Sách tham khảo về giao tiếp và ứng xử xã hội.',
     NULL, 3, 2, 0),

    -- 8-15: Tiểu thuyết
    (N'Nhà Giả Kim', N'Paulo Coelho', N'Tiểu thuyết',
     N'NXB Văn Học', N'9780000000026', 2020,
     N'Tiểu thuyết kể về hành trình theo đuổi ước mơ và khám phá bản thân.',
     N'/Resources/bookcover/nhagiakim.jpg', 1, 0, 1),

    (N'Mắt Biếc', N'Nguyễn Nhật Ánh', N'Tiểu thuyết',
     N'NXB Trẻ', N'9780000000118', 2019,
     N'Tiểu thuyết về tình yêu, tuổi trẻ và ký ức.',
     NULL, 3, 3, 0),

    (N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', N'Nguyễn Nhật Ánh',
     N'Tiểu thuyết', N'NXB Trẻ', N'9780000000125', 2018,
     N'Câu chuyện tuổi thơ ở một vùng quê Việt Nam.',
     NULL, 1, 0, 1),

    (N'1984', N'George Orwell', N'Tiểu thuyết',
     N'NXB Văn Học', N'9780000000132', 2020,
     N'Tiểu thuyết phản địa đàng về quyền lực và sự kiểm soát.',
     NULL, 3, 2, 0),

    (N'Harry Potter Và Hòn Đá Phù Thủy', N'J. K. Rowling',
     N'Tiểu thuyết', N'NXB Trẻ', N'9780000000149', 2021,
     N'Cuốn đầu tiên trong loạt truyện giả tưởng Harry Potter.',
     NULL, 4, 4, 0),

    (N'Giết Con Chim Nhại', N'Harper Lee', N'Tiểu thuyết',
     N'NXB Văn Học', N'9780000000156', 2019,
     N'Tiểu thuyết về công lý, lòng trắc ẩn và định kiến xã hội.',
     NULL, 1, 0, 1),

    (N'Ông Già Và Biển Cả', N'Ernest Hemingway', N'Tiểu thuyết',
     N'NXB Văn Học', N'9780000000163', 2018,
     N'Tác phẩm về ý chí và cuộc đấu tranh của con người.',
     NULL, 3, 2, 0),

    (N'Những Người Khốn Khổ', N'Victor Hugo', N'Tiểu thuyết',
     N'NXB Văn Học', N'9780000000170', 2020,
     N'Tác phẩm kinh điển về xã hội, lòng nhân đạo và sự chuộc lỗi.',
     NULL, 0, 0, 2),

    -- 16-22: Lịch sử
    (N'Sapiens - Lược sử loài người', N'Yuval Noah Harari',
     N'Lịch sử', N'NXB Thế Giới', N'9780000000033', 2018,
     N'Tổng quan lịch sử phát triển của loài người.',
     N'/Resources/bookcover/sapiens.jpg', 3, 2, 0),

    (N'Lược Sử Thời Gian', N'Stephen Hawking', N'Lịch sử',
     N'NXB Thế Giới', N'9780000000187', 2019,
     N'Giới thiệu các khái niệm cơ bản về vũ trụ học.',
     NULL, 2, 1, 0),

    (N'Homo Deus: Lược Sử Tương Lai', N'Yuval Noah Harari',
     N'Lịch sử', N'NXB Thế Giới', N'9780000000194', 2020,
     N'Khảo sát các viễn cảnh tương lai của nhân loại.',
     NULL, 1, 0, 1),

    (N'Đại Việt Sử Ký Toàn Thư', N'Nguyễn Du', N'Lịch sử',
     N'NXB Chính trị quốc gia Sự thật', N'9780000000200', 2018,
     N'Tác phẩm sử học kinh điển về lịch sử Việt Nam.',
     NULL, 3, 2, 0),

    (N'Súng, Vi Trùng Và Thép', N'Yuval Noah Harari',
     N'Lịch sử', N'NXB Thế Giới', N'9780000000217', 2021,
     N'Sách tìm hiểu những yếu tố ảnh hưởng đến lịch sử nhân loại.',
     NULL, 3, 3, 0),

    (N'Lịch Sử Thế Giới', N'Nguyễn Văn Tuấn', N'Lịch sử',
     N'NXB Giáo Dục Việt Nam', N'9780000000224', 2019,
     N'Sách tham khảo tổng quan về lịch sử thế giới.',
     NULL, 0, 0, 2),

    (N'Đường Xưa Mây Trắng', N'Tô Hoài', N'Lịch sử',
     N'NXB Trẻ', N'9780000000231', 2020,
     N'Sách văn học và lịch sử dành cho bạn đọc phổ thông.',
     NULL, 2, 1, 0),

    -- 23-31: Công nghệ
    (N'Clean Code', N'Robert C. Martin', N'Công nghệ',
     N'NXB Lao Động', N'9780000000040', 2021,
     N'Sách về nguyên tắc viết mã nguồn rõ ràng và dễ bảo trì.',
     N'/Resources/bookcover/cleancode.jpg', 2, 1, 0),

    (N'The Clean Coder', N'Robert C. Martin', N'Công nghệ',
     N'NXB Lao Động', N'9780000000248', 2022,
     N'Bàn về tính chuyên nghiệp trong nghề phát triển phần mềm.',
     NULL, 3, 2, 0),

    (N'Code Complete', N'Martin Fowler', N'Công nghệ',
     N'NXB Bách Khoa Hà Nội', N'9780000000255', 2021,
     N'Tài liệu về thực hành xây dựng phần mềm.',
     NULL, 1, 0, 1),

    (N'The Pragmatic Programmer', N'Martin Fowler', N'Công nghệ',
     N'NXB Bách Khoa Hà Nội', N'9780000000262', 2020,
     N'Kinh nghiệm và phương pháp làm việc của lập trình viên.',
     NULL, 3, 3, 0),

    (N'Introduction to Algorithms', N'Thomas H. Cormen',
     N'Công nghệ', N'NXB Bách Khoa Hà Nội', N'9780000000279', 2022,
     N'Tài liệu tham khảo về thuật toán và cấu trúc dữ liệu.',
     NULL, 1, 0, 1),

    (N'Python Crash Course', N'Eric Matthes', N'Công nghệ',
     N'NXB Thông Tin và Truyền Thông', N'9780000000286', 2023,
     N'Sách thực hành nhập môn lập trình Python.',
     NULL, 3, 2, 0),

    (N'Effective Java', N'Joshua Bloch', N'Công nghệ',
     N'NXB Bách Khoa Hà Nội', N'9780000000293', 2021,
     N'Các thực hành tốt khi phát triển ứng dụng Java.',
     NULL, 2, 1, 0),

    (N'Computer Networking', N'Andrew S. Tanenbaum', N'Công nghệ',
     N'NXB Đại học Quốc gia TP. Hồ Chí Minh', N'9780000000309', 2020,
     N'Kiến thức về mạng máy tính và các giao thức truyền thông.',
     NULL, 0, 0, 2),

    (N'The C Programming Language', N'Brian W. Kernighan',
     N'Công nghệ', N'NXB Bách Khoa Hà Nội', N'9780000000316', 2019,
     N'Tài liệu kinh điển về ngôn ngữ lập trình C.',
     NULL, 4, 4, 0),

    -- 32-36: Khoa học
    (N'Vũ Trụ Trong Vỏ Hạt Dẻ', N'Stephen Hawking',
     N'Khoa học', N'NXB Thế Giới', N'9780000000323', 2019,
     N'Giải thích các ý tưởng vật lý hiện đại cho độc giả phổ thông.',
     NULL, 3, 2, 0),

    (N'Cosmos', N'Carl Sagan', N'Khoa học',
     N'NXB Thế Giới', N'9780000000330', 2020,
     N'Khám phá vũ trụ, khoa học và vị trí của con người.',
     NULL, 1, 0, 1),

    (N'Nguồn Gốc Các Loài', N'Charles Darwin', N'Khoa học',
     N'NXB Tri Thức', N'9780000000347', 2018,
     N'Tác phẩm nền tảng về thuyết tiến hóa bằng chọn lọc tự nhiên.',
     NULL, 2, 1, 0),

    (N'Chắc Chắn Bạn Đang Đùa, Ngài Feynman!', N'Richard Feynman',
     N'Khoa học', N'NXB Trẻ', N'9780000000354', 2021,
     N'Những câu chuyện về khoa học, tò mò và tư duy phản biện.',
     NULL, 1, 0, 1),

    (N'Vật Lý Đại Cương', N'Richard Feynman', N'Khoa học',
     N'NXB Giáo Dục Việt Nam', N'9780000000361', 2019,
     N'Sách tham khảo các khái niệm vật lý cơ bản.',
     NULL, 0, 0, 3),

    -- 37-41: Kinh tế
    (N'Dạy Con Làm Giàu', N'Robert T. Kiyosaki', N'Kinh tế',
     N'NXB Trẻ', N'9780000000378', 2020,
     N'Sách phổ thông về tư duy tài chính cá nhân.',
     NULL, 3, 3, 0),

    (N'Nghĩ Giàu Và Làm Giàu', N'Napoleon Hill', N'Kinh tế',
     N'NXB Tổng hợp TP. Hồ Chí Minh', N'9780000000385', 2019,
     N'Sách về mục tiêu, động lực và tư duy thành công.',
     NULL, 1, 0, 1),

    (N'Zero to One', N'Peter Thiel', N'Kinh tế',
     N'NXB Thế Giới', N'9780000000392', 2021,
     N'Bàn về khởi nghiệp và phát triển những ý tưởng mới.',
     NULL, 2, 2, 0),

    (N'Principles of Marketing', N'Philip Kotler', N'Kinh tế',
     N'NXB Công Thương', N'9780000000408', 2022,
     N'Kiến thức nền tảng về marketing và thị trường.',
     NULL, 2, 1, 0),

    (N'Tinh Thần Doanh Nhân Khởi Nghiệp', N'Peter F. Drucker',
     N'Kinh tế', N'NXB Công Thương', N'9780000000415', 2020,
     N'Tài liệu tham khảo về quản trị và đổi mới trong kinh doanh.',
     NULL, 0, 0, 2),

    -- 42-46: Tâm lý học
    (N'Đi Tìm Lẽ Sống', N'Victor Hugo', N'Tâm lý học',
     N'NXB Trẻ', N'9780000000422', 2019,
     N'Sách đọc thêm về ý nghĩa cuộc sống và nghị lực con người.',
     NULL, 2, 2, 0),

    (N'Give and Take', N'Adam Grant', N'Tâm lý học',
     N'NXB Thế Giới', N'9780000000439', 2021,
     N'Khảo sát cách cho đi và nhận lại ảnh hưởng đến thành công.',
     NULL, 1, 0, 1),

    (N'So Good They Can’t Ignore You', N'Cal Newport',
     N'Tâm lý học', N'NXB Lao Động', N'9780000000446', 2022,
     N'Sách về phát triển kỹ năng và xây dựng sự nghiệp.',
     NULL, 2, 1, 0),

    (N'Tư Duy Phản Biện', N'Nguyễn Duy Cần', N'Tâm lý học',
     N'NXB Tri Thức', N'9780000000453', 2020,
     N'Sách tham khảo về suy luận và đánh giá thông tin.',
     NULL, 0, 0, 2),

    (N'Tâm Lý Học Đám Đông', N'Nguyễn Hiến Lê', N'Tâm lý học',
     N'NXB Tổng hợp TP. Hồ Chí Minh', N'9780000000460', 2018,
     N'Sách tham khảo về hành vi cá nhân trong đám đông.',
     NULL, 2, 1, 0),

    -- 47-50: Thiếu nhi
    (N'Dế Mèn Phiêu Lưu Ký', N'Tô Hoài', N'Thiếu nhi',
     N'NXB Kim Đồng', N'9780000000477', 2020,
     N'Tác phẩm thiếu nhi kinh điển của văn học Việt Nam.',
     NULL, 4, 4, 0),

    (N'Hoàng Tử Bé', N'Antoine de Saint-Exupéry', N'Thiếu nhi',
     N'NXB Kim Đồng', N'9780000000484', 2021,
     N'Tác phẩm giàu tính tưởng tượng về tình bạn và cuộc sống.',
     NULL, 1, 0, 1),

    (N'Hai Vạn Dặm Dưới Biển', N'Jules Verne', N'Thiếu nhi',
     N'NXB Kim Đồng', N'9780000000491', 2019,
     N'Tiểu thuyết phiêu lưu khoa học dành cho độc giả trẻ.',
     NULL, 2, 2, 0),

    (N'Những Cuộc Phiêu Lưu Của Tom Sawyer', N'Ernest Hemingway',
     N'Thiếu nhi', N'NXB Kim Đồng', N'9780000000507', 2018,
     N'Tác phẩm phiêu lưu dành cho độc giả trẻ.',
     NULL, 0, 0, 3);

    -- Validate lookup prerequisites and seed values.
    IF EXISTS
    (
        SELECT 1
        FROM @Books B
        LEFT JOIN dbo.Authors A ON A.AuthorName = B.AuthorName
        LEFT JOIN dbo.Genres G ON G.[Name] = B.GenreName
        LEFT JOIN dbo.Publishers P ON P.PublisherName = B.PublisherName
        WHERE A.AuthorID IS NULL
           OR G.GenreID IS NULL
           OR P.PublisherID IS NULL
    )
    BEGIN
        ;THROW 50010,
            'Missing author, genre, or publisher. Seed prerequisite tables first.',
            1;
    END;

    IF (SELECT COUNT(*) FROM @Books) <> 50
    BEGIN
        ;THROW 50011, 'The Books seed must contain exactly 50 rows.', 1;
    END;

    IF EXISTS
    (
        SELECT ISBN
        FROM @Books
        GROUP BY ISBN
        HAVING COUNT(*) > 1
    )
    BEGIN
        ;THROW 50012, 'Duplicate ISBNs found in the seed data.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM @Books
        WHERE LEN(ISBN) <> 13
           OR TotalCopies < 0
           OR AvailableCopies < 0
           OR AvailableCopies > TotalCopies
           OR Status NOT IN (0, 1, 2, 3)
    )
    BEGIN
        ;THROW 50013, 'Invalid ISBN, inventory, or book status.', 1;
    END;

    -- Fresh seed: refuse to mix these rows with an existing Books table.
    IF EXISTS (SELECT 1 FROM dbo.Books)
    BEGIN
        ;THROW 50014,
            'Books table is not empty. Use a fresh database or clear dependent records first.',
            1;
    END;

    INSERT INTO dbo.Books
    (
        Title, AuthorId, GenreId, PublisherId, ISBN,
        PublicationYear, Description, CoverImageUrl,
        TotalCopies, AvailableCopies, Status, CreatedAt
    )
    SELECT
        B.Title, A.AuthorID, G.GenreID, P.PublisherID, B.ISBN,
        B.PublicationYear, B.Description, B.CoverImageUrl,
        B.TotalCopies, B.AvailableCopies, B.Status, GETDATE()
    FROM @Books B
    INNER JOIN dbo.Authors A ON A.AuthorName = B.AuthorName
    INNER JOIN dbo.Genres G ON G.[Name] = B.GenreName
    INNER JOIN dbo.Publishers P ON P.PublisherName = B.PublisherName;

    IF @@ROWCOUNT <> 50
    BEGIN
        ;THROW 50015, 'Expected to insert exactly 50 books.', 1;
    END;

    -- Confirm that the adjusted inventory contains exactly 30 unavailable copies.
    IF
    (
        SELECT SUM(TotalCopies - AvailableCopies)
        FROM dbo.Books
    ) <> 30
    BEGIN
        ;THROW 50016, 'Adjusted inventory must contain 30 unavailable copies.', 1;
    END;

    COMMIT TRANSACTION;
    PRINT N'Books seed committed: 50 books, 30 unavailable copies.';

    SELECT
        BookID, Title, AuthorId, GenreId, PublisherId, ISBN,
        TotalCopies, AvailableCopies, Status, CoverImageUrl
    FROM dbo.Books
    ORDER BY BookID;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'Books seed failed and was rolled back.';
    THROW;
END CATCH;
GO