SET NOCOUNT ON;
GO


-- create [emfac] schema -----------------------------------------------------
-- note that [emfac] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'emfac'
)
EXEC ('CREATE SCHEMA [emfac]')
GO

-- add metadata for [emfac] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[emfac]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'emfac', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'emfac', 'MS_Description', 'schema to hold all objects associated with emfac program'
END
GO




-- drop table constraints if they exist --------------------------------------
-- so tables can be dropped and re-created
IF  EXISTS (
    SELECT TOP 1
        [object_id]
    FROM
        [sys].[foreign_keys]
    WHERE
        [object_id] = OBJECT_ID('[emfac].[fk_emfac_vehicle_map_emfac_vehicle_class]')
        AND [parent_object_id] = OBJECT_ID('[emfac].[emfac_vehicle_map]')
)
ALTER TABLE [emfac].[emfac_vehicle_map]
DROP CONSTRAINT [fk_emfac_vehicle_map_emfac_vehicle_class]

IF  EXISTS (
    SELECT TOP 1
        [object_id]
    FROM
        [sys].[foreign_keys]
    WHERE
        [object_id] = OBJECT_ID('[emfac].[fk_emfac_vehicle_map_sandag_vehicle_class]')
        AND [parent_object_id] = OBJECT_ID('[emfac].[emfac_vehicle_map]')
)
ALTER TABLE [emfac].[emfac_vehicle_map]
DROP CONSTRAINT [fk_emfac_vehicle_map_sandag_vehicle_class]
GO




-- create emfac vehicle class reference table --------------------------------
DROP TABLE IF EXISTS [emfac].[emfac_vehicle_class]
GO

CREATE TABLE [emfac].[emfac_vehicle_class](
	[emfac_vehicle_class_id] smallint IDENTITY(1,1) NOT NULL,
	[emfac_vehicle_class] varchar(50) NOT NULL,
	[emfac_vehicle_category] varchar(50) NOT NULL,
	[emfac_vehicle_fuel_type] varchar(20) NOT NULL,
	[major_version] varchar(5) NOT NULL,
	[minor_version] varchar(5) NOT NULL,
	CONSTRAINT [pk_emfac_vehicle_class]
        PRIMARY KEY ([emfac_vehicle_class_id])
	)
WITH
	(DATA_COMPRESSION = PAGE);

INSERT INTO [emfac].[emfac_vehicle_class] VALUES
	('LDA - Dsl','LDA','Dsl','2014','1.0'),
	('LDA - Elec','LDA','Elec','2014','1.0'),
	('LDA - Gas','LDA','Gas','2014','1.0'),
	('LDT1 - Dsl','LDT1','Dsl','2014','1.0'),
	('LDT1 - Elec','LDT1','Elec','2014','1.0'),
	('LDT1 - Gas','LDT1','Gas','2014','1.0'),
	('LDT2 - Dsl','LDT2','Dsl','2014','1.0'),
	('LDT2 - Gas','LDT2','Gas','2014','1.0'),
	('LHD1 - Dsl','LHD1','Dsl','2014','1.0'),
	('LHD1 - Gas','LHD1','Gas','2014','1.0'),
	('LHD2 - Dsl','LHD2','Dsl','2014','1.0'),
	('LHD2 - Gas','LHD2','Gas','2014','1.0'),
	('MCY - Gas','MCY','Gas','2014','1.0'),
	('MDV - Dsl','MDV','Dsl','2014','1.0'),
	('MDV - Gas','MDV','Gas','2014','1.0'),
	('MH - Dsl','MH','Dsl','2014','1.0'),
	('MH - Gas','MH','Gas','2014','1.0'),
	('T6 Ag - Dsl','T6 Ag','Dsl','2014','1.0'),
	('T6 CAIRP Heavy - Dsl','T6 CAIRP Heavy','Dsl','2014','1.0'),
	('T6 CAIRP Small - Dsl','T6 CAIRP Small','Dsl','2014','1.0'),
	('T6 Instate Construction Heavy - Dsl','T6 Instate Construction Heavy','Dsl','2014','1.0'),
	('T6 Instate Construction Small - Dsl','T6 Instate Construction Small','Dsl','2014','1.0'),
	('T6 Instate Heavy - Dsl','T6 Instate Heavy','Dsl','2014','1.0'),
	('T6 Instate Small - Dsl','T6 Instate Small','Dsl','2014','1.0'),
	('T6 OOS Heavy - Dsl','T6 OOS Heavy','Dsl','2014','1.0'),
	('T6 OOS Small - Dsl','T6 OOS Small','Dsl','2014','1.0'),
	('T6 Public - Dsl','T6 Public','Dsl','2014','1.0'),
	('T6 Utility - Dsl','T6 Utility','Dsl','2014','1.0'),
	('T6TS - Gas','T6TS','Gas','2014','1.0'),
	('T7 Ag - Dsl','T7 Ag','Dsl','2014','1.0'),
	('T7 CAIRP - Dsl','T7 CAIRP','Dsl','2014','1.0'),
	('T7 CAIRP Construction - Dsl','T7 CAIRP Construction','Dsl','2014','1.0'),
	('T7 NNOOS - Dsl','T7 NNOOS','Dsl','2014','1.0'),
	('T7 NOOS - Dsl','T7 NOOS','Dsl','2014','1.0'),
	('T7 Other Port - Dsl','T7 Other Port','Dsl','2014','1.0'),
	('T7 POAK - Dsl','T7 POAK','Dsl','2014','1.0'),
	('T7 POLA - Dsl','T7 POLA','Dsl','2014','1.0'),
	('T7 Public - Dsl','T7 Public','Dsl','2014','1.0'),
	('T7 Single - Dsl','T7 Single','Dsl','2014','1.0'),
	('T7 Single Construction - Dsl','T7 Single Construction','Dsl','2014','1.0'),
	('T7 SWCV - Dsl','T7 SWCV','Dsl','2014','1.0'),
	('T7 Tractor - Dsl','T7 Tractor','Dsl','2014','1.0'),
	('T7 Tractor Construction - Dsl','T7 Tractor Construction','Dsl','2014','1.0'),
	('T7 Utility - Dsl','T7 Utility','Dsl','2014','1.0'),
	('T7IS - Gas','T7IS','Gas','2014','1.0'),
	('PTO - Dsl','PTO','Dsl','2014','1.0'),
	('SBUS - Dsl','SBUS','Dsl','2014','1.0'),
	('SBUS - Gas','SBUS','Gas','2014','1.0'),
	('UBUS - Dsl','UBUS','Dsl','2014','1.0'),
	('UBUS - Gas','UBUS','Gas','2014','1.0'),
	('Motor Coach - Dsl','Motor Coach','Dsl','2014','1.0'),
	('OBUS - Gas','OBUS','Gas','2014','1.0'),
	('All Other Buses - Dsl','All Other Buses','Dsl','2014','1.0'),
	('LDA - Dsl','LDA','Dsl','2017','1.0'),
	('LDA - Elec','LDA','Elec','2017','1.0'),
	('LDA - Gas','LDA','Gas','2017','1.0'),
	('LDT1 - Dsl','LDT1','Dsl','2017','1.0'),
	('LDT1 - Elec','LDT1','Elec','2017','1.0'),
	('LDT1 - Gas','LDT1','Gas','2017','1.0'),
	('LDT2 - Dsl','LDT2','Dsl','2017','1.0'),
	('LDT2 - Elec','LDT2','Elec','2017','1.0'),
	('LDT2 - Gas','LDT2','Gas','2017','1.0'),
	('LHD1 - Dsl','LHD1','Dsl','2017','1.0'),
	('LHD1 - Gas','LHD1','Gas','2017','1.0'),
	('LHD2 - Dsl','LHD2','Dsl','2017','1.0'),
	('LHD2 - Gas','LHD2','Gas','2017','1.0'),
	('MCY - Gas','MCY','Gas','2017','1.0'),
	('MDV - Dsl','MDV','Dsl','2017','1.0'),
	('MDV - Elec','MDV','Elec','2017','1.0'),
	('MDV - Gas','MDV','Gas','2017','1.0'),
	('MH - Dsl','MH','Dsl','2017','1.0'),
	('MH - Gas','MH','Gas','2017','1.0'),
	('T6 Ag - Dsl','T6 Ag','Dsl','2017','1.0'),
	('T6 CAIRP Heavy - Dsl','T6 CAIRP Heavy','Dsl','2017','1.0'),
	('T6 CAIRP Small - Dsl','T6 CAIRP Small','Dsl','2017','1.0'),
	('T6 Instate Construction Heavy - Dsl','T6 Instate Construction Heavy','Dsl','2017','1.0'),
	('T6 Instate Construction Small - Dsl','T6 Instate Construction Small','Dsl','2017','1.0'),
	('T6 Instate Heavy - Dsl','T6 Instate Heavy','Dsl','2017','1.0'),
	('T6 Instate Small - Dsl','T6 Instate Small','Dsl','2017','1.0'),
	('T6 OOS Heavy - Dsl','T6 OOS Heavy','Dsl','2017','1.0'),
	('T6 OOS Small - Dsl','T6 OOS Small','Dsl','2017','1.0'),
	('T6 Public - Dsl','T6 Public','Dsl','2017','1.0'),
	('T6 Utility - Dsl','T6 Utility','Dsl','2017','1.0'),
	('T6TS - Gas','T6TS','Gas','2017','1.0'),
	('T7 Ag - Dsl','T7 Ag','Dsl','2017','1.0'),
	('T7 CAIRP - Dsl','T7 CAIRP','Dsl','2017','1.0'),
	('T7 CAIRP Construction - Dsl','T7 CAIRP Construction','Dsl','2017','1.0'),
	('T7 NNOOS - Dsl','T7 NNOOS','Dsl','2017','1.0'),
	('T7 NOOS - Dsl','T7 NOOS','Dsl','2017','1.0'),
	('T7 Other Port - Dsl','T7 Other Port','Dsl','2017','1.0'),
	('T7 POAK - Dsl','T7 POAK','Dsl','2017','1.0'),
	('T7 POLA - Dsl','T7 POLA','Dsl','2017','1.0'),
	('T7 Public - Dsl','T7 Public','Dsl','2017','1.0'),
	('T7 Single - Dsl','T7 Single','Dsl','2017','1.0'),
	('T7 Single Construction - Dsl','T7 Single Construction','Dsl','2017','1.0'),
	('T7 SWCV - Dsl','T7 SWCV','Dsl','2017','1.0'),
	('T7 SWCV - NG','T7 SWCV','NG','2017','1.0'),
	('T7 Tractor - Dsl','T7 Tractor','Dsl','2017','1.0'),
	('T7 Tractor Construction - Dsl','T7 Tractor Construction','Dsl','2017','1.0'),
	('T7 Utility - Dsl','T7 Utility','Dsl','2017','1.0'),
	('T7IS - Gas','T7IS','Gas','2017','1.0'),
	('PTO - Dsl','PTO','Dsl','2017','1.0'),
	('SBUS - Dsl','SBUS','Dsl','2017','1.0'),
	('SBUS - Gas','SBUS','Gas','2017','1.0'),
	('UBUS - Dsl','UBUS','Dsl','2017','1.0'),
	('UBUS - Gas','UBUS','Gas','2017','1.0'),
	('UBUS - NG','UBUS','NG','2017','1.0'),
	('Motor Coach - Dsl','Motor Coach','Dsl','2017','1.0'),
	('OBUS - Gas','OBUS','Gas','2017','1.0'),
	('All Other Buses - Dsl','All Other Buses','Dsl','2017','1.0'),
    ('All Other Buses-Dsl','All Other Buses','Dsl','2021','1.0'),
    ('All Other Buses-NG','All Other Buses','NG','2021','1.0'),
    ('LDA-Dsl','LDA','Dsl','2021','1.0'),
    ('LDA-Elec','LDA','Elec','2021','1.0'),
    ('LDA-Gas','LDA','Gas','2021','1.0'),
    ('LDA-Phe','LDA','Phe','2021','1.0'),
    ('LDT1-Dsl','LDT1','Dsl','2021','1.0'),
    ('LDT1-Elec','LDT1','Elec','2021','1.0'),
    ('LDT1-Gas','LDT1','Gas','2021','1.0'),
    ('LDT1-Phe','LDT1','Phe','2021','1.0'),
    ('LDT2-Dsl','LDT2','Dsl','2021','1.0'),
    ('LDT2-Elec','LDT2','Elec','2021','1.0'),
    ('LDT2-Gas','LDT2','Gas','2021','1.0'),
    ('LDT2-Phe','LDT2','Phe','2021','1.0'),
    ('LHD1-Dsl','LHD1','Dsl','2021','1.0'),
    ('LHD1-Elec','LHD1','Elec','2021','1.0'),
    ('LHD1-Gas','LHD1','Gas','2021','1.0'),
    ('LHD2-Dsl','LHD2','Dsl','2021','1.0'),
    ('LHD2-Elec','LHD2','Elec','2021','1.0'),
    ('LHD2-Gas','LHD2','Gas','2021','1.0'),
    ('MCY-Gas','MCY','Gas','2021','1.0'),
    ('MDV-Dsl','MDV','Dsl','2021','1.0'),
    ('MDV-Elec','MDV','Elec','2021','1.0'),
    ('MDV-Gas','MDV','Gas','2021','1.0'),
    ('MDV-Phe','MDV','Phe','2021','1.0'),
    ('MH-Dsl','MH','Dsl','2021','1.0'),
    ('MH-Gas','MH','Gas','2021','1.0'),
    ('Motor Coach-Dsl','Motor Coach','Dsl','2021','1.0'),
    ('OBUS-Elec','OBUS','Elec','2021','1.0'),
    ('OBUS-Gas','OBUS','Gas','2021','1.0'),
    ('PTO-Dsl','PTO','Dsl','2021','1.0'),
    ('PTO-Elec','PTO','Elec','2021','1.0'),
    ('SBUS-Dsl','SBUS','Dsl','2021','1.0'),
    ('SBUS-Elec','SBUS','Elec','2021','1.0'),
    ('SBUS-Gas','SBUS','Gas','2021','1.0'),
    ('SBUS-NG','SBUS','NG','2021','1.0'),
    ('T6 CAIRP Class 4-Dsl','T6 CAIRP Class 4','Dsl','2021','1.0'),
    ('T6 CAIRP Class 4-Elec','T6 CAIRP Class 4','Elec','2021','1.0'),
    ('T6 CAIRP Class 5-Dsl','T6 CAIRP Class 5','Dsl','2021','1.0'),
    ('T6 CAIRP Class 5-Elec','T6 CAIRP Class 5','Elec','2021','1.0'),
    ('T6 CAIRP Class 6-Dsl','T6 CAIRP Class 6','Dsl','2021','1.0'),
    ('T6 CAIRP Class 6-Elec','T6 CAIRP Class 6','Elec','2021','1.0'),
    ('T6 CAIRP Class 7-Dsl','T6 CAIRP Class 7','Dsl','2021','1.0'),
    ('T6 CAIRP Class 7-Elec','T6 CAIRP Class 7','Elec','2021','1.0'),
    ('T6 Instate Delivery Class 4-Dsl','T6 Instate Delivery Class 4','Dsl','2021','1.0'),
    ('T6 Instate Delivery Class 4-Elec','T6 Instate Delivery Class 4','Elec','2021','1.0'),
    ('T6 Instate Delivery Class 4-NG','T6 Instate Delivery Class 4','NG','2021','1.0'),
    ('T6 Instate Delivery Class 5-Dsl','T6 Instate Delivery Class 5','Dsl','2021','1.0'),
    ('T6 Instate Delivery Class 5-Elec','T6 Instate Delivery Class 5','Elec','2021','1.0'),
    ('T6 Instate Delivery Class 5-NG','T6 Instate Delivery Class 5','NG','2021','1.0'),
    ('T6 Instate Delivery Class 6-Dsl','T6 Instate Delivery Class 6','Dsl','2021','1.0'),
    ('T6 Instate Delivery Class 6-Elec','T6 Instate Delivery Class 6','Elec','2021','1.0'),
    ('T6 Instate Delivery Class 6-NG','T6 Instate Delivery Class 6','NG','2021','1.0'),
    ('T6 Instate Delivery Class 7-Dsl','T6 Instate Delivery Class 7','Dsl','2021','1.0'),
    ('T6 Instate Delivery Class 7-Elec','T6 Instate Delivery Class 7','Elec','2021','1.0'),
    ('T6 Instate Delivery Class 7-NG','T6 Instate Delivery Class 7','NG','2021','1.0'),
    ('T6 Instate Other Class 4-Dsl','T6 Instate Other Class 4','Dsl','2021','1.0'),
    ('T6 Instate Other Class 4-Elec','T6 Instate Other Class 4','Elec','2021','1.0'),
    ('T6 Instate Other Class 4-NG','T6 Instate Other Class 4','NG','2021','1.0'),
    ('T6 Instate Other Class 5-Dsl','T6 Instate Other Class 5','Dsl','2021','1.0'),
    ('T6 Instate Other Class 5-Elec','T6 Instate Other Class 5','Elec','2021','1.0'),
    ('T6 Instate Other Class 5-NG','T6 Instate Other Class 5','NG','2021','1.0'),
    ('T6 Instate Other Class 6-Dsl','T6 Instate Other Class 6','Dsl','2021','1.0'),
    ('T6 Instate Other Class 6-Elec','T6 Instate Other Class 6','Elec','2021','1.0'),
    ('T6 Instate Other Class 6-NG','T6 Instate Other Class 6','NG','2021','1.0'),
    ('T6 Instate Other Class 7-Dsl','T6 Instate Other Class 7','Dsl','2021','1.0'),
    ('T6 Instate Other Class 7-Elec','T6 Instate Other Class 7','Elec','2021','1.0'),
    ('T6 Instate Other Class 7-NG','T6 Instate Other Class 7','NG','2021','1.0'),
    ('T6 Instate Tractor Class 6-Dsl','T6 Instate Tractor Class 6','Dsl','2021','1.0'),
    ('T6 Instate Tractor Class 6-Elec','T6 Instate Tractor Class 6','Elec','2021','1.0'),
    ('T6 Instate Tractor Class 6-NG','T6 Instate Tractor Class 6','NG','2021','1.0'),
    ('T6 Instate Tractor Class 7-Dsl','T6 Instate Tractor Class 7','Dsl','2021','1.0'),
    ('T6 Instate Tractor Class 7-Elec','T6 Instate Tractor Class 7','Elec','2021','1.0'),
    ('T6 Instate Tractor Class 7-NG','T6 Instate Tractor Class 7','NG','2021','1.0'),
    ('T6 OOS Class 4-Dsl','T6 OOS Class 4','Dsl','2021','1.0'),
    ('T6 OOS Class 5-Dsl','T6 OOS Class 5','Dsl','2021','1.0'),
    ('T6 OOS Class 6-Dsl','T6 OOS Class 6','Dsl','2021','1.0'),
    ('T6 OOS Class 7-Dsl','T6 OOS Class 7','Dsl','2021','1.0'),
    ('T6 Public Class 4-Dsl','T6 Public Class 4','Dsl','2021','1.0'),
    ('T6 Public Class 4-Elec','T6 Public Class 4','Elec','2021','1.0'),
    ('T6 Public Class 4-NG','T6 Public Class 4','NG','2021','1.0'),
    ('T6 Public Class 5-Dsl','T6 Public Class 5','Dsl','2021','1.0'),
    ('T6 Public Class 5-Elec','T6 Public Class 5','Elec','2021','1.0'),
    ('T6 Public Class 5-NG','T6 Public Class 5','NG','2021','1.0'),
    ('T6 Public Class 6-Dsl','T6 Public Class 6','Dsl','2021','1.0'),
    ('T6 Public Class 6-Elec','T6 Public Class 6','Elec','2021','1.0'),
    ('T6 Public Class 6-NG','T6 Public Class 6','NG','2021','1.0'),
    ('T6 Public Class 7-Dsl','T6 Public Class 7','Dsl','2021','1.0'),
    ('T6 Public Class 7-Elec','T6 Public Class 7','Elec','2021','1.0'),
    ('T6 Public Class 7-NG','T6 Public Class 7','NG','2021','1.0'),
    ('T6 Utility Class 5-Dsl','T6 Utility Class 5','Dsl','2021','1.0'),
    ('T6 Utility Class 5-Elec','T6 Utility Class 5','Elec','2021','1.0'),
    ('T6 Utility Class 6-Dsl','T6 Utility Class 6','Dsl','2021','1.0'),
    ('T6 Utility Class 6-Elec','T6 Utility Class 6','Elec','2021','1.0'),
    ('T6 Utility Class 7-Dsl','T6 Utility Class 7','Dsl','2021','1.0'),
    ('T6 Utility Class 7-Elec','T6 Utility Class 7','Elec','2021','1.0'),
    ('T6TS-Elec','T6TS','Elec','2021','1.0'),
    ('T6TS-Gas','T6TS','Gas','2021','1.0'),
    ('T7 CAIRP Class 8-Dsl','T7 CAIRP Class 8','Dsl','2021','1.0'),
    ('T7 CAIRP Class 8-Elec','T7 CAIRP Class 8','Elec','2021','1.0'),
    ('T7 CAIRP Class 8-NG','T7 CAIRP Class 8','NG','2021','1.0'),
    ('T7 NNOOS Class 8-Dsl','T7 NNOOS Class 8','Dsl','2021','1.0'),
    ('T7 NOOS Class 8-Dsl','T7 NOOS Class 8','Dsl','2021','1.0'),
    ('T7 Other Port Class 8-Dsl','T7 Other Port Class 8','Dsl','2021','1.0'),
    ('T7 Other Port Class 8-Elec','T7 Other Port Class 8','Elec','2021','1.0'),
    ('T7 POLA Class 8-Dsl','T7 POLA Class 8','Dsl','2021','1.0'),
    ('T7 POLA Class 8-Elec','T7 POLA Class 8','Elec','2021','1.0'),
    ('T7 Public Class 8-Dsl','T7 Public Class 8','Dsl','2021','1.0'),
    ('T7 Public Class 8-Elec','T7 Public Class 8','Elec','2021','1.0'),
    ('T7 Public Class 8-NG','T7 Public Class 8','NG','2021','1.0'),
    ('T7 Single Concrete/Transit Mix Class 8-Dsl','T7 Single Concrete/Transit Mix Class 8','Dsl','2021','1.0'),
    ('T7 Single Concrete/Transit Mix Class 8-Elec','T7 Single Concrete/Transit Mix Class 8','Elec','2021','1.0'),
    ('T7 Single Concrete/Transit Mix Class 8-NG','T7 Single Concrete/Transit Mix Class 8','NG','2021','1.0'),
    ('T7 Single Dump Class 8-Dsl','T7 Single Dump Class 8','Dsl','2021','1.0'),
    ('T7 Single Dump Class 8-Elec','T7 Single Dump Class 8','Elec','2021','1.0'),
    ('T7 Single Dump Class 8-NG','T7 Single Dump Class 8','NG','2021','1.0'),
    ('T7 Single Other Class 8-Dsl','T7 Single Other Class 8','Dsl','2021','1.0'),
    ('T7 Single Other Class 8-Elec','T7 Single Other Class 8','Elec','2021','1.0'),
    ('T7 Single Other Class 8-NG','T7 Single Other Class 8','NG','2021','1.0'),
    ('T7 SWCV Class 8-Dsl','T7 SWCV Class 8','Dsl','2021','1.0'),
    ('T7 SWCV Class 8-Elec','T7 SWCV Class 8','Elec','2021','1.0'),
    ('T7 SWCV Class 8-NG','T7 SWCV Class 8','NG','2021','1.0'),
    ('T7 Tractor Class 8-Dsl','T7 Tractor Class 8','Dsl','2021','1.0'),
    ('T7 Tractor Class 8-Elec','T7 Tractor Class 8','Elec','2021','1.0'),
    ('T7 Tractor Class 8-NG','T7 Tractor Class 8','NG','2021','1.0'),
    ('T7 Utility Class 8-Dsl','T7 Utility Class 8','Dsl','2021','1.0'),
    ('T7 Utility Class 8-Elec','T7 Utility Class 8','Elec','2021','1.0'),
    ('T7IS-Elec','T7IS','Elec','2021','1.0'),
    ('T7IS-Gas','T7IS','Gas','2021','1.0'),
    ('UBUS-Dsl','UBUS','Dsl','2021','1.0'),
    ('UBUS-Elec','UBUS','Elec','2021','1.0'),
    ('UBUS-Gas','UBUS','Gas','2021','1.0'),
    ('UBUS-NG','UBUS','NG','2021','1.0')
GO

-- add metadata for [emfac].[emfac_vehicle_class]
EXECUTE [db_meta].[add_xp] 'emfac.emfac_vehicle_class', 'MS_Description', 'emfac vehicle classes used in emfac program by emfac versions'
GO




-- create sandag vehicle class reference table -------------------------------
DROP TABLE IF EXISTS [emfac].[sandag_vehicle_class]
GO

CREATE TABLE [emfac].[sandag_vehicle_class](
	[sandag_vehicle_class_id] tinyint IDENTITY(1, 1) NOT NULL,
	[sandag_vehicle_class] varchar(50) NOT NULL,
	CONSTRAINT [pk_sandag_vehicle_class]
        PRIMARY KEY ([sandag_vehicle_class_id]))
WITH
	(DATA_COMPRESSION = PAGE);

INSERT INTO [emfac].[sandag_vehicle_class] VALUES
	('Drive Alone'),
	('Heavy Heavy Duty Truck'),
	('Highway Network Preload - Bus'),
	('Light Heavy Duty Truck'),
	('Medium Heavy Duty Truck'),
	('Shared Ride 2'),
	('Shared Ride 3+')
GO

-- add metadata for [emfac].[sandag_vehicle_class]
EXECUTE [db_meta].[add_xp] 'emfac.sandag_vehicle_class', 'MS_Description', 'assignment sandag vehicle classes used in emfac program'
GO




-- create emfac default vmt reference table ----------------------------------
DROP TABLE IF EXISTS [emfac].[emfac_default_vmt]
GO

CREATE TABLE [emfac].[emfac_default_vmt](
	[emfac_default_vmt_id] int IDENTITY(1, 1) NOT NULL,
	[emfac_vehicle_class_id] smallint NOT NULL,
	[year] smallint NOT NULL,
	[vmt] float NOT NULL,
	CONSTRAINT [pk_emfac_default_vmt]
        PRIMARY KEY ([emfac_default_vmt_id]),
	CONSTRAINT [ixuq_emfac_default_vmt]
        UNIQUE ([emfac_vehicle_class_id],[year])
        WITH (DATA_COMPRESSION = PAGE))
WITH
	(DATA_COMPRESSION = PAGE);
GO

-- insert emfac default vmt output
-- this is the output from
-- Default_SanDiegoSD_<<YEAR>>_Annual_vmt_<<datetime>>.csv file
CREATE TABLE #tt_emfac_default_vmt (
	[major_version] varchar(5) NOT NULL,
	[minor_version] varchar(5) NOT NULL,
	[calendar_year] smallint NOT NULL,
	[vehicle_class] varchar(50) NOT NULL,
	[fuel] varchar(10) NOT NULL,
	[vmt] float NOT NULL,
	CONSTRAINT [pk_tt_emfac_default_vmt]
        PRIMARY KEY ([major_version], [minor_version], [calendar_year], [vehicle_class], [fuel]))
INSERT INTO #tt_emfac_default_vmt VALUES
	('2014', '1.0', 2016, 'LDA', 'Gas', 42635257.4215625),
	('2014', '1.0', 2016, 'LDA', 'Dsl', 426828.919615786),
	('2014', '1.0', 2016, 'LDA', 'Elec', 361065.7688),
	('2014', '1.0', 2016, 'LDT1', 'Gas', 3819079.06131335),
	('2014', '1.0', 2016, 'LDT2', 'Gas', 15191198.6715159),
	('2014', '1.0', 2016, 'MDV', 'Gas', 9503697.60677983),
	('2014', '1.0', 2016, 'LHD1', 'Gas', 871997.976708303),
	('2014', '1.0', 2016, 'LHD2', 'Gas', 158011.570350224),
	('2014', '1.0', 2016, 'T6TS', 'Gas', 130292.240587274),
	('2014', '1.0', 2016, 'T7IS', 'Gas', 15823.2389216182),
	('2014', '1.0', 2016, 'LDT1', 'Dsl', 4626.51039492335),
	('2014', '1.0', 2016, 'LDT2', 'Dsl', 23278.763103949),
	('2014', '1.0', 2016, 'MDV', 'Dsl', 118354.328689985),
	('2014', '1.0', 2016, 'LHD1', 'Dsl', 822600.359829786),
	('2014', '1.0', 2016, 'LHD2', 'Dsl', 289554.295195844),
	('2014', '1.0', 2016, 'LDT1', 'Elec', 1226.726986),
	('2014', '1.0', 2016, 'UBUS', 'Gas', 51061.3987570125),
	('2014', '1.0', 2016, 'SBUS', 'Gas', 13048.9122722549),
	('2014', '1.0', 2016, 'OBUS', 'Gas', 78345.6206138285),
	('2014', '1.0', 2016, 'UBUS', 'Dsl', 131235.774521707),
	('2014', '1.0', 2016, 'MCY', 'Gas', 519051.304688517),
	('2014', '1.0', 2016, 'MH', 'Gas', 105400.84269778),
	('2014', '1.0', 2016, 'MH', 'Dsl', 25059.8493878083),
	('2014', '1.0', 2016, 'T6 Ag', 'Dsl', 3928.58633777122),
	('2014', '1.0', 2016, 'T6 Public', 'Dsl', 34896.2868149329),
	('2014', '1.0', 2016, 'T6 CAIRP Small', 'Dsl', 5588.7593863279),
	('2014', '1.0', 2016, 'T6 CAIRP Heavy', 'Dsl', 1820.58915998585),
	('2014', '1.0', 2016, 'T6 Instate Construction Small', 'Dsl', 101250.782925016),
	('2014', '1.0', 2016, 'T6 Instate Construction Heavy', 'Dsl', 37690.2688608889),
	('2014', '1.0', 2016, 'T6 Instate Small', 'Dsl', 575058.262258837),
	('2014', '1.0', 2016, 'T6 Instate Heavy', 'Dsl', 223541.362684953),
	('2014', '1.0', 2016, 'T6 OOS Small', 'Dsl', 3202.14909387798),
	('2014', '1.0', 2016, 'T6 OOS Heavy', 'Dsl', 1043.12916802869),
	('2014', '1.0', 2016, 'T6 Utility', 'Dsl', 4845.49741376434),
	('2014', '1.0', 2016, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2016, 'T7 Public', 'Dsl', 30181.8458359344),
	('2014', '1.0', 2016, 'PTO', 'Dsl', 27520.8470944743),
	('2014', '1.0', 2016, 'T7 CAIRP', 'Dsl', 278500.099616451),
	('2014', '1.0', 2016, 'T7 CAIRP Construction', 'Dsl', 26737.1895323611),
	('2014', '1.0', 2016, 'T7 Utility', 'Dsl', 2489.15210649718),
	('2014', '1.0', 2016, 'T7 NNOOS', 'Dsl', 345340.470043116),
	('2014', '1.0', 2016, 'T7 NOOS', 'Dsl', 110007.457219493),
	('2014', '1.0', 2016, 'T7 Other Port', 'Dsl', 72845.3468954483),
	('2014', '1.0', 2016, 'T7 POLA', 'Dsl', 29634.6936254156),
	('2014', '1.0', 2016, 'T7 Single', 'Dsl', 138600.48692929),
	('2014', '1.0', 2016, 'T7 Single Construction', 'Dsl', 69165.5914162094),
	('2014', '1.0', 2016, 'T7 Tractor', 'Dsl', 413512.272205298),
	('2014', '1.0', 2016, 'T7 Tractor Construction', 'Dsl', 51568.0604271223),
	('2014', '1.0', 2016, 'T7 SWCV', 'Dsl', 65616.3452535721),
	('2014', '1.0', 2016, 'SBUS', 'Dsl', 43271.0655343951),
	('2014', '1.0', 2016, 'Motor Coach', 'Dsl', 26910.9556900688),
	('2014', '1.0', 2016, 'All Other Buses', 'Dsl', 39743.2555554817),
	('2014', '1.0', 2017, 'LDA', 'Gas', 44179602.3522944),
	('2014', '1.0', 2017, 'LDA', 'Dsl', 461703.192858792),
	('2014', '1.0', 2017, 'LDA', 'Elec', 459468.859211156),
	('2014', '1.0', 2017, 'LDT1', 'Gas', 3754424.42924429),
	('2014', '1.0', 2017, 'LDT2', 'Gas', 15294622.901609),
	('2014', '1.0', 2017, 'MDV', 'Gas', 9417997.52090453),
	('2014', '1.0', 2017, 'LHD1', 'Gas', 812630.960504969),
	('2014', '1.0', 2017, 'LHD2', 'Gas', 156371.933522921),
	('2014', '1.0', 2017, 'T6TS', 'Gas', 134534.541208634),
	('2014', '1.0', 2017, 'T7IS', 'Gas', 16383.1930439717),
	('2014', '1.0', 2017, 'LDT1', 'Dsl', 4371.10261439934),
	('2014', '1.0', 2017, 'LDT2', 'Dsl', 25189.4715400808),
	('2014', '1.0', 2017, 'MDV', 'Dsl', 133039.139046432),
	('2014', '1.0', 2017, 'LHD1', 'Dsl', 817208.471588187),
	('2014', '1.0', 2017, 'LHD2', 'Dsl', 297507.852355986),
	('2014', '1.0', 2017, 'LDT1', 'Elec', 1248.27149892768),
	('2014', '1.0', 2017, 'UBUS', 'Gas', 53301.1176229663),
	('2014', '1.0', 2017, 'SBUS', 'Gas', 13848.819047245),
	('2014', '1.0', 2017, 'OBUS', 'Gas', 80946.6887330535),
	('2014', '1.0', 2017, 'UBUS', 'Dsl', 126235.497924388),
	('2014', '1.0', 2017, 'MCY', 'Gas', 518937.441235234),
	('2014', '1.0', 2017, 'MH', 'Gas', 99840.389862293),
	('2014', '1.0', 2017, 'MH', 'Dsl', 24361.884089354),
	('2014', '1.0', 2017, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2017, 'T6 Public', 'Dsl', 35391.4490999579),
	('2014', '1.0', 2017, 'T6 CAIRP Small', 'Dsl', 5779.99177668877),
	('2014', '1.0', 2017, 'T6 CAIRP Heavy', 'Dsl', 1882.88484904001),
	('2014', '1.0', 2017, 'T6 Instate Construction Small', 'Dsl', 99468.3003179174),
	('2014', '1.0', 2017, 'T6 Instate Construction Heavy', 'Dsl', 37026.7456094073),
	('2014', '1.0', 2017, 'T6 Instate Small', 'Dsl', 600087.145413497),
	('2014', '1.0', 2017, 'T6 Instate Heavy', 'Dsl', 232253.908145976),
	('2014', '1.0', 2017, 'T6 OOS Small', 'Dsl', 3311.71806673665),
	('2014', '1.0', 2017, 'T6 OOS Heavy', 'Dsl', 1078.82225668541),
	('2014', '1.0', 2017, 'T6 Utility', 'Dsl', 4896.38676716811),
	('2014', '1.0', 2017, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2017, 'T7 Public', 'Dsl', 30303.0319393219),
	('2014', '1.0', 2017, 'PTO', 'Dsl', 28405.1281995013),
	('2014', '1.0', 2017, 'T7 CAIRP', 'Dsl', 288029.627743155),
	('2014', '1.0', 2017, 'T7 CAIRP Construction', 'Dsl', 26266.4911937671),
	('2014', '1.0', 2017, 'T7 Utility', 'Dsl', 2515.2941782819),
	('2014', '1.0', 2017, 'T7 NNOOS', 'Dsl', 357157.096777173),
	('2014', '1.0', 2017, 'T7 NOOS', 'Dsl', 113771.618019306),
	('2014', '1.0', 2017, 'T7 Other Port', 'Dsl', 75897.1762458404),
	('2014', '1.0', 2017, 'T7 POLA', 'Dsl', 31265.1548263392),
	('2014', '1.0', 2017, 'T7 Single', 'Dsl', 143053.903327354),
	('2014', '1.0', 2017, 'T7 Single Construction', 'Dsl', 67947.9567456659),
	('2014', '1.0', 2017, 'T7 Tractor', 'Dsl', 427919.110900353),
	('2014', '1.0', 2017, 'T7 Tractor Construction', 'Dsl', 50660.2237848982),
	('2014', '1.0', 2017, 'T7 SWCV', 'Dsl', 67133.6791794598),
	('2014', '1.0', 2017, 'SBUS', 'Dsl', 44888.6499855504),
	('2014', '1.0', 2017, 'Motor Coach', 'Dsl', 27831.7765785288),
	('2014', '1.0', 2017, 'All Other Buses', 'Dsl', 39551.0883919118),
	('2014', '1.0', 2018, 'LDA', 'Gas', 45109707.9648538),
	('2014', '1.0', 2018, 'LDA', 'Dsl', 489909.23709901),
	('2014', '1.0', 2018, 'LDA', 'Elec', 666112.511668884),
	('2014', '1.0', 2018, 'LDT1', 'Gas', 3663178.15174991),
	('2014', '1.0', 2018, 'LDT2', 'Gas', 15233244.7531527),
	('2014', '1.0', 2018, 'MDV', 'Gas', 9243704.16592251),
	('2014', '1.0', 2018, 'LHD1', 'Gas', 750542.440141126),
	('2014', '1.0', 2018, 'LHD2', 'Gas', 153163.9706149),
	('2014', '1.0', 2018, 'T6TS', 'Gas', 137679.048159245),
	('2014', '1.0', 2018, 'T7IS', 'Gas', 16882.231833576),
	('2014', '1.0', 2018, 'LDT1', 'Dsl', 4094.70823532771),
	('2014', '1.0', 2018, 'LDT2', 'Dsl', 26718.6339567531),
	('2014', '1.0', 2018, 'MDV', 'Dsl', 145758.654112351),
	('2014', '1.0', 2018, 'LHD1', 'Dsl', 803314.856891975),
	('2014', '1.0', 2018, 'LHD2', 'Dsl', 301820.698631761),
	('2014', '1.0', 2018, 'LDT1', 'Elec', 1257.60420615233),
	('2014', '1.0', 2018, 'UBUS', 'Gas', 54911.9057884603),
	('2014', '1.0', 2018, 'SBUS', 'Gas', 14529.7477117067),
	('2014', '1.0', 2018, 'OBUS', 'Gas', 82785.5649788627),
	('2014', '1.0', 2018, 'UBUS', 'Dsl', 120166.071145902),
	('2014', '1.0', 2018, 'MCY', 'Gas', 514554.42361694),
	('2014', '1.0', 2018, 'MH', 'Gas', 93556.2095788147),
	('2014', '1.0', 2018, 'MH', 'Dsl', 23411.8219331489),
	('2014', '1.0', 2018, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2018, 'T6 Public', 'Dsl', 35840.8469711171),
	('2014', '1.0', 2018, 'T6 CAIRP Small', 'Dsl', 5975.01190006232),
	('2014', '1.0', 2018, 'T6 CAIRP Heavy', 'Dsl', 1946.41442654545),
	('2014', '1.0', 2018, 'T6 Instate Construction Small', 'Dsl', 97238.0464224185),
	('2014', '1.0', 2018, 'T6 Instate Construction Heavy', 'Dsl', 36196.54097769),
	('2014', '1.0', 2018, 'T6 Instate Small', 'Dsl', 625514.786212179),
	('2014', '1.0', 2018, 'T6 Instate Heavy', 'Dsl', 241468.452687236),
	('2014', '1.0', 2018, 'T6 OOS Small', 'Dsl', 3423.45726826255),
	('2014', '1.0', 2018, 'T6 OOS Heavy', 'Dsl', 1115.22231705322),
	('2014', '1.0', 2018, 'T6 Utility', 'Dsl', 4948.25313543844),
	('2014', '1.0', 2018, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2018, 'T7 Public', 'Dsl', 30465.6788996015),
	('2014', '1.0', 2018, 'PTO', 'Dsl', 29275.3283585551),
	('2014', '1.0', 2018, 'T7 CAIRP', 'Dsl', 297747.90688747),
	('2014', '1.0', 2018, 'T7 CAIRP Construction', 'Dsl', 25677.5503541353),
	('2014', '1.0', 2018, 'T7 Utility', 'Dsl', 2541.93814665339),
	('2014', '1.0', 2018, 'T7 NNOOS', 'Dsl', 369207.775007917),
	('2014', '1.0', 2018, 'T7 NOOS', 'Dsl', 117610.335415414),
	('2014', '1.0', 2018, 'T7 Other Port', 'Dsl', 78873.0203555734),
	('2014', '1.0', 2018, 'T7 POLA', 'Dsl', 32895.6160272628),
	('2014', '1.0', 2018, 'T7 Single', 'Dsl', 147436.405266947),
	('2014', '1.0', 2018, 'T7 Single Construction', 'Dsl', 66424.4442825118),
	('2014', '1.0', 2018, 'T7 Tractor', 'Dsl', 442711.24420074),
	('2014', '1.0', 2018, 'T7 Tractor Construction', 'Dsl', 49524.3326408657),
	('2014', '1.0', 2018, 'T7 SWCV', 'Dsl', 68528.4787659308),
	('2014', '1.0', 2018, 'SBUS', 'Dsl', 45023.3069801769),
	('2014', '1.0', 2018, 'Motor Coach', 'Dsl', 28770.8361328938),
	('2014', '1.0', 2018, 'All Other Buses', 'Dsl', 39179.5617098976),
	('2014', '1.0', 2019, 'LDA', 'Gas', 45872559.3398017),
	('2014', '1.0', 2019, 'LDA', 'Dsl', 515767.315915888),
	('2014', '1.0', 2019, 'LDA', 'Elec', 992624.920118956),
	('2014', '1.0', 2019, 'LDT1', 'Gas', 3589856.42906383),
	('2014', '1.0', 2019, 'LDT2', 'Gas', 15178788.4238551),
	('2014', '1.0', 2019, 'MDV', 'Gas', 9088628.54988983),
	('2014', '1.0', 2019, 'LHD1', 'Gas', 696046.596364324),
	('2014', '1.0', 2019, 'LHD2', 'Gas', 150284.51403862),
	('2014', '1.0', 2019, 'T6TS', 'Gas', 141107.720425471),
	('2014', '1.0', 2019, 'T7IS', 'Gas', 17445.2213679086),
	('2014', '1.0', 2019, 'LDT1', 'Dsl', 3841.61038039071),
	('2014', '1.0', 2019, 'LDT2', 'Dsl', 28188.4482956205),
	('2014', '1.0', 2019, 'MDV', 'Dsl', 157638.594508229),
	('2014', '1.0', 2019, 'LHD1', 'Dsl', 789976.270491345),
	('2014', '1.0', 2019, 'LHD2', 'Dsl', 305880.494311805),
	('2014', '1.0', 2019, 'LDT1', 'Elec', 1270.20307406143),
	('2014', '1.0', 2019, 'UBUS', 'Gas', 56375.9400668056),
	('2014', '1.0', 2019, 'SBUS', 'Gas', 15258.2634109211),
	('2014', '1.0', 2019, 'OBUS', 'Gas', 84344.0392134418),
	('2014', '1.0', 2019, 'UBUS', 'Dsl', 113661.313034587),
	('2014', '1.0', 2019, 'MCY', 'Gas', 511431.003816245),
	('2014', '1.0', 2019, 'MH', 'Gas', 88050.6745304077),
	('2014', '1.0', 2019, 'MH', 'Dsl', 22476.6286066651),
	('2014', '1.0', 2019, 'T6 Ag', 'Dsl', 3928.58633777124),
	('2014', '1.0', 2019, 'T6 Public', 'Dsl', 36270.6246878502),
	('2014', '1.0', 2019, 'T6 CAIRP Small', 'Dsl', 6213.43734679054),
	('2014', '1.0', 2019, 'T6 CAIRP Heavy', 'Dsl', 2024.08368259538),
	('2014', '1.0', 2019, 'T6 Instate Construction Small', 'Dsl', 94560.0212385214),
	('2014', '1.0', 2019, 'T6 Instate Construction Heavy', 'Dsl', 35199.6549657356),
	('2014', '1.0', 2019, 'T6 Instate Small', 'Dsl', 655687.241911247),
	('2014', '1.0', 2019, 'T6 Instate Heavy', 'Dsl', 253157.483573342),
	('2014', '1.0', 2019, 'T6 OOS Small', 'Dsl', 3560.0660888294),
	('2014', '1.0', 2019, 'T6 OOS Heavy', 'Dsl', 1159.72388183536),
	('2014', '1.0', 2019, 'T6 Utility', 'Dsl', 5000.86523497357),
	('2014', '1.0', 2019, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2019, 'T7 Public', 'Dsl', 30644.2213766406),
	('2014', '1.0', 2019, 'PTO', 'Dsl', 30368.5083268172),
	('2014', '1.0', 2019, 'T7 CAIRP', 'Dsl', 309629.168196973),
	('2014', '1.0', 2019, 'T7 CAIRP Construction', 'Dsl', 24970.3670134659),
	('2014', '1.0', 2019, 'T7 Utility', 'Dsl', 2568.96520026673),
	('2014', '1.0', 2019, 'T7 NNOOS', 'Dsl', 383940.553814747),
	('2014', '1.0', 2019, 'T7 NOOS', 'Dsl', 122303.430128913),
	('2014', '1.0', 2019, 'T7 Other Port', 'Dsl', 82831.2956446969),
	('2014', '1.0', 2019, 'T7 POLA', 'Dsl', 34526.0772281863),
	('2014', '1.0', 2019, 'T7 Single', 'Dsl', 152941.878095685),
	('2014', '1.0', 2019, 'T7 Single Construction', 'Dsl', 64595.0540267445),
	('2014', '1.0', 2019, 'T7 Tractor', 'Dsl', 460785.506907221),
	('2014', '1.0', 2019, 'T7 Tractor Construction', 'Dsl', 48160.3869950243),
	('2014', '1.0', 2019, 'T7 SWCV', 'Dsl', 69993.0725486687),
	('2014', '1.0', 2019, 'SBUS', 'Dsl', 45156.6096511292),
	('2014', '1.0', 2019, 'Motor Coach', 'Dsl', 29918.9007012101),
	('2014', '1.0', 2019, 'All Other Buses', 'Dsl', 39550.8493543593),
	('2014', '1.0', 2020, 'LDA', 'Gas', 46477370.3052946),
	('2014', '1.0', 2020, 'LDA', 'Dsl', 538420.329353311),
	('2014', '1.0', 2020, 'LDA', 'Elec', 1411897.27979924),
	('2014', '1.0', 2020, 'LDT1', 'Gas', 3527546.68023022),
	('2014', '1.0', 2020, 'LDT2', 'Gas', 15153592.8948958),
	('2014', '1.0', 2020, 'MDV', 'Gas', 8951665.34842478),
	('2014', '1.0', 2020, 'LHD1', 'Gas', 646438.91593793),
	('2014', '1.0', 2020, 'LHD2', 'Gas', 147807.929508414),
	('2014', '1.0', 2020, 'T6TS', 'Gas', 144534.91417192),
	('2014', '1.0', 2020, 'T7IS', 'Gas', 18029.7835723667),
	('2014', '1.0', 2020, 'LDT1', 'Dsl', 3620.17281016068),
	('2014', '1.0', 2020, 'LDT2', 'Dsl', 29442.8794211064),
	('2014', '1.0', 2020, 'MDV', 'Dsl', 168365.090178335),
	('2014', '1.0', 2020, 'LHD1', 'Dsl', 777102.187110278),
	('2014', '1.0', 2020, 'LHD2', 'Dsl', 309669.221307391),
	('2014', '1.0', 2020, 'LDT1', 'Elec', 1282.6929551445),
	('2014', '1.0', 2020, 'UBUS', 'Gas', 57900.5065073061),
	('2014', '1.0', 2020, 'SBUS', 'Gas', 16025.5311725526),
	('2014', '1.0', 2020, 'OBUS', 'Gas', 85997.5983690948),
	('2014', '1.0', 2020, 'UBUS', 'Dsl', 108695.77098302),
	('2014', '1.0', 2020, 'MCY', 'Gas', 508817.781208714),
	('2014', '1.0', 2020, 'MH', 'Gas', 83043.6876042318),
	('2014', '1.0', 2020, 'MH', 'Dsl', 21581.9626001239),
	('2014', '1.0', 2020, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2020, 'T6 Public', 'Dsl', 36668.3626313309),
	('2014', '1.0', 2020, 'T6 CAIRP Small', 'Dsl', 6437.72508520719),
	('2014', '1.0', 2020, 'T6 CAIRP Heavy', 'Dsl', 2097.14745168125),
	('2014', '1.0', 2020, 'T6 Instate Construction Small', 'Dsl', 91434.2247662234),
	('2014', '1.0', 2020, 'T6 Instate Construction Heavy', 'Dsl', 34036.0875735453),
	('2014', '1.0', 2020, 'T6 Instate Small', 'Dsl', 684747.322608806),
	('2014', '1.0', 2020, 'T6 Instate Heavy', 'Dsl', 264836.176316617),
	('2014', '1.0', 2020, 'T6 OOS Small', 'Dsl', 3688.57453385135),
	('2014', '1.0', 2020, 'T6 OOS Heavy', 'Dsl', 1201.58667566864),
	('2014', '1.0', 2020, 'T6 Utility', 'Dsl', 5054.01348903667),
	('2014', '1.0', 2020, 'T7 Ag', 'Dsl', 2922.3022458487),
	('2014', '1.0', 2020, 'T7 Public', 'Dsl', 30810.2573126309),
	('2014', '1.0', 2020, 'PTO', 'Dsl', 31430.4853088272),
	('2014', '1.0', 2020, 'T7 CAIRP', 'Dsl', 320805.916590292),
	('2014', '1.0', 2020, 'T7 CAIRP Construction', 'Dsl', 24144.9411717585),
	('2014', '1.0', 2020, 'T7 Utility', 'Dsl', 2596.2676786835),
	('2014', '1.0', 2020, 'T7 NNOOS', 'Dsl', 397799.73572893),
	('2014', '1.0', 2020, 'T7 NOOS', 'Dsl', 126718.242448278),
	('2014', '1.0', 2020, 'T7 Other Port', 'Dsl', 86658.7925898185),
	('2014', '1.0', 2020, 'T7 POLA', 'Dsl', 36156.5384291101),
	('2014', '1.0', 2020, 'T7 Single', 'Dsl', 158290.206448697),
	('2014', '1.0', 2020, 'T7 Single Construction', 'Dsl', 62459.785978365),
	('2014', '1.0', 2020, 'T7 Tractor', 'Dsl', 478144.832837156),
	('2014', '1.0', 2020, 'T7 Tractor Construction', 'Dsl', 46568.3868473741),
	('2014', '1.0', 2020, 'T7 SWCV', 'Dsl', 71432.9547422583),
	('2014', '1.0', 2020, 'SBUS', 'Dsl', 45288.8208880947),
	('2014', '1.0', 2020, 'Motor Coach', 'Dsl', 30998.8894738743),
	('2014', '1.0', 2020, 'All Other Buses', 'Dsl', 39534.1053746632),
	('2014', '1.0', 2021, 'LDA', 'Gas', 46943610.9456067),
	('2014', '1.0', 2021, 'LDA', 'Dsl', 558069.370798338),
	('2014', '1.0', 2021, 'LDA', 'Elec', 1907231.66327277),
	('2014', '1.0', 2021, 'LDT1', 'Gas', 3476182.52978266),
	('2014', '1.0', 2021, 'LDT2', 'Gas', 15157119.193385),
	('2014', '1.0', 2021, 'MDV', 'Gas', 8833465.29241256),
	('2014', '1.0', 2021, 'LHD1', 'Gas', 602303.387054929),
	('2014', '1.0', 2021, 'LHD2', 'Gas', 145577.204018672),
	('2014', '1.0', 2021, 'T6TS', 'Gas', 148008.727688536),
	('2014', '1.0', 2021, 'T7IS', 'Gas', 18678.574416938),
	('2014', '1.0', 2021, 'LDT1', 'Dsl', 3419.4752070833),
	('2014', '1.0', 2021, 'LDT2', 'Dsl', 30570.6471867714),
	('2014', '1.0', 2021, 'MDV', 'Dsl', 177976.505503728),
	('2014', '1.0', 2021, 'LHD1', 'Dsl', 764994.426969598),
	('2014', '1.0', 2021, 'LHD2', 'Dsl', 313081.690422976),
	('2014', '1.0', 2021, 'LDT1', 'Elec', 1289.72063686202),
	('2014', '1.0', 2021, 'UBUS', 'Gas', 59315.293528418),
	('2014', '1.0', 2021, 'SBUS', 'Gas', 16816.6197160019),
	('2014', '1.0', 2021, 'OBUS', 'Gas', 87395.1678734925),
	('2014', '1.0', 2021, 'UBUS', 'Dsl', 104740.794627761),
	('2014', '1.0', 2021, 'MCY', 'Gas', 506605.813929469),
	('2014', '1.0', 2021, 'MH', 'Gas', 78492.7207253635),
	('2014', '1.0', 2021, 'MH', 'Dsl', 20730.586884098),
	('2014', '1.0', 2021, 'T6 Ag', 'Dsl', 3928.58633777122),
	('2014', '1.0', 2021, 'T6 Public', 'Dsl', 37037.119397169),
	('2014', '1.0', 2021, 'T6 CAIRP Small', 'Dsl', 6652.67227544794),
	('2014', '1.0', 2021, 'T6 CAIRP Heavy', 'Dsl', 2167.16845231316),
	('2014', '1.0', 2021, 'T6 Instate Construction Small', 'Dsl', 93153.232803792),
	('2014', '1.0', 2021, 'T6 Instate Construction Heavy', 'Dsl', 34675.9826265835),
	('2014', '1.0', 2021, 'T6 Instate Small', 'Dsl', 713680.030158043),
	('2014', '1.0', 2021, 'T6 Instate Heavy', 'Dsl', 276589.667450385),
	('2014', '1.0', 2021, 'T6 OOS Small', 'Dsl', 3811.7311958012),
	('2014', '1.0', 2021, 'T6 OOS Heavy', 'Dsl', 1241.70607752989),
	('2014', '1.0', 2021, 'T6 Utility', 'Dsl', 5107.50853120404),
	('2014', '1.0', 2021, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2021, 'T7 Public', 'Dsl', 30879.8326388843),
	('2014', '1.0', 2021, 'PTO', 'Dsl', 32436.6673169214),
	('2014', '1.0', 2021, 'T7 CAIRP', 'Dsl', 331517.205045611),
	('2014', '1.0', 2021, 'T7 CAIRP Construction', 'Dsl', 24598.8778464226),
	('2014', '1.0', 2021, 'T7 Utility', 'Dsl', 2623.74830358689),
	('2014', '1.0', 2021, 'T7 NNOOS', 'Dsl', 411081.746740851),
	('2014', '1.0', 2021, 'T7 NOOS', 'Dsl', 130949.198229396),
	('2014', '1.0', 2021, 'T7 Other Port', 'Dsl', 90382.8494164384),
	('2014', '1.0', 2021, 'T7 POLA', 'Dsl', 38425.6008727599),
	('2014', '1.0', 2021, 'T7 Single', 'Dsl', 163357.540160578),
	('2014', '1.0', 2021, 'T7 Single Construction', 'Dsl', 63634.060429711),
	('2014', '1.0', 2021, 'T7 Tractor', 'Dsl', 495009.963234401),
	('2014', '1.0', 2021, 'T7 Tractor Construction', 'Dsl', 47443.8952414344),
	('2014', '1.0', 2021, 'T7 SWCV', 'Dsl', 72925.3015502216),
	('2014', '1.0', 2021, 'SBUS', 'Dsl', 45420.3424385749),
	('2014', '1.0', 2021, 'Motor Coach', 'Dsl', 32033.901703319),
	('2014', '1.0', 2021, 'All Other Buses', 'Dsl', 39602.6628607944),
	('2014', '1.0', 2022, 'LDA', 'Gas', 47200227.7243563),
	('2014', '1.0', 2022, 'LDA', 'Dsl', 573988.727867624),
	('2014', '1.0', 2022, 'LDA', 'Elec', 2453981.95492655),
	('2014', '1.0', 2022, 'LDT1', 'Gas', 3429502.53223169),
	('2014', '1.0', 2022, 'LDT2', 'Gas', 15161162.3281413),
	('2014', '1.0', 2022, 'MDV', 'Gas', 8719960.00094091),
	('2014', '1.0', 2022, 'LHD1', 'Gas', 562420.112480737),
	('2014', '1.0', 2022, 'LHD2', 'Gas', 143669.159124997),
	('2014', '1.0', 2022, 'T6TS', 'Gas', 151421.383827642),
	('2014', '1.0', 2022, 'T7IS', 'Gas', 19334.2240008231),
	('2014', '1.0', 2022, 'LDT1', 'Dsl', 3243.02629802041),
	('2014', '1.0', 2022, 'LDT2', 'Dsl', 31419.6064074415),
	('2014', '1.0', 2022, 'MDV', 'Dsl', 186245.002133443),
	('2014', '1.0', 2022, 'LHD1', 'Dsl', 753461.119511486),
	('2014', '1.0', 2022, 'LHD2', 'Dsl', 316039.803003898),
	('2014', '1.0', 2022, 'LDT1', 'Elec', 1303.02362412211),
	('2014', '1.0', 2022, 'UBUS', 'Gas', 60679.9535200481),
	('2014', '1.0', 2022, 'SBUS', 'Gas', 17615.6555907953),
	('2014', '1.0', 2022, 'OBUS', 'Gas', 88804.3548114624),
	('2014', '1.0', 2022, 'UBUS', 'Dsl', 101443.062860469),
	('2014', '1.0', 2022, 'MCY', 'Gas', 504731.8099328),
	('2014', '1.0', 2022, 'MH', 'Gas', 74246.4379464555),
	('2014', '1.0', 2022, 'MH', 'Dsl', 19917.7632232316),
	('2014', '1.0', 2022, 'T6 Ag', 'Dsl', 3928.58633777121),
	('2014', '1.0', 2022, 'T6 Public', 'Dsl', 37359.5844658412),
	('2014', '1.0', 2022, 'T6 CAIRP Small', 'Dsl', 6840.63287544809),
	('2014', '1.0', 2022, 'T6 CAIRP Heavy', 'Dsl', 2228.39832592373),
	('2014', '1.0', 2022, 'T6 Instate Construction Small', 'Dsl', 94776.9579993118),
	('2014', '1.0', 2022, 'T6 Instate Construction Heavy', 'Dsl', 35280.4089570019),
	('2014', '1.0', 2022, 'T6 Instate Small', 'Dsl', 739396.254652392),
	('2014', '1.0', 2022, 'T6 Instate Heavy', 'Dsl', 287460.060940488),
	('2014', '1.0', 2022, 'T6 OOS Small', 'Dsl', 3919.42555574228),
	('2014', '1.0', 2022, 'T6 OOS Heavy', 'Dsl', 1276.78849399247),
	('2014', '1.0', 2022, 'T6 Utility', 'Dsl', 5161.18082092978),
	('2014', '1.0', 2022, 'T7 Ag', 'Dsl', 2922.3022458487),
	('2014', '1.0', 2022, 'T7 Public', 'Dsl', 30965.9525932595),
	('2014', '1.0', 2022, 'PTO', 'Dsl', 33341.2440705126),
	('2014', '1.0', 2022, 'T7 CAIRP', 'Dsl', 340883.692705121),
	('2014', '1.0', 2022, 'T7 CAIRP Construction', 'Dsl', 25027.6532795295),
	('2014', '1.0', 2022, 'T7 Utility', 'Dsl', 2651.31998129576),
	('2014', '1.0', 2022, 'T7 NNOOS', 'Dsl', 422696.203092727),
	('2014', '1.0', 2022, 'T7 NOOS', 'Dsl', 134648.958092747),
	('2014', '1.0', 2022, 'T7 Other Port', 'Dsl', 93468.521358634),
	('2014', '1.0', 2022, 'T7 POLA', 'Dsl', 40694.6633164097),
	('2014', '1.0', 2022, 'T7 Single', 'Dsl', 167913.169501574),
	('2014', '1.0', 2022, 'T7 Single Construction', 'Dsl', 64743.2460597),
	('2014', '1.0', 2022, 'T7 Tractor', 'Dsl', 509872.451108746),
	('2014', '1.0', 2022, 'T7 Tractor Construction', 'Dsl', 48270.8751084605),
	('2014', '1.0', 2022, 'T7 SWCV', 'Dsl', 74267.0874446277),
	('2014', '1.0', 2022, 'SBUS', 'Dsl', 45553.939006468),
	('2014', '1.0', 2022, 'Motor Coach', 'Dsl', 32938.968289377),
	('2014', '1.0', 2022, 'All Other Buses', 'Dsl', 39826.0852461426),
	('2014', '1.0', 2023, 'LDA', 'Gas', 47419862.693897),
	('2014', '1.0', 2023, 'LDA', 'Dsl', 588372.318144816),
	('2014', '1.0', 2023, 'LDA', 'Elec', 3057843.56861078),
	('2014', '1.0', 2023, 'LDT1', 'Gas', 3396130.68847452),
	('2014', '1.0', 2023, 'LDT2', 'Gas', 15213817.1311862),
	('2014', '1.0', 2023, 'MDV', 'Gas', 8638383.42429831),
	('2014', '1.0', 2023, 'LHD1', 'Gas', 526831.396591764),
	('2014', '1.0', 2023, 'LHD2', 'Gas', 141997.596747828),
	('2014', '1.0', 2023, 'T6TS', 'Gas', 154755.892051671),
	('2014', '1.0', 2023, 'T7IS', 'Gas', 19982.9140066915),
	('2014', '1.0', 2023, 'LDT1', 'Dsl', 3096.0533981364),
	('2014', '1.0', 2023, 'LDT2', 'Dsl', 32185.7649174534),
	('2014', '1.0', 2023, 'MDV', 'Dsl', 193895.564133549),
	('2014', '1.0', 2023, 'LHD1', 'Dsl', 742843.353645507),
	('2014', '1.0', 2023, 'LHD2', 'Dsl', 318520.881638765),
	('2014', '1.0', 2023, 'LDT1', 'Elec', 1319.21340063239),
	('2014', '1.0', 2023, 'UBUS', 'Gas', 61819.0972367932),
	('2014', '1.0', 2023, 'SBUS', 'Gas', 18418.2174177266),
	('2014', '1.0', 2023, 'OBUS', 'Gas', 90155.4355568049),
	('2014', '1.0', 2023, 'UBUS', 'Dsl', 98141.5461611703),
	('2014', '1.0', 2023, 'MCY', 'Gas', 503137.347567115),
	('2014', '1.0', 2023, 'MH', 'Gas', 70317.3464898707),
	('2014', '1.0', 2023, 'MH', 'Dsl', 19144.5455339262),
	('2014', '1.0', 2023, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2023, 'T6 Public', 'Dsl', 37683.9389296817),
	('2014', '1.0', 2023, 'T6 CAIRP Small', 'Dsl', 7018.70915825111),
	('2014', '1.0', 2023, 'T6 CAIRP Heavy', 'Dsl', 2286.40829337999),
	('2014', '1.0', 2023, 'T6 Instate Construction Small', 'Dsl', 96305.4003527828),
	('2014', '1.0', 2023, 'T6 Instate Construction Heavy', 'Dsl', 35849.3665648001),
	('2014', '1.0', 2023, 'T6 Instate Small', 'Dsl', 763747.623446842),
	('2014', '1.0', 2023, 'T6 Instate Heavy', 'Dsl', 297953.218577928),
	('2014', '1.0', 2023, 'T6 OOS Small', 'Dsl', 4021.45657339779),
	('2014', '1.0', 2023, 'T6 OOS Heavy', 'Dsl', 1310.02602523785),
	('2014', '1.0', 2023, 'T6 Utility', 'Dsl', 5214.88066642899),
	('2014', '1.0', 2023, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2023, 'T7 Public', 'Dsl', 30950.9036662631),
	('2014', '1.0', 2023, 'PTO', 'Dsl', 34277.0341081097),
	('2014', '1.0', 2023, 'T7 CAIRP', 'Dsl', 349757.623227392),
	('2014', '1.0', 2023, 'T7 CAIRP Construction', 'Dsl', 25431.2674710791),
	('2014', '1.0', 2023, 'T7 Utility', 'Dsl', 2678.90581451964),
	('2014', '1.0', 2023, 'T7 NNOOS', 'Dsl', 433699.887981571),
	('2014', '1.0', 2023, 'T7 NOOS', 'Dsl', 138154.158032144),
	('2014', '1.0', 2023, 'T7 Other Port', 'Dsl', 95002.9029235967),
	('2014', '1.0', 2023, 'T7 POLA', 'Dsl', 42963.7257600596),
	('2014', '1.0', 2023, 'T7 Single', 'Dsl', 172625.995179843),
	('2014', '1.0', 2023, 'T7 Single Construction', 'Dsl', 65787.3428683315),
	('2014', '1.0', 2023, 'T7 Tractor', 'Dsl', 524285.859143293),
	('2014', '1.0', 2023, 'T7 Tractor Construction', 'Dsl', 49049.3264484523),
	('2014', '1.0', 2023, 'T7 SWCV', 'Dsl', 75585.7712489172),
	('2014', '1.0', 2023, 'SBUS', 'Dsl', 45689.9393589062),
	('2014', '1.0', 2023, 'Motor Coach', 'Dsl', 33796.4399793709),
	('2014', '1.0', 2023, 'All Other Buses', 'Dsl', 39919.4959182535),
	('2014', '1.0', 2024, 'LDA', 'Gas', 47541533.5577945),
	('2014', '1.0', 2024, 'LDA', 'Dsl', 600345.080096761),
	('2014', '1.0', 2024, 'LDA', 'Elec', 3698814.26143369),
	('2014', '1.0', 2024, 'LDT1', 'Gas', 3370470.64976954),
	('2014', '1.0', 2024, 'LDT2', 'Gas', 15287132.2674422),
	('2014', '1.0', 2024, 'MDV', 'Gas', 8576365.04894104),
	('2014', '1.0', 2024, 'LHD1', 'Gas', 495537.12311862),
	('2014', '1.0', 2024, 'LHD2', 'Gas', 140651.566325947),
	('2014', '1.0', 2024, 'T6TS', 'Gas', 158009.518023188),
	('2014', '1.0', 2024, 'T7IS', 'Gas', 20610.8787772347),
	('2014', '1.0', 2024, 'LDT1', 'Dsl', 2963.72666148761),
	('2014', '1.0', 2024, 'LDT2', 'Dsl', 32835.8839634694),
	('2014', '1.0', 2024, 'MDV', 'Dsl', 200750.942034245),
	('2014', '1.0', 2024, 'LHD1', 'Dsl', 733097.07730167),
	('2014', '1.0', 2024, 'LHD2', 'Dsl', 320654.833129821),
	('2014', '1.0', 2024, 'LDT1', 'Elec', 1325.52760303062),
	('2014', '1.0', 2024, 'UBUS', 'Gas', 62960.1179823605),
	('2014', '1.0', 2024, 'SBUS', 'Gas', 19210.4820836323),
	('2014', '1.0', 2024, 'OBUS', 'Gas', 91311.3294092667),
	('2014', '1.0', 2024, 'UBUS', 'Dsl', 95864.7940755069),
	('2014', '1.0', 2024, 'MCY', 'Gas', 501901.208693663),
	('2014', '1.0', 2024, 'MH', 'Gas', 66952.1824714206),
	('2014', '1.0', 2024, 'MH', 'Dsl', 18414.1432801473),
	('2014', '1.0', 2024, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2024, 'T6 Public', 'Dsl', 37981.7714990398),
	('2014', '1.0', 2024, 'T6 CAIRP Small', 'Dsl', 7117.84562130399),
	('2014', '1.0', 2024, 'T6 CAIRP Heavy', 'Dsl', 2318.70289715823),
	('2014', '1.0', 2024, 'T6 Instate Construction Small', 'Dsl', 97738.5598642062),
	('2014', '1.0', 2024, 'T6 Instate Construction Heavy', 'Dsl', 36382.8554499781),
	('2014', '1.0', 2024, 'T6 Instate Small', 'Dsl', 779125.349407431),
	('2014', '1.0', 2024, 'T6 Instate Heavy', 'Dsl', 305016.384665943),
	('2014', '1.0', 2024, 'T6 OOS Small', 'Dsl', 4078.25804102075),
	('2014', '1.0', 2024, 'T6 OOS Heavy', 'Dsl', 1328.52961952008),
	('2014', '1.0', 2024, 'T6 Utility', 'Dsl', 5268.47469153401),
	('2014', '1.0', 2024, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2024, 'T7 Public', 'Dsl', 30961.1620263259),
	('2014', '1.0', 2024, 'PTO', 'Dsl', 34780.0420068179),
	('2014', '1.0', 2024, 'T7 CAIRP', 'Dsl', 354697.809935625),
	('2014', '1.0', 2024, 'T7 CAIRP Construction', 'Dsl', 25809.7204210717),
	('2014', '1.0', 2024, 'T7 Utility', 'Dsl', 2706.43728736841),
	('2014', '1.0', 2024, 'T7 NNOOS', 'Dsl', 439825.725646517),
	('2014', '1.0', 2024, 'T7 NOOS', 'Dsl', 140105.530325047),
	('2014', '1.0', 2024, 'T7 Other Port', 'Dsl', 96818.6265015413),
	('2014', '1.0', 2024, 'T7 POLA', 'Dsl', 45232.7882037094),
	('2014', '1.0', 2024, 'T7 Single', 'Dsl', 175159.243500685),
	('2014', '1.0', 2024, 'T7 Single Construction', 'Dsl', 66766.3508556051),
	('2014', '1.0', 2024, 'T7 Tractor', 'Dsl', 532728.009092018),
	('2014', '1.0', 2024, 'T7 Tractor Construction', 'Dsl', 49779.2492614098),
	('2014', '1.0', 2024, 'T7 SWCV', 'Dsl', 76871.2599914861),
	('2014', '1.0', 2024, 'SBUS', 'Dsl', 45824.3467878981),
	('2014', '1.0', 2024, 'Motor Coach', 'Dsl', 34273.8011932053),
	('2014', '1.0', 2024, 'All Other Buses', 'Dsl', 39353.6798784434),
	('2014', '1.0', 2025, 'LDA', 'Gas', 47587916.8373453),
	('2014', '1.0', 2025, 'LDA', 'Dsl', 610522.55882162),
	('2014', '1.0', 2025, 'LDA', 'Elec', 4362999.30273061),
	('2014', '1.0', 2025, 'LDT1', 'Gas', 3351787.67502307),
	('2014', '1.0', 2025, 'LDT2', 'Gas', 15377108.9925014),
	('2014', '1.0', 2025, 'MDV', 'Gas', 8534402.66267022),
	('2014', '1.0', 2025, 'LHD1', 'Gas', 468069.795750459),
	('2014', '1.0', 2025, 'LHD2', 'Gas', 139572.070649092),
	('2014', '1.0', 2025, 'T6TS', 'Gas', 161145.594265312),
	('2014', '1.0', 2025, 'T7IS', 'Gas', 21202.3780694177),
	('2014', '1.0', 2025, 'LDT1', 'Dsl', 2803.10713446673),
	('2014', '1.0', 2025, 'LDT2', 'Dsl', 33384.9391530872),
	('2014', '1.0', 2025, 'MDV', 'Dsl', 206955.856394072),
	('2014', '1.0', 2025, 'LHD1', 'Dsl', 724642.354874594),
	('2014', '1.0', 2025, 'LHD2', 'Dsl', 322602.573968487),
	('2014', '1.0', 2025, 'LDT1', 'Elec', 1338.28194944701),
	('2014', '1.0', 2025, 'UBUS', 'Gas', 63912.5467743571),
	('2014', '1.0', 2025, 'SBUS', 'Gas', 19991.2601173306),
	('2014', '1.0', 2025, 'OBUS', 'Gas', 92464.3354352665),
	('2014', '1.0', 2025, 'UBUS', 'Dsl', 93377.9791787174),
	('2014', '1.0', 2025, 'MCY', 'Gas', 501031.335181827),
	('2014', '1.0', 2025, 'MH', 'Gas', 64191.892075194),
	('2014', '1.0', 2025, 'MH', 'Dsl', 17748.2635310609),
	('2014', '1.0', 2025, 'T6 Ag', 'Dsl', 3928.58633777122),
	('2014', '1.0', 2025, 'T6 Public', 'Dsl', 38271.3933116404),
	('2014', '1.0', 2025, 'T6 CAIRP Small', 'Dsl', 7216.98208435687),
	('2014', '1.0', 2025, 'T6 CAIRP Heavy', 'Dsl', 2350.99750093649),
	('2014', '1.0', 2025, 'T6 Instate Construction Small', 'Dsl', 97296.4570597357),
	('2014', '1.0', 2025, 'T6 Instate Construction Heavy', 'Dsl', 36218.2841441247),
	('2014', '1.0', 2025, 'T6 Instate Small', 'Dsl', 794019.535961944),
	('2014', '1.0', 2025, 'T6 Instate Heavy', 'Dsl', 311813.02450752),
	('2014', '1.0', 2025, 'T6 OOS Small', 'Dsl', 4135.05950864372),
	('2014', '1.0', 2025, 'T6 OOS Heavy', 'Dsl', 1347.03321380232),
	('2014', '1.0', 2025, 'T6 Utility', 'Dsl', 5321.84787228649),
	('2014', '1.0', 2025, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2025, 'T7 Public', 'Dsl', 30803.3622896822),
	('2014', '1.0', 2025, 'PTO', 'Dsl', 35256.5356528937),
	('2014', '1.0', 2025, 'T7 CAIRP', 'Dsl', 359637.996643858),
	('2014', '1.0', 2025, 'T7 CAIRP Construction', 'Dsl', 25692.9747907227),
	('2014', '1.0', 2025, 'T7 Utility', 'Dsl', 2733.85531155785),
	('2014', '1.0', 2025, 'T7 NNOOS', 'Dsl', 445951.563311466),
	('2014', '1.0', 2025, 'T7 NOOS', 'Dsl', 142056.90261795),
	('2014', '1.0', 2025, 'T7 Other Port', 'Dsl', 98649.9992663932),
	('2014', '1.0', 2025, 'T7 POLA', 'Dsl', 47501.8506473591),
	('2014', '1.0', 2025, 'T7 Single', 'Dsl', 177558.960745511),
	('2014', '1.0', 2025, 'T7 Single Construction', 'Dsl', 66464.3452705166),
	('2014', '1.0', 2025, 'T7 Tractor', 'Dsl', 540975.703034865),
	('2014', '1.0', 2025, 'T7 Tractor Construction', 'Dsl', 49554.0817765043),
	('2014', '1.0', 2025, 'T7 SWCV', 'Dsl', 78081.7878023427),
	('2014', '1.0', 2025, 'SBUS', 'Dsl', 45957.6346394587),
	('2014', '1.0', 2025, 'Motor Coach', 'Dsl', 34751.1624070398),
	('2014', '1.0', 2025, 'All Other Buses', 'Dsl', 39125.3078141994),
	('2014', '1.0', 2026, 'LDA', 'Gas', 47518288.5350541),
	('2014', '1.0', 2026, 'LDA', 'Dsl', 616981.990017419),
	('2014', '1.0', 2026, 'LDA', 'Elec', 4949434.02235479),
	('2014', '1.0', 2026, 'LDT1', 'Gas', 3331644.12124066),
	('2014', '1.0', 2026, 'LDT2', 'Gas', 15436548.8641627),
	('2014', '1.0', 2026, 'MDV', 'Gas', 8489901.38570791),
	('2014', '1.0', 2026, 'LHD1', 'Gas', 444554.291667102),
	('2014', '1.0', 2026, 'LHD2', 'Gas', 138815.060751793),
	('2014', '1.0', 2026, 'T6TS', 'Gas', 164145.645475965),
	('2014', '1.0', 2026, 'T7IS', 'Gas', 21749.5230383908),
	('2014', '1.0', 2026, 'LDT1', 'Dsl', 2633.84178721693),
	('2014', '1.0', 2026, 'LDT2', 'Dsl', 33713.9131158319),
	('2014', '1.0', 2026, 'MDV', 'Dsl', 211944.377573667),
	('2014', '1.0', 2026, 'LHD1', 'Dsl', 717478.899094099),
	('2014', '1.0', 2026, 'LHD2', 'Dsl', 324679.086985966),
	('2014', '1.0', 2026, 'LDT1', 'Elec', 1352.09648489792),
	('2014', '1.0', 2026, 'UBUS', 'Gas', 64703.6832904814),
	('2014', '1.0', 2026, 'SBUS', 'Gas', 20767.5610052069),
	('2014', '1.0', 2026, 'OBUS', 'Gas', 93481.5697109898),
	('2014', '1.0', 2026, 'UBUS', 'Dsl', 90155.6120548342),
	('2014', '1.0', 2026, 'MCY', 'Gas', 500602.409043498),
	('2014', '1.0', 2026, 'MH', 'Gas', 61737.1359182059),
	('2014', '1.0', 2026, 'MH', 'Dsl', 17146.8506279604),
	('2014', '1.0', 2026, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2026, 'T6 Public', 'Dsl', 38552.3756799212),
	('2014', '1.0', 2026, 'T6 CAIRP Small', 'Dsl', 7316.11854740975),
	('2014', '1.0', 2026, 'T6 CAIRP Heavy', 'Dsl', 2383.29210471473),
	('2014', '1.0', 2026, 'T6 Instate Construction Small', 'Dsl', 98180.0280118819),
	('2014', '1.0', 2026, 'T6 Instate Construction Heavy', 'Dsl', 36547.1905069403),
	('2014', '1.0', 2026, 'T6 Instate Small', 'Dsl', 808742.78207526),
	('2014', '1.0', 2026, 'T6 Instate Heavy', 'Dsl', 318537.692577164),
	('2014', '1.0', 2026, 'T6 OOS Small', 'Dsl', 4191.86097626668),
	('2014', '1.0', 2026, 'T6 OOS Heavy', 'Dsl', 1365.53680808456),
	('2014', '1.0', 2026, 'T6 Utility', 'Dsl', 5374.89986649531),
	('2014', '1.0', 2026, 'T7 Ag', 'Dsl', 2922.30224584868),
	('2014', '1.0', 2026, 'T7 Public', 'Dsl', 30637.2349038364),
	('2014', '1.0', 2026, 'PTO', 'Dsl', 35787.0506484436),
	('2014', '1.0', 2026, 'T7 CAIRP', 'Dsl', 364578.183352091),
	('2014', '1.0', 2026, 'T7 CAIRP Construction', 'Dsl', 25926.2984582575),
	('2014', '1.0', 2026, 'T7 Utility', 'Dsl', 2761.10834088848),
	('2014', '1.0', 2026, 'T7 NNOOS', 'Dsl', 452077.400976412),
	('2014', '1.0', 2026, 'T7 NOOS', 'Dsl', 144008.274910853),
	('2014', '1.0', 2026, 'T7 Other Port', 'Dsl', 100497.131661931),
	('2014', '1.0', 2026, 'T7 POLA', 'Dsl', 50135.4378893965),
	('2014', '1.0', 2026, 'T7 Single', 'Dsl', 180230.740304261),
	('2014', '1.0', 2026, 'T7 Single Construction', 'Dsl', 67067.9228992316),
	('2014', '1.0', 2026, 'T7 Tractor', 'Dsl', 549130.756501415),
	('2014', '1.0', 2026, 'T7 Tractor Construction', 'Dsl', 50004.0935091118),
	('2014', '1.0', 2026, 'T7 SWCV', 'Dsl', 79314.714393755),
	('2014', '1.0', 2026, 'SBUS', 'Dsl', 46089.0373881022),
	('2014', '1.0', 2026, 'Motor Coach', 'Dsl', 35228.5236208743),
	('2014', '1.0', 2026, 'All Other Buses', 'Dsl', 38939.4122466905),
	('2014', '1.0', 2030, 'LDA', 'Gas', 47786587.0719261),
	('2014', '1.0', 2030, 'LDA', 'Dsl', 640574.545947961),
	('2014', '1.0', 2030, 'LDA', 'Elec', 6819437.3444266),
	('2014', '1.0', 2030, 'LDT1', 'Gas', 3329391.11004832),
	('2014', '1.0', 2030, 'LDT2', 'Gas', 15864608.9522573),
	('2014', '1.0', 2030, 'MDV', 'Gas', 8526088.21630027),
	('2014', '1.0', 2030, 'LHD1', 'Gas', 380410.211470587),
	('2014', '1.0', 2030, 'LHD2', 'Gas', 138600.40344593),
	('2014', '1.0', 2030, 'T6TS', 'Gas', 174715.945666432),
	('2014', '1.0', 2030, 'T7IS', 'Gas', 23466.7385979223),
	('2014', '1.0', 2030, 'LDT1', 'Dsl', 1872.24075107995),
	('2014', '1.0', 2030, 'LDT2', 'Dsl', 34812.8654623428),
	('2014', '1.0', 2030, 'MDV', 'Dsl', 228716.075766619),
	('2014', '1.0', 2030, 'LHD1', 'Dsl', 703166.654169448),
	('2014', '1.0', 2030, 'LHD2', 'Dsl', 334565.621686019),
	('2014', '1.0', 2030, 'LDT1', 'Elec', 1405.43891539444),
	('2014', '1.0', 2030, 'UBUS', 'Gas', 68166.1853585003),
	('2014', '1.0', 2030, 'SBUS', 'Gas', 23773.0118674348),
	('2014', '1.0', 2030, 'OBUS', 'Gas', 97329.0458669687),
	('2014', '1.0', 2030, 'UBUS', 'Dsl', 82103.0139539401),
	('2014', '1.0', 2030, 'MCY', 'Gas', 503373.316758924),
	('2014', '1.0', 2030, 'MH', 'Gas', 54713.567329612),
	('2014', '1.0', 2030, 'MH', 'Dsl', 15379.252782547),
	('2014', '1.0', 2030, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2030, 'T6 Public', 'Dsl', 39599.3415930405),
	('2014', '1.0', 2030, 'T6 CAIRP Small', 'Dsl', 7712.66439962127),
	('2014', '1.0', 2030, 'T6 CAIRP Heavy', 'Dsl', 2512.47051982771),
	('2014', '1.0', 2030, 'T6 Instate Construction Small', 'Dsl', 101657.314129198),
	('2014', '1.0', 2030, 'T6 Instate Construction Heavy', 'Dsl', 37841.5987562564),
	('2014', '1.0', 2030, 'T6 Instate Small', 'Dsl', 862011.864825051),
	('2014', '1.0', 2030, 'T6 Instate Heavy', 'Dsl', 341613.46064481),
	('2014', '1.0', 2030, 'T6 OOS Small', 'Dsl', 4419.06684675854),
	('2014', '1.0', 2030, 'T6 OOS Heavy', 'Dsl', 1439.55118521351),
	('2014', '1.0', 2030, 'T6 Utility', 'Dsl', 5582.40631854939),
	('2014', '1.0', 2030, 'T7 Ag', 'Dsl', 2922.30224584868),
	('2014', '1.0', 2030, 'T7 Public', 'Dsl', 30705.4242749657),
	('2014', '1.0', 2030, 'PTO', 'Dsl', 37957.5596549897),
	('2014', '1.0', 2030, 'T7 CAIRP', 'Dsl', 384338.930185023),
	('2014', '1.0', 2030, 'T7 CAIRP Construction', 'Dsl', 26844.5418070106),
	('2014', '1.0', 2030, 'T7 Utility', 'Dsl', 2867.70526544259),
	('2014', '1.0', 2030, 'T7 NNOOS', 'Dsl', 476580.7516362),
	('2014', '1.0', 2030, 'T7 NOOS', 'Dsl', 151813.764082465),
	('2014', '1.0', 2030, 'T7 Other Port', 'Dsl', 108045.491366829),
	('2014', '1.0', 2030, 'T7 POLA', 'Dsl', 60669.7868575451),
	('2014', '1.0', 2030, 'T7 Single', 'Dsl', 191161.857510028),
	('2014', '1.0', 2030, 'T7 Single Construction', 'Dsl', 69443.2976260189),
	('2014', '1.0', 2030, 'T7 Tractor', 'Dsl', 581132.251682551),
	('2014', '1.0', 2030, 'T7 Tractor Construction', 'Dsl', 51775.1109317911),
	('2014', '1.0', 2030, 'T7 SWCV', 'Dsl', 83529.868336995),
	('2014', '1.0', 2030, 'SBUS', 'Dsl', 46570.8016311325),
	('2014', '1.0', 2030, 'Motor Coach', 'Dsl', 37137.9684762122),
	('2014', '1.0', 2030, 'All Other Buses', 'Dsl', 38624.9004697453),
	('2014', '1.0', 2032, 'LDA', 'Gas', 47990963.4438981),
	('2014', '1.0', 2032, 'LDA', 'Dsl', 650888.804075972),
	('2014', '1.0', 2032, 'LDA', 'Elec', 7491882.80018529),
	('2014', '1.0', 2032, 'LDT1', 'Gas', 3343379.27489916),
	('2014', '1.0', 2032, 'LDT2', 'Gas', 16076576.4396973),
	('2014', '1.0', 2032, 'MDV', 'Gas', 8600900.17994734),
	('2014', '1.0', 2032, 'LHD1', 'Gas', 362102.142924009),
	('2014', '1.0', 2032, 'LHD2', 'Gas', 139697.614715591),
	('2014', '1.0', 2032, 'T6TS', 'Gas', 179095.386404937),
	('2014', '1.0', 2032, 'T7IS', 'Gas', 24091.6521212759),
	('2014', '1.0', 2032, 'LDT1', 'Dsl', 1852.36795236596),
	('2014', '1.0', 2032, 'LDT2', 'Dsl', 35241.6404081664),
	('2014', '1.0', 2032, 'MDV', 'Dsl', 235251.500543521),
	('2014', '1.0', 2032, 'LHD1', 'Dsl', 702575.933592086),
	('2014', '1.0', 2032, 'LHD2', 'Dsl', 340224.820635471),
	('2014', '1.0', 2032, 'LDT1', 'Elec', 1439.97612115942),
	('2014', '1.0', 2032, 'UBUS', 'Gas', 69711.8480156559),
	('2014', '1.0', 2032, 'SBUS', 'Gas', 25213.7673553602),
	('2014', '1.0', 2032, 'OBUS', 'Gas', 99069.5140220569),
	('2014', '1.0', 2032, 'UBUS', 'Dsl', 80877.1191316105),
	('2014', '1.0', 2032, 'MCY', 'Gas', 507121.339068032),
	('2014', '1.0', 2032, 'MH', 'Gas', 52796.9446120002),
	('2014', '1.0', 2032, 'MH', 'Dsl', 14890.8247298729),
	('2014', '1.0', 2032, 'T6 Ag', 'Dsl', 3928.58633777122),
	('2014', '1.0', 2032, 'T6 Public', 'Dsl', 40120.9362946562),
	('2014', '1.0', 2032, 'T6 CAIRP Small', 'Dsl', 7910.93732572704),
	('2014', '1.0', 2032, 'T6 CAIRP Heavy', 'Dsl', 2577.0597273842),
	('2014', '1.0', 2032, 'T6 Instate Construction Small', 'Dsl', 109142.087861518),
	('2014', '1.0', 2032, 'T6 Instate Construction Heavy', 'Dsl', 40627.7810077357),
	('2014', '1.0', 2032, 'T6 Instate Small', 'Dsl', 887313.964777414),
	('2014', '1.0', 2032, 'T6 Instate Heavy', 'Dsl', 352093.348819257),
	('2014', '1.0', 2032, 'T6 OOS Small', 'Dsl', 4532.66978200447),
	('2014', '1.0', 2032, 'T6 OOS Heavy', 'Dsl', 1476.55837377798),
	('2014', '1.0', 2032, 'T6 Utility', 'Dsl', 5682.64977381548),
	('2014', '1.0', 2032, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2032, 'T7 Public', 'Dsl', 30752.0668576022),
	('2014', '1.0', 2032, 'PTO', 'Dsl', 39033.8955904171),
	('2014', '1.0', 2032, 'T7 CAIRP', 'Dsl', 394219.303601489),
	('2014', '1.0', 2032, 'T7 CAIRP Construction', 'Dsl', 28821.0382656707),
	('2014', '1.0', 2032, 'T7 Utility', 'Dsl', 2919.20074393141),
	('2014', '1.0', 2032, 'T7 NNOOS', 'Dsl', 488832.426966094),
	('2014', '1.0', 2032, 'T7 NOOS', 'Dsl', 155716.50866827),
	('2014', '1.0', 2032, 'T7 Other Port', 'Dsl', 111917.153135675),
	('2014', '1.0', 2032, 'T7 POLA', 'Dsl', 64995.8333789849),
	('2014', '1.0', 2032, 'T7 Single', 'Dsl', 196582.500422567),
	('2014', '1.0', 2032, 'T7 Single Construction', 'Dsl', 74556.2339101342),
	('2014', '1.0', 2032, 'T7 Tractor', 'Dsl', 596895.040455994),
	('2014', '1.0', 2032, 'T7 Tractor Construction', 'Dsl', 55587.1828285335),
	('2014', '1.0', 2032, 'T7 SWCV', 'Dsl', 85639.7666577668),
	('2014', '1.0', 2032, 'SBUS', 'Dsl', 46765.9277187145),
	('2014', '1.0', 2032, 'Motor Coach', 'Dsl', 38092.690903881),
	('2014', '1.0', 2032, 'All Other Buses', 'Dsl', 38777.281725661),
	('2014', '1.0', 2035, 'LDA', 'Gas', 48408570.2583729),
	('2014', '1.0', 2035, 'LDA', 'Dsl', 665027.105770658),
	('2014', '1.0', 2035, 'LDA', 'Elec', 8233397.43700278),
	('2014', '1.0', 2035, 'LDT1', 'Gas', 3378752.88003488),
	('2014', '1.0', 2035, 'LDT2', 'Gas', 16378273.4043412),
	('2014', '1.0', 2035, 'MDV', 'Gas', 8741809.62620017),
	('2014', '1.0', 2035, 'LHD1', 'Gas', 345136.839472689),
	('2014', '1.0', 2035, 'LHD2', 'Gas', 141927.950704305),
	('2014', '1.0', 2035, 'T6TS', 'Gas', 184607.517010469),
	('2014', '1.0', 2035, 'T7IS', 'Gas', 24830.5641142837),
	('2014', '1.0', 2035, 'LDT1', 'Dsl', 1874.33928230513),
	('2014', '1.0', 2035, 'LDT2', 'Dsl', 35919.4346481846),
	('2014', '1.0', 2035, 'MDV', 'Dsl', 243300.467184301),
	('2014', '1.0', 2035, 'LHD1', 'Dsl', 707069.416075168),
	('2014', '1.0', 2035, 'LHD2', 'Dsl', 348187.271585498),
	('2014', '1.0', 2035, 'LDT1', 'Elec', 1481.13940281916),
	('2014', '1.0', 2035, 'UBUS', 'Gas', 71917.5691049383),
	('2014', '1.0', 2035, 'SBUS', 'Gas', 27270.9091637599),
	('2014', '1.0', 2035, 'OBUS', 'Gas', 101446.802645298),
	('2014', '1.0', 2035, 'UBUS', 'Dsl', 79488.3329840073),
	('2014', '1.0', 2035, 'MCY', 'Gas', 514749.381883448),
	('2014', '1.0', 2035, 'MH', 'Gas', 51253.0535449531),
	('2014', '1.0', 2035, 'MH', 'Dsl', 14508.0379388716),
	('2014', '1.0', 2035, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2035, 'T6 Public', 'Dsl', 40937.207028471),
	('2014', '1.0', 2035, 'T6 CAIRP Small', 'Dsl', 8208.34671488568),
	('2014', '1.0', 2035, 'T6 CAIRP Heavy', 'Dsl', 2673.94353871894),
	('2014', '1.0', 2035, 'T6 Instate Construction Small', 'Dsl', 120792.704872446),
	('2014', '1.0', 2035, 'T6 Instate Construction Heavy', 'Dsl', 44964.6846330865),
	('2014', '1.0', 2035, 'T6 Instate Small', 'Dsl', 924383.366836715),
	('2014', '1.0', 2035, 'T6 Instate Heavy', 'Dsl', 366986.317086572),
	('2014', '1.0', 2035, 'T6 OOS Small', 'Dsl', 4703.07418487337),
	('2014', '1.0', 2035, 'T6 OOS Heavy', 'Dsl', 1532.06915662469),
	('2014', '1.0', 2035, 'T6 Utility', 'Dsl', 5828.11673835576),
	('2014', '1.0', 2035, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2035, 'T7 Public', 'Dsl', 30844.5413056471),
	('2014', '1.0', 2035, 'PTO', 'Dsl', 40648.1026892651),
	('2014', '1.0', 2035, 'T7 CAIRP', 'Dsl', 409039.863726188),
	('2014', '1.0', 2035, 'T7 CAIRP Construction', 'Dsl', 31897.6046505531),
	('2014', '1.0', 2035, 'T7 Utility', 'Dsl', 2993.92772659013),
	('2014', '1.0', 2035, 'T7 NNOOS', 'Dsl', 507209.939960935),
	('2014', '1.0', 2035, 'T7 NOOS', 'Dsl', 161570.625546979),
	('2014', '1.0', 2035, 'T7 Other Port', 'Dsl', 117849.084714346),
	('2014', '1.0', 2035, 'T7 POLA', 'Dsl', 71484.903161145),
	('2014', '1.0', 2035, 'T7 Single', 'Dsl', 204711.97002563),
	('2014', '1.0', 2035, 'T7 Single Construction', 'Dsl', 82514.9063534013),
	('2014', '1.0', 2035, 'T7 Tractor', 'Dsl', 620348.512251583),
	('2014', '1.0', 2035, 'T7 Tractor Construction', 'Dsl', 61520.9613601791),
	('2014', '1.0', 2035, 'T7 SWCV', 'Dsl', 88703.3812772072),
	('2014', '1.0', 2035, 'SBUS', 'Dsl', 46984.4031905381),
	('2014', '1.0', 2035, 'Motor Coach', 'Dsl', 39524.7745453844),
	('2014', '1.0', 2035, 'All Other Buses', 'Dsl', 39397.3231010727),
	('2014', '1.0', 2040, 'LDA', 'Gas', 49363216.4968083),
	('2014', '1.0', 2040, 'LDA', 'Dsl', 685436.635435044),
	('2014', '1.0', 2040, 'LDA', 'Elec', 8948393.82097683),
	('2014', '1.0', 2040, 'LDT1', 'Gas', 3455160.07988165),
	('2014', '1.0', 2040, 'LDT2', 'Gas', 16835632.1713115),
	('2014', '1.0', 2040, 'MDV', 'Gas', 8992380.00954148),
	('2014', '1.0', 2040, 'LHD1', 'Gas', 335176.531721659),
	('2014', '1.0', 2040, 'LHD2', 'Gas', 145971.759642308),
	('2014', '1.0', 2040, 'T6TS', 'Gas', 191875.959296988),
	('2014', '1.0', 2040, 'T7IS', 'Gas', 25767.4818176463),
	('2014', '1.0', 2040, 'LDT1', 'Dsl', 1920.4156606511),
	('2014', '1.0', 2040, 'LDT2', 'Dsl', 36983.4622454689),
	('2014', '1.0', 2040, 'MDV', 'Dsl', 253699.538129156),
	('2014', '1.0', 2040, 'LHD1', 'Dsl', 719459.316175938),
	('2014', '1.0', 2040, 'LHD2', 'Dsl', 359749.676234085),
	('2014', '1.0', 2040, 'LDT1', 'Elec', 1532.34197781194),
	('2014', '1.0', 2040, 'UBUS', 'Gas', 75151.0828805302),
	('2014', '1.0', 2040, 'SBUS', 'Gas', 30322.2412088052),
	('2014', '1.0', 2040, 'OBUS', 'Gas', 104974.194385037),
	('2014', '1.0', 2040, 'UBUS', 'Dsl', 77984.3392108103),
	('2014', '1.0', 2040, 'MCY', 'Gas', 528802.790484717),
	('2014', '1.0', 2040, 'MH', 'Gas', 50912.4914673983),
	('2014', '1.0', 2040, 'MH', 'Dsl', 14372.0111695892),
	('2014', '1.0', 2040, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2040, 'T6 Public', 'Dsl', 42323.0529359535),
	('2014', '1.0', 2040, 'T6 CAIRP Small', 'Dsl', 8704.02903015006),
	('2014', '1.0', 2040, 'T6 CAIRP Heavy', 'Dsl', 2835.41655761017),
	('2014', '1.0', 2040, 'T6 Instate Construction Small', 'Dsl', 142197.366534645),
	('2014', '1.0', 2040, 'T6 Instate Construction Heavy', 'Dsl', 52932.4990994903),
	('2014', '1.0', 2040, 'T6 Instate Small', 'Dsl', 983465.900700678),
	('2014', '1.0', 2040, 'T6 Instate Heavy', 'Dsl', 390366.323326952),
	('2014', '1.0', 2040, 'T6 OOS Small', 'Dsl', 4987.0815229882),
	('2014', '1.0', 2040, 'T6 OOS Heavy', 'Dsl', 1624.58712803589),
	('2014', '1.0', 2040, 'T6 Utility', 'Dsl', 6057.7846500253),
	('2014', '1.0', 2040, 'T7 Ag', 'Dsl', 2922.30224584868),
	('2014', '1.0', 2040, 'T7 Public', 'Dsl', 31176.9112301875),
	('2014', '1.0', 2040, 'PTO', 'Dsl', 43230.2144898272),
	('2014', '1.0', 2040, 'T7 CAIRP', 'Dsl', 433740.797267353),
	('2014', '1.0', 2040, 'T7 CAIRP Construction', 'Dsl', 37549.9115187587),
	('2014', '1.0', 2040, 'T7 Utility', 'Dsl', 3111.90908481003),
	('2014', '1.0', 2040, 'T7 NNOOS', 'Dsl', 537839.12828567),
	('2014', '1.0', 2040, 'T7 NOOS', 'Dsl', 171327.487011494),
	('2014', '1.0', 2040, 'T7 Other Port', 'Dsl', 128075.311761056),
	('2014', '1.0', 2040, 'T7 POLA', 'Dsl', 84061.4007179998),
	('2014', '1.0', 2040, 'T7 Single', 'Dsl', 217716.001174643),
	('2014', '1.0', 2040, 'T7 Single Construction', 'Dsl', 97136.6805279902),
	('2014', '1.0', 2040, 'T7 Tractor', 'Dsl', 658769.455887983),
	('2014', '1.0', 2040, 'T7 Tractor Construction', 'Dsl', 72422.5747021303),
	('2014', '1.0', 2040, 'T7 SWCV', 'Dsl', 93275.2531107462),
	('2014', '1.0', 2040, 'SBUS', 'Dsl', 47159.0039916262),
	('2014', '1.0', 2040, 'Motor Coach', 'Dsl', 41911.5806145567),
	('2014', '1.0', 2040, 'All Other Buses', 'Dsl', 41163.7975371907),
	('2014', '1.0', 2045, 'LDA', 'Gas', 50487482.338569),
	('2014', '1.0', 2045, 'LDA', 'Dsl', 703663.176851595),
	('2014', '1.0', 2045, 'LDA', 'Elec', 9322353.80898545),
	('2014', '1.0', 2045, 'LDT1', 'Gas', 3530473.76467834),
	('2014', '1.0', 2045, 'LDT2', 'Gas', 17257260.6013902),
	('2014', '1.0', 2045, 'MDV', 'Gas', 9213694.80001052),
	('2014', '1.0', 2045, 'LHD1', 'Gas', 333035.374307102),
	('2014', '1.0', 2045, 'LHD2', 'Gas', 149983.723489533),
	('2014', '1.0', 2045, 'T6TS', 'Gas', 197790.478209345),
	('2014', '1.0', 2045, 'T7IS', 'Gas', 26535.8438706765),
	('2014', '1.0', 2045, 'LDT1', 'Dsl', 1964.3354470808),
	('2014', '1.0', 2045, 'LDT2', 'Dsl', 37979.6851169149),
	('2014', '1.0', 2045, 'MDV', 'Dsl', 262215.428534092),
	('2014', '1.0', 2045, 'LHD1', 'Dsl', 736419.344042699),
	('2014', '1.0', 2045, 'LHD2', 'Dsl', 370233.98751231),
	('2014', '1.0', 2045, 'LDT1', 'Elec', 1575.93651138719),
	('2014', '1.0', 2045, 'UBUS', 'Gas', 78036.4748262484),
	('2014', '1.0', 2045, 'SBUS', 'Gas', 32189.0682859471),
	('2014', '1.0', 2045, 'OBUS', 'Gas', 108017.98128386),
	('2014', '1.0', 2045, 'UBUS', 'Dsl', 78461.3906735761),
	('2014', '1.0', 2045, 'MCY', 'Gas', 542158.154267195),
	('2014', '1.0', 2045, 'MH', 'Gas', 51539.3504226918),
	('2014', '1.0', 2045, 'MH', 'Dsl', 14514.7100853378),
	('2014', '1.0', 2045, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2045, 'T6 Public', 'Dsl', 43704.8445234297),
	('2014', '1.0', 2045, 'T6 CAIRP Small', 'Dsl', 9199.71134541445),
	('2014', '1.0', 2045, 'T6 CAIRP Heavy', 'Dsl', 2996.8895765014),
	('2014', '1.0', 2045, 'T6 Instate Construction Small', 'Dsl', 174092.721865968),
	('2014', '1.0', 2045, 'T6 Instate Construction Heavy', 'Dsl', 64805.4395659497),
	('2014', '1.0', 2045, 'T6 Instate Small', 'Dsl', 1040480.07857733),
	('2014', '1.0', 2045, 'T6 Instate Heavy', 'Dsl', 412722.200285996),
	('2014', '1.0', 2045, 'T6 OOS Small', 'Dsl', 5271.08886110303),
	('2014', '1.0', 2045, 'T6 OOS Heavy', 'Dsl', 1717.10509944707),
	('2014', '1.0', 2045, 'T6 Utility', 'Dsl', 6273.60747202819),
	('2014', '1.0', 2045, 'T7 Ag', 'Dsl', 2922.30224584869),
	('2014', '1.0', 2045, 'T7 Public', 'Dsl', 31791.3377908367),
	('2014', '1.0', 2045, 'PTO', 'Dsl', 45744.0105959225),
	('2014', '1.0', 2045, 'T7 CAIRP', 'Dsl', 458441.730808518),
	('2014', '1.0', 2045, 'T7 CAIRP Construction', 'Dsl', 45972.4850145818),
	('2014', '1.0', 2045, 'T7 Utility', 'Dsl', 3222.778163079),
	('2014', '1.0', 2045, 'T7 NNOOS', 'Dsl', 568468.316610405),
	('2014', '1.0', 2045, 'T7 NOOS', 'Dsl', 181084.348476009),
	('2014', '1.0', 2045, 'T7 Other Port', 'Dsl', 138739.176507708),
	('2014', '1.0', 2045, 'T7 POLA', 'Dsl', 95036.642591733),
	('2014', '1.0', 2045, 'T7 Single', 'Dsl', 230375.980831146),
	('2014', '1.0', 2045, 'T7 Single Construction', 'Dsl', 118924.769974713),
	('2014', '1.0', 2045, 'T7 Tractor', 'Dsl', 696435.870411295),
	('2014', '1.0', 2045, 'T7 Tractor Construction', 'Dsl', 88667.2057415592),
	('2014', '1.0', 2045, 'T7 SWCV', 'Dsl', 97043.4572934889),
	('2014', '1.0', 2045, 'SBUS', 'Dsl', 47180.4220494399),
	('2014', '1.0', 2045, 'Motor Coach', 'Dsl', 44298.386683729),
	('2014', '1.0', 2045, 'All Other Buses', 'Dsl', 43300.8898577386),
	('2014', '1.0', 2050, 'LDA', 'Gas', 51627403.9723141),
	('2014', '1.0', 2050, 'LDA', 'Dsl', 720523.995162547),
	('2014', '1.0', 2050, 'LDA', 'Elec', 9581514.20167511),
	('2014', '1.0', 2050, 'LDT1', 'Gas', 3617313.54822532),
	('2014', '1.0', 2050, 'LDT2', 'Gas', 17656932.0057607),
	('2014', '1.0', 2050, 'MDV', 'Gas', 9402704.95097675),
	('2014', '1.0', 2050, 'LHD1', 'Gas', 335072.476082297),
	('2014', '1.0', 2050, 'LHD2', 'Gas', 153807.410946326),
	('2014', '1.0', 2050, 'T6TS', 'Gas', 203126.575572812),
	('2014', '1.0', 2050, 'T7IS', 'Gas', 27238.0921779934),
	('2014', '1.0', 2050, 'LDT1', 'Dsl', 2013.40421716508),
	('2014', '1.0', 2050, 'LDT2', 'Dsl', 38906.0665973664),
	('2014', '1.0', 2050, 'MDV', 'Dsl', 269939.536497837),
	('2014', '1.0', 2050, 'LHD1', 'Dsl', 751698.806014234),
	('2014', '1.0', 2050, 'LHD2', 'Dsl', 379839.656967372),
	('2014', '1.0', 2050, 'LDT1', 'Elec', 1621.4871986614),
	('2014', '1.0', 2050, 'UBUS', 'Gas', 80825.0019135375),
	('2014', '1.0', 2050, 'SBUS', 'Gas', 33260.9988634981),
	('2014', '1.0', 2050, 'OBUS', 'Gas', 110722.700033188),
	('2014', '1.0', 2050, 'UBUS', 'Dsl', 79601.3048978306),
	('2014', '1.0', 2050, 'MCY', 'Gas', 554061.218165707),
	('2014', '1.0', 2050, 'MH', 'Gas', 52491.8447368603),
	('2014', '1.0', 2050, 'MH', 'Dsl', 14739.9875688207),
	('2014', '1.0', 2050, 'T6 Ag', 'Dsl', 3928.58633777123),
	('2014', '1.0', 2050, 'T6 Public', 'Dsl', 45073.8884352664),
	('2014', '1.0', 2050, 'T6 CAIRP Small', 'Dsl', 9695.39366067887),
	('2014', '1.0', 2050, 'T6 CAIRP Heavy', 'Dsl', 3158.36259539263),
	('2014', '1.0', 2050, 'T6 Instate Construction Small', 'Dsl', 198267.704694781),
	('2014', '1.0', 2050, 'T6 Instate Construction Heavy', 'Dsl', 73804.4969184257),
	('2014', '1.0', 2050, 'T6 Instate Small', 'Dsl', 1096429.9218617),
	('2014', '1.0', 2050, 'T6 Instate Heavy', 'Dsl', 434839.722237133),
	('2014', '1.0', 2050, 'T6 OOS Small', 'Dsl', 5555.09619921785),
	('2014', '1.0', 2050, 'T6 OOS Heavy', 'Dsl', 1809.62307085826),
	('2014', '1.0', 2050, 'T6 Utility', 'Dsl', 6478.18685655741),
	('2014', '1.0', 2050, 'T7 Ag', 'Dsl', 2922.30224584868),
	('2014', '1.0', 2050, 'T7 Public', 'Dsl', 32496.3659363719),
	('2014', '1.0', 2050, 'PTO', 'Dsl', 48220.5483946327),
	('2014', '1.0', 2050, 'T7 CAIRP', 'Dsl', 483142.664349684),
	('2014', '1.0', 2050, 'T7 CAIRP Construction', 'Dsl', 52356.3477281595),
	('2014', '1.0', 2050, 'T7 Utility', 'Dsl', 3327.87144091261),
	('2014', '1.0', 2050, 'T7 NNOOS', 'Dsl', 599097.504935139),
	('2014', '1.0', 2050, 'T7 NOOS', 'Dsl', 190841.209940524),
	('2014', '1.0', 2050, 'T7 Other Port', 'Dsl', 149856.168998068),
	('2014', '1.0', 2050, 'T7 POLA', 'Dsl', 106599.011548242),
	('2014', '1.0', 2050, 'T7 Single', 'Dsl', 242848.320204339),
	('2014', '1.0', 2050, 'T7 Single Construction', 'Dsl', 135438.98286796),
	('2014', '1.0', 2050, 'T7 Tractor', 'Dsl', 733911.356293423),
	('2014', '1.0', 2050, 'T7 Tractor Construction', 'Dsl', 100979.772018346),
	('2014', '1.0', 2050, 'T7 SWCV', 'Dsl', 100623.057246242),
	('2014', '1.0', 2050, 'SBUS', 'Dsl', 47180.4220494401),
	('2014', '1.0', 2050, 'Motor Coach', 'Dsl', 46685.1927529014),
	('2014', '1.0', 2050, 'All Other Buses', 'Dsl', 45528.0837601139)
INSERT INTO #tt_emfac_default_vmt VALUES
	('2017', '1.0', 2016, 'LDA', 'Gas', 49556075.7855182),
	('2017', '1.0', 2016, 'LDA', 'Dsl', 512070.554520489),
	('2017', '1.0', 2016, 'LDA', 'Elec', 377986.506546188),
	('2017', '1.0', 2016, 'LDT1', 'Gas', 5816482.38270923),
	('2017', '1.0', 2016, 'LDT2', 'Gas', 19051888.3864095),
	('2017', '1.0', 2016, 'MDV', 'Gas', 12415805.3561357),
	('2017', '1.0', 2016, 'LHD1', 'Gas', 1425643.17575046),
	('2017', '1.0', 2016, 'LHD2', 'Gas', 193662.649516449),
	('2017', '1.0', 2016, 'T6TS', 'Gas', 176511.812248815),
	('2017', '1.0', 2016, 'T7IS', 'Gas', 1919.21550833428),
	('2017', '1.0', 2016, 'LDT1', 'Dsl', 3675.19184194763),
	('2017', '1.0', 2016, 'LDT2', 'Dsl', 75200.4200504308),
	('2017', '1.0', 2016, 'MDV', 'Dsl', 221113.191548664),
	('2017', '1.0', 2016, 'LHD1', 'Dsl', 1085785.61582288),
	('2017', '1.0', 2016, 'LHD2', 'Dsl', 356727.71633393),
	('2017', '1.0', 2016, 'T6 Ag', 'Dsl', 559.607114001101),
	('2017', '1.0', 2016, 'T6 Public', 'Dsl', 33367.0602219691),
	('2017', '1.0', 2016, 'T6 CAIRP Small', 'Dsl', 2065.65229307281),
	('2017', '1.0', 2016, 'T6 CAIRP Heavy', 'Dsl', 14876.9561020308),
	('2017', '1.0', 2016, 'T6 Instate Construction Small', 'Dsl', 124988.349492329),
	('2017', '1.0', 2016, 'T6 Instate Construction Heavy', 'Dsl', 47788.0099891241),
	('2017', '1.0', 2016, 'T6 Instate Small', 'Dsl', 452331.172016019),
	('2017', '1.0', 2016, 'T6 Instate Heavy', 'Dsl', 293818.225509874),
	('2017', '1.0', 2016, 'T6 OOS Small', 'Dsl', 1185.56255245499),
	('2017', '1.0', 2016, 'T6 OOS Heavy', 'Dsl', 8528.12185748256),
	('2017', '1.0', 2016, 'T6 Utility', 'Dsl', 5069.7577184693),
	('2017', '1.0', 2016, 'T7 Ag', 'Dsl', 262.858344622062),
	('2017', '1.0', 2016, 'T7 Public', 'Dsl', 29921.4574745731),
	('2017', '1.0', 2016, 'PTO', 'Dsl', 25506.3955732488),
	('2017', '1.0', 2016, 'T7 CAIRP', 'Dsl', 294736.61085236),
	('2017', '1.0', 2016, 'T7 CAIRP Construction', 'Dsl', 34326.542698199),
	('2017', '1.0', 2016, 'T7 Utility', 'Dsl', 2444.83130228542),
	('2017', '1.0', 2016, 'T7 NNOOS', 'Dsl', 359306.371900981),
	('2017', '1.0', 2016, 'T7 NOOS', 'Dsl', 115801.018654978),
	('2017', '1.0', 2016, 'T7 Other Port', 'Dsl', 71196.5119798331),
	('2017', '1.0', 2016, 'T7 POLA', 'Dsl', 22441.2991909231),
	('2017', '1.0', 2016, 'T7 Single', 'Dsl', 128455.306412905),
	('2017', '1.0', 2016, 'T7 Single Construction', 'Dsl', 85157.8387432246),
	('2017', '1.0', 2016, 'T7 Tractor', 'Dsl', 419463.136490063),
	('2017', '1.0', 2016, 'T7 Tractor Construction', 'Dsl', 70247.7195973639),
	('2017', '1.0', 2016, 'T7 SWCV', 'Dsl', 36561.7114786158),
	('2017', '1.0', 2016, 'LDT1', 'Elec', 5773.54682429123),
	('2017', '1.0', 2016, 'LDT2', 'Elec', 14482.594590844),
	('2017', '1.0', 2016, 'MDV', 'Elec', 386.10703857041),
	('2017', '1.0', 2016, 'T7 SWCV', 'NG', 16115.4159600178),
	('2017', '1.0', 2016, 'UBUS', 'Gas', 31690.7148870049),
	('2017', '1.0', 2016, 'SBUS', 'Gas', 5717.64807449752),
	('2017', '1.0', 2016, 'OBUS', 'Gas', 77473.3059112272),
	('2017', '1.0', 2016, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2016, 'SBUS', 'Dsl', 72155.0854074023),
	('2017', '1.0', 2016, 'Motor Coach', 'Dsl', 21564.2009016665),
	('2017', '1.0', 2016, 'All Other Buses', 'Dsl', 30599.8352837585),
	('2017', '1.0', 2016, 'UBUS', 'NG', 88329.3729268768),
	('2017', '1.0', 2016, 'MCY', 'Gas', 711796.610854376),
	('2017', '1.0', 2016, 'MH', 'Gas', 123356.240025702),
	('2017', '1.0', 2016, 'MH', 'Dsl', 37537.3146933627),
	('2017', '1.0', 2017, 'LDA', 'Gas', 50899724.366),
	('2017', '1.0', 2017, 'LDA', 'Dsl', 541136.179142472),
	('2017', '1.0', 2017, 'LDA', 'Elec', 486518.39726044),
	('2017', '1.0', 2017, 'LDT1', 'Gas', 5884822.50141784),
	('2017', '1.0', 2017, 'LDT2', 'Gas', 18916837.9780969),
	('2017', '1.0', 2017, 'MDV', 'Gas', 12349369.400803),
	('2017', '1.0', 2017, 'LHD1', 'Gas', 1420800.38253579),
	('2017', '1.0', 2017, 'LHD2', 'Gas', 194118.193753107),
	('2017', '1.0', 2017, 'T6TS', 'Gas', 180312.812320684),
	('2017', '1.0', 2017, 'T7IS', 'Gas', 1923.14083951081),
	('2017', '1.0', 2017, 'LDT1', 'Dsl', 3353.58174098353),
	('2017', '1.0', 2017, 'LDT2', 'Dsl', 85720.3348349701),
	('2017', '1.0', 2017, 'MDV', 'Dsl', 242858.423588224),
	('2017', '1.0', 2017, 'LHD1', 'Dsl', 1126694.41367438),
	('2017', '1.0', 2017, 'LHD2', 'Dsl', 373551.206559113),
	('2017', '1.0', 2017, 'T6 Ag', 'Dsl', 523.09293332517),
	('2017', '1.0', 2017, 'T6 Public', 'Dsl', 35021.1797809767),
	('2017', '1.0', 2017, 'T6 CAIRP Small', 'Dsl', 2133.75689162611),
	('2017', '1.0', 2017, 'T6 CAIRP Heavy', 'Dsl', 15293.912316525),
	('2017', '1.0', 2017, 'T6 Instate Construction Small', 'Dsl', 122787.975800156),
	('2017', '1.0', 2017, 'T6 Instate Construction Heavy', 'Dsl', 46946.7197376048),
	('2017', '1.0', 2017, 'T6 Instate Small', 'Dsl', 468567.091192507),
	('2017', '1.0', 2017, 'T6 Instate Heavy', 'Dsl', 312511.172305169),
	('2017', '1.0', 2017, 'T6 OOS Small', 'Dsl', 1225.78057336279),
	('2017', '1.0', 2017, 'T6 OOS Heavy', 'Dsl', 8775.14434625851),
	('2017', '1.0', 2017, 'T6 Utility', 'Dsl', 5114.92010770081),
	('2017', '1.0', 2017, 'T7 Ag', 'Dsl', 264.965848660888),
	('2017', '1.0', 2017, 'T7 Public', 'Dsl', 29567.0345223977),
	('2017', '1.0', 2017, 'PTO', 'Dsl', 25867.0991881205),
	('2017', '1.0', 2017, 'T7 CAIRP', 'Dsl', 303527.38435549),
	('2017', '1.0', 2017, 'T7 CAIRP Construction', 'Dsl', 33722.2366024455),
	('2017', '1.0', 2017, 'T7 Utility', 'Dsl', 2466.28254040991),
	('2017', '1.0', 2017, 'T7 NNOOS', 'Dsl', 370024.429654376),
	('2017', '1.0', 2017, 'T7 NOOS', 'Dsl', 119253.678452999),
	('2017', '1.0', 2017, 'T7 Other Port', 'Dsl', 74100.8281060041),
	('2017', '1.0', 2017, 'T7 POLA', 'Dsl', 23692.8960674653),
	('2017', '1.0', 2017, 'T7 Single', 'Dsl', 130271.881916077),
	('2017', '1.0', 2017, 'T7 Single Construction', 'Dsl', 83658.6664698566),
	('2017', '1.0', 2017, 'T7 Tractor', 'Dsl', 433900.351068857),
	('2017', '1.0', 2017, 'T7 Tractor Construction', 'Dsl', 69011.0344601894),
	('2017', '1.0', 2017, 'T7 SWCV', 'Dsl', 33452.5474042461),
	('2017', '1.0', 2017, 'LDT1', 'Elec', 6684.38439483301),
	('2017', '1.0', 2017, 'LDT2', 'Elec', 31842.7662355372),
	('2017', '1.0', 2017, 'MDV', 'Elec', 2790.82483786815),
	('2017', '1.0', 2017, 'T7 SWCV', 'NG', 21758.3517885213),
	('2017', '1.0', 2017, 'UBUS', 'Gas', 33542.6433088721),
	('2017', '1.0', 2017, 'SBUS', 'Gas', 6918.83188893948),
	('2017', '1.0', 2017, 'OBUS', 'Gas', 74839.4518220545),
	('2017', '1.0', 2017, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2017, 'SBUS', 'Dsl', 74496.3942807359),
	('2017', '1.0', 2017, 'Motor Coach', 'Dsl', 22206.4374011746),
	('2017', '1.0', 2017, 'All Other Buses', 'Dsl', 29749.578248778),
	('2017', '1.0', 2017, 'UBUS', 'NG', 93644.7055803585),
	('2017', '1.0', 2017, 'MCY', 'Gas', 706180.413376895),
	('2017', '1.0', 2017, 'MH', 'Gas', 117863.762488051),
	('2017', '1.0', 2017, 'MH', 'Dsl', 37254.4120677887),
	('2017', '1.0', 2018, 'LDA', 'Gas', 51727791.3209101),
	('2017', '1.0', 2018, 'LDA', 'Dsl', 568022.764443197),
	('2017', '1.0', 2018, 'LDA', 'Elec', 596027.464439541),
	('2017', '1.0', 2018, 'LDT1', 'Gas', 5874466.34970015),
	('2017', '1.0', 2018, 'LDT2', 'Gas', 18597631.576268),
	('2017', '1.0', 2018, 'MDV', 'Gas', 12143683.8585704),
	('2017', '1.0', 2018, 'LHD1', 'Gas', 1376448.45321185),
	('2017', '1.0', 2018, 'LHD2', 'Gas', 194638.877260831),
	('2017', '1.0', 2018, 'T6TS', 'Gas', 184616.635005081),
	('2017', '1.0', 2018, 'T7IS', 'Gas', 1962.54481692526),
	('2017', '1.0', 2018, 'LDT1', 'Dsl', 3013.8982713616),
	('2017', '1.0', 2018, 'LDT2', 'Dsl', 95230.5802242896),
	('2017', '1.0', 2018, 'MDV', 'Dsl', 259627.645567171),
	('2017', '1.0', 2018, 'LHD1', 'Dsl', 1144231.70916203),
	('2017', '1.0', 2018, 'LHD2', 'Dsl', 386843.330744443),
	('2017', '1.0', 2018, 'T6 Ag', 'Dsl', 488.117688889643),
	('2017', '1.0', 2018, 'T6 Public', 'Dsl', 35707.2307890933),
	('2017', '1.0', 2018, 'T6 CAIRP Small', 'Dsl', 2207.27899355693),
	('2017', '1.0', 2018, 'T6 CAIRP Heavy', 'Dsl', 15721.7999504346),
	('2017', '1.0', 2018, 'T6 Instate Construction Small', 'Dsl', 120034.853845991),
	('2017', '1.0', 2018, 'T6 Instate Construction Heavy', 'Dsl', 45894.0918728379),
	('2017', '1.0', 2018, 'T6 Instate Small', 'Dsl', 487756.192426712),
	('2017', '1.0', 2018, 'T6 Instate Heavy', 'Dsl', 333609.478801163),
	('2017', '1.0', 2018, 'T6 OOS Small', 'Dsl', 1269.50974549365),
	('2017', '1.0', 2018, 'T6 OOS Heavy', 'Dsl', 9030.65451109694),
	('2017', '1.0', 2018, 'T6 Utility', 'Dsl', 5159.90070286014),
	('2017', '1.0', 2018, 'T7 Ag', 'Dsl', 264.956275230583),
	('2017', '1.0', 2018, 'T7 Public', 'Dsl', 29669.6274125096),
	('2017', '1.0', 2018, 'PTO', 'Dsl', 26322.2838513236),
	('2017', '1.0', 2018, 'T7 CAIRP', 'Dsl', 312694.228164782),
	('2017', '1.0', 2018, 'T7 CAIRP Construction', 'Dsl', 32966.1248632567),
	('2017', '1.0', 2018, 'T7 Utility', 'Dsl', 2487.60976633223),
	('2017', '1.0', 2018, 'T7 NNOOS', 'Dsl', 381199.585819498),
	('2017', '1.0', 2018, 'T7 NOOS', 'Dsl', 122854.265115873),
	('2017', '1.0', 2018, 'T7 Other Port', 'Dsl', 76170.8647322662),
	('2017', '1.0', 2018, 'T7 POLA', 'Dsl', 24950.4912509322),
	('2017', '1.0', 2018, 'T7 Single', 'Dsl', 132564.282863842),
	('2017', '1.0', 2018, 'T7 Single Construction', 'Dsl', 81782.8923167822),
	('2017', '1.0', 2018, 'T7 Tractor', 'Dsl', 448800.521866984),
	('2017', '1.0', 2018, 'T7 Tractor Construction', 'Dsl', 67463.6859285938),
	('2017', '1.0', 2018, 'T7 SWCV', 'Dsl', 31642.4431114013),
	('2017', '1.0', 2018, 'LDT1', 'Elec', 7639.20683938903),
	('2017', '1.0', 2018, 'LDT2', 'Elec', 48018.1579283603),
	('2017', '1.0', 2018, 'MDV', 'Elec', 5322.46019727319),
	('2017', '1.0', 2018, 'T7 SWCV', 'NG', 24648.8388805399),
	('2017', '1.0', 2018, 'UBUS', 'Gas', 35394.5717307391),
	('2017', '1.0', 2018, 'SBUS', 'Gas', 8375.86869927894),
	('2017', '1.0', 2018, 'OBUS', 'Gas', 72007.7303623936),
	('2017', '1.0', 2018, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2018, 'SBUS', 'Dsl', 74840.6305966173),
	('2017', '1.0', 2018, 'Motor Coach', 'Dsl', 22880.578141929),
	('2017', '1.0', 2018, 'All Other Buses', 'Dsl', 29765.1635405588),
	('2017', '1.0', 2018, 'UBUS', 'NG', 98960.0382338399),
	('2017', '1.0', 2018, 'MCY', 'Gas', 688024.013985356),
	('2017', '1.0', 2018, 'MH', 'Gas', 111481.119364785),
	('2017', '1.0', 2018, 'MH', 'Dsl', 36560.8643843543),
	('2017', '1.0', 2019, 'LDA', 'Gas', 52523886.142925),
	('2017', '1.0', 2019, 'LDA', 'Dsl', 591969.305298019),
	('2017', '1.0', 2019, 'LDA', 'Elec', 706843.17068797),
	('2017', '1.0', 2019, 'LDT1', 'Gas', 5870445.07374778),
	('2017', '1.0', 2019, 'LDT2', 'Gas', 18303424.0866995),
	('2017', '1.0', 2019, 'MDV', 'Gas', 11949483.2664602),
	('2017', '1.0', 2019, 'LHD1', 'Gas', 1338981.06109597),
	('2017', '1.0', 2019, 'LHD2', 'Gas', 194787.188601461),
	('2017', '1.0', 2019, 'T6TS', 'Gas', 189550.120746574),
	('2017', '1.0', 2019, 'T7IS', 'Gas', 1990.27848220891),
	('2017', '1.0', 2019, 'LDT1', 'Dsl', 2721.38315777368),
	('2017', '1.0', 2019, 'LDT2', 'Dsl', 104229.364409994),
	('2017', '1.0', 2019, 'MDV', 'Dsl', 275254.83774106),
	('2017', '1.0', 2019, 'LHD1', 'Dsl', 1159049.22128235),
	('2017', '1.0', 2019, 'LHD2', 'Dsl', 398690.618365761),
	('2017', '1.0', 2019, 'T6 Ag', 'Dsl', 455.066396077409),
	('2017', '1.0', 2019, 'T6 Public', 'Dsl', 36329.4536515028),
	('2017', '1.0', 2019, 'T6 CAIRP Small', 'Dsl', 2275.63491368784),
	('2017', '1.0', 2019, 'T6 CAIRP Heavy', 'Dsl', 16108.5545028904),
	('2017', '1.0', 2019, 'T6 Instate Construction Small', 'Dsl', 116728.983629835),
	('2017', '1.0', 2019, 'T6 Instate Construction Heavy', 'Dsl', 44630.1263948226),
	('2017', '1.0', 2019, 'T6 Instate Small', 'Dsl', 506929.212481184),
	('2017', '1.0', 2019, 'T6 Instate Heavy', 'Dsl', 353882.575277131),
	('2017', '1.0', 2019, 'T6 OOS Small', 'Dsl', 1310.25460643275),
	('2017', '1.0', 2019, 'T6 OOS Heavy', 'Dsl', 9262.89849081038),
	('2017', '1.0', 2019, 'T6 Utility', 'Dsl', 5204.71239510035),
	('2017', '1.0', 2019, 'T7 Ag', 'Dsl', 262.050929720013),
	('2017', '1.0', 2019, 'T7 Public', 'Dsl', 29820.4462156525),
	('2017', '1.0', 2019, 'PTO', 'Dsl', 26735.8176648659),
	('2017', '1.0', 2019, 'T7 CAIRP', 'Dsl', 321070.7891482),
	('2017', '1.0', 2019, 'T7 CAIRP Construction', 'Dsl', 32058.2074806327),
	('2017', '1.0', 2019, 'T7 Utility', 'Dsl', 2508.90536901142),
	('2017', '1.0', 2019, 'T7 NNOOS', 'Dsl', 391410.582287427),
	('2017', '1.0', 2019, 'T7 NOOS', 'Dsl', 126144.732377787),
	('2017', '1.0', 2019, 'T7 Other Port', 'Dsl', 79503.9790238711),
	('2017', '1.0', 2019, 'T7 POLA', 'Dsl', 26218.4638160617),
	('2017', '1.0', 2019, 'T7 Single', 'Dsl', 134646.921807402),
	('2017', '1.0', 2019, 'T7 Single Construction', 'Dsl', 79530.5162840008),
	('2017', '1.0', 2019, 'T7 Tractor', 'Dsl', 462625.633391797),
	('2017', '1.0', 2019, 'T7 Tractor Construction', 'Dsl', 65605.6740025778),
	('2017', '1.0', 2019, 'T7 SWCV', 'Dsl', 29853.5840733311),
	('2017', '1.0', 2019, 'LDT1', 'Elec', 10565.0190481451),
	('2017', '1.0', 2019, 'LDT2', 'Elec', 62740.8428462921),
	('2017', '1.0', 2019, 'MDV', 'Elec', 12089.2587623624),
	('2017', '1.0', 2019, 'T7 SWCV', 'NG', 27662.8881748074),
	('2017', '1.0', 2019, 'UBUS', 'Gas', 37246.5001526067),
	('2017', '1.0', 2019, 'SBUS', 'Gas', 9804.98031547671),
	('2017', '1.0', 2019, 'OBUS', 'Gas', 69330.8723516893),
	('2017', '1.0', 2019, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2019, 'SBUS', 'Dsl', 75144.6669105868),
	('2017', '1.0', 2019, 'Motor Coach', 'Dsl', 23497.9303062949),
	('2017', '1.0', 2019, 'All Other Buses', 'Dsl', 29426.7995255998),
	('2017', '1.0', 2019, 'UBUS', 'NG', 104275.370887322),
	('2017', '1.0', 2019, 'MCY', 'Gas', 671702.38367458),
	('2017', '1.0', 2019, 'MH', 'Gas', 105760.805083713),
	('2017', '1.0', 2019, 'MH', 'Dsl', 35904.9770774599),
	('2017', '1.0', 2020, 'LDA', 'Gas', 53431842.7047542),
	('2017', '1.0', 2020, 'LDA', 'Dsl', 614670.224562255),
	('2017', '1.0', 2020, 'LDA', 'Elec', 849126.679330846),
	('2017', '1.0', 2020, 'LDT1', 'Gas', 5889125.74236069),
	('2017', '1.0', 2020, 'LDT2', 'Gas', 18096266.6766263),
	('2017', '1.0', 2020, 'MDV', 'Gas', 11798102.2736309),
	('2017', '1.0', 2020, 'LHD1', 'Gas', 1308635.80955139),
	('2017', '1.0', 2020, 'LHD2', 'Gas', 195409.439532664),
	('2017', '1.0', 2020, 'T6TS', 'Gas', 195204.533761061),
	('2017', '1.0', 2020, 'T7IS', 'Gas', 1996.63450477858),
	('2017', '1.0', 2020, 'LDT1', 'Dsl', 2463.95224328166),
	('2017', '1.0', 2020, 'LDT2', 'Dsl', 112909.653057369),
	('2017', '1.0', 2020, 'MDV', 'Dsl', 290576.1883728),
	('2017', '1.0', 2020, 'LHD1', 'Dsl', 1175504.1699384),
	('2017', '1.0', 2020, 'LHD2', 'Dsl', 410789.023733899),
	('2017', '1.0', 2020, 'T6 Ag', 'Dsl', 424.234051935724),
	('2017', '1.0', 2020, 'T6 Public', 'Dsl', 36936.8571085524),
	('2017', '1.0', 2020, 'T6 CAIRP Small', 'Dsl', 2327.48268901525),
	('2017', '1.0', 2020, 'T6 CAIRP Heavy', 'Dsl', 16380.1229068154),
	('2017', '1.0', 2020, 'T6 Instate Construction Small', 'Dsl', 112870.365151687),
	('2017', '1.0', 2020, 'T6 Instate Construction Heavy', 'Dsl', 43154.8233035587),
	('2017', '1.0', 2020, 'T6 Instate Small', 'Dsl', 523210.013076852),
	('2017', '1.0', 2020, 'T6 Instate Heavy', 'Dsl', 370814.214271919),
	('2017', '1.0', 2020, 'T6 OOS Small', 'Dsl', 1341.42863025334),
	('2017', '1.0', 2020, 'T6 OOS Heavy', 'Dsl', 9428.7527303042),
	('2017', '1.0', 2020, 'T6 Utility', 'Dsl', 5249.75385797133),
	('2017', '1.0', 2020, 'T7 Ag', 'Dsl', 255.784238972595),
	('2017', '1.0', 2020, 'T7 Public', 'Dsl', 29982.851438062),
	('2017', '1.0', 2020, 'PTO', 'Dsl', 26998.8217639999),
	('2017', '1.0', 2020, 'T7 CAIRP', 'Dsl', 327143.264244189),
	('2017', '1.0', 2020, 'T7 CAIRP Construction', 'Dsl', 30998.4844545731),
	('2017', '1.0', 2020, 'T7 Utility', 'Dsl', 2530.33484103627),
	('2017', '1.0', 2020, 'T7 NNOOS', 'Dsl', 398811.868652989),
	('2017', '1.0', 2020, 'T7 NOOS', 'Dsl', 128530.422319502),
	('2017', '1.0', 2020, 'T7 Other Port', 'Dsl', 82672.7000207911),
	('2017', '1.0', 2020, 'T7 POLA', 'Dsl', 27497.3965881508),
	('2017', '1.0', 2020, 'T7 Single', 'Dsl', 135971.463020804),
	('2017', '1.0', 2020, 'T7 Single Construction', 'Dsl', 76901.5383715117),
	('2017', '1.0', 2020, 'T7 Tractor', 'Dsl', 473298.431008303),
	('2017', '1.0', 2020, 'T7 Tractor Construction', 'Dsl', 63436.9986821411),
	('2017', '1.0', 2020, 'T7 SWCV', 'Dsl', 27968.6967694131),
	('2017', '1.0', 2020, 'LDT1', 'Elec', 17133.5152237821),
	('2017', '1.0', 2020, 'LDT2', 'Elec', 78796.1243362887),
	('2017', '1.0', 2020, 'MDV', 'Elec', 26122.3279828246),
	('2017', '1.0', 2020, 'T7 SWCV', 'NG', 30816.1401483369),
	('2017', '1.0', 2020, 'UBUS', 'Gas', 39098.4285744738),
	('2017', '1.0', 2020, 'SBUS', 'Gas', 11222.0067172827),
	('2017', '1.0', 2020, 'OBUS', 'Gas', 67147.0726676893),
	('2017', '1.0', 2020, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2020, 'SBUS', 'Dsl', 75332.859656543),
	('2017', '1.0', 2020, 'Motor Coach', 'Dsl', 23946.7201441174),
	('2017', '1.0', 2020, 'All Other Buses', 'Dsl', 29485.2719768511),
	('2017', '1.0', 2020, 'UBUS', 'NG', 109590.703540804),
	('2017', '1.0', 2020, 'MCY', 'Gas', 659798.774723662),
	('2017', '1.0', 2020, 'MH', 'Gas', 100810.531208985),
	('2017', '1.0', 2020, 'MH', 'Dsl', 35416.528826041),
	('2017', '1.0', 2021, 'LDA', 'Gas', 54325093.7795572),
	('2017', '1.0', 2021, 'LDA', 'Dsl', 635343.569775883),
	('2017', '1.0', 2021, 'LDA', 'Elec', 1016385.30178862),
	('2017', '1.0', 2021, 'LDT1', 'Gas', 5908845.80911897),
	('2017', '1.0', 2021, 'LDT2', 'Gas', 17914883.5791478),
	('2017', '1.0', 2021, 'MDV', 'Gas', 11660085.2116204),
	('2017', '1.0', 2021, 'LHD1', 'Gas', 1284364.48033852),
	('2017', '1.0', 2021, 'LHD2', 'Gas', 196023.476451233),
	('2017', '1.0', 2021, 'T6TS', 'Gas', 201226.261366834),
	('2017', '1.0', 2021, 'T7IS', 'Gas', 2048.746206272),
	('2017', '1.0', 2021, 'LDT1', 'Dsl', 2248.50450976422),
	('2017', '1.0', 2021, 'LDT2', 'Dsl', 121070.412508758),
	('2017', '1.0', 2021, 'MDV', 'Dsl', 304547.50192788),
	('2017', '1.0', 2021, 'LHD1', 'Dsl', 1191286.2268978),
	('2017', '1.0', 2021, 'LHD2', 'Dsl', 422173.443409931),
	('2017', '1.0', 2021, 'T6 Ag', 'Dsl', 395.86178513628),
	('2017', '1.0', 2021, 'T6 Public', 'Dsl', 37461.6454610499),
	('2017', '1.0', 2021, 'T6 CAIRP Small', 'Dsl', 2380.57165179642),
	('2017', '1.0', 2021, 'T6 CAIRP Heavy', 'Dsl', 16669.0079547756),
	('2017', '1.0', 2021, 'T6 Instate Construction Small', 'Dsl', 114992.383087478),
	('2017', '1.0', 2021, 'T6 Instate Construction Heavy', 'Dsl', 43966.1550374729),
	('2017', '1.0', 2021, 'T6 Instate Small', 'Dsl', 540414.391115857),
	('2017', '1.0', 2021, 'T6 Instate Heavy', 'Dsl', 387411.855065186),
	('2017', '1.0', 2021, 'T6 OOS Small', 'Dsl', 1373.21818078705),
	('2017', '1.0', 2021, 'T6 OOS Heavy', 'Dsl', 9603.55412427916),
	('2017', '1.0', 2021, 'T6 Utility', 'Dsl', 5295.178621308),
	('2017', '1.0', 2021, 'T7 Ag', 'Dsl', 246.309360325947),
	('2017', '1.0', 2021, 'T7 Public', 'Dsl', 30113.830984204),
	('2017', '1.0', 2021, 'PTO', 'Dsl', 27352.2993385873),
	('2017', '1.0', 2021, 'T7 CAIRP', 'Dsl', 333495.859610365),
	('2017', '1.0', 2021, 'T7 CAIRP Construction', 'Dsl', 31581.2710868881),
	('2017', '1.0', 2021, 'T7 Utility', 'Dsl', 2551.97795973662),
	('2017', '1.0', 2021, 'T7 NNOOS', 'Dsl', 406553.253162033),
	('2017', '1.0', 2021, 'T7 NOOS', 'Dsl', 131026.460716784),
	('2017', '1.0', 2021, 'T7 Other Port', 'Dsl', 86157.8127881648),
	('2017', '1.0', 2021, 'T7 POLA', 'Dsl', 29275.8024879516),
	('2017', '1.0', 2021, 'T7 Single', 'Dsl', 137751.646740739),
	('2017', '1.0', 2021, 'T7 Single Construction', 'Dsl', 78347.3248141703),
	('2017', '1.0', 2021, 'T7 Tractor', 'Dsl', 484557.386734766),
	('2017', '1.0', 2021, 'T7 Tractor Construction', 'Dsl', 64629.6452091131),
	('2017', '1.0', 2021, 'T7 SWCV', 'Dsl', 26012.2651618614),
	('2017', '1.0', 2021, 'LDT1', 'Elec', 28400.0394639217),
	('2017', '1.0', 2021, 'LDT2', 'Elec', 106352.429415941),
	('2017', '1.0', 2021, 'MDV', 'Elec', 48649.7178503663),
	('2017', '1.0', 2021, 'T7 SWCV', 'NG', 34235.2272355981),
	('2017', '1.0', 2021, 'UBUS', 'Gas', 40557.5271198331),
	('2017', '1.0', 2021, 'SBUS', 'Gas', 12615.2030894634),
	('2017', '1.0', 2021, 'OBUS', 'Gas', 65401.6857414668),
	('2017', '1.0', 2021, 'UBUS', 'Dsl', 2628.07967339449),
	('2017', '1.0', 2021, 'SBUS', 'Dsl', 75385.4444547755),
	('2017', '1.0', 2021, 'Motor Coach', 'Dsl', 24416.2562853541),
	('2017', '1.0', 2021, 'All Other Buses', 'Dsl', 29652.2260335133),
	('2017', '1.0', 2021, 'UBUS', 'NG', 113778.551219591),
	('2017', '1.0', 2021, 'MCY', 'Gas', 649886.951101033),
	('2017', '1.0', 2021, 'MH', 'Gas', 96423.7960599785),
	('2017', '1.0', 2021, 'MH', 'Dsl', 34995.5646069922),
	('2017', '1.0', 2023 ,'LDA', 'Gas', 55680725.7751483),
	('2017', '1.0', 2023 ,'LDA', 'Dsl', 667168.904290149),
	('2017', '1.0', 2023 ,'LDA', 'Elec', 1464886.32879755),
	('2017', '1.0', 2023 ,'LDT1', 'Gas', 5930025.33108143),
	('2017', '1.0', 2023 ,'LDT2', 'Gas', 17562165.0222611),
	('2017', '1.0', 2023 ,'MDV', 'Gas', 11383340.5754949),
	('2017', '1.0', 2023 ,'LHD1', 'Gas', 1242729.37782004),
	('2017', '1.0', 2023 ,'LHD2', 'Gas', 196670.202455525),
	('2017', '1.0', 2023 ,'T6TS', 'Gas', 212826.028696541),
	('2017', '1.0', 2023 ,'T7IS', 'Gas', 2100.31560135116),
	('2017', '1.0', 2023 ,'LDT1', 'Dsl', 1884.50087319813),
	('2017', '1.0', 2023 ,'LDT2', 'Dsl', 134917.903125902),
	('2017', '1.0', 2023 ,'MDV', 'Dsl', 327264.66216476),
	('2017', '1.0', 2023 ,'LHD1', 'Dsl', 1216772.60599085),
	('2017', '1.0', 2023 ,'LHD2', 'Dsl', 441983.554633182),
	('2017', '1.0', 2023 ,'T6 Ag', 'Dsl', 334.941177885686),
	('2017', '1.0', 2023 ,'T6 Public', 'Dsl', 38354.5825079213),
	('2017', '1.0', 2023 ,'T6 CAIRP Small', 'Dsl', 2477.82655640898),
	('2017', '1.0', 2023 ,'T6 CAIRP Heavy', 'Dsl', 17209.2843543371),
	('2017', '1.0', 2023 ,'T6 Instate Construction Small', 'Dsl', 118883.555164275),
	('2017', '1.0', 2023 ,'T6 Instate Construction Heavy', 'Dsl', 45453.9046623831),
	('2017', '1.0', 2023 ,'T6 Instate Small', 'Dsl', 573522.946961727),
	('2017', '1.0', 2023 ,'T6 Instate Heavy', 'Dsl', 416375.006847312),
	('2017', '1.0', 2023 ,'T6 OOS Small', 'Dsl', 1431.42919532984),
	('2017', '1.0', 2023 ,'T6 OOS Heavy', 'Dsl', 9928.29225550428),
	('2017', '1.0', 2023 ,'T6 Utility', 'Dsl', 5387.1054529101),
	('2017', '1.0', 2023 ,'T7 Ag', 'Dsl', 215.624255197271),
	('2017', '1.0', 2023 ,'T7 Public', 'Dsl', 30270.3587168975),
	('2017', '1.0', 2023 ,'PTO', 'Dsl', 28026.2223944099),
	('2017', '1.0', 2023 ,'T7 CAIRP', 'Dsl', 345233.195387767),
	('2017', '1.0', 2023 ,'T7 CAIRP Construction', 'Dsl', 32649.9345661861),
	('2017', '1.0', 2023 ,'T7 Utility', 'Dsl', 2596.10063895049),
	('2017', '1.0', 2023 ,'T7 NNOOS', 'Dsl', 420853.391354239),
	('2017', '1.0', 2023 ,'T7 NOOS', 'Dsl', 135638.78952783),
	('2017', '1.0', 2023 ,'T7 Other Port', 'Dsl', 92750.4135342696),
	('2017', '1.0', 2023 ,'T7 POLA', 'Dsl', 32891.6133099674),
	('2017', '1.0', 2023 ,'T7 Single', 'Dsl', 141145.657955918),
	('2017', '1.0', 2023 ,'T7 Single Construction', 'Dsl', 80998.4823467237),
	('2017', '1.0', 2023 ,'T7 Tractor', 'Dsl', 506004.349786111),
	('2017', '1.0', 2023 ,'T7 Tractor Construction', 'Dsl', 66816.6167633916),
	('2017', '1.0', 2023 ,'T7 SWCV', 'Dsl', 21981.1669483982),
	('2017', '1.0', 2023 ,'LDT1', 'Elec', 58144.1080231878),
	('2017', '1.0', 2023 ,'LDT2', 'Elec', 174144.312347146),
	('2017', '1.0', 2023 ,'MDV', 'Elec', 102541.97883386),
	('2017', '1.0', 2023 ,'T7 SWCV', 'NG', 40637.5314539532),
	('2017', '1.0', 2023 ,'UBUS', 'Gas', 43475.7242105514),
	('2017', '1.0', 2023 ,'SBUS', 'Gas', 15228.6091027583),
	('2017', '1.0', 2023 ,'OBUS', 'Gas', 62362.5625497527),
	('2017', '1.0', 2023 ,'UBUS', 'Dsl', 0),
	('2017', '1.0', 2023 ,'SBUS', 'Dsl', 74965.255117352),
	('2017', '1.0', 2023 ,'Motor Coach', 'Dsl', 25284.1005047346),
	('2017', '1.0', 2023 ,'All Other Buses', 'Dsl', 29980.6488303942),
	('2017', '1.0', 2023 ,'UBUS', 'NG', 124782.326250559),
	('2017', '1.0', 2023 ,'MCY', 'Gas', 632873.619936745),
	('2017', '1.0', 2023 ,'MH', 'Gas', 88883.5515035789),
	('2017', '1.0', 2023 ,'MH', 'Dsl', 34280.2898123446),
	('2017', '1.0', 2024, 'LDA', 'Gas', 56261566.0430415),
	('2017', '1.0', 2024, 'LDA', 'Dsl', 679768.998312016),
	('2017', '1.0', 2024, 'LDA', 'Elec', 1747836.48004438),
	('2017', '1.0', 2024, 'LDT1', 'Gas', 5946393.24147056),
	('2017', '1.0', 2024, 'LDT2', 'Gas', 17427995.2301097),
	('2017', '1.0', 2024, 'MDV', 'Gas', 11271527.3027173),
	('2017', '1.0', 2024, 'LHD1', 'Gas', 1225429.77588154),
	('2017', '1.0', 2024, 'LHD2', 'Gas', 196903.049427812),
	('2017', '1.0', 2024, 'T6TS', 'Gas', 218405.965335444),
	('2017', '1.0', 2024, 'T7IS', 'Gas', 2126.1258505233),
	('2017', '1.0', 2024, 'LDT1', 'Dsl', 1738.37353367195),
	('2017', '1.0', 2024, 'LDT2', 'Dsl', 140774.84484717),
	('2017', '1.0', 2024, 'MDV', 'Dsl', 337025.282062987),
	('2017', '1.0', 2024, 'LHD1', 'Dsl', 1227535.97470033),
	('2017', '1.0', 2024, 'LHD2', 'Dsl', 450420.065484963),
	('2017', '1.0', 2024, 'T6 Ag', 'Dsl', 302.338120776696),
	('2017', '1.0', 2024, 'T6 Public', 'Dsl', 38759.2387303732),
	('2017', '1.0', 2024, 'T6 CAIRP Small', 'Dsl', 2527.74208131301),
	('2017', '1.0', 2024, 'T6 CAIRP Heavy', 'Dsl', 17505.9422858919),
	('2017', '1.0', 2024, 'T6 Instate Construction Small', 'Dsl', 120652.709305283),
	('2017', '1.0', 2024, 'T6 Instate Construction Heavy', 'Dsl', 46130.3225533797),
	('2017', '1.0', 2024, 'T6 Instate Small', 'Dsl', 590355.725123823),
	('2017', '1.0', 2024, 'T6 Instate Heavy', 'Dsl', 430115.341441877),
	('2017', '1.0', 2024, 'T6 OOS Small', 'Dsl', 1460.99237718214),
	('2017', '1.0', 2024, 'T6 OOS Heavy', 'Dsl', 10104.6446839591),
	('2017', '1.0', 2024, 'T6 Utility', 'Dsl', 5433.37348991915),
	('2017', '1.0', 2024, 'T7 Ag', 'Dsl', 195.568111793869),
	('2017', '1.0', 2024, 'T7 Public', 'Dsl', 30286.0175191978),
	('2017', '1.0', 2024, 'PTO', 'Dsl', 28392.2981413826),
	('2017', '1.0', 2024, 'T7 CAIRP', 'Dsl', 351543.458749718),
	('2017', '1.0', 2024, 'T7 CAIRP Construction', 'Dsl', 33135.8114131696),
	('2017', '1.0', 2024, 'T7 Utility', 'Dsl', 2618.40542913546),
	('2017', '1.0', 2024, 'T7 NNOOS', 'Dsl', 428541.151120535),
	('2017', '1.0', 2024, 'T7 NOOS', 'Dsl', 138118.564529936),
	('2017', '1.0', 2024, 'T7 Other Port', 'Dsl', 96196.9989532744),
	('2017', '1.0', 2024, 'T7 POLA', 'Dsl', 34739.2441692714),
	('2017', '1.0', 2024, 'T7 Single', 'Dsl', 142989.288590151),
	('2017', '1.0', 2024, 'T7 Single Construction', 'Dsl', 82203.8534366193),
	('2017', '1.0', 2024, 'T7 Tractor', 'Dsl', 517433.095729385),
	('2017', '1.0', 2024, 'T7 Tractor Construction', 'Dsl', 67810.941790698),
	('2017', '1.0', 2024, 'T7 SWCV', 'Dsl', 20056.3860219542),
	('2017', '1.0', 2024, 'LDT1', 'Elec', 76193.0227158191),
	('2017', '1.0', 2024, 'LDT2', 'Elec', 211904.09256256),
	('2017', '1.0', 2024, 'MDV', 'Elec', 132009.875037993),
	('2017', '1.0', 2024, 'T7 SWCV', 'NG', 43785.8317087397),
	('2017', '1.0', 2024, 'UBUS', 'Gas', 44934.8227559107),
	('2017', '1.0', 2024, 'SBUS', 'Gas', 16394.6378638256),
	('2017', '1.0', 2024, 'OBUS', 'Gas', 61109.5356223157),
	('2017', '1.0', 2024, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2024, 'SBUS', 'Dsl', 74434.0982255977),
	('2017', '1.0', 2024, 'Motor Coach', 'Dsl', 25749.7891850643),
	('2017', '1.0', 2024, 'All Other Buses', 'Dsl', 30187.6994518078),
	('2017', '1.0', 2024, 'UBUS', 'NG', 128970.173929345),
	('2017', '1.0', 2024, 'MCY', 'Gas', 625860.671703682),
	('2017', '1.0', 2024, 'MH', 'Gas', 85692.5763909802),
	('2017', '1.0', 2024, 'MH', 'Dsl', 33988.3403465279),
	('2017', '1.0', 2025, 'LDA', 'Gas', 56754206.9015478),
	('2017', '1.0', 2025, 'LDA', 'Dsl', 690321.668204181),
	('2017', '1.0', 2025, 'LDA', 'Elec', 2068368.30199744),
	('2017', '1.0', 2025, 'LDT1', 'Gas', 5960108.8626605),
	('2017', '1.0', 2025, 'LDT2', 'Gas', 17314400.1249172),
	('2017', '1.0', 2025, 'MDV', 'Gas', 11174917.0873842),
	('2017', '1.0', 2025, 'LHD1', 'Gas', 1211073.79901396),
	('2017', '1.0', 2025, 'LHD2', 'Gas', 197013.847649085),
	('2017', '1.0', 2025, 'T6TS', 'Gas', 223952.112193934),
	('2017', '1.0', 2025, 'T7IS', 'Gas', 2160.8119390204),
	('2017', '1.0', 2025, 'LDT1', 'Dsl', 1609.12394534806),
	('2017', '1.0', 2025, 'LDT2', 'Dsl', 145971.130114037),
	('2017', '1.0', 2025, 'MDV', 'Dsl', 345420.9236397),
	('2017', '1.0', 2025, 'LHD1', 'Dsl', 1237477.07784608),
	('2017', '1.0', 2025, 'LHD2', 'Dsl', 458167.032696793),
	('2017', '1.0', 2025, 'T6 Ag', 'Dsl', 272.16043734417),
	('2017', '1.0', 2025, 'T6 Public', 'Dsl', 39128.8986523938),
	('2017', '1.0', 2025, 'T6 CAIRP Small', 'Dsl', 2571.41313417984),
	('2017', '1.0', 2025, 'T6 CAIRP Heavy', 'Dsl', 17767.1549949934),
	('2017', '1.0', 2025, 'T6 Instate Construction Small', 'Dsl', 120106.958465235),
	('2017', '1.0', 2025, 'T6 Instate Construction Heavy', 'Dsl', 45921.6603324473),
	('2017', '1.0', 2025, 'T6 Instate Small', 'Dsl', 605558.915580199),
	('2017', '1.0', 2025, 'T6 Instate Heavy', 'Dsl', 442272.342835426),
	('2017', '1.0', 2025, 'T6 OOS Small', 'Dsl', 1486.79735617234),
	('2017', '1.0', 2025, 'T6 OOS Heavy', 'Dsl', 10259.7405449726),
	('2017', '1.0', 2025, 'T6 Utility', 'Dsl', 5479.40256641492),
	('2017', '1.0', 2025, 'T7 Ag', 'Dsl', 174.620962500733),
	('2017', '1.0', 2025, 'T7 Public', 'Dsl', 30240.3558580549),
	('2017', '1.0', 2025, 'PTO', 'Dsl', 28708.8394204249),
	('2017', '1.0', 2025, 'T7 CAIRP', 'Dsl', 357088.077754161),
	('2017', '1.0', 2025, 'T7 CAIRP Construction', 'Dsl', 32985.9275272752),
	('2017', '1.0', 2025, 'T7 Utility', 'Dsl', 2640.66666569444),
	('2017', '1.0', 2025, 'T7 NNOOS', 'Dsl', 435295.375597353),
	('2017', '1.0', 2025, 'T7 NOOS', 'Dsl', 140297.531363531),
	('2017', '1.0', 2025, 'T7 Other Port', 'Dsl', 99233.6503107908),
	('2017', '1.0', 2025, 'T7 POLA', 'Dsl', 36619.6301338928),
	('2017', '1.0', 2025, 'T7 Single', 'Dsl', 144583.453742768),
	('2017', '1.0', 2025, 'T7 Single Construction', 'Dsl', 81832.0190839017),
	('2017', '1.0', 2025, 'T7 Tractor', 'Dsl', 527711.424793603),
	('2017', '1.0', 2025, 'T7 Tractor Construction', 'Dsl', 67504.2111863071),
	('2017', '1.0', 2025, 'T7 SWCV', 'Dsl', 18264.0773037026),
	('2017', '1.0', 2025, 'LDT1', 'Elec', 96350.2474716881),
	('2017', '1.0', 2025, 'LDT2', 'Elec', 251820.347668728),
	('2017', '1.0', 2025, 'MDV', 'Elec', 162831.984149394),
	('2017', '1.0', 2025, 'T7 SWCV', 'NG', 46869.1542130905),
	('2017', '1.0', 2025, 'UBUS', 'Gas', 46393.92130127),
	('2017', '1.0', 2025, 'SBUS', 'Gas', 17301.8373990139),
	('2017', '1.0', 2025, 'OBUS', 'Gas', 60038.836343938),
	('2017', '1.0', 2025, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2025, 'SBUS', 'Dsl', 73642.2893497003),
	('2017', '1.0', 2025, 'Motor Coach', 'Dsl', 26159.2257068172),
	('2017', '1.0', 2025, 'All Other Buses', 'Dsl', 30342.6791751076),
	('2017', '1.0', 2025, 'UBUS', 'NG', 133158.021608133),
	('2017', '1.0', 2025, 'MCY', 'Gas', 619719.788451345),
	('2017', '1.0', 2025, 'MH', 'Gas', 82862.9329735183),
	('2017', '1.0', 2025, 'MH', 'Dsl', 33693.7874228924),
	('2017', '1.0', 2026, 'LDA', 'Gas', 57093644.1468361),
	('2017', '1.0', 2026, 'LDA', 'Dsl', 697799.058606399),
	('2017', '1.0', 2026, 'LDA', 'Elec', 2309504.76675885),
	('2017', '1.0', 2026, 'LDT1', 'Gas', 5963916.81430919),
	('2017', '1.0', 2026, 'LDT2', 'Gas', 17200885.2052848),
	('2017', '1.0', 2026, 'MDV', 'Gas', 11077548.4154823),
	('2017', '1.0', 2026, 'LHD1', 'Gas', 1199913.74308324),
	('2017', '1.0', 2026, 'LHD2', 'Gas', 197353.260764152),
	('2017', '1.0', 2026, 'T6TS', 'Gas', 229372.681795205),
	('2017', '1.0', 2026, 'T7IS', 'Gas', 2199.02546753991),
	('2017', '1.0', 2026, 'LDT1', 'Dsl', 1453.29306944409),
	('2017', '1.0', 2026, 'LDT2', 'Dsl', 150275.328588656),
	('2017', '1.0', 2026, 'MDV', 'Dsl', 352143.765090525),
	('2017', '1.0', 2026, 'LHD1', 'Dsl', 1247127.84615239),
	('2017', '1.0', 2026, 'LHD2', 'Dsl', 465546.424907211),
	('2017', '1.0', 2026, 'T6 Ag', 'Dsl', 244.509155416706),
	('2017', '1.0', 2026, 'T6 Public', 'Dsl', 39494.5449524899),
	('2017', '1.0', 2026, 'T6 CAIRP Small', 'Dsl', 2614.38783332907),
	('2017', '1.0', 2026, 'T6 CAIRP Heavy', 'Dsl', 18029.7416390326),
	('2017', '1.0', 2026, 'T6 Instate Construction Small', 'Dsl', 121197.676697508),
	('2017', '1.0', 2026, 'T6 Instate Construction Heavy', 'Dsl', 46338.6852310953),
	('2017', '1.0', 2026, 'T6 Instate Small', 'Dsl', 620567.036484004),
	('2017', '1.0', 2026, 'T6 Instate Heavy', 'Dsl', 453745.754002522),
	('2017', '1.0', 2026, 'T6 OOS Small', 'Dsl', 1512.09572294039),
	('2017', '1.0', 2026, 'T6 OOS Heavy', 'Dsl', 10414.9021638202),
	('2017', '1.0', 2026, 'T6 Utility', 'Dsl', 5525.04807489898),
	('2017', '1.0', 2026, 'T7 Ag', 'Dsl', 154.641171585997),
	('2017', '1.0', 2026, 'T7 Public', 'Dsl', 29972.150109304),
	('2017', '1.0', 2026, 'PTO', 'Dsl', 29042.1169395302),
	('2017', '1.0', 2026, 'T7 CAIRP', 'Dsl', 362608.240899071),
	('2017', '1.0', 2026, 'T7 CAIRP Construction', 'Dsl', 33285.4801345693),
	('2017', '1.0', 2026, 'T7 Utility', 'Dsl', 2662.78731727309),
	('2017', '1.0', 2026, 'T7 NNOOS', 'Dsl', 442020.0432406),
	('2017', '1.0', 2026, 'T7 NOOS', 'Dsl', 142466.841347502),
	('2017', '1.0', 2026, 'T7 Other Port', 'Dsl', 102205.876188529),
	('2017', '1.0', 2026, 'T7 POLA', 'Dsl', 38818.4151458747),
	('2017', '1.0', 2026, 'T7 Single', 'Dsl', 146261.905945638),
	('2017', '1.0', 2026, 'T7 Single Construction', 'Dsl', 82575.1540058005),
	('2017', '1.0', 2026, 'T7 Tractor', 'Dsl', 537929.854719551),
	('2017', '1.0', 2026, 'T7 Tractor Construction', 'Dsl', 68117.2320706663),
	('2017', '1.0', 2026, 'T7 SWCV', 'Dsl', 16531.1254436795),
	('2017', '1.0', 2026, 'LDT1', 'Elec', 112519.671864118),
	('2017', '1.0', 2026, 'LDT2', 'Elec', 289021.786705545),
	('2017', '1.0', 2026, 'MDV', 'Elec', 191723.566220141),
	('2017', '1.0', 2026, 'T7 SWCV', 'NG', 49957.0382225439),
	('2017', '1.0', 2026, 'UBUS', 'Gas', 47853.0198466294),
	('2017', '1.0', 2026, 'SBUS', 'Gas', 18274.2282925221),
	('2017', '1.0', 2026, 'OBUS', 'Gas', 59162.936817705),
	('2017', '1.0', 2026, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2026, 'SBUS', 'Dsl', 72615.1161645869),
	('2017', '1.0', 2026, 'Motor Coach', 'Dsl', 26566.5278327514),
	('2017', '1.0', 2026, 'All Other Buses', 'Dsl', 30443.5075717498),
	('2017', '1.0', 2026, 'UBUS', 'NG', 137345.86928692),
	('2017', '1.0', 2026, 'MCY', 'Gas', 614738.618338323),
	('2017', '1.0', 2026, 'MH', 'Gas', 80300.0125764853),
	('2017', '1.0', 2026, 'MH', 'Dsl', 33430.600032959),
	('2017', '1.0', 2029, 'LDA', 'Gas', 58295243.1935054),
    ('2017', '1.0', 2029, 'LDA', 'Dsl', 717836.103517089),
    ('2017', '1.0', 2029, 'LDA', 'Elec', 2943211.28583324),
    ('2017', '1.0', 2029, 'LDT1', 'Gas', 6021952.81494054),
    ('2017', '1.0', 2029, 'LDT2', 'Gas', 17105120.9702451),
    ('2017', '1.0', 2029, 'MDV', 'Gas', 10957716.0180508),
    ('2017', '1.0', 2029, 'LHD1', 'Gas', 1181873.89321324),
    ('2017', '1.0', 2029, 'LHD2', 'Gas', 199001.838769153),
    ('2017', '1.0', 2029, 'T6TS', 'Gas', 243782.265922778),
    ('2017', '1.0', 2029, 'T7IS', 'Gas', 2307.98702182151),
    ('2017', '1.0', 2029, 'LDT1', 'Dsl', 935.902795822),
    ('2017', '1.0', 2029, 'LDT2', 'Dsl', 161132.766513656),
    ('2017', '1.0', 2029, 'MDV', 'Dsl', 369777.397409912),
    ('2017', '1.0', 2029, 'LHD1', 'Dsl', 1276631.00058037),
    ('2017', '1.0', 2029, 'LHD2', 'Dsl', 486247.970525844),
    ('2017', '1.0', 2029, 'T6 Ag', 'Dsl', 175.810486710523),
    ('2017', '1.0', 2029, 'T6 Public', 'Dsl', 40402.5643798762),
    ('2017', '1.0', 2029, 'T6 CAIRP Small', 'Dsl', 2731.49902444815),
    ('2017', '1.0', 2029, 'T6 CAIRP Heavy', 'Dsl', 18768.3704873861),
    ('2017', '1.0', 2029, 'T6 Instate Construction Small', 'Dsl', 124427.615143837),
    ('2017', '1.0', 2029, 'T6 Instate Construction Heavy', 'Dsl', 47573.6189778353),
    ('2017', '1.0', 2029, 'T6 Instate Small', 'Dsl', 659966.088830014),
    ('2017', '1.0', 2029, 'T6 Instate Heavy', 'Dsl', 484104.390835872),
    ('2017', '1.0', 2029, 'T6 OOS Small', 'Dsl', 1580.79750238668),
    ('2017', '1.0', 2029, 'T6 OOS Heavy', 'Dsl', 10847.827893582),
    ('2017', '1.0', 2029, 'T6 Utility', 'Dsl', 5659.7536192187),
    ('2017', '1.0', 2029, 'T7 Ag', 'Dsl', 101.069424966104),
    ('2017', '1.0', 2029, 'T7 Public', 'Dsl', 29879.7472771077),
    ('2017', '1.0', 2029, 'PTO', 'Dsl', 29997.3321974027),
    ('2017', '1.0', 2029, 'T7 CAIRP', 'Dsl', 377899.056813831),
    ('2017', '1.0', 2029, 'T7 CAIRP Construction', 'Dsl', 34172.5437724266),
    ('2017', '1.0', 2029, 'T7 Utility', 'Dsl', 2728.51947627886),
    ('2017', '1.0', 2029, 'T7 NNOOS', 'Dsl', 460649.494972344),
    ('2017', '1.0', 2029, 'T7 NOOS', 'Dsl', 148475.675587856),
    ('2017', '1.0', 2029, 'T7 Other Port', 'Dsl', 107720.637543069),
    ('2017', '1.0', 2029, 'T7 POLA', 'Dsl', 45648.9399597067),
    ('2017', '1.0', 2029, 'T7 Single', 'Dsl', 151072.560915993),
    ('2017', '1.0', 2029, 'T7 Single Construction', 'Dsl', 84775.7957334506),
    ('2017', '1.0', 2029, 'T7 Tractor', 'Dsl', 566021.063301376),
    ('2017', '1.0', 2029, 'T7 Tractor Construction', 'Dsl', 69932.5677496801),
    ('2017', '1.0', 2029, 'T7 SWCV', 'Dsl', 12074.0029888749),
    ('2017', '1.0', 2029, 'LDT1', 'Elec', 155431.163164544),
    ('2017', '1.0', 2029, 'LDT2', 'Elec', 384112.222745531),
    ('2017', '1.0', 2029, 'MDV', 'Elec', 265489.996244393),
    ('2017', '1.0', 2029, 'T7 SWCV', 'NG', 58265.6527685596),
    ('2017', '1.0', 2029, 'UBUS', 'Gas', 52230.3154827067),
    ('2017', '1.0', 2029, 'SBUS', 'Gas', 22450.7155659242),
    ('2017', '1.0', 2029, 'OBUS', 'Gas', 57414.2932319195),
    ('2017', '1.0', 2029, 'UBUS', 'Dsl', 0),
    ('2017', '1.0', 2029, 'SBUS', 'Dsl', 68066.3113461401),
    ('2017', '1.0', 2029, 'Motor Coach', 'Dsl', 27693.5403054525),
    ('2017', '1.0', 2029, 'All Other Buses', 'Dsl', 30682.1918708305),
    ('2017', '1.0', 2029, 'UBUS', 'NG', 149909.412323279),
    ('2017', '1.0', 2029, 'MCY', 'Gas', 604720.834202591),
    ('2017', '1.0', 2029, 'MH', 'Gas', 74209.6167204858),
    ('2017', '1.0', 2029, 'MH', 'Dsl', 32696.9763976226),
	('2017', '1.0', 2030, 'LDA', 'Gas', 58643392.1213564),
	('2017', '1.0', 2030, 'LDA', 'Dsl', 723194.982733142),
	('2017', '1.0', 2030, 'LDA', 'Elec', 3120492.41662785),
	('2017', '1.0', 2030, 'LDT1', 'Gas', 6042844.30832609),
	('2017', '1.0', 2030, 'LDT2', 'Gas', 17103403.9153146),
	('2017', '1.0', 2030, 'MDV', 'Gas', 10944818.8431182),
	('2017', '1.0', 2030, 'LHD1', 'Gas', 1179447.6133155),
	('2017', '1.0', 2030, 'LHD2', 'Gas', 199832.804855525),
	('2017', '1.0', 2030, 'T6TS', 'Gas', 248004.21090808),
	('2017', '1.0', 2030, 'T7IS', 'Gas', 2341.16314787932),
	('2017', '1.0', 2030, 'LDT1', 'Dsl', 852.713045268351),
	('2017', '1.0', 2030, 'LDT2', 'Dsl', 163906.531339999),
	('2017', '1.0', 2030, 'MDV', 'Dsl', 374468.360911417),
	('2017', '1.0', 2030, 'LHD1', 'Dsl', 1287014.65954094),
	('2017', '1.0', 2030, 'LHD2', 'Dsl', 492672.229321154),
	('2017', '1.0', 2030, 'T6 Ag', 'Dsl', 156.420566685599),
	('2017', '1.0', 2030, 'T6 Public', 'Dsl', 40680.5056984451),
	('2017', '1.0', 2030, 'T6 CAIRP Small', 'Dsl', 2765.01328235627),
	('2017', '1.0', 2030, 'T6 CAIRP Heavy', 'Dsl', 18984.2930019115),
	('2017', '1.0', 2030, 'T6 Instate Construction Small', 'Dsl', 125490.194228726),
	('2017', '1.0', 2030, 'T6 Instate Construction Heavy', 'Dsl', 47979.8851628765),
	('2017', '1.0', 2030, 'T6 Instate Small', 'Dsl', 671076.177310353),
	('2017', '1.0', 2030, 'T6 Instate Heavy', 'Dsl', 492941.521251334),
	('2017', '1.0', 2030, 'T6 OOS Small', 'Dsl', 1600.44665096334),
	('2017', '1.0', 2030, 'T6 OOS Heavy', 'Dsl', 10973.7877353531),
	('2017', '1.0', 2030, 'T6 Utility', 'Dsl', 5702.55499318767),
	('2017', '1.0', 2030, 'T7 Ag', 'Dsl', 87.2208335601758),
	('2017', '1.0', 2030, 'T7 Public', 'Dsl', 29864.5216092669),
	('2017', '1.0', 2030, 'PTO', 'Dsl', 30276.4879875933),
	('2017', '1.0', 2030, 'T7 CAIRP', 'Dsl', 382327.926359806),
	('2017', '1.0', 2030, 'T7 CAIRP Construction', 'Dsl', 34464.3669237046),
	('2017', '1.0', 2030, 'T7 Utility', 'Dsl', 2749.48370842396),
	('2017', '1.0', 2030, 'T7 NNOOS', 'Dsl', 466045.938923866),
	('2017', '1.0', 2030, 'T7 NOOS', 'Dsl', 150216.023627893),
	('2017', '1.0', 2030, 'T7 Other Port', 'Dsl', 109479.209953526),
	('2017', '1.0', 2030, 'T7 POLA', 'Dsl', 47983.7480244276),
	('2017', '1.0', 2030, 'T7 Single', 'Dsl', 152478.445274012),
	('2017', '1.0', 2030, 'T7 Single Construction', 'Dsl', 85499.7552966537),
	('2017', '1.0', 2030, 'T7 Tractor', 'Dsl', 574170.152300117),
	('2017', '1.0', 2030, 'T7 Tractor Construction', 'Dsl', 70529.7706513304),
	('2017', '1.0', 2030, 'T7 SWCV', 'Dsl', 10750.3611641086),
	('2017', '1.0', 2030, 'LDT1', 'Elec', 167796.951045855),
	('2017', '1.0', 2030, 'LDT2', 'Elec', 411255.710867086),
	('2017', '1.0', 2030, 'MDV', 'Elec', 286401.030225361),
	('2017', '1.0', 2030, 'T7 SWCV', 'NG', 60751.1249491543),
	('2017', '1.0', 2030, 'UBUS', 'Gas', 53689.4140280663),
	('2017', '1.0', 2030, 'SBUS', 'Gas', 23832.0248782068),
	('2017', '1.0', 2030, 'OBUS', 'Gas', 57080.1686378322),
	('2017', '1.0', 2030, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2030, 'SBUS', 'Dsl', 66263.7689705135),
	('2017', '1.0', 2030, 'Motor Coach', 'Dsl', 28019.6447021765),
	('2017', '1.0', 2030, 'All Other Buses', 'Dsl', 30731.2676688904),
	('2017', '1.0', 2030, 'UBUS', 'NG', 154097.260002067),
	('2017', '1.0', 2030, 'MCY', 'Gas', 602831.193805678),
	('2017', '1.0', 2030, 'MH', 'Gas', 72727.8681752379),
	('2017', '1.0', 2030, 'MH', 'Dsl', 32498.7476495335),
	('2017', '1.0', 2032, 'LDA', 'Gas', 59279976.1893565),
	('2017', '1.0', 2032, 'LDA', 'Dsl', 732879.970302371),
	('2017', '1.0', 2032, 'LDA', 'Elec', 3427043.42899407),
	('2017', '1.0', 2032, 'LDT1', 'Gas', 6086083.52718176),
	('2017', '1.0', 2032, 'LDT2', 'Gas', 17126436.57919),
	('2017', '1.0', 2032, 'MDV', 'Gas', 10951050.9035245),
	('2017', '1.0', 2032, 'LHD1', 'Gas', 1179783.1200914),
	('2017', '1.0', 2032, 'LHD2', 'Gas', 201523.486151378),
	('2017', '1.0', 2032, 'T6TS', 'Gas', 255468.747392031),
	('2017', '1.0', 2032, 'T7IS', 'Gas', 2404.39891945116),
	('2017', '1.0', 2032, 'LDT1', 'Dsl', 835.962050768801),
	('2017', '1.0', 2032, 'LDT2', 'Dsl', 168294.555903335),
	('2017', '1.0', 2032, 'MDV', 'Dsl', 382528.395831116),
	('2017', '1.0', 2032, 'LHD1', 'Dsl', 1309037.42793774),
	('2017', '1.0', 2032, 'LHD2', 'Dsl', 505034.21496433),
	('2017', '1.0', 2032, 'T6 Ag', 'Dsl', 119.56446189351),
	('2017', '1.0', 2032, 'T6 Public', 'Dsl', 41187.1541675973),
	('2017', '1.0', 2032, 'T6 CAIRP Small', 'Dsl', 2830.91651078509),
	('2017', '1.0', 2032, 'T6 CAIRP Heavy', 'Dsl', 19419.0873667369),
	('2017', '1.0', 2032, 'T6 Instate Construction Small', 'Dsl', 134729.717912999),
	('2017', '1.0', 2032, 'T6 Instate Construction Heavy', 'Dsl', 51512.5220199296),
	('2017', '1.0', 2032, 'T6 Instate Small', 'Dsl', 691388.83998312),
	('2017', '1.0', 2032, 'T6 Instate Heavy', 'Dsl', 509962.489045564),
	('2017', '1.0', 2032, 'T6 OOS Small', 'Dsl', 1639.0379080082),
	('2017', '1.0', 2032, 'T6 OOS Heavy', 'Dsl', 11226.5080341869),
	('2017', '1.0', 2032, 'T6 Utility', 'Dsl', 5788.17665670168),
	('2017', '1.0', 2032, 'T7 Ag', 'Dsl', 65.9674241313728),
	('2017', '1.0', 2032, 'T7 Public', 'Dsl', 29843.2970415493),
	('2017', '1.0', 2032, 'PTO', 'Dsl', 30867.2484273594),
	('2017', '1.0', 2032, 'T7 CAIRP', 'Dsl', 391184.37678062),
	('2017', '1.0', 2032, 'T7 CAIRP Construction', 'Dsl', 37001.8920438717),
	('2017', '1.0', 2032, 'T7 Utility', 'Dsl', 2791.4503064725),
	('2017', '1.0', 2032, 'T7 NNOOS', 'Dsl', 476838.840136581),
	('2017', '1.0', 2032, 'T7 NOOS', 'Dsl', 153696.028646143),
	('2017', '1.0', 2032, 'T7 Other Port', 'Dsl', 112999.489969877),
	('2017', '1.0', 2032, 'T7 POLA', 'Dsl', 51907.8647653376),
	('2017', '1.0', 2032, 'T7 Single', 'Dsl', 155453.632931901),
	('2017', '1.0', 2032, 'T7 Single Construction', 'Dsl', 91794.888392053),
	('2017', '1.0', 2032, 'T7 Tractor', 'Dsl', 590030.435489335),
	('2017', '1.0', 2032, 'T7 Tractor Construction', 'Dsl', 75722.7012263668),
	('2017', '1.0', 2032, 'T7 SWCV', 'Dsl', 8736.72358471161),
	('2017', '1.0', 2032, 'LDT1', 'Elec', 189778.273324956),
	('2017', '1.0', 2032, 'LDT2', 'Elec', 458993.955543098),
	('2017', '1.0', 2032, 'MDV', 'Elec', 323102.346750195),
	('2017', '1.0', 2032, 'T7 SWCV', 'NG', 65294.8965809238),
	('2017', '1.0', 2032, 'UBUS', 'Gas', 56607.6111187847),
	('2017', '1.0', 2032, 'SBUS', 'Gas', 26560.9113323598),
	('2017', '1.0', 2032, 'OBUS', 'Gas', 56726.1451663759),
	('2017', '1.0', 2032, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2032, 'SBUS', 'Dsl', 62843.3256401287),
	('2017', '1.0', 2032, 'Motor Coach', 'Dsl', 28671.2525693513),
	('2017', '1.0', 2032, 'All Other Buses', 'Dsl', 30681.7272862721),
	('2017', '1.0', 2032, 'UBUS', 'NG', 162472.95535964),
	('2017', '1.0', 2032, 'MCY', 'Gas', 600968.905060312),
	('2017', '1.0', 2032, 'MH', 'Gas', 70417.1048966328),
	('2017', '1.0', 2032, 'MH', 'Dsl', 32162.897144354),
	('2017', '1.0', 2035, 'LDA', 'Gas', 60161270.9992843),
	('2017', '1.0', 2035, 'LDA', 'Dsl', 746246.243227145),
	('2017', '1.0', 2035, 'LDA', 'Elec', 3780117.91100395),
	('2017', '1.0', 2035, 'LDT1', 'Gas', 6159579.6283566),
	('2017', '1.0', 2035, 'LDT2', 'Gas', 17230527.9954298),
	('2017', '1.0', 2035, 'MDV', 'Gas', 11020863.8098805),
	('2017', '1.0', 2035, 'LHD1', 'Gas', 1185631.46906399),
	('2017', '1.0', 2035, 'LHD2', 'Gas', 204627.935786422),
	('2017', '1.0', 2035, 'T6TS', 'Gas', 264563.405115612),
	('2017', '1.0', 2035, 'T7IS', 'Gas', 2479.24414393628),
	('2017', '1.0', 2035, 'LDT1', 'Dsl', 848.63463804637),
	('2017', '1.0', 2035, 'LDT2', 'Dsl', 173166.724563207),
	('2017', '1.0', 2035, 'MDV', 'Dsl', 392271.792422165),
	('2017', '1.0', 2035, 'LHD1', 'Dsl', 1342853.6902361),
	('2017', '1.0', 2035, 'LHD2', 'Dsl', 522173.877513016),
	('2017', '1.0', 2035, 'T6 Ag', 'Dsl', 69.3094972367595),
	('2017', '1.0', 2035, 'T6 Public', 'Dsl', 41983.1954252846),
	('2017', '1.0', 2035, 'T6 CAIRP Small', 'Dsl', 2928.19211582268),
	('2017', '1.0', 2035, 'T6 CAIRP Heavy', 'Dsl', 20073.7662850727),
	('2017', '1.0', 2035, 'T6 Instate Construction Small', 'Dsl', 149111.743895372),
	('2017', '1.0', 2035, 'T6 Instate Construction Heavy', 'Dsl', 57011.3417427362),
	('2017', '1.0', 2035, 'T6 Instate Small', 'Dsl', 719943.455335274),
	('2017', '1.0', 2035, 'T6 Instate Heavy', 'Dsl', 535458.213323117),
	('2017', '1.0', 2035, 'T6 OOS Small', 'Dsl', 1695.56335275692),
	('2017', '1.0', 2035, 'T6 OOS Heavy', 'Dsl', 11606.5142794177),
	('2017', '1.0', 2035, 'T6 Utility', 'Dsl', 5918.19966658331),
	('2017', '1.0', 2035, 'T7 Ag', 'Dsl', 46.209264865929),
	('2017', '1.0', 2035, 'T7 Public', 'Dsl', 29809.4465361707),
	('2017', '1.0', 2035, 'PTO', 'Dsl', 31817.7666622905),
	('2017', '1.0', 2035, 'T7 CAIRP', 'Dsl', 404467.522720991),
	('2017', '1.0', 2035, 'T7 CAIRP Construction', 'Dsl', 40951.7420176952),
	('2017', '1.0', 2035, 'T7 Utility', 'Dsl', 2855.00952666663),
	('2017', '1.0', 2035, 'T7 NNOOS', 'Dsl', 493028.202841818),
	('2017', '1.0', 2035, 'T7 NOOS', 'Dsl', 158915.179612541),
	('2017', '1.0', 2035, 'T7 Other Port', 'Dsl', 118283.69135942),
	('2017', '1.0', 2035, 'T7 POLA', 'Dsl', 57603.9390893006),
	('2017', '1.0', 2035, 'T7 Single', 'Dsl', 160240.632755867),
	('2017', '1.0', 2035, 'T7 Single Construction', 'Dsl', 101593.739680052),
	('2017', '1.0', 2035, 'T7 Tractor', 'Dsl', 613024.37368946),
	('2017', '1.0', 2035, 'T7 Tractor Construction', 'Dsl', 83805.8908400815),
	('2017', '1.0', 2035, 'T7 SWCV', 'Dsl', 6450.1427322381),
	('2017', '1.0', 2035, 'LDT1', 'Elec', 216578.737560418),
	('2017', '1.0', 2035, 'LDT2', 'Elec', 515173.83879364),
	('2017', '1.0', 2035, 'MDV', 'Elec', 366845.339167316),
	('2017', '1.0', 2035, 'T7 SWCV', 'NG', 71069.7725130796),
	('2017', '1.0', 2035, 'UBUS', 'Gas', 60984.9067548628),
	('2017', '1.0', 2035, 'SBUS', 'Gas', 30389.2621681957),
	('2017', '1.0', 2035, 'OBUS', 'Gas', 56721.6927859057),
	('2017', '1.0', 2035, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2035, 'SBUS', 'Dsl', 59746.6864323547),
	('2017', '1.0', 2035, 'Motor Coach', 'Dsl', 29648.6289349906),
	('2017', '1.0', 2035, 'All Other Buses', 'Dsl', 30489.0980676738),
	('2017', '1.0', 2035, 'UBUS', 'NG', 175036.498396002),
	('2017', '1.0', 2035, 'MCY', 'Gas', 602328.120365036),
	('2017', '1.0', 2035, 'MH', 'Gas', 68440.9911386433),
	('2017', '1.0', 2035, 'MH', 'Dsl', 31748.9324803444),
	('2017', '1.0', 2040, 'LDA', 'Gas', 61543177.3378523),
	('2017', '1.0', 2040, 'LDA', 'Dsl', 766461.550234153),
	('2017', '1.0', 2040, 'LDA', 'Elec', 4145268.16133039),
	('2017', '1.0', 2040, 'LDT1', 'Gas', 6287838.96672777),
	('2017', '1.0', 2040, 'LDT2', 'Gas', 17521582.3560852),
	('2017', '1.0', 2040, 'MDV', 'Gas', 11214088.7574463),
	('2017', '1.0', 2040, 'LHD1', 'Gas', 1207250.21990281),
	('2017', '1.0', 2040, 'LHD2', 'Gas', 210440.490735904),
	('2017', '1.0', 2040, 'T6TS', 'Gas', 275501.496070627),
	('2017', '1.0', 2040, 'T7IS', 'Gas', 2569.18042374718),
	('2017', '1.0', 2040, 'LDT1', 'Dsl', 874.758179080279),
	('2017', '1.0', 2040, 'LDT2', 'Dsl', 179477.843684848),
	('2017', '1.0', 2040, 'MDV', 'Dsl', 404906.895340399),
	('2017', '1.0', 2040, 'LHD1', 'Dsl', 1391315.63021982),
	('2017', '1.0', 2040, 'LHD2', 'Dsl', 545475.909206923),
	('2017', '1.0', 2040, 'T6 Ag', 'Dsl', 30.019746061821),
	('2017', '1.0', 2040, 'T6 Public', 'Dsl', 43149.3797397051),
	('2017', '1.0', 2040, 'T6 CAIRP Small', 'Dsl', 3089.23991493893),
	('2017', '1.0', 2040, 'T6 CAIRP Heavy', 'Dsl', 21169.1564682858),
	('2017', '1.0', 2040, 'T6 Instate Construction Small', 'Dsl', 175534.584838551),
	('2017', '1.0', 2040, 'T6 Instate Construction Heavy', 'Dsl', 67113.8432323744),
	('2017', '1.0', 2040, 'T6 Instate Small', 'Dsl', 764418.513136265),
	('2017', '1.0', 2040, 'T6 Instate Heavy', 'Dsl', 576040.840673966),
	('2017', '1.0', 2040, 'T6 OOS Small', 'Dsl', 1789.040348777),
	('2017', '1.0', 2040, 'T6 OOS Heavy', 'Dsl', 12240.917859118),
	('2017', '1.0', 2040, 'T6 Utility', 'Dsl', 6110.536635433),
	('2017', '1.0', 2040, 'T7 Ag', 'Dsl', 22.8221882765871),
	('2017', '1.0', 2040, 'T7 Public', 'Dsl', 29926.3033516476),
	('2017', '1.0', 2040, 'PTO', 'Dsl', 33563.3411895505),
	('2017', '1.0', 2040, 'T7 CAIRP', 'Dsl', 426604.524922029),
	('2017', '1.0', 2040, 'T7 CAIRP Construction', 'Dsl', 48208.4565957158),
	('2017', '1.0', 2040, 'T7 Utility', 'Dsl', 2948.80402074702),
	('2017', '1.0', 2040, 'T7 NNOOS', 'Dsl', 520010.52973588),
	('2017', '1.0', 2040, 'T7 NOOS', 'Dsl', 167612.986430888),
	('2017', '1.0', 2040, 'T7 Other Port', 'Dsl', 127086.890369923),
	('2017', '1.0', 2040, 'T7 POLA', 'Dsl', 68107.7113557936),
	('2017', '1.0', 2040, 'T7 Single', 'Dsl', 169031.694986585),
	('2017', '1.0', 2040, 'T7 Single Construction', 'Dsl', 119596.313818493),
	('2017', '1.0', 2040, 'T7 Tractor', 'Dsl', 649641.621360541),
	('2017', '1.0', 2040, 'T7 Tractor Construction', 'Dsl', 98656.4295429391),
	('2017', '1.0', 2040, 'T7 SWCV', 'Dsl', 4006.10753294759),
	('2017', '1.0', 2040, 'LDT1', 'Elec', 247505.18821317),
	('2017', '1.0', 2040, 'LDT2', 'Elec', 573635.004506412),
	('2017', '1.0', 2040, 'MDV', 'Elec', 414764.636595657),
	('2017', '1.0', 2040, 'T7 SWCV', 'NG', 78081.2098427947),
	('2017', '1.0', 2040, 'UBUS', 'Gas', 63789.7310726501),
	('2017', '1.0', 2040, 'SBUS', 'Gas', 37290.4363446339),
	('2017', '1.0', 2040, 'OBUS', 'Gas', 57563.9802496635),
	('2017', '1.0', 2040, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2040, 'SBUS', 'Dsl', 60155.7510031809),
	('2017', '1.0', 2040, 'Motor Coach', 'Dsl', 31276.134226009),
	('2017', '1.0', 2040, 'All Other Buses', 'Dsl', 30768.0780571775),
	('2017', '1.0', 2040, 'UBUS', 'NG', 183086.795647006),
	('2017', '1.0', 2040, 'MCY', 'Gas', 610227.246926743),
	('2017', '1.0', 2040, 'MH', 'Gas', 67621.6934916037),
	('2017', '1.0', 2040, 'MH', 'Dsl', 31234.948656354),
	('2017', '1.0', 2045, 'LDA', 'Gas', 62881551.0256916),
	('2017', '1.0', 2045, 'LDA', 'Dsl', 784560.737056601),
	('2017', '1.0', 2045, 'LDA', 'Elec', 4339163.9196289),
	('2017', '1.0', 2045, 'LDT1', 'Gas', 6419865.60673603),
	('2017', '1.0', 2045, 'LDT2', 'Gas', 17855438.3426912),
	('2017', '1.0', 2045, 'MDV', 'Gas', 11434156.1638779),
	('2017', '1.0', 2045, 'LHD1', 'Gas', 1229700.67118615),
	('2017', '1.0', 2045, 'LHD2', 'Gas', 216195.266558271),
	('2017', '1.0', 2045, 'T6TS', 'Gas', 283358.501354427),
	('2017', '1.0', 2045, 'T7IS', 'Gas', 2636.39245650845),
	('2017', '1.0', 2045, 'LDT1', 'Dsl', 897.144523835352),
	('2017', '1.0', 2045, 'LDT2', 'Dsl', 184658.25771467),
	('2017', '1.0', 2045, 'MDV', 'Dsl', 415507.349464255),
	('2017', '1.0', 2045, 'LHD1', 'Dsl', 1433414.17265227),
	('2017', '1.0', 2045, 'LHD2', 'Dsl', 565308.981154924),
	('2017', '1.0', 2045, 'T6 Ag', 'Dsl', 7.60180407380658),
	('2017', '1.0', 2045, 'T6 Public', 'Dsl', 44212.6225061575),
	('2017', '1.0', 2045, 'T6 CAIRP Small', 'Dsl', 3249.76978455022),
	('2017', '1.0', 2045, 'T6 CAIRP Heavy', 'Dsl', 22266.7342619405),
	('2017', '1.0', 2045, 'T6 Instate Construction Small', 'Dsl', 214907.592179004),
	('2017', '1.0', 2045, 'T6 Instate Construction Heavy', 'Dsl', 82167.7076583777),
	('2017', '1.0', 2045, 'T6 Instate Small', 'Dsl', 806353.021767028),
	('2017', '1.0', 2045, 'T6 Instate Heavy', 'Dsl', 612576.236703815),
	('2017', '1.0', 2045, 'T6 OOS Small', 'Dsl', 1882.23627389276),
	('2017', '1.0', 2045, 'T6 OOS Heavy', 'Dsl', 12875.865878857),
	('2017', '1.0', 2045, 'T6 Utility', 'Dsl', 6284.01168869477),
	('2017', '1.0', 2045, 'T7 Ag', 'Dsl', 7.70649998971793),
	('2017', '1.0', 2045, 'T7 Public', 'Dsl', 30331.482641998),
	('2017', '1.0', 2045, 'PTO', 'Dsl', 35324.1439886115),
	('2017', '1.0', 2045, 'T7 CAIRP', 'Dsl', 448740.654316914),
	('2017', '1.0', 2045, 'T7 CAIRP Construction', 'Dsl', 59021.778182233),
	('2017', '1.0', 2045, 'T7 Utility', 'Dsl', 3032.99577051759),
	('2017', '1.0', 2045, 'T7 NNOOS', 'Dsl', 546992.891003678),
	('2017', '1.0', 2045, 'T7 NOOS', 'Dsl', 176310.34015927),
	('2017', '1.0', 2045, 'T7 Other Port', 'Dsl', 135892.275487054),
	('2017', '1.0', 2045, 'T7 POLA', 'Dsl', 77496.262369472),
	('2017', '1.0', 2045, 'T7 Single', 'Dsl', 177899.449837972),
	('2017', '1.0', 2045, 'T7 Single Construction', 'Dsl', 146422.17577725),
	('2017', '1.0', 2045, 'T7 Tractor', 'Dsl', 684598.81745021),
	('2017', '1.0', 2045, 'T7 Tractor Construction', 'Dsl', 120785.403888078),
	('2017', '1.0', 2045, 'T7 SWCV', 'Dsl', 2110.3867227581),
	('2017', '1.0', 2045, 'LDT1', 'Elec', 265968.251266481),
	('2017', '1.0', 2045, 'LDT2', 'Elec', 603789.597641493),
	('2017', '1.0', 2045, 'MDV', 'Elec', 441360.427261975),
	('2017', '1.0', 2045, 'T7 SWCV', 'NG', 83354.8128352638),
	('2017', '1.0', 2045, 'UBUS', 'Gas', 66594.5553904373),
	('2017', '1.0', 2045, 'SBUS', 'Gas', 44037.2715237603),
	('2017', '1.0', 2045, 'OBUS', 'Gas', 58575.2873909166),
	('2017', '1.0', 2045, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2045, 'SBUS', 'Dsl', 61032.5902338304),
	('2017', '1.0', 2045, 'Motor Coach', 'Dsl', 32900.7262440619),
	('2017', '1.0', 2045, 'All Other Buses', 'Dsl', 31229.8464843433),
	('2017', '1.0', 2045, 'UBUS', 'NG', 191137.092898011),
	('2017', '1.0', 2045, 'MCY', 'Gas', 620483.89319506),
	('2017', '1.0', 2045, 'MH', 'Gas', 68149.8447761729),
	('2017', '1.0', 2045, 'MH', 'Dsl', 30969.5251638768),
	('2017', '1.0', 2050, 'LDA', 'Gas', 64175557.1685459),
	('2017', '1.0', 2050, 'LDA', 'Dsl', 801264.601584109),
	('2017', '1.0', 2050, 'LDA', 'Elec', 4461620.95995062),
	('2017', '1.0', 2050, 'LDT1', 'Gas', 6561852.96937462),
	('2017', '1.0', 2050, 'LDT2', 'Gas', 18197180.7226008),
	('2017', '1.0', 2050, 'MDV', 'Gas', 11639272.1276311),
	('2017', '1.0', 2050, 'LHD1', 'Gas', 1250460.13547759),
	('2017', '1.0', 2050, 'LHD2', 'Gas', 221454.281167033),
	('2017', '1.0', 2050, 'T6TS', 'Gas', 289964.86682496),
	('2017', '1.0', 2050, 'T7IS', 'Gas', 2695.33124543815),
	('2017', '1.0', 2050, 'LDT1', 'Dsl', 919.619814282664),
	('2017', '1.0', 2050, 'LDT2', 'Dsl', 189190.731194145),
	('2017', '1.0', 2050, 'MDV', 'Dsl', 425164.74265219),
	('2017', '1.0', 2050, 'LHD1', 'Dsl', 1469714.02064261),
	('2017', '1.0', 2050, 'LHD2', 'Dsl', 580022.570236855),
	('2017', '1.0', 2050, 'T6 Ag', 'Dsl', 0.649476899484862),
	('2017', '1.0', 2050, 'T6 Public', 'Dsl', 45202.7057666132),
	('2017', '1.0', 2050, 'T6 CAIRP Small', 'Dsl', 3410.14787279998),
	('2017', '1.0', 2050, 'T6 CAIRP Heavy', 'Dsl', 23364.8862579448),
	('2017', '1.0', 2050, 'T6 Instate Construction Small', 'Dsl', 244750.23749481),
	('2017', '1.0', 2050, 'T6 Instate Construction Heavy', 'Dsl', 93577.7361790047),
	('2017', '1.0', 2050, 'T6 Instate Small', 'Dsl', 846932.439856954),
	('2017', '1.0', 2050, 'T6 Instate Heavy', 'Dsl', 646768.938204074),
	('2017', '1.0', 2050, 'T6 OOS Small', 'Dsl', 1975.26980496966),
	('2017', '1.0', 2050, 'T6 OOS Heavy', 'Dsl', 13510.9562469385),
	('2017', '1.0', 2050, 'T6 Utility', 'Dsl', 6439.9366094987),
	('2017', '1.0', 2050, 'T7 Ag', 'Dsl', 1.30550327060958),
	('2017', '1.0', 2050, 'T7 Public', 'Dsl', 30743.1956339982),
	('2017', '1.0', 2050, 'PTO', 'Dsl', 37085.7293434642),
	('2017', '1.0', 2050, 'T7 CAIRP', 'Dsl', 470876.59834834),
	('2017', '1.0', 2050, 'T7 CAIRP Construction', 'Dsl', 67217.7007847881),
	('2017', '1.0', 2050, 'T7 Utility', 'Dsl', 3108.62347273769),
	('2017', '1.0', 2050, 'T7 NNOOS', 'Dsl', 573975.26573398),
	('2017', '1.0', 2050, 'T7 NOOS', 'Dsl', 185007.591947269),
	('2017', '1.0', 2050, 'T7 Other Port', 'Dsl', 144698.299985726),
	('2017', '1.0', 2050, 'T7 POLA', 'Dsl', 87181.3885465312),
	('2017', '1.0', 2050, 'T7 Single', 'Dsl', 186771.145796746),
	('2017', '1.0', 2050, 'T7 Single Construction', 'Dsl', 166754.752275754),
	('2017', '1.0', 2050, 'T7 Tractor', 'Dsl', 718885.458886924),
	('2017', '1.0', 2050, 'T7 Tractor Construction', 'Dsl', 137557.989402674),
	('2017', '1.0', 2050, 'T7 SWCV', 'Dsl', 802.423852352264),
	('2017', '1.0', 2050, 'LDT1', 'Elec', 277356.93303118),
	('2017', '1.0', 2050, 'LDT2', 'Elec', 622618.636386332),
	('2017', '1.0', 2050, 'MDV', 'Elec', 457171.43318052),
	('2017', '1.0', 2050, 'T7 SWCV', 'NG', 87669.1464620094),
	('2017', '1.0', 2050, 'UBUS', 'Gas', 69399.3797082244),
	('2017', '1.0', 2050, 'SBUS', 'Gas', 48034.4063133765),
	('2017', '1.0', 2050, 'OBUS', 'Gas', 59385.7631943616),
	('2017', '1.0', 2050, 'UBUS', 'Dsl', 0),
	('2017', '1.0', 2050, 'SBUS', 'Dsl', 61752.3711758229),
	('2017', '1.0', 2050, 'Motor Coach', 'Dsl', 34523.9488557975),
	('2017', '1.0', 2050, 'All Other Buses', 'Dsl', 31954.7739743902),
	('2017', '1.0', 2050, 'UBUS', 'NG', 199187.390149015),
	('2017', '1.0', 2050, 'MCY', 'Gas', 630197.997825984),
	('2017', '1.0', 2050, 'MH', 'Gas', 69273.2749387299),
	('2017', '1.0', 2050, 'MH', 'Dsl', 31082.999310364)
INSERT INTO #tt_emfac_default_vmt VALUES
    ('2021', '1.0', 2016, 'All Other Buses', 'Dsl', 27438.5),
    ('2021', '1.0', 2016, 'All Other Buses', 'NG', 1112.56),
    ('2021', '1.0', 2016, 'LDA', 'Gas', 4.91364e+007),
    ('2021', '1.0', 2016, 'LDA', 'Dsl', 514134),
    ('2021', '1.0', 2016, 'LDA', 'Elec', 392176),
    ('2021', '1.0', 2016, 'LDA', 'Phe', 426354),
    ('2021', '1.0', 2016, 'LDT1', 'Gas', 5.5202e+006),
    ('2021', '1.0', 2016, 'LDT1', 'Dsl', 3702.37),
    ('2021', '1.0', 2016, 'LDT1', 'Elec', 5743.21),
    ('2021', '1.0', 2016, 'LDT2', 'Gas', 1.81693e+007),
    ('2021', '1.0', 2016, 'LDT2', 'Dsl', 75273.7),
    ('2021', '1.0', 2016, 'LDT2', 'Elec', 1225.11),
    ('2021', '1.0', 2016, 'LDT2', 'Phe', 3028.9),
    ('2021', '1.0', 2016, 'LHD1', 'Gas', 1.4152e+006),
    ('2021', '1.0', 2016, 'LHD1', 'Dsl', 1.11299e+006),
    ('2021', '1.0', 2016, 'LHD2', 'Gas', 178189),
    ('2021', '1.0', 2016, 'LHD2', 'Dsl', 368461),
    ('2021', '1.0', 2016, 'MCY', 'Gas', 524788),
    ('2021', '1.0', 2016, 'MDV', 'Gas', 1.10431e+007),
    ('2021', '1.0', 2016, 'MDV', 'Dsl', 222672),
    ('2021', '1.0', 2016, 'MDV', 'Elec', 402.582),
    ('2021', '1.0', 2016, 'MDV', 'Phe', 10128.6),
    ('2021', '1.0', 2016, 'MH', 'Gas', 123378),
    ('2021', '1.0', 2016, 'MH', 'Dsl', 37550.5),
    ('2021', '1.0', 2016, 'Motor Coach', 'Dsl', 21771.5),
    ('2021', '1.0', 2016, 'OBUS', 'Gas', 78975.6),
    ('2021', '1.0', 2016, 'PTO', 'Dsl', 33128.6),
    ('2021', '1.0', 2016, 'SBUS', 'Gas', 17904.9),
    ('2021', '1.0', 2016, 'SBUS', 'Dsl', 44284.8),
    ('2021', '1.0', 2016, 'SBUS', 'NG', 141.26),
    ('2021', '1.0', 2016, 'T6 CAIRP Class 4', 'Dsl', 518.591),
    ('2021', '1.0', 2016, 'T6 CAIRP Class 5', 'Dsl', 711.414),
    ('2021', '1.0', 2016, 'T6 CAIRP Class 6', 'Dsl', 1858.95),
    ('2021', '1.0', 2016, 'T6 CAIRP Class 7', 'Dsl', 11660.2),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 4', 'Dsl', 28853.2),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 4', 'NG', 27.3519),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 5', 'Dsl', 21892.5),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 5', 'NG', 20.7537),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 6', 'Dsl', 65296.9),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 6', 'NG', 61.897),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 7', 'Dsl', 25523.8),
    ('2021', '1.0', 2016, 'T6 Instate Delivery Class 7', 'NG', 1.17645),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 4', 'Dsl', 75202.6),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 4', 'NG', 69.5834),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 5', 'Dsl', 142070),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 5', 'NG', 131.538),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 6', 'Dsl', 139983),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 6', 'NG', 129.333),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 7', 'Dsl', 68389),
    ('2021', '1.0', 2016, 'T6 Instate Other Class 7', 'NG', 5.34854),
    ('2021', '1.0', 2016, 'T6 Instate Tractor Class 6', 'Dsl', 834.831),
    ('2021', '1.0', 2016, 'T6 Instate Tractor Class 6', 'NG', 0.906339),
    ('2021', '1.0', 2016, 'T6 Instate Tractor Class 7', 'Dsl', 25379.5),
    ('2021', '1.0', 2016, 'T6 Instate Tractor Class 7', 'NG', 1.77628),
    ('2021', '1.0', 2016, 'T6 OOS Class 4', 'Dsl', 295.582),
    ('2021', '1.0', 2016, 'T6 OOS Class 5', 'Dsl', 405.486),
    ('2021', '1.0', 2017, 'T7 NNOOS Class 8', 'Dsl', 476590),
    ('2021', '1.0', 2017, 'T7 NOOS Class 8', 'Dsl', 173137),
    ('2021', '1.0', 2017, 'T7 Other Port Class 8', 'Dsl', 83557.1),
    ('2021', '1.0', 2017, 'T7 POLA Class 8', 'Dsl', 25899.8),
    ('2021', '1.0', 2017, 'T7 Public Class 8', 'Dsl', 65824.5),
    ('2021', '1.0', 2017, 'T7 Public Class 8', 'NG', 114.711),
    ('2021', '1.0', 2017, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 26832.1),
    ('2021', '1.0', 2017, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 299.985),
    ('2021', '1.0', 2017, 'T7 Single Dump Class 8', 'Dsl', 51838.7),
    ('2021', '1.0', 2017, 'T7 Single Dump Class 8', 'NG', 2235.86),
    ('2021', '1.0', 2017, 'T7 Single Other Class 8', 'Dsl', 90106.9),
    ('2021', '1.0', 2017, 'T7 Single Other Class 8', 'NG', 4637.05),
    ('2021', '1.0', 2017, 'T7 SWCV Class 8', 'Dsl', 61889),
    ('2021', '1.0', 2017, 'T7 SWCV Class 8', 'NG', 25561.4),
    ('2021', '1.0', 2017, 'T7 Tractor Class 8', 'Dsl', 304591),
    ('2021', '1.0', 2017, 'T7 Tractor Class 8', 'NG', 3126.04),
    ('2021', '1.0', 2017, 'T7 Utility Class 8', 'Dsl', 6587.55),
    ('2021', '1.0', 2017, 'T7IS', 'Gas', 1805.07),
    ('2021', '1.0', 2017, 'UBUS', 'Gas', 23242.6),
    ('2021', '1.0', 2017, 'UBUS', 'Dsl', 4777.69),
    ('2021', '1.0', 2017, 'UBUS', 'NG', 86875.1),
    ('2021', '1.0', 2018, 'All Other Buses', 'Dsl', 25721.1),
    ('2021', '1.0', 2018, 'All Other Buses', 'NG', 3699.78),
    ('2021', '1.0', 2018, 'LDA', 'Gas', 4.7106e+007),
    ('2021', '1.0', 2018, 'LDA', 'Dsl', 236237),
    ('2021', '1.0', 2018, 'LDA', 'Elec', 700562),
    ('2021', '1.0', 2018, 'LDA', 'Phe', 723622),
    ('2021', '1.0', 2018, 'LDT1', 'Gas', 5.16348e+006),
    ('2021', '1.0', 2018, 'LDT1', 'Dsl', 3145.84),
    ('2021', '1.0', 2018, 'LDT1', 'Elec', 4922.5),
    ('2021', '1.0', 2018, 'LDT1', 'Phe', 94.9787),
    ('2021', '1.0', 2018, 'LDT2', 'Gas', 2.00153e+007),
    ('2021', '1.0', 2018, 'LDT2', 'Dsl', 88300.6),
    ('2021', '1.0', 2018, 'LDT2', 'Elec', 971.917),
    ('2021', '1.0', 2018, 'LDT2', 'Phe', 9511.71),
    ('2021', '1.0', 2018, 'LHD1', 'Gas', 1.60818e+006),
    ('2021', '1.0', 2018, 'LHD1', 'Dsl', 1.11499e+006),
    ('2021', '1.0', 2018, 'LHD2', 'Gas', 208119),
    ('2021', '1.0', 2018, 'LHD2', 'Dsl', 374464),
    ('2021', '1.0', 2018, 'MCY', 'Gas', 471421),
    ('2021', '1.0', 2018, 'MDV', 'Gas', 1.28459e+007),
    ('2021', '1.0', 2018, 'MDV', 'Dsl', 216954),
    ('2021', '1.0', 2018, 'MDV', 'Elec', 490.283),
    ('2021', '1.0', 2018, 'MDV', 'Phe', 43998),
    ('2021', '1.0', 2018, 'MH', 'Gas', 122196),
    ('2021', '1.0', 2018, 'MH', 'Dsl', 42581.6),
    ('2021', '1.0', 2018, 'Motor Coach', 'Dsl', 22434.8),
    ('2021', '1.0', 2018, 'OBUS', 'Gas', 70609.1),
    ('2021', '1.0', 2018, 'PTO', 'Dsl', 34137.9),
    ('2021', '1.0', 2018, 'SBUS', 'Gas', 19397.1),
    ('2021', '1.0', 2018, 'SBUS', 'Dsl', 45432.1),
    ('2021', '1.0', 2018, 'SBUS', 'NG', 347.455),
    ('2021', '1.0', 2018, 'T6 CAIRP Class 4', 'Dsl', 534.391),
    ('2021', '1.0', 2018, 'T6 CAIRP Class 5', 'Dsl', 733.088),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 7', 'Dsl', 70168.3),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 7', 'NG', 557.507),
    ('2021', '1.0', 2019, 'T6 Instate Tractor Class 6', 'Dsl', 849.326),
    ('2021', '1.0', 2019, 'T6 Instate Tractor Class 6', 'NG', 14.8989),
    ('2021', '1.0', 2019, 'T6 Instate Tractor Class 7', 'Dsl', 26178.7),
    ('2021', '1.0', 2019, 'T6 Instate Tractor Class 7', 'NG', 67.6826),
    ('2021', '1.0', 2019, 'T6 OOS Class 4', 'Dsl', 305.658),
    ('2021', '1.0', 2019, 'T6 OOS Class 5', 'Dsl', 419.308),
    ('2021', '1.0', 2019, 'T6 OOS Class 6', 'Dsl', 1095.66),
    ('2021', '1.0', 2019, 'T6 OOS Class 7', 'Dsl', 7966.83),
    ('2021', '1.0', 2019, 'T6 Public Class 4', 'Dsl', 9836.81),
    ('2021', '1.0', 2019, 'T6 Public Class 4', 'NG', 20.3664),
    ('2021', '1.0', 2019, 'T6 Public Class 5', 'Dsl', 21735.2),
    ('2021', '1.0', 2019, 'T6 Public Class 5', 'NG', 257.57),
    ('2021', '1.0', 2019, 'T6 Public Class 6', 'Dsl', 14730.1),
    ('2021', '1.0', 2019, 'T6 Public Class 6', 'NG', 45.6024),
    ('2021', '1.0', 2019, 'T6 Public Class 7', 'Dsl', 32748.2),
    ('2021', '1.0', 2019, 'T6 Public Class 7', 'NG', 143.097),
    ('2021', '1.0', 2019, 'T6 Utility Class 5', 'Dsl', 8180.55),
    ('2021', '1.0', 2019, 'T6 Utility Class 6', 'Dsl', 1964.19),
    ('2021', '1.0', 2019, 'T6 Utility Class 7', 'Dsl', 2383.32),
    ('2021', '1.0', 2019, 'T6TS', 'Gas', 189399),
    ('2021', '1.0', 2019, 'T7 CAIRP Class 8', 'Dsl', 394964),
    ('2021', '1.0', 2019, 'T7 CAIRP Class 8', 'NG', 299.905),
    ('2021', '1.0', 2019, 'T7 NNOOS Class 8', 'Dsl', 467324),
    ('2021', '1.0', 2019, 'T7 NOOS Class 8', 'Dsl', 169770),
    ('2021', '1.0', 2019, 'T7 Other Port Class 8', 'Dsl', 81932.5),
    ('2021', '1.0', 2019, 'T7 POLA Class 8', 'Dsl', 25396.3),
    ('2021', '1.0', 2019, 'T7 Public Class 8', 'Dsl', 64387.4),
    ('2021', '1.0', 2019, 'T7 Public Class 8', 'NG', 269.691),
    ('2021', '1.0', 2019, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24958.4),
    ('2021', '1.0', 2019, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1646.22),
    ('2021', '1.0', 2019, 'T7 Single Dump Class 8', 'Dsl', 49765.2),
    ('2021', '1.0', 2019, 'T7 Single Dump Class 8', 'NG', 3258.02),
    ('2021', '1.0', 2019, 'T7 Single Other Class 8', 'Dsl', 87039),
    ('2021', '1.0', 2019, 'T7 Single Other Class 8', 'NG', 5862.84),
    ('2021', '1.0', 2019, 'T7 SWCV Class 8', 'Dsl', 53754.4),
    ('2021', '1.0', 2019, 'T7 SWCV Class 8', 'NG', 31995.8),
    ('2021', '1.0', 2019, 'T7 Tractor Class 8', 'Dsl', 297691),
    ('2021', '1.0', 2019, 'T7 Tractor Class 8', 'NG', 4043.45),
    ('2021', '1.0', 2019, 'T7 Utility Class 8', 'Dsl', 6459.47),
    ('2021', '1.0', 2019, 'T7IS', 'Gas', 851.047),
    ('2021', '1.0', 2019, 'UBUS', 'Gas', 11134.7),
    ('2021', '1.0', 2019, 'UBUS', 'Dsl', 3331.18),
    ('2021', '1.0', 2019, 'UBUS', 'NG', 89470.1),
    ('2021', '1.0', 2020, 'All Other Buses', 'Dsl', 24593.8),
    ('2021', '1.0', 2020, 'All Other Buses', 'NG', 5044.59),
    ('2021', '1.0', 2020, 'LDA', 'Gas', 4.01255e+007),
    ('2021', '1.0', 2020, 'LDA', 'Dsl', 204548),
    ('2021', '1.0', 2020, 'LDA', 'Elec', 1.11837e+006),
    ('2021', '1.0', 2020, 'LDA', 'Phe', 819575),
    ('2021', '1.0', 2020, 'LDT1', 'Gas', 4.21752e+006),
    ('2021', '1.0', 2020, 'LDT1', 'Dsl', 1193.27),
    ('2021', '1.0', 2020, 'LDT1', 'Elec', 4452.87),
    ('2021', '1.0', 2020, 'LDT1', 'Phe', 293.758),
    ('2021', '1.0', 2021, 'OBUS', 'Gas', 63994.5),
    ('2021', '1.0', 2021, 'PTO', 'Dsl', 34639.4),
    ('2021', '1.0', 2021, 'SBUS', 'Gas', 13935),
    ('2021', '1.0', 2021, 'SBUS', 'Dsl', 45575),
    ('2021', '1.0', 2021, 'SBUS', 'NG', 365.448),
    ('2021', '1.0', 2021, 'T6 CAIRP Class 4', 'Dsl', 543.014),
    ('2021', '1.0', 2021, 'T6 CAIRP Class 5', 'Dsl', 744.918),
    ('2021', '1.0', 2021, 'T6 CAIRP Class 6', 'Dsl', 1946.49),
    ('2021', '1.0', 2021, 'T6 CAIRP Class 7', 'Dsl', 12209.4),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 4', 'Dsl', 29813.8),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 4', 'NG', 426.796),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 5', 'Dsl', 22442.9),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 5', 'NG', 502.294),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 6', 'Dsl', 67285.9),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 6', 'NG', 1150.88),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 7', 'Dsl', 26477.1),
    ('2021', '1.0', 2021, 'T6 Instate Delivery Class 7', 'NG', 249.982),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 4', 'Dsl', 77891.1),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 4', 'NG', 925.992),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 5', 'Dsl', 145445),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 5', 'NG', 3452.93),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 6', 'Dsl', 143119),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 6', 'NG', 3591.55),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 7', 'Dsl', 71037.1),
    ('2021', '1.0', 2021, 'T6 Instate Other Class 7', 'NG', 578.27),
    ('2021', '1.0', 2021, 'T6 Instate Tractor Class 6', 'Dsl', 858.391),
    ('2021', '1.0', 2021, 'T6 Instate Tractor Class 6', 'NG', 16.7044),
    ('2021', '1.0', 2021, 'T6 Instate Tractor Class 7', 'Dsl', 26463.8),
    ('2021', '1.0', 2021, 'T6 Instate Tractor Class 7', 'NG', 112.736),
    ('2021', '1.0', 2021, 'T6 OOS Class 4', 'Dsl', 309.503),
    ('2021', '1.0', 2021, 'T6 OOS Class 5', 'Dsl', 424.582),
    ('2021', '1.0', 2021, 'T6 OOS Class 6', 'Dsl', 1109.44),
    ('2021', '1.0', 2021, 'T6 OOS Class 7', 'Dsl', 8067.04),
    ('2021', '1.0', 2021, 'T6 Public Class 4', 'Dsl', 9895.66),
    ('2021', '1.0', 2021, 'T6 Public Class 4', 'NG', 39.9045),
    ('2021', '1.0', 2021, 'T6 Public Class 5', 'Dsl', 21893.6),
    ('2021', '1.0', 2021, 'T6 Public Class 5', 'NG', 274.073),
    ('2021', '1.0', 2021, 'T6 Public Class 6', 'Dsl', 14821.7),
    ('2021', '1.0', 2021, 'T6 Public Class 6', 'NG', 71.5189),
    ('2021', '1.0', 2021, 'T6 Public Class 7', 'Dsl', 32925.5),
    ('2021', '1.0', 2021, 'T6 Public Class 7', 'NG', 227.382),
    ('2021', '1.0', 2021, 'T6 Utility Class 5', 'Dsl', 8245.61),
    ('2021', '1.0', 2021, 'T6 Utility Class 6', 'Dsl', 1979.81),
    ('2021', '1.0', 2021, 'T6 Utility Class 7', 'Dsl', 2402.28),
    ('2021', '1.0', 2021, 'T6TS', 'Gas', 189874),
    ('2021', '1.0', 2021, 'T7 CAIRP Class 8', 'Dsl', 402335),
    ('2021', '1.0', 2021, 'T7 CAIRP Class 8', 'NG', 339.754),
    ('2021', '1.0', 2021, 'T7 NNOOS Class 8', 'Dsl', 476086),
    ('2021', '1.0', 2021, 'T7 NOOS Class 8', 'Dsl', 172954),
    ('2021', '1.0', 2021, 'T7 Other Port Class 8', 'Dsl', 89231.7),
    ('2021', '1.0', 2021, 'T7 POLA Class 8', 'Dsl', 27793.9),
    ('2021', '1.0', 2021, 'T7 Public Class 8', 'Dsl', 64832),
    ('2021', '1.0', 2021, 'T7 Public Class 8', 'NG', 339.293),
    ('2021', '1.0', 2021, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24685.4),
    ('2021', '1.0', 2023, 'All Other Buses', 'NG', 5808.9),
    ('2021', '1.0', 2023, 'LDA', 'Gas', 4.68619e+007),
    ('2021', '1.0', 2023, 'LDA', 'Dsl', 189349),
    ('2021', '1.0', 2023, 'LDA', 'Elec', 2.58825e+006),
    ('2021', '1.0', 2023, 'LDA', 'Phe', 1.4082e+006),
    ('2021', '1.0', 2023, 'LDT1', 'Gas', 4.54653e+006),
    ('2021', '1.0', 2023, 'LDT1', 'Dsl', 995.632),
    ('2021', '1.0', 2023, 'LDT1', 'Elec', 8437.07),
    ('2021', '1.0', 2023, 'LDT1', 'Phe', 4488.74),
    ('2021', '1.0', 2023, 'LDT2', 'Gas', 2.21782e+007),
    ('2021', '1.0', 2023, 'LDT2', 'Dsl', 85740.5),
    ('2021', '1.0', 2023, 'LDT2', 'Elec', 78826.8),
    ('2021', '1.0', 2023, 'LDT2', 'Phe', 161761),
    ('2021', '1.0', 2023, 'LHD1', 'Gas', 1.65992e+006),
    ('2021', '1.0', 2023, 'LHD1', 'Dsl', 1.17748e+006),
    ('2021', '1.0', 2023, 'LHD2', 'Gas', 229749),
    ('2021', '1.0', 2023, 'LHD2', 'Dsl', 468439),
    ('2021', '1.0', 2023, 'MCY', 'Gas', 433816),
    ('2021', '1.0', 2023, 'MDV', 'Gas', 1.30722e+007),
    ('2021', '1.0', 2023, 'MDV', 'Dsl', 241474),
    ('2021', '1.0', 2023, 'MDV', 'Elec', 84685.4),
    ('2021', '1.0', 2023, 'MDV', 'Phe', 97545.5),
    ('2021', '1.0', 2023, 'MH', 'Gas', 98581.3),
    ('2021', '1.0', 2023, 'MH', 'Dsl', 40051.4),
    ('2021', '1.0', 2023, 'Motor Coach', 'Dsl', 22889.4),
    ('2021', '1.0', 2023, 'OBUS', 'Gas', 59392.5),
    ('2021', '1.0', 2023, 'PTO', 'Dsl', 35414.4),
    ('2021', '1.0', 2023, 'PTO', 'Elec', 9.76186),
    ('2021', '1.0', 2023, 'SBUS', 'Gas', 15325.7),
    ('2021', '1.0', 2023, 'SBUS', 'Dsl', 45498.9),
    ('2021', '1.0', 2023, 'SBUS', 'Elec', 13.1418),
    ('2021', '1.0', 2023, 'SBUS', 'NG', 428.354),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 4', 'Dsl', 555.733),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 4', 'Elec', 0.399354),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 5', 'Dsl', 762.45),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 5', 'Elec', 0.464085),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 6', 'Dsl', 1991.03),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 6', 'Elec', 2.48164),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 7', 'Dsl', 12497.4),
    ('2021', '1.0', 2023, 'T6 CAIRP Class 7', 'Elec', 6.89451),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 4', 'Dsl', 30431.5),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 4', 'Elec', 10.3119),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 4', 'NG', 529.425),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 5', 'Dsl', 22926.3),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 5', 'Elec', 5.53676),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 5', 'NG', 567.672),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 6', 'Dsl', 68598.5),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 6', 'Elec', 24.8595),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 6', 'NG', 1466.82),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 7', 'Dsl', 27090.9),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 7', 'Elec', 3.27321),
    ('2021', '1.0', 2023, 'T6 Instate Delivery Class 7', 'NG', 278.574),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 4', 'Dsl', 79291),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 4', 'Elec', 5.03771),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 4', 'NG', 1425.23),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 5', 'Dsl', 148440),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 5', 'Elec', 34.8742),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 5', 'NG', 4020.43),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 6', 'Dsl', 145985),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 6', 'Elec', 42.9386),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 6', 'NG', 4226.79),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 7', 'Dsl', 72701.7),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 7', 'Elec', 1140.14),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 7', 'NG', 573.426),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 6', 'Dsl', 885.106),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 6', 'Elec', 22.4898),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 6', 'NG', 21.3149),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 7', 'Dsl', 27869.9),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 7', 'Elec', 180.613),
    ('2021', '1.0', 2026, 'T6 Instate Tractor Class 7', 'NG', 160.393),
    ('2021', '1.0', 2026, 'T6 OOS Class 4', 'Dsl', 328.536),
    ('2021', '1.0', 2026, 'T6 OOS Class 5', 'Dsl', 450.692),
    ('2021', '1.0', 2026, 'T6 OOS Class 6', 'Dsl', 1177.67),
    ('2021', '1.0', 2026, 'T6 OOS Class 7', 'Dsl', 8563.13),
    ('2021', '1.0', 2026, 'T6 Public Class 4', 'Dsl', 9905.76),
    ('2021', '1.0', 2026, 'T6 Public Class 4', 'Elec', 196.252),
    ('2021', '1.0', 2026, 'T6 Public Class 4', 'NG', 78.3721),
    ('2021', '1.0', 2026, 'T6 Public Class 5', 'Dsl', 22071.5),
    ('2021', '1.0', 2026, 'T6 Public Class 5', 'Elec', 331.209),
    ('2021', '1.0', 2026, 'T6 Public Class 5', 'NG', 311.177),
    ('2021', '1.0', 2026, 'T6 Public Class 6', 'Dsl', 14862.3),
    ('2021', '1.0', 2026, 'T6 Public Class 6', 'Elec', 274.512),
    ('2021', '1.0', 2026, 'T6 Public Class 6', 'NG', 123.416),
    ('2021', '1.0', 2026, 'T6 Public Class 7', 'Dsl', 32932.6),
    ('2021', '1.0', 2026, 'T6 Public Class 7', 'Elec', 710.149),
    ('2021', '1.0', 2026, 'T6 Public Class 7', 'NG', 326.992),
    ('2021', '1.0', 2026, 'T6 Utility Class 5', 'Dsl', 8196.58),
    ('2021', '1.0', 2026, 'T6 Utility Class 5', 'Elec', 252.21),
    ('2021', '1.0', 2026, 'T6 Utility Class 6', 'Dsl', 1966.99),
    ('2021', '1.0', 2026, 'T6 Utility Class 6', 'Elec', 61.6063),
    ('2021', '1.0', 2026, 'T6 Utility Class 7', 'Dsl', 2375.93),
    ('2021', '1.0', 2026, 'T6 Utility Class 7', 'Elec', 85.5338),
    ('2021', '1.0', 2026, 'T6TS', 'Gas', 196489),
    ('2021', '1.0', 2026, 'T6TS', 'Elec', 4604.08),
    ('2021', '1.0', 2026, 'T7 CAIRP Class 8', 'Dsl', 426609),
    ('2021', '1.0', 2026, 'T7 CAIRP Class 8', 'Elec', 8754.1),
    ('2021', '1.0', 2026, 'T7 CAIRP Class 8', 'NG', 466.547),
    ('2021', '1.0', 2026, 'T7 NNOOS Class 8', 'Dsl', 515284),
    ('2021', '1.0', 2026, 'T7 NOOS Class 8', 'Dsl', 187194),
    ('2021', '1.0', 2026, 'T7 Other Port Class 8', 'Dsl', 107051),
    ('2021', '1.0', 2026, 'T7 Other Port Class 8', 'Elec', 1106.97),
    ('2021', '1.0', 2026, 'T7 POLA Class 8', 'Dsl', 33991.7),
    ('2021', '1.0', 2026, 'T7 POLA Class 8', 'Elec', 105.059),
    ('2021', '1.0', 2026, 'T7 Public Class 8', 'Dsl', 65207.4),
    ('2021', '1.0', 2026, 'T7 Public Class 8', 'Elec', 1146.8),
    ('2021', '1.0', 2026, 'T7 Public Class 8', 'NG', 422.985),
    ('2021', '1.0', 2026, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24457.2),
    ('2021', '1.0', 2026, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 924.342),
    ('2021', '1.0', 2026, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 2087.37),
    ('2021', '1.0', 2026, 'T7 Single Dump Class 8', 'Dsl', 49757.6),
    ('2021', '1.0', 2026, 'T7 Single Dump Class 8', 'Elec', 949.296),
    ('2021', '1.0', 2026, 'T7 Single Dump Class 8', 'NG', 4038.96),
    ('2021', '1.0', 2026, 'T7 Single Other Class 8', 'Dsl', 93053.4),
    ('2021', '1.0', 2026, 'T7 Single Other Class 8', 'Elec', 1913.03),
    ('2021', '1.0', 2026, 'T7 Single Other Class 8', 'NG', 7469.92),
    ('2021', '1.0', 2026, 'T7 SWCV Class 8', 'Dsl', 30800.1),
    ('2021', '1.0', 2026, 'T7 SWCV Class 8', 'Elec', 1028.22),
    ('2021', '1.0', 2026, 'T7 SWCV Class 8', 'NG', 56733.5),
    ('2021', '1.0', 2026, 'T7 Tractor Class 8', 'Dsl', 324527),
    ('2021', '1.0', 2026, 'T7 Tractor Class 8', 'Elec', 3341.4),
    ('2021', '1.0', 2026, 'T7 Tractor Class 8', 'NG', 4832.53),
    ('2021', '1.0', 2026, 'T7 Utility Class 8', 'Dsl', 6575.86),
    ('2021', '1.0', 2026, 'T7 Utility Class 8', 'Elec', 95.4111),
    ('2021', '1.0', 2026, 'T7IS', 'Gas', 471.798),
    ('2021', '1.0', 2026, 'T7IS', 'Elec', 12.7702),
    ('2021', '1.0', 2026, 'UBUS', 'Gas', 14501.9),
    ('2021', '1.0', 2026, 'UBUS', 'Elec', 5573.63),
    ('2021', '1.0', 2026, 'UBUS', 'NG', 115309),
    ('2021', '1.0', 2029, 'T7 Tractor Class 8', 'Elec', 11404.8),
    ('2021', '1.0', 2029, 'T7 Tractor Class 8', 'NG', 4809.71),
    ('2021', '1.0', 2029, 'T7 Utility Class 8', 'Dsl', 6379.2),
    ('2021', '1.0', 2029, 'T7 Utility Class 8', 'Elec', 386.023),
    ('2021', '1.0', 2029, 'T7IS', 'Gas', 484.064),
    ('2021', '1.0', 2029, 'T7IS', 'Elec', 47.198),
    ('2021', '1.0', 2029, 'UBUS', 'Gas', 15882),
    ('2021', '1.0', 2029, 'UBUS', 'Elec', 27331),
    ('2021', '1.0', 2029, 'UBUS', 'NG', 105312),
    ('2021', '1.0', 2030, 'All Other Buses', 'Dsl', 25729.9),
    ('2021', '1.0', 2030, 'All Other Buses', 'NG', 5327.42),
    ('2021', '1.0', 2030, 'LDA', 'Gas', 4.61787e+007),
    ('2021', '1.0', 2030, 'LDA', 'Dsl', 82539.8),
    ('2021', '1.0', 2030, 'LDA', 'Elec', 5.13321e+006),
    ('2021', '1.0', 2030, 'LDA', 'Phe', 2.03555e+006),
    ('2021', '1.0', 2030, 'LDT1', 'Gas', 3.74812e+006),
    ('2021', '1.0', 2030, 'LDT1', 'Dsl', 60.7717),
    ('2021', '1.0', 2030, 'LDT1', 'Elec', 39240.6),
    ('2021', '1.0', 2030, 'LDT1', 'Phe', 29530.2),
    ('2021', '1.0', 2030, 'LDT2', 'Gas', 2.31243e+007),
    ('2021', '1.0', 2030, 'LDT2', 'Dsl', 89997.9),
    ('2021', '1.0', 2030, 'LDT2', 'Elec', 348640),
    ('2021', '1.0', 2030, 'LDT2', 'Phe', 400375),
    ('2021', '1.0', 2030, 'LHD1', 'Gas', 1.59726e+006),
    ('2021', '1.0', 2030, 'LHD1', 'Dsl', 1.17318e+006),
    ('2021', '1.0', 2030, 'LHD1', 'Elec', 263906),
    ('2021', '1.0', 2030, 'LHD2', 'Gas', 219451),
    ('2021', '1.0', 2030, 'LHD2', 'Dsl', 510869),
    ('2021', '1.0', 2030, 'LHD2', 'Elec', 65783),
    ('2021', '1.0', 2030, 'MCY', 'Gas', 408889),
    ('2021', '1.0', 2030, 'MDV', 'Gas', 1.33269e+007),
    ('2021', '1.0', 2030, 'MDV', 'Dsl', 193552),
    ('2021', '1.0', 2030, 'MDV', 'Elec', 345605),
    ('2021', '1.0', 2030, 'MDV', 'Phe', 255449),
    ('2021', '1.0', 2030, 'MH', 'Gas', 69772.3),
    ('2021', '1.0', 2030, 'MH', 'Dsl', 35959.7),
    ('2021', '1.0', 2030, 'Motor Coach', 'Dsl', 23738.8),
    ('2021', '1.0', 2030, 'OBUS', 'Gas', 41815.1),
    ('2021', '1.0', 2030, 'OBUS', 'Elec', 4503.74),
    ('2021', '1.0', 2030, 'PTO', 'Dsl', 34429),
    ('2021', '1.0', 2030, 'PTO', 'Elec', 3852.78),
    ('2021', '1.0', 2030, 'SBUS', 'Gas', 17314.2),
    ('2021', '1.0', 2030, 'SBUS', 'Dsl', 41877.1),
    ('2021', '1.0', 2030, 'SBUS', 'Elec', 4824.2),
    ('2021', '1.0', 2030, 'SBUS', 'NG', 614.817),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 4', 'Dsl', 525.106),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 4', 'Elec', 79.4884),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 5', 'Dsl', 725.756),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 5', 'Elec', 103.639),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 6', 'Dsl', 1848.78),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 6', 'Elec', 318.452),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 7', 'Dsl', 12535.4),
    ('2021', '1.0', 2030, 'T6 CAIRP Class 7', 'Elec', 1058.55),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 4', 'Dsl', 29940.7),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 4', 'Elec', 3163.12),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 4', 'NG', 566.257),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 5', 'Dsl', 22717.6),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 5', 'Elec', 2296.35),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 5', 'NG', 533.39),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 6', 'Dsl', 67792.7),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 6', 'Elec', 6956.95),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 6', 'NG', 1448.17),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 5', 'NG', 500.734),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 6', 'Dsl', 65259.2),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 6', 'Elec', 12415),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 6', 'NG', 1374.39),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 7', 'Dsl', 28691.7),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 7', 'Elec', 1902.24),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 7', 'NG', 277.45),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 4', 'Dsl', 73396.6),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 4', 'Elec', 16175.1),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 4', 'NG', 1466.77),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 5', 'Dsl', 139139),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 5', 'Elec', 29461),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 5', 'NG', 3386.76),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 6', 'Dsl', 137035),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 6', 'Elec', 28913.7),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 6', 'NG', 3510.15),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 7', 'Dsl', 71405.1),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 7', 'Elec', 10754.4),
    ('2021', '1.0', 2032, 'T6 Instate Other Class 7', 'NG', 560.478),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 6', 'Dsl', 809.889),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 6', 'Elec', 183.821),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 6', 'NG', 17.0784),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 7', 'Dsl', 28676.1),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 7', 'Elec', 1847.57),
    ('2021', '1.0', 2032, 'T6 Instate Tractor Class 7', 'NG', 173.854),
    ('2021', '1.0', 2032, 'T6 OOS Class 4', 'Dsl', 357.494),
    ('2021', '1.0', 2032, 'T6 OOS Class 5', 'Dsl', 490.418),
    ('2021', '1.0', 2032, 'T6 OOS Class 6', 'Dsl', 1281.48),
    ('2021', '1.0', 2032, 'T6 OOS Class 7', 'Dsl', 9317.92),
    ('2021', '1.0', 2032, 'T6 Public Class 4', 'Dsl', 9002.06),
    ('2021', '1.0', 2032, 'T6 Public Class 4', 'Elec', 1357.68),
    ('2021', '1.0', 2032, 'T6 Public Class 4', 'NG', 93.0447),
    ('2021', '1.0', 2032, 'T6 Public Class 5', 'Dsl', 19951.8),
    ('2021', '1.0', 2032, 'T6 Public Class 5', 'Elec', 3081.8),
    ('2021', '1.0', 2032, 'T6 Public Class 5', 'NG', 288.074),
    ('2021', '1.0', 2032, 'T6 Public Class 6', 'Dsl', 13455.4),
    ('2021', '1.0', 2032, 'T6 Public Class 6', 'Elec', 2069.65),
    ('2021', '1.0', 2032, 'T6 Public Class 6', 'NG', 143.505),
    ('2021', '1.0', 2032, 'T6 Public Class 7', 'Dsl', 29446.4),
    ('2021', '1.0', 2032, 'T6 Public Class 7', 'Elec', 5080.97),
    ('2021', '1.0', 2032, 'T6 Public Class 7', 'NG', 351.351),
    ('2021', '1.0', 2032, 'T6 Utility Class 5', 'Dsl', 6672.36),
    ('2021', '1.0', 2032, 'T6 Utility Class 5', 'Elec', 2002.49),
    ('2021', '1.0', 2032, 'T6 Utility Class 6', 'Dsl', 1600.76),
    ('2021', '1.0', 2032, 'T6 Utility Class 6', 'Elec', 482.115),
    ('2021', '1.0', 2032, 'T6 Utility Class 7', 'Dsl', 1886.08),
    ('2021', '1.0', 2032, 'T6 Utility Class 7', 'Elec', 641.251),
    ('2021', '1.0', 2032, 'T6TS', 'Gas', 174733),
    ('2021', '1.0', 2032, 'T6TS', 'Elec', 38640.3),
    ('2021', '1.0', 2032, 'T7 CAIRP Class 8', 'Dsl', 435255),
    ('2021', '1.0', 2032, 'T7 CAIRP Class 8', 'Elec', 62559.8),
    ('2021', '1.0', 2032, 'T7 CAIRP Class 8', 'NG', 389.61),
    ('2021', '1.0', 2032, 'T7 NNOOS Class 8', 'Dsl', 589031),
    ('2021', '1.0', 2032, 'T7 NOOS Class 8', 'Dsl', 213985),
    ('2021', '1.0', 2032, 'T7 Other Port Class 8', 'Dsl', 119718),
    ('2021', '1.0', 2032, 'T7 Other Port Class 8', 'Elec', 14239.2),
    ('2021', '1.0', 2032, 'T7 POLA Class 8', 'Dsl', 41447.6),
    ('2021', '1.0', 2032, 'T7 POLA Class 8', 'Elec', 1478.81),
    ('2021', '1.0', 2032, 'T7 Public Class 8', 'Dsl', 59345.9),
    ('2021', '1.0', 2032, 'T7 Public Class 8', 'Elec', 8769.43),
    ('2021', '1.0', 2032, 'T7 Public Class 8', 'NG', 448.605),
    ('2021', '1.0', 2032, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 19865.7),
    ('2021', '1.0', 2032, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 6772.35),
    ('2021', '1.0', 2032, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1574.73),
    ('2021', '1.0', 2035, 'T7 Public Class 8', 'NG', 439.17),
    ('2021', '1.0', 2035, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 16781.7),
    ('2021', '1.0', 2035, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 10525.3),
    ('2021', '1.0', 2035, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1299.47),
    ('2021', '1.0', 2035, 'T7 Single Dump Class 8', 'Dsl', 41019.1),
    ('2021', '1.0', 2035, 'T7 Single Dump Class 8', 'Elec', 12793.2),
    ('2021', '1.0', 2035, 'T7 Single Dump Class 8', 'NG', 3200.74),
    ('2021', '1.0', 2035, 'T7 Single Other Class 8', 'Dsl', 90766.3),
    ('2021', '1.0', 2035, 'T7 Single Other Class 8', 'Elec', 32350.8),
    ('2021', '1.0', 2035, 'T7 Single Other Class 8', 'NG', 7034.04),
    ('2021', '1.0', 2035, 'T7 SWCV Class 8', 'Dsl', 12651.9),
    ('2021', '1.0', 2035, 'T7 SWCV Class 8', 'Elec', 15266.2),
    ('2021', '1.0', 2035, 'T7 SWCV Class 8', 'NG', 64032.4),
    ('2021', '1.0', 2035, 'T7 Tractor Class 8', 'Dsl', 375121),
    ('2021', '1.0', 2035, 'T7 Tractor Class 8', 'Elec', 42371.1),
    ('2021', '1.0', 2035, 'T7 Tractor Class 8', 'NG', 5223.48),
    ('2021', '1.0', 2035, 'T7 Utility Class 8', 'Dsl', 5404.21),
    ('2021', '1.0', 2035, 'T7 Utility Class 8', 'Elec', 1522.32),
    ('2021', '1.0', 2035, 'T7IS', 'Gas', 480.103),
    ('2021', '1.0', 2035, 'T7IS', 'Elec', 185.951),
    ('2021', '1.0', 2035, 'UBUS', 'Gas', 18446.8),
    ('2021', '1.0', 2035, 'UBUS', 'Elec', 90624.4),
    ('2021', '1.0', 2035, 'UBUS', 'NG', 65734.8),
    ('2021', '1.0', 2040, 'All Other Buses', 'Dsl', 26960.3),
    ('2021', '1.0', 2040, 'All Other Buses', 'NG', 5201.49),
    ('2021', '1.0', 2040, 'LDA', 'Gas', 4.68679e+007),
    ('2021', '1.0', 2040, 'LDA', 'Dsl', 32233.5),
    ('2021', '1.0', 2040, 'LDA', 'Elec', 6.64525e+006),
    ('2021', '1.0', 2040, 'LDA', 'Phe', 2.23796e+006),
    ('2021', '1.0', 2040, 'LDT1', 'Gas', 3.18621e+006),
    ('2021', '1.0', 2040, 'LDT1', 'Dsl', 32.9516),
    ('2021', '1.0', 2040, 'LDT1', 'Elec', 86382.3),
    ('2021', '1.0', 2040, 'LDT1', 'Phe', 63187.2),
    ('2021', '1.0', 2040, 'LDT2', 'Gas', 2.35681e+007),
    ('2021', '1.0', 2040, 'LDT2', 'Dsl', 89853.6),
    ('2021', '1.0', 2040, 'LDT2', 'Elec', 643497),
    ('2021', '1.0', 2040, 'LDT2', 'Phe', 611620),
    ('2021', '1.0', 2040, 'LHD1', 'Gas', 1.17626e+006),
    ('2021', '1.0', 2040, 'LHD1', 'Dsl', 893628),
    ('2021', '1.0', 2040, 'LHD1', 'Elec', 1.17723e+006),
    ('2021', '1.0', 2040, 'LHD2', 'Gas', 159909),
    ('2021', '1.0', 2040, 'LHD2', 'Dsl', 412217),
    ('2021', '1.0', 2040, 'LHD2', 'Elec', 301922),
    ('2021', '1.0', 2040, 'MCY', 'Gas', 396882),
    ('2021', '1.0', 2040, 'MDV', 'Gas', 1.36484e+007),
    ('2021', '1.0', 2040, 'MDV', 'Dsl', 155837),
    ('2021', '1.0', 2040, 'MDV', 'Elec', 585861),
    ('2021', '1.0', 2040, 'MDV', 'Phe', 386985),
    ('2021', '1.0', 2040, 'MH', 'Gas', 52833.9),
    ('2021', '1.0', 2040, 'MH', 'Dsl', 31198.9),
    ('2021', '1.0', 2040, 'Motor Coach', 'Dsl', 25069.8),
    ('2021', '1.0', 2040, 'OBUS', 'Gas', 23584),
    ('2021', '1.0', 2040, 'OBUS', 'Elec', 18005.9),
    ('2021', '1.0', 2040, 'PTO', 'Dsl', 28832.6),
    ('2021', '1.0', 2040, 'PTO', 'Elec', 19386.6),
    ('2021', '1.0', 2040, 'SBUS', 'Gas', 15363.8),
    ('2021', '1.0', 2040, 'SBUS', 'Dsl', 30700.8),
    ('2021', '1.0', 2040, 'SBUS', 'Elec', 21612.6),
    ('2021', '1.0', 2040, 'SBUS', 'NG', 632.386),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 4', 'Dsl', 353.454),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 4', 'Elec', 373.023),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 5', 'Dsl', 487.326),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 5', 'Elec', 509.269),
    ('2021', '1.0', 2045, 'SBUS', 'NG', 569.449),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 4', 'Dsl', 332.999),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 4', 'Elec', 463.345),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 5', 'Dsl', 457.711),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 5', 'Elec', 634.729),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 6', 'Dsl', 1189.48),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 6', 'Elec', 1665.09),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 7', 'Dsl', 13635.9),
    ('2021', '1.0', 2045, 'T6 CAIRP Class 7', 'Elec', 4269.42),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 4', 'Dsl', 21229.9),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 4', 'Elec', 22734.5),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 4', 'NG', 384.226),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 5', 'Dsl', 16109.9),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 5', 'Elec', 17235.1),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 5', 'NG', 304.748),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 6', 'Dsl', 48045.6),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 6', 'Elec', 51428.4),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 6', 'NG', 890.267),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 7', 'Dsl', 24986.3),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 7', 'Elec', 13975.9),
    ('2021', '1.0', 2045, 'T6 Instate Delivery Class 7', 'NG', 233.805),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 4', 'Dsl', 53664.3),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 4', 'Elec', 60957.4),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 4', 'NG', 965.568),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 5', 'Dsl', 101367),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 5', 'Elec', 115101),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 5', 'NG', 1894.99),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 6', 'Dsl', 99900.4),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 6', 'Elec', 113363),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 6', 'NG', 1890.49),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 7', 'Dsl', 61445.5),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 7', 'Elec', 43090.4),
    ('2021', '1.0', 2045, 'T6 Instate Other Class 7', 'NG', 489.815),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 6', 'Dsl', 583.207),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 6', 'Elec', 689.353),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 6', 'NG', 10.7889),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 7', 'Dsl', 31637.2),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 7', 'Elec', 7103.44),
    ('2021', '1.0', 2045, 'T6 Instate Tractor Class 7', 'NG', 234.522),
    ('2021', '1.0', 2045, 'T6 OOS Class 4', 'Dsl', 453.893),
    ('2021', '1.0', 2045, 'T6 OOS Class 5', 'Dsl', 622.66),
    ('2021', '1.0', 2045, 'T6 OOS Class 6', 'Dsl', 1627.03),
    ('2021', '1.0', 2045, 'T6 OOS Class 7', 'Dsl', 11830.5),
    ('2021', '1.0', 2045, 'T6 Public Class 4', 'Dsl', 5847.09),
    ('2021', '1.0', 2045, 'T6 Public Class 4', 'Elec', 4949.33),
    ('2021', '1.0', 2045, 'T6 Public Class 4', 'NG', 73.2243),
    ('2021', '1.0', 2045, 'T6 Public Class 5', 'Dsl', 13054.3),
    ('2021', '1.0', 2045, 'T6 Public Class 5', 'Elec', 11018),
    ('2021', '1.0', 2045, 'T6 Public Class 5', 'NG', 179.395),
    ('2021', '1.0', 2045, 'T6 Public Class 6', 'Dsl', 8774.59),
    ('2021', '1.0', 2045, 'T6 Public Class 6', 'Elec', 7408.23),
    ('2021', '1.0', 2045, 'T6 Public Class 6', 'NG', 110.552),
    ('2021', '1.0', 2045, 'T6 Public Class 7', 'Dsl', 21394.7),
    ('2021', '1.0', 2045, 'T6 Public Class 7', 'Elec', 14595),
    ('2021', '1.0', 2045, 'T6 Public Class 7', 'NG', 279.926),
    ('2021', '1.0', 2045, 'T6 Utility Class 5', 'Dsl', 3734.18),
    ('2021', '1.0', 2045, 'T6 Utility Class 5', 'Elec', 5286.63),
    ('2021', '1.0', 2045, 'T6 Utility Class 6', 'Dsl', 897.021),
    ('2021', '1.0', 2045, 'T6 Utility Class 6', 'Elec', 1268.92),
    ('2021', '1.0', 2045, 'T6 Utility Class 7', 'Dsl', 1071.37),
    ('2021', '1.0', 2045, 'T6 Utility Class 7', 'Elec', 1556.75),
    ('2021', '1.0', 2045, 'T6TS', 'Gas', 107544),
    ('2021', '1.0', 2045, 'T6TS', 'Elec', 121146),
    ('2021', '1.0', 2045, 'T7 CAIRP Class 8', 'Dsl', 609058),
    ('2021', '1.0', 2045, 'T7 CAIRP Class 8', 'Elec', 178049),
    ('2021', '1.0', 2045, 'T7 CAIRP Class 8', 'NG', 517.525),
    ('2021', '1.0', 2050, 'T7 CAIRP Class 8', 'Dsl', 725522),
    ('2021', '1.0', 2050, 'T7 CAIRP Class 8', 'Elec', 213204),
    ('2021', '1.0', 2050, 'T7 CAIRP Class 8', 'NG', 616.004),
    ('2021', '1.0', 2050, 'T7 NNOOS Class 8', 'Dsl', 1.11059e+006),
    ('2021', '1.0', 2050, 'T7 NOOS Class 8', 'Dsl', 403458),
    ('2021', '1.0', 2050, 'T7 Other Port Class 8', 'Dsl', 124365),
    ('2021', '1.0', 2050, 'T7 Other Port Class 8', 'Elec', 31321.5),
    ('2021', '1.0', 2050, 'T7 POLA Class 8', 'Dsl', 40455.6),
    ('2021', '1.0', 2050, 'T7 POLA Class 8', 'Elec', 7768.68),
    ('2021', '1.0', 2050, 'T7 Public Class 8', 'Dsl', 39064.7),
    ('2021', '1.0', 2050, 'T7 Public Class 8', 'Elec', 32420.8),
    ('2021', '1.0', 2050, 'T7 Public Class 8', 'NG', 352.721),
    ('2021', '1.0', 2050, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 11861.8),
    ('2021', '1.0', 2050, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 17895.7),
    ('2021', '1.0', 2050, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 901.295),
    ('2021', '1.0', 2050, 'T7 Single Dump Class 8', 'Dsl', 27757.9),
    ('2021', '1.0', 2050, 'T7 Single Dump Class 8', 'Elec', 31215.4),
    ('2021', '1.0', 2050, 'T7 Single Dump Class 8', 'NG', 2129.95),
    ('2021', '1.0', 2050, 'T7 Single Other Class 8', 'Dsl', 95262),
    ('2021', '1.0', 2050, 'T7 Single Other Class 8', 'Elec', 118249),
    ('2021', '1.0', 2050, 'T7 Single Other Class 8', 'NG', 7269.63),
    ('2021', '1.0', 2050, 'T7 SWCV Class 8', 'Dsl', 1933.15),
    ('2021', '1.0', 2050, 'T7 SWCV Class 8', 'Elec', 44010.1),
    ('2021', '1.0', 2050, 'T7 SWCV Class 8', 'NG', 49330.7),
    ('2021', '1.0', 2050, 'T7 Tractor Class 8', 'Dsl', 581673),
    ('2021', '1.0', 2050, 'T7 Tractor Class 8', 'Elec', 127565),
    ('2021', '1.0', 2050, 'T7 Tractor Class 8', 'NG', 7832.61),
    ('2021', '1.0', 2050, 'T7 Utility Class 8', 'Dsl', 3759.91),
    ('2021', '1.0', 2050, 'T7 Utility Class 8', 'Elec', 3416.97),
    ('2021', '1.0', 2050, 'T7IS', 'Gas', 341.607),
    ('2021', '1.0', 2050, 'T7IS', 'Elec', 426.708),
    ('2021', '1.0', 2050, 'UBUS', 'Gas', 24773.5),
    ('2021', '1.0', 2050, 'UBUS', 'Elec', 215735),
    ('2021', '1.0', 2016, 'T6 OOS Class 6', 'Dsl', 1059.55),
    ('2021', '1.0', 2016, 'T6 OOS Class 7', 'Dsl', 7704.22),
    ('2021', '1.0', 2016, 'T6 Public Class 4', 'Dsl', 9519.08),
    ('2021', '1.0', 2016, 'T6 Public Class 4', 'NG', 13.168),
    ('2021', '1.0', 2016, 'T6 Public Class 5', 'Dsl', 21189.9),
    ('2021', '1.0', 2016, 'T6 Public Class 5', 'NG', 77.9289),
    ('2021', '1.0', 2016, 'T6 Public Class 6', 'Dsl', 14267.4),
    ('2021', '1.0', 2016, 'T6 Public Class 6', 'NG', 21.2318),
    ('2021', '1.0', 2016, 'T6 Public Class 7', 'Dsl', 31761.7),
    ('2021', '1.0', 2016, 'T6 Public Class 7', 'NG', 45.4307),
    ('2021', '1.0', 2016, 'T6 Utility Class 5', 'Dsl', 7910.89),
    ('2021', '1.0', 2016, 'T6 Utility Class 6', 'Dsl', 1899.44),
    ('2021', '1.0', 2016, 'T6 Utility Class 7', 'Dsl', 2304.76),
    ('2021', '1.0', 2016, 'T6TS', 'Gas', 188449),
    ('2021', '1.0', 2016, 'T7 CAIRP Class 8', 'Dsl', 382234),
    ('2021', '1.0', 2016, 'T7 NNOOS Class 8', 'Dsl', 451919),
    ('2021', '1.0', 2016, 'T7 NOOS Class 8', 'Dsl', 164174),
    ('2021', '1.0', 2016, 'T7 Other Port Class 8', 'Dsl', 79231.7),
    ('2021', '1.0', 2016, 'T7 POLA Class 8', 'Dsl', 24559.1),
    ('2021', '1.0', 2016, 'T7 Public Class 8', 'Dsl', 62422.1),
    ('2021', '1.0', 2016, 'T7 Public Class 8', 'NG', 103.677),
    ('2021', '1.0', 2016, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24928.3),
    ('2021', '1.0', 2016, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 799.254),
    ('2021', '1.0', 2016, 'T7 Single Dump Class 8', 'Dsl', 49682.3),
    ('2021', '1.0', 2016, 'T7 Single Dump Class 8', 'NG', 1593.06),
    ('2021', '1.0', 2016, 'T7 Single Other Class 8', 'Dsl', 87057.9),
    ('2021', '1.0', 2016, 'T7 Single Other Class 8', 'NG', 2781.64),
    ('2021', '1.0', 2016, 'T7 SWCV Class 8', 'Dsl', 61181.8),
    ('2021', '1.0', 2016, 'T7 SWCV Class 8', 'NG', 21741.7),
    ('2021', '1.0', 2016, 'T7 Tractor Class 8', 'Dsl', 288971),
    ('2021', '1.0', 2016, 'T7 Tractor Class 8', 'NG', 2817.6),
    ('2021', '1.0', 2016, 'T7 Utility Class 8', 'Dsl', 6246.54),
    ('2021', '1.0', 2016, 'T7IS', 'Gas', 1949.51),
    ('2021', '1.0', 2016, 'UBUS', 'Gas', 31747.7),
    ('2021', '1.0', 2016, 'UBUS', 'Dsl', 9368.61),
    ('2021', '1.0', 2016, 'UBUS', 'NG', 77064.7),
    ('2021', '1.0', 2017, 'All Other Buses', 'Dsl', 28138.1),
    ('2021', '1.0', 2017, 'All Other Buses', 'NG', 1971.6),
    ('2021', '1.0', 2017, 'LDA', 'Gas', 4.75758e+007),
    ('2021', '1.0', 2017, 'LDA', 'Dsl', 268866),
    ('2021', '1.0', 2017, 'LDA', 'Elec', 482134),
    ('2021', '1.0', 2017, 'LDA', 'Phe', 578118),
    ('2021', '1.0', 2017, 'LDT1', 'Gas', 5.25016e+006),
    ('2021', '1.0', 2017, 'LDT1', 'Dsl', 3427.86),
    ('2021', '1.0', 2017, 'LDT1', 'Elec', 4890.26),
    ('2021', '1.0', 2017, 'LDT1', 'Phe', 91.043),
    ('2021', '1.0', 2017, 'LDT2', 'Gas', 1.93042e+007),
    ('2021', '1.0', 2017, 'LDT2', 'Dsl', 80635.9),
    ('2021', '1.0', 2017, 'LDT2', 'Elec', 1106.2),
    ('2021', '1.0', 2017, 'LDT2', 'Phe', 3505.97),
    ('2021', '1.0', 2017, 'LHD1', 'Gas', 1.57212e+006),
    ('2021', '1.0', 2017, 'LHD1', 'Dsl', 1.12064e+006),
    ('2021', '1.0', 2017, 'LHD2', 'Gas', 209425),
    ('2021', '1.0', 2017, 'LHD2', 'Dsl', 370636),
    ('2021', '1.0', 2018, 'T6 CAIRP Class 6', 'Dsl', 1915.58),
    ('2021', '1.0', 2018, 'T6 CAIRP Class 7', 'Dsl', 12015.5),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 4', 'Dsl', 29552.1),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 4', 'NG', 208.25),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 5', 'Dsl', 22157.4),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 5', 'NG', 423.418),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 6', 'Dsl', 66664.6),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 6', 'NG', 685.396),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 7', 'Dsl', 26227.5),
    ('2021', '1.0', 2018, 'T6 Instate Delivery Class 7', 'NG', 75.114),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 4', 'Dsl', 77173.4),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 4', 'NG', 392.044),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 5', 'Dsl', 144232),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 5', 'NG', 2301.36),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 6', 'Dsl', 141836),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 6', 'NG', 2544.99),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 7', 'Dsl', 70214),
    ('2021', '1.0', 2018, 'T6 Instate Other Class 7', 'NG', 264.045),
    ('2021', '1.0', 2018, 'T6 Instate Tractor Class 6', 'Dsl', 848.412),
    ('2021', '1.0', 2018, 'T6 Instate Tractor Class 6', 'NG', 12.7868),
    ('2021', '1.0', 2018, 'T6 Instate Tractor Class 7', 'Dsl', 26118.5),
    ('2021', '1.0', 2018, 'T6 Instate Tractor Class 7', 'NG', 36.0382),
    ('2021', '1.0', 2018, 'T6 OOS Class 4', 'Dsl', 304.588),
    ('2021', '1.0', 2018, 'T6 OOS Class 5', 'Dsl', 417.839),
    ('2021', '1.0', 2018, 'T6 OOS Class 6', 'Dsl', 1091.83),
    ('2021', '1.0', 2018, 'T6 OOS Class 7', 'Dsl', 7938.93),
    ('2021', '1.0', 2018, 'T6 Public Class 4', 'Dsl', 9807.36),
    ('2021', '1.0', 2018, 'T6 Public Class 4', 'NG', 15.2988),
    ('2021', '1.0', 2018, 'T6 Public Class 5', 'Dsl', 21707.9),
    ('2021', '1.0', 2018, 'T6 Public Class 5', 'NG', 207.84),
    ('2021', '1.0', 2018, 'T6 Public Class 6', 'Dsl', 14679.8),
    ('2021', '1.0', 2018, 'T6 Public Class 6', 'NG', 44.205),
    ('2021', '1.0', 2018, 'T6 Public Class 7', 'Dsl', 32636.7),
    ('2021', '1.0', 2018, 'T6 Public Class 7', 'NG', 139.392),
    ('2021', '1.0', 2018, 'T6 Utility Class 5', 'Dsl', 8151.9),
    ('2021', '1.0', 2018, 'T6 Utility Class 6', 'Dsl', 1957.31),
    ('2021', '1.0', 2018, 'T6 Utility Class 7', 'Dsl', 2374.97),
    ('2021', '1.0', 2018, 'T6TS', 'Gas', 182270),
    ('2021', '1.0', 2018, 'T7 CAIRP Class 8', 'Dsl', 393568),
    ('2021', '1.0', 2018, 'T7 CAIRP Class 8', 'NG', 311.259),
    ('2021', '1.0', 2018, 'T7 NNOOS Class 8', 'Dsl', 465687),
    ('2021', '1.0', 2018, 'T7 NOOS Class 8', 'Dsl', 169176),
    ('2021', '1.0', 2018, 'T7 Other Port Class 8', 'Dsl', 81645.6),
    ('2021', '1.0', 2018, 'T7 POLA Class 8', 'Dsl', 25307.3),
    ('2021', '1.0', 2018, 'T7 Public Class 8', 'Dsl', 64188.8),
    ('2021', '1.0', 2018, 'T7 Public Class 8', 'NG', 241.884),
    ('2021', '1.0', 2018, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 25309.3),
    ('2021', '1.0', 2018, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1202.1),
    ('2021', '1.0', 2018, 'T7 Single Dump Class 8', 'Dsl', 49892.6),
    ('2021', '1.0', 2018, 'T7 Single Dump Class 8', 'NG', 2944.93),
    ('2021', '1.0', 2018, 'T7 Single Other Class 8', 'Dsl', 87231.5),
    ('2021', '1.0', 2018, 'T7 Single Other Class 8', 'NG', 5345.08),
    ('2021', '1.0', 2018, 'T7 SWCV Class 8', 'Dsl', 57267.3),
    ('2021', '1.0', 2018, 'T7 SWCV Class 8', 'NG', 28182.6),
    ('2021', '1.0', 2020, 'LDT2', 'Gas', 1.83834e+007),
    ('2021', '1.0', 2020, 'LDT2', 'Dsl', 66426.7),
    ('2021', '1.0', 2020, 'LDT2', 'Elec', 3517.1),
    ('2021', '1.0', 2020, 'LDT2', 'Phe', 44094.3),
    ('2021', '1.0', 2020, 'LHD1', 'Gas', 1.37998e+006),
    ('2021', '1.0', 2020, 'LHD1', 'Dsl', 946304),
    ('2021', '1.0', 2020, 'LHD2', 'Gas', 190440),
    ('2021', '1.0', 2020, 'LHD2', 'Dsl', 353901),
    ('2021', '1.0', 2020, 'MCY', 'Gas', 388227),
    ('2021', '1.0', 2020, 'MDV', 'Gas', 1.0921e+007),
    ('2021', '1.0', 2020, 'MDV', 'Dsl', 220391),
    ('2021', '1.0', 2020, 'MDV', 'Elec', 5142.92),
    ('2021', '1.0', 2020, 'MDV', 'Phe', 47503),
    ('2021', '1.0', 2020, 'MH', 'Gas', 99681),
    ('2021', '1.0', 2020, 'MH', 'Dsl', 35403.9),
    ('2021', '1.0', 2020, 'Motor Coach', 'Dsl', 22614.4),
    ('2021', '1.0', 2020, 'OBUS', 'Gas', 57947.5),
    ('2021', '1.0', 2020, 'PTO', 'Dsl', 34463.5),
    ('2021', '1.0', 2020, 'SBUS', 'Gas', 11579.8),
    ('2021', '1.0', 2020, 'SBUS', 'Dsl', 45604.3),
    ('2021', '1.0', 2020, 'SBUS', 'NG', 336.154),
    ('2021', '1.0', 2020, 'T6 CAIRP Class 4', 'Dsl', 536.571),
    ('2021', '1.0', 2020, 'T6 CAIRP Class 5', 'Dsl', 736.079),
    ('2021', '1.0', 2020, 'T6 CAIRP Class 6', 'Dsl', 1923.4),
    ('2021', '1.0', 2020, 'T6 CAIRP Class 7', 'Dsl', 12064.5),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 4', 'Dsl', 29578.5),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 4', 'NG', 303.27),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 5', 'Dsl', 22209.3),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 5', 'NG', 463.717),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 6', 'Dsl', 66681),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 6', 'NG', 943.791),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 7', 'Dsl', 26162.8),
    ('2021', '1.0', 2020, 'T6 Instate Delivery Class 7', 'NG', 247.136),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 4', 'Dsl', 77247.8),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 4', 'NG', 634.115),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 5', 'Dsl', 144018),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 5', 'NG', 3113.7),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 6', 'Dsl', 141830),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 6', 'NG', 3139.83),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 7', 'Dsl', 70163.5),
    ('2021', '1.0', 2020, 'T6 Instate Other Class 7', 'NG', 602.157),
    ('2021', '1.0', 2020, 'T6 Instate Tractor Class 6', 'Dsl', 850.001),
    ('2021', '1.0', 2020, 'T6 Instate Tractor Class 6', 'NG', 14.7114),
    ('2021', '1.0', 2020, 'T6 Instate Tractor Class 7', 'Dsl', 26148.5),
    ('2021', '1.0', 2020, 'T6 Instate Tractor Class 7', 'NG', 112.735),
    ('2021', '1.0', 2020, 'T6 OOS Class 4', 'Dsl', 305.83),
    ('2021', '1.0', 2020, 'T6 OOS Class 5', 'Dsl', 419.544),
    ('2021', '1.0', 2020, 'T6 OOS Class 6', 'Dsl', 1096.28),
    ('2021', '1.0', 2020, 'T6 OOS Class 7', 'Dsl', 7971.33),
    ('2021', '1.0', 2020, 'T6 Public Class 4', 'Dsl', 9864.89),
    ('2021', '1.0', 2020, 'T6 Public Class 4', 'NG', 30.38),
    ('2021', '1.0', 2020, 'T6 Public Class 5', 'Dsl', 21812),
    ('2021', '1.0', 2020, 'T6 Public Class 5', 'NG', 265.75),
    ('2021', '1.0', 2020, 'T6 Public Class 6', 'Dsl', 14773.9),
    ('2021', '1.0', 2020, 'T6 Public Class 6', 'NG', 58.9056),
    ('2021', '1.0', 2020, 'T6 Public Class 7', 'Dsl', 32819.9),
    ('2021', '1.0', 2021, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1979.07),
    ('2021', '1.0', 2021, 'T7 Single Dump Class 8', 'Dsl', 49454.1),
    ('2021', '1.0', 2021, 'T7 Single Dump Class 8', 'NG', 3688.62),
    ('2021', '1.0', 2021, 'T7 Single Other Class 8', 'Dsl', 87978.5),
    ('2021', '1.0', 2021, 'T7 Single Other Class 8', 'NG', 6665.29),
    ('2021', '1.0', 2021, 'T7 SWCV Class 8', 'Dsl', 47399.8),
    ('2021', '1.0', 2021, 'T7 SWCV Class 8', 'NG', 39032.3),
    ('2021', '1.0', 2021, 'T7 Tractor Class 8', 'Dsl', 302623),
    ('2021', '1.0', 2021, 'T7 Tractor Class 8', 'NG', 4769),
    ('2021', '1.0', 2021, 'T7 Utility Class 8', 'Dsl', 6510.84),
    ('2021', '1.0', 2021, 'T7IS', 'Gas', 633.832),
    ('2021', '1.0', 2021, 'UBUS', 'Gas', 12157.6),
    ('2021', '1.0', 2021, 'UBUS', 'Dsl', 2552.67),
    ('2021', '1.0', 2021, 'UBUS', 'NG', 98773.6),
    ('2021', '1.0', 2022, 'All Other Buses', 'Dsl', 24398.7),
    ('2021', '1.0', 2022, 'All Other Buses', 'NG', 5491.32),
    ('2021', '1.0', 2022, 'LDA', 'Gas', 4.66519e+007),
    ('2021', '1.0', 2022, 'LDA', 'Dsl', 205722),
    ('2021', '1.0', 2022, 'LDA', 'Elec', 2.09711e+006),
    ('2021', '1.0', 2022, 'LDA', 'Phe', 1.24883e+006),
    ('2021', '1.0', 2022, 'LDT1', 'Gas', 4.65132e+006),
    ('2021', '1.0', 2022, 'LDT1', 'Dsl', 1118.12),
    ('2021', '1.0', 2022, 'LDT1', 'Elec', 6613.86),
    ('2021', '1.0', 2022, 'LDT1', 'Phe', 2525.07),
    ('2021', '1.0', 2022, 'LDT2', 'Gas', 2.18179e+007),
    ('2021', '1.0', 2022, 'LDT2', 'Dsl', 82881.7),
    ('2021', '1.0', 2022, 'LDT2', 'Elec', 46668.6),
    ('2021', '1.0', 2022, 'LDT2', 'Phe', 121164),
    ('2021', '1.0', 2022, 'LHD1', 'Gas', 1.63217e+006),
    ('2021', '1.0', 2022, 'LHD1', 'Dsl', 1.14792e+006),
    ('2021', '1.0', 2022, 'LHD2', 'Gas', 225990),
    ('2021', '1.0', 2022, 'LHD2', 'Dsl', 448079),
    ('2021', '1.0', 2022, 'MCY', 'Gas', 436040),
    ('2021', '1.0', 2022, 'MDV', 'Gas', 1.29073e+007),
    ('2021', '1.0', 2022, 'MDV', 'Dsl', 245783),
    ('2021', '1.0', 2022, 'MDV', 'Elec', 46899.5),
    ('2021', '1.0', 2022, 'MDV', 'Phe', 79487.5),
    ('2021', '1.0', 2022, 'MH', 'Gas', 103886),
    ('2021', '1.0', 2022, 'MH', 'Dsl', 40359),
    ('2021', '1.0', 2022, 'Motor Coach', 'Dsl', 22799.8),
    ('2021', '1.0', 2022, 'OBUS', 'Gas', 61727.8),
    ('2021', '1.0', 2022, 'PTO', 'Dsl', 35069.8),
    ('2021', '1.0', 2022, 'SBUS', 'Gas', 14719.6),
    ('2021', '1.0', 2022, 'SBUS', 'Dsl', 45543.5),
    ('2021', '1.0', 2022, 'SBUS', 'NG', 396.94),
    ('2021', '1.0', 2022, 'T6 CAIRP Class 4', 'Dsl', 549.534),
    ('2021', '1.0', 2022, 'T6 CAIRP Class 5', 'Dsl', 753.862),
    ('2021', '1.0', 2022, 'T6 CAIRP Class 6', 'Dsl', 1969.86),
    ('2021', '1.0', 2022, 'T6 CAIRP Class 7', 'Dsl', 12356),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 4', 'Dsl', 30159.3),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 4', 'NG', 444.437),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 5', 'Dsl', 22707.8),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 5', 'NG', 512.947),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 6', 'Dsl', 68067.8),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 6', 'NG', 1190.72),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 7', 'Elec', 13.9832),
    ('2021', '1.0', 2023, 'T6 Instate Other Class 7', 'NG', 629.8),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 6', 'Dsl', 875.533),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 6', 'Elec', 0.0246483),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 6', 'NG', 20.6792),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 7', 'Dsl', 27047.5),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 7', 'Elec', 1.23126),
    ('2021', '1.0', 2023, 'T6 Instate Tractor Class 7', 'NG', 169.92),
    ('2021', '1.0', 2023, 'T6 OOS Class 4', 'Dsl', 316.98),
    ('2021', '1.0', 2023, 'T6 OOS Class 5', 'Dsl', 434.839),
    ('2021', '1.0', 2023, 'T6 OOS Class 6', 'Dsl', 1136.25),
    ('2021', '1.0', 2023, 'T6 OOS Class 7', 'Dsl', 8261.93),
    ('2021', '1.0', 2023, 'T6 Public Class 4', 'Dsl', 9967.53),
    ('2021', '1.0', 2023, 'T6 Public Class 4', 'Elec', 0.583836),
    ('2021', '1.0', 2023, 'T6 Public Class 4', 'NG', 57.7563),
    ('2021', '1.0', 2023, 'T6 Public Class 5', 'Dsl', 22076.7),
    ('2021', '1.0', 2023, 'T6 Public Class 5', 'Elec', 1.09756),
    ('2021', '1.0', 2023, 'T6 Public Class 5', 'NG', 291.407),
    ('2021', '1.0', 2023, 'T6 Public Class 6', 'Dsl', 14927.9),
    ('2021', '1.0', 2023, 'T6 Public Class 6', 'Elec', 5.59535),
    ('2021', '1.0', 2023, 'T6 Public Class 6', 'NG', 95.0554),
    ('2021', '1.0', 2023, 'T6 Public Class 7', 'Dsl', 33167.7),
    ('2021', '1.0', 2023, 'T6 Public Class 7', 'Elec', 11.0769),
    ('2021', '1.0', 2023, 'T6 Public Class 7', 'NG', 275.401),
    ('2021', '1.0', 2023, 'T6 Utility Class 5', 'Dsl', 8320.55),
    ('2021', '1.0', 2023, 'T6 Utility Class 6', 'Dsl', 1997.81),
    ('2021', '1.0', 2023, 'T6 Utility Class 7', 'Dsl', 2421.88),
    ('2021', '1.0', 2023, 'T6 Utility Class 7', 'Elec', 2.22876),
    ('2021', '1.0', 2023, 'T6TS', 'Gas', 195472),
    ('2021', '1.0', 2023, 'T7 CAIRP Class 8', 'Dsl', 414744),
    ('2021', '1.0', 2023, 'T7 CAIRP Class 8', 'Elec', 466.078),
    ('2021', '1.0', 2023, 'T7 CAIRP Class 8', 'NG', 412.666),
    ('2021', '1.0', 2023, 'T7 NNOOS Class 8', 'Dsl', 491394),
    ('2021', '1.0', 2023, 'T7 NOOS Class 8', 'Dsl', 178515),
    ('2021', '1.0', 2023, 'T7 Other Port Class 8', 'Dsl', 96726.8),
    ('2021', '1.0', 2023, 'T7 Other Port Class 8', 'Elec', 24.6377),
    ('2021', '1.0', 2023, 'T7 POLA Class 8', 'Dsl', 30261.1),
    ('2021', '1.0', 2023, 'T7 POLA Class 8', 'Elec', 3.49162),
    ('2021', '1.0', 2023, 'T7 Public Class 8', 'Dsl', 65371.7),
    ('2021', '1.0', 2023, 'T7 Public Class 8', 'Elec', 15.2507),
    ('2021', '1.0', 2023, 'T7 Public Class 8', 'NG', 376.681),
    ('2021', '1.0', 2023, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24759.2),
    ('2021', '1.0', 2023, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 5.58423),
    ('2021', '1.0', 2023, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 2203.46),
    ('2021', '1.0', 2023, 'T7 Single Dump Class 8', 'Dsl', 49754.6),
    ('2021', '1.0', 2023, 'T7 Single Dump Class 8', 'NG', 3993.43),
    ('2021', '1.0', 2023, 'T7 Single Other Class 8', 'Dsl', 90356.6),
    ('2021', '1.0', 2023, 'T7 Single Other Class 8', 'Elec', 43.5785),
    ('2021', '1.0', 2023, 'T7 Single Other Class 8', 'NG', 7286.89),
    ('2021', '1.0', 2023, 'T7 SWCV Class 8', 'Dsl', 40453.1),
    ('2021', '1.0', 2023, 'T7 SWCV Class 8', 'Elec', 18.3657),
    ('2021', '1.0', 2023, 'T7 SWCV Class 8', 'NG', 46746.1),
    ('2021', '1.0', 2023, 'T7 Tractor Class 8', 'Dsl', 312331),
    ('2021', '1.0', 2023, 'T7 Tractor Class 8', 'Elec', 122.086),
    ('2021', '1.0', 2023, 'T7 Tractor Class 8', 'NG', 4822.8),
    ('2021', '1.0', 2023, 'T7 Utility Class 8', 'Dsl', 6568.81),
    ('2021', '1.0', 2023, 'T7 Utility Class 8', 'Elec', 1.19972),
    ('2021', '1.0', 2023, 'T7IS', 'Gas', 525.175),
    ('2021', '1.0', 2023, 'UBUS', 'Gas', 13096.1),
    ('2021', '1.0', 2023, 'UBUS', 'NG', 109148),
    ('2021', '1.0', 2026, 'All Other Buses', 'Dsl', 24876.6),
    ('2021', '1.0', 2026, 'All Other Buses', 'NG', 5615.76),
    ('2021', '1.0', 2026, 'LDA', 'Gas', 4.64052e+007)
INSERT INTO #tt_emfac_default_vmt VALUES
    ('2021', '1.0', 2029, 'All Other Buses', 'Dsl', 25501),
    ('2021', '1.0', 2029, 'All Other Buses', 'NG', 5420.85),
    ('2021', '1.0', 2029, 'LDA', 'Gas', 4.62141e+007),
    ('2021', '1.0', 2029, 'LDA', 'Dsl', 94251.4),
    ('2021', '1.0', 2029, 'LDA', 'Elec', 4.85777e+006),
    ('2021', '1.0', 2029, 'LDA', 'Phe', 1.98599e+006),
    ('2021', '1.0', 2029, 'LDT1', 'Gas', 3.84295e+006),
    ('2021', '1.0', 2029, 'LDT1', 'Dsl', 138.428),
    ('2021', '1.0', 2029, 'LDT1', 'Elec', 32651.8),
    ('2021', '1.0', 2029, 'LDT1', 'Phe', 24788.7),
    ('2021', '1.0', 2029, 'LDT2', 'Gas', 2.30411e+007),
    ('2021', '1.0', 2029, 'LDT2', 'Dsl', 90063.2),
    ('2021', '1.0', 2029, 'LDT2', 'Elec', 303515),
    ('2021', '1.0', 2029, 'LDT2', 'Phe', 365897),
    ('2021', '1.0', 2029, 'LHD1', 'Gas', 1.62467e+006),
    ('2021', '1.0', 2029, 'LHD1', 'Dsl', 1.18839e+006),
    ('2021', '1.0', 2029, 'LHD1', 'Elec', 195435),
    ('2021', '1.0', 2029, 'LHD2', 'Gas', 223393),
    ('2021', '1.0', 2029, 'LHD2', 'Dsl', 512612),
    ('2021', '1.0', 2029, 'LHD2', 'Elec', 48563.6),
    ('2021', '1.0', 2029, 'MCY', 'Gas', 411441),
    ('2021', '1.0', 2029, 'MDV', 'Gas', 1.32964e+007),
    ('2021', '1.0', 2029, 'MDV', 'Dsl', 199976),
    ('2021', '1.0', 2029, 'MDV', 'Elec', 308134),
    ('2021', '1.0', 2029, 'MDV', 'Phe', 234482),
    ('2021', '1.0', 2029, 'MH', 'Gas', 72743),
    ('2021', '1.0', 2029, 'MH', 'Dsl', 36524),
    ('2021', '1.0', 2029, 'Motor Coach', 'Dsl', 23609.7),
    ('2021', '1.0', 2029, 'OBUS', 'Gas', 44284.9),
    ('2021', '1.0', 2029, 'OBUS', 'Elec', 3217.22),
    ('2021', '1.0', 2029, 'PTO', 'Dsl', 35077),
    ('2021', '1.0', 2029, 'PTO', 'Elec', 2788.04),
    ('2021', '1.0', 2029, 'SBUS', 'Gas', 17113.5),
    ('2021', '1.0', 2029, 'SBUS', 'Dsl', 42942),
    ('2021', '1.0', 2029, 'SBUS', 'Elec', 3376.47),
    ('2021', '1.0', 2029, 'SBUS', 'NG', 596.288),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 4', 'Dsl', 541.498),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 4', 'Elec', 55.9235),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 5', 'Dsl', 747.275),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 5', 'Elec', 72.2789),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 6', 'Dsl', 1911.06),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 6', 'Elec', 230.455),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 7', 'Dsl', 12641.6),
    ('2021', '1.0', 2029, 'T6 CAIRP Class 7', 'Elec', 791.072),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 4', 'Dsl', 30479.9),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 4', 'Elec', 2217.47),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 4', 'NG', 573.211),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 5', 'Dsl', 23102.7),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 5', 'Elec', 1593.79),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 5', 'NG', 547.748),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 6', 'Dsl', 68975.2),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 6', 'Elec', 4840.05),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 6', 'NG', 1478.52),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 7', 'Dsl', 28531.1),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 7', 'Elec', 610.41),
    ('2021', '1.0', 2029, 'T6 Instate Delivery Class 7', 'NG', 263.484),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 4', 'Dsl', 78678.8),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 4', 'Elec', 6462.9),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 4', 'NG', 1572.47),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 5', 'Dsl', 148739),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 5', 'Elec', 11225),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 7', 'Dsl', 28571),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 7', 'Elec', 920.414),
    ('2021', '1.0', 2030, 'T6 Instate Delivery Class 7', 'NG', 266.651),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 4', 'Dsl', 76929.6),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 4', 'Elec', 9279.6),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 4', 'NG', 1546.13),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 5', 'Dsl', 145676),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 5', 'Elec', 16392.6),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 5', 'NG', 3715.13),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 6', 'Dsl', 143355),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 6', 'Elec', 16124.1),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 6', 'NG', 3868.6),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 7', 'Dsl', 73116.4),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 7', 'Elec', 6065.1),
    ('2021', '1.0', 2030, 'T6 Instate Other Class 7', 'NG', 555.346),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 6', 'Dsl', 846.937),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 6', 'Elec', 108.126),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 6', 'NG', 19.2732),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 7', 'Dsl', 28398.7),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 7', 'Elec', 1025.53),
    ('2021', '1.0', 2030, 'T6 Instate Tractor Class 7', 'NG', 166.214),
    ('2021', '1.0', 2030, 'T6 OOS Class 4', 'Dsl', 344.602),
    ('2021', '1.0', 2030, 'T6 OOS Class 5', 'Dsl', 472.732),
    ('2021', '1.0', 2030, 'T6 OOS Class 6', 'Dsl', 1235.26),
    ('2021', '1.0', 2030, 'T6 OOS Class 7', 'Dsl', 8981.88),
    ('2021', '1.0', 2030, 'T6 Public Class 4', 'Dsl', 9426.14),
    ('2021', '1.0', 2030, 'T6 Public Class 4', 'Elec', 851.345),
    ('2021', '1.0', 2030, 'T6 Public Class 4', 'NG', 91.501),
    ('2021', '1.0', 2030, 'T6 Public Class 5', 'Dsl', 20973.2),
    ('2021', '1.0', 2030, 'T6 Public Class 5', 'Elec', 1856.9),
    ('2021', '1.0', 2030, 'T6 Public Class 5', 'NG', 304.656),
    ('2021', '1.0', 2030, 'T6 Public Class 6', 'Dsl', 14111.1),
    ('2021', '1.0', 2030, 'T6 Public Class 6', 'Elec', 1289.68),
    ('2021', '1.0', 2030, 'T6 Public Class 6', 'NG', 142.14),
    ('2021', '1.0', 2030, 'T6 Public Class 7', 'Dsl', 30984.4),
    ('2021', '1.0', 2030, 'T6 Public Class 7', 'Elec', 3261.52),
    ('2021', '1.0', 2030, 'T6 Public Class 7', 'NG', 353.238),
    ('2021', '1.0', 2030, 'T6 Utility Class 5', 'Dsl', 7342.74),
    ('2021', '1.0', 2030, 'T6 Utility Class 5', 'Elec', 1262.57),
    ('2021', '1.0', 2030, 'T6 Utility Class 6', 'Dsl', 1760.77),
    ('2021', '1.0', 2030, 'T6 Utility Class 6', 'Elec', 305.406),
    ('2021', '1.0', 2030, 'T6 Utility Class 7', 'Dsl', 2100.55),
    ('2021', '1.0', 2030, 'T6 Utility Class 7', 'Elec', 406.516),
    ('2021', '1.0', 2030, 'T6TS', 'Gas', 185780),
    ('2021', '1.0', 2030, 'T6TS', 'Elec', 23665.3),
    ('2021', '1.0', 2030, 'T7 CAIRP Class 8', 'Dsl', 425674),
    ('2021', '1.0', 2030, 'T7 CAIRP Class 8', 'Elec', 38235.3),
    ('2021', '1.0', 2030, 'T7 CAIRP Class 8', 'NG', 397.716),
    ('2021', '1.0', 2030, 'T7 NNOOS Class 8', 'Dsl', 548955),
    ('2021', '1.0', 2030, 'T7 NOOS Class 8', 'Dsl', 199425),
    ('2021', '1.0', 2030, 'T7 Other Port Class 8', 'Dsl', 116738),
    ('2021', '1.0', 2030, 'T7 Other Port Class 8', 'Elec', 7921.98),
    ('2021', '1.0', 2030, 'T7 POLA Class 8', 'Dsl', 39038.7),
    ('2021', '1.0', 2030, 'T7 POLA Class 8', 'Elec', 722.653),
    ('2021', '1.0', 2030, 'T7 Public Class 8', 'Dsl', 62103.9),
    ('2021', '1.0', 2030, 'T7 Public Class 8', 'Elec', 5462.02),
    ('2021', '1.0', 2030, 'T7 Public Class 8', 'NG', 448.368),
    ('2021', '1.0', 2030, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 21849.2),
    ('2021', '1.0', 2030, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 4334.34),
    ('2021', '1.0', 2030, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1769.85),
    ('2021', '1.0', 2030, 'T7 Single Dump Class 8', 'Dsl', 46837.4),
    ('2021', '1.0', 2030, 'T7 Single Dump Class 8', 'Elec', 5117.6),
    ('2021', '1.0', 2030, 'T7 Single Dump Class 8', 'NG', 3756.39),
    ('2021', '1.0', 2030, 'T7 Single Other Class 8', 'Dsl', 91909.9),
    ('2021', '1.0', 2030, 'T7 Single Other Class 8', 'Elec', 9951.45),
    ('2021', '1.0', 2032, 'T7 Single Dump Class 8', 'Dsl', 44824.1),
    ('2021', '1.0', 2032, 'T7 Single Dump Class 8', 'Elec', 7856.46),
    ('2021', '1.0', 2032, 'T7 Single Dump Class 8', 'NG', 3547.91),
    ('2021', '1.0', 2032, 'T7 Single Other Class 8', 'Dsl', 92402.3),
    ('2021', '1.0', 2032, 'T7 Single Other Class 8', 'Elec', 17457.5),
    ('2021', '1.0', 2032, 'T7 Single Other Class 8', 'NG', 7237.11),
    ('2021', '1.0', 2032, 'T7 SWCV Class 8', 'Dsl', 17034.4),
    ('2021', '1.0', 2032, 'T7 SWCV Class 8', 'Elec', 8704.29),
    ('2021', '1.0', 2032, 'T7 SWCV Class 8', 'NG', 65192.8),
    ('2021', '1.0', 2032, 'T7 Tractor Class 8', 'Dsl', 349933),
    ('2021', '1.0', 2032, 'T7 Tractor Class 8', 'Elec', 25429.4),
    ('2021', '1.0', 2032, 'T7 Tractor Class 8', 'NG', 4954.86),
    ('2021', '1.0', 2032, 'T7 Utility Class 8', 'Dsl', 5938.48),
    ('2021', '1.0', 2032, 'T7 Utility Class 8', 'Elec', 911.287),
    ('2021', '1.0', 2032, 'T7IS', 'Gas', 489.798),
    ('2021', '1.0', 2032, 'T7IS', 'Elec', 109.118),
    ('2021', '1.0', 2032, 'UBUS', 'Gas', 17201.6),
    ('2021', '1.0', 2032, 'UBUS', 'Elec', 64518),
    ('2021', '1.0', 2032, 'UBUS', 'NG', 79946),
    ('2021', '1.0', 2035, 'All Other Buses', 'Dsl', 26445.7),
    ('2021', '1.0', 2035, 'All Other Buses', 'NG', 5213.39),
    ('2021', '1.0', 2035, 'LDA', 'Gas', 4.63479e+007),
    ('2021', '1.0', 2035, 'LDA', 'Dsl', 45149.6),
    ('2021', '1.0', 2035, 'LDA', 'Elec', 6.13802e+006),
    ('2021', '1.0', 2035, 'LDA', 'Phe', 2.1838e+006),
    ('2021', '1.0', 2035, 'LDT1', 'Gas', 3.39e+006),
    ('2021', '1.0', 2035, 'LDT1', 'Dsl', 29.06),
    ('2021', '1.0', 2035, 'LDT1', 'Elec', 67210.2),
    ('2021', '1.0', 2035, 'LDT1', 'Phe', 49528.8),
    ('2021', '1.0', 2035, 'LDT2', 'Gas', 2.33734e+007),
    ('2021', '1.0', 2035, 'LDT2', 'Dsl', 88897.5),
    ('2021', '1.0', 2035, 'LDT2', 'Elec', 531116),
    ('2021', '1.0', 2035, 'LDT2', 'Phe', 534719),
    ('2021', '1.0', 2035, 'LHD1', 'Gas', 1.38283e+006),
    ('2021', '1.0', 2035, 'LHD1', 'Dsl', 1.03915e+006),
    ('2021', '1.0', 2035, 'LHD1', 'Elec', 735138),
    ('2021', '1.0', 2035, 'LHD2', 'Gas', 188890),
    ('2021', '1.0', 2035, 'LHD2', 'Dsl', 468652),
    ('2021', '1.0', 2035, 'LHD2', 'Elec', 185715),
    ('2021', '1.0', 2035, 'MCY', 'Gas', 400555),
    ('2021', '1.0', 2035, 'MDV', 'Gas', 1.34925e+007),
    ('2021', '1.0', 2035, 'MDV', 'Dsl', 168660),
    ('2021', '1.0', 2035, 'MDV', 'Elec', 495120),
    ('2021', '1.0', 2035, 'MDV', 'Phe', 337827),
    ('2021', '1.0', 2035, 'MH', 'Gas', 58799.1),
    ('2021', '1.0', 2035, 'MH', 'Dsl', 33466.8),
    ('2021', '1.0', 2035, 'Motor Coach', 'Dsl', 24395.2),
    ('2021', '1.0', 2035, 'OBUS', 'Gas', 30803.8),
    ('2021', '1.0', 2035, 'OBUS', 'Elec', 11904.7),
    ('2021', '1.0', 2035, 'PTO', 'Dsl', 31790.1),
    ('2021', '1.0', 2035, 'PTO', 'Elec', 11053.8),
    ('2021', '1.0', 2035, 'SBUS', 'Gas', 16522.8),
    ('2021', '1.0', 2035, 'SBUS', 'Dsl', 35557.8),
    ('2021', '1.0', 2035, 'SBUS', 'Elec', 13718.9),
    ('2021', '1.0', 2035, 'SBUS', 'NG', 659.172),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 4', 'Dsl', 429.145),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 4', 'Elec', 233.594),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 5', 'Dsl', 593.46),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 5', 'Elec', 315.7),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 6', 'Dsl', 1512.06),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 6', 'Elec', 863.597),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 7', 'Dsl', 12298.2),
    ('2021', '1.0', 2035, 'T6 CAIRP Class 7', 'Elec', 2603.11),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 6', 'Dsl', 1254.62),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 6', 'Elec', 1349.51),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 7', 'Dsl', 12745.5),
    ('2021', '1.0', 2040, 'T6 CAIRP Class 7', 'Elec', 3588.89),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 4', 'Dsl', 23168.9),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 4', 'Elec', 16859.9),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 4', 'NG', 428.95),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 5', 'Dsl', 17585.4),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 5', 'Elec', 12755.6),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 5', 'NG', 356.501),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 6', 'Dsl', 52439.1),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 6', 'Elec', 38099.9),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 6', 'NG', 1019.8),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 7', 'Dsl', 26127.1),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 7', 'Elec', 9364.04),
    ('2021', '1.0', 2040, 'T6 Instate Delivery Class 7', 'NG', 265.982),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 4', 'Dsl', 59018.2),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 4', 'Elec', 45344.7),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 4', 'NG', 1083.39),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 5', 'Dsl', 111284),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 5', 'Elec', 85709.3),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 5', 'NG', 2211.23),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 6', 'Dsl', 109613),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 6', 'Elec', 84437),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 6', 'NG', 2228.29),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 7', 'Dsl', 63115.9),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 7', 'Elec', 32184.5),
    ('2021', '1.0', 2040, 'T6 Instate Other Class 7', 'NG', 510.957),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 6', 'Dsl', 632.526),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 6', 'Elec', 525.974),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 6', 'NG', 12.2553),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 7', 'Dsl', 29951.2),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 7', 'Elec', 5388.62),
    ('2021', '1.0', 2040, 'T6 Instate Tractor Class 7', 'NG', 215.88),
    ('2021', '1.0', 2040, 'T6 OOS Class 4', 'Dsl', 414.071),
    ('2021', '1.0', 2040, 'T6 OOS Class 5', 'Dsl', 568.031),
    ('2021', '1.0', 2040, 'T6 OOS Class 6', 'Dsl', 1484.28),
    ('2021', '1.0', 2040, 'T6 OOS Class 7', 'Dsl', 10792.6),
    ('2021', '1.0', 2040, 'T6 Public Class 4', 'Dsl', 6865.53),
    ('2021', '1.0', 2040, 'T6 Public Class 4', 'Elec', 3790.45),
    ('2021', '1.0', 2040, 'T6 Public Class 4', 'NG', 81.7788),
    ('2021', '1.0', 2040, 'T6 Public Class 5', 'Dsl', 15286.2),
    ('2021', '1.0', 2040, 'T6 Public Class 5', 'Elec', 8456.79),
    ('2021', '1.0', 2040, 'T6 Public Class 5', 'NG', 214.536),
    ('2021', '1.0', 2040, 'T6 Public Class 6', 'Dsl', 10298.2),
    ('2021', '1.0', 2040, 'T6 Public Class 6', 'Elec', 5673.18),
    ('2021', '1.0', 2040, 'T6 Public Class 6', 'NG', 124.312),
    ('2021', '1.0', 2040, 'T6 Public Class 7', 'Dsl', 23804.4),
    ('2021', '1.0', 2040, 'T6 Public Class 7', 'Elec', 11717.5),
    ('2021', '1.0', 2040, 'T6 Public Class 7', 'NG', 307.756),
    ('2021', '1.0', 2040, 'T6 Utility Class 5', 'Dsl', 4297.94),
    ('2021', '1.0', 2040, 'T6 Utility Class 5', 'Elec', 4613.41),
    ('2021', '1.0', 2040, 'T6 Utility Class 6', 'Dsl', 1032.04),
    ('2021', '1.0', 2040, 'T6 Utility Class 6', 'Elec', 1107.62),
    ('2021', '1.0', 2040, 'T6 Utility Class 7', 'Dsl', 1207.99),
    ('2021', '1.0', 2040, 'T6 Utility Class 7', 'Elec', 1388.24),
    ('2021', '1.0', 2040, 'T6TS', 'Gas', 126036),
    ('2021', '1.0', 2040, 'T6TS', 'Elec', 98746.8),
    ('2021', '1.0', 2040, 'T7 CAIRP Class 8', 'Dsl', 518046),
    ('2021', '1.0', 2040, 'T7 CAIRP Class 8', 'Elec', 141923),
    ('2021', '1.0', 2040, 'T7 CAIRP Class 8', 'NG', 441.831),
    ('2021', '1.0', 2040, 'T7 NNOOS Class 8', 'Dsl', 780810),
    ('2021', '1.0', 2040, 'T7 NOOS Class 8', 'Dsl', 283655),
    ('2021', '1.0', 2040, 'T7 Other Port Class 8', 'Dsl', 122660),
    ('2021', '1.0', 2040, 'T7 Other Port Class 8', 'Elec', 29026.4),
    ('2021', '1.0', 2045, 'T7 NNOOS Class 8', 'Dsl', 931215),
    ('2021', '1.0', 2045, 'T7 NOOS Class 8', 'Dsl', 338294),
    ('2021', '1.0', 2045, 'T7 Other Port Class 8', 'Dsl', 122656),
    ('2021', '1.0', 2045, 'T7 Other Port Class 8', 'Elec', 31017.2),
    ('2021', '1.0', 2045, 'T7 POLA Class 8', 'Dsl', 41077.2),
    ('2021', '1.0', 2045, 'T7 POLA Class 8', 'Elec', 7147.05),
    ('2021', '1.0', 2045, 'T7 Public Class 8', 'Dsl', 43342.6),
    ('2021', '1.0', 2045, 'T7 Public Class 8', 'Elec', 27575.4),
    ('2021', '1.0', 2045, 'T7 Public Class 8', 'NG', 380.201),
    ('2021', '1.0', 2045, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 12036.1),
    ('2021', '1.0', 2045, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 17007.2),
    ('2021', '1.0', 2045, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 915.492),
    ('2021', '1.0', 2045, 'T7 Single Dump Class 8', 'Dsl', 30075.2),
    ('2021', '1.0', 2045, 'T7 Single Dump Class 8', 'Elec', 27310.7),
    ('2021', '1.0', 2045, 'T7 Single Dump Class 8', 'NG', 2322.39),
    ('2021', '1.0', 2045, 'T7 Single Other Class 8', 'Dsl', 87848.4),
    ('2021', '1.0', 2045, 'T7 Single Other Class 8', 'Elec', 90540.1),
    ('2021', '1.0', 2045, 'T7 Single Other Class 8', 'NG', 6733.03),
    ('2021', '1.0', 2045, 'T7 SWCV Class 8', 'Dsl', 4128.68),
    ('2021', '1.0', 2045, 'T7 SWCV Class 8', 'Elec', 37089.1),
    ('2021', '1.0', 2045, 'T7 SWCV Class 8', 'NG', 53340.1),
    ('2021', '1.0', 2045, 'T7 Tractor Class 8', 'Dsl', 494712),
    ('2021', '1.0', 2045, 'T7 Tractor Class 8', 'Elec', 99853.5),
    ('2021', '1.0', 2045, 'T7 Tractor Class 8', 'NG', 6688.13),
    ('2021', '1.0', 2045, 'T7 Utility Class 8', 'Dsl', 4079.11),
    ('2021', '1.0', 2045, 'T7 Utility Class 8', 'Elec', 3043.83),
    ('2021', '1.0', 2045, 'T7IS', 'Gas', 368.854),
    ('2021', '1.0', 2045, 'T7IS', 'Elec', 388.462),
    ('2021', '1.0', 2045, 'UBUS', 'Gas', 22517.6),
    ('2021', '1.0', 2045, 'UBUS', 'Elec', 196090),
    ('2021', '1.0', 2050, 'All Other Buses', 'Dsl', 27491.6),
    ('2021', '1.0', 2050, 'All Other Buses', 'NG', 5311.77),
    ('2021', '1.0', 2050, 'LDA', 'Gas', 4.77556e+007),
    ('2021', '1.0', 2050, 'LDA', 'Dsl', 28000.9),
    ('2021', '1.0', 2050, 'LDA', 'Elec', 6.99671e+006),
    ('2021', '1.0', 2050, 'LDA', 'Phe', 2.28121e+006),
    ('2021', '1.0', 2050, 'LDT1', 'Gas', 3.06241e+006),
    ('2021', '1.0', 2050, 'LDT1', 'Dsl', 36.2886),
    ('2021', '1.0', 2050, 'LDT1', 'Elec', 104185),
    ('2021', '1.0', 2050, 'LDT1', 'Phe', 76168.1),
    ('2021', '1.0', 2050, 'LDT2', 'Gas', 2.39209e+007),
    ('2021', '1.0', 2050, 'LDT2', 'Dsl', 91950.6),
    ('2021', '1.0', 2050, 'LDT2', 'Elec', 723757),
    ('2021', '1.0', 2050, 'LDT2', 'Phe', 667926),
    ('2021', '1.0', 2050, 'LHD1', 'Gas', 954197),
    ('2021', '1.0', 2050, 'LHD1', 'Dsl', 725721),
    ('2021', '1.0', 2050, 'LHD1', 'Elec', 1.65941e+006),
    ('2021', '1.0', 2050, 'LHD2', 'Gas', 128757),
    ('2021', '1.0', 2050, 'LHD2', 'Dsl', 342734),
    ('2021', '1.0', 2050, 'LHD2', 'Elec', 437064),
    ('2021', '1.0', 2050, 'MCY', 'Gas', 391982),
    ('2021', '1.0', 2050, 'MDV', 'Gas', 1.38484e+007),
    ('2021', '1.0', 2050, 'MDV', 'Dsl', 150833),
    ('2021', '1.0', 2050, 'MDV', 'Elec', 655563),
    ('2021', '1.0', 2050, 'MDV', 'Phe', 425727),
    ('2021', '1.0', 2050, 'MH', 'Gas', 48347.4),
    ('2021', '1.0', 2050, 'MH', 'Dsl', 28038.5),
    ('2021', '1.0', 2050, 'Motor Coach', 'Dsl', 26475.4),
    ('2021', '1.0', 2050, 'OBUS', 'Gas', 17180.3),
    ('2021', '1.0', 2050, 'OBUS', 'Elec', 23339.4),
    ('2021', '1.0', 2050, 'PTO', 'Dsl', 28827.8),
    ('2021', '1.0', 2050, 'PTO', 'Elec', 33231.5),
    ('2021', '1.0', 2017, 'MCY', 'Gas', 486975),
    ('2021', '1.0', 2017, 'MDV', 'Gas', 1.25417e+007),
    ('2021', '1.0', 2017, 'MDV', 'Dsl', 210475),
    ('2021', '1.0', 2017, 'MDV', 'Elec', 398.239),
    ('2021', '1.0', 2017, 'MDV', 'Phe', 21065.3),
    ('2021', '1.0', 2017, 'MH', 'Gas', 122288),
    ('2021', '1.0', 2017, 'MH', 'Dsl', 39404.4),
    ('2021', '1.0', 2017, 'Motor Coach', 'Dsl', 22960),
    ('2021', '1.0', 2017, 'OBUS', 'Gas', 78709.8),
    ('2021', '1.0', 2017, 'PTO', 'Dsl', 34937.2),
    ('2021', '1.0', 2017, 'SBUS', 'Gas', 14597.7),
    ('2021', '1.0', 2017, 'SBUS', 'Dsl', 46580.7),
    ('2021', '1.0', 2017, 'SBUS', 'NG', 270.663),
    ('2021', '1.0', 2017, 'T6 CAIRP Class 4', 'Dsl', 546.902),
    ('2021', '1.0', 2017, 'T6 CAIRP Class 5', 'Dsl', 750.252),
    ('2021', '1.0', 2017, 'T6 CAIRP Class 6', 'Dsl', 1960.43),
    ('2021', '1.0', 2017, 'T6 CAIRP Class 7', 'Dsl', 12296.8),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 4', 'Dsl', 30389.1),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 4', 'NG', 68.0657),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 5', 'Dsl', 22956),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 5', 'NG', 153.504),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 6', 'Dsl', 68511.4),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 6', 'NG', 415.377),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 7', 'Dsl', 26900.1),
    ('2021', '1.0', 2017, 'T6 Instate Delivery Class 7', 'NG', 18.3443),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 4', 'Dsl', 79268.7),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 4', 'NG', 112.735),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 5', 'Dsl', 148874),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 5', 'NG', 1090.42),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 6', 'Dsl', 146492),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 6', 'NG', 1268.31),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 7', 'Dsl', 72027.5),
    ('2021', '1.0', 2017, 'T6 Instate Other Class 7', 'NG', 100.623),
    ('2021', '1.0', 2017, 'T6 Instate Tractor Class 6', 'Dsl', 876.896),
    ('2021', '1.0', 2017, 'T6 Instate Tractor Class 6', 'NG', 4.46524),
    ('2021', '1.0', 2017, 'T6 Instate Tractor Class 7', 'Dsl', 26754.3),
    ('2021', '1.0', 2017, 'T6 Instate Tractor Class 7', 'NG', 12.5186),
    ('2021', '1.0', 2017, 'T6 OOS Class 4', 'Dsl', 311.719),
    ('2021', '1.0', 2017, 'T6 OOS Class 5', 'Dsl', 427.622),
    ('2021', '1.0', 2017, 'T6 OOS Class 6', 'Dsl', 1117.39),
    ('2021', '1.0', 2017, 'T6 OOS Class 7', 'Dsl', 8124.8),
    ('2021', '1.0', 2017, 'T6 Public Class 4', 'Dsl', 10036.6),
    ('2021', '1.0', 2017, 'T6 Public Class 4', 'NG', 16.016),
    ('2021', '1.0', 2017, 'T6 Public Class 5', 'Dsl', 22290.9),
    ('2021', '1.0', 2017, 'T6 Public Class 5', 'NG', 137.941),
    ('2021', '1.0', 2017, 'T6 Public Class 6', 'Dsl', 15027.5),
    ('2021', '1.0', 2017, 'T6 Public Class 6', 'NG', 41.2206),
    ('2021', '1.0', 2017, 'T6 Public Class 7', 'Dsl', 33407.6),
    ('2021', '1.0', 2017, 'T6 Public Class 7', 'NG', 135.852),
    ('2021', '1.0', 2017, 'T6 Utility Class 5', 'Dsl', 8342.76),
    ('2021', '1.0', 2017, 'T6 Utility Class 6', 'Dsl', 2003.14),
    ('2021', '1.0', 2017, 'T6 Utility Class 7', 'Dsl', 2430.58),
    ('2021', '1.0', 2017, 'T6TS', 'Gas', 180820),
    ('2021', '1.0', 2017, 'T7 CAIRP Class 8', 'Dsl', 403002),
    ('2021', '1.0', 2017, 'T7 CAIRP Class 8', 'NG', 98.9808),
    ('2021', '1.0', 2018, 'T7 Tractor Class 8', 'Dsl', 297319),
    ('2021', '1.0', 2018, 'T7 Tractor Class 8', 'NG', 3359.06),
    ('2021', '1.0', 2018, 'T7 Utility Class 8', 'Dsl', 6436.84),
    ('2021', '1.0', 2018, 'T7IS', 'Gas', 2061.85),
    ('2021', '1.0', 2018, 'UBUS', 'Gas', 16700.1),
    ('2021', '1.0', 2018, 'UBUS', 'Dsl', 3226.93),
    ('2021', '1.0', 2018, 'UBUS', 'NG', 96156.5),
    ('2021', '1.0', 2019, 'All Other Buses', 'Dsl', 26020.3),
    ('2021', '1.0', 2019, 'All Other Buses', 'NG', 3504.03),
    ('2021', '1.0', 2019, 'LDA', 'Gas', 4.60026e+007),
    ('2021', '1.0', 2019, 'LDA', 'Dsl', 247168),
    ('2021', '1.0', 2019, 'LDA', 'Elec', 878338),
    ('2021', '1.0', 2019, 'LDA', 'Phe', 822458),
    ('2021', '1.0', 2019, 'LDT1', 'Gas', 4.95144e+006),
    ('2021', '1.0', 2019, 'LDT1', 'Dsl', 1509.77),
    ('2021', '1.0', 2019, 'LDT1', 'Elec', 4387.47),
    ('2021', '1.0', 2019, 'LDT1', 'Phe', 59.5619),
    ('2021', '1.0', 2019, 'LDT2', 'Gas', 2.09556e+007),
    ('2021', '1.0', 2019, 'LDT2', 'Dsl', 74213.1),
    ('2021', '1.0', 2019, 'LDT2', 'Elec', 2045.12),
    ('2021', '1.0', 2019, 'LDT2', 'Phe', 32729.4),
    ('2021', '1.0', 2019, 'LHD1', 'Gas', 1.5853e+006),
    ('2021', '1.0', 2019, 'LHD1', 'Dsl', 1.06913e+006),
    ('2021', '1.0', 2019, 'LHD2', 'Gas', 216597),
    ('2021', '1.0', 2019, 'LHD2', 'Dsl', 390905),
    ('2021', '1.0', 2019, 'MCY', 'Gas', 455820),
    ('2021', '1.0', 2019, 'MDV', 'Gas', 1.24648e+007),
    ('2021', '1.0', 2019, 'MDV', 'Dsl', 257044),
    ('2021', '1.0', 2019, 'MDV', 'Elec', 128.489),
    ('2021', '1.0', 2019, 'MDV', 'Phe', 49189),
    ('2021', '1.0', 2019, 'MH', 'Gas', 119760),
    ('2021', '1.0', 2019, 'MH', 'Dsl', 40566.1),
    ('2021', '1.0', 2019, 'Motor Coach', 'Dsl', 22513.6),
    ('2021', '1.0', 2019, 'OBUS', 'Gas', 69371.3),
    ('2021', '1.0', 2019, 'PTO', 'Dsl', 34257.9),
    ('2021', '1.0', 2019, 'SBUS', 'Gas', 18962.7),
    ('2021', '1.0', 2019, 'SBUS', 'Dsl', 45612.5),
    ('2021', '1.0', 2019, 'SBUS', 'NG', 327.923),
    ('2021', '1.0', 2019, 'T6 CAIRP Class 4', 'Dsl', 536.269),
    ('2021', '1.0', 2019, 'T6 CAIRP Class 5', 'Dsl', 735.664),
    ('2021', '1.0', 2019, 'T6 CAIRP Class 6', 'Dsl', 1922.31),
    ('2021', '1.0', 2019, 'T6 CAIRP Class 7', 'Dsl', 12057.7),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 4', 'Dsl', 29604.7),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 4', 'NG', 260.256),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 5', 'Dsl', 22217.3),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 5', 'NG', 442.888),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 6', 'Dsl', 66744.8),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 6', 'NG', 841.893),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 7', 'Dsl', 26199.9),
    ('2021', '1.0', 2019, 'T6 Instate Delivery Class 7', 'NG', 195.185),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 4', 'Dsl', 77315.2),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 4', 'NG', 522.824),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 5', 'Dsl', 144025),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 5', 'NG', 3023.86),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 6', 'Dsl', 141936),
    ('2021', '1.0', 2019, 'T6 Instate Other Class 6', 'NG', 2951.74),
    ('2021', '1.0', 2020, 'T6 Public Class 7', 'NG', 198.533),
    ('2021', '1.0', 2020, 'T6 Utility Class 5', 'Dsl', 8212.17),
    ('2021', '1.0', 2020, 'T6 Utility Class 6', 'Dsl', 1971.78),
    ('2021', '1.0', 2020, 'T6 Utility Class 7', 'Dsl', 2392.53),
    ('2021', '1.0', 2020, 'T6TS', 'Gas', 164450),
    ('2021', '1.0', 2020, 'T7 CAIRP Class 8', 'Dsl', 396038),
    ('2021', '1.0', 2020, 'T7 CAIRP Class 8', 'NG', 315.506),
    ('2021', '1.0', 2020, 'T7 NNOOS Class 8', 'Dsl', 468612),
    ('2021', '1.0', 2020, 'T7 NOOS Class 8', 'Dsl', 170238),
    ('2021', '1.0', 2020, 'T7 Other Port Class 8', 'Dsl', 85551.6),
    ('2021', '1.0', 2020, 'T7 POLA Class 8', 'Dsl', 26584.8),
    ('2021', '1.0', 2020, 'T7 Public Class 8', 'Dsl', 64589.8),
    ('2021', '1.0', 2020, 'T7 Public Class 8', 'NG', 317.203),
    ('2021', '1.0', 2020, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 25020),
    ('2021', '1.0', 2020, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1845.02),
    ('2021', '1.0', 2020, 'T7 Single Dump Class 8', 'Dsl', 50006.5),
    ('2021', '1.0', 2020, 'T7 Single Dump Class 8', 'NG', 3535.73),
    ('2021', '1.0', 2020, 'T7 Single Other Class 8', 'Dsl', 86870.6),
    ('2021', '1.0', 2020, 'T7 Single Other Class 8', 'NG', 6287.39),
    ('2021', '1.0', 2020, 'T7 SWCV Class 8', 'Dsl', 50608.6),
    ('2021', '1.0', 2020, 'T7 SWCV Class 8', 'NG', 35473),
    ('2021', '1.0', 2020, 'T7 Tractor Class 8', 'Dsl', 297956),
    ('2021', '1.0', 2020, 'T7 Tractor Class 8', 'NG', 4610.02),
    ('2021', '1.0', 2020, 'T7 Utility Class 8', 'Dsl', 6484.43),
    ('2021', '1.0', 2020, 'T7IS', 'Gas', 622.503),
    ('2021', '1.0', 2020, 'UBUS', 'Gas', 11688.3),
    ('2021', '1.0', 2020, 'UBUS', 'Dsl', 2552.67),
    ('2021', '1.0', 2020, 'UBUS', 'NG', 94862.7),
    ('2021', '1.0', 2021, 'All Other Buses', 'Dsl', 24530.4),
    ('2021', '1.0', 2021, 'All Other Buses', 'NG', 5228.75),
    ('2021', '1.0', 2021, 'LDA', 'Gas', 4.62534e+007),
    ('2021', '1.0', 2021, 'LDA', 'Dsl', 220806),
    ('2021', '1.0', 2021, 'LDA', 'Elec', 1.64398e+006),
    ('2021', '1.0', 2021, 'LDA', 'Phe', 1.08239e+006),
    ('2021', '1.0', 2021, 'LDT1', 'Gas', 4.742e+006),
    ('2021', '1.0', 2021, 'LDT1', 'Dsl', 1243.41),
    ('2021', '1.0', 2021, 'LDT1', 'Elec', 5442.41),
    ('2021', '1.0', 2021, 'LDT1', 'Phe', 1116.13),
    ('2021', '1.0', 2021, 'LDT2', 'Gas', 2.13766e+007),
    ('2021', '1.0', 2021, 'LDT2', 'Dsl', 79313.2),
    ('2021', '1.0', 2021, 'LDT2', 'Elec', 18038.9),
    ('2021', '1.0', 2021, 'LDT2', 'Phe', 82236.1),
    ('2021', '1.0', 2021, 'LHD1', 'Gas', 1.59917e+006),
    ('2021', '1.0', 2021, 'LHD1', 'Dsl', 1.11228e+006),
    ('2021', '1.0', 2021, 'LHD2', 'Gas', 221316),
    ('2021', '1.0', 2021, 'LHD2', 'Dsl', 424982),
    ('2021', '1.0', 2021, 'MCY', 'Gas', 437705),
    ('2021', '1.0', 2021, 'MDV', 'Gas', 1.26844e+007),
    ('2021', '1.0', 2021, 'MDV', 'Dsl', 249280),
    ('2021', '1.0', 2021, 'MDV', 'Elec', 18921.2),
    ('2021', '1.0', 2021, 'MDV', 'Phe', 62533.6),
    ('2021', '1.0', 2021, 'MH', 'Gas', 109106),
    ('2021', '1.0', 2021, 'MH', 'Dsl', 40498.7),
    ('2021', '1.0', 2021, 'Motor Coach', 'Dsl', 22696.2),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 7', 'Dsl', 26790.1),
    ('2021', '1.0', 2022, 'T6 Instate Delivery Class 7', 'NG', 257.916),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 4', 'Dsl', 78783.9),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 4', 'NG', 979.598),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 5', 'Dsl', 147110),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 5', 'NG', 3576.32),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 6', 'Dsl', 144731),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 6', 'NG', 3740.92),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 7', 'Dsl', 71870.3),
    ('2021', '1.0', 2022, 'T6 Instate Other Class 7', 'NG', 604.995),
    ('2021', '1.0', 2022, 'T6 Instate Tractor Class 6', 'Dsl', 867.971),
    ('2021', '1.0', 2022, 'T6 Instate Tractor Class 6', 'NG', 17.632),
    ('2021', '1.0', 2022, 'T6 Instate Tractor Class 7', 'Dsl', 26763.5),
    ('2021', '1.0', 2022, 'T6 Instate Tractor Class 7', 'NG', 132.192),
    ('2021', '1.0', 2022, 'T6 OOS Class 4', 'Dsl', 313.219),
    ('2021', '1.0', 2022, 'T6 OOS Class 5', 'Dsl', 429.68),
    ('2021', '1.0', 2022, 'T6 OOS Class 6', 'Dsl', 1122.77),
    ('2021', '1.0', 2022, 'T6 OOS Class 7', 'Dsl', 8163.91),
    ('2021', '1.0', 2022, 'T6 Public Class 4', 'Dsl', 9930.23),
    ('2021', '1.0', 2022, 'T6 Public Class 4', 'NG', 49.0564),
    ('2021', '1.0', 2022, 'T6 Public Class 5', 'Dsl', 21982.5),
    ('2021', '1.0', 2022, 'T6 Public Class 5', 'NG', 282.691),
    ('2021', '1.0', 2022, 'T6 Public Class 6', 'Dsl', 14875.2),
    ('2021', '1.0', 2022, 'T6 Public Class 6', 'NG', 83.5287),
    ('2021', '1.0', 2022, 'T6 Public Class 7', 'Dsl', 33046.6),
    ('2021', '1.0', 2022, 'T6 Public Class 7', 'NG', 252.163),
    ('2021', '1.0', 2022, 'T6 Utility Class 5', 'Dsl', 8281.89),
    ('2021', '1.0', 2022, 'T6 Utility Class 6', 'Dsl', 1988.52),
    ('2021', '1.0', 2022, 'T6 Utility Class 7', 'Dsl', 2412.85),
    ('2021', '1.0', 2022, 'T6TS', 'Gas', 192778),
    ('2021', '1.0', 2022, 'T7 CAIRP Class 8', 'Dsl', 408728),
    ('2021', '1.0', 2022, 'T7 CAIRP Class 8', 'NG', 369.53),
    ('2021', '1.0', 2022, 'T7 NNOOS Class 8', 'Dsl', 483679),
    ('2021', '1.0', 2022, 'T7 NOOS Class 8', 'Dsl', 175712),
    ('2021', '1.0', 2022, 'T7 Other Port Class 8', 'Dsl', 92967.1),
    ('2021', '1.0', 2022, 'T7 POLA Class 8', 'Dsl', 29021.3),
    ('2021', '1.0', 2022, 'T7 Public Class 8', 'Dsl', 65100.3),
    ('2021', '1.0', 2022, 'T7 Public Class 8', 'NG', 357.801),
    ('2021', '1.0', 2022, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 24686.8),
    ('2021', '1.0', 2022, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 2197.51),
    ('2021', '1.0', 2022, 'T7 Single Dump Class 8', 'Dsl', 49688.3),
    ('2021', '1.0', 2022, 'T7 Single Dump Class 8', 'NG', 3892.54),
    ('2021', '1.0', 2022, 'T7 Single Other Class 8', 'Dsl', 89110.8),
    ('2021', '1.0', 2022, 'T7 Single Other Class 8', 'NG', 7042.6),
    ('2021', '1.0', 2022, 'T7 SWCV Class 8', 'Dsl', 44044.1),
    ('2021', '1.0', 2022, 'T7 SWCV Class 8', 'NG', 42768.3),
    ('2021', '1.0', 2022, 'T7 Tractor Class 8', 'Dsl', 307466),
    ('2021', '1.0', 2022, 'T7 Tractor Class 8', 'NG', 4829.09),
    ('2021', '1.0', 2022, 'T7 Utility Class 8', 'Dsl', 6539.48),
    ('2021', '1.0', 2022, 'T7IS', 'Gas', 577.747),
    ('2021', '1.0', 2022, 'UBUS', 'Gas', 12626.8),
    ('2021', '1.0', 2022, 'UBUS', 'NG', 105237),
    ('2021', '1.0', 2023, 'All Other Buses', 'Dsl', 24220.7),
    ('2021', '1.0', 2026, 'LDA', 'Dsl', 137704),
    ('2021', '1.0', 2026, 'LDA', 'Elec', 3.95977e+006),
    ('2021', '1.0', 2026, 'LDA', 'Phe', 1.77177e+006),
    ('2021', '1.0', 2026, 'LDT1', 'Gas', 4.1656e+006),
    ('2021', '1.0', 2026, 'LDT1', 'Dsl', 661.827),
    ('2021', '1.0', 2026, 'LDT1', 'Elec', 17688.2),
    ('2021', '1.0', 2026, 'LDT1', 'Phe', 13025.1),
    ('2021', '1.0', 2026, 'LDT2', 'Gas', 2.26849e+007),
    ('2021', '1.0', 2026, 'LDT2', 'Dsl', 89302.4),
    ('2021', '1.0', 2026, 'LDT2', 'Elec', 184924),
    ('2021', '1.0', 2026, 'LDT2', 'Phe', 264862),
    ('2021', '1.0', 2026, 'LHD1', 'Gas', 1.6686e+006),
    ('2021', '1.0', 2026, 'LHD1', 'Dsl', 1.2066e+006),
    ('2021', '1.0', 2026, 'LHD1', 'Elec', 53715.6),
    ('2021', '1.0', 2026, 'LHD2', 'Gas', 230603),
    ('2021', '1.0', 2026, 'LHD2', 'Dsl', 502331),
    ('2021', '1.0', 2026, 'LHD2', 'Elec', 13217.3),
    ('2021', '1.0', 2026, 'MCY', 'Gas', 421049),
    ('2021', '1.0', 2026, 'MDV', 'Gas', 1.31917e+007),
    ('2021', '1.0', 2026, 'MDV', 'Dsl', 220738),
    ('2021', '1.0', 2026, 'MDV', 'Elec', 198662),
    ('2021', '1.0', 2026, 'MDV', 'Phe', 169869),
    ('2021', '1.0', 2026, 'MH', 'Gas', 83714.9),
    ('2021', '1.0', 2026, 'MH', 'Dsl', 38352.8),
    ('2021', '1.0', 2026, 'Motor Coach', 'Dsl', 23220.7),
    ('2021', '1.0', 2026, 'OBUS', 'Gas', 51596.6),
    ('2021', '1.0', 2026, 'OBUS', 'Elec', 882.658),
    ('2021', '1.0', 2026, 'PTO', 'Dsl', 35912.9),
    ('2021', '1.0', 2026, 'PTO', 'Elec', 751.89),
    ('2021', '1.0', 2026, 'SBUS', 'Gas', 15865.5),
    ('2021', '1.0', 2026, 'SBUS', 'Dsl', 44841.9),
    ('2021', '1.0', 2026, 'SBUS', 'Elec', 836.2),
    ('2021', '1.0', 2026, 'SBUS', 'NG', 517.858),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 4', 'Dsl', 561.727),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 4', 'Elec', 14.6804),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 5', 'Dsl', 772.518),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 5', 'Elec', 18.2097),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 6', 'Dsl', 1998.76),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 6', 'Elec', 67.4359),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 7', 'Dsl', 12735.2),
    ('2021', '1.0', 2026, 'T6 CAIRP Class 7', 'Elec', 224.966),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 4', 'Dsl', 30974.2),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 4', 'Elec', 555.764),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 4', 'NG', 570.329),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 5', 'Dsl', 23398.5),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 5', 'Elec', 383.057),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 5', 'NG', 574.732),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 6', 'Dsl', 69959.8),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 6', 'Elec', 1165.56),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 6', 'NG', 1520),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 7', 'Dsl', 27957.2),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 7', 'Elec', 151.354),
    ('2021', '1.0', 2026, 'T6 Instate Delivery Class 7', 'NG', 262.187),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 4', 'Dsl', 80557.2),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 4', 'Elec', 1540.44),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 4', 'NG', 1566.41),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 5', 'Dsl', 151525),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 5', 'Elec', 2422.81),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 5', 'NG', 4106.59),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 6', 'Dsl', 149006),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 6', 'Elec', 2415.89),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 6', 'NG', 4310.89),
    ('2021', '1.0', 2026, 'T6 Instate Other Class 7', 'Dsl', 74305.9),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 5', 'NG', 3852.94),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 6', 'Dsl', 146321),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 6', 'Elec', 11066.4),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 6', 'NG', 4022.32),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 7', 'Dsl', 73976.8),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 7', 'Elec', 4256.99),
    ('2021', '1.0', 2029, 'T6 Instate Other Class 7', 'NG', 556.991),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 6', 'Dsl', 863.594),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 6', 'Elec', 79.0747),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 6', 'NG', 20.1061),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 7', 'Dsl', 28300.1),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 7', 'Elec', 775.112),
    ('2021', '1.0', 2029, 'T6 Instate Tractor Class 7', 'NG', 164.139),
    ('2021', '1.0', 2029, 'T6 OOS Class 4', 'Dsl', 340.513),
    ('2021', '1.0', 2029, 'T6 OOS Class 5', 'Dsl', 467.123),
    ('2021', '1.0', 2029, 'T6 OOS Class 6', 'Dsl', 1220.6),
    ('2021', '1.0', 2029, 'T6 OOS Class 7', 'Dsl', 8875.31),
    ('2021', '1.0', 2029, 'T6 Public Class 4', 'Dsl', 9609.78),
    ('2021', '1.0', 2029, 'T6 Public Class 4', 'Elec', 624.276),
    ('2021', '1.0', 2029, 'T6 Public Class 4', 'NG', 89.7058),
    ('2021', '1.0', 2029, 'T6 Public Class 5', 'Dsl', 21415.4),
    ('2021', '1.0', 2029, 'T6 Public Class 5', 'Elec', 1308.19),
    ('2021', '1.0', 2029, 'T6 Public Class 5', 'NG', 310.247),
    ('2021', '1.0', 2029, 'T6 Public Class 6', 'Dsl', 14399.2),
    ('2021', '1.0', 2029, 'T6 Public Class 6', 'Elec', 936.198),
    ('2021', '1.0', 2029, 'T6 Public Class 6', 'NG', 139.688),
    ('2021', '1.0', 2029, 'T6 Public Class 7', 'Dsl', 31700),
    ('2021', '1.0', 2029, 'T6 Public Class 7', 'Elec', 2396.27),
    ('2021', '1.0', 2029, 'T6 Public Class 7', 'NG', 351.906),
    ('2021', '1.0', 2029, 'T6 Utility Class 5', 'Dsl', 7654.66),
    ('2021', '1.0', 2029, 'T6 Utility Class 5', 'Elec', 913.115),
    ('2021', '1.0', 2029, 'T6 Utility Class 6', 'Dsl', 1836.02),
    ('2021', '1.0', 2029, 'T6 Utility Class 6', 'Elec', 221.15),
    ('2021', '1.0', 2029, 'T6 Utility Class 7', 'Dsl', 2200.26),
    ('2021', '1.0', 2029, 'T6 Utility Class 7', 'Elec', 295.87),
    ('2021', '1.0', 2029, 'T6TS', 'Gas', 190418),
    ('2021', '1.0', 2029, 'T6TS', 'Elec', 16889),
    ('2021', '1.0', 2029, 'T7 CAIRP Class 8', 'Dsl', 427698),
    ('2021', '1.0', 2029, 'T7 CAIRP Class 8', 'Elec', 28907.8),
    ('2021', '1.0', 2029, 'T7 CAIRP Class 8', 'NG', 412.219),
    ('2021', '1.0', 2029, 'T7 NNOOS Class 8', 'Dsl', 540336),
    ('2021', '1.0', 2029, 'T7 NOOS Class 8', 'Dsl', 196295),
    ('2021', '1.0', 2029, 'T7 Other Port Class 8', 'Dsl', 114935),
    ('2021', '1.0', 2029, 'T7 Other Port Class 8', 'Elec', 5426.47),
    ('2021', '1.0', 2029, 'T7 POLA Class 8', 'Dsl', 37797.2),
    ('2021', '1.0', 2029, 'T7 POLA Class 8', 'Elec', 481.58),
    ('2021', '1.0', 2029, 'T7 Public Class 8', 'Dsl', 63350.7),
    ('2021', '1.0', 2029, 'T7 Public Class 8', 'Elec', 3921.1),
    ('2021', '1.0', 2029, 'T7 Public Class 8', 'NG', 445.804),
    ('2021', '1.0', 2029, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 22795.4),
    ('2021', '1.0', 2029, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 3160.92),
    ('2021', '1.0', 2029, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1868.28),
    ('2021', '1.0', 2029, 'T7 Single Dump Class 8', 'Dsl', 47780.3),
    ('2021', '1.0', 2029, 'T7 Single Dump Class 8', 'Elec', 3818.05),
    ('2021', '1.0', 2029, 'T7 Single Dump Class 8', 'NG', 3856.27),
    ('2021', '1.0', 2029, 'T7 Single Other Class 8', 'Dsl', 92969.5),
    ('2021', '1.0', 2029, 'T7 Single Other Class 8', 'Elec', 7062.17),
    ('2021', '1.0', 2029, 'T7 Single Other Class 8', 'NG', 7384.81),
    ('2021', '1.0', 2029, 'T7 SWCV Class 8', 'Dsl', 23074.2),
    ('2021', '1.0', 2029, 'T7 SWCV Class 8', 'Elec', 3717.35),
    ('2021', '1.0', 2029, 'T7 SWCV Class 8', 'NG', 63017.5),
    ('2021', '1.0', 2029, 'T7 Tractor Class 8', 'Dsl', 332662),
    ('2021', '1.0', 2030, 'T7 Single Other Class 8', 'NG', 7268.39),
    ('2021', '1.0', 2030, 'T7 SWCV Class 8', 'Dsl', 20693),
    ('2021', '1.0', 2030, 'T7 SWCV Class 8', 'Elec', 5292.96),
    ('2021', '1.0', 2030, 'T7 SWCV Class 8', 'NG', 64216.6),
    ('2021', '1.0', 2030, 'T7 Tractor Class 8', 'Dsl', 334445),
    ('2021', '1.0', 2030, 'T7 Tractor Class 8', 'Elec', 15207.6),
    ('2021', '1.0', 2030, 'T7 Tractor Class 8', 'NG', 4788.05),
    ('2021', '1.0', 2030, 'T7 Utility Class 8', 'Dsl', 6249.71),
    ('2021', '1.0', 2030, 'T7 Utility Class 8', 'Elec', 545.15),
    ('2021', '1.0', 2030, 'T7IS', 'Gas', 487.826),
    ('2021', '1.0', 2030, 'T7IS', 'Elec', 66.356),
    ('2021', '1.0', 2030, 'UBUS', 'Gas', 16333.2),
    ('2021', '1.0', 2030, 'UBUS', 'Elec', 39331.7),
    ('2021', '1.0', 2030, 'UBUS', 'NG', 97240.4),
    ('2021', '1.0', 2032, 'All Other Buses', 'Dsl', 26075.3),
    ('2021', '1.0', 2032, 'All Other Buses', 'NG', 5232.99),
    ('2021', '1.0', 2032, 'LDA', 'Gas', 4.61724e+007),
    ('2021', '1.0', 2032, 'LDA', 'Dsl', 63650.7),
    ('2021', '1.0', 2032, 'LDA', 'Elec', 5.6077e+006),
    ('2021', '1.0', 2032, 'LDA', 'Phe', 2.11163e+006),
    ('2021', '1.0', 2032, 'LDT1', 'Gas', 3.5821e+006),
    ('2021', '1.0', 2032, 'LDT1', 'Dsl', 25.5617),
    ('2021', '1.0', 2032, 'LDT1', 'Elec', 51498.9),
    ('2021', '1.0', 2032, 'LDT1', 'Phe', 38307.5),
    ('2021', '1.0', 2032, 'LDT2', 'Gas', 2.32481e+007),
    ('2021', '1.0', 2032, 'LDT2', 'Dsl', 89579.7),
    ('2021', '1.0', 2032, 'LDT2', 'Elec', 430489),
    ('2021', '1.0', 2032, 'LDT2', 'Phe', 461709),
    ('2021', '1.0', 2032, 'LHD1', 'Gas', 1.52733e+006),
    ('2021', '1.0', 2032, 'LHD1', 'Dsl', 1.13102e+006),
    ('2021', '1.0', 2032, 'LHD1', 'Elec', 428332),
    ('2021', '1.0', 2032, 'LHD2', 'Gas', 209189),
    ('2021', '1.0', 2032, 'LHD2', 'Dsl', 500247),
    ('2021', '1.0', 2032, 'LHD2', 'Elec', 107393),
    ('2021', '1.0', 2032, 'MCY', 'Gas', 404607),
    ('2021', '1.0', 2032, 'MDV', 'Gas', 1.33906e+007),
    ('2021', '1.0', 2032, 'MDV', 'Dsl', 182110),
    ('2021', '1.0', 2032, 'MDV', 'Elec', 413154),
    ('2021', '1.0', 2032, 'MDV', 'Phe', 292936),
    ('2021', '1.0', 2032, 'MH', 'Gas', 64574.1),
    ('2021', '1.0', 2032, 'MH', 'Dsl', 34901.7),
    ('2021', '1.0', 2032, 'Motor Coach', 'Dsl', 23999.2),
    ('2021', '1.0', 2032, 'OBUS', 'Gas', 37141.1),
    ('2021', '1.0', 2032, 'OBUS', 'Elec', 7318.84),
    ('2021', '1.0', 2032, 'PTO', 'Dsl', 33646.8),
    ('2021', '1.0', 2032, 'PTO', 'Elec', 6371.13),
    ('2021', '1.0', 2032, 'SBUS', 'Gas', 17319.1),
    ('2021', '1.0', 2032, 'SBUS', 'Dsl', 39401.4),
    ('2021', '1.0', 2032, 'SBUS', 'Elec', 8196.88),
    ('2021', '1.0', 2032, 'SBUS', 'NG', 643.192),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 4', 'Dsl', 490.544),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 4', 'Elec', 136.67),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 5', 'Dsl', 679.003),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 5', 'Elec', 181.421),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 6', 'Dsl', 1725.31),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 6', 'Elec', 523.008),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 7', 'Dsl', 12397.3),
    ('2021', '1.0', 2032, 'T6 CAIRP Class 7', 'Elec', 1705.25),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 4', 'Dsl', 28808.3),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 4', 'Elec', 5574.93),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 4', 'NG', 546.499),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 5', 'Dsl', 21885),
    ('2021', '1.0', 2032, 'T6 Instate Delivery Class 5', 'Elec', 4117.37),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 4', 'Dsl', 26557.5),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 4', 'Elec', 9848.84),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 4', 'NG', 501.848),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 5', 'Dsl', 20177.4),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 5', 'Elec', 7384.54),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 5', 'NG', 442.338),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 6', 'Dsl', 60173.9),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 6', 'Elec', 22118.1),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 6', 'NG', 1233.95),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 7', 'Dsl', 28084.1),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 7', 'Elec', 4263.56),
    ('2021', '1.0', 2035, 'T6 Instate Delivery Class 7', 'NG', 272.32),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 4', 'Dsl', 67418),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 4', 'Elec', 27482.7),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 4', 'NG', 1294.34),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 5', 'Dsl', 127068),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 5', 'Elec', 51840.3),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 5', 'NG', 2819.01),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 6', 'Dsl', 125399),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 6', 'Elec', 50765.9),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 6', 'NG', 2892.64),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 7', 'Dsl', 67568.2),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 7', 'Elec', 19298.6),
    ('2021', '1.0', 2035, 'T6 Instate Other Class 7', 'NG', 538.564),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 6', 'Dsl', 741.043),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 6', 'Elec', 311.969),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 6', 'NG', 15.0271),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 7', 'Dsl', 29004.9),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 7', 'Elec', 3245.77),
    ('2021', '1.0', 2035, 'T6 Instate Tractor Class 7', 'NG', 185.546),
    ('2021', '1.0', 2035, 'T6 OOS Class 4', 'Dsl', 377.743),
    ('2021', '1.0', 2035, 'T6 OOS Class 5', 'Dsl', 518.195),
    ('2021', '1.0', 2035, 'T6 OOS Class 6', 'Dsl', 1354.06),
    ('2021', '1.0', 2035, 'T6 OOS Class 7', 'Dsl', 9845.69),
    ('2021', '1.0', 2035, 'T6 Public Class 4', 'Dsl', 8216),
    ('2021', '1.0', 2035, 'T6 Public Class 4', 'Elec', 2262.98),
    ('2021', '1.0', 2035, 'T6 Public Class 4', 'NG', 90.9376),
    ('2021', '1.0', 2035, 'T6 Public Class 5', 'Dsl', 18100.4),
    ('2021', '1.0', 2035, 'T6 Public Class 5', 'Elec', 5226.64),
    ('2021', '1.0', 2035, 'T6 Public Class 5', 'NG', 256.01),
    ('2021', '1.0', 2035, 'T6 Public Class 6', 'Dsl', 12284.8),
    ('2021', '1.0', 2035, 'T6 Public Class 6', 'Elec', 3420.75),
    ('2021', '1.0', 2035, 'T6 Public Class 6', 'NG', 138.581),
    ('2021', '1.0', 2035, 'T6 Public Class 7', 'Dsl', 27038),
    ('2021', '1.0', 2035, 'T6 Public Class 7', 'Elec', 7894.08),
    ('2021', '1.0', 2035, 'T6 Public Class 7', 'NG', 337.546),
    ('2021', '1.0', 2035, 'T6 Utility Class 5', 'Dsl', 5596.31),
    ('2021', '1.0', 2035, 'T6 Utility Class 5', 'Elec', 3175.76),
    ('2021', '1.0', 2035, 'T6 Utility Class 6', 'Dsl', 1344.61),
    ('2021', '1.0', 2035, 'T6 Utility Class 6', 'Elec', 761.609),
    ('2021', '1.0', 2035, 'T6 Utility Class 7', 'Dsl', 1559.66),
    ('2021', '1.0', 2035, 'T6 Utility Class 7', 'Elec', 995.996),
    ('2021', '1.0', 2035, 'T6TS', 'Gas', 154954),
    ('2021', '1.0', 2035, 'T6TS', 'Elec', 63565.6),
    ('2021', '1.0', 2035, 'T7 CAIRP Class 8', 'Dsl', 456146),
    ('2021', '1.0', 2035, 'T7 CAIRP Class 8', 'Elec', 97204),
    ('2021', '1.0', 2035, 'T7 CAIRP Class 8', 'NG', 395.714),
    ('2021', '1.0', 2035, 'T7 NNOOS Class 8', 'Dsl', 654698),
    ('2021', '1.0', 2035, 'T7 NOOS Class 8', 'Dsl', 237840),
    ('2021', '1.0', 2035, 'T7 Other Port Class 8', 'Dsl', 126582),
    ('2021', '1.0', 2035, 'T7 Other Port Class 8', 'Elec', 23056),
    ('2021', '1.0', 2035, 'T7 POLA Class 8', 'Dsl', 45017.4),
    ('2021', '1.0', 2035, 'T7 POLA Class 8', 'Elec', 3206.81),
    ('2021', '1.0', 2035, 'T7 Public Class 8', 'Dsl', 54669.6),
    ('2021', '1.0', 2035, 'T7 Public Class 8', 'Elec', 14223.5),
    ('2021', '1.0', 2040, 'T7 POLA Class 8', 'Dsl', 42521.1),
    ('2021', '1.0', 2040, 'T7 POLA Class 8', 'Elec', 5703.12),
    ('2021', '1.0', 2040, 'T7 Public Class 8', 'Dsl', 48391.6),
    ('2021', '1.0', 2040, 'T7 Public Class 8', 'Elec', 21629.9),
    ('2021', '1.0', 2040, 'T7 Public Class 8', 'NG', 411.682),
    ('2021', '1.0', 2040, 'T7 Single Concrete/Transit Mix Class 8', 'Dsl', 13314.3),
    ('2021', '1.0', 2040, 'T7 Single Concrete/Transit Mix Class 8', 'Elec', 14942.6),
    ('2021', '1.0', 2040, 'T7 Single Concrete/Transit Mix Class 8', 'NG', 1017.94),
    ('2021', '1.0', 2040, 'T7 Single Dump Class 8', 'Dsl', 34588.5),
    ('2021', '1.0', 2040, 'T7 Single Dump Class 8', 'Elec', 21063),
    ('2021', '1.0', 2040, 'T7 Single Dump Class 8', 'NG', 2693.64),
    ('2021', '1.0', 2040, 'T7 Single Other Class 8', 'Dsl', 86886.7),
    ('2021', '1.0', 2040, 'T7 Single Other Class 8', 'Elec', 61629.3),
    ('2021', '1.0', 2040, 'T7 Single Other Class 8', 'NG', 6705.79),
    ('2021', '1.0', 2040, 'T7 SWCV Class 8', 'Dsl', 7752.56),
    ('2021', '1.0', 2040, 'T7 SWCV Class 8', 'Elec', 26914.9),
    ('2021', '1.0', 2040, 'T7 SWCV Class 8', 'NG', 58743),
    ('2021', '1.0', 2040, 'T7 Tractor Class 8', 'Dsl', 427671),
    ('2021', '1.0', 2040, 'T7 Tractor Class 8', 'Elec', 70622.7),
    ('2021', '1.0', 2040, 'T7 Tractor Class 8', 'NG', 5848.47),
    ('2021', '1.0', 2040, 'T7 Utility Class 8', 'Dsl', 4598.52),
    ('2021', '1.0', 2040, 'T7 Utility Class 8', 'Elec', 2437.99),
    ('2021', '1.0', 2040, 'T7IS', 'Gas', 422.884),
    ('2021', '1.0', 2040, 'T7IS', 'Elec', 307.16),
    ('2021', '1.0', 2040, 'UBUS', 'Gas', 20267.1),
    ('2021', '1.0', 2040, 'UBUS', 'Elec', 149104),
    ('2021', '1.0', 2040, 'UBUS', 'NG', 27336),
    ('2021', '1.0', 2045, 'All Other Buses', 'Dsl', 27309.1),
    ('2021', '1.0', 2045, 'All Other Buses', 'NG', 5247.72),
    ('2021', '1.0', 2045, 'LDA', 'Gas', 4.73951e+007),
    ('2021', '1.0', 2045, 'LDA', 'Dsl', 28914.1),
    ('2021', '1.0', 2045, 'LDA', 'Elec', 6.88334e+006),
    ('2021', '1.0', 2045, 'LDA', 'Phe', 2.26361e+006),
    ('2021', '1.0', 2045, 'LDT1', 'Gas', 3.09002e+006),
    ('2021', '1.0', 2045, 'LDT1', 'Dsl', 35.131),
    ('2021', '1.0', 2045, 'LDT1', 'Elec', 98001.2),
    ('2021', '1.0', 2045, 'LDT1', 'Phe', 71551.6),
    ('2021', '1.0', 2045, 'LDT2', 'Gas', 2.37786e+007),
    ('2021', '1.0', 2045, 'LDT2', 'Dsl', 91120.5),
    ('2021', '1.0', 2045, 'LDT2', 'Elec', 699548),
    ('2021', '1.0', 2045, 'LDT2', 'Phe', 649593),
    ('2021', '1.0', 2045, 'LHD1', 'Gas', 1.03964e+006),
    ('2021', '1.0', 2045, 'LHD1', 'Dsl', 793406),
    ('2021', '1.0', 2045, 'LHD1', 'Elec', 1.47324e+006),
    ('2021', '1.0', 2045, 'LHD2', 'Gas', 141035),
    ('2021', '1.0', 2045, 'LHD2', 'Dsl', 372725),
    ('2021', '1.0', 2045, 'LHD2', 'Elec', 383122),
    ('2021', '1.0', 2045, 'MCY', 'Gas', 394965),
    ('2021', '1.0', 2045, 'MDV', 'Gas', 1.3779e+007),
    ('2021', '1.0', 2045, 'MDV', 'Dsl', 151680),
    ('2021', '1.0', 2045, 'MDV', 'Elec', 633512),
    ('2021', '1.0', 2045, 'MDV', 'Phe', 413101),
    ('2021', '1.0', 2045, 'MH', 'Gas', 49653.4),
    ('2021', '1.0', 2045, 'MH', 'Dsl', 29326.2),
    ('2021', '1.0', 2045, 'Motor Coach', 'Dsl', 25763),
    ('2021', '1.0', 2045, 'OBUS', 'Gas', 19590.2),
    ('2021', '1.0', 2045, 'OBUS', 'Elec', 21537),
    ('2021', '1.0', 2045, 'PTO', 'Dsl', 27785),
    ('2021', '1.0', 2045, 'PTO', 'Elec', 26777.7),
    ('2021', '1.0', 2045, 'SBUS', 'Gas', 14855.6),
    ('2021', '1.0', 2045, 'SBUS', 'Dsl', 26056.8),
    ('2021', '1.0', 2045, 'SBUS', 'Elec', 29396.6),
    ('2021', '1.0', 2050, 'SBUS', 'Gas', 13139.8),
    ('2021', '1.0', 2050, 'SBUS', 'Dsl', 21642.1),
    ('2021', '1.0', 2050, 'SBUS', 'Elec', 37036.6),
    ('2021', '1.0', 2050, 'SBUS', 'NG', 448.253),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 4', 'Dsl', 345.852),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 4', 'Elec', 527.078),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 5', 'Dsl', 474.735),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 5', 'Elec', 722.767),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 6', 'Dsl', 1238.61),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 6', 'Elec', 1890.5),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 7', 'Dsl', 14833.4),
    ('2021', '1.0', 2050, 'T6 CAIRP Class 7', 'Elec', 4793.93),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 4', 'Dsl', 20815.3),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 4', 'Elec', 27430.4),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 4', 'NG', 367.981),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 5', 'Dsl', 15777.4),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 5', 'Elec', 20825.2),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 5', 'NG', 283.276),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 6', 'Dsl', 47086.5),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 6', 'Elec', 62090.7),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 6', 'NG', 839.201),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 7', 'Dsl', 24537.1),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 7', 'Elec', 18211),
    ('2021', '1.0', 2050, 'T6 Instate Delivery Class 7', 'NG', 217.313),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 4', 'Dsl', 53152.3),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 4', 'Elec', 72613.7),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 4', 'NG', 937.48),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 5', 'Dsl', 100331),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 5', 'Elec', 137239),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 5', 'NG', 1792.82),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 6', 'Dsl', 98882.7),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 6', 'Elec', 135189),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 6', 'NG', 1774.77),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 7', 'Dsl', 61512),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 7', 'Elec', 53126.3),
    ('2021', '1.0', 2050, 'T6 Instate Other Class 7', 'NG', 487.985),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 6', 'Dsl', 584.681),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 6', 'Elec', 811.683),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 6', 'NG', 10.4074),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 7', 'Dsl', 33831.1),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 7', 'Elec', 8635.88),
    ('2021', '1.0', 2050, 'T6 Instate Tractor Class 7', 'NG', 256.579),
    ('2021', '1.0', 2050, 'T6 OOS Class 4', 'Dsl', 497.545),
    ('2021', '1.0', 2050, 'T6 OOS Class 5', 'Dsl', 682.542),
    ('2021', '1.0', 2050, 'T6 OOS Class 6', 'Dsl', 1783.5),
    ('2021', '1.0', 2050, 'T6 OOS Class 7', 'Dsl', 12968.3),
    ('2021', '1.0', 2050, 'T6 Public Class 4', 'Dsl', 5176.07),
    ('2021', '1.0', 2050, 'T6 Public Class 4', 'Elec', 5708.93),
    ('2021', '1.0', 2050, 'T6 Public Class 4', 'NG', 66.9558),
    ('2021', '1.0', 2050, 'T6 Public Class 5', 'Dsl', 11622),
    ('2021', '1.0', 2050, 'T6 Public Class 5', 'Elec', 12656.2),
    ('2021', '1.0', 2050, 'T6 Public Class 5', 'NG', 157.288),
    ('2021', '1.0', 2050, 'T6 Public Class 6', 'Dsl', 7802.79),
    ('2021', '1.0', 2050, 'T6 Public Class 6', 'Elec', 8513.41),
    ('2021', '1.0', 2050, 'T6 Public Class 6', 'NG', 100.575),
    ('2021', '1.0', 2050, 'T6 Public Class 7', 'Dsl', 19619.1),
    ('2021', '1.0', 2050, 'T6 Public Class 7', 'Elec', 16667.1),
    ('2021', '1.0', 2050, 'T6 Public Class 7', 'NG', 258.181),
    ('2021', '1.0', 2050, 'T6 Utility Class 5', 'Dsl', 3565.79),
    ('2021', '1.0', 2050, 'T6 Utility Class 5', 'Elec', 5523.34),
    ('2021', '1.0', 2050, 'T6 Utility Class 6', 'Dsl', 856.173),
    ('2021', '1.0', 2050, 'T6 Utility Class 6', 'Elec', 1326.17),
    ('2021', '1.0', 2050, 'T6 Utility Class 7', 'Dsl', 1028.32),
    ('2021', '1.0', 2050, 'T6 Utility Class 7', 'Elec', 1619.71),
    ('2021', '1.0', 2050, 'T6TS', 'Gas', 98058.4),
    ('2021', '1.0', 2050, 'T6TS', 'Elec', 133033)
GO

-- get the emfac vehicle class surrogate key
-- and insert into emfac_default_vmt table
INSERT INTO [emfac].[emfac_default_vmt] (
    [emfac_vehicle_class_id],
    [year],
    [vmt]
)
SELECT
	[emfac_vehicle_class_id]
	,[calendar_year] AS [year]
	,[vmt]
FROM
	#tt_emfac_default_vmt
LEFT OUTER JOIN -- if no matches a NULL value will return insert error
	[emfac].[emfac_vehicle_class]
ON
	#tt_emfac_default_vmt.[major_version] = [emfac_vehicle_class].[major_version]
	AND #tt_emfac_default_vmt.[minor_version] = [emfac_vehicle_class].[minor_version]
	AND CASE WHEN #tt_emfac_default_vmt.[major_version] = '2021'
             THEN CONCAT(#tt_emfac_default_vmt.[vehicle_class], '-', #tt_emfac_default_vmt.[fuel])
             ELSE CONCAT(#tt_emfac_default_vmt.[vehicle_class], ' - ', #tt_emfac_default_vmt.[fuel])
             END = [emfac_vehicle_class].[emfac_vehicle_class]

-- drop temporary emfac_default_vmt table
DROP TABLE #tt_emfac_default_vmt
GO

-- add metadata for [emfac].[emfac_default_vmt]
EXECUTE [db_meta].[add_xp] 'emfac.emfac_default_vmt', 'MS_Description', 'default emfac run vmt'
GO




-- create emfac vehicle map reference table ----------------------------------
DROP TABLE IF EXISTS [emfac].[emfac_vehicle_map]
GO

CREATE TABLE [emfac].[emfac_vehicle_map](
	[emfac_vehicle_map_id] int IDENTITY(1,1) NOT NULL,
	[sandag_vehicle_class_id] tinyint NOT NULL,
	[emfac_vehicle_class_id] smallint NOT NULL,
	CONSTRAINT [pk_emfac_vehicle_map]
        PRIMARY KEY ([emfac_vehicle_map_id]),
	CONSTRAINT [ixuq_emfac_vehicle_map]
        UNIQUE ([sandag_vehicle_class_id],[emfac_vehicle_class_id])
        WITH (DATA_COMPRESSION = PAGE),
	CONSTRAINT [fk_emfac_vehicle_map_emfac_vehicle_class]
        FOREIGN KEY ([emfac_vehicle_class_id])
        REFERENCES [emfac].[emfac_vehicle_class] ([emfac_vehicle_class_id]),
	CONSTRAINT [fk_emfac_vehicle_map_sandag_vehicle_class]
        FOREIGN KEY ([sandag_vehicle_class_id])
        REFERENCES [emfac].[sandag_vehicle_class] ([sandag_vehicle_class_id])
	)
WITH
	(DATA_COMPRESSION = PAGE)
GO

-- create temporary table to hold sandag to emfac vehicle class map
-- and insert values
CREATE TABLE #tt_emfac_vehicle_map (
	[sandag_vehicle_class] varchar(50) NOT NULL,
	[emfac_vehicle_class] varchar(50) NOT NULL,
	[major_version] varchar(5) NOT NULL,
	[minor_version] varchar(5) NOT NULL,
	CONSTRAINT pk_tt_emfac_vehicle_map
        PRIMARY KEY ([sandag_vehicle_class], [emfac_vehicle_class], [major_version], [minor_version]))
INSERT INTO #tt_emfac_vehicle_map VALUES
	('Drive Alone', 'LDA - Dsl', '2014', '1.0'),
	('Drive Alone', 'LDA - Elec', '2014', '1.0'),
	('Drive Alone', 'LDA - Gas', '2014', '1.0'),
	('Drive Alone', 'LDT1 - Dsl', '2014', '1.0'),
	('Drive Alone', 'LDT1 - Elec', '2014', '1.0'),
	('Drive Alone', 'LDT1 - Gas', '2014', '1.0'),
	('Drive Alone', 'LDT2 - Dsl', '2014', '1.0'),
	('Drive Alone', 'LDT2 - Gas', '2014', '1.0'),
	('Drive Alone', 'MCY - Gas', '2014', '1.0'),
	('Drive Alone', 'MDV - Dsl', '2014', '1.0'),
	('Drive Alone', 'MDV - Gas', '2014', '1.0'),
	('Drive Alone', 'MH - Dsl', '2014', '1.0'),
	('Drive Alone', 'MH - Gas', '2014', '1.0'),
	('Shared Ride 2', 'LDA - Dsl', '2014', '1.0'),
	('Shared Ride 2', 'LDA - Elec', '2014', '1.0'),
	('Shared Ride 2', 'LDA - Gas', '2014', '1.0'),
	('Shared Ride 2', 'LDT1 - Dsl', '2014', '1.0'),
	('Shared Ride 2', 'LDT1 - Elec', '2014', '1.0'),
	('Shared Ride 2', 'LDT1 - Gas', '2014', '1.0'),
	('Shared Ride 2', 'LDT2 - Dsl', '2014', '1.0'),
	('Shared Ride 2', 'LDT2 - Gas', '2014', '1.0'),
	('Shared Ride 2', 'MCY - Gas', '2014', '1.0'),
	('Shared Ride 2', 'MDV - Dsl', '2014', '1.0'),
	('Shared Ride 2', 'MDV - Gas', '2014', '1.0'),
	('Shared Ride 2', 'MH - Dsl', '2014', '1.0'),
	('Shared Ride 2', 'MH - Gas', '2014', '1.0'),
	('Shared Ride 3+', 'LDA - Dsl', '2014', '1.0'),
	('Shared Ride 3+', 'LDA - Elec', '2014', '1.0'),
	('Shared Ride 3+', 'LDA - Gas', '2014', '1.0'),
	('Shared Ride 3+', 'LDT1 - Dsl', '2014', '1.0'),
	('Shared Ride 3+', 'LDT1 - Elec', '2014', '1.0'),
	('Shared Ride 3+', 'LDT1 - Gas', '2014', '1.0'),
	('Shared Ride 3+', 'LDT2 - Dsl', '2014', '1.0'),
	('Shared Ride 3+', 'LDT2 - Gas', '2014', '1.0'),
	--('Shared Ride 3+', 'MCY - Gas', '2014', '1.0'),
	('Shared Ride 3+', 'MDV - Dsl', '2014', '1.0'),
	('Shared Ride 3+', 'MDV - Gas', '2014', '1.0'),
	('Shared Ride 3+', 'MH - Dsl', '2014', '1.0'),
	('Shared Ride 3+', 'MH - Gas', '2014', '1.0'),
	('Light Heavy Duty Truck', 'LHD1 - Dsl', '2014', '1.0'),
	('Light Heavy Duty Truck', 'LHD1 - Gas', '2014', '1.0'),
	('Light Heavy Duty Truck', 'LHD2 - Dsl', '2014', '1.0'),
	('Light Heavy Duty Truck', 'LHD2 - Gas', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Ag - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 CAIRP Heavy - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 CAIRP Small - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Construction Heavy - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Construction Small - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Heavy - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Small - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 OOS Heavy - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 OOS Small - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Public - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Utility - Dsl', '2014', '1.0'),
	('Medium Heavy Duty Truck', 'T6TS - Gas', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Ag - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 CAIRP - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 CAIRP Construction - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 NNOOS - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 NOOS - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Other Port - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 POLA - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Public - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Single - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Single Construction - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 SWCV - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Tractor - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Tractor Construction - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Utility - Dsl', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'T7IS - Gas', '2014', '1.0'),
	('Heavy Heavy Duty Truck', 'PTO - Dsl', '2014', '1.0'),
	('Highway Network Preload - Bus', 'UBUS - Dsl', '2014', '1.0'),
	('Highway Network Preload - Bus', 'UBUS - Gas', '2014', '1.0'),
	('Drive Alone', 'LDA - Dsl', '2017', '1.0'),
	('Drive Alone', 'LDA - Elec', '2017', '1.0'),
	('Drive Alone', 'LDA - Gas', '2017', '1.0'),
	('Drive Alone', 'LDT1 - Dsl', '2017', '1.0'),
	('Drive Alone', 'LDT1 - Elec', '2017', '1.0'),
	('Drive Alone', 'LDT1 - Gas', '2017', '1.0'),
	('Drive Alone', 'LDT2 - Dsl', '2017', '1.0'),
	('Drive Alone', 'LDT2 - Elec', '2017', '1.0'),
	('Drive Alone', 'LDT2 - Gas', '2017', '1.0'),
	('Drive Alone', 'MCY - Gas', '2017', '1.0'),
	('Drive Alone', 'MDV - Dsl', '2017', '1.0'),
	('Drive Alone', 'MDV - Elec', '2017', '1.0'),
	('Drive Alone', 'MDV - Gas', '2017', '1.0'),
	('Drive Alone', 'MH - Dsl', '2017', '1.0'),
	('Drive Alone', 'MH - Gas', '2017', '1.0'),
	('Shared Ride 2', 'LDA - Dsl', '2017', '1.0'),
	('Shared Ride 2', 'LDA - Elec', '2017', '1.0'),
	('Shared Ride 2', 'LDA - Gas', '2017', '1.0'),
	('Shared Ride 2', 'LDT1 - Dsl', '2017', '1.0'),
	('Shared Ride 2', 'LDT1 - Elec', '2017', '1.0'),
	('Shared Ride 2', 'LDT1 - Gas', '2017', '1.0'),
	('Shared Ride 2', 'LDT2 - Dsl', '2017', '1.0'),
	('Shared Ride 2', 'LDT2 - Elec', '2017', '1.0'),
	('Shared Ride 2', 'LDT2 - Gas', '2017', '1.0'),
	('Shared Ride 2', 'MCY - Gas', '2017', '1.0'),
	('Shared Ride 2', 'MDV - Dsl', '2017', '1.0'),
	('Shared Ride 2', 'MDV - Elec', '2017', '1.0'),
	('Shared Ride 2', 'MDV - Gas', '2017', '1.0'),
	('Shared Ride 2', 'MH - Dsl', '2017', '1.0'),
	('Shared Ride 2', 'MH - Gas', '2017', '1.0'),
	('Shared Ride 3+', 'LDA - Dsl', '2017', '1.0'),
	('Shared Ride 3+', 'LDA - Elec', '2017', '1.0'),
	('Shared Ride 3+', 'LDA - Gas', '2017', '1.0'),
	('Shared Ride 3+', 'LDT1 - Dsl', '2017', '1.0'),
	('Shared Ride 3+', 'LDT1 - Elec', '2017', '1.0'),
	('Shared Ride 3+', 'LDT1 - Gas', '2017', '1.0'),
	('Shared Ride 3+', 'LDT2 - Dsl', '2017', '1.0'),
	('Shared Ride 3+', 'LDT2 - Elec', '2017', '1.0'),
	('Shared Ride 3+', 'LDT2 - Gas', '2017', '1.0'),
	--('Shared Ride 3+', 'MCY - Gas', '2017', '1.0'),
	('Shared Ride 3+', 'MDV - Dsl', '2017', '1.0'),
	('Shared Ride 3+', 'MDV - Elec', '2017', '1.0'),
	('Shared Ride 3+', 'MDV - Gas', '2017', '1.0'),
	('Shared Ride 3+', 'MH - Dsl', '2017', '1.0'),
	('Shared Ride 3+', 'MH - Gas', '2017', '1.0'),
	('Light Heavy Duty Truck', 'LHD1 - Dsl', '2017', '1.0'),
	('Light Heavy Duty Truck', 'LHD1 - Gas', '2017', '1.0'),
	('Light Heavy Duty Truck', 'LHD2 - Dsl', '2017', '1.0'),
	('Light Heavy Duty Truck', 'LHD2 - Gas', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Ag - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 CAIRP Heavy - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 CAIRP Small - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Construction Heavy - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Construction Small - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Heavy - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Instate Small - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 OOS Heavy - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 OOS Small - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Public - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6 Utility - Dsl', '2017', '1.0'),
	('Medium Heavy Duty Truck', 'T6TS - Gas', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Ag - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 CAIRP - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 CAIRP Construction - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 NNOOS - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 NOOS - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Other Port - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 POLA - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Public - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Single - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Single Construction - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 SWCV - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 SWCV - NG', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Tractor - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Tractor Construction - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7 Utility - Dsl', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'T7IS - Gas', '2017', '1.0'),
	('Heavy Heavy Duty Truck', 'PTO - Dsl', '2017', '1.0'),
	('Highway Network Preload - Bus', 'UBUS - Dsl', '2017', '1.0'),
	('Highway Network Preload - Bus', 'UBUS - Gas', '2017', '1.0'),
	('Highway Network Preload - Bus', 'UBUS - NG', '2017', '1.0'),
    ('Drive Alone', 'LDA-Dsl', '2021', '1.0'),
    ('Drive Alone', 'LDA-Elec', '2021', '1.0'),
    ('Drive Alone', 'LDA-Gas', '2021', '1.0'),
    ('Drive Alone', 'LDA-Phe', '2021', '1.0'),
    ('Drive Alone', 'LDT1-Dsl', '2021', '1.0'),
    ('Drive Alone', 'LDT1-Elec', '2021', '1.0'),
    ('Drive Alone', 'LDT1-Gas', '2021', '1.0'),
    ('Drive Alone', 'LDT1-Phe', '2021', '1.0'),
    ('Drive Alone', 'LDT2-Dsl', '2021', '1.0'),
    ('Drive Alone', 'LDT2-Elec', '2021', '1.0'),
    ('Drive Alone', 'LDT2-Gas', '2021', '1.0'),
    ('Drive Alone', 'LDT2-Phe', '2021', '1.0'),
    ('Drive Alone', 'MCY-Gas', '2021', '1.0'),
    ('Drive Alone', 'MDV-Dsl', '2021', '1.0'),
    ('Drive Alone', 'MDV-Elec', '2021', '1.0'),
    ('Drive Alone', 'MDV-Gas', '2021', '1.0'),
    ('Drive Alone', 'MDV-Phe', '2021', '1.0'),
    ('Drive Alone', 'MH-Dsl', '2021', '1.0'),
    ('Drive Alone', 'MH-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'LDA-Dsl', '2021', '1.0'),
    ('Shared Ride 2', 'LDA-Elec', '2021', '1.0'),
    ('Shared Ride 2', 'LDA-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'LDA-Phe', '2021', '1.0'),
    ('Shared Ride 2', 'LDT1-Dsl', '2021', '1.0'),
    ('Shared Ride 2', 'LDT1-Elec', '2021', '1.0'),
    ('Shared Ride 2', 'LDT1-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'LDT1-Phe', '2021', '1.0'),
    ('Shared Ride 2', 'LDT2-Dsl', '2021', '1.0'),
    ('Shared Ride 2', 'LDT2-Elec', '2021', '1.0'),
    ('Shared Ride 2', 'LDT2-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'LDT2-Phe', '2021', '1.0'),
    ('Shared Ride 2', 'MCY-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'MDV-Dsl', '2021', '1.0'),
    ('Shared Ride 2', 'MDV-Elec', '2021', '1.0'),
    ('Shared Ride 2', 'MDV-Gas', '2021', '1.0'),
    ('Shared Ride 2', 'MDV-Phe', '2021', '1.0'),
    ('Shared Ride 2', 'MH-Dsl', '2021', '1.0'),
    ('Shared Ride 2', 'MH-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'LDA-Dsl', '2021', '1.0'),
    ('Shared Ride 3+', 'LDA-Elec', '2021', '1.0'),
    ('Shared Ride 3+', 'LDA-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'LDA-Phe', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT1-Dsl', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT1-Elec', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT1-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT1-Phe', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT2-Dsl', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT2-Elec', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT2-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'LDT2-Phe', '2021', '1.0'),
    --('Shared Ride 3+', 'MCY-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'MDV-Dsl', '2021', '1.0'),
    ('Shared Ride 3+', 'MDV-Elec', '2021', '1.0'),
    ('Shared Ride 3+', 'MDV-Gas', '2021', '1.0'),
    ('Shared Ride 3+', 'MDV-Phe', '2021', '1.0'),
    ('Shared Ride 3+', 'MH-Dsl', '2021', '1.0'),
    ('Shared Ride 3+', 'MH-Gas', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD1-Dsl', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD1-Elec', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD1-Gas', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD2-Dsl', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD2-Elec', '2021', '1.0'),
    ('Light Heavy Duty Truck', 'LHD2-Gas', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'PTO-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'PTO-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 4-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 4-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 5-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 CAIRP Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 4-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 4-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 4-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 5-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 5-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 6-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Delivery Class 7-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 4-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 4-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 4-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 5-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 5-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 6-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Other Class 7-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 6-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Instate Tractor Class 7-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 OOS Class 4-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 OOS Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 OOS Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 OOS Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 4-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 4-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 4-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 5-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 5-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 6-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Public Class 7-NG', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 5-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 5-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 6-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 6-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 7-Dsl', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6 Utility Class 7-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6TS-Elec', '2021', '1.0'),
    ('Medium Heavy Duty Truck', 'T6TS-Gas', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 CAIRP Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 CAIRP Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 CAIRP Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 NNOOS Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 NOOS Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Other Port Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Other Port Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 POLA Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 POLA Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Public Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Public Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Public Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Concrete/Transit Mix Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Concrete/Transit Mix Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Concrete/Transit Mix Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Dump Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Dump Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Dump Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Other Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Other Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Single Other Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 SWCV Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 SWCV Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 SWCV Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Tractor Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Tractor Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Tractor Class 8-NG', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Utility Class 8-Dsl', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7 Utility Class 8-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7IS-Elec', '2021', '1.0'),
    ('Heavy Heavy Duty Truck', 'T7IS-Gas', '2021', '1.0'),
    ('Highway Network Preload - Bus', 'UBUS-Dsl', '2021', '1.0'),
    ('Highway Network Preload - Bus', 'UBUS-Elec', '2021', '1.0'),
    ('Highway Network Preload - Bus', 'UBUS-Gas', '2021', '1.0'),
    ('Highway Network Preload - Bus', 'UBUS-NG', '2021', '1.0')
GO

-- get the sandag and emfac vehicle class surrogate keys
-- and insert into emfac_vehicle_map table
INSERT INTO [emfac].[emfac_vehicle_map]
SELECT
	[sandag_vehicle_class].[sandag_vehicle_class_id]
	,[emfac_vehicle_class].[emfac_vehicle_class_id]
FROM
	#tt_emfac_vehicle_map
LEFT OUTER JOIN -- if no matches a NULL value will return insert error
	[emfac].[sandag_vehicle_class]
ON
	#tt_emfac_vehicle_map.[sandag_vehicle_class] = [sandag_vehicle_class].[sandag_vehicle_class]
LEFT OUTER JOIN -- if no matches a NULL value will return insert error
	[emfac].[emfac_vehicle_class]
ON
	#tt_emfac_vehicle_map.[emfac_vehicle_class] = [emfac_vehicle_class].[emfac_vehicle_class]
	AND #tt_emfac_vehicle_map.[major_version] = [emfac_vehicle_class].[major_version]
	AND #tt_emfac_vehicle_map.[minor_version] = [emfac_vehicle_class].[minor_version]
GO

-- drop temporary emfac_vehicle_map table
DROP TABLE #tt_emfac_vehicle_map
GO

-- add metadata for [emfac].[emfac_vehicle_map]
EXECUTE [db_meta].[add_xp] 'emfac.emfac_vehicle_map', 'MS_Description', 'mapping of emfac vehicle classes to sandag vehicle classes'
GO




-- create fn_emfac_2014_vmt_map table valued function ------------------------
DROP FUNCTION IF EXISTS [emfac].[fn_emfac_2014_vmt_map]
GO

CREATE FUNCTION [emfac].[fn_emfac_2014_vmt_map]
(
	@year integer
)
RETURNS @tbl_emfac_2014_vmt_map TABLE
(
	[sandag_vehicle_class] varchar(50) NOT NULL
	,[emfac_vehicle_class] varchar(50) NOT NULL
	,[value] float NOT NULL
	,PRIMARY KEY ([sandag_vehicle_class], [emfac_vehicle_class])
)
AS

/**
summary:   >
    Take the EMFAC 2014 sandag to emfac vehicle class map and the default
    vmt for a given year to create the percentage split of emfac vehicle
    classes into sandag vehicle classes.
**/

BEGIN

	INSERT INTO @tbl_emfac_2014_vmt_map
	SELECT
		[sandag_vehicle_class]
		,[emfac_vehicle_class]
        -- calculate pct of sandag_vehicle_class that is made up of
        -- emfac_vehicle_class weighted by the default vmt
        -- nof the emfac_vehicle_class
		,[vmt] / (SUM([vmt]) OVER (PARTITION BY [sandag_vehicle_class])) AS [value]
	FROM (
		SELECT
			[sandag_vehicle_class].[sandag_vehicle_class]
            -- EMFAC 2014 contains these two modes in the default vmt report
            -- but does not allow them in the custom input file
			,CASE	WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDA - Elec'
                    THEN 'LDA - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT1 - Elec'
                    THEN 'LDT1 - Gas'
					ELSE [emfac_vehicle_class].[emfac_vehicle_class]
					END AS [emfac_vehicle_class]
			,SUM([emfac_default_vmt].[vmt]) AS [vmt]
		FROM
			[emfac].[emfac_default_vmt]
		INNER JOIN
			[emfac].[emfac_vehicle_class]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_class].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[emfac_vehicle_map]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_map].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[sandag_vehicle_class]
		ON
			[emfac_vehicle_map].[sandag_vehicle_class_id] = [sandag_vehicle_class].[sandag_vehicle_class_id]
		WHERE
			[emfac_default_vmt].[year] = @year
			AND [emfac_vehicle_class].[major_version] = '2014'
			AND [emfac_vehicle_class].[minor_version] = '1.0'
		GROUP BY
			[sandag_vehicle_class].[sandag_vehicle_class]
            -- EMFAC 2014 contains these two modes in the default vmt report
            -- but does not allow them in the custom input file
			,CASE	WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDA - Elec'
                    THEN 'LDA - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT1 - Elec'
                    THEN 'LDT1 - Gas'
					ELSE [emfac_vehicle_class].[emfac_vehicle_class]
					END) AS [tt]

	RETURN
END
GO

-- add metadata for [emfac].[fn_emfac_2014_vmt_map]
EXECUTE [db_meta].[add_xp] 'emfac.fn_emfac_2014_vmt_map', 'MS_Description', 'emfac 2014 function mapping sandag vehicle classes to emfac vehicle classes using the emfac vehicle class default vmt for a given year'
GO




-- create fn_emfac_2017_vmt_map table valued function ------------------------
DROP FUNCTION IF EXISTS [emfac].[fn_emfac_2017_vmt_map]
GO

CREATE FUNCTION [emfac].[fn_emfac_2017_vmt_map]
(
	@year integer
)
RETURNS @tbl_emfac_2017_vmt_map TABLE
(
	[sandag_vehicle_class] varchar(50) NOT NULL
	,[emfac_vehicle_class] varchar(50) NOT NULL
	,[value] float NOT NULL
	,PRIMARY KEY ([sandag_vehicle_class], [emfac_vehicle_class])
)
AS

/**
summary:   >
    Take the EMFAC 2017 sandag to emfac vehicle class map and the default
    vmt for a given year to create the percentage split of emfac vehicle
    classes into sandag vehicle classes.
**/

BEGIN
	INSERT INTO @tbl_emfac_2017_vmt_map
	SELECT
		[sandag_vehicle_class]
		,[emfac_vehicle_class]
        -- calculate pct of sandag_vehicle_class that is made up of
        -- emfac_vehicle_class weighted by the default vmt
        -- of the emfac_vehicle_class
		,[vmt] / (SUM([vmt]) OVER (PARTITION BY [sandag_vehicle_class])) AS [value]
	FROM (
		SELECT
			[sandag_vehicle_class].[sandag_vehicle_class]
            -- EMFAC 2017 contains these six modes in the default vmt report
            -- but does not allow them in the custom input file
			,CASE	WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDA - Elec'
                    THEN 'LDA - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT1 - Elec'
                    THEN 'LDT1 - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT2 - Elec'
                    THEN 'LDT2 - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'MDV - Elec'
                    THEN 'MDV - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'UBUS - NG'
                    THEN 'UBUS - Dsl'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'T7 SWCV - NG'
                    THEN 'T7 SWCV - Dsl'
					ELSE [emfac_vehicle_class].[emfac_vehicle_class]
					END AS [emfac_vehicle_class]
			,SUM([emfac_default_vmt].[vmt]) AS [vmt]
		FROM
			[emfac].[emfac_default_vmt]
		INNER JOIN
			[emfac].[emfac_vehicle_class]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_class].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[emfac_vehicle_map]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_map].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[sandag_vehicle_class]
		ON
			[emfac_vehicle_map].[sandag_vehicle_class_id] = [sandag_vehicle_class].[sandag_vehicle_class_id]
		WHERE
			[emfac_default_vmt].[year] = @year
			AND [emfac_vehicle_class].[major_version] = '2017'
			AND [emfac_vehicle_class].[minor_version] = '1.0'
		GROUP BY
			[sandag_vehicle_class].[sandag_vehicle_class]
            -- EMFAC 2017 contains these six modes in the default vmt report
            -- but does not allow them in the custom input file
			,CASE	WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDA - Elec'
                    THEN 'LDA - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT1 - Elec'
                    THEN 'LDT1 - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'LDT2 - Elec'
                    THEN 'LDT2 - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'MDV - Elec'
                    THEN 'MDV - Gas'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'UBUS - NG'
                    THEN 'UBUS - Dsl'
					WHEN [emfac_vehicle_class].[emfac_vehicle_class] = 'T7 SWCV - NG'
                    THEN 'T7 SWCV - Dsl'
					ELSE [emfac_vehicle_class].[emfac_vehicle_class]
					END) AS [tt]
	RETURN
END
GO

-- add metadata for [emfac].[fn_emfac_2017_vmt_map]
EXECUTE [db_meta].[add_xp] 'emfac.fn_emfac_2017_vmt_map', 'MS_Description', 'emfac 2017 function mapping sandag vehicle classes to emfac vehicle classes using the emfac vehicle class default vmt for a given year'
GO




-- create fn_emfac_2021_vmt_map table valued function ------------------------
DROP FUNCTION IF EXISTS [emfac].[fn_emfac_2021_vmt_map]
GO

CREATE FUNCTION [emfac].[fn_emfac_2021_vmt_map]
(
	@year integer
)
RETURNS @tbl_emfac_2021_vmt_map TABLE
(
	[sandag_vehicle_class] varchar(50) NOT NULL
	,[emfac_vehicle_class] varchar(50) NOT NULL
	,[value] float NOT NULL
	,PRIMARY KEY ([sandag_vehicle_class], [emfac_vehicle_class])
)
AS

/**
summary:   >
    Take the EMFAC 2021 sandag to emfac vehicle class map and the default
    vmt for a given year to create the percentage split of emfac vehicle
    classes into sandag vehicle classes.
**/

BEGIN
	INSERT INTO @tbl_emfac_2021_vmt_map
	SELECT
		[sandag_vehicle_class]
		,[emfac_vehicle_class]
        -- calculate pct of sandag_vehicle_class that is made up of
        -- emfac_vehicle_class weighted by the default vmt
        -- of the emfac_vehicle_class
		,[vmt] / (SUM([vmt]) OVER (PARTITION BY [sandag_vehicle_class])) AS [value]
	FROM (
		SELECT
			[sandag_vehicle_class].[sandag_vehicle_class]
			,[emfac_vehicle_class].[emfac_vehicle_class]
			,SUM([emfac_default_vmt].[vmt]) AS [vmt]
		FROM
			[emfac].[emfac_default_vmt]
		INNER JOIN
			[emfac].[emfac_vehicle_class]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_class].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[emfac_vehicle_map]
		ON
			[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_map].[emfac_vehicle_class_id]
		INNER JOIN
			[emfac].[sandag_vehicle_class]
		ON
			[emfac_vehicle_map].[sandag_vehicle_class_id] = [sandag_vehicle_class].[sandag_vehicle_class_id]
		WHERE
			[emfac_default_vmt].[year] = @year
			AND [emfac_vehicle_class].[major_version] = '2021'
			AND [emfac_vehicle_class].[minor_version] = '1.0'
		GROUP BY
			[sandag_vehicle_class].[sandag_vehicle_class]
			,[emfac_vehicle_class].[emfac_vehicle_class]) AS [tt]
	RETURN
END
GO

-- add metadata for [emfac].[fn_emfac_2021_vmt_map]
EXECUTE [db_meta].[add_xp] 'emfac.fn_emfac_2021_vmt_map', 'MS_Description', 'emfac 2021 function mapping sandag vehicle classes to emfac vehicle classes using the emfac vehicle class default vmt for a given year'
GO




-- Create fn_get_unassigned_vmt table valued function ------------------------
DROP FUNCTION IF EXISTS [emfac].[fn_get_unassigned_vmt]
GO

CREATE FUNCTION [emfac].[fn_get_unassigned_vmt]
(
	@major_version varchar(5),
	@minor_version varchar(5),
	@year integer
)
RETURNS @tbl_unassigned_vmt TABLE
(
	[emfac_vehicle_class] varchar(50) NOT NULL
	,[vmt] float NOT NULL
	,PRIMARY KEY ([emfac_vehicle_class])
)
AS

/**
summary:   >
    Take the sandag to emfac vehicle class map for a given EMFAC version and
    return the default vmt for a given year for all unmapped emfac vehicle
    classes.
**/

BEGIN
	INSERT INTO @tbl_unassigned_vmt
	SELECT
		[emfac_vehicle_class].[emfac_vehicle_class]
		,ISNULL([vmt], 0) AS [vmt]
	FROM
		[emfac].[emfac_vehicle_class]
    -- make it a full and not left outer join to catch errors
    -- (default vmt with no emfac vehicle class)
	FULL OUTER JOIN -- get all emfac vehicle classes for the year
		[emfac].[emfac_default_vmt]
	ON
		[emfac_vehicle_class].[emfac_vehicle_class_id] = [emfac_default_vmt].[emfac_vehicle_class_id]
	LEFT OUTER JOIN
		[emfac].[emfac_vehicle_map]
	ON
		[emfac_default_vmt].[emfac_vehicle_class_id] = [emfac_vehicle_map].[emfac_vehicle_class_id]
	WHERE
        -- get emfac vehicle classes with no default vmt
		([emfac_default_vmt].[year] = @year OR [emfac_default_vmt].[year] IS NULL)
		AND [emfac_vehicle_class].[major_version] = @major_version
		AND [emfac_vehicle_class].[minor_version] = @minor_version
        -- return unassigned emfac vehicle classes
		AND [emfac_vehicle_map].[emfac_vehicle_map_id] IS NULL

	RETURN
END
GO

-- add metadata for [emfac].[fn_get_unassigned_vmt]
EXECUTE [db_meta].[add_xp] 'emfac.fn_get_unassigned_vmt', 'MS_Description', 'emfac function returning default vmt of unmapped emfac vehicle classes for a given emfac version and a given year'
GO




-- create sp_emfac_2014_vmt stored procedure ---------------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2014_vmt]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2014_vmt]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT function for EMFAC 2014 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id)

	-- get model vmt by emfac vehicle class
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[fn_emfac_2014_vmt_map].[emfac_vehicle_class] AS [Veh_Tech]
		,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2014_vmt_map].[value]) AS [New Total VMT]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[hwy_link]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
    -- left outer join keeps NULL records if no matches and throws insert error
	LEFT OUTER JOIN
		[emfac].[fn_emfac_2014_vmt_map](@year)
	ON
		[mode].[mode_description] = [fn_emfac_2014_vmt_map].[sandag_vehicle_class]
	WHERE
		[hwy_flow_mode].[scenario_id] = @scenario_id
		AND [hwy_link].[scenario_id] = @scenario_id
	GROUP BY
		[fn_emfac_2014_vmt_map].[emfac_vehicle_class]

	UNION ALL

	-- get non-assigned classes (e.g., school bus) vmt
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[vmt] AS [New Total VMT]
	FROM
		[emfac].[fn_get_unassigned_vmt]('2014', '1.0', @year)
	ORDER BY
		[emfac_vehicle_class]
OPTION(MAXDOP 1)
END
GO

-- add metadata for [emfac].[sp_emfac_2014_vmt]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2014_vmt', 'MS_Description', 'emfac 2014 vmt stored procedure for emfac program'
GO




-- create sp_emfac_2017_vmt stored procedure ---------------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2017_vmt]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2017_vmt]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT function for EMFAC 2017 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id)

	-- get model vmt by emfac vehicle class
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[fn_emfac_2017_vmt_map].[emfac_vehicle_class] AS [Veh_Tech]
		,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2017_vmt_map].[value]) AS [New Total VMT]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[hwy_link]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
    -- left outer join keeps NULL records if no matches and throws insert error
	LEFT OUTER JOIN
		[emfac].[fn_emfac_2017_vmt_map](@year)
	ON
		[mode].[mode_description] = [fn_emfac_2017_vmt_map].[sandag_vehicle_class]
	WHERE
		[hwy_flow_mode].[scenario_id] = @scenario_id
		AND [hwy_link].[scenario_id] = @scenario_id
	GROUP BY
		[fn_emfac_2017_vmt_map].[emfac_vehicle_class]

	UNION ALL

	-- get non-assigned classes (e.g., school bus) vmt
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[vmt] AS [New Total VMT]
	FROM
		[emfac].[fn_get_unassigned_vmt]('2017', '1.0', @year)
	ORDER BY
		[emfac_vehicle_class]
OPTION(MAXDOP 1)
END
GO

-- add metadata for [emfac].[sp_emfac_2017_vmt]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2017_vmt', 'MS_Description', 'emfac 2017 vmt stored procedure for emfac program'
GO




-- create sp_emfac_2021_vmt stored procedure ---------------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2021_vmt]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2021_vmt]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT function for EMFAC 2021 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id)

	-- get model vmt by emfac vehicle class
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[fn_emfac_2021_vmt_map].[emfac_vehicle_class] AS [Veh_Tech]
		,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2021_vmt_map].[value]) AS [New Total VMT]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[hwy_link]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
    -- left outer join keeps NULL records if no matches and will result in ERROR
	LEFT OUTER JOIN
		[emfac].[fn_emfac_2021_vmt_map](@year)
	ON
		[mode].[mode_description] = [fn_emfac_2021_vmt_map].[sandag_vehicle_class]
	WHERE
		[hwy_flow_mode].[scenario_id] = @scenario_id
		AND [hwy_link].[scenario_id] = @scenario_id
	GROUP BY
		[fn_emfac_2021_vmt_map].[emfac_vehicle_class]

	UNION ALL

	-- get non-assigned classes (e.g., school bus) vmt
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[vmt] AS [New Total VMT]
	FROM
		[emfac].[fn_get_unassigned_vmt]('2021', '1.0', @year)
	ORDER BY
		[emfac_vehicle_class]
OPTION(MAXDOP 1)
END
GO

-- add metadata for [emfac].[sp_emfac_2021_vmt]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2021_vmt', 'MS_Description', 'emfac 2021 vmt stored procedure for emfac program'
GO




-- create sp_emfac_2014_vmt_speed stored procedure ---------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2014_vmt_speed]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2014_vmt_speed]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT by speed bin function for EMFAC 2014 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id);

	-- declare table to hold mapping of abm assignment
    -- five time of day to hour based representation
	DECLARE @tbl_emfac_time TABLE
	(
		[abm_5_tod] int NOT NULL
		,[emfac_hours] int NOT NULL
	)

	-- define mapping of abm assignment five time of day to hour
    -- based representation
	INSERT INTO @tbl_emfac_time VALUES
		(5,1),
		(5,2),
		(5,3),
		(5,20),
		(5,21),
		(5,22),
		(5,23),
		(5,24),
		(1,4),
		(1,5),
		(1,6),
		(2,7),
		(2,8),
		(2,9),
		(3,10),
		(3,11),
		(3,12),
		(3,13),
		(3,14),
		(3,15),
		(3,16),
		(4,17),
		(4,18),
		(4,19);


	-- calculate model vmt by emfac vehicle class, hour of day, and speed bin
	--Get the ABM assigned VMT by vehicle type and speed
	with [vmt_speed] AS (
		SELECT
			[fn_emfac_2014_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5 AS [speed_bin]
			,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2014_vmt_map].[value]) AS [vmt]
		FROM
			[fact].[hwy_flow_mode]
		INNER JOIN
			[dimension].[hwy_link]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
		INNER JOIN
			[fact].[hwy_flow]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
		INNER JOIN
			[dimension].[mode]
		ON
			[hwy_flow_mode].[mode_id] = [mode].[mode_id]
		INNER JOIN
			[emfac].[fn_emfac_2014_vmt_map](@year)
		ON
			[mode].[mode_description] = [fn_emfac_2014_vmt_map].[sandag_vehicle_class]
		WHERE
			[hwy_flow_mode].[scenario_id] = @scenario_id
			AND [hwy_link].[scenario_id] = @scenario_id
			AND [hwy_flow].[scenario_id] = @scenario_id
			AND [hwy_flow_mode].[flow] > 0
		GROUP BY
			[fn_emfac_2014_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5),
	[unassigned_vmt_speed] AS (
	-- get non-assigned classes (e.g., school bus) vmt by hour and speed bin
	-- use LDA-Gas from model vmt, this is ok as it is just used to
    -- create percentage of vmt by speed bin
		SELECT
			[fn_get_unassigned_vmt].[emfac_vehicle_class]
			,[vmt_speed].[time_id]
			,[vmt_speed].[speed_bin]
			,[vmt_speed].[vmt]
		FROM
			[vmt_speed]
		CROSS JOIN
			[emfac].[fn_get_unassigned_vmt]('2014', '1.0', @year)
		WHERE
			[vmt_speed].[emfac_vehicle_class] = 'LDA - Gas'),
	[vmt_speed_pct] AS (
		SELECT
			[emfac_vehicle_class]
			,[emfac_hours]
			,[speed_bin]
            -- note CASE statements stop execution when first true is evaluated
			,CASE	WHEN [emfac_vehicle_class] = 'PTO - Dsl'
						 AND [speed_bin] = 20
					THEN 1 -- assign all PTO - Dsl pct vmt to the 20mph speed bin
					WHEN [emfac_vehicle_class] = 'PTO - Dsl'
					THEN 0 -- all other PTO - Dsl pct vmt by speed bin is set to 0
                    -- create pct of vmt by speed bin
					ELSE [vmt] / SUM([vmt]) OVER (PARTITION BY [emfac_vehicle_class], [emfac_hours])
					END AS [class_hr_vmt_pct]
		FROM (
			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            -- assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])

			UNION ALL

			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[unassigned_vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[unassigned_vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            -- assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])) AS [tt])
	-- pivot results for final return table
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[emfac_hours] AS [Hour]
		,ISNULL([0],0) + ISNULL([5],0) AS [5mph]
		,ISNULL([10],0) AS [10mph]
		,ISNULL([15],0) AS [15mph]
		,ISNULL([20],0) AS [20mph]
		,ISNULL([25],0) AS [25mph]
		,ISNULL([30],0) AS [30mph]
		,ISNULL([35],0) AS [35mph]
		,ISNULL([40],0) AS [40mph]
		,ISNULL([45],0) AS [45mph]
		,ISNULL([50],0) AS [50mph]
		,ISNULL([55],0) AS [55mph]
		,ISNULL([60],0) AS [60mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN ISNULL([65],0)  + ISNULL([70],0)  + ISNULL([75],0)  + ISNULL([80],0)  + ISNULL([85],0)  + ISNULL([90],0)
				ELSE ISNULL([65],0)
				END AS [65mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([70],0)
				END AS [70mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([75],0)
				END AS [75mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([80],0)
				END AS [80mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([85],0)
				END AS [85mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([90],0)
				END AS [90mph]
	FROM
		[vmt_speed_pct]
	PIVOT
		(SUM([class_hr_vmt_pct]) FOR [speed_bin] IN ([0],
													 [5],
													 [10],
													 [15],
													 [20],
													 [25],
													 [30],
													 [35],
													 [40],
													 [45],
													 [50],
													 [55],
													 [60],
													 [65],
													 [70],
													 [75],
													 [80],
													 [85],
													 [90])) AS [pvt]
	 ORDER BY
		[emfac_vehicle_class]
		,[emfac_hours]

	RETURN
END
GO

-- add metadata for [emfac].[sp_emfac_2014_vmt_speed]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2014_vmt_speed', 'MS_Description', 'emfac 2014 vmt by hour and speed bin stored procedure for emfac program'
GO




-- create sp_emfac_2017_vmt_speed stored procedure ---------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2017_vmt_speed]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2017_vmt_speed]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT by speed bin function for EMFAC 2017 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id);

	-- declare table to hold mapping of
    -- abm assignment five time of day to hour based representation
	DECLARE @tbl_emfac_time TABLE
	(
		[abm_5_tod] int NOT NULL
		,[emfac_hours] int NOT NULL
	)

	-- define mapping of abm assignment five time of day to hour based
    -- representation
	INSERT INTO @tbl_emfac_time VALUES
		(5,1),
		(5,2),
		(5,3),
		(5,20),
		(5,21),
		(5,22),
		(5,23),
		(5,24),
		(1,4),
		(1,5),
		(1,6),
		(2,7),
		(2,8),
		(2,9),
		(3,10),
		(3,11),
		(3,12),
		(3,13),
		(3,14),
		(3,15),
		(3,16),
		(4,17),
		(4,18),
		(4,19);

	-- calculate model vmt by emfac vehicle class, hour of day, and speed bin
	-- Get the ABM assigned VMT by vehicle type and speed
	with [vmt_speed] AS (
		SELECT
			[fn_emfac_2017_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5 AS [speed_bin]
			,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2017_vmt_map].[value]) AS [vmt]
		FROM
			[fact].[hwy_flow_mode]
		INNER JOIN
			[dimension].[hwy_link]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
		INNER JOIN
			[fact].[hwy_flow]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
		INNER JOIN
			[dimension].[mode]
		ON
			[hwy_flow_mode].[mode_id] = [mode].[mode_id]
		INNER JOIN
			[emfac].[fn_emfac_2017_vmt_map](@year)
		ON
			[mode].[mode_description] = [fn_emfac_2017_vmt_map].[sandag_vehicle_class]
		WHERE
			[hwy_flow_mode].[scenario_id] = @scenario_id
			AND [hwy_link].[scenario_id] = @scenario_id
			AND [hwy_flow].[scenario_id] = @scenario_id
			AND [hwy_flow_mode].[flow] > 0
		GROUP BY
			[fn_emfac_2017_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5),
	[unassigned_vmt_speed] AS (
	-- get non-assigned classes (e.g., school bus) vmt by hour and speed bin
	-- use LDA-Gas from model vmt, this is ok as it is just used to
    -- create percentage of vmt by speed bin
		SELECT
			[fn_get_unassigned_vmt].[emfac_vehicle_class]
			,[vmt_speed].[time_id]
			,[vmt_speed].[speed_bin]
			,[vmt_speed].[vmt]
		FROM
			[vmt_speed]
		CROSS JOIN
			[emfac].[fn_get_unassigned_vmt]('2017', '1.0', @year)
		WHERE
			[vmt_speed].[emfac_vehicle_class] = 'LDA - Gas'),
	[vmt_speed_pct] AS (
		SELECT
			[emfac_vehicle_class]
			,[emfac_hours]
			,[speed_bin]
            -- CASE statements stop execution when first true is evaluated
			,CASE	WHEN [emfac_vehicle_class] = 'PTO - Dsl'
						 AND [speed_bin] = 20
					THEN 1 -- assign all PTO - Dsl pct vmt to the 20mph speed bin
					WHEN [emfac_vehicle_class] = 'PTO - Dsl'
					THEN 0 -- all other PTO - Dsl pct vmt by speed bin is set to 0
                    -- create pct of vmt by speed bin
					ELSE [vmt] / SUM([vmt]) OVER (PARTITION BY [emfac_vehicle_class], [emfac_hours])
					END AS [class_hr_vmt_pct]
		FROM (
			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            --assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])

			UNION ALL

			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[unassigned_vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[unassigned_vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            --assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])) AS [tt])
	-- pivot results for final return table
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[emfac_hours] AS [Hour]
		,ISNULL([0],0) + ISNULL([5],0) AS [5mph]
		,ISNULL([10],0) AS [10mph]
		,ISNULL([15],0) AS [15mph]
		,ISNULL([20],0) AS [20mph]
		,ISNULL([25],0) AS [25mph]
		,ISNULL([30],0) AS [30mph]
		,ISNULL([35],0) AS [35mph]
		,ISNULL([40],0) AS [40mph]
		,ISNULL([45],0) AS [45mph]
		,ISNULL([50],0) AS [50mph]
		,ISNULL([55],0) AS [55mph]
		,ISNULL([60],0) AS [60mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN ISNULL([65],0)  + ISNULL([70],0)  + ISNULL([75],0)  + ISNULL([80],0)  + ISNULL([85],0)  + ISNULL([90],0)
				ELSE ISNULL([65],0)
				END AS [65mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([70],0)
				END AS [70mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([75],0)
				END AS [75mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([80],0)
				END AS [80mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([85],0)
				END AS [85mph]
		,CASE	WHEN [emfac_vehicle_class] IN ('LHD1 - Dsl',
											   'LHD1 - Gas',
											   'LHD2 - Dsl',
											   'LHD2 - Gas',
											   'OBUS - Gas',
											   'SBUS - Dsl',
											   'SBUS - Gas',
											   'T6 Ag - Dsl',
											   'T6 CAIRP Heavy - Dsl',
											   'T6 CAIRP Small - Dsl',
											   'T6 Instate Construction Heavy - Dsl',
											   'T6 Instate Construction Small - Dsl',
											   'T6 Instate Heavy - Dsl',
											   'T6 Instate Small - Dsl',
											   'T6 OOS Heavy - Dsl',
											   'T6 OOS Small - Dsl',
											   'T6 Public - Dsl',
											   'T6 Utility - Dsl',
											   'T6TS - Gas',
											   'T7 Ag - Dsl',
											   'T7 CAIRP - Dsl',
											   'T7 CAIRP Construction - Dsl',
											   'T7 NNOOS - Dsl',
											   'T7 NOOS - Dsl',
											   'T7 Other Port - Dsl',
											   'T7 POAK - Dsl',
											   'T7 POLA - Dsl',
											   'T7 Public - Dsl',
											   'T7 Single - Dsl',
											   'T7 Single Construction - Dsl',
											   'T7 SWCV - Dsl',
											   'T7 Tractor - Dsl',
											   'T7 Tractor Construction - Dsl',
											   'T7 Utility - Dsl',
											   'T7IS - Gas',
											   'UBUS - Dsl',
											   'UBUS - Gas')
				THEN 0
				ELSE ISNULL([90],0)
				END AS [90mph]
	FROM
		[vmt_speed_pct]
	PIVOT
		(SUM([class_hr_vmt_pct]) FOR [speed_bin] IN ([0],
													 [5],
													 [10],
													 [15],
													 [20],
													 [25],
													 [30],
													 [35],
													 [40],
													 [45],
													 [50],
													 [55],
													 [60],
													 [65],
													 [70],
													 [75],
													 [80],
													 [85],
													 [90])) AS [pvt]
	 ORDER BY
		[emfac_vehicle_class]
		,[emfac_hours]

	RETURN
END
GO

-- add metadata for [emfac].[sp_emfac_2017_vmt_speed]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2017_vmt_speed', 'MS_Description', 'emfac 2017 vmt by hour and speed bin stored procedure for emfac program'
GO




-- create sp_emfac_2021_vmt_speed stored procedure ---------------------------
DROP PROCEDURE IF EXISTS [emfac].[sp_emfac_2021_vmt_speed]
GO

CREATE PROCEDURE [emfac].[sp_emfac_2021_vmt_speed]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**
summary:   >
    VMT by speed bin function for EMFAC 2021 program.
**/

BEGIN
	SET NOCOUNT ON;

	-- get the scenario year
	DECLARE @year integer;
	SET @year = (
		SELECT
			[year]
		FROM
			[dimension].[scenario]
		WHERE
			[scenario_id] = @scenario_id);

	-- declare table to hold mapping of
    -- abm assignment five time of day to hour based representation
	DECLARE @tbl_emfac_time TABLE
	(
		[abm_5_tod] int NOT NULL
		,[emfac_hours] int NOT NULL
	)

	-- define mapping of abm assignment five time of day to hour based
    -- representation
	INSERT INTO @tbl_emfac_time VALUES
		(5,1),
		(5,2),
		(5,3),
		(5,20),
		(5,21),
		(5,22),
		(5,23),
		(5,24),
		(1,4),
		(1,5),
		(1,6),
		(2,7),
		(2,8),
		(2,9),
		(3,10),
		(3,11),
		(3,12),
		(3,13),
		(3,14),
		(3,15),
		(3,16),
		(4,17),
		(4,18),
		(4,19);

	-- calculate model vmt by emfac vehicle class, hour of day, and speed bin
	-- Get the ABM assigned VMT by vehicle type and speed
	with [vmt_speed] AS (
		SELECT
			[fn_emfac_2021_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5 AS [speed_bin]
			,SUM([hwy_flow_mode].[flow] * [hwy_link].[length_mile] * [fn_emfac_2021_vmt_map].[value]) AS [vmt]
		FROM
			[fact].[hwy_flow_mode]
		INNER JOIN
			[dimension].[hwy_link]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
		INNER JOIN
			[fact].[hwy_flow]
		ON
			[hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
			AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
		INNER JOIN
			[dimension].[mode]
		ON
			[hwy_flow_mode].[mode_id] = [mode].[mode_id]
		INNER JOIN
			[emfac].[fn_emfac_2021_vmt_map](@year)
		ON
			[mode].[mode_description] = [fn_emfac_2021_vmt_map].[sandag_vehicle_class]
		WHERE
			[hwy_flow_mode].[scenario_id] = @scenario_id
			AND [hwy_link].[scenario_id] = @scenario_id
			AND [hwy_flow].[scenario_id] = @scenario_id
			AND [hwy_flow_mode].[flow] > 0
		GROUP BY
			[fn_emfac_2021_vmt_map].[emfac_vehicle_class]
			,[hwy_flow_mode].[time_id]
			,CEILING([hwy_flow].[speed] / 5) * 5),
	[unassigned_vmt_speed] AS (
	-- get non-assigned classes (e.g., school bus) vmt by hour and speed bin
	-- use LDA-Gas from model vmt, this is ok as it is just used to
    -- create percentage of vmt by speed bin
		SELECT
			[fn_get_unassigned_vmt].[emfac_vehicle_class]
			,[vmt_speed].[time_id]
			,[vmt_speed].[speed_bin]
			,[vmt_speed].[vmt]
		FROM
			[vmt_speed]
		CROSS JOIN
			[emfac].[fn_get_unassigned_vmt]('2021', '1.0', @year)
		WHERE
			[vmt_speed].[emfac_vehicle_class] = 'LDA-Gas'),
	[vmt_speed_pct] AS (
		SELECT
			[emfac_vehicle_class]
			,[emfac_hours]
			,[speed_bin]
            -- CASE statements stop execution when first true is evaluated
			,CASE	WHEN [emfac_vehicle_class] = 'PTO-Dsl'
						 AND [speed_bin] = 20
					THEN 1 -- assign all PTO-Dsl pct vmt to the 20mph speed bin
					WHEN [emfac_vehicle_class] = 'PTO-Dsl'
					THEN 0 -- all other PTO-Dsl pct vmt by speed bin is set to 0
                    -- create pct of vmt by speed bin
					ELSE [vmt] / SUM([vmt]) OVER (PARTITION BY [emfac_vehicle_class], [emfac_hours])
					END AS [class_hr_vmt_pct]
		FROM (
			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            --assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])

			UNION ALL

			SELECT
				[emfac_vehicle_class]
				,[emfac_hours]
				,[speed_bin]
				,[vmt]
			FROM
				[unassigned_vmt_speed]
			INNER JOIN
				[dimension].[time]
			ON
				[unassigned_vmt_speed].[time_id] = [time].[time_id]
			RIGHT JOIN -- TODO does this make sense?
            --assigns same vmt to every hour within each assignment period
				@tbl_emfac_time AS [tbl_emfac_time]
			ON
				[time].[abm_5_tod] = CONVERT(varchar, [tbl_emfac_time].[abm_5_tod])) AS [tt])
	-- pivot results for final return table
	SELECT
		'SANDAG' AS [MPO]
		,38 AS [GAI]
		,'San Diego (SD)' AS [Sub-Area]
		,@year AS [Cal_Year]
		,[emfac_vehicle_class] AS [Veh_Tech]
		,[emfac_hours] AS [Hour]
		,ISNULL([0],0) + ISNULL([5],0) AS [5mph]
		,ISNULL([10],0) AS [10mph]
		,ISNULL([15],0) AS [15mph]
		,ISNULL([20],0) AS [20mph]
		,ISNULL([25],0) AS [25mph]
		,ISNULL([30],0) AS [30mph]
		,ISNULL([35],0) AS [35mph]
		,ISNULL([40],0) AS [40mph]
		,ISNULL([45],0) AS [45mph]
		,ISNULL([50],0) AS [50mph]
		,ISNULL([55],0) AS [55mph]
		,ISNULL([60],0) AS [60mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN ISNULL([65],0)  + ISNULL([70],0)  + ISNULL([75],0)  + ISNULL([80],0)  + ISNULL([85],0)  + ISNULL([90],0)
				ELSE ISNULL([65],0)
				END AS [65mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN 0
				ELSE ISNULL([70],0)
				END AS [70mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN 0
				ELSE ISNULL([75],0)
				END AS [75mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN 0
				ELSE ISNULL([80],0)
				END AS [80mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN 0
				ELSE ISNULL([85],0)
				END AS [85mph]
		,CASE WHEN [emfac_vehicle_class] IN (-- 'Motor Coach-Dsl',  INCLUDE????
                                             -- 'PTO-Dsl',  INCLUDE????
                                             -- 'PTO-Elec',  INCLUDE????
                                                'LHD1-Dsl',
                                                'LHD1-Elec',
                                                'LHD1-Gas',
                                                'LHD2-Dsl',
                                                'LHD2-Elec',
                                                'LHD2-Gas',
                                                'OBUS-Elec',
                                                'OBUS-Gas',
                                                'SBUS-Dsl',
                                                'SBUS-Elec',
                                                'SBUS-Gas',
                                                'SBUS-NG',
                                                'T6 CAIRP Class 4-Dsl',
                                                'T6 CAIRP Class 4-Elec',
                                                'T6 CAIRP Class 5-Dsl',
                                                'T6 CAIRP Class 5-Elec',
                                                'T6 CAIRP Class 6-Dsl',
                                                'T6 CAIRP Class 6-Elec',
                                                'T6 CAIRP Class 7-Dsl',
                                                'T6 CAIRP Class 7-Elec',
                                                'T6 Instate Delivery Class 4-Dsl',
                                                'T6 Instate Delivery Class 4-Elec',
                                                'T6 Instate Delivery Class 4-NG',
                                                'T6 Instate Delivery Class 5-Dsl',
                                                'T6 Instate Delivery Class 5-Elec',
                                                'T6 Instate Delivery Class 5-NG',
                                                'T6 Instate Delivery Class 6-Dsl',
                                                'T6 Instate Delivery Class 6-Elec',
                                                'T6 Instate Delivery Class 6-NG',
                                                'T6 Instate Delivery Class 7-Dsl',
                                                'T6 Instate Delivery Class 7-Elec',
                                                'T6 Instate Delivery Class 7-NG',
                                                'T6 Instate Other Class 4-Dsl',
                                                'T6 Instate Other Class 4-Elec',
                                                'T6 Instate Other Class 4-NG',
                                                'T6 Instate Other Class 5-Dsl',
                                                'T6 Instate Other Class 5-Elec',
                                                'T6 Instate Other Class 5-NG',
                                                'T6 Instate Other Class 6-Dsl',
                                                'T6 Instate Other Class 6-Elec',
                                                'T6 Instate Other Class 6-NG',
                                                'T6 Instate Other Class 7-Dsl',
                                                'T6 Instate Other Class 7-Elec',
                                                'T6 Instate Other Class 7-NG',
                                                'T6 Instate Tractor Class 6-Dsl',
                                                'T6 Instate Tractor Class 6-Elec',
                                                'T6 Instate Tractor Class 6-NG',
                                                'T6 Instate Tractor Class 7-Dsl',
                                                'T6 Instate Tractor Class 7-Elec',
                                                'T6 Instate Tractor Class 7-NG',
                                                'T6 OOS Class 4-Dsl',
                                                'T6 OOS Class 5-Dsl',
                                                'T6 OOS Class 6-Dsl',
                                                'T6 OOS Class 7-Dsl',
                                                'T6 Public Class 4-Dsl',
                                                'T6 Public Class 4-Elec',
                                                'T6 Public Class 4-NG',
                                                'T6 Public Class 5-Dsl',
                                                'T6 Public Class 5-Elec',
                                                'T6 Public Class 5-NG',
                                                'T6 Public Class 6-Dsl',
                                                'T6 Public Class 6-Elec',
                                                'T6 Public Class 6-NG',
                                                'T6 Public Class 7-Dsl',
                                                'T6 Public Class 7-Elec',
                                                'T6 Public Class 7-NG',
                                                'T6 Utility Class 5-Dsl',
                                                'T6 Utility Class 5-Elec',
                                                'T6 Utility Class 6-Dsl',
                                                'T6 Utility Class 6-Elec',
                                                'T6 Utility Class 7-Dsl',
                                                'T6 Utility Class 7-Elec',
                                                'T6TS-Elec',
                                                'T6TS-Gas',
                                                'T7 CAIRP Class 8-Dsl',
                                                'T7 CAIRP Class 8-Elec',
                                                'T7 CAIRP Class 8-NG',
                                                'T7 NNOOS Class 8-Dsl',
                                                'T7 NOOS Class 8-Dsl',
                                                'T7 Other Port Class 8-Dsl',
                                                'T7 Other Port Class 8-Elec',
                                                'T7 POLA Class 8-Dsl',
                                                'T7 POLA Class 8-Elec',
                                                'T7 Public Class 8-Dsl',
                                                'T7 Public Class 8-Elec',
                                                'T7 Public Class 8-NG',
                                                'T7 Single Concrete/Transit Mix Class 8-Dsl',
                                                'T7 Single Concrete/Transit Mix Class 8-Elec',
                                                'T7 Single Concrete/Transit Mix Class 8-NG',
                                                'T7 Single Dump Class 8-Dsl',
                                                'T7 Single Dump Class 8-Elec',
                                                'T7 Single Dump Class 8-NG',
                                                'T7 Single Other Class 8-Dsl',
                                                'T7 Single Other Class 8-Elec',
                                                'T7 Single Other Class 8-NG',
                                                'T7 SWCV Class 8-Dsl',
                                                'T7 SWCV Class 8-Elec',
                                                'T7 SWCV Class 8-NG',
                                                'T7 Tractor Class 8-Dsl',
                                                'T7 Tractor Class 8-Elec',
                                                'T7 Tractor Class 8-NG',
                                                'T7 Utility Class 8-Dsl',
                                                'T7 Utility Class 8-Elec',
                                                'T7IS-Elec',
                                                'T7IS-Gas',
                                                'UBUS-Dsl',
                                                'UBUS-Elec',
                                                'UBUS-Gas',
                                                'UBUS-NG')
				THEN 0
				ELSE ISNULL([90],0)
				END AS [90mph]
	FROM
		[vmt_speed_pct]
	PIVOT
		(SUM([class_hr_vmt_pct]) FOR [speed_bin] IN ([0],
													 [5],
													 [10],
													 [15],
													 [20],
													 [25],
													 [30],
													 [35],
													 [40],
													 [45],
													 [50],
													 [55],
													 [60],
													 [65],
													 [70],
													 [75],
													 [80],
													 [85],
													 [90])) AS [pvt]
	 ORDER BY
		[emfac_vehicle_class]
		,[emfac_hours]

	RETURN
END
GO

-- add metadata for [emfac].[sp_emfac_2021_vmt_speed]
EXECUTE [db_meta].[add_xp] 'emfac.sp_emfac_2021_vmt_speed', 'MS_Description', 'emfac 2021 vmt by hour and speed bin stored procedure for emfac program'
GO




-- define [emfac] schema permissions -----------------------------------------
-- drop [emfac] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'emfac_user'

IF @RoleName <> 'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals
    where principal_id in (
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName

    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)

        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;

    DROP ROLE [emfac_user]
END
GO
-- create user role for [emfac] schema
CREATE ROLE [emfac_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [emfac] stored procedures
GRANT EXECUTE ON SCHEMA :: [emfac] TO [emfac_user];
GRANT SELECT ON SCHEMA :: [emfac] TO [emfac_user];
GRANT VIEW DEFINITION ON SCHEMA :: [emfac] TO [emfac_user];
