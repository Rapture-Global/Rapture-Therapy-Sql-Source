--------------------------------------------------------------------------------
-- Copyright © 2021+ Éamonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Created: Éamonn A. Duffy, 2-May-2021.
--
-- Purpose: Main Sql File for the Rapture Therapy Sql Server Database.
--
-- Assumptions:
--
--  0.  The Sql Server Database has already been Created by some other means.
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Some Variables.
--------------------------------------------------------------------------------

:SETVAR Schema                          "Dad"

:SETVAR RaptureTherapyDatabaseName      "[RaptureTherapy]"

:SETVAR EadentIdentitySqlFolder         "\Projects\Eadent\Eadent-Identity-Sql-Source\Sql"

--------------------------------------------------------------------------------
-- Select the Correct Database.
--------------------------------------------------------------------------------

USE $(RaptureTherapyDatabaseName)
GO

--------------------------------------------------------------------------------
-- Begin the Main Transaction.
--------------------------------------------------------------------------------

SET CONTEXT_INFO    0x00;

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
GO

--------------------------------------------------------------------------------
-- Include the Eadent Identity Sql.
--------------------------------------------------------------------------------

:R $(EadentIdentitySqlFolder)"\00. EadentIdentity.sql"

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
        Patch                       Int NOT NULL,
        Build                       Int NOT NULL,
        Description                 NVarChar(128) NOT NULL,
        ReleasedDateTimeUtc         DateTime2(7) NOT NULL,
        InstalledDateTimeUtc        DateTime2(7) NOT NULL
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
GO

--------------------------------------------------------------------------------
-- Insert Version.
--------------------------------------------------------------------------------

INSERT INTO $(Schema).RaptureTherapyDatabaseVersions
    (Major, Minor, Patch, Build, Description, ReleasedDateTimeUtc, InstalledDateTimeUtc)
VALUES
    (0,     0,     0,     9,     N'Alpha Build.', N'1927-04-29 19:27:07', GetUtcDate());
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    BEGIN TRANSACTION;
    SET CONTEXT_INFO 0x01;
END
GO

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
    PRINT N' One or More Errors Occurred Executing the Sql.';

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END
GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------

/*

:SETVAR Schema      "Dad"

DROP TABLE $(Schema).RaptureTherapyDatabaseVersions;

DROP SCHEMA $(Schema);

*/
