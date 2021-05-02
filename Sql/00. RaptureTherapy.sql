--------------------------------------------------------------------------------
-- Copyright © 2021+ Éamonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Created:	Éamonn A. Duffy, 2-May-2021.
--
-- Purpose:	Main Sql File for the Rapture Therapy Sql Server Database.
--
-- Assumptions:
--
--	0.	The Sql Server Database has already been Created by some other means,
--		and has been selected for Use.
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Some Variables.
--------------------------------------------------------------------------------

:SETVAR Schema							"Dad"

:SETVAR RaptureTherapyDatabaseName		"[IdentityInvestigation]"

:SETVAR EadentIdentitySql				"\Projects\Eadent\Eadent-Identity-Sql-Source\Sql\00. EadentIdentity.sql"

:SETVAR EadentIdentitySqlFolder			"\Projects\Eadent\Eadent-Identity-Sql-Source\Sql"

--------------------------------------------------------------------------------
-- Select the Correct Database.
--------------------------------------------------------------------------------

USE $(RaptureTherapyDatabaseName)
GO

--------------------------------------------------------------------------------
-- Begin the Main Transacttoin.
--------------------------------------------------------------------------------

SET CONTEXT_INFO	0x00;

BEGIN TRANSACTION
GO

--------------------------------------------------------------------------------
-- Create Schema if/as appropriate.
--------------------------------------------------------------------------------

IF SCHEMA_ID(N'$(Schema)') IS NULL
BEGIN
	EXECUTE(N'CREATE SCHEMA $(Schema);');
END
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
	BEGIN TRANSACTION;
	SET CONTEXT_INFO 0x01;
END

--------------------------------------------------------------------------------
-- Include the Eadent Identity Sql.
--------------------------------------------------------------------------------

:R $(EadentIdentitySql)

--------------------------------------------------------------------------------
-- Create Tables if/as appropriate.
--------------------------------------------------------------------------------

IF OBJECT_ID(N'$(Schema).RaptureTherapyDatabaseVersions', N'U') IS NULL
BEGIN
	CREATE TABLE $(Schema).RaptureTherapyDatabaseVersions
	(
		DatabaseVersionId           Int NOT NULL CONSTRAINT PK_$(Schema)_RaptureTherapyDatabaseVersions PRIMARY KEY IDENTITY(0, 1),
		Major                       Int NOT NULL,
		Minor                       Int NOT NULL,
		Patch						Int NOT NULL,
		Build                       Int NOT NULL,
		Description					NVarChar(128) NOT NULL,
		CreatedDateTimeUtc          DateTime2(7) NOT NULL
	);
END
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
	BEGIN TRANSACTION;
	SET CONTEXT_INFO 0x01;
END

--------------------------------------------------------------------------------
-- Check for Errors.
--------------------------------------------------------------------------------

IF CONTEXT_INFO() = 0x00
BEGIN
	PRINT N'The Sql Executed Successfully.';

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
ELSE
BEGIN
	PRINT N' There was One or More Errors Executing the Sql.';

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
END
GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------

/*

DROP TABLE [Dad].RaptureTherapyDatabaseVersions;

DROP TABLE [Dad].Users;

DROP TABLE [Dad].UserEMails;

*/
