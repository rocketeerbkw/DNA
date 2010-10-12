USE [master]
PRINT 'EDIT VALUES BEFORE RUNNING'
RETURN

GO
/****** Object:  Database [DNASearch]    Script Date: 10/04/2010 12:05:37 ******/
CREATE DATABASE [DNASearch] ON  PRIMARY 
( NAME = N'PrimaryFileName', FILENAME = N'D:\SQLServer\Data\DNASearch.mdf' , SIZE = 6369472KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PrimaryLogFileName', FILENAME = N'D:\SQLServer\Data\DNASearch_log.ldf' , SIZE = 1964480KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'DNASearch', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DNASearch].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DNASearch] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [DNASearch] SET ANSI_NULLS ON 
GO
ALTER DATABASE [DNASearch] SET ANSI_PADDING ON 
GO
ALTER DATABASE [DNASearch] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [DNASearch] SET ARITHABORT ON 
GO
ALTER DATABASE [DNASearch] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DNASearch] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DNASearch] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DNASearch] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DNASearch] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DNASearch] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [DNASearch] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [DNASearch] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DNASearch] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [DNASearch] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DNASearch] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DNASearch] SET AUTO_UPDATE_STATISTICS_ASYNC ON 
GO
ALTER DATABASE [DNASearch] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DNASearch] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DNASearch] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DNASearch] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DNASearch] SET  READ_WRITE 
GO
ALTER DATABASE [DNASearch] SET RECOVERY FULL 
GO
ALTER DATABASE [DNASearch] SET  MULTI_USER 
GO
ALTER DATABASE [DNASearch] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [DNASearch] SET DB_CHAINING OFF 
GO
EXEC [DNASearch].sys.sp_addextendedproperty @name=N'microsoft_database_tools_deploystamp', @value=N'b649beb8-11cf-42b4-b5e2-be33324935a9' 
GO
USE DNASEARCH
CREATE FULLTEXT CATALOG [SearchThreadEntriesCat] WITH ACCENT_SENSITIVITY = OFF;
GO
CREATE ROLE [ripleyrole] AUTHORIZATION [dbo]
GO
CREATE USER [ripley] FOR LOGIN [ripley] WITH DEFAULT_SCHEMA=[dbo]
GO
EXEC sp_addrolemember N'ripleyrole', N'ripley'
GO

