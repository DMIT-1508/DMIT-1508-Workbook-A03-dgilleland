/* **********************************************
 * Simple Table Creation - Columns and Primary Keys
 *
 * School Transcript
 *  Version 1.0.0
 *
 * Author: Dan Gilleland
 ********************************************** */
-- Create the database
-- Note: The "context" for the following code is the "master" database (if no other database was identified in the connection profile).
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'SchoolTranscript')
BEGIN
    CREATE DATABASE [SchoolTranscript]
END
GO
-- USE master
-- DROP DATABASE [SchoolTranscript]


-- Switch execution context to the database
USE [SchoolTranscript] -- remaining SQL statements will run against the SchoolTranscript database
GO

-- Create Tables...
DROP TABLE IF EXISTS StudentCourses
DROP TABLE IF EXISTS Courses
DROP TABLE IF EXISTS Students

CREATE TABLE Students
(
    -- Here, I define all my columns
    -- as a comma-separated list of
    -- column definitions
    StudentId   int
        CONSTRAINT PK_Students_StudentID
            PRIMARY KEY
            IDENTITY (20250001, 3)
                                NOT NULL,
    GivenName   varchar(50)
        CONSTRAINT CK_Students_GivenName
            CHECK (LEN(GivenName) >= 2) -- Using the LEN() function, I can
                                        -- get the number of characters
                                NOT NULL,
    Surname     varchar(50)     NOT NULL,
    DateOfBirth datetime
        CONSTRAINT CK_Students_DateOfBirth
            CHECK (DateOfBirth < GETDATE()) -- GETDATE() returns the current
                                            -- date and time
                                NOT NULL,
    Enrolled    bit             NOT NULL
)

CREATE TABLE Courses
(
    [Number]    varchar(10)
        CONSTRAINT PK_Courses_Number
            PRIMARY KEY
        CONSTRAINT CK_Courses_Number
            CHECK ([Number] LIKE '[a-z][a-z][a-z][a-z][- ][1-9][0-9][0-9][0-9]%')
            -- The following course numbers would be accepted
            --   'DMIT-1508', 'CPSC 1012', 'PROG-1255B'
                                NOT NULL,
    [Name]      varchar(50)     NOT NULL,
    [Credits]   decimal(3,1)
        CONSTRAINT CK_Courses_Credits
            CHECK (Credits = 3.0 OR Credits = 4.5 OR Credits = 6.0)
            --    (Credits IN (3, 4.5, 6))
                                NOT NULL,
    [Hours]     tinyint
        CONSTRAINT CK_Courses_Hours
            CHECK ([Hours] IN (60, 75, 90, 120))
                                NOT NULL,
    [Active]    bit
        CONSTRAINT DF_Courses_Active
            DEFAULT (1) -- 1 is the equivalent of TRUE
                                NOT NULL,
    [Cost]      money
        CONSTRAINT CK_Courses_Cost
            CHECK (Cost >= 0)
                                NOT NULL
)

CREATE TABLE StudentCourses
(
    StudentId       int
        CONSTRAINT FK_StudentCourses_Students
            FOREIGN KEY REFERENCES Students(StudentId)
                                NOT NULL,
    CourseNumber    varchar(10)
        CONSTRAINT FK_StudentCourses_Courses
            FOREIGN KEY REFERENCES Courses([Number])
                                NOT NULL,
    [Year]          smallint
        CONSTRAINT CK_StudentCourses_Year
            CHECK ([Year] BETWEEN 2000 AND 2299)
                                NOT NULL,
    Term            char(3)
        CONSTRAINT CK_StudentCourses_Term
            CHECK (Term IN ('SEP', 'JAN', 'MAY'))
                                NOT NULL,
    FinalMark       tinyint         NULL,
    [Status]        char(1)     NOT NULL,
    -- Table-level constraints are where we identify
    -- any constraints that involve TWO or MORE columns
    CONSTRAINT PK_StudentCourses_StudentId_CourseNumber
        PRIMARY KEY (StudentId, CourseNumber)
)



-- Practice for ALTER TABLE and CREATE INDEX statements

-- Add a column to the Students table for the student's Email. Make it up to 80 characters long.
ALTER TABLE Students
    ADD Email varchar(80) NULL

-- As a separate ALTER TABLE statements, add a CHECK constraint to make sure the email is "valid"
-- by expecting it to have the '@' symbol somewhere in the email.
ALTER TABLE Students
    ADD CONSTRAINT CK_Students_Email
        CHECK (Email LIKE '%@%')

-- Add a column to the StudentCourses table called 'Paid'; make it a bit data type.
ALTER TABLE StudentCourses
    ADD Paid bit NULL
-- In a separate ALTER TABLE statement, add a default for the 'Paid' column to be '0'.
ALTER TABLE StudentCourses
    ADD CONSTRAINT DF_StudentCourses_Paid
        DEFAULT (0) FOR Paid
-- Lastly, add non-clustered indexes for all the foreign keys in the database.
CREATE NONCLUSTERED INDEX IX_StudentCourses_Students
    ON StudentCourses (StudentId)
CREATE NONCLUSTERED INDEX IX_StudentCourses_Courses
    ON StudentCourses (CourseNumber)
-- Note: I could have added the indexes when I created the tables, but I wanted to show you how to add them after the fact.
GO
