USE [master]
GO
/****** Object:  Database [Insaat]    Script Date: 28.02.2022 04:41:03 ******/
CREATE DATABASE [Insaat]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Insaat', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Insaat.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Insaat_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Insaat_log.ldf' , SIZE = 3840KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Insaat].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Insaat] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Insaat] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Insaat] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Insaat] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Insaat] SET ARITHABORT OFF 
GO
ALTER DATABASE [Insaat] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Insaat] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Insaat] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Insaat] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Insaat] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Insaat] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Insaat] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Insaat] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Insaat] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Insaat] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Insaat] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Insaat] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Insaat] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Insaat] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Insaat] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Insaat] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Insaat] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Insaat] SET RECOVERY FULL 
GO
ALTER DATABASE [Insaat] SET  MULTI_USER 
GO
ALTER DATABASE [Insaat] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Insaat] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Insaat] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Insaat] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Insaat] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Insaat', N'ON'
GO
USE [Insaat]
GO
/****** Object:  User [StajyerAksam1]    Script Date: 28.02.2022 04:41:03 ******/
CREATE USER [StajyerAksam1] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [devuser]    Script Date: 28.02.2022 04:41:03 ******/
CREATE USER [devuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CompanyOwner]    Script Date: 28.02.2022 04:41:03 ******/
CREATE USER [CompanyOwner] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Stajyerler]    Script Date: 28.02.2022 04:41:03 ******/
CREATE ROLE [Stajyerler]
GO
ALTER ROLE [Stajyerler] ADD MEMBER [StajyerAksam1]
GO
ALTER ROLE [db_datareader] ADD MEMBER [devuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [devuser]
GO
ALTER ROLE [db_owner] ADD MEMBER [CompanyOwner]
GO
/****** Object:  UserDefinedFunction [dbo].[AuthenticateUser]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AuthenticateUser](@Username varchar(50), @Password varchar(50))
RETURNS tinyint

as
BEGIN
	
	DECLARE @isSuccess tinyint
	DECLARE @chr char(1) = char(39) -- özel karakter, ' karakterini temsil ediyor

	IF @Password LIKE '%' + @chr + '%'
	-- INJECTION VARSA DIREKT HATAYA DUSUR
	BEGIN
		SET @isSuccess = 1

	END
	ELSE
	-- INJECTION YOKSA SIFREYI KONTROL ET
	BEGIN
		IF EXISTS	-- asagıdaki user / pass varsa cevap olumlu yani 1
		(SELECT EmployeeID
		FROM Employee WHERE Username = @Username AND Password = @Password
		)
			BEGIN
				SET @isSuccess = 1
			END
		ELSE	-- exists değilse cevap 0
			BEGIN
				SET @isSuccess = 0
			END
	END
	RETURN @isSuccess
END
GO
/****** Object:  UserDefinedFunction [dbo].[SatinAlmaAdedi]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[SatinAlmaAdedi](@CustomerID int)
RETURNS int

AS

BEGIN
	DECLARE @TotalSales as integer
	SET @TotalSales = 0

	SELECT @TotalSales = COUNT(*)
	FROM Sales
	WHERE CustomerID = @CustomerID

	RETURN @TotalSales
END
GO
/****** Object:  Table [dbo].[City]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](50) NULL,
	[CustomerSurname] [varchar](50) NULL,
	[GSM] [varchar](50) NULL,
	[BirthDate] [date] NULL,
	[TC] [char](11) NULL,
	[EMail] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[GenderID] [int] NULL,
	[CityID] [int] NULL,
	[CustomerNo] [varchar](50) NULL,
	[IncomeTypeID] [int] NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerRequest]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerRequest](
	[CustomerRequestID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[FlatTypeID] [int] NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_CustomerRequest] PRIMARY KEY CLUSTERED 
(
	[CustomerRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeName] [varchar](50) NULL,
	[EmployeeSurname] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Flat]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Flat](
	[FlatID] [int] IDENTITY(1,1) NOT NULL,
	[FlatNo] [varchar](50) NULL,
	[ProjectID] [int] NULL,
	[FlatTypeID] [int] NULL,
	[FlatStatusID] [int] NULL,
	[Price] [money] NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_ProjectID] PRIMARY KEY CLUSTERED 
(
	[FlatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlatStatus]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlatStatus](
	[FlatStatusID] [int] IDENTITY(1,1) NOT NULL,
	[FlatStatusName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_FlatStatus] PRIMARY KEY CLUSTERED 
(
	[FlatStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlatType]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlatType](
	[FlatTypeID] [int] NOT NULL,
	[FlatTypeName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_FlatType] PRIMARY KEY CLUSTERED 
(
	[FlatTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gender](
	[GenderID] [int] IDENTITY(1,1) NOT NULL,
	[GenderName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED 
(
	[GenderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncomeType]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomeType](
	[IncomeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[IncomeTypeName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_IncomeType] PRIMARY KEY CLUSTERED 
(
	[IncomeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Project]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](50) NULL,
	[CityID] [int] NULL,
	[ProjectStatusID] [int] NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectStatus]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectStatus](
	[ProjectStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectStatusName] [varchar](50) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_ProjectStatus] PRIMARY KEY CLUSTERED 
(
	[ProjectStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sales]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales](
	[SaleID] [int] IDENTITY(1,1) NOT NULL,
	[SaleDate] [datetime] NULL,
	[CustomerID] [int] NULL,
	[FlatID] [int] NULL,
	[Price] [money] NULL,
	[EmployeeID] [int] NULL,
	[Notes] [varchar](500) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[SaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[EMail] [varchar](50) NULL,
	[Password] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Visit]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Visit](
	[VisitID] [int] IDENTITY(1,1) NOT NULL,
	[VisitDate] [datetime] NULL,
	[CustomerID] [int] NULL,
	[ProjectID] [int] NULL,
	[Notes] [varchar](500) NULL,
	[CreationDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Visit] PRIMARY KEY CLUSTERED 
(
	[VisitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[DaireListesi]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DaireListesi](@ProjectID int, @FlatStatusID int)
RETURNS TABLE 

AS 

	RETURN 
		SELECT Flat.FlatNo, FlatType.FlatTypeName  
		FROM Flat
		LEFT JOIN FlatType ON FlatType.FlatTypeID = Flat.FlatTypeID
		WHERE ProjectID = @ProjectID AND FlatStatusID = @FlatStatusID
GO
SET IDENTITY_INSERT [dbo].[City] ON 

INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (1, N'İstanbul', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (2, N'Ankara', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (3, N'İzmir', CAST(N'2022-02-15' AS Date), CAST(N'2022-02-18' AS Date))
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (4, N'Antalya', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (6, N'Aydın', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (7, N'Manisa', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[City] ([CityID], [CityName], [CreationDate], [UpdateDate]) VALUES (25, N'Muğla', CAST(N'2022-02-18' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[City] OFF
GO
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (1, N'Onur', N'Kulabaş', N'5325412563', CAST(N'1990-12-21' AS Date), N'02492839410', N'onurkulabas@yahoo.com', N'Maltepe', 2, 1, N'111', 1, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (2, N'Güney', N'Eroğlu', N'5326691731', CAST(N'1995-10-17' AS Date), N'20914041546', N'guney@gmail.com', N'Ataşehir', 2, 2, N'31', 1, CAST(N'2022-02-15' AS Date), CAST(N'2022-02-20' AS Date))
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (3, N'Gülçin', N'Pehlivan', N'5451237485', CAST(N'1993-05-05' AS Date), N'39414765128', N'gulcin@hotmail.com', N'Kadıköy', 1, 3, N'162', 2, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (4, N'Esin', N'Kaplan', N'5451237235', CAST(N'1998-07-12' AS Date), N'20224335720', N'esin@hotmail.com', N'Beşiktaş', 1, 2, N'141', 3, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (5, N'Zeycan', N'Gürer', N'5331328412', CAST(N'1995-01-30' AS Date), N'29224344124', N'zeycangrr@yahoo.com', N'Beşiktaş', 1, 4, N'151', 4, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (7, N'Kaan', N'Gümüşdağ', N'5311327016', CAST(N'1996-04-24' AS Date), N'38245672148', N'kaangms@yahoo.com', N'Koşuyolu', 2, 3, N'160', 2, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (10, N'Alican', N'Yavaş', N'5321447124', CAST(N'1995-12-28' AS Date), N'28244674122', N'alcn@gmail.com', N'Koşuyolu', 2, 1, N'165', 2, CAST(N'2022-02-15' AS Date), CAST(N'2022-02-19' AS Date))
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerSurname], [GSM], [BirthDate], [TC], [EMail], [Address], [GenderID], [CityID], [CustomerNo], [IncomeTypeID], [CreationDate], [UpdateDate]) VALUES (11, N'Can', N'Beyazıt', N'5313316769', CAST(N'1993-05-03' AS Date), N'1234567494 ', N'can@can.com', N'Orduevi', 2, 1, N'199456', 1, CAST(N'2022-02-19' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (1, N'Gülçin', N'Pehlivan', N'gulcin', N'1234', CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (2, N'Güney', N'Eroğlu', N'guneyeroglu', N'1234', CAST(N'2022-02-15T00:00:00.000' AS DateTime), CAST(N'2022-02-19T14:39:12.770' AS DateTime))
INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (11, N'Onur', N'Kulabaş', N'onuronur', N'1234', CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (12, N'Can', N'Beyazıt', N'canbeyaz', N'1234', CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (13, N'Kaan', N'Gümüşdağ', N'kaangmsdg', N'1234', CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Employee] ([EmployeeID], [EmployeeName], [EmployeeSurname], [Username], [Password], [CreationDate], [UpdateDate]) VALUES (14, N'Alican', N'Aksakal', N'aaksakal', N'1234', CAST(N'2022-02-19T13:38:42.870' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
SET IDENTITY_INSERT [dbo].[Flat] ON 

INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (1, N'101', 1, 2, 2, 100000.0000, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (2, N'102', 1, 2, 2, 110000.0000, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (3, N'103', 1, 4, 2, 400000.0000, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (4, N'104', 3, 1, 2, 123456.0000, CAST(N'2022-02-15' AS Date), CAST(N'2022-02-19' AS Date))
INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (5, N'105', 3, 3, 2, 700000.0000, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Flat] ([FlatID], [FlatNo], [ProjectID], [FlatTypeID], [FlatStatusID], [Price], [CreationDate], [UpdateDate]) VALUES (6, N'106', 1, 2, 2, 150000.0000, CAST(N'2022-02-19' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Flat] OFF
GO
SET IDENTITY_INSERT [dbo].[FlatStatus] ON 

INSERT [dbo].[FlatStatus] ([FlatStatusID], [FlatStatusName], [CreationDate], [UpdateDate]) VALUES (1, N'Uygun', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[FlatStatus] ([FlatStatusID], [FlatStatusName], [CreationDate], [UpdateDate]) VALUES (2, N'Satıldı', CAST(N'2022-02-15' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[FlatStatus] OFF
GO
INSERT [dbo].[FlatType] ([FlatTypeID], [FlatTypeName], [CreationDate], [UpdateDate]) VALUES (1, N'1+0', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[FlatType] ([FlatTypeID], [FlatTypeName], [CreationDate], [UpdateDate]) VALUES (2, N'1+1', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[FlatType] ([FlatTypeID], [FlatTypeName], [CreationDate], [UpdateDate]) VALUES (3, N'2+1', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[FlatType] ([FlatTypeID], [FlatTypeName], [CreationDate], [UpdateDate]) VALUES (4, N'3+1', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[FlatType] ([FlatTypeID], [FlatTypeName], [CreationDate], [UpdateDate]) VALUES (5, N'4+1', CAST(N'2022-02-18' AS Date), CAST(N'2022-02-18' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Gender] ON 

INSERT [dbo].[Gender] ([GenderID], [GenderName], [CreationDate], [UpdateDate]) VALUES (1, N'Kadın', CAST(N'2022-02-15' AS Date), CAST(N'2022-02-18' AS Date))
INSERT [dbo].[Gender] ([GenderID], [GenderName], [CreationDate], [UpdateDate]) VALUES (2, N'Erkek', CAST(N'2022-02-15' AS Date), CAST(N'2022-02-18' AS Date))
INSERT [dbo].[Gender] ([GenderID], [GenderName], [CreationDate], [UpdateDate]) VALUES (8, N'Belirtmek İstemiyorum', CAST(N'2022-02-26' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Gender] OFF
GO
SET IDENTITY_INSERT [dbo].[IncomeType] ON 

INSERT [dbo].[IncomeType] ([IncomeTypeID], [IncomeTypeName], [CreationDate], [UpdateDate]) VALUES (1, N'A', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[IncomeType] ([IncomeTypeID], [IncomeTypeName], [CreationDate], [UpdateDate]) VALUES (2, N'B', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[IncomeType] ([IncomeTypeID], [IncomeTypeName], [CreationDate], [UpdateDate]) VALUES (3, N'C', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[IncomeType] ([IncomeTypeID], [IncomeTypeName], [CreationDate], [UpdateDate]) VALUES (4, N'D', CAST(N'2022-02-15' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[IncomeType] OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([ProjectID], [ProjectName], [CityID], [ProjectStatusID], [CreationDate], [UpdateDate]) VALUES (1, N'Suryapı Muğla', 25, 2, CAST(N'2022-02-15' AS Date), CAST(N'2022-02-19' AS Date))
INSERT [dbo].[Project] ([ProjectID], [ProjectName], [CityID], [ProjectStatusID], [CreationDate], [UpdateDate]) VALUES (2, N'Suryapı İzmir', 3, 1, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Project] ([ProjectID], [ProjectName], [CityID], [ProjectStatusID], [CreationDate], [UpdateDate]) VALUES (3, N'Suryapı İstanbul', 1, 1, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Project] ([ProjectID], [ProjectName], [CityID], [ProjectStatusID], [CreationDate], [UpdateDate]) VALUES (4, N'Suryapı Ankara', 2, 2, CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Project] ([ProjectID], [ProjectName], [CityID], [ProjectStatusID], [CreationDate], [UpdateDate]) VALUES (9, N'Suryapı Manisa', 7, 1, CAST(N'2022-02-19' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Project] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectStatus] ON 

INSERT [dbo].[ProjectStatus] ([ProjectStatusID], [ProjectStatusName], [CreationDate], [UpdateDate]) VALUES (1, N'Tamamlandı', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[ProjectStatus] ([ProjectStatusID], [ProjectStatusName], [CreationDate], [UpdateDate]) VALUES (2, N'İnşaat Hâlinde', CAST(N'2022-02-15' AS Date), CAST(N'2022-02-18' AS Date))
SET IDENTITY_INSERT [dbo].[ProjectStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[Sales] ON 

INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (2, CAST(N'2021-12-21T00:00:00.000' AS DateTime), 5, 3, 390000.0000, 2, N'Almaz bu', CAST(N'2022-02-10' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (3, CAST(N'2021-12-22T00:00:00.000' AS DateTime), 2, 2, 200000.0000, 1, N'Alıcı ', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (6, CAST(N'2022-02-15T00:00:00.000' AS DateTime), 1, 1, 500000.0000, 11, N'Alıcı', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (7, CAST(N'2022-02-13T00:00:00.000' AS DateTime), 3, 1, 350000.0000, 13, N'Alıcı', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (8, CAST(N'2022-02-11T00:00:00.000' AS DateTime), 4, 2, 350000.0000, 13, N'Alıcı değil', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (9, CAST(N'2022-02-10T00:00:00.000' AS DateTime), 7, 3, 350000.0000, 13, N'Alıcı', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (10, CAST(N'2022-02-09T00:00:00.000' AS DateTime), 10, 4, 350000.0000, 13, N'Almaz gibi', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (12, CAST(N'2022-02-02T00:00:00.000' AS DateTime), 3, 3, 140000.0000, 1, N'Olmadı', CAST(N'2022-02-19' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (13, CAST(N'2022-02-02T00:00:00.000' AS DateTime), 3, 2, 290000.0000, 2, N'Komisyon', CAST(N'2022-02-19' AS Date), NULL)
INSERT [dbo].[Sales] ([SaleID], [SaleDate], [CustomerID], [FlatID], [Price], [EmployeeID], [Notes], [CreationDate], [UpdateDate]) VALUES (14, CAST(N'2020-04-02T00:00:00.000' AS DateTime), 11, 1, 800000.0000, 13, N'Kazıkladık', CAST(N'2022-02-19' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Sales] OFF
GO
INSERT [dbo].[Users] ([EMail], [Password]) VALUES (N'benguneyeroglu@gmail.com', N'1234')
INSERT [dbo].[Users] ([EMail], [Password]) VALUES (N'guneyeroglu_', N'1234')
INSERT [dbo].[Users] ([EMail], [Password]) VALUES (N'a', N'a')
GO
SET IDENTITY_INSERT [dbo].[Visit] ON 

INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (1, CAST(N'2021-12-20T00:00:00.000' AS DateTime), 1, 1, NULL, NULL, NULL)
INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (3, CAST(N'2021-12-21T00:00:00.000' AS DateTime), 3, 1, N'bi daha geldi baktı', NULL, NULL)
INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (4, CAST(N'2021-12-21T00:00:00.000' AS DateTime), 2, 2, N'Hehey', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (5, CAST(N'2022-03-15T00:00:00.000' AS DateTime), 5, 1, N'Gelme', CAST(N'2022-02-15' AS Date), CAST(N'2022-02-19' AS Date))
INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (6, CAST(N'2022-02-14T00:00:00.000' AS DateTime), 4, 2, N'Olur bu', CAST(N'2022-02-15' AS Date), NULL)
INSERT [dbo].[Visit] ([VisitID], [VisitDate], [CustomerID], [ProjectID], [Notes], [CreationDate], [UpdateDate]) VALUES (8, CAST(N'2022-02-02T00:00:00.000' AS DateTime), 2, 3, N'Olmaz gibi sanma', CAST(N'2022-02-19' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Visit] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer]    Script Date: 28.02.2022 04:41:03 ******/
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [IX_Customer] UNIQUE NONCLUSTERED 
(
	[CustomerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_1]    Script Date: 28.02.2022 04:41:03 ******/
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [IX_Customer_1] UNIQUE NONCLUSTERED 
(
	[TC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[City] ADD  CONSTRAINT [DF_City_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[CustomerRequest] ADD  CONSTRAINT [DF_CustomerRequest_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Flat] ADD  CONSTRAINT [DF_Flat_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[FlatStatus] ADD  CONSTRAINT [DF_FlatStatus_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[FlatType] ADD  CONSTRAINT [DF_FlatType_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Gender] ADD  CONSTRAINT [DF_Gender_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[IncomeType] ADD  CONSTRAINT [DF_IncomeType_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Project] ADD  CONSTRAINT [DF_Project_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[ProjectStatus] ADD  CONSTRAINT [DF_ProjectStatus_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Sales] ADD  CONSTRAINT [DF_Sales_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Visit] ADD  CONSTRAINT [DF_Visit_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_City]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Gender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[Gender] ([GenderID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Gender]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_IncomeType] FOREIGN KEY([IncomeTypeID])
REFERENCES [dbo].[IncomeType] ([IncomeTypeID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_IncomeType]
GO
ALTER TABLE [dbo].[CustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_CustomerRequest_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[CustomerRequest] CHECK CONSTRAINT [FK_CustomerRequest_Customer]
GO
ALTER TABLE [dbo].[CustomerRequest]  WITH CHECK ADD  CONSTRAINT [FK_CustomerRequest_FlatType] FOREIGN KEY([FlatTypeID])
REFERENCES [dbo].[FlatType] ([FlatTypeID])
GO
ALTER TABLE [dbo].[CustomerRequest] CHECK CONSTRAINT [FK_CustomerRequest_FlatType]
GO
ALTER TABLE [dbo].[Flat]  WITH CHECK ADD  CONSTRAINT [FK_Flat_FlatStatus] FOREIGN KEY([FlatStatusID])
REFERENCES [dbo].[FlatStatus] ([FlatStatusID])
GO
ALTER TABLE [dbo].[Flat] CHECK CONSTRAINT [FK_Flat_FlatStatus]
GO
ALTER TABLE [dbo].[Flat]  WITH CHECK ADD  CONSTRAINT [FK_Flat_FlatType] FOREIGN KEY([FlatTypeID])
REFERENCES [dbo].[FlatType] ([FlatTypeID])
GO
ALTER TABLE [dbo].[Flat] CHECK CONSTRAINT [FK_Flat_FlatType]
GO
ALTER TABLE [dbo].[Flat]  WITH CHECK ADD  CONSTRAINT [FK_Flat_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[Flat] CHECK CONSTRAINT [FK_Flat_Project]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_City]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectStatus] FOREIGN KEY([ProjectStatusID])
REFERENCES [dbo].[ProjectStatus] ([ProjectStatusID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectStatus]
GO
ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Customer]
GO
ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Employee]
GO
ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Flat] FOREIGN KEY([FlatID])
REFERENCES [dbo].[Flat] ([FlatID])
GO
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Flat]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Customer]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Project]
GO
/****** Object:  Trigger [dbo].[IptalEdilenSatisiAc]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[IptalEdilenSatisiAc]
   ON  [dbo].[Sales] 
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FlatID as int
	SELECT @FlatID = FlatID FROM deleted

	UPDATE Flat SET FlatStatusID = 1 
	WHERE FlatID = @FlatID

    -- Insert statements for trigger here

END
GO
ALTER TABLE [dbo].[Sales] ENABLE TRIGGER [IptalEdilenSatisiAc]
GO
/****** Object:  Trigger [dbo].[SatilanEviKapat]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[SatilanEviKapat]
   ON  [dbo].[Sales] 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FlatID as int
	SELECT @FlatID = FlatID FROM inserted

	UPDATE Flat SET FlatStatusID = 2 
	WHERE FlatID = @FlatID

    -- Insert statements for trigger here

END
GO
ALTER TABLE [dbo].[Sales] ENABLE TRIGGER [SatilanEviKapat]
GO
/****** Object:  Trigger [dbo].[SatisGuncellenemesin]    Script Date: 28.02.2022 04:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[SatisGuncellenemesin] 
   ON  [dbo].[Sales] 
INSTEAD OF UPDATE
AS 
BEGIN
	RAISERROR('Guncelleme yapılamaz', 1,1)
	ROLLBACK TRAN
END
GO
ALTER TABLE [dbo].[Sales] DISABLE TRIGGER [SatisGuncellenemesin]
GO
USE [master]
GO
ALTER DATABASE [Insaat] SET  READ_WRITE 
GO
