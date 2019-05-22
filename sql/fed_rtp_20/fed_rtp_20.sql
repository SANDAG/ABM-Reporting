-- assumes ctemfac_2014 database exists

SET NOCOUNT ON;
GO


-- create [fed_rtp_20] schema ---------------------------------------------------
-- note that [fed_rtp_20] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'fed_rtp_20'
)
EXEC ('CREATE SCHEMA [fed_rtp_20]')
GO

-- add metadata for [fed_rtp_20] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[fed_rtp_20]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'fed_rtp_20', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'fed_rtp_20', 'MS_Description', 'schema to hold all objects associated with the 2020 Federal Regional Transportation Plan'
END
GO




-- create table holding series 13 TAZs
-- identified as freight distribution hubs -----------------------------------
DROP TABLE IF EXISTS [fed_rtp_20].[freight_distribution_hub]
/**
summary:   >
    Creates table holding series 13 TAZs identified as freight distribution
    hubs. These are used in the stored procedure [fed_rtp_20].[sp_pm_H].
**/
BEGIN
    -- create table to hold freight distribution hubs
	CREATE TABLE [fed_rtp_20].[freight_distribution_hub] (
        [taz_13] nchar(20) NOT NULL,
		CONSTRAINT pk_freightdistributionhub PRIMARY KEY ([taz_13]))
	WITH (DATA_COMPRESSION = PAGE)

    -- insert data into freight distribution hub table
    INSERT INTO [fed_rtp_20].[freight_distribution_hub] VALUES
        ('1'),
        ('2'),
        ('3'),
        ('4'),
        ('5'),
        ('6'),
        ('7'),
        ('8'),
        ('9'),
        ('10'),
        ('11'),
        ('12'),
        ('736'),
        ('772'),
        ('785'),
        ('792'),
        ('812'),
        ('814'),
        ('820'),
        ('822'),
        ('824'),
        ('830'),
        ('832'),
        ('834'),
        ('836'),
        ('839'),
        ('844'),
        ('845'),
        ('847'),
        ('848'),
        ('850'),
        ('856'),
        ('857'),
        ('858'),
        ('860'),
        ('862'),
        ('866'),
        ('867'),
        ('868'),
        ('871'),
        ('874'),
        ('877'),
        ('881'),
        ('883'),
        ('884'),
        ('887'),
        ('889'),
        ('890'),
        ('892'),
        ('893'),
        ('894'),
        ('897'),
        ('898'),
        ('899'),
        ('904'),
        ('907'),
        ('908'),
        ('911'),
        ('915'),
        ('916'),
        ('918'),
        ('920'),
        ('922'),
        ('923'),
        ('925'),
        ('927'),
        ('928'),
        ('930'),
        ('931'),
        ('934'),
        ('936'),
        ('937'),
        ('938'),
        ('939'),
        ('940'),
        ('941'),
        ('942'),
        ('944'),
        ('946'),
        ('947'),
        ('950'),
        ('951'),
        ('953'),
        ('956'),
        ('957'),
        ('958'),
        ('961'),
        ('962'),
        ('963'),
        ('964'),
        ('965'),
        ('968'),
        ('969'),
        ('970'),
        ('973'),
        ('974'),
        ('976'),
        ('978'),
        ('981'),
        ('982'),
        ('983'),
        ('985'),
        ('986'),
        ('987'),
        ('988'),
        ('989'),
        ('991'),
        ('992'),
        ('993'),
        ('994'),
        ('995'),
        ('996'),
        ('997'),
        ('998'),
        ('1000'),
        ('1001'),
        ('1002'),
        ('1006'),
        ('1007'),
        ('1010'),
        ('1012'),
        ('1013'),
        ('1014'),
        ('1016'),
        ('1018'),
        ('1020'),
        ('1023'),
        ('1024'),
        ('1025'),
        ('1026'),
        ('1028'),
        ('1029'),
        ('1030'),
        ('1031'),
        ('1032'),
        ('1033'),
        ('1038'),
        ('1039'),
        ('1040'),
        ('1041'),
        ('1043'),
        ('1044'),
        ('1045'),
        ('1046'),
        ('1047'),
        ('1049'),
        ('1050'),
        ('1051'),
        ('1052'),
        ('1055'),
        ('1056'),
        ('1057'),
        ('1058'),
        ('1060'),
        ('1061'),
        ('1065'),
        ('1066'),
        ('1068'),
        ('1069'),
        ('1070'),
        ('1073'),
        ('1075'),
        ('1076'),
        ('1077'),
        ('1079'),
        ('1080'),
        ('1081'),
        ('1082'),
        ('1084'),
        ('1086'),
        ('1088'),
        ('1090'),
        ('1091'),
        ('1093'),
        ('1096'),
        ('1097'),
        ('1099'),
        ('1100'),
        ('1101'),
        ('1103'),
        ('1105'),
        ('1109'),
        ('1111'),
        ('1113'),
        ('1115'),
        ('1121'),
        ('1124'),
        ('1125'),
        ('1136'),
        ('1138'),
        ('1140'),
        ('1143'),
        ('1144'),
        ('1145'),
        ('1147'),
        ('1150'),
        ('1154'),
        ('1155'),
        ('1156'),
        ('1157'),
        ('1160'),
        ('1161'),
        ('1170'),
        ('1173'),
        ('1174'),
        ('1175'),
        ('1176'),
        ('1181'),
        ('1182'),
        ('1184'),
        ('1186'),
        ('1187'),
        ('1188'),
        ('1193'),
        ('1197'),
        ('1201'),
        ('1205'),
        ('1206'),
        ('1209'),
        ('1212'),
        ('1213'),
        ('1221'),
        ('1223'),
        ('1230'),
        ('1235'),
        ('1240'),
        ('1241'),
        ('1275'),
        ('1419'),
        ('1458'),
        ('1459'),
        ('1497'),
        ('1502'),
        ('1504'),
        ('1514'),
        ('1552'),
        ('1554'),
        ('1572'),
        ('1576'),
        ('1577'),
        ('1583'),
        ('1585'),
        ('1590'),
        ('1600'),
        ('1627'),
        ('1632'),
        ('1639'),
        ('1645'),
        ('1646'),
        ('1650'),
        ('1671'),
        ('1674'),
        ('1678'),
        ('1680'),
        ('1681'),
        ('1683'),
        ('1684'),
        ('1687'),
        ('1688'),
        ('1691'),
        ('1693'),
        ('1695'),
        ('1699'),
        ('1702'),
        ('1704'),
        ('1711'),
        ('1712'),
        ('1716'),
        ('1718'),
        ('1719'),
        ('1720'),
        ('1726'),
        ('1728'),
        ('1729'),
        ('1731'),
        ('1740'),
        ('1762'),
        ('1898'),
        ('1901'),
        ('1906'),
        ('1908'),
        ('1911'),
        ('1912'),
        ('1916'),
        ('1917'),
        ('1922'),
        ('1925'),
        ('1926'),
        ('1927'),
        ('1928'),
        ('1929'),
        ('1930'),
        ('1933'),
        ('1937'),
        ('1945'),
        ('1948'),
        ('1950'),
        ('1952'),
        ('1961'),
        ('1964'),
        ('1971'),
        ('1979'),
        ('1982'),
        ('1984'),
        ('1991'),
        ('1992'),
        ('1993'),
        ('1997'),
        ('2003'),
        ('2004'),
        ('2008'),
        ('2014'),
        ('2021'),
        ('2022'),
        ('2062'),
        ('2069'),
        ('2086'),
        ('2091'),
        ('2097'),
        ('2098'),
        ('2103'),
        ('2104'),
        ('2105'),
        ('2107'),
        ('2110'),
        ('2111'),
        ('2113'),
        ('2114'),
        ('2115'),
        ('2116'),
        ('2119'),
        ('2120'),
        ('2121'),
        ('2122'),
        ('2123'),
        ('2126'),
        ('2127'),
        ('2129'),
        ('2131'),
        ('2132'),
        ('2134'),
        ('2135'),
        ('2136'),
        ('2137'),
        ('2138'),
        ('2142'),
        ('2143'),
        ('2144'),
        ('2145'),
        ('2148'),
        ('2149'),
        ('2150'),
        ('2151'),
        ('2152'),
        ('2153'),
        ('2155'),
        ('2156'),
        ('2157'),
        ('2159'),
        ('2161'),
        ('2162'),
        ('2164'),
        ('2166'),
        ('2167'),
        ('2168'),
        ('2170'),
        ('2171'),
        ('2172'),
        ('2173'),
        ('2175'),
        ('2176'),
        ('2177'),
        ('2178'),
        ('2179'),
        ('2181'),
        ('2182'),
        ('2183'),
        ('2186'),
        ('2188'),
        ('2189'),
        ('2190'),
        ('2191'),
        ('2193'),
        ('2194'),
        ('2195'),
        ('2196'),
        ('2197'),
        ('2198'),
        ('2201'),
        ('2202'),
        ('2204'),
        ('2207'),
        ('2208'),
        ('2209'),
        ('2210'),
        ('2212'),
        ('2213'),
        ('2215'),
        ('2218'),
        ('2222'),
        ('2227'),
        ('2228'),
        ('2233'),
        ('2234'),
        ('2236'),
        ('2242'),
        ('2246'),
        ('2247'),
        ('2248'),
        ('2249'),
        ('2250'),
        ('2252'),
        ('2253'),
        ('2254'),
        ('2257'),
        ('2258'),
        ('2264'),
        ('2265'),
        ('2266'),
        ('2269'),
        ('2272'),
        ('2275'),
        ('2279'),
        ('2282'),
        ('2283'),
        ('2284'),
        ('2286'),
        ('2300'),
        ('2376'),
        ('2377'),
        ('2409'),
        ('2433'),
        ('2439'),
        ('2441'),
        ('2448'),
        ('2449'),
        ('2451'),
        ('2452'),
        ('2456'),
        ('2460'),
        ('2463'),
        ('2470'),
        ('2471'),
        ('2473'),
        ('2474'),
        ('2475'),
        ('2476'),
        ('2485'),
        ('2486'),
        ('2492'),
        ('2493'),
        ('2494'),
        ('2496'),
        ('2497'),
        ('2498'),
        ('2500'),
        ('2501'),
        ('2510'),
        ('2512'),
        ('2517'),
        ('2533'),
        ('2537'),
        ('2542'),
        ('2545'),
        ('2546'),
        ('2549'),
        ('2554'),
        ('2557'),
        ('2559'),
        ('2560'),
        ('2562'),
        ('2563'),
        ('2564'),
        ('2568'),
        ('2580'),
        ('2581'),
        ('2583'),
        ('2586'),
        ('2588'),
        ('2589'),
        ('2590'),
        ('2591'),
        ('2592'),
        ('2594'),
        ('2599'),
        ('2601'),
        ('2609'),
        ('2610'),
        ('2616'),
        ('2618'),
        ('2620'),
        ('2624'),
        ('2626'),
        ('2628'),
        ('2631'),
        ('2637'),
        ('2639'),
        ('2643'),
        ('2645'),
        ('2646'),
        ('2647'),
        ('2648'),
        ('2649'),
        ('2655'),
        ('2660'),
        ('2661'),
        ('2664'),
        ('2667'),
        ('2668'),
        ('2670'),
        ('2671'),
        ('2680'),
        ('2691'),
        ('2693'),
        ('2694'),
        ('2698'),
        ('2700'),
        ('2701'),
        ('2702'),
        ('2710'),
        ('2713'),
        ('2721'),
        ('2724'),
        ('2725'),
        ('2747'),
        ('2748'),
        ('2749'),
        ('2756'),
        ('2761'),
        ('2762'),
        ('2789'),
        ('2792'),
        ('2801'),
        ('2802'),
        ('2804'),
        ('2805'),
        ('2806'),
        ('2807'),
        ('2808'),
        ('2812'),
        ('2860'),
        ('2861'),
        ('2862'),
        ('2863'),
        ('2875'),
        ('2876'),
        ('2894'),
        ('2900'),
        ('2919'),
        ('2921'),
        ('2927'),
        ('2928'),
        ('2933'),
        ('2962'),
        ('2963'),
        ('2965'),
        ('2966'),
        ('3215'),
        ('3252'),
        ('3253'),
        ('3255'),
        ('3259'),
        ('3261'),
        ('3272'),
        ('3274'),
        ('3277'),
        ('3281'),
        ('3289'),
        ('3290'),
        ('3311'),
        ('3312'),
        ('3313'),
        ('3314'),
        ('3315'),
        ('3317'),
        ('3337'),
        ('3340'),
        ('3342'),
        ('3343'),
        ('3347'),
        ('3363'),
        ('3375'),
        ('3378'),
        ('3379'),
        ('3383'),
        ('3385'),
        ('3388'),
        ('3390'),
        ('3392'),
        ('3393'),
        ('3395'),
        ('3396'),
        ('3397'),
        ('3398'),
        ('3399'),
        ('3400'),
        ('3401'),
        ('3402'),
        ('3403'),
        ('3412'),
        ('3433'),
        ('3445'),
        ('3446'),
        ('3457'),
        ('3458'),
        ('3461'),
        ('3464'),
        ('3469'),
        ('3470'),
        ('3479'),
        ('3493'),
        ('3497'),
        ('3498'),
        ('3501'),
        ('3502'),
        ('3504'),
        ('3505'),
        ('3514'),
        ('3517'),
        ('3520'),
        ('3521'),
        ('3523'),
        ('3524'),
        ('3527'),
        ('3528'),
        ('3535'),
        ('3536'),
        ('3537'),
        ('3540'),
        ('3543'),
        ('3549'),
        ('3556'),
        ('3563'),
        ('3569'),
        ('3570'),
        ('3576'),
        ('3581'),
        ('3592'),
        ('3593'),
        ('3595'),
        ('3597'),
        ('3606'),
        ('3611'),
        ('3628'),
        ('3631'),
        ('3643'),
        ('3652'),
        ('3660'),
        ('3664'),
        ('3668'),
        ('3671'),
        ('3675'),
        ('3683'),
        ('3692'),
        ('3694'),
        ('3695'),
        ('3697'),
        ('3723'),
        ('3730'),
        ('3738'),
        ('3748'),
        ('3760'),
        ('3785'),
        ('3789'),
        ('3798'),
        ('4079'),
        ('4080'),
        ('4081'),
        ('4082'),
        ('4083'),
        ('4086'),
        ('4087'),
        ('4088'),
        ('4089'),
        ('4090'),
        ('4091'),
        ('4092'),
        ('4093'),
        ('4096'),
        ('4097'),
        ('4107'),
        ('4108'),
        ('4109'),
        ('4110'),
        ('4111'),
        ('4112'),
        ('4113'),
        ('4114'),
        ('4115'),
        ('4116'),
        ('4117'),
        ('4118'),
        ('4130'),
        ('4131'),
        ('4134'),
        ('4135'),
        ('4136'),
        ('4137'),
        ('4138'),
        ('4139'),
        ('4140'),
        ('4141'),
        ('4142'),
        ('4143'),
        ('4144'),
        ('4145'),
        ('4146'),
        ('4153'),
        ('4154'),
        ('4158'),
        ('4159'),
        ('4160'),
        ('4161'),
        ('4162'),
        ('4163'),
        ('4164'),
        ('4165'),
        ('4166'),
        ('4167'),
        ('4172'),
        ('4174'),
        ('4176'),
        ('4177'),
        ('4178'),
        ('4179'),
        ('4180'),
        ('4181'),
        ('4182'),
        ('4183'),
        ('4185'),
        ('4195'),
        ('4196'),
        ('4198'),
        ('4199'),
        ('4200'),
        ('4201'),
        ('4202'),
        ('4203'),
        ('4204'),
        ('4205'),
        ('4207'),
        ('4212'),
        ('4213'),
        ('4214'),
        ('4215'),
        ('4216'),
        ('4224'),
        ('4227'),
        ('4228'),
        ('4231'),
        ('4232'),
        ('4233'),
        ('4234'),
        ('4235'),
        ('4236'),
        ('4237'),
        ('4239'),
        ('4241'),
        ('4251'),
        ('4255'),
        ('4257'),
        ('4258'),
        ('4259'),
        ('4274'),
        ('4275'),
        ('4279'),
        ('4281'),
        ('4285'),
        ('4286'),
        ('4287'),
        ('4290'),
        ('4292'),
        ('4306'),
        ('4314'),
        ('4395'),
        ('4414'),
        ('4425'),
        ('4426'),
        ('4427'),
        ('4431'),
        ('4432'),
        ('4439'),
        ('4441'),
        ('4445'),
        ('4447'),
        ('4451'),
        ('4456'),
        ('4458'),
        ('4462'),
        ('4465'),
        ('4468'),
        ('4470'),
        ('4473'),
        ('4474'),
        ('4477'),
        ('4479'),
        ('4481'),
        ('4484'),
        ('4491'),
        ('4492'),
        ('4495'),
        ('4501'),
        ('4502'),
        ('4503'),
        ('4505'),
        ('4507'),
        ('4509'),
        ('4518'),
        ('4519'),
        ('4523'),
        ('4525'),
        ('4526'),
        ('4527'),
        ('4528'),
        ('4531'),
        ('4532'),
        ('4536'),
        ('4539'),
        ('4544'),
        ('4550'),
        ('4556'),
        ('4834'),
        ('4835'),
        ('4837'),
        ('4855'),
        ('4862'),
        ('4865'),
        ('4867'),
        ('4868'),
        ('4870'),
        ('4871'),
        ('4873'),
        ('4875'),
        ('4889'),
        ('4890'),
        ('4891'),
        ('4894'),
        ('4895'),
        ('4897'),
        ('4900'),
        ('4902'),
        ('4903'),
        ('4908'),
        ('4909'),
        ('4912'),
        ('4913'),
        ('4915'),
        ('4916'),
        ('4917'),
        ('4918'),
        ('4920'),
        ('4921'),
        ('4922'),
        ('4923'),
        ('4924'),
        ('4926'),
        ('4927'),
        ('4928'),
        ('4929'),
        ('4930'),
        ('4935'),
        ('4936'),
        ('4937'),
        ('4938'),
        ('4939'),
        ('4940'),
        ('4941'),
        ('4942'),
        ('4943'),
        ('4947'),
        ('4948'),
        ('4951'),
        ('4952'),
        ('4953'),
        ('4954'),
        ('4955'),
        ('4956'),
        ('4957'),
        ('4958'),
        ('4959'),
        ('4961'),
        ('4962'),
        ('4964'),
        ('4965'),
        ('4966'),
        ('4971'),
        ('4972'),
        ('4973'),
        ('4975'),
        ('4978'),
        ('4980'),
        ('4981'),
        ('4982'),
        ('4983'),
        ('4984'),
        ('4987'),
        ('4989')

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.freight_distribution_hub', 'MS_Description', 'table to hold series 13 TAZs identified as freight distribution hubs'
    EXECUTE [db_meta].[add_xp] 'fed_rtp_20.freight_distribution_hub.taz_13', 'MS_Description', 'series 13 TAZ geography zones'
END
GO




-- create table holding results of fed_rtp_20 Performance Measures ----------------
DROP TABLE IF EXISTS [fed_rtp_20].[pm_results]
/**	
summary:   >
    Creates table holding results from 2020 Federal RTP Performance
    Measures. This holds all outputs except for interim results used as inputs
    for other processes from:
        [fed_rtp_20].[sp_particulate_matter_ctemfac_2014]
        [fed_rtp_20].[sp_particulate_matter_ctemfac_2017]
        [fed_rtp_20].[sp_pm_3ab_pmt_bmt]
        [fed_rtp_20].[sp_pm_3ab_vmt]
        [fed_rtp_20].[sp_pm_5a_hf_transit_stops]
        [fed_rtp_20].[sp_pm_G_transit_stops]
        [fed_rtp_20].[sp_pm_7ab_destinations]
        [fed_rtp_20].[sp_pm_7ab_population]
**/
BEGIN
    -- create table to hold results of 2020 federal rtp peformance measures
	CREATE TABLE [fed_rtp_20].[pm_results] (
        [scenario_id] int NOT NULL,
		[performance_measure] nvarchar(50) NOT NULL,
        [metric] nvarchar(200) NOT NULL,
        [value] float NOT NULL,
        [updated_by] nvarchar(100) NOT NULL,
        [updated_date] smalldatetime NOT NULL,
		CONSTRAINT pk_pmresults PRIMARY KEY ([scenario_id], [performance_measure], [metric]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results', 'MS_Description', 'table to hold results for 2020 federal rtp performance measures'
    EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.scenario_id', 'MS_Description', 'ABM scenario in ABM database [dimension].[scenario]'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.performance_measure', 'MS_Description', 'name of the performance measure'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.metric', 'MS_Description', 'metric within the performance measure'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.value', 'MS_Description', 'value of the specified metric within the performance measure'
    EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.updated_by', 'MS_Description', 'SQL username who last updated the value of the specified metric within the performance measure'
    EXECUTE [db_meta].[add_xp] 'fed_rtp_20.pm_results.updated_date', 'MS_Description', 'date the value of the specified metric within the performance measure was last updated'
END
GO




-- creates table holding square representation of San Diego ------------------
IF NOT EXISTS (
    SELECT TOP 1
        [object_id]
    FROM
        [sys].[objects]
    WHERE
        [object_id] = OBJECT_ID('[fed_rtp_20].[particulate_matter_grid]')
        AND type = 'U'
)
BEGIN

/**	
summary:   >
    Creates table holding elements of a 100x100 square representation of the
    San Diego region. Each record in the table is a single square of the
    making up the entirety of a square San Diego region. Along with their 
    shape and centroid spatial attributes, each 100x100 square also contains
    the name of the Series 13 MGRA polygon that its centroid resides in. Note
    that 100x100 squares whose centroids do not fall within a Series 13 MGRA
    polygon are removed from the result. All spatial data uses EPSG: 2230.

    This table is used in conjunction with the functions
    [fed_rtp_20].[fn_particulate_matter_ctemfac_2014] and
    [fed_rtp_20].[fn_particulate_matter_ctemfac_2017] as well as the stored
    procedures [fed_rtp_20].[sp_particulate_matter_ctemfac_2014] and 
    [fed_rtp_20].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions: 
    - author: Gregor Schroeder, Ziying Ouyang, Rick Curry
      modification: create and translate to new abm database structure
      date: Spring 2018
**/

	RAISERROR('Note: Building [fed_rtp_20].[particulate_matter_grid] takes approximately one hour and 45 minutes at a 100x100 grid size', 0, 1) WITH NOWAIT;

    -- create table to hold representation of square San Diego region
    -- to be split into square polygons
	CREATE TABLE [fed_rtp_20].[particulate_matter_grid] (
		[id] int NOT NULL,
		[shape] geometry NOT NULL,
		[centroid] geometry NOT NULL,
		[mgra_13] nchar(20) NOT NULL,
		CONSTRAINT pk_particulatemattergrid PRIMARY KEY ([id]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.particulate_matter_grid', 'MS_Description', 'a square representation of the San Diego region broken into a square polygon grid'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.particulate_matter_grid.id', 'MS_Description', 'particulate_matter_grid surrogate key'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.particulate_matter_grid.shape', 'MS_Description', 'geometry representation of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.particulate_matter_grid.centroid', 'MS_Description', 'geometry representation of centroid of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'fed_rtp_20.particulate_matter_grid.mgra_13', 'MS_Description', 'the mgra_13 number that contains the square polygon''s centroid'


	-- define the square region to be split into square polygons
	-- ((x_min, y_min), (x_max, y_min), (x_max, y_max), (x_min, y_max))
	-- calculate by taking the envelope of the San Diego Region 2004 polygon
	-- and finding its minimum/maximum latitudes and longitudes
	DECLARE @x_min int = 6150700
	DECLARE @x_max int = 6613500
	DECLARE @y_min int = 1775300
	DECLARE @y_max int = 2129800

	-- create spatial index for the table on the [centroid] attribute
	-- use the square region bounding box of the San Diego region
	-- have to hardcode the bounding box, should match above variables
	SET QUOTED_IDENTIFIER ON; -- set this option for sqlcmd execution
	CREATE SPATIAL INDEX
        spix_particulatemattergrid_centroid
	ON
        [fed_rtp_20].[particulate_matter_grid]([centroid])
    USING
        GEOMETRY_GRID
	WITH (
		BOUNDING_BOX = (xmin=6150700,
                        ymin=1775300,
                        xmax=6613500,
                        ymax=2129800),
		GRIDS = (LOW, LOW, MEDIUM, HIGH),
		CELLS_PER_OBJECT = 64,
		DATA_COMPRESSION = PAGE)

	-- declare size of square polygons to split square region into
    -- 100x100 is currently the agreed upon size
    -- this is noted in the documentation
	DECLARE @grid_size int = 100

	-- build individual polygons for the square region
	DECLARE @x_tracker int = @x_min
	DECLARE @counter int = 0

	WHILE @x_tracker < @x_max
	BEGIN
		DECLARE @y_tracker int = @y_min;
		WHILE @y_tracker < @y_max
		BEGIN
			SET @counter = @counter + 1;
			DECLARE @cell geometry
			DECLARE @centroid geometry
			DECLARE @mgra_13 nchar(20);
			-- build polygon assuming EPSG: 2230
			SET @cell = geometry::STPolyFromText('POLYGON((' + CONVERT(nvarchar, @x_tracker) + ' ' +CONVERT(nvarchar, @y_tracker) + ',' +
															   CONVERT(nvarchar, (@x_tracker + @grid_size)) + ' ' + CONVERT(nvarchar, @y_tracker) + ',' +
															   CONVERT(nvarchar, (@x_tracker + @grid_size)) + ' ' + CONVERT(nvarchar, (@y_tracker + @grid_size)) + ',' +
															   CONVERT(nvarchar, @x_tracker) + ' ' + CONVERT(nvarchar, (@y_tracker + @grid_size)) + ',' +
															   CONVERT(nvarchar, @x_tracker) + ' ' + CONVERT(nvarchar, @y_tracker) + '))', 2230)
			SET @centroid = @cell.STCentroid()

			INSERT INTO [fed_rtp_20].[particulate_matter_grid] (
                [id], [shape], [centroid], [mgra_13]
            )
			VALUES (@counter, @cell, @centroid, 'Not Applicable')

			SET @y_tracker = @y_tracker + @grid_size;
		END
		SET @x_tracker = @x_tracker + @grid_size;
	END


	-- get xref of grid cell to mgra_13
	UPDATE [fed_rtp_20].[particulate_matter_grid]
	SET [particulate_matter_grid].[mgra_13] = [mgras].[mgra_13]
	FROM
        -- this join is considerably sped up by forcing the query to use 
        -- the spatial index in its query plan
		[fed_rtp_20].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
	INNER JOIN (
		SELECT
			[mgra_13]
			,[mgra_13_shape]
		FROM
			[dimension].[geography]
		WHERE
			[mgra_13] != 'Not Applicable') AS [mgras]
	ON
		[particulate_matter_grid].[centroid].STWithin([mgra_13_shape]) = 1

	-- remove grid cells that do not match to a mgra_13
	DELETE FROM [fed_rtp_20].[particulate_matter_grid] WHERE [mgra_13] = 'Not Applicable'
END
GO




-- create function to calculate link-level particulate matter for EMFAC 2014 -
DROP FUNCTION IF EXISTS [fed_rtp_20].[fn_particulate_matter_ctemfac_2014]
GO

CREATE FUNCTION [fed_rtp_20].[fn_particulate_matter_ctemfac_2014]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Calculate link level emissions for particulate matter for a given ABM
    scenario. Exhaust calculation based on EMFAC 2017 User Guide page 12.
    https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf

    Relies on the ctemfac_2014 database existing in the SQL environment, the
    port of the EMFAC 2014 Access database to SQL Server.

    Similar to [abm_13_2_3].[abm].[ctemfac11_particulate_matter_10]
    stored procedure originally created by Clint Daniels and Ziying Ouyang.

    This function is used in conjunction with the table
    [fed_rtp_20].[particulate_matter_grid] and the stored
    procedure [fed_rtp_20].[sp_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate emissions for EMFAC 2014.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: added Idling Exhaust
      date: May 2019
    - author: Gregor Schroeder
      modification: included particulate matter 10, corrected error
        in tire brake wear left outer join that resulted in double-counting of
        link-level running exhaust emissions, removed running loss calculation
        as no particulate matter 2.5 or 10 exists
      date: May 2019
    - author: Gregor Schroeder and Ziying Ouyang
      modification: create and translate to new abm database structure
      date: 10 July 2018
**/
    with [running_exhaust] AS (
        SELECT
	        [Category].[Name] AS [CategoryName]
	        ,[RunningExhaust].[Speed]
	        ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
        FROM
	        [ctemfac_2014].[dbo].[RunningExhaust]
        INNER JOIN
	        [ctemfac_2014].[dbo].[Pollutant]
        ON
	        [RunningExhaust].[PollutantID] = [Pollutant].[PollutantID]
        INNER JOIN
	        [ctemfac_2014].[dbo].[Category]
        ON
	        [RunningExhaust].[CategoryID] = [Category].[CategoryID]
        WHERE
	        [RunningExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2014].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [RunningExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2014].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
	        AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]
	        ,[RunningExhaust].[Speed]),
    [tire_brake_wear] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM10]
	    FROM
		    [ctemfac_2014].[dbo].[TireBrakeWear]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Pollutant]
	    ON
		    [TireBrakeWear].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Category]
	    ON
		    [TireBrakeWear].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [TireBrakeWear].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2014].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [TireBrakeWear].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2014].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [idling_exhaust] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [IdlingExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [IdlingExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
	    FROM
		    [ctemfac_2014].[dbo].[IdlingExhaust]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Pollutant]
	    ON
		    [IdlingExhaust].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Category]
	    ON
		    [IdlingExhaust].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [IdlingExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2014].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [IdlingExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2014].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] IN ('Light Heavy Duty Truck (Non-Toll)',
													    'Light Heavy Duty Truck (Toll)')
				    THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck (Non-Toll)',
													    'Medium Heavy Duty Truck (Toll)',
													    'Heavy Heavy Duty Truck (Non-Toll)',
													    'Heavy Heavy Duty Truck (Toll)')
				    THEN 'Truck 2'
				    ELSE 'Non-truck' END AS [CategoryName]
		    -- create lower bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5
				    END AS [speed_bin_low]
		    -- create upper bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1)
				    END AS [speed_bin_high]
		    ,[hwy_flow].[speed]
		    ,[hwy_flow_mode].[flow] * [hwy_link].[length_mile] AS [vmt]
	    FROM
		    [fact].[hwy_flow_mode]
	    INNER JOIN
		    [fact].[hwy_flow]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
	    INNER JOIN
		    [dimension].[hwy_link]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	    INNER JOIN
		    [dimension].[mode]
	    ON
		    [hwy_flow_mode].[mode_id] = [mode].[mode_id]
	    INNER JOIN
		    [dimension].[time]
	    ON
		    [hwy_flow_mode].[time_id] = [time].[time_id]
	    WHERE
		    [hwy_flow_mode].[scenario_id] = @scenario_id
		    AND [hwy_flow].[scenario_id] = @scenario_id
		    AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_flow_mode].[flow] * [hwy_link].[length_mile] > 0),
    [link_emissions] AS (
        SELECT
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id]
            -- stratify by particulate matter 2.5 and 10
	        -- running exhaust calculation based on EMFAC 2017 User Guide page 12
	        -- https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM25] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM25] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM25], 0)) AS [tire_brake_wear_PM25]
            ,SUM(ISNULL([travel].[vmt] * [idling_exhaust].[Value_PM25], 0)) AS [idling_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
            ,SUM(ISNULL([travel].[vmt] * [idling_exhaust].[Value_PM10], 0)) AS [idling_exhaust_PM10]
        FROM
	        [travel]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_low]
        ON
	        [travel].[CategoryName] = [running_exhaust_low].[CategoryName]
	        AND [travel].[speed_bin_low] = [running_exhaust_low].[Speed]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_high]
        ON
	        [travel].[CategoryName] = [running_exhaust_high].[CategoryName]
	        AND [travel].[speed_bin_high] = [running_exhaust_high].[Speed]
        LEFT OUTER JOIN
	        [tire_brake_wear]
        ON
	        [travel].[CategoryName] = [tire_brake_wear].[CategoryName]
	    LEFT OUTER JOIN
	        [idling_exhaust]
        ON
	        [travel].[CategoryName] = [idling_exhaust].[CategoryName]
        GROUP BY
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id])
    SELECT
        @scenario_id AS [scenario_id]
	    ,[hwy_link_id]
	    ,[hwycov_id]
        ,[running_exhaust_PM25]
        ,[running_exhaust_PM10]
	    ,[running_exhaust_PM25] + [running_exhaust_PM10] AS [running_exhaust]
	    ,[tire_brake_wear_PM25]
        ,[tire_brake_wear_PM10]
        ,[tire_brake_wear_PM25] + [tire_brake_wear_PM10] AS [tire_brake_wear]
        ,[idling_exhaust_PM25]
        ,[idling_exhaust_PM10]
        ,[idling_exhaust_PM25] + [idling_exhaust_PM10] AS [idling_exhaust]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [idling_exhaust_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] +
	        [idling_exhaust_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [idling_exhaust_PM25] + [running_exhaust_PM10] +
	        [tire_brake_wear_PM10] + [idling_exhaust_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [fed_rtp_20].[fn_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.fn_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2014'
GO




-- create function to calculate link-level particulate matter for EMFAC 2017 -
DROP FUNCTION IF EXISTS [fed_rtp_20].[fn_particulate_matter_ctemfac_2017]
GO

CREATE FUNCTION [fed_rtp_20].[fn_particulate_matter_ctemfac_2017]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Calculate link level emissions for particulate matter for a given ABM
    scenario. Exhaust calculation based on EMFAC 2017 User Guide page 12.
    https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf

    Relies on the ctemfac_2017 database existing in the SQL environment, the
    port of the EMFAC 2017 Access database to SQL Server.

    Similar to [abm_13_2_3].[abm].[ctemfac11_particulate_matter_10]
    stored procedure originally created by Clint Daniels and Ziying Ouyang.

    This function is used in conjunction with the table
    [fed_rtp_20].[particulate_matter_grid] and the stored
    procedure [fed_rtp_20].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate emissions for EMFAC 2017.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: added Idling Exhaust
      date: May 2019
    - author: Gregor Schroeder
      modification: included particulate matter 10, corrected error
        in tire brake wear left outer join that resulted in double-counting of
        link-level running exhaust emissions, removed running loss calculation
        as no particulate matter 2.5 or 10 exists
      date: May 2019
    - author: Gregor Schroeder and Ziying Ouyang
      modification: create and translate to new abm database structure
      date: 10 July 2018
**/
    with [running_exhaust] AS (
        SELECT
	        [Category].[Name] AS [CategoryName]
	        ,[RunningExhaust].[Speed]
	        ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
            ,SUM([RunningExhaust].[Value]) AS [Value]
        FROM
	        [ctemfac_2017].[dbo].[RunningExhaust]
        INNER JOIN
	        [ctemfac_2017].[dbo].[Pollutant]
        ON
	        [RunningExhaust].[PollutantID] = [Pollutant].[PollutantID]
        INNER JOIN
	        [ctemfac_2017].[dbo].[Category]
        ON
	        [RunningExhaust].[CategoryID] = [Category].[CategoryID]
        WHERE
	        [RunningExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2017].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [RunningExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2017].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
	        AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]
	        ,[RunningExhaust].[Speed]),
    [tire_brake_wear] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM10]
            ,SUM([TireBrakeWear].[Value]) AS [Value]
	    FROM
		    [ctemfac_2017].[dbo].[TireBrakeWear]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Pollutant]
	    ON
		    [TireBrakeWear].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Category]
	    ON
		    [TireBrakeWear].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [TireBrakeWear].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2017].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [TireBrakeWear].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2017].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [idling_exhaust] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [IdlingExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [IdlingExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
            ,SUM([IdlingExhaust].[Value]) AS [Value]
	    FROM
		    [ctemfac_2017].[dbo].[IdlingExhaust]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Pollutant]
	    ON
		    [IdlingExhaust].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Category]
	    ON
		    [IdlingExhaust].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [IdlingExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2017].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [IdlingExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2017].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] IN ('Light Heavy Duty Truck (Non-Toll)',
													    'Light Heavy Duty Truck (Toll)')
				    THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck (Non-Toll)',
													    'Medium Heavy Duty Truck (Toll)',
													    'Heavy Heavy Duty Truck (Non-Toll)',
													    'Heavy Heavy Duty Truck (Toll)')
				    THEN 'Truck 2'
				    ELSE 'Non-truck' END AS [CategoryName]
		    -- create lower bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5
				    END AS [speed_bin_low]
		    -- create upper bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1)
				    END AS [speed_bin_high]
		    ,[hwy_flow].[speed]
		    ,[hwy_flow_mode].[flow] * [hwy_link].[length_mile] AS [vmt]
	    FROM
		    [fact].[hwy_flow_mode]
	    INNER JOIN
		    [fact].[hwy_flow]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
	    INNER JOIN
		    [dimension].[hwy_link]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	    INNER JOIN
		    [dimension].[mode]
	    ON
		    [hwy_flow_mode].[mode_id] = [mode].[mode_id]
	    INNER JOIN
		    [dimension].[time]
	    ON
		    [hwy_flow_mode].[time_id] = [time].[time_id]
	    WHERE
		    [hwy_flow_mode].[scenario_id] = @scenario_id
		    AND [hwy_flow].[scenario_id] = @scenario_id
		    AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_flow_mode].[flow] * [hwy_link].[length_mile] > 0),
    [link_emissions] AS (
        SELECT
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id]
            -- stratify by particulate matter 2.5 and 10
	        -- running exhaust calculation based on EMFAC 2017 User Guide page 12
	        -- https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM25] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM25] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM25], 0)) AS [tire_brake_wear_PM25]
            ,SUM(ISNULL([travel].[vmt] * [idling_exhaust].[Value_PM25], 0)) AS [idling_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
            ,SUM(ISNULL([travel].[vmt] * [idling_exhaust].[Value_PM10], 0)) AS [idling_exhaust_PM10]
        FROM
	        [travel]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_low]
        ON
	        [travel].[CategoryName] = [running_exhaust_low].[CategoryName]
	        AND [travel].[speed_bin_low] = [running_exhaust_low].[Speed]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_high]
        ON
	        [travel].[CategoryName] = [running_exhaust_high].[CategoryName]
	        AND [travel].[speed_bin_high] = [running_exhaust_high].[Speed]
        LEFT OUTER JOIN
	        [tire_brake_wear]
        ON
	        [travel].[CategoryName] = [tire_brake_wear].[CategoryName]
	    LEFT OUTER JOIN
	        [idling_exhaust]
        ON
	        [travel].[CategoryName] = [idling_exhaust].[CategoryName]
        GROUP BY
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id])
    SELECT
        @scenario_id AS [scenario_id]
	    ,[hwy_link_id]
	    ,[hwycov_id]
        ,[running_exhaust_PM25]
        ,[running_exhaust_PM10]
	    ,[running_exhaust_PM25] + [running_exhaust_PM10] AS [running_exhaust]
	    ,[tire_brake_wear_PM25]
        ,[tire_brake_wear_PM10]
        ,[tire_brake_wear_PM25] + [tire_brake_wear_PM10] AS [tire_brake_wear]
        ,[idling_exhaust_PM25]
        ,[idling_exhaust_PM10]
        ,[idling_exhaust_PM25] + [idling_exhaust_PM10] AS [idling_exhaust]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [idling_exhaust_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] +
	        [idling_exhaust_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [idling_exhaust_PM25] + [running_exhaust_PM10] +
	        [tire_brake_wear_PM10] + [idling_exhaust_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [fed_rtp_20].[fn_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.fn_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2017'
GO




-- create stored procedure to calculate 
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_particulate_matter_ctemfac_2014]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_particulate_matter_ctemfac_2014]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@distance integer = 1000,  -- maximum distance of emissions exposure in feet
	@shoulder_width integer = 10  -- width of road shoulder in feet
AS
/**
summary:   >
     Calculate person-level exposure to particulate matter for a given ABM
     scenario. Returns both total and average per person exposure to tons of
     particulate matter 2.5 and 10 emissions for the total population and
     within Community of Concern groups.

    This stored procedure is used in conjunction with the table
    [fed_rtp_20].[particulate_matter_grid] and the function
    [fed_rtp_20].[fn_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [fed_rtp_20].[fn_particulate_matter_ctemfac_2014] function
      date: 8 May 2019
    - author: Gregor Schroeder
      modification: create and translate to new abm database structure
      date: 12 July 2018
**/
SET NOCOUNT ON;

-- create temporary table of the xref between the highway network and the
-- 100x100 square grid representation of San Diego County
SELECT
	[particulate_matter_grid].[id]
	,[hwy_link_lanes].[hwy_link_id]
	,[hwy_link_lanes].[hwycov_id]
	,CASE	WHEN [hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid])
	            - @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12 <= 0
		    THEN 100
		    ELSE CEILING(([hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid]) -
		        @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12) / 100.0) * 100
		    END AS [interval]
	INTO #xref_grid_hwycov
FROM (
	SELECT
		[hwy_link].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,CONVERT(integer,
				CASE	WHEN [hwy_link].[iway] = 2
						THEN [ln_max] * 2
						ELSE [ln_max] END) AS [lanes]
		,[hwy_link].[shape].MakeValid() AS [shape]
	FROM
		[dimension].[hwy_link]
	INNER JOIN (
		SELECT
			[hwy_link_id]
			,MAX([ln]) AS [ln_max]
		FROM
			[dimension].[hwy_link_ab_tod]
		WHERE
			[scenario_id] = @scenario_id
			AND [ln] < 9 -- this coding means lane unavailable
		GROUP BY
			[hwy_link_id]) AS [link_ln_max]
	ON
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[hwy_link_id] = [link_ln_max].[hwy_link_id]
	WHERE
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[ifc] < 10) AS [hwy_link_lanes]
INNER JOIN
	[fed_rtp_20].[particulate_matter_grid] WITH(INDEX(spix_particulatematter25grid_centroid))
ON
	[particulate_matter_grid].[centroid].STWithin([hwy_link_lanes].[shape].STBuffer(@distance + @shoulder_width + CEILING([hwy_link_lanes].[lanes] / 2.0) * 12)) = 1;


-- use the highway network to grid xref to output the final results
-- for Particulate Matter 2.5 and 10
with [grid_particulate_matter] AS (
-- for each (link, interval) tuple
-- calculate the link emissions at that interval/distance multiplied by 2 to assume symmetric emissions
-- assign the emissions uniformly to all the grids that the (link, interval) tuple is matched to
	SELECT
		#xref_grid_hwycov.[id]
        ,SUM([assigned_PM25]) AS [assigned_PM25]
        ,SUM([assigned_PM10]) AS [assigned_PM10]
		,SUM([assigned_PM]) AS [assigned_PM]
	FROM (
		SELECT
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
			,2 * [link_total_emissions_PM25] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM25]
            ,2 * [link_total_emissions_PM10] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM10]
            ,2 * [link_total_emissions] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM]
		FROM
			#xref_grid_hwycov
		INNER JOIN
			[fed_rtp_20].[fn_particulate_matter_ctemfac_2014](@scenario_id)
		ON
			#xref_grid_hwycov.[hwycov_id] = [fn_particulate_matter_ctemfac_2014].[hwycov_id]
		GROUP BY
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
            ,[link_total_emissions_PM25]
            ,[link_total_emissions_PM10]
			,[link_total_emissions]
		HAVING
			(COUNT([id]) / 2) / ([interval] / 100.0) > 0) AS [link_interval_emissions]
	INNER JOIN
		#xref_grid_hwycov
	ON
		#xref_grid_hwycov.[hwy_link_id] = [link_interval_emissions].[hwy_link_id]
		AND #xref_grid_hwycov.[interval] = [link_interval_emissions].[interval]
	INNER JOIN
		[fed_rtp_20].[particulate_matter_grid]
	ON
		#xref_grid_hwycov.[id] = [particulate_matter_grid].[id]
	GROUP BY
		#xref_grid_hwycov.[id]),
[mgra_13_particulate_matter] AS (
-- average the grid emissions within each mgra, grids are of equal size so average is ok
	SELECT
		[particulate_matter_grid].[mgra_13]
        ,AVG(ISNULL([assigned_PM25], 0)) AS [avg_PM25]
        ,AVG(ISNULL([assigned_PM10], 0)) AS [avg_PM10]
		,AVG(ISNULL([assigned_PM], 0)) AS [avg_PM]
	FROM
		[fed_rtp_20].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
	    [geography_household_location].[household_location_mgra_13]
	    ,SUM([fn_person_coc].[weight_person]) AS [persons]
	    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [senior]
	    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_senior]
        ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [minority]
	    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_minority]
        ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [low_income]
	    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_low_income]
    FROM
	    [fed_rtp_20].[fn_person_coc] (@scenario_id)
    INNER JOIN
	    [dimension].[household]
    ON
	    [fn_person_coc].[scenario_id] = [household].[scenario_id]
	    AND [fn_person_coc].[household_id] = [household].[household_id]
    INNER JOIN
	    [dimension].[geography_household_location] -- this is at the mgra_13 level
    ON
	    [household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
    WHERE
	    [fn_person_coc].[scenario_id] = @scenario_id
	    AND [household].[scenario_id] = @scenario_id
    GROUP BY
	    [geography_household_location].[household_location_mgra_13])
SELECT
    [Particulate Matter]
    ,[Population]
    ,[Total Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) AS [non_low_income_PM]
    FROM
	    [population]
    LEFT OUTER JOIN
	    [mgra_13_particulate_matter]
    ON
	    [population].[household_location_mgra_13] = [mgra_13_particulate_matter].[mgra_13]
) AS [tt]
CROSS APPLY (
    VALUES ('Particulate Matter 2.5', 'Total', [person_PM25]),
           ('Particulate Matter 10', 'Total', [person_PM10]),
           ('Particulate Matter 2.5 and 10', 'Total', [person_PM]),
           ('Particulate Matter 2.5', 'Senior', [senior_PM25]),
           ('Particulate Matter 10', 'Senior', [senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Senior', [senior_PM]),
           ('Particulate Matter 2.5', 'Non-Senior', [non_senior_PM25]),
           ('Particulate Matter 10', 'Non-Senior', [non_senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Senior', [non_senior_PM]),
           ('Particulate Matter 2.5', 'Minority', [minority_PM25]),
           ('Particulate Matter 10', 'Minority', [minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Minority', [minority_PM]),
           ('Particulate Matter 2.5', 'Non-Minority', [non_minority_PM25]),
           ('Particulate Matter 10', 'Non-Minority', [non_minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Minority', [non_minority_PM]),
           ('Particulate Matter 2.5', 'Low Income', [low_income_PM25]),
           ('Particulate Matter 10', 'Low Income', [low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Low Income', [low_income_PM]),
           ('Particulate Matter 2.5', 'Non-Low Income', [non_low_income_PM25]),
           ('Particulate Matter 10', 'Non-Low Income', [non_low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Low Income', [non_low_income_PM]))
x([Particulate Matter],
  [Population],
  [Total Particulate Matter])
OPTION(MAXDOP 1)


-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [fed_rtp_20].[sp_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2014'
GO




-- create stored procedure to calculate
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_particulate_matter_ctemfac_2017]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_particulate_matter_ctemfac_2017]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@distance integer = 1000,  -- maximum distance of emissions exposure in feet
	@shoulder_width integer = 10  -- width of road shoulder in feet
AS
/**
summary:   >
     Calculate person-level exposure to particulate matter for a given ABM
     scenario. Returns both total and average per person exposure to tons of
     particulate matter 2.5 and 10 emissions for the total population and
     within Community of Concern groups.

    This stored procedure is used in conjunction with the table
    [fed_rtp_20].[particulate_matter_grid] and the function
    [fed_rtp_20].[fn_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [fed_rtp_20].[fn_particulate_matter_ctemfac_2017] function
      date: 8 May 2019
    - author: Gregor Schroeder
      modification: create and translate to new abm database structure
      date: 12 July 2018
**/
SET NOCOUNT ON;

-- create temporary table of the xref between the highway network and the
-- 100x100 square grid representation of San Diego County
SELECT
	[particulate_matter_grid].[id]
	,[hwy_link_lanes].[hwy_link_id]
	,[hwy_link_lanes].[hwycov_id]
	,CASE	WHEN [hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid])
	            - @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12 <= 0
		    THEN 100
		    ELSE CEILING(([hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid]) -
		        @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12) / 100.0) * 100
		    END AS [interval]
	INTO #xref_grid_hwycov
FROM (
	SELECT
		[hwy_link].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,CONVERT(integer,
				CASE	WHEN [hwy_link].[iway] = 2
						THEN [ln_max] * 2
						ELSE [ln_max] END) AS [lanes]
		,[hwy_link].[shape].MakeValid() AS [shape]
	FROM
		[dimension].[hwy_link]
	INNER JOIN (
		SELECT
			[hwy_link_id]
			,MAX([ln]) AS [ln_max]
		FROM
			[dimension].[hwy_link_ab_tod]
		WHERE
			[scenario_id] = @scenario_id
			AND [ln] < 9 -- this coding means lane unavailable
		GROUP BY
			[hwy_link_id]) AS [link_ln_max]
	ON
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[hwy_link_id] = [link_ln_max].[hwy_link_id]
	WHERE
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[ifc] < 10) AS [hwy_link_lanes]
INNER JOIN
	[fed_rtp_20].[particulate_matter_grid] WITH(INDEX(spix_particulatematter25grid_centroid))
ON
	[particulate_matter_grid].[centroid].STWithin([hwy_link_lanes].[shape].STBuffer(@distance + @shoulder_width + CEILING([hwy_link_lanes].[lanes] / 2.0) * 12)) = 1;


-- use the highway network to grid xref to output the final results
-- for Particulate Matter 2.5 and 10
with [grid_particulate_matter] AS (
-- for each (link, interval) tuple
-- calculate the link emissions at that interval/distance multiplied by 2 to assume symmetric emissions
-- assign the emissions uniformly to all the grids that the (link, interval) tuple is matched to
	SELECT
		#xref_grid_hwycov.[id]
        ,SUM([assigned_PM25]) AS [assigned_PM25]
        ,SUM([assigned_PM10]) AS [assigned_PM10]
		,SUM([assigned_PM]) AS [assigned_PM]
	FROM (
		SELECT
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
			,2 * [link_total_emissions_PM25] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM25]
            ,2 * [link_total_emissions_PM10] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM10]
            ,2 * [link_total_emissions] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM]
		FROM
			#xref_grid_hwycov
		INNER JOIN
			[fed_rtp_20].[fn_particulate_matter_ctemfac_2017](@scenario_id)
		ON
			#xref_grid_hwycov.[hwycov_id] = [fn_particulate_matter_ctemfac_2017].[hwycov_id]
		GROUP BY
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
            ,[link_total_emissions_PM25]
            ,[link_total_emissions_PM10]
			,[link_total_emissions]
		HAVING
			(COUNT([id]) / 2) / ([interval] / 100.0) > 0) AS [link_interval_emissions]
	INNER JOIN
		#xref_grid_hwycov
	ON
		#xref_grid_hwycov.[hwy_link_id] = [link_interval_emissions].[hwy_link_id]
		AND #xref_grid_hwycov.[interval] = [link_interval_emissions].[interval]
	INNER JOIN
		[fed_rtp_20].[particulate_matter_grid]
	ON
		#xref_grid_hwycov.[id] = [particulate_matter_grid].[id]
	GROUP BY
		#xref_grid_hwycov.[id]),
[mgra_13_particulate_matter] AS (
-- average the grid emissions within each mgra, grids are of equal size so average is ok
	SELECT
		[particulate_matter_grid].[mgra_13]
        ,AVG(ISNULL([assigned_PM25], 0)) AS [avg_PM25]
        ,AVG(ISNULL([assigned_PM10], 0)) AS [avg_PM10]
		,AVG(ISNULL([assigned_PM], 0)) AS [avg_PM]
	FROM
		[fed_rtp_20].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
	    [geography_household_location].[household_location_mgra_13]
	    ,SUM([fn_person_coc].[weight_person]) AS [persons]
	    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [senior]
	    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_senior]
        ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [minority]
	    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_minority]
        ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [low_income]
	    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                    THEN [fn_person_coc].[weight_person]
                    ELSE 0 END) AS [non_low_income]
    FROM
	    [fed_rtp_20].[fn_person_coc] (@scenario_id)
    INNER JOIN
	    [dimension].[household]
    ON
	    [fn_person_coc].[scenario_id] = [household].[scenario_id]
	    AND [fn_person_coc].[household_id] = [household].[household_id]
    INNER JOIN
	    [dimension].[geography_household_location] -- this is at the mgra_13 level
    ON
	    [household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
    WHERE
	    [fn_person_coc].[scenario_id] = @scenario_id
	    AND [household].[scenario_id] = @scenario_id
    GROUP BY
	    [geography_household_location].[household_location_mgra_13])
SELECT
    [Particulate Matter]
    ,[Population]
    ,[Total Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) AS [non_low_income_PM]
    FROM
	    [population]
    LEFT OUTER JOIN
	    [mgra_13_particulate_matter]
    ON
	    [population].[household_location_mgra_13] = [mgra_13_particulate_matter].[mgra_13]
) AS [tt]
CROSS APPLY (
    VALUES ('Particulate Matter 2.5', 'Total', [person_PM25]),
           ('Particulate Matter 10', 'Total', [person_PM10]),
           ('Particulate Matter 2.5 and 10', 'Total', [person_PM]),
           ('Particulate Matter 2.5', 'Senior', [senior_PM25]),
           ('Particulate Matter 10', 'Senior', [senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Senior', [senior_PM]),
           ('Particulate Matter 2.5', 'Non-Senior', [non_senior_PM25]),
           ('Particulate Matter 10', 'Non-Senior', [non_senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Senior', [non_senior_PM]),
           ('Particulate Matter 2.5', 'Minority', [minority_PM25]),
           ('Particulate Matter 10', 'Minority', [minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Minority', [minority_PM]),
           ('Particulate Matter 2.5', 'Non-Minority', [non_minority_PM25]),
           ('Particulate Matter 10', 'Non-Minority', [non_minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Minority', [non_minority_PM]),
           ('Particulate Matter 2.5', 'Low Income', [low_income_PM25]),
           ('Particulate Matter 10', 'Low Income', [low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Low Income', [low_income_PM]),
           ('Particulate Matter 2.5', 'Non-Low Income', [non_low_income_PM25]),
           ('Particulate Matter 10', 'Non-Low Income', [non_low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Low Income', [non_low_income_PM]))
x([Particulate Matter],
  [Population],
  [Total Particulate Matter])
OPTION(MAXDOP 1)

-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [fed_rtp_20].[sp_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2017'
GO




-- create function to return ABM population with CoC designations ------------
DROP FUNCTION IF EXISTS [fed_rtp_20].[fn_person_coc]
GO

CREATE FUNCTION [fed_rtp_20].[fn_person_coc]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Return table of ABM synthetic population for a given ABM scenario with
    Community of Concern (CoC) designations.
**/
SELECT
    @scenario_id AS [scenario_id]
	,[person].[person_id]
    ,[household].[household_id]
	,[person].[weight_person]
	,CASE   WHEN [person].[age] >= 75 
            THEN 'Senior'
            ELSE 'Non-Senior'
            END AS [senior]
	,CASE	WHEN [person].[race] IN ('Some Other Race Alone',
									    'Asian Alone',
									    'Black or African American Alone',
									    'Two or More Major Race Groups',
									    'Native Hawaiian and Other Pacific Islander Alone',
									    'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                    OR [person].[hispanic] = 'Hispanic'
            THEN 'Minority'
            ELSE 'Non-Minority'
            END AS [minority]
	,CASE   WHEN [household].[poverty] <= 2
            THEN 'Low Income'
            ELSE 'Non-Low Income'
            END AS [low_income]
FROM
	[dimension].[person]
INNER JOIN
	[dimension].[household]
ON
	[person].[scenario_id] = [household].[scenario_id]
	AND [person].[household_id] = [household].[household_id]
WHERE
	[person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
GO

-- add metadata for [fed_rtp_20].[fn_person_coc]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.fn_person_coc', 'MS_Description', 'return ABM synthetic population with Community of Concern (CoC) designations'
GO




-- create stored procedure for performance metric #1a ------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_1a]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_1a]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure 1A, Daily vehicle delay per capita
    (minutes). Formerly Performance Measure 1B in the 2015 rp, this is the
    sum of link level vehicle flows multiplied by the difference between
    congested and free flow travel time and then divided by the total
    synthetic population for a given ABM scenario.

filters:   >
    ([time] - ([tm] + [tx])) >= 0 
        remove 0 values from vehicle delay
    [hwy_flow].[tm] != 999
        remove missing values for the loaded highway travel time

revisions: 
    - author: Gregor Schroeder
      modification: translate to new abm database structure
      date: 6 Apr 2018
**/
SET NOCOUNT ON;


-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure 1a result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 1a'


    -- subquery for total synthetic population within a given abm scenario
    DECLARE @population integer = (
        SELECT
            SUM([weight_person])
        FROM
            [dimension].[person]
        WHERE
            [scenario_id] = @scenario_id
    )


    -- calculate vehicle delay per capita and insert into Performance Measures
    -- results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure 1a' AS [performance_measure]
        ,'Vehicle Delay per Capita' AS [metric]
	    ,SUM(([time] - ([tm] + [tx])) * [flow]) / @population AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    [fact].[hwy_flow]
    INNER JOIN
	    [dimension].[hwy_link_ab_tod]
    ON
	    [hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
	    AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
    WHERE
	    [hwy_flow].[scenario_id] = @scenario_id
	    AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
	    AND ([time] - ([tm] + [tx])) >= 0  -- remove 0 values from vehicle delay
	    AND [tm] != 999  -- remove missing values for the loaded highway travel time
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 1a';
GO

-- add metadata for [fed_rtp_20].[sp_pm_1a]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_1a', 'MS_Description', 'performance metric 1a'
GO




-- create stored procedure for performance metric #2a ------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_2a]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_2a]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 1,  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
	@uats bit = 0,  -- 1/0 switch to limit origin and destination geographies
        -- to UATS zones
	@work bit = 0  -- 1/0  switch to limit trip purpose to work
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure 2A, Percent of person-trips by mode
    with option to filter to work purpose trips (defined as direct home-work
    or work-home trips where the mode is determined by the SANDAG tour journey
    mode hierarchy) and/or to trip origins/destinations within the City of
    San Diego Urban Area Transit Strategy (UATS) districts for a given ABM
    scenario.

    Note this relies on the existence of [sql2014b8] GIS spatial tables:
        [lis].[gis].[UATS2014_DISSOLVED]
        [lis].[gis].[MGRA13_WEIGHTEDCENTROID]

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [purpose_trip_origin].[purpose_trip_origin_description] = ('Home', 'Work')
        part of AND condition used if option selected to filter trips to work purpose only
    [purpose_trip_destination].[purpose_trip_destination_description] = ('Home', 'Work')
        part of AND condition used if option selected to filter trips to work purpose only
    [geography_trip_origin].[trip_origin_mgra_13] satisfies condition
        [UATS2014_DISSOLVED].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1
        part of OR condition used if option selected to filter trips to UATS
        origins/destination only
    [geography_trip_destination].[trip_destination_mgra_13] satisfies condition
        [UATS2014_DISSOLVED].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1
        part of OR condition used if option selected to filter trips to UATS
        origins/destination only

revisions:
    - author: Gregor Schroeder
      modification: update to use sandag tour mode for work trip mode
        and LIS UATS tables
      date: 28 Feb 2019
    - author: Gregor Schroeder
      modification: create and translate to new abm database structure
      date: 3 Jan 2019
**/
SET NOCOUNT ON;

-- create name of the Performance Measure based on options selected
DECLARE @pm_name nvarchar(40)
IF(@uats = 0 AND @work = 0)
    SET @pm_name = 'Performance Measure 2a'
IF(@uats = 1 AND @work = 0)
    SET @pm_name = 'Performance Measure 2a - UATS'
IF(@uats = 0 AND @work = 1)
    SET @pm_name = 'Performance Measure 2a - Work'
IF(@uats = 1 AND @work = 1)
    SET @pm_name = 'Performance Measure 2a - UATS x Work'

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure 2a result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_name


    -- get the year of the ABM scenario
    DECLARE @year smallint = (
        SELECT
            [year]
        FROM
            [dimension].[scenario]
        WHERE
            [scenario_id] = @scenario_id
    )


    -- get Series 13 mgras with weighted centroids contained within the City of
    -- San Diego Urban Area Transit Strategy (UATS) districts
    -- using Series 13 mgras here as ABM Resident models operate at the Series 13
    -- mgra geography level (excepting Internal-External model external TAZs which
    -- all reside outside of UATS districts
    DECLARE @uats_mgras TABLE ([mgra] nchar(15) PRIMARY KEY NOT NULL)
    INSERT INTO @uats_mgras
    SELECT
        CONVERT(nchar, [mgra]) AS [mgra]
    FROM OPENQUERY(
	    [sql2014b8],
	    'SELECT
            [MGRA]
         FROM
            [lis].[gis].[UATS2014_DISSOLVED]
         INNER JOIN
            [lis].[gis].[MGRA13_WEIGHTEDCENTROID]
	     ON [UATS2014_DISSOLVED].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1');


    -- get person trips by mode
    -- for resident models only (Individual, Internal-External, Joint)
    -- potentially filtered by direct home-work, work-home purpose
    -- use SANDAG tour journey mode hierarchy if work purpose switch selected
    -- Series 13 MGRA in UATS district
    DECLARE @aggregated_trips TABLE (
	    [mode_aggregate_description] nchar(15) NOT NULL,
	    [person_trips] float NOT NULL
    )

    INSERT INTO @aggregated_trips
    SELECT
	    ISNULL(CASE    WHEN @work = 0 THEN
                         CASE    WHEN [mode_trip].[mode_aggregate_trip_description] IN
                                   ('School Bus',
                                    'Taxi',
                                    'Heavy Heavy Duty Truck',
                                    'Light Heavy Duty Truck',
                                    'Medium Heavy Duty Truck',
                                    'Parking Lot',
                                    'Pickup/Drop-off',
                                    'Rental car',
                                    'Shuttle/Van/Courtesy Vehicle')
                                  THEN 'Other'
                                  ELSE [mode_trip].[mode_aggregate_trip_description]
                                  END
                       WHEN @work = 1 THEN
                         CASE    WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN
                                   ('School Bus',
                                    'Taxi',
                                    'Heavy Heavy Duty Truck',
                                    'Light Heavy Duty Truck',
                                    'Medium Heavy Duty Truck',
                                    'Parking Lot',
                                    'Pickup/Drop-off',
                                    'Rental car',
                                    'Shuttle/Van/Courtesy Vehicle')
                                  THEN 'Other'
                                  ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                                  END
               ELSE 'Error' END, 'Total') AS [mode_aggregate_description]
	    ,SUM(ISNULL([weight_person_trip], 0)) AS [person_trips]
    FROM
	    [fact].[person_trip]
    INNER JOIN
	    [dimension].[model_trip]
    ON
	    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
    INNER JOIN
	    [dimension].[mode_trip]
    ON
	    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
    INNER JOIN
        [report].[fn_resident_tourjourney_mode](@scenario_id)
    ON
        [person_trip].[scenario_id] = [fn_resident_tourjourney_mode].[scenario_id]
        AND [person_trip].[tour_id] = [fn_resident_tourjourney_mode].[tour_id]
        AND [person_trip].[inbound_id] = [fn_resident_tourjourney_mode].[inbound_id]
    INNER JOIN
	    [dimension].[purpose_trip_origin]
    ON
	    [person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
    INNER JOIN
	    [dimension].[purpose_trip_destination]
    ON
	    [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
    INNER JOIN
	    [dimension].[geography_trip_origin]
    ON
	    [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    INNER JOIN
	    [dimension].[geography_trip_destination]
    ON
	    [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	    @uats_mgras AS [uats_mgras_origin_xref]
    ON
	    [geography_trip_origin].[trip_origin_mgra_13] = [uats_mgras_origin_xref].[mgra]
    LEFT OUTER JOIN -- keep as outer join since where clause is OR condition
	    @uats_mgras AS [uats_mgras_dest_xref]
    ON
	    [geography_trip_destination].[trip_destination_mgra_13] = [uats_mgras_dest_xref].[mgra]
    WHERE
	    [person_trip].[scenario_id] = @scenario_id
	    AND [model_trip].[model_trip_description] IN ('Individual',
												      'Internal-External', -- can use external TAZs but they will not be in UATS districts
												      'Joint') -- resident models only
	    AND (
                (@work = 1
                 AND (  -- direct Home-Work or Work-Home trips
                    ([purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
                      AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work')
                    OR
                    ([purpose_trip_origin].[purpose_trip_origin_description] = 'Work'
                      AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Home')
                      )
                 )
			    OR @work = 0
                ) -- if work trips then filter by direct home-work or work-home trips
	    AND (
                (@uats = 1
                 AND (
                    [uats_mgras_origin_xref].[mgra] IS NOT NULL
                    AND [uats_mgras_dest_xref].[mgra] IS NOT NULL
                    )
                  )
			    OR @uats = 0
                ) -- if UATS districts option selected only count trips originating and ending in UATS mgras
    GROUP BY
	    CASE    WHEN @work = 0 THEN
                         CASE    WHEN [mode_trip].[mode_aggregate_trip_description] IN
                                   ('School Bus',
                                    'Taxi',
                                    'Heavy Heavy Duty Truck',
                                    'Light Heavy Duty Truck',
                                    'Medium Heavy Duty Truck',
                                    'Parking Lot',
                                    'Pickup/Drop-off',
                                    'Rental car',
                                    'Shuttle/Van/Courtesy Vehicle')
                                  THEN 'Other'
                                  ELSE [mode_trip].[mode_aggregate_trip_description]
                                  END
                       WHEN @work = 1 THEN
                         CASE    WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN
                                   ('School Bus',
                                    'Taxi',
                                    'Heavy Heavy Duty Truck',
                                    'Light Heavy Duty Truck',
                                    'Medium Heavy Duty Truck',
                                    'Parking Lot',
                                    'Pickup/Drop-off',
                                    'Rental car',
                                    'Shuttle/Van/Courtesy Vehicle')
                                  THEN 'Other'
                                  ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                                  END
               ELSE 'Error' END
    WITH ROLLUP


    -- get and store total person trips
    DECLARE @total_trips float = (
        SELECT [person_trips] FROM @aggregated_trips
        WHERE [mode_aggregate_description] = 'Total'
        )


    -- insert mode percentage split into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,@pm_name AS [performance_measure]
	    ,CONCAT('Percentage of Total Person Trips - ',
                [all_modes].[mode]) AS [metric]
	    ,ISNULL(100.0 * [person_trips] / @total_trips, 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    @aggregated_trips
    RIGHT OUTER JOIN (  -- ensure all modes are represented
        SELECT DISTINCT
            CASE    WHEN [mode_aggregate_trip_description] IN ('School Bus',
                                                               'Taxi',
                                                               'Heavy Heavy Duty Truck',
                                                               'Light Heavy Duty Truck',
                                                               'Medium Heavy Duty Truck',
                                                               'Not Applicable',
                                                               'Parking Lot',
                                                               'Pickup/Drop-off',
                                                               'Rental car',
                                                               'Shuttle/Van/Courtesy Vehicle')
                    THEN 'Other'
                    ELSE [mode_aggregate_trip_description]
                    END AS [mode]
        FROM
            [dimension].[mode_trip]) AS [all_modes]
    ON
        [@aggregated_trips].[mode_aggregate_description] = [all_modes].[mode]


    -- insert total trips by mode into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,@pm_name AS [performance_measure]
	    ,CONCAT('Person Trips - ',
                [all_modes].[mode]) AS [metric]
	    ,ISNULL([person_trips], 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    @aggregated_trips
    RIGHT OUTER JOIN (  -- ensure all modes are represented
        SELECT DISTINCT
            CASE    WHEN [mode_aggregate_trip_description] IN ('School Bus',
                                                               'Taxi',
                                                               'Heavy Heavy Duty Truck',
                                                               'Light Heavy Duty Truck',
                                                               'Medium Heavy Duty Truck',
                                                               'Not Applicable',
                                                               'Parking Lot',
                                                               'Pickup/Drop-off',
                                                               'Rental car',
                                                               'Shuttle/Van/Courtesy Vehicle')
                    THEN 'Other'
                    ELSE [mode_aggregate_trip_description]
                    END AS [mode]
        FROM
            [dimension].[mode_trip]) AS [all_modes]
    ON
        [@aggregated_trips].[mode_aggregate_description] = [all_modes].[mode]


    -- insert total bike and walk metrics into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,[performance_measure]
        ,'Person Trips - Total Bike and Walk' AS [metric]
        ,SUM([value]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_Name
        AND [metric] IN ('Person Trips - Bike',
                         'Person Trips - Walk')
    GROUP BY
        [performance_measure]

    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,[performance_measure]
        ,'Percentage of Total Person Trips - Total Bike and Walk' AS [metric]
        ,SUM([value]) / @total_trips AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_Name
        AND [metric] IN ('Person Trips - Bike',
                         'Person Trips - Walk')
    GROUP BY
        [performance_measure]


    -- insert total carpool metrics into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,[performance_measure]
        ,'Person Trips - Total Carpool' AS [metric]
        ,SUM([value]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_Name
        AND [metric] IN ('Person Trips - Shared Ride 2',
                         'Person Trips - Shared Ride 3')
    GROUP BY
        [performance_measure]

    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,[performance_measure]
        ,'Percentage of Total Person Trips - Total Carpool' AS [metric]
        ,SUM([value]) / @total_trips AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_Name
        AND [metric] IN ('Person Trips - Shared Ride 2',
                         'Person Trips - Shared Ride 3')
    GROUP BY
        [performance_measure]


END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = @pm_name;
GO

-- add metadata for [fed_rtp_20].[sp_pm_2a]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_2a', 'MS_Description', 'performance metric 2a'
GO




-- Create stored procedure for performance metric #2b ------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_2b]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_2b]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Performance Measure 2b, network VMT per capita and regionwide for a given
    ABM scenario. Similar to [rp_2015].[sp_eval_vmt] in the 2015 RTP.

filters:   >
    None

revisions: 
    - author: Gregor Schroeder
      modification: translate to new abm database structure
      date: 17 Apr 2018
**/
SET NOCOUNT ON;


-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure 2a result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 2b'


    -- subquery for total synthetic population
    DECLARE @population integer = (
        SELECT
            SUM([weight_person])
        FROM
            [dimension].[person]
        WHERE
            [scenario_id] = @scenario_id
    )


    -- insert VMT per capita into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure 2b' AS [performance_measure]
        ,'VMT per Capita' AS [metric]
	    ,SUM([hwy_flow].[flow] * [hwy_link].[length_mile]) /
            @population AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    [fact].[hwy_flow]
    INNER JOIN
	    [dimension].[hwy_link]
    ON
	    [hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
	    AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
    WHERE
	    [hwy_flow].[scenario_id] = @scenario_id
	    AND [hwy_link].[scenario_id] = @scenario_id


    -- insert VMT into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure 2b' AS [performance_measure]
        ,'VMT' AS [metric]
	    ,SUM([hwy_flow].[flow] * [hwy_link].[length_mile]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    [fact].[hwy_flow]
    INNER JOIN
	    [dimension].[hwy_link]
    ON
	    [hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
	    AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
    WHERE
	    [hwy_flow].[scenario_id] = @scenario_id
	    AND [hwy_link].[scenario_id] = @scenario_id
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 2b';
GO

-- Add metadata for [fed_rtp_20].[sp_pm_2b]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_2b', 'MS_Description', 'performance metric 2b'
GO




-- create stored procedure for performance metric #5a
-- high-frequency transit stops ----------------------------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_5a_hf_transit_stops]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_5a_hf_transit_stops]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@high_frequency_headway integer = 15 -- vehicle headway/frequency minutes
AS

/**	
summary:   >
    Input for Performance Measure 5a, Percentage of
	population/employment within 0.5-mile of high-frequency (≤15 min peak)
	transit stops. High frequency transit stops are defined by the combined
	headway frequency of transit stops on a node, route, and direction where
	multiple stops ocurring on the same node, route, direction, and
	configuration are counted only once.

filters:   >
    Not Applicable

revisions: 
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 13 Nov 2018
**/

-- transform headway/frequency into vehicles per hour
DECLARE @high_frequency_vehicles float = 60.0 / @high_frequency_headway;


with [high_freq_nodes] AS (
	-- combine multiple stops at the same [near_node]
	-- on the same [route] and [direction] across different [config]
	-- summing vehicles defined by the headways
	-- have to select distinct as same [near_node]
	-- on different [route] and/or [direction] can appear
	SELECT DISTINCT
		[near_node]
	FROM (
		-- combine multiple stops at the same [near_node] with the same [config]
		-- not double-counting the vehicles defined by the headways
		SELECT DISTINCT
			[near_node]
			,[config]
			,[config] / 1000 AS [route]
			,([config] - 1000 * ([config] / 1000)) / 100 AS [direction]
			,CASE WHEN [am_headway] > 0 THEN 60.0 / [am_headway] ELSE 0 END AS [am_vehicles]
			,CASE WHEN [pm_headway] > 0 THEN 60.0 / [pm_headway] ELSE 0 END AS [pm_vehicles]
			,CASE WHEN [op_headway] > 0 THEN 60.0 / [op_headway] ELSE 0 END AS [op_vehicles]
		FROM
			[dimension].[transit_stop]
		INNER JOIN
			[dimension].[transit_route]
		ON
			[transit_stop].[scenario_id] = [transit_route].[scenario_id]
			AND [transit_stop].[transit_route_id] = [transit_route].[transit_route_id]
		WHERE
			[transit_stop].[scenario_id] = @scenario_id
			AND [transit_route].[scenario_id] = @scenario_id) AS [unique_stops]
	GROUP BY
		[near_node]
		,[route]
		,[direction]
	HAVING
		SUM([am_vehicles]) >= @high_frequency_vehicles
		OR SUM([pm_vehicles]) >= @high_frequency_vehicles
		OR SUM([op_vehicles]) >= @high_frequency_vehicles)
SELECT
	@scenario_id AS [scenario_id]
	,[tt_high_freq_nodes].[near_node]
	,[transit_stop].[transit_stop_shape] AS [near_node_shape]
FROM (
	-- create an interim table of the high-frequency transit nodes
	-- to allow one-to-one join of geometry column as
	-- geometry columns do not allow for DISTINCT statements
	-- [near_node]s can have multiple [transit_stop_id]s
	-- but the [transit_stop_shape] is always the same within a [near_node]
	SELECT
		[high_freq_nodes].[near_node]
		,MIN([transit_stop].[transit_stop_id]) AS [min_transit_stop_id]
	FROM
		[high_freq_nodes]
	INNER JOIN
		[dimension].[transit_stop]
	ON
		[transit_stop].[scenario_id] = @scenario_id
		AND [transit_stop].[near_node] = [high_freq_nodes].[near_node]
	GROUP BY
		[high_freq_nodes].[near_node]) AS [tt_high_freq_nodes]
INNER JOIN
	[dimension].[transit_stop]
ON
	[transit_stop].[scenario_id] = @scenario_id
	AND [tt_high_freq_nodes].[min_transit_stop_id] = [transit_stop].[transit_stop_id]
GO

-- add metadata for [fed_rtp_20].[sp_pm_5a_hf_transit_stops]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_5a_hf_transit_stops', 'MS_Description', 'performance metric 5a high frequency transit stops'
GO




-- create stored procedure for performance metric #6a ------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_6a]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_6a]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure 6A, person-level time engaged in
    transportation-related physical activity per capita (minutes). Similar
    to Performance Measures 7E and 7F in the 2015 RTP.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual',
                                              'Internal-External',
                                              'Joint')
        ABM resident sub-models

revisions: 
    - author: Gregor Schroeder
      modification: translate to new abm database structure
      date: 17 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure 6a result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 6a'


    -- create table variable to hold population with
    -- Community of Concern (CoC) attributes
    DECLARE @coc_pop TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [weight_person] tinyint NOT NULL,
        [senior] nvarchar(15) NOT NULL,
        [minority] nvarchar(15) NOT NULL,
        [low_income] nvarchar(15) NOT NULL)
    -- assign CoC attributes to each person and insert into a table variable
    INSERT INTO @coc_pop
    SELECT
        [person_id]
        ,[weight_person]
        ,[senior]
        ,[minority]
        ,[low_income]
    FROM
        [fed_rtp_20].[fn_person_coc] (@scenario_id);


    with [agg_coc_pop] AS (
        -- aggregate the CoC populations and pivot from wide to long
        SELECT
            [pop_segmentation]
            ,[weight_person]
        FROM (
            SELECT
                SUM(CASE    WHEN [senior] = 'Senior'
                            THEN [weight_person]
                            ELSE 0 END) AS [Senior]
                ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Senior]
                ,SUM(CASE   WHEN [minority] = 'Minority'
                            THEN [weight_person]
                            ELSE 0 END) AS [Minority]
                ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Minority]
                ,SUM(CASE   WHEN [low_income] = 'Low Income'
                            THEN [weight_person]
                            ELSE 0 END) AS [Low Income]
                ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Low Income]
                ,SUM([weight_person]) AS [Total]
            FROM
	            @coc_pop) AS [to_unpvt]
        UNPIVOT (
            [weight_person] FOR [pop_segmentation] IN
            ([Senior], [Non-Senior], [Minority], [Non-Minority],
             [Low Income], [Non-Low Income], [Total])) AS [unpvt]),
    [agg_activity] AS (
        -- aggregate CoC physical activity in minutes and pivot from wide to long
        SELECT
            [pop_segmentation]
            ,[physical_activity]
        FROM (
            SELECT
                SUM(CASE     WHEN [senior] = 'Senior'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Senior]
                ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Non-Senior]
                ,SUM(CASE   WHEN [minority] = 'Minority'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Minority]
                ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Non-Minority]
                ,SUM(CASE   WHEN [low_income] = 'Low Income'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Low Income]
                ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike])
                            ELSE 0 END) AS [Non-Low Income]
                ,SUM([weight_person_trip] * ([time_walk] + [time_bike])) AS [Total]
            FROM
	            [fact].[person_trip]
            INNER JOIN
	            [dimension].[model_trip]
            ON
	            [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
            INNER JOIN
	            @coc_pop
            ON
	            [person_trip].[scenario_id] = @scenario_id
	            AND [person_trip].[person_id] = [@coc_pop].[person_id]
            WHERE
	            [person_trip].[scenario_id] = @scenario_id
                 -- synthetic population only used in resident models
	            AND [model_trip].[model_trip_description] IN ('Individual',
													            'Internal-External',
													            'Joint')) AS [to_unpvt]
        UNPIVOT (
            [physical_activity] FOR [pop_segmentation] IN
            ([Senior], [Non-Senior], [Minority], [Non-Minority],
             [Low Income], [Non-Low Income], [Total])) AS [unpvt])
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure 6a' AS [performance_measure]
	    ,CONCAT('Physical Activity per Capita - ',
                [agg_coc_pop].[pop_segmentation]) AS [metric]
	    ,ISNULL([agg_activity].[physical_activity], 0) /
            [agg_coc_pop].[weight_person] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    [agg_coc_pop]
    LEFT OUTER JOIN
	    [agg_activity]
    ON
	    [agg_coc_pop].[pop_segmentation] = [agg_activity].[pop_segmentation]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure 6a';
GO

-- Add metadata for [fed_rtp_20].[sp_pm_6a]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_6a', 'MS_Description', 'performance metric 6a'
GO




-- create stored procedure for performance metric #A -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_A]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_A]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure A, average peak-period person trip
    travel time in minutes to work by mode. Only trips that go directly from
    home to work are considered. Similar to Performance Measures 1a and 7d in
    the 2015 RTP.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [inbound].[inbound_description] = 'Outbound'
        only to-work trips are considered
    [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4')
        peak period trips that start in the ABM five time of day peak periods
    [purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
        trips must originate at home
    [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
        trips must destinate at work

revisions: 
    - author: Gregor Schroeder
      modification: translate to new abm database structure
      date: 20 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure A result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure A'


    -- create table variable to hold population with
    -- Community of Concern (CoC) attributes
    DECLARE @coc_pop TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [weight_person] tinyint NOT NULL,
        [senior] nvarchar(15) NOT NULL,
        [minority] nvarchar(15) NOT NULL,
        [low_income] nvarchar(15) NOT NULL)
    -- assign CoC attributes to each person and insert into a table variable
    INSERT INTO @coc_pop
    SELECT
        [person_id]
        ,[weight_person]
        ,[senior]
        ,[minority]
        ,[low_income]
    FROM
        [fed_rtp_20].[fn_person_coc] (@scenario_id);


    -- create table variable to hold eligible
    --resident model peak period direct to-work trips
    DECLARE @to_work_trips TABLE (
        [person_trip_id] integer PRIMARY KEY NOT NULL,
        [person_id] integer NOT NULL,
        [mode_aggregate_trip_description] nvarchar(75) NOT NULL,
        [time_total] decimal(10,4) NOT NULL,
        [weight_person_trip] decimal(8,5) NOT NULL)
    INSERT INTO @to_work_trips
    SELECT
        [person_trip_id]
        ,[person_id]
	    ,[mode_aggregate_trip_description]
	    ,[time_total]
	    ,[weight_person_trip]
    FROM
	    [fact].[person_trip]
    INNER JOIN
	    [dimension].[inbound]
    ON
	    [person_trip].[inbound_id] = [inbound].[inbound_id]
    INNER JOIN
	    [dimension].[mode_trip]
    ON
	    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
    INNER JOIN
	    [dimension].[model_trip]
    ON
	    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
    INNER JOIN
	    [dimension].[time_trip_start]
    ON
	    [person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
    INNER JOIN
	    [dimension].[purpose_trip_origin]
    ON
	    [person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
    INNER JOIN
	    [dimension].[purpose_trip_destination]
    ON
	    [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
    WHERE
	    [person_trip].[scenario_id] = @scenario_id
	    -- to work trips only
	    AND [inbound].[inbound_description] = 'Outbound'
	    -- resident models only
	    AND [model_trip].[model_trip_description] IN ('Individual',
                                                        'Internal-External',
                                                        'Joint')
        -- trips that start in abm five time of day peak periods only
	    AND [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4')
	    -- work trips must start at home, a direct to work trip
	    AND [purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
	    AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'


    -- calculate peak-period trip travel time in minutes to work by mode
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure A' AS [performance_measure]
	    ,CONCAT('Average Direct to Work Travel Time - ',
                [pop_segmentation],
                ' - ',
                [mode]) AS [metric]
	    ,[avg_time] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL([mode_aggregate_trip_description], 'Total') AS [mode]
            ,SUM(CASE   WHEN [senior] = 'Senior'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [senior] = 'Senior'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Senior]
            ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [senior] = 'Non-Senior'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Non-Senior]
            ,SUM(CASE   WHEN [minority] = 'Minority'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [minority] = 'Minority'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Minority]
            ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [minority] = 'Non-Minority'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Non-Minority]
            ,SUM(CASE   WHEN [low_income] = 'Low Income'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [low_income] = 'Low Income'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Low Income]
            ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                        THEN [time_total] * [weight_person_trip]
                        ELSE 0 END) /
                SUM(CASE    WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Non-Low Income]
            ,SUM([time_total] * [weight_person_trip]) /
                SUM([weight_person_trip] * [weight_person]) AS [Total]
        FROM
            @to_work_trips
        INNER JOIN
            @coc_pop
        ON
            [@to_work_trips].[person_id] = [@coc_pop].[person_id]
        GROUP BY
            [mode_aggregate_trip_description]
        WITH ROLLUP) AS [to_unpvt]
    UNPIVOT (
        [avg_time] FOR [pop_segmentation] IN
        ([Senior], [Non-Senior], [Minority], [Non-Minority],
            [Low Income], [Non-Low Income], [Total])) AS [unpvt]


    -- calculate peak-period person trips to work by mode
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure A' AS [performance_measure]
	    ,CONCAT('Total Person Trips - ',
                [pop_segmentation],
                ' - ',
                [mode]) AS [metric]
	    ,[avg_time] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL([mode_aggregate_trip_description], 'Total') AS [mode]
            ,SUM(CASE   WHEN [senior] = 'Senior'
                        THEN [weight_person_trip] * [weight_person]
                        ELSE 0 END) AS [Senior]
            ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                        THEN [weight_person_trip] * [weight_person]
                        ELSE 0 END) AS [Non-Senior]
            ,SUM(CASE   WHEN [minority] = 'Minority'
                        THEN [weight_person_trip] * [weight_person]
                        ELSE 0 END) AS [Minority]
            ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                        THEN [weight_person_trip] * [weight_person]
                            ELSE 0 END) AS [Non-Minority]
            ,SUM(CASE   WHEN [low_income] = 'Low Income'
                        THEN [weight_person_trip] * [weight_person]
                        ELSE 0 END) AS [Low Income]
            ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                        THEN [weight_person_trip] * [weight_person]
                        ELSE 0 END) AS [Non-Low Income]
            ,SUM([weight_person_trip] * [weight_person]) AS [Total]
        FROM
            @to_work_trips
        INNER JOIN
            @coc_pop
        ON
            [@to_work_trips].[person_id] = [@coc_pop].[person_id]
        GROUP BY
            [mode_aggregate_trip_description]
        WITH ROLLUP) AS [to_unpvt]
    UNPIVOT (
        [avg_time] FOR [pop_segmentation] IN
        ([Senior], [Non-Senior], [Minority], [Non-Minority],
            [Low Income], [Non-Low Income], [Total])) AS [unpvt]


    -- create total carpool metrics (sr2 + sr3)
    DECLARE @cursor CURSOR;
    DECLARE @segmentation nvarchar(200);
    BEGIN
        SET @cursor = CURSOR FOR
        SELECT 'Senior' UNION SELECT 'Non-Senior' UNION
        SELECT 'Minority' UNION SELECT 'Non-Minority' UNION
        SELECT 'Low Income' UNION SELECT 'Non-Low Income' UNION
        SELECT 'Total'
 

        OPEN @cursor 
        FETCH NEXT FROM @cursor 
        INTO @segmentation

        WHILE @@FETCH_STATUS = 0
        BEGIN
          DECLARE @sr2_trips float = (
            SELECT [value] FROM [fed_rtp_20].[pm_results]
            WHERE [scenario_id] = @scenario_id
            AND [performance_measure] = 'Performance Measure A'
            AND [metric] = CONCAT('Total Person Trips - ',
                                  @segmentation,
                                  ' - Shared Ride 2'))

          DECLARE @sr3_trips float = (
            SELECT [value] FROM [fed_rtp_20].[pm_results]
            WHERE [scenario_id] = @scenario_id
            AND [performance_measure] = 'Performance Measure A'
            AND [metric] = CONCAT('Total Person Trips - ',
                                  @segmentation,
                                  ' - Shared Ride 3'))

          DECLARE @sr2_time float = (
            SELECT [value] FROM [fed_rtp_20].[pm_results]
            WHERE [scenario_id] = @scenario_id
            AND [performance_measure] = 'Performance Measure A'
            AND [metric] = CONCAT('Average Direct to Work Travel Time - ',
                                  @segmentation,
                                  ' - Shared Ride 2'))

          DECLARE @sr3_time float = (
            SELECT [value] FROM [fed_rtp_20].[pm_results]
            WHERE [scenario_id] = @scenario_id
            AND [performance_measure] = 'Performance Measure A'
            AND [metric] = CONCAT('Average Direct to Work Travel Time - ',
                                  @segmentation,
                                  ' - Shared Ride 3'))


          -- insert total carpool trips into Performance Measures results table
          INSERT INTO [fed_rtp_20].[pm_results] (
              [scenario_id]
              ,[performance_measure]
              ,[metric]
              ,[value]
              ,[updated_by]
              ,[updated_date]
            )
          SELECT
            @scenario_id as [scenario_id]
            ,'Performance Measure A' AS [performance_measure]
            ,CONCAT('Total Person Trips - ',
                    @segmentation,
                    ' - Total Carpool') AS [metric]
            ,@sr2_trips + @sr3_trips AS [value]
            ,USER_NAME() AS [updated_by]
            ,SYSDATETIME() AS [updated_date]

          -- insert total carpool time into Performance Measures results table
          INSERT INTO [fed_rtp_20].[pm_results] (
              [scenario_id]
              ,[performance_measure]
              ,[metric]
              ,[value]
              ,[updated_by]
              ,[updated_date]
            )
          SELECT
            @scenario_id as [scenario_id]
            ,'Performance Measure A' AS [performance_measure]
            ,CONCAT('Average Direct to Work Travel Time - ',
                    @segmentation,
                    ' - Total Carpool') AS [metric]
            ,((@sr2_time * @sr2_trips) + (@sr3_time * @sr3_trips)) /
                (@sr2_trips + @sr3_trips) AS [value]
            ,USER_NAME() AS [updated_by]
            ,SYSDATETIME() AS [updated_date]

          FETCH NEXT FROM @cursor 
          INTO @segmentation 
        END; 

        CLOSE @cursor ;
        DEALLOCATE @cursor;
    END;
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure A';
GO

-- add metadata for [fed_rtp_20].[sp_pm_A]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_A', 'MS_Description', 'performance metric A'
GO




-- create stored procedure for performance metric #B -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_B]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_B]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure B, average person-trip travel
    time to/from tribal lands (minutes). A trip to/from tribal lands is
    defined as a trip with origin or destination MGRAs whose centroids are
    within the tribal lands. If the ABM-sub model uses TAZs instead of MGRAs
    then a trip to/from tribal lands is defined as a trip where the
    origin/destination TAZ contains any MGRA whose centroid is within the
    tribal lands. Similar to Performance Measure 6A in the 2015 RTP.

filters:   >
    [geography_trip_origin].[trip_origin_mgra_13]
        weighted centroid within tribal lands part of OR condition with
        destination mgra
    [geography_trip_origin].[trip_destination_mgra_13]
        weighted centroid within tribal lands part of OR condition with
        origin mgra
    [geography_trip_origin].[trip_origin_taz_13]
        contains any mgra with a weighted centroid within tribal lands part
        of OR condition with destination taz
    [geography_trip_origin].[trip_destination_taz_13]
        contains any mgra with a weighted centroid within tribal lands part
        of OR condition with origin taz

revisions: 
    - author: Gregor Schroeder
      modification: include all ABM sub-models
      date: 8 Mar 2019
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 10 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure B result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure B';


    -- create lookup of series 13 mgras whose weighted centroids are
    -- within tribal lands
    with [mgra_xref] AS (
	    SELECT [mgra] FROM
	    OPENQUERY(
		    [sql2014b8],
		    'SELECT [mgra] FROM [lis].[gis].[INDIANRES],[lis].[gis].[MGRA13_WEIGHTEDCENTROID]
		    WHERE [INDIANRES].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1')),
    -- create lookup of series 13 tazs that contain series 13 mgras whose weighted
    -- centroids are within tribal lands
    [taz_xref] AS (
        SELECT [TAZ] FROM
        OPENQUERY(
            [sql2014b8],
            'SELECT DISTINCT [TAZ] FROM [lis].[GIS].[MGRA13]
             WHERE [MGRA] IN (
             SELECT [mgra] FROM [lis].[gis].[INDIANRES], [lis].[gis].[MGRA13_WEIGHTEDCENTROID]
             WHERE [INDIANRES].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1)'))
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure B' AS [performance_measure]
        ,[metric]
        ,[value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
	        CONVERT(float, SUM([weight_person_trip] * [time_total]) / SUM([weight_person_trip])) AS [Average Travel Time]
	        ,CONVERT(float, SUM([weight_person_trip])) AS [Total Person Trips]
        FROM
	        [fact].[person_trip]
        INNER JOIN
	        [dimension].[geography_trip_origin]
        ON
	        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        INNER JOIN
	        [dimension].[geography_trip_destination]
        ON
	        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	        [mgra_xref] AS [origin_mgra_xref]
        ON
	        [geography_trip_origin].[trip_origin_mgra_13] = CONVERT(nchar, [origin_mgra_xref].[mgra])
        LEFT OUTER JOIN -- keep as outer join since where clause is OR condition
	        [mgra_xref] AS [dest_mgra_xref]
        ON
	        [geography_trip_destination].[trip_destination_mgra_13] = CONVERT(nchar, [dest_mgra_xref].[mgra])
        LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	        [taz_xref] AS [origin_taz_xref]
        ON
	        [geography_trip_origin].[trip_origin_taz_13] = CONVERT(nchar, [origin_taz_xref].[TAZ])
        LEFT OUTER JOIN -- keep as outer join since where clause is OR condition
	        [taz_xref] AS [dest_taz_xref]
        ON
	        [geography_trip_destination].[trip_destination_taz_13] = CONVERT(nchar, [dest_taz_xref].[TAZ])
        WHERE
	        [person_trip].[scenario_id] = @scenario_id
	        AND (  -- only count trips originating and ending in tribal lands
                    ([origin_mgra_xref].[mgra] IS NOT NULL OR [dest_mgra_xref].[mgra] IS NOT NULL)
                    OR ([origin_taz_xref].[TAZ] IS NOT NULL OR [dest_taz_xref].[TAZ] IS NOT NULL)
                )) AS [to_unpvt]
    UNPIVOT (
        [value] FOR [metric] IN
        ([Average Travel Time], [Total Person Trips])) AS [pvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure B';
GO

-- add metadata for [fed_rtp_20].[sp_pm_B]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_B', 'MS_Description', 'performance metric B'
GO




-- create stored procedure for performance metric #C -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_C]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_C]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure B, average person-trip travel time
    to/from Mexico points of entry (POE) (minutes). A trip to/from Mexico POEs
    is defined as a trip with origin or destination to external Mexico TAZs.
    Note that a trip that originates at one POE and destinates at another is
    removed from consideration. Similar to Performance Measure 6B
    in the 2015 RTP.

filters:   >
    [geography_trip_origin].[trip_origin_external_zone] IN ('San Ysidro',
    'Otay Mesa', 'Tecate', 'Otay Mesa East', 'Jacumba')
        part of OR condition with
        [geography_trip_destination].[trip_destination_external_zone]
    [geography_trip_destination].[trip_destination_external_zone] IN
    ('San Ysidro', 'Otay Mesa', 'Tecate', 'Otay Mesa East', 'Jacumba')
        part of OR condition with
        [geography_trip_origin].[trip_origin_external_zone]
    Note that both conditions evaluating to TRUE results in the trip
    being removed from consideration

revisions:
    - author: Gregor Schroeder
      modification: remove trips that both originate AND destinate at POEs
      date: 22 May 2019
    - author: Gregor Schroeder
      modification: include all ABM sub-models
      date: 8 Mar 2019
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 12 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure C result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure C';


    -- create temporary table and insert poe results
    DECLARE @poe_results TABLE (
        [poe_desc] nvarchar(20) PRIMARY KEY NOT NULL,
        [Average Travel Time] float NOT NULL,
        [Total Person Trips] float NOT NULL)
    INSERT INTO @poe_results
    SELECT
	    ISNULL(
            CASE	WHEN [geography_trip_origin].[trip_origin_external_zone] NOT IN ('San Ysidro',
																                     'Otay Mesa',
																                     'Tecate',
																                     'Otay Mesa East',
																                     'Jacumba')
				    THEN [geography_trip_destination].[trip_destination_external_zone]
				    ELSE [geography_trip_origin].[trip_origin_external_zone]
				    END,
            'Total') AS [poe_desc]
	    ,SUM([weight_person_trip] * [time_total]) /
            SUM([weight_person_trip]) AS [Average Travel Time]
	    ,SUM([weight_person_trip]) AS [Total Person Trips]
    FROM
	    [fact].[person_trip]
    INNER JOIN
	    [dimension].[geography_trip_origin]
    ON
	    [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    INNER JOIN
	    [dimension].[geography_trip_destination]
    ON
	    [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    WHERE
	    [person_trip].[scenario_id] = @scenario_id
	    AND (  -- keep trips that originate OR destinate at a POE
            [geography_trip_origin].[trip_origin_external_zone] IN ('San Ysidro',
																    'Otay Mesa',
																    'Tecate',
																    'Otay Mesa East',
																    'Jacumba')
		    OR [geography_trip_destination].[trip_destination_external_zone] IN ('San Ysidro',
																			     'Otay Mesa',
																			     'Tecate',
																			     'Otay Mesa East',
																			     'Jacumba')
             )
        AND NOT (  -- remove trips that originate AND destinate at a POE
            [geography_trip_origin].[trip_origin_external_zone] IN ('San Ysidro',
																    'Otay Mesa',
																    'Tecate',
																    'Otay Mesa East',
																    'Jacumba')
		    AND [geography_trip_destination].[trip_destination_external_zone] IN ('San Ysidro',
																			      'Otay Mesa',
																			      'Tecate',
																			      'Otay Mesa East',
																			      'Jacumba')
             )
    GROUP BY
	    CASE	WHEN [geography_trip_origin].[trip_origin_external_zone] NOT IN ('San Ysidro',
																                 'Otay Mesa',
																                 'Tecate',
																                 'Otay Mesa East',
																                 'Jacumba')
			    THEN [geography_trip_destination].[trip_destination_external_zone]
			    ELSE [geography_trip_origin].[trip_origin_external_zone]
			    END
    WITH ROLLUP

    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure C' AS [performance_measure]
        ,CONCAT([metric], ' - ', [poe_desc]) AS [metric]
        ,[value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL([poe_list].[poe_desc], 'Total') AS [poe_desc]
            ,ISNULL([Average Travel Time], 0) AS [Average Travel Time]
            ,ISNULL([Total Person Trips], 0) AS [Total Person Trips]
        FROM
            @poe_results
        FULL OUTER JOIN (
            SELECT DISTINCT
                [external_zone] AS [poe_desc]
            FROM
                [dimension].[geography]
            WHERE
                [external_zone] IN ('San Ysidro',
						            'Otay Mesa',
						            'Tecate',
						            'Otay Mesa East',
						            'Jacumba')) AS [poe_list]
        ON
           [@poe_results].[poe_desc] = [poe_list].[poe_desc]) AS [to_unpvt]
    UNPIVOT (
        [value] FOR [metric] IN
        ([Average Travel Time], [Total Person Trips])) AS [pvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure C';
GO

-- add metadata for [fed_rtp_20].[sp_pm_C]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_C', 'MS_Description', 'performance metric C'
GO




-- create stored procedure for performance metric #D -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_D]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_D]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure B, average person-trip travel time
    to/from neighboring counties(Imperial, Orange, Riverside) (minutes). A
    trip to/from neighboring counties is defined as a trip with origin or
    destination to external neighboring counties TAZs. Note that ABM
    External-External sub-model trips are removed from consideration.
    Similar to Performance Measure 6C in the 2015 RTP.

filters:   >
    [model_trip].[model_trip_description] != 'External-External'
        remove ABM External-External sub-model trips from consideration
    [geography_trip_origin].[trip_origin_external_zone] IN ('I-8', 'CA-78',
    'CA-79', 'Pala Road', 'I-15', 'CA-241 Toll Road', 'I-5')
        part of OR condition with
        [geography_trip_destination].[trip_destination_external_zone]
    [geography_trip_destination].[trip_destination_external_zone] IN ('I-8',
    'CA-78', 'CA-79', 'Pala Road', 'I-15', 'CA-241 Toll Road', 'I-5')
        part of OR condition with
        [geography_trip_origin].[trip_origin_external_zone]

revisions:
    - author: Gregor Schroeder
      modification: remove ABM  External-External sub-model trips from
        consideration
      date: 22 May 2019
    - author: Gregor Schroeder
      modification: include all ABM sub-models
      date: 8 Mar 2019
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 12 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure D result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure D'


    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure D' AS [performance_measure]
        ,[metric]
        ,[value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
	        @scenario_id AS [scenario_id]
	        ,CONVERT(float, SUM([weight_person_trip] * [time_total]) /
                               SUM([weight_person_trip])) AS [Average Travel Time]
	        ,CONVERT(float, SUM([weight_person_trip])) AS [Total Person Trips]
        FROM
	        [fact].[person_trip]
        INNER JOIN
            [dimension].[model_trip]
        ON
            [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
        INNER JOIN
	        [dimension].[geography_trip_origin]
        ON
	        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        INNER JOIN
	        [dimension].[geography_trip_destination]
        ON
	        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        WHERE
	        [person_trip].[scenario_id] = @scenario_id
            -- remove External-External model trips
            AND [model_trip].[model_trip_description] != 'External-External'
	        AND (
                [geography_trip_origin].[trip_origin_external_zone] IN ('I-8',
																        'CA-78',
																        'CA-79',
																        'Pala Road',
																        'I-15',
																        'CA-241 Toll Road',
																        'I-5')
		        OR [geography_trip_destination].[trip_destination_external_zone] IN ('I-8',
																			         'CA-78',
																			         'CA-79',
																			         'Pala Road',
																			         'I-15',
																			         'CA-241 Toll Road',
																			         'I-5')
                )) AS [to_unpvt]
    UNPIVOT (
        [value] FOR [metric] IN
        ([Average Travel Time], [Total Person Trips])) AS [pvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure D';
GO

-- add metadata for [fed_rtp_20].[sp_pm_D]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_D', 'MS_Description', 'performance metric D'
GO




-- create stored procedure for performance metric #E -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_E]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_E]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure B, average person-trip travel time
    to/from military bases/installations (minutes). A trip to/from military
    bases/installations is defined as a trip with origin or destination MGRAs
    whose centroids are within military bases/installations. If the ABM-sub
    model uses TAZs instead of MGRAs then a trip to/from
    military bases/installations is defined as a trip where the
    origin/destination TAZ contains any MGRA whose centroid is within military
    bases/installations. Similar to Performance Measure 6D in the 2015 RTP.

filters:   >
    [geography_trip_origin].[trip_origin_mgra_13]
        weighted centroid within military bases/installations part of OR
        condition with destination mgra
    [geography_trip_origin].[trip_destination_mgra_13]
        weighted centroid within military bases/installations part of OR
        condition with origin mgra
    [geography_trip_origin].[trip_origin_taz_13]
        contains any mgra with a weighted centroid within military
        bases/installations part of OR condition with destination taz
    [geography_trip_origin].[trip_destination_taz_13]
        contains any mgra with a weighted centroid within military
        bases/installations part of OR condition with origin taz

revisions: 
    - author: Gregor Schroeder
      modification: include all ABM sub-models
      date: 8 Mar 2019
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 12 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure E result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure E';


    -- create lookup of series 13 mgras whose weighted centroids are
    -- within military bases/installations
    with [mgra_xref] AS (
	    SELECT [mgra] FROM
	    OPENQUERY(
		    [sql2014b8],
		    'SELECT [mgra] FROM [lis].[gis].[OWNERSHIP],[lis].[gis].[MGRA13_WEIGHTEDCENTROID]
		    WHERE [Own] = 41 AND [OWNERSHIP].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1')),
    -- create lookup of series 13 tazs that contain series 13 mgras whose weighted
    -- centroids are within military bases/installations
    [taz_xref] AS (
        SELECT [TAZ] FROM
        OPENQUERY(
            [sql2014b8],
            'SELECT DISTINCT [TAZ] FROM [lis].[GIS].[MGRA13]
             WHERE [MGRA] IN (
             SELECT [mgra] FROM [lis].[gis].[OWNERSHIP], [lis].[gis].[MGRA13_WEIGHTEDCENTROID]
             WHERE [Own] = 41 AND [OWNERSHIP].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1)'))
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure E' AS [performance_measure]
        ,[metric]
        ,[value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
	        CONVERT(float, SUM([weight_person_trip] * [time_total]) /
                            SUM([weight_person_trip])) AS [Average Travel Time]
	        ,CONVERT(float, SUM([weight_person_trip])) AS [Total Person Trips]
        FROM
	        [fact].[person_trip]
        INNER JOIN
	        [dimension].[geography_trip_origin]
        ON
	        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        INNER JOIN
	        [dimension].[geography_trip_destination]
        ON
	        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	        [mgra_xref] AS [origin_mgra_xref]
        ON
	        [geography_trip_origin].[trip_origin_mgra_13] = CONVERT(nchar, [origin_mgra_xref].[mgra])
        LEFT OUTER JOIN -- keep as outer join since where clause is OR condition
	        [mgra_xref] AS [dest_mgra_xref]
        ON
	        [geography_trip_destination].[trip_destination_mgra_13] = CONVERT(nchar, [dest_mgra_xref].[mgra])
        LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	        [taz_xref] AS [origin_taz_xref]
        ON
	        [geography_trip_origin].[trip_origin_taz_13] = CONVERT(nchar, [origin_taz_xref].[TAZ])
        LEFT OUTER JOIN -- keep as outer join since where clause is OR condition
	        [taz_xref] AS [dest_taz_xref]
        ON
	        [geography_trip_destination].[trip_destination_taz_13] = CONVERT(nchar, [dest_taz_xref].[TAZ])
        WHERE
	        [person_trip].[scenario_id] = @scenario_id
	        AND (  -- only count trips originating and ending in military bases/installations
                    ([origin_mgra_xref].[mgra] IS NOT NULL OR [dest_mgra_xref].[mgra] IS NOT NULL)
                    OR ([origin_taz_xref].[TAZ] IS NOT NULL OR [dest_taz_xref].[TAZ] IS NOT NULL)
                )) AS [to_unpvt]
    UNPIVOT (
        [value] FOR [metric] IN
        ([Average Travel Time], [Total Person Trips])) AS [pvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure E';
GO

-- add metadata for [fed_rtp_20].[sp_pm_E]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_E', 'MS_Description', 'performance metric E'
GO




-- create stored procedure for performance metric #F -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_F]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_F]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure F, percent of household income
    consumed by transportation costs. Transportation costs fall into 4
    categories; parking costs, auto operating cost, toll cost, and transit
    fare. Only households with members who travelled are considered in this
    calculation. Costs are multiplied by 300 to estimate annual costs and are
    capped at total household income. Similar to Performance Measure 5A in the
    2015 RTP.

    Parking costs are calculated as follows. All auto modes destinating in
    zones designated as paid parking zones that are not the driver's home zone
    pay the minimum of the hourly, monthly, or daily parking cost in the zone.
    Trips may park in a different parking zone than their destination zone.
    The maximum parking reimbursement percentage of all trip participants is
    used to deduct from the parking cost. Parking cost is split amongst all
    trip participants.

    Auto operating and toll costs are split amongst all trip participants.

    Transit fare costs are reduced by 50% for persons aged 60 or over. A
    persons travel costs are capped at $12 or $5 depending on if they used
    premium transit modes.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [dimension].[household]
        limited to households with members who travelled

revisions: 
    - author: Gregor Schroeder
      modification: translate to new abm database structure
      date: 20 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure F result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure F';


    -- create temporary table to store household-level results
    DECLARE @hh_results TABLE (
        [household_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [weight_household] tinyint NOT NULL,
        [income] integer NOT NULL,
        [annual_cost] float NOT NULL);


    -- get maximum parking reimbursement percentage of person on the tour
	    -- it is ok to do this at tour level since i, i-e, j trips all have tours
	    -- limited to i, i-e, j trips since these use synthetic population
    with [tour_freeparking_reimbpct] AS (
	    SELECT 
		    [tour_id]
		    ,CASE	WHEN MAX(CASE	WHEN [person].[freeparking_choice] IN ('Employer Pays for Parking',
																	       'Has Free Parking')
								    THEN 1
								    WHEN [person].[freeparking_choice] = 'Employer Reimburses for Parking'
								    THEN [person].[freeparking_reimbpct]
								    ELSE 0 END) > 1
				    THEN 1
				    ELSE MAX(CASE	WHEN [person].[freeparking_choice] IN ('Employer Pays for Parking',
																	       'Has Free Parking')
								    THEN 1
								    WHEN [person].[freeparking_choice] = 'Employer Reimburses for Parking'
								    THEN [person].[freeparking_reimbpct]
								    ELSE 0 END)
				    END AS [freeparking_reimbpct]
	    FROM
		    [fact].[person_trip]
	    INNER JOIN
		    [dimension].[model_trip]
	    ON
		    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
	    INNER JOIN
		    [dimension].[mode_trip]
	    ON
		    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
	    INNER JOIN
		    [dimension].[person]
	    ON
		    [person_trip].[scenario_id] = [person].[scenario_id]
		    AND [person_trip].[person_id] = [person].[person_id]
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
		    AND [person].[scenario_id] = @scenario_id
		    AND [model_trip].[model_trip_description] IN ('Individual',
													      'Internal-External',
													      'Joint') -- models that use synthetic population
		    AND [mode_trip].[mode_trip_description] IN ('Drive Alone Non-Toll',
													    'Drive Alone Toll Eligible',
													    'Shared Ride 2 Non-Toll',
													    'Shared Ride 2 Toll Eligible',
													    'Shared Ride 3 Non-Toll',
													    'Shared Ride 3 Toll Eligible') -- only take driving modes used in the i, i-e, and joint models
																				       -- it is assumed park and ride has free parking
	    GROUP BY
		    [tour_id]),
    -- sum costs to the person level
    -- auto = aoc split among riders, fare split among riders, and parking cost split among riders
	    -- for parking have to look at tour reimbursement, mgra based input parking costs, and home location
    -- transit = transit fare
	    -- for age >= 60 apply a 50% reduction
    [person_costs] AS (
	    SELECT
		    [person_trip].[person_id]
		    ,[person_trip].[household_id]
		    ,[person].[weight_person]
		    ,SUM(([toll_cost_drive] + [operating_cost_drive]) * [weight_trip]) AS [cost_auto]
		    ,SUM(CASE	WHEN [mode_trip].[mode_trip_description] IN ('Drive Alone Non-Toll',
																     'Drive Alone Toll Eligible',
																     'Shared Ride 2 Non-Toll',
																     'Shared Ride 2 Toll Eligible',
																     'Shared Ride 3 Non-Toll',
																     'Shared Ride 3 Toll Eligible')
						    AND [mgra_based_input].[parkarea] IN (1, 2, 3) -- values of park area that imply trip pays for parking
						    AND [mparkcost] >= [dparkcost]
					    THEN (1 - ISNULL([tour_freeparking_reimbpct].[freeparking_reimbpct], 0)) * [dparkcost] * [weight_trip]
					    WHEN [mode_trip].[mode_trip_description] IN ('Drive Alone Non-Toll',
																     'Drive Alone Toll Eligible',
																     'Shared Ride 2 Non-Toll',
																     'Shared Ride 2 Toll Eligible',
																     'Shared Ride 3 Non-Toll',
																     'Shared Ride 3 Toll Eligible')
						    AND [mgra_based_input].[parkarea] IN (1, 2, 3) -- values of park area that imply trip pays for parking
						    AND [mparkcost] < [dparkcost]
					    THEN (1 - ISNULL([tour_freeparking_reimbpct].[freeparking_reimbpct], 0)) * [mparkcost] * [weight_trip]
					    ELSE 0 END *
			    -- multiply parking cost by indicator if trip destination is the persons household location
			    -- note this works as both resident trips and household location operate on the same geographic resolution (mgra)
			    -- also works as all members of a tour live in same household
			     CASE WHEN [person_trip].[geography_trip_destination_id] = [household].[geography_household_location_id]
					    OR [person_trip].[geography_parking_destination_id] = [household].[geography_household_location_id]
				      THEN 0 ELSE 1 END) AS [cost_parking]
		    ,SUM(CASE	WHEN [person].[age] >= 60 THEN [weight_person_trip] * [cost_transit] * .5
					    ELSE [weight_person_trip] * [cost_transit] END) AS [cost_transit]
		    ,MAX(CASE	WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus and Premium Transit',
																     'Kiss and Ride to Transit - Premium Transit Only',
																     'Park and Ride to Transit - Local Bus and Premium Transit',
																     'Park and Ride to Transit - Premium Transit Only',
																     'Walk to Transit - Local Bus and Premium Transit',
																     'Walk to Transit - Premium Transit Only')
				    THEN 1 ELSE 0 END) AS [premium_transit_indicator] -- indicate if premium transit was used for later transit fare cap
	    FROM
		    [fact].[person_trip]
	    INNER JOIN
		    [dimension].[model_trip]
	    ON
		    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
	    INNER JOIN
		    [dimension].[mode_trip]
	    ON
		    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
	    INNER JOIN
		    [dimension].[person]
	    ON
		    [person_trip].[scenario_id] = [person].[scenario_id]
		    AND [person_trip].[person_id] = [person].[person_id]
	    INNER JOIN
		    [dimension].[household]
	    ON
		    [person_trip].[scenario_id] = [household].[scenario_id]
		    AND [person_trip].[household_id] = [household].[household_id]
	    LEFT OUTER JOIN
		    [tour_freeparking_reimbpct]
	    ON
		    [person_trip].[scenario_id] = @scenario_id
		    AND [person_trip].[tour_id] = [tour_freeparking_reimbpct].[tour_id]
	    INNER JOIN
		    [fact].[mgra_based_input]
	    ON -- join works since i, i-e, j trips are all mgra based, do not need to account for tazs
		    [person_trip].[scenario_id] = [mgra_based_input].[scenario_id]
		    AND CASE	WHEN [person_trip].[geography_parking_destination_id] = 0 -- null record, do not use
					    THEN [person_trip].[geography_trip_destination_id]
					    ELSE [person_trip].[geography_parking_destination_id]
					    END = [mgra_based_input].[geography_id] -- use parking geography field if applicable otherwise use trip destination field
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
		    AND [person].[scenario_id] = @scenario_id
		    AND [household].[scenario_id] = @scenario_id
		    AND [mgra_based_input].[scenario_id] = @scenario_id
		    AND [model_trip].[model_trip_description] IN ('Individual',
													      'Internal-External',
													      'Joint') -- models that use synthetic population
	    GROUP BY
		    [person_trip].[person_id]
		    ,[person_trip].[household_id]
		    ,[person].[weight_person]),
    [household_costs] AS (
	    SELECT
		    -- multiply the person cost by 300 to get annual cost and sum over the household to get household costs
		    -- cap person transit costs at $12 or $5 depending on if they used premium or non-premium transit
		    [person_costs].[household_id]
		    ,SUM(300.0 * [weight_person] * ([cost_auto] + [cost_parking] +
			     CASE	WHEN [premium_transit_indicator] = 1 AND [cost_transit] > 12 THEN 12
					    WHEN [premium_transit_indicator] = 0 AND [cost_transit] > 5 THEN 5
					    ELSE [cost_transit] END)) AS [annual_cost]
	    FROM
		    [person_costs]
	    GROUP BY
		    [person_costs].[household_id])
    -- insert household result set into a temporary table
    INSERT INTO @hh_results
    SELECT
        [household_costs].[household_id]
	    ,[senior]
	    ,[minority]
	    ,[low_income]
	    ,[coc_households].[weight_household] 
	    ,[coc_households].[income]
	    ,[household_costs].[annual_cost]
    FROM
	    [household_costs]
    INNER JOIN (  -- only keep households that actually travelled
        SELECT
	        [household].[household_id]
	        ,[household].[income]
	        ,[household].[weight_household]
	        ,CASE   WHEN MAX(CASE WHEN [senior] = 'Senior' THEN 1 ELSE 0 END) = 1
                    THEN 'Senior'
                    ELSE 'Non-Senior'
                    END AS [senior]
	        ,CASE   WHEN MAX(CASE WHEN [minority] = 'Minority' THEN 1 ELSE 0 END) = 1
                    THEN 'Minority'
                    ELSE 'Non-Minority'
                    END AS [minority]
	        ,CASE   WHEN MAX(CASE WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END) = 1
                    THEN 'Low Income'
                    ELSE 'Non-Low Income'
                    END AS [low_income]
        FROM
	        [dimension].[household]
        INNER JOIN
	        [fed_rtp_20].[fn_person_coc] (@scenario_id)
        ON
	        [household].[scenario_id] = [fn_person_coc].[scenario_id]
	        AND [household].[household_id] = [fn_person_coc].[household_id]
        WHERE
	        [household].[scenario_id] = @scenario_id
        GROUP BY
	        [household].[household_id]
	        ,[household].[income]
	        ,[household].[weight_household]) AS [coc_households]
    ON
	    [household_costs].[household_id] = [coc_households].[household_id]


    -- aggregate household result set transportation costs as a percentage of 
    -- household income to Community of Concern household groups
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure F' AS [performance_measure]
	    ,CONCAT('Percentage of Household Income Spent on Transportation Costs - ',
                [pop_segmentation]) AS [metric]
	    ,[annual_cost] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            100.0 * SUM(CASE    WHEN [senior] = 'Senior'
                                THEN [weight_household] ELSE 0 END *
		                CASE    WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [senior] = 'Senior'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Senior] -- cap percentage cost at 100% of income
            ,100.0 * SUM(CASE   WHEN [senior] = 'Non-Senior'
                                THEN [weight_household] ELSE 0 END *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [senior] = 'Non-Senior'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Non-Senior] -- cap percentage cost at 100% of income
            ,100.0 * SUM(CASE   WHEN [minority] = 'Minority'
                                THEN [weight_household] ELSE 0 END *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [minority] = 'Minority'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Minority] -- cap percentage cost at 100% of income
            ,100.0 * SUM(CASE   WHEN [minority] = 'Non-Minority'
                                THEN [weight_household] ELSE 0 END *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [minority] = 'Non-Minority'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Non-Minority] -- cap percentage cost at 100% of income
            ,100.0 * SUM(CASE   WHEN [low_income] = 'Low Income'
                                THEN [weight_household] ELSE 0 END *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [low_income] = 'Low Income'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Low Income] -- cap percentage cost at 100% of income
            ,100.0 * SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                                THEN [weight_household] ELSE 0 END *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM(CASE    WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_household] 
                            ELSE 0 END) AS [Non-Low Income] -- cap percentage cost at 100% of income
            ,100.0 * SUM([weight_household] *
		                 CASE   WHEN [income] = 0 OR [annual_cost] / [income] > 1
                                THEN 1 ELSE [annual_cost] / [income] END) /
		        SUM([weight_household]) AS [Total] -- cap percentage cost at 100% of income
        FROM
            @hh_results
        ) AS [to_unpvt]
    UNPIVOT (
        [annual_cost] FOR [pop_segmentation] IN
        ([Senior], [Non-Senior], [Minority], [Non-Minority],
            [Low Income], [Non-Low Income], [Total])) AS [unpvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure F';
GO

-- add metadata for [fed_rtp_20].[sp_pm_F]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_F', 'MS_Description', 'performance metric F'
GO




-- create stored procedure for performance metric #G transit stops -----------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_G_transit_stops]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_G_transit_stops]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**	
summary:   >
    Input for Performance Measure G, Percentage of
	population/employment within 0.5-mile of a transit stop. The
    [stop_id] assigned is the [stop_id] of the minimum [transit_stop_id] by
    [near_node].

filters:   >
    None

revisions: 
    - author: Ziying Ouyang
      modification: change from major transit stops to just unique transit
        stops for the federal 2020 rtp
      date: 3 May 2019
    - author: Ziying Ouyang, Tom King, and Gregor Schroeder
      modification: translate to new abm database structure
      date: 19 Nov 2018
**/
SELECT 
	[transit_stop].[stop_id]
    ,[transit_stop].[near_node]
	,[transit_stop].[transit_stop_shape]
FROM
    [dimension].[transit_stop]
INNER JOIN (
	SELECT
        MIN([transit_stop_id]) AS [transit_stop_id]
	FROM
        [dimension].[transit_stop]
	WHERE
        [scenario_id] = @scenario_id
	GROUP BY
        [near_node]) AS [unique_nodes]
ON
    [transit_stop].[transit_stop_id] = [unique_nodes].transit_stop_id
WHERE
    [transit_stop].scenario_id = @scenario_id

GO

-- add metadata for [fed_rtp_20].[sp_pm_G_transit_stops]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_G_transit_stops', 'MS_Description', 'performance metric G intermediate output of unique transit stops'
GO




-- create stored procedure for performance metric #H -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_H]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_H]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**
summary:   >
    Federal RTP 2020 Performance Measure H, average trip travel time for
    Commercial Vehicles and Trucks to/from freight distribution hubs.
    Similar to Performance Measure 4B in the 2015 RTP. Freight
    distribution hubs are defined by the table
    [fed_rtp_20].[freight_distribution_hub].

filters:   >
    [model_trip].[model_trip_description] IN ('Commercial Vehicle', 'Truck')
        ABM Commercial Vehicle and Truck sub-models
    [geography_trip_origin].[trip_origin_taz_13] IN [fed_rtp_20].[freight_distribution_hub].[taz_13]
        part of OR condition with trip destination Series 13 TAZs
        origin or destination is a freight distribution hub
    [geography_trip_destination].[trip_destination_taz_13] IN [fed_rtp_20].[freight_distribution_hub].[taz_13]
        part of OR condition with trip origin Series 13 TAZs
        origin or destination is a freight distribution hub
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure H result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure H'

    -- calculate average trip travel time in minutes to/from freight
    -- distribution hubs for Commercial Vehicle and Truck sub-models
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure H' AS [performance_measure]
	    ,'Average Travel Time' AS [metric]
	    ,SUM([person_trip].[time_total] * [person_trip].[weight_trip]) /
            SUM([person_trip].[weight_trip]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[model]
    ON
        [person_trip].[model_trip_id] = [model].[model_id]
    INNER JOIN
        [dimension].[geography_trip_origin]
    ON
        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN  -- left outer join for later OR condition
        [fed_rtp_20].[freight_distribution_hub] AS [hub_origin]
    ON
        [geography_trip_origin].[trip_origin_taz_13] = [hub_origin].[taz_13]
    LEFT OUTER JOIN  -- left outer join for later OR condition
        [fed_rtp_20].[freight_distribution_hub] AS [hub_destination]
    ON
        [geography_trip_destination].[trip_destination_taz_13] = [hub_destination].[taz_13]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        -- commercial vehicle and truck models only
        AND [model].[model_description] IN ('Commercial Vehicle',
                                            'Truck')
        -- origin or destination is a Series 13 TAZ freight distribution hub
        AND ([hub_origin].[taz_13] IS NOT NULL
             OR [hub_destination].[taz_13] IS NOT NULL)
END

-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure H';
GO

-- add metadata for [fed_rtp_20].[sp_pm_H]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_H', 'MS_Description', 'performance metric H'
GO




-- create stored procedure for performance metric #I -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_I]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_I]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 Performance Measure I, percent of population engaging in
    more than 20 minutes of daily transportation related physical activity.
    Physical activity is defined as any biking or walking. Formerly
    Performance Measure 7F in the 2015 RTP.

filters:   >
    None

revisions:
    - author: Gregor Schroeder
      modification: renamed to pm_I
      date: 8 May 2019
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 12 Apr 2018
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure I result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure I';


    -- create temporary table to store person-level results
    DECLARE @person_results TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [weight_person] tinyint NOT NULL,
        [activity] float NOT NULL);


    -- insert person result set into a temporary table
    INSERT INTO @person_results
    SELECT
	    [person_coc].[person_id]
        ,[senior]
	    ,[minority]
	    ,[low_income]
        ,[person_coc].[weight_person]
	    ,ISNULL([physical_activity].[activity], 0) AS [activity]
    FROM (
	    SELECT
		    [person_id]
		    ,[weight_person]
		    ,[senior]
		    ,[minority]
		    ,[low_income]
	    FROM
		    [fed_rtp_20].[fn_person_coc] (@scenario_id)) AS [person_coc]
    LEFT OUTER JOIN ( -- keep persons who do not travel
	    SELECT
		    [person_id]
		    ,SUM([time_walk] + [time_bike]) AS [activity]
	    FROM
		    [fact].[person_trip]
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
	    GROUP BY
		    [person_id]) AS [physical_activity]
    ON
	    [person_coc].[person_id] = [physical_activity].[person_id]


    -- aggregate person result set transportation-related physical activity
    -- to Community of Concern groups
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'Performance Measure I' AS [performance_measure]
	    ,CONCAT('Percentage of Population Engaging in Transportation-Related Physical Activity - ',
                [pop_segmentation]) AS [metric]
	    ,[activity] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
    SELECT
        100.0 * SUM(CASE    WHEN [senior] = 'Senior'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [senior] = 'Senior'
                            THEN [weight_person] ELSE 0 END) AS [Senior]
        ,100.0 * SUM(CASE   WHEN [senior] = 'Non-Senior'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [senior] = 'Non-Senior'
                            THEN [weight_person] ELSE 0 END) AS [Non-Senior]
        ,100.0 * SUM(CASE   WHEN [minority] = 'Minority'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [minority] = 'Minority'
                            THEN [weight_person] ELSE 0 END) AS [Minority]
        ,100.0 * SUM(CASE   WHEN [minority] = 'Non-Minority'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [minority] = 'Non-Minority'
                            THEN [weight_person] ELSE 0 END) AS [Non-Minority]
        ,100.0 * SUM(CASE   WHEN [low_income] = 'Low Income'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [low_income] = 'Low Income'
                            THEN [weight_person] ELSE 0 END) AS [Low Income]
        ,100.0 * SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            AND [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM(CASE    WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person] ELSE 0 END) AS [Non-Low Income]
        ,100.0 * SUM(CASE   WHEN [activity] >= 20
                            THEN [weight_person] ELSE 0 END) /
                SUM([weight_person]) AS [Total]
    FROM
        @person_results) AS [to_unpvt]
    UNPIVOT (
        [activity] FOR [pop_segmentation] IN
        ([Senior], [Non-Senior], [Minority], [Non-Minority],
            [Low Income], [Non-Low Income], [Total])) AS [unpvt]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure I';
GO

-- add metadata for [fed_rtp_20].[sp_pm_I]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_I', 'MS_Description', 'performance metric I'
GO




-- create stored procedure for performance metric #J -------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_J]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_J]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**
summary:   >
    Federal RTP 2020 Performance Measure J, average person trip
    travel distance in miles to/from work by mode (defined as direct home-work
    or work-home trips where the mode is determined by the SANDAG tour journey
    mode hierarchy).

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
        trips must originate at home
    [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
        trips must destinate at work
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure A result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure J'

    -- calculate person trip travel distance in miles to/from work by mode
    -- insert into temporary table and caluclate total carpool distance
    SELECT
        ISNULL([mode].[mode_aggregate_description], 'Total') AS [mode_aggregate_description]
	    ,SUM([person_trip].[weight_person_trip]) AS [person_trips]
	    ,SUM([person_trip].[dist_total] * [person_trip].[weight_person_trip]) /
            SUM([person_trip].[weight_person_trip]) AS [avg_person_trip_dist]
    INTO #result_set
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[model]
    ON
        [person_trip].[model_trip_id] = [model].[model_id]
    INNER JOIN
        [dimension].[mode]
    ON
        [person_trip].[mode_trip_id] = [mode].[mode_id]
    INNER JOIN
        [dimension].[purpose_trip_origin]
    ON
        [person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
    INNER JOIN
        [dimension].[purpose_trip_destination]
    ON
        [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        -- resident models only
        AND [model].[model_description] IN ('Individual',
                                            'Internal-External',
                                            'Joint')
        -- direct Home-Work or Work-Home trips
        AND (
            ([purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
                AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work')
            OR
            ([purpose_trip_origin].[purpose_trip_origin_description] = 'Work'
                AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Home')
                )
    GROUP BY
        [mode].[mode_aggregate_description]
    WITH ROLLUP

    -- create total carpool metrics (sr2 + sr3)
    INSERT INTO #result_set
    SELECT
        'Total Carpool' AS [mode_aggregate_description]
        ,SUM([person_trips]) AS [person_trips]
        ,SUM([avg_person_trip_dist] * [person_trips]) /
            SUM([person_trips]) AS [avg_person_trip_dist]
    FROM
        #result_set
    WHERE
        [mode_aggregate_description] IN ('Shared Ride 2',
                                         'Shared Ride 3')

    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,'Performance Measure J' AS [performance_measure]
	    ,CONCAT('Average Direct to Work Travel Distance - ',
                [mode_aggregate_description]) AS [metric]
	    ,[avg_person_trip_dist] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        #result_set
END

-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Performance Measure J';
GO

-- add metadata for [fed_rtp_20].[sp_pm_J]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_J', 'MS_Description', 'performance metric J'
GO




-- Create stored procedure for pmt and bmt inputs to
-- performance measures 3a/3b ------------------------------------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_3ab_pmt_bmt]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_3ab_pmt_bmt]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**	
summary:   >
    Person and bicycle miles travelled used in Performance Measures 3a/3b.
    Includes all models as 3ab vmt is a network based measure that includes
    all models. Similar to [rtp_2015].[sp_pmt_bmt] in the 2015 RTP.

filters:   >
    None

revisions: 
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 20 Apr 2018
**/

SELECT
	@scenario_id AS [scenario_id]
	,SUM([weight_person_trip] * [dist_bike]) AS [bmt]
	,SUM([weight_person_trip] * [dist_walk]) AS [pmt]
FROM
	[fact].[person_trip]
WHERE
	[person_trip].[scenario_id] = @scenario_id
GO

-- add metadata for [fed_rtp_20].[sp_pm_3ab_pmt_bmt]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_3ab_pmt_bmt', 'MS_Description', 'person and bicycle miles travelled used for performance measures 3a/3b'
GO




-- create stored procedure for vmt input to performance measure 3a/3b --------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_3ab_vmt]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_3ab_vmt]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**	
summary:   >
    Network vehicle miles travelled used in Performance Measures 3a/3b.
    Formerly [rtp_2015].[sp_eval_vmt] in the 2015 RTP.

filters:   >
    None

revisions: 
    - author: Ziying Ouyang and Gregor Schroeder
      modification: translate to new abm database structure
      date: 20 Apr 2018
**/

SELECT 
	@scenario_id AS [scenario_id]
	,SUM([hwy_flow].[flow] * [hwy_link].[length_mile]) AS [vmt]
	,SUM(CASE   WHEN [hwy_link].[ijur] = 1
                THEN [flow] * [hwy_link].[length_mile]
                ELSE 0 END) AS [vmt_ijur1]
	,SUM([hwy_flow_mode_wide].[flow_auto] * [hwy_link].[length_mile]) AS [vmt_auto]
	,SUM([hwy_flow_mode_wide].[flow_truck] * [hwy_link].[length_mile]) AS [vmt_truck]
	,SUM([hwy_flow_mode_wide].[flow_bus] * [hwy_link].[length_mile]) / 3.0 AS [vmt_bus]
FROM
	[fact].[hwy_flow]
INNER JOIN
	[dimension].[hwy_link]
ON
	[hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
	AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
INNER JOIN (
	SELECT
		[hwy_link_ab_tod_id]
		,SUM(CASE	WHEN [mode].[mode_description] IN ('Drive Alone Non-Toll',
													   'Drive Alone Toll Eligible',
													   'Shared Ride 2 Non-Toll',
													   'Shared Ride 2 Toll Eligible',
													   'Shared Ride 3 Non-Toll',
													   'Shared Ride 3 Toll Eligible')
					THEN [flow] ELSE 0 END) AS [flow_auto]
		,SUM(CASE	WHEN [mode].[mode_description] IN ('Heavy Heavy Duty Truck (Non-Toll)',
													   'Heavy Heavy Duty Truck (Toll)',
													   'Light Heavy Duty Truck (Non-Toll)',
													   'Light Heavy Duty Truck (Toll)',
													   'Medium Heavy Duty Truck (Non-Toll)',
													   'Medium Heavy Duty Truck (Toll)')
					THEN [flow] ELSE 0 END) AS [flow_truck]
		,SUM(CASE	WHEN [mode].[mode_description] = 'Highway Network Preload - Bus'
					THEN [flow] ELSE 0 END) AS [flow_bus]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
	WHERE
		[scenario_id] = @scenario_id
	GROUP BY
		[hwy_link_ab_tod_id]) AS [hwy_flow_mode_wide]
ON
	[hwy_flow].[scenario_id] = @scenario_id
	AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_flow_mode_wide].[hwy_link_ab_tod_id]
WHERE
	[hwy_flow].[scenario_id] = @scenario_id
	AND [hwy_link].[scenario_id] = @scenario_id
OPTION(MAXDOP 1)
GO

-- add metadata for [fed_rtp_20].[sp_pm_3ab_vmt]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_3ab_vmt', 'MS_Description', 'vehicle miles travelled used for performance measures 3a/3b'
GO




-- create stored procedure for performance metrics #7a/b destinations --------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_7ab_destinations]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_7ab_destinations]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@uats bit = 0  -- 1/0 switch to limit destinations geography to UATS zones
AS
/**	
summary:   >
    Destinations at the MGRA level to be used in calculations
	for Federal RTP 2020 Performance Measures 7a/b. Allows aggregation to
	MGRA or TAZ level for both transit and auto accessibility and optional
	restriction to UATS geography only. Beachactive and parkactive measures
	are left as sums for now for later calculation of indicators of > .5 to
	allow for aggregation.
**/
SET NOCOUNT ON;

-- get Series 13 mgras with weighted centroids contained within the City of
-- San Diego Urban Area Transit Strategy (UATS) districts
DECLARE @uats_mgras TABLE ([mgra] nchar(15) PRIMARY KEY NOT NULL)
INSERT INTO @uats_mgras
SELECT
    CONVERT(nchar, [mgra]) AS [mgra]
FROM OPENQUERY(
	[sql2014b8],
	'SELECT
        [MGRA]
        FROM
        [lis].[gis].[UATS2014_DISSOLVED]
        INNER JOIN
        [lis].[gis].[MGRA13_WEIGHTEDCENTROID]
	    ON [UATS2014_DISSOLVED].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1');

SELECT
	[geography].[mgra_13]
	,[geography].[taz_13]
	,SUM([emp_total] + [collegeenroll] + [othercollegeenroll] + [adultschenrl]) AS [emp_educ] -- used in pm 7a
	,SUM([beachactive]) AS [beachactive] -- used in pm 7b, indicator > .5
	,SUM([emp_health]) AS [emp_health] -- used in pm 7b
	,SUM([parkactive]) AS [parkactive] -- used in pm 7b, indicator > .5
	,SUM([emp_retail]) AS [emp_retail] -- used in pm 7b
FROM
	[fact].[mgra_based_input]
INNER JOIN
	[dimension].[geography]
ON
	[mgra_based_input].[geography_id] = [geography].[geography_id]
LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	@uats_mgras AS [uats_xref]
ON
	[geography].[mgra_13] = [uats_xref].[mgra]
WHERE
	[mgra_based_input].[scenario_id] = @scenario_id
	AND ((@uats = 1 AND [uats_xref].[mgra] IS NOT NULL)
		OR @uats = 0) -- if UATS districts option selected only count destinations within UATS district
GROUP BY
	[geography].[mgra_13]
	,[geography].[taz_13]
HAVING
	SUM([emp_total] + [collegeenroll] + [othercollegeenroll] + [adultschenrl]) > 0
	OR SUM([beachactive]) > 0
	OR SUM([emp_health]) > 0
	OR SUM([parkactive]) > 0
	OR SUM([emp_retail]) > 0
GO

-- Add metadata for [fed_rtp_20].[sp_pm_7ab_destinations]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_7ab_destinations', 'MS_Description', 'performance metric 7ab destinations'
GO




-- create stored procedure for performance metrics #7a/b population ----------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_pm_7ab_population]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_pm_7ab_population]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@age_18_plus bit = 0,  -- 1/0 switch to limit population to aged 18+
	@uats bit = 0  -- 1/0 switch to limit population geography to UATS zones
AS
/**	
summary:   >
    Population at the MGRA level to be used in calculations
	for Federal RTP 2020 Performance Measures 7a/b. Allows aggregation to MGRA
	or TAZ level for both transit and auto accessibility, optional restriction
	to 18+ for employment and enrollment metrics, and optional restriction to
	UATS geography only. Also includes Community of Concern designations.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual',
                                              'Internal-External',
                                              'Joint')
        ABM resident sub-models
**/
SET NOCOUNT ON;

-- get Series 13 mgras with weighted centroids contained within the City of
-- San Diego Urban Area Transit Strategy (UATS) districts
DECLARE @uats_mgras TABLE ([mgra] nchar(15) PRIMARY KEY NOT NULL)
INSERT INTO @uats_mgras
SELECT
    CONVERT(nchar, [mgra]) AS [mgra]
FROM OPENQUERY(
	[sql2014b8],
	'SELECT
        [MGRA]
        FROM
        [lis].[gis].[UATS2014_DISSOLVED]
        INNER JOIN
        [lis].[gis].[MGRA13_WEIGHTEDCENTROID]
	    ON [UATS2014_DISSOLVED].[Shape].STContains([MGRA13_WEIGHTEDCENTROID].[Shape]) = 1');


SELECT
	[geography_household_location].[household_location_mgra_13] AS [mgra_13]
	,[geography_household_location].[household_location_taz_13] AS [taz_13]
	,SUM([fn_person_coc].[weight_person]) AS [pop]
	,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_senior]
    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_non_senior]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_minority]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_non_minority]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_low_income]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                THEN [fn_person_coc].[weight_person]
                ELSE 0 END) AS [pop_non_low_income]
FROM
	[fed_rtp_20].[fn_person_coc] (@scenario_id)
INNER JOIN
    [dimension].[person]
ON
    [fn_person_coc].[scenario_id] = [person].[scenario_id]
	AND [fn_person_coc].[person_id] = [person].[person_id]
INNER JOIN
	[dimension].[household]
ON
	[fn_person_coc].[scenario_id] = [household].[scenario_id]
	AND [fn_person_coc].[household_id] = [household].[household_id]
INNER JOIN
	[dimension].[geography_household_location]
ON
	[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
LEFT OUTER JOIN -- keep as outer join since where clause is	OR condition
	@uats_mgras AS [uats_xref]
ON
	[geography_household_location].[household_location_mgra_13] = [uats_xref].[mgra]
WHERE
    [person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND ((@age_18_plus = 1 AND [person].[age] >= 18)
		OR @age_18_plus = 0) -- if age 18+ option is selected restrict population to individuals age 18 or older
	AND ((@uats = 1 AND [uats_xref].[mgra] IS NOT NULL)
		OR @uats = 0) -- if UATS districts option selected only count population within UATS district
GROUP BY
	[geography_household_location].[household_location_mgra_13]
	,[geography_household_location].[household_location_taz_13]
HAVING
	SUM([fn_person_coc].[weight_person]) > 0
GO

-- Add metadata for [fed_rtp_20].[sp_pm_7ab_population]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_pm_7ab_population', 'MS_Description', 'performance metric 7ab population'
GO




-- create stored procedure for Federal RTP 2020 population -------------------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_population]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_population]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [fed_rtp_20].[pm_results] table instead of
        -- grabbing the results from the [fed_rtp_20].[pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [fed_rtp_20].[pm_results] table is updated with no output
AS

/**	
summary:   >
    Federal RTP 2020 populations by Community of Concern (CoC) and SB375. The
    total population used for CoC designations is the total synthetic
    population of San Diego available to travel while the SB375 population
    includes populations not eligible to travel (prisons, etc...)

filters:   >
    None
**/
SET NOCOUNT ON;

-- if update switch is selected then run and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Federal RTP 2020 Populations';


   with [population] AS (
        SELECT
            [synthetic_pop].[scenario_id]
            ,[Senior]
            ,[Non-Senior]
            ,[Minority]
            ,[Non-Minority]
            ,[Low Income]
            ,[Non-Low Income]
            ,[Total]
            ,[SB375]
        FROM (
            SELECT
                @scenario_id AS [scenario_id]
                ,SUM(CASE   WHEN [senior] = 'Senior'
                            THEN [weight_person]
                            ELSE 0 END) AS [Senior]
                ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Senior]
                ,SUM(CASE   WHEN [minority] = 'Minority'
                            THEN [weight_person]
                            ELSE 0 END) AS [Minority]
                ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Minority]
                ,SUM(CASE   WHEN [low_income] = 'Low Income'
                            THEN [weight_person]
                            ELSE 0 END) AS [Low Income]
                ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person]
                            ELSE 0 END) AS [Non-Low Income]
                ,SUM([weight_person]) AS [Total]
            FROM
                [fed_rtp_20].[fn_person_coc] (@scenario_id)) AS [synthetic_pop]
        INNER JOIN (
            SELECT
                @scenario_id AS [scenario_id]
                ,SUM([pop]) AS [SB375]
            FROM
                [fact].[mgra_based_input]
            WHERE
                [scenario_id] = @scenario_id) AS [sb375_pop]
        ON
            [synthetic_pop].[scenario_id] = [sb375_pop].[scenario_id])
    -- insert result set into Performance Measures results table
    INSERT INTO [fed_rtp_20].[pm_results] (
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
         @scenario_id AS [scenario_id]
        ,'Federal RTP 2020 Populations' AS [performance_measure]
	    ,CONCAT('Population - ', [pop_segmentation]) AS [metric]
	    ,ISNULL([population], 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [population]
    UNPIVOT (
        [population] FOR [pop_segmentation] IN
        ([Senior], [Non-Senior], [Minority], [Non-Minority],
         [Low Income], [Non-Low Income], [SB375], [Total])) AS [unpvt] 

END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[performance_measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [fed_rtp_20].[pm_results]
    WHERE
        [scenario_id] = @scenario_id
        AND [performance_measure] = 'Federal RTP 2020 Populations';
GO

-- add metadata for [fed_rtp_20].[sp_population]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_population', 'MS_Description', 'population segmentation for Federal RTP 2020'
GO




-- create stored procedure to update results in [fed_rtp_20].[pm_results] -------
DROP PROCEDURE IF EXISTS [fed_rtp_20].[sp_update_pm_results]
GO

CREATE PROCEDURE [fed_rtp_20].[sp_update_pm_results]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS

/**	
summary:   >
    Updates all performance measures written out to the [fed_rtp_20].[pm_results]
    table. These include all performance measures except for interim results
    used as inputs for other processes. Measures not included are:
        [fed_rtp_20].[sp_particulate_matter_ctemfac_2014]
        [fed_rtp_20].[sp_particulate_matter_ctemfac_2017]
        [fed_rtp_20].[sp_pm_3ab_pmt_bmt]
        [fed_rtp_20].[sp_pm_3ab_vmt]
        [fed_rtp_20].[sp_pm_5a_hf_transit_stops]
        [fed_rtp_20].[sp_pm_G_major_transit_stops]
        [fed_rtp_20].[sp_pm_7ab_destinations]
        [fed_rtp_20].[sp_pm_7ab_population]

filters:   >
    None
**/
BEGIN
    EXECUTE [fed_rtp_20].[sp_pm_1a] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_2a] @scenario_id, @update = 1, @silent = 1, @uats = 0, @work = 0
    EXECUTE [fed_rtp_20].[sp_pm_2a] @scenario_id, @update = 1, @silent = 1, @uats = 1, @work = 0
    EXECUTE [fed_rtp_20].[sp_pm_2a] @scenario_id, @update = 1, @silent = 1, @uats = 0, @work = 1
    EXECUTE [fed_rtp_20].[sp_pm_2a] @scenario_id, @update = 1, @silent = 1, @uats = 1, @work = 1
    EXECUTE [fed_rtp_20].[sp_pm_2b] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_6a] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_A] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_B] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_C] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_D] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_E] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_F] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_H] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_I] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_pm_J] @scenario_id, @update = 1, @silent = 1
    EXECUTE [fed_rtp_20].[sp_population] @scenario_id, @update = 1, @silent = 1
END
GO

-- add metadata for [fed_rtp_20].[sp_update_pm_results]
EXECUTE [db_meta].[add_xp] 'fed_rtp_20.sp_update_pm_results', 'MS_Description', 'updates results in [fed_rtp_20].[pm_results] table'
GO




-- define [fed_rtp_20] schema permissions -----------------------------------------
-- drop [fed_rtp_20] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'fed_rtp_20_user'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
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

    DROP ROLE [fed_rtp_20_user]
END
GO
-- create user role for [fed_rtp_20] schema
CREATE ROLE [fed_rtp_20_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [fed_rtp_20] stored procedures
GRANT EXECUTE ON SCHEMA :: [fed_rtp_20] TO [fed_rtp_20_user];
GRANT SELECT ON SCHEMA :: [fed_rtp_20] TO [fed_rtp_20_user];
GRANT VIEW DEFINITION ON SCHEMA :: [fed_rtp_20] TO [fed_rtp_20_user];
-- deny insert+update+delete on [fed_rtp_20].[particulate_matter_grid]
DENY DELETE ON [fed_rtp_20].[particulate_matter_grid] TO [fed_rtp_20_user];
DENY INSERT ON [fed_rtp_20].[particulate_matter_grid] TO [fed_rtp_20_user];
DENY UPDATE ON [fed_rtp_20].[particulate_matter_grid] TO [fed_rtp_20_user];
-- deny insert and update on [fed_rtp_20].[pm_results] so user can only
-- add new information via stored procedures, allow deletes
GRANT DELETE ON [fed_rtp_20].[pm_results] TO [fed_rtp_20_user];
DENY INSERT ON [fed_rtp_20].[pm_results] TO [fed_rtp_20_user];
DENY UPDATE ON [fed_rtp_20].[pm_results] TO [fed_rtp_20_user];