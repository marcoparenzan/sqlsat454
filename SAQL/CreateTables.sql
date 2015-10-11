CREATE TABLE [dbo].[RawApiCalls](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Deployment] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](64) NULL,
	[Elapsed] int NOT NULL,
	[Size] [int] NOT NULL,
	[CallTime] [datetime] NOT NULL
)

ALTER TABLE [dbo].[RawApiCalls] ADD [ElapsedAvg] int NULL

CREATE TABLE [dbo].[RawApiCallsHeavy](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Deployment] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](64) NULL,
	[Elapsed] int NOT NULL,
	[Size] [int] NOT NULL,
	[CallTime] [datetime] NOT NULL,
	[ElapsedAvg] int NULL
)

CREATE TABLE [dbo].[RawApiCallsStats](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Deployment] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](64) NULL,
	[AvgElapsed] int NOT NULL,
	[AvgSize] int NOT NULL,
	[SumElapsed] int NOT NULL,
	[SumSize] int NOT NULL
)

ALTER TABLE [dbo].[RawApiCallsStats] ADD TSTime DateTime NULL

CREATE TABLE [dbo].[RawApiCallsLoad](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Deployment] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](64) NULL,
	[AvgElapsed] [int] NOT NULL,
	[AvgLoad] [int] NOT NULL,
	[TSTime] [datetime] NULL
)

CREATE TABLE [dbo].[RawApiCallsStorage](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Deployment] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](64) NULL,
	[AvgSize] [int] NOT NULL,
	[AvgBytes] [int] NOT NULL,
	[TSTime] [datetime] NULL
)

