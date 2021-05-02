--------------------------------------------------------------------------------
-- Copyright © 2010+ Éamonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Created:	Éamonn A. Duffy, 2-May-2021.
--
-- Purpose:	Main Sql File for the Rapture Therapy Sql Server Database.
--
-- Assumptions:
--
--	0.	The Sql Server Database has already been Created by some other means,
--		ans has been selected for Use.
--
--------------------------------------------------------------------------------

-- Some Variables.
:SETVAR Schema							"Dad"

:SETVAR EadentIdentitySqlFolder			"\Projects\Eadent-Identity-Sql-Source\Sql"

--------------------------------------------------------------------------------
-- Create Schema if/as appropriate.
--------------------------------------------------------------------------------

IF SCHEMA_ID(N'$(Schema)') IS NULL
BEGIN
	EXECUTE(N'CREATE SCHEMA $(Schema);');
END
GO

--------------------------------------------------------------------------------
-- Include the Eadent Identity Sql.
--------------------------------------------------------------------------------

:R "$(EadentIdentitySqlFolder)\00. EadentIdentity.sql"

--------------------------------------------------------------------------------
-- Create Tables if/as appropriate.
--------------------------------------------------------------------------------
-- TODO: Investigate further the potential requirement for ON PRIMARY.
--------------------------------------------------------------------------------

IF OBJECT_ID('*objectName*', 'U') IS NOT NULL
BEGIN
	CREATE TABLE $(Schema).DatabaseVersion
	(
		DatabaseVersionId           Integer CONSTRAINT PK_DatabaseVersion PRIMARY KEY IDENTITY(0, 1) NOT NULL,
		Major                       Integer NOT NULL,
		Minor                       Integer NOT NULL,
		Patch						Integer NOT NULL.
		Build                       Integer NOT NULL,
		Description                 NVarChar(128) NOT NULL,
		CreatedDateTimeUtc          DateTime2(7) NOT NULL
	);
END
GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------
