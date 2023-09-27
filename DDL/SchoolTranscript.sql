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
    StudentId   int             NOT NULL,
    GivenName   varchar(50)     NOT NULL,
    Surname     varchar(50)     NOT NULL,
    DateOfBirth datetime        NOT NULL,
    Enrolled    bit             NOT NULL
)

CREATE TABLE Courses
(
    [Number]    varchar(10)     NOT NULL,
    [Name]      varchar(50)     NOT NULL,
    [Credits]   decimal(3,1)    NOT NULL,
    [Hours]     tinyint         NOT NULL,
    [Active]    bit             NOT NULL,
    [Cost]      money           NOT NULL
)

CREATE TABLE StudentCourses
(
    StudentId       int         NOT NULL,
    CourseNumber    varchar(10) NOT NULL,
    [Year]          smallint    NOT NULL,
    Term            char(3)     NOT NULL,
    FinalMark       tinyint         NULL,
    [Status]        char(1)     NOT NULL
)
