-- assumes ctemfac_2014 database exists

SET NOCOUNT ON;
GO


-- create [rp_2021] schema ---------------------------------------------------
-- note [rp_2021] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'rp_2021'
)
EXEC ('CREATE SCHEMA [rp_2021]')
GO

-- add metadata for [rp_2021] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[rp_2021]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'rp_2021', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'rp_2021', 'MS_Description', 'schema to hold all objects associated with the 2021 Regional Plan'
END
GO




-- create table holding series 13 TAZ freight distribution hubs --------------
DROP TABLE IF EXISTS [rp_2021].[freight_distribution_hubs]
/**
summary:   >
    Create table holding series 13 TAZs identified as freight distribution
    hubs. These are used in the stored procedure [rp_2021].[sp_pm_ad7] for
    the 2021 Regional Plan Performance Measure AD-7, the average Truck and
    Commercial Vehicle travel times to and around regional gateways and
    distribution hubs (minutes).
**/
BEGIN
    -- create table to hold freight distribution hubs
	CREATE TABLE [rp_2021].[freight_distribution_hubs] (
        [taz_13] nvarchar(20) NOT NULL,
		CONSTRAINT pk_freightdistributionhubs PRIMARY KEY ([taz_13]))
	WITH (DATA_COMPRESSION = PAGE)

    -- insert data into freight distribution hub table
    INSERT INTO [rp_2021].[freight_distribution_hubs] VALUES
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
	EXECUTE [db_meta].[add_xp] 'rp_2021.freight_distribution_hubs', 'MS_Description', 'table to hold series 13 TAZs identified as freight distribution hubs'
    EXECUTE [db_meta].[add_xp] 'rp_2021.freight_distribution_hubs.taz_13', 'MS_Description', 'series 13 TAZ geography zones'
END
GO




-- create table holding results of rp_2021 measures --------------------------
DROP TABLE IF EXISTS [rp_2021].[results]
/**
summary:   >
    Creates table holding results from 2021 regional plan measures.
    This holds all outputs except for interim results used as inputs
    to other processes from:
        [rp_2021].[sp_particulate_matter_ctemfac_2014]
        [rp_2021].[sp_particulate_matter_ctemfac_2017]
        [rp_2021].[sp_m1_m5_destinations]
        [rp_2021].[sp_m1_m5_populations]
        [rp_2021].[fn_person_coc]
**/
BEGIN
    -- create table to hold results of 2021 regional plan measures
	CREATE TABLE [rp_2021].[results] (
        [scenario_id] int NOT NULL,
		[measure] nvarchar(100) NOT NULL,
        [metric] nvarchar(200) NOT NULL,
        [value] float NOT NULL,
        [updated_by] nvarchar(100) NOT NULL,
        [updated_date] smalldatetime NOT NULL,
		CONSTRAINT pk_results PRIMARY KEY ([scenario_id], [measure], [metric]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'rp_2021.results', 'MS_Description', 'table to hold results for 2021 regional plan measures'
    EXECUTE [db_meta].[add_xp] 'rp_2021.results.scenario_id', 'MS_Description', 'ABM scenario in ABM database [dimension].[scenario]'
	EXECUTE [db_meta].[add_xp] 'rp_2021.results.measure', 'MS_Description', 'name of the regional plan measure'
	EXECUTE [db_meta].[add_xp] 'rp_2021.results.metric', 'MS_Description', 'metric within the measure'
	EXECUTE [db_meta].[add_xp] 'rp_2021.results.value', 'MS_Description', 'value of the specified metric within the measure'
    EXECUTE [db_meta].[add_xp] 'rp_2021.results.updated_by', 'MS_Description', 'SQL username who last updated the value of the specified metric within the measure'
    EXECUTE [db_meta].[add_xp] 'rp_2021.results.updated_date', 'MS_Description', 'date the value of the specified metric within the measure was last updated'
END
GO




-- creates table holding square representation of San Diego ------------------
IF NOT EXISTS (
    SELECT TOP 1
        [object_id]
    FROM
        [sys].[objects]
    WHERE
        [object_id] = OBJECT_ID('[rp_2021].[particulate_matter_grid]')
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
    [rp_2021].[fn_particulate_matter_ctemfac_2014] and
    [rp_2021].[fn_particulate_matter_ctemfac_2017] as well as the stored
    procedures [rp_2021].[sp_particulate_matter_ctemfac_2014] and 
    [rp_2021].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions: 
    - author: Gregor Schroeder, Ziying Ouyang, Rick Curry
      modification: create and translate to new abm database structure
      date: Spring 2018
**/

	RAISERROR('Note: Building [rp_2021].[particulate_matter_grid] takes approximately one hour and 45 minutes at a 100x100 grid size', 0, 1) WITH NOWAIT;

    -- create table to hold representation of square San Diego region
    -- to be split into square polygons
	CREATE TABLE [rp_2021].[particulate_matter_grid] (
		[id] int NOT NULL,
		[shape] geometry NOT NULL,
		[centroid] geometry NOT NULL,
		[mgra_13] nvarchar(20) NOT NULL,
		CONSTRAINT pk_particulatemattergrid PRIMARY KEY ([id]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid', 'MS_Description', 'a square representation of the San Diego region broken into a square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.id', 'MS_Description', 'particulate_matter_grid surrogate key'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.shape', 'MS_Description', 'geometry representation of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.centroid', 'MS_Description', 'geometry representation of centroid of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.mgra_13', 'MS_Description', 'the mgra_13 number that contains the square polygon''s centroid'


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
        [rp_2021].[particulate_matter_grid]([centroid])
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

			INSERT INTO [rp_2021].[particulate_matter_grid] (
                [id], [shape], [centroid], [mgra_13]
            )
			VALUES (@counter, @cell, @centroid, 'Not Applicable')

			SET @y_tracker = @y_tracker + @grid_size;
		END
		SET @x_tracker = @x_tracker + @grid_size;
	END


	-- get xref of grid cell to mgra_13
	UPDATE [rp_2021].[particulate_matter_grid]
	SET [particulate_matter_grid].[mgra_13] = [mgras].[mgra_13]
	FROM
        -- this join is considerably sped up by forcing the query to use 
        -- the spatial index in its query plan
		[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
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
	DELETE FROM [rp_2021].[particulate_matter_grid] WHERE [mgra_13] = 'Not Applicable'
END
GO




-- create function to calculate link-level particulate matter for EMFAC 2014 -
DROP FUNCTION IF EXISTS [rp_2021].[fn_particulate_matter_ctemfac_2014]
GO

CREATE FUNCTION [rp_2021].[fn_particulate_matter_ctemfac_2014]
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
    [rp_2021].[particulate_matter_grid] and the stored
    procedure [rp_2021].[sp_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate emissions for EMFAC 2014.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: removed Idling Exhaust per Ziying Ouyang request
      date: June 2019
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
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] = 'Light Heavy Duty Truck' THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck',
													   'Heavy Heavy Duty Truck')
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
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
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
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [rp_2021].[fn_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2014'
GO




-- create function to calculate link-level particulate matter for EMFAC 2017 -
DROP FUNCTION IF EXISTS [rp_2021].[fn_particulate_matter_ctemfac_2017]
GO

CREATE FUNCTION [rp_2021].[fn_particulate_matter_ctemfac_2017]
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
    [rp_2021].[particulate_matter_grid] and the stored
    procedure [rp_2021].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate emissions for EMFAC 2017.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: removed Idling Exhaust per Ziying Ouyang request
      date: June 2019
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
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] = 'Light Heavy Duty Truck' THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck',
													   'Heavy Heavy Duty Truck')
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
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
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
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [rp_2021].[fn_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2017'
GO




-- create stored procedure to calculate 
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_particulate_matter_ctemfac_2014]
GO

CREATE PROCEDURE [rp_2021].[sp_particulate_matter_ctemfac_2014]
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
    [rp_2021].[particulate_matter_grid] and the function
    [rp_2021].[fn_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: switch final output metric from total particulate
        matter exposure to average person particulate matter exposure
      date: 14 June 2019
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [rp_2021].[fn_particulate_matter_ctemfac_2014] function
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
	[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
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
			[rp_2021].[fn_particulate_matter_ctemfac_2014](@scenario_id)
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
		[rp_2021].[particulate_matter_grid]
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
		[rp_2021].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
	    [geography_household_location].[household_location_mgra_13]
	    ,SUM(CASE WHEN [fn_person_coc].[person_id] > 0 THEN 1 ELSE 0 END) AS [persons]  -- remove not applicable records
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Senior' THEN 1 ELSE 0 END) AS [senior]
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [non_senior]
        ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Minority' THEN 1 ELSE 0 END) AS [minority]
	    ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [non_minority]
        ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [low_income]
	    ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [non_low_income]
    FROM
	    [rp_2021].[fn_person_coc] (@scenario_id)
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
    ,[Average Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) / SUM([persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) / SUM([persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) / SUM([persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) / SUM([senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) / SUM([senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) / SUM([senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) / SUM([minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) / SUM([minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) / SUM([minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM]
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
  [Average Particulate Matter])
OPTION(MAXDOP 1)


-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [rp_2021].[sp_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2014'
GO




-- create stored procedure to calculate
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_particulate_matter_ctemfac_2017]
GO

CREATE PROCEDURE [rp_2021].[sp_particulate_matter_ctemfac_2017]
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
    [rp_2021].[particulate_matter_grid] and the function
    [rp_2021].[fn_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: switch final output metric from total particulate
        matter exposure to average person particulate matter exposure
      date: 14 June 2019
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [rp_2021].[fn_particulate_matter_ctemfac_2017] function
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
	[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
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
			[rp_2021].[fn_particulate_matter_ctemfac_2017](@scenario_id)
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
		[rp_2021].[particulate_matter_grid]
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
		[rp_2021].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
        [geography_household_location].[household_location_mgra_13]
	    ,SUM(CASE WHEN [fn_person_coc].[person_id] > 0 THEN 1 ELSE 0 END) AS [persons]  -- remove not applicable records
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Senior' THEN 1 ELSE 0 END) AS [senior]
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [non_senior]
        ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Minority' THEN 1 ELSE 0 END) AS [minority]
	    ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [non_minority]
        ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [low_income]
	    ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [non_low_income]
    FROM
	    [rp_2021].[fn_person_coc] (@scenario_id)
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
    ,[Average Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) / SUM([persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) / SUM([persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) / SUM([persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) / SUM([senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) / SUM([senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) / SUM([senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) / SUM([minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) / SUM([minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) / SUM([minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM]
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
  [Average Particulate Matter])
OPTION(MAXDOP 1)

-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [rp_2021].[sp_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2017'
GO




-- create function to return ABM population with CoC designations ------------
DROP FUNCTION IF EXISTS [rp_2021].[fn_person_coc]
GO

CREATE FUNCTION [rp_2021].[fn_person_coc]
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
    ,CASE   WHEN [person].[age] >= 75
                OR ([person].[race] IN ('Some Other Race Alone',
									    'Asian Alone',
									    'Black or African American Alone',
									    'Two or More Major Race Groups',
									    'Native Hawaiian and Other Pacific Islander Alone',
									    'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                        OR [person].[hispanic] = 'Hispanic')
                OR [household].[poverty] <= 2
            THEN 'CoC'
            ELSE 'Non-CoC'
            END AS [coc]
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

-- add metadata for [rp_2021].[fn_person_coc]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_person_coc', 'MS_Description', 'return ABM synthetic population with Community of Concern (CoC) designations'
GO




-- create function to return Tier X transit stops ----------------------------
DROP FUNCTION IF EXISTS [rp_2021].[fn_transit_node_tiers]
GO

CREATE FUNCTION [rp_2021].[fn_transit_node_tiers]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Return the transit stop [near_node]/[trcov_id] for Tier 1, Tier 2, and
    Tier 3 transit stops. Note that a single transit stop may be returned
    multiple times under different Tiers. This is used by GIS to calculate
    the 2021 Regional Plan Performance Meausres AD-2 and AD-3.

    Tier 1: hardcoded routes 581, 582 583
    Tier 2: rail routes (light rail and commuter)
    Tier 3: rapid routes (freeway and arterial)

revisions:
    - None
**/
SELECT
    [nodeTiers].[near_node] AS [trcov_id]
    ,[nodeTiers].[tier]
    ,[nodeTiersShape].[transit_stop_shape] AS [shape]
FROM (
    SELECT DISTINCT
        [near_node]
        ,CASE   WHEN [transit_route].[config] / 1000 IN (581, 582, 583) THEN 'Tier 1'
                WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
                    AND [mode_transit_route_description] IN ('Light Rail', 'Commuter Rail')
                    THEN 'Tier 2'
                WHEN [mode_transit_route_description] IN ('Freeway Rapid', 'Arterial Rapid')
                    THEN 'Tier 3'
                ELSE NULL END AS [tier]
    FROM
        [dimension].[transit_stop]
    INNER JOIN
        [dimension].[transit_route]
    ON
        [transit_stop].[scenario_id] = [transit_route].[scenario_id]
        AND [transit_stop].[transit_route_id] = [transit_route].[transit_route_id]
    INNER JOIN
        [dimension].[mode_transit_route]
    ON
        [transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
    WHERE
        [transit_stop].[scenario_id] = @scenario_id
        AND [transit_route].[scenario_id] = @scenario_id
        AND [mode_transit_route_description] NOT IN ('Premium Express Bus', 'Express Bus', 'Local Bus')
    ) AS [nodeTiers]
INNER JOIN (
    SELECT
	    [transit_stop].[near_node]
        ,[transit_stop].[transit_stop_shape]
    FROM
	    [dimension].[transit_stop]
    INNER JOIN (
        SELECT
		    [transit_stop].[scenario_id]
            ,[near_node]
            ,MIN([stop_id]) AS [stop_id]
	    FROM
		    [dimension].[transit_stop]
	    INNER JOIN
		    [dimension].[transit_route]
	    ON
		    [transit_stop].[scenario_id] = [transit_route].[scenario_id]
	        AND [transit_stop].[transit_route_id] = [transit_route].[transit_route_id]
	    INNER JOIN
		    [dimension].[mode_transit_route]
	    ON
		    [transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
	    WHERE
		    [transit_stop].[scenario_id] = @scenario_id
            AND [transit_route].[scenario_id] = @scenario_id
		    AND [mode_transit_route_description] NOT IN ('Premium Express Bus', 'Express Bus', 'Local Bus')
	    GROUP BY
		    [transit_stop].scenario_id, near_node
	    ) AS [minStop]
    ON
	    [transit_stop].[scenario_id] = [minStop].[scenario_id]
	    AND [transit_stop].[stop_id] = [minStop].[stop_id]
) AS [nodeTiersShape]
ON
    [nodeTiers].[near_node] = [nodeTiersShape].[near_node]

GO

-- add metadata for [rp_2021].[fn_transit_node_tiers]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_transit_node_tiers', 'MS_Description', 'inline function returning list of all Tier <<1,2,3>> transit stop nodes used in performance measures AD-2 and AD-3'
GO




-- create destination stored procedure for performance measures M1 and M5 ----
DROP PROCEDURE IF EXISTS [rp_2021].[sp_m1_m5_destinations]
GO

CREATE PROCEDURE [rp_2021].[sp_m1_m5_destinations]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS
/**
summary:   >
    Destinations at the MGRA level used in calculations for the 2021 Regional
    Plan Main Performance Measures M1 and M5. Allows aggregation to MGRA or
    TAZ level for both transit and auto accessibility.
**/
SET NOCOUNT ON;

SELECT
    CONVERT(integer, [geography].[mgra_13]) AS [mgra]
	,CONVERT(integer, [geography].[taz_13]) AS [taz]
    ,ISNULL([mgra_tiers].[tier], 0) AS [employmentCenterTier]  -- used in PM M-5-a and M-5-b
	,[emp_health] AS [empHealth]  -- used in pm M-1-c
	,[parkactive] AS [parkActive]  -- used in pm M-1-b, indicator > .5
	,[emp_retail] AS [empRetail]  -- used in pm M-1-a
    ,[collegeenroll] + [othercollegeenroll] AS [higherLearningEnrollment]  -- used in pm M-5-c
FROM
	[fact].[mgra_based_input]
INNER JOIN
	[dimension].[geography]
ON
	[mgra_based_input].[geography_id] = [geography].[geography_id]
LEFT OUTER JOIN (  -- get indicators if MGRAs in Tier 1-4 employment centers
    SELECT
        [mgra_13],
        [tier]
    FROM OPENQUERY(
	    [sql2014a8],
	    'SELECT
            [mgra_13]
            ,[tier]
         FROM
            [employment].[employment_centers].[fn_get_mgra_xref](1)
         WHERE
            [tier] IN (1,2,3,4)')) AS [mgra_tiers]
ON
	[geography].[mgra_13] = CONVERT(nvarchar, [mgra_tiers].[mgra_13])
WHERE
	[mgra_based_input].[scenario_id] = @scenario_id
GO

-- add metadata for [rp_2021].[sp_m1_m5_destinations]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_m1_m5_destinations', 'MS_Description', 'main performance measures M-1 and M-5 destinations'
GO




-- create population stored procedure for performance measures M1 and M5 -----
DROP PROCEDURE IF EXISTS [rp_2021].[sp_m1_m5_populations]
GO

CREATE PROCEDURE [rp_2021].[sp_m1_m5_populations]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@age_18_plus bit = 0  -- 1/0 switch to limit population to aged 18+
AS
/**
summary:   >
    Population at the MGRA level used in calculations for the 2021 Regional
    Plan Main Performance Measures M1 and M5. Allows aggregation to MGRA
	or TAZ level for both transit and auto accessibility, optional restriction
	to 18+ for employment and education metrics. Also includes Community of
    Concern designations.
**/
SET NOCOUNT ON;

SELECT
	CONVERT(integer, [geography_household_location].[household_location_mgra_13]) AS [mgra]
	,CONVERT(integer, [geography_household_location].[household_location_taz_13]) AS [taz]
	,COUNT([fn_person_coc].[person_id]) AS [pop]
	,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                THEN 1 ELSE 0 END) AS [popSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                THEN 1 ELSE 0 END) AS [popNonSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                THEN 1 ELSE 0 END) AS [popMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                THEN 1 ELSE 0 END) AS [popNonMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                THEN 1 ELSE 0 END) AS [popLowIncome]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                THEN 1 ELSE 0 END) AS [popNonLowIncome]
FROM
	[rp_2021].[fn_person_coc] (@scenario_id)
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
WHERE
    [person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND [person].[person_id] > 0  -- remove Not Applicable values
	AND [household].[household_id] > 0  -- remove Not Applicable values
	AND ((@age_18_plus = 1 AND [person].[age] >= 18)
		OR @age_18_plus = 0)  -- if age 18+ option is selected restrict population to individuals age 18 or older
GROUP BY
	[geography_household_location].[household_location_mgra_13]
	,[geography_household_location].[household_location_taz_13]
GO

-- add metadata for [rp_2021].[sp_m1_m5_populations]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_m1_m5_populations', 'MS_Description', 'main performance measures M-1 and M-5 populations'
GO




-- create stored procedure for performance measure AD-1 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad1]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad1]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 1,  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
	@work bit = 0,  -- 1/0  switch to limit trip purpose to work
    @peak_period bit = 0  -- 1/0 switch to limit trip start to ABM 5 TOD peak
        -- period time periods (AM Peak and PM Peak)
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-1 Mode Share, Percent of
    person-trips by mode with option to filter to work purpose trips (defined
    as outbound work tour where the mode is determined by the SANDAG tour
    journey mode hierarchy) and/or to trips made in the peak period (ABM 5 TOD
    AM Peak and PM Peak periods) for a given ABM scenario.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [tour].[tour_category] = 'Mandatory'
         part of AND condition used if option selected to filter trips to
         outbound work-tour destination only
    [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
        part of AND condition used if option selected to filter trips to
        outbound work-tour destination only
    [time_trip_start].[trip_start_abm_5_tod] IN (2, 4)

revisions:
    - author: None
      modification: None
      date: None
**/
BEGIN
SET NOCOUNT ON;

-- create name of the Performance Measure based on options selected
DECLARE @measure nvarchar(40)
IF(@work = 0 AND @peak_period = 0)
    SET @measure  = 'AD-1 - All Trips'
IF(@work = 0 AND @peak_period = 1)
    SET @measure = 'AD-1 - All Peak Period Trips'
IF(@work = 1 AND @peak_period = 0)
    SET @measure = 'AD-1 - Outbound Work Trips'
IF(@work = 1 AND @peak_period = 1)
    SET @measure = 'AD-1 - Peak Period Outbound Work Trips'

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove AD-1 result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = @measure


    -- create table variable to hold result set
    DECLARE @aggregated_trips TABLE (
	    [mode] nchar(15) NOT NULL,
	    [person_trips] float NOT NULL)


    -- if work option is not selected then get person trips by mode
    -- for resident models only (Individual, Internal-External, Joint)
    -- filtered by trip start time in peak period if option is selected
    IF(@work = 0)
    BEGIN
        INSERT INTO @aggregated_trips
        SELECT
	        ISNULL(CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN ('School Bus',
                                                                               'Taxi',
                                                                               'Non-Pooled TNC',
                                                                               'Pooled TNC')
                        THEN 'Other'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Bike', 'Super-Walk', 'Walk')
                        THEN 'Bike & Walk'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                        THEN 'Carpool'
                        ELSE [mode_trip].[mode_aggregate_trip_description]
                        END, 'Total') AS [mode]
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
            [dimension].[time_trip_start]
        ON
            [person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
        WHERE
	        [person_trip].[scenario_id] = @scenario_id
            -- resident models only
	        AND [model_trip].[model_trip_description] IN ('Individual',
												          'Internal-External',
												          'Joint')
            -- if peak period selected filter trips to ABM 5 TOD Peak Periods
            AND (
                @peak_period = 0 OR
                (@peak_period = 1 AND [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4'))
                )
        GROUP BY
	        CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN ('School Bus',
                                                                        'Taxi',
                                                                        'Non-Pooled TNC',
                                                                        'Pooled TNC')
                        THEN 'Other'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Bike', 'Super-Walk', 'Walk')
                        THEN 'Bike & Walk'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                        THEN 'Carpool'
                        ELSE [mode_trip].[mode_aggregate_trip_description]
                        END
        WITH ROLLUP
    END


    -- if work option is selected
    -- get outbound work tour journeys
    -- for resident models only (Individual, Internal-External, Joint)
    -- filtered by tour origin or tour destination in UATS district if option selected
    -- mode is determined by the SANDAG tour mode hierarchy
    -- person trip weight set to final work destinating person trip weight
    IF(@work = 1)
    BEGIN
        INSERT INTO @aggregated_trips
        SELECT
            ISNULL(CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('School Bus',
                                                                                             'Taxi',
                                                                                             'Non-Pooled TNC',
                                                                                             'Pooled TNC')
                        THEN 'Other'
                        WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Bike', 'Super-Walk', 'Walk')
                        THEN 'Bike & Walk'
                        WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                        THEN 'Carpool'
                        ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                        END, 'Total') AS [mode]
            ,SUM(ISNULL([weight_person_trip], 0)) AS [person_trips]
        FROM
	        [fact].[person_trip]
        INNER JOIN
            [dimension].[tour]
        ON
            [person_trip].[scenario_id] = [tour].[scenario_id]
            AND [person_trip].[tour_id] = [tour].[tour_id]
        INNER JOIN
            [report].[fn_resident_tourjourney_mode](@scenario_id)
        ON
            [person_trip].[scenario_id] = [fn_resident_tourjourney_mode].[scenario_id]
            AND [person_trip].[tour_id] = [fn_resident_tourjourney_mode].[tour_id]
            AND [person_trip].[inbound_id] = [fn_resident_tourjourney_mode].[inbound_id]
        INNER JOIN
            [dimension].[inbound]
        ON
            [person_trip].[inbound_id] = [inbound].[inbound_id]
        INNER JOIN
	        [dimension].[model_trip]
        ON
	        [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
        INNER JOIN
            [dimension].[purpose_trip_destination]
        ON
            [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
        INNER JOIN
            [dimension].[time_trip_start]
        ON
            [person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
        WHERE
	        [person_trip].[scenario_id] = @scenario_id
            AND [tour].[scenario_id] = @scenario_id
            AND [tour].[tour_category] = 'Mandatory'  -- mandatory tours only to remove at-work subtours
            AND [inbound].[inbound_description] = 'Outbound'  -- outbound tour journey legs only
            AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'  -- use person trip weight at the final work destinating trip
            -- resident models only
	        AND [model_trip].[model_trip_description] IN ('Individual',
												            'Internal-External',
												            'Joint')
            -- if peak period selected filter trips to ABM 5 TOD Peak Periods
            AND (
                @peak_period = 0 OR
                (@peak_period = 1 AND [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4'))
                )
        GROUP BY
	        CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('School Bus',
                                                                                      'Taxi',
                                                                                      'Non-Pooled TNC',
                                                                                      'Pooled TNC')
                 THEN 'Other'
                 WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Bike', 'Super-Walk', 'Walk')
                 THEN 'Bike & Walk'
                 WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                 THEN 'Carpool'
                 ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                 END
        WITH ROLLUP
        OPTION (MAXDOP 1)
    END


    -- get and store total person trips
    DECLARE @total_trips float = (
        SELECT [person_trips] FROM @aggregated_trips
        WHERE [mode] = 'Total'
        )


    -- insert mode percentage split into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,@measure AS [measure]
	    ,CONCAT('Percentage of Person Trips - ',
                [all_modes].[mode]) AS [metric]
	    ,ISNULL(100.0 * [person_trips] / @total_trips, 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    @aggregated_trips
    RIGHT OUTER JOIN (  -- ensure all modes are represented
        SELECT DISTINCT
            CASE WHEN [mode_aggregate_trip_description] IN ('Taxi',
                                                            'School Bus',
                                                            'Non-Pooled TNC',
                                                            'Pooled TNC')
                 THEN 'Other'
                 WHEN [mode_aggregate_trip_description] IN ('Bike', 'Super-Walk', 'Walk')
                 THEN 'Bike & Walk'
                 WHEN [mode_aggregate_trip_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                 THEN 'Carpool'
                 ELSE [mode_aggregate_trip_description]
                 END AS [mode]
        FROM
            [dimension].[mode_trip]
        WHERE [mode_aggregate_trip_description] NOT IN ('Heavy Heavy Duty Truck',
                                                        'Light Heavy Duty Truck',
                                                        'Medium Heavy Duty Truck',
                                                        'Not Applicable',
                                                        'Parking Lot',
                                                        'Pickup/Drop-off',
                                                        'Rental car',
                                                        'Shuttle/Van/Courtesy Vehicle')) AS [all_modes]
    ON
        [@aggregated_trips].[mode] = [all_modes].[mode]


    -- insert total trips by mode into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
	    @scenario_id AS [scenario_id]
        ,@measure AS [performance_measure]
	    ,CONCAT('Person Trips - ',
                [all_modes].[mode]) AS [metric]
	    ,ISNULL([person_trips], 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    @aggregated_trips
    RIGHT OUTER JOIN (  -- ensure all modes are represented
        SELECT DISTINCT
            CASE WHEN [mode_aggregate_trip_description] IN ('Taxi',
                                                            'School Bus',
                                                            'Non-Pooled TNC',
                                                            'Pooled TNC')
                 THEN 'Other'
                 WHEN [mode_aggregate_trip_description] IN ('Bike', 'Super-Walk', 'Walk')
                 THEN 'Bike & Walk'
                 WHEN [mode_aggregate_trip_description] IN ('Shared Ride 2', 'Shared Ride 3+')
                 THEN 'Carpool'
                 ELSE [mode_aggregate_trip_description]
                 END AS [mode]
        FROM
            [dimension].[mode_trip]
        WHERE [mode_aggregate_trip_description] NOT IN ('Heavy Heavy Duty Truck',
                                                        'Light Heavy Duty Truck',
                                                        'Medium Heavy Duty Truck',
                                                        'Not Applicable',
                                                        'Parking Lot',
                                                        'Pickup/Drop-off',
                                                        'Rental car',
                                                        'Shuttle/Van/Courtesy Vehicle')) AS [all_modes]
    ON
        [@aggregated_trips].[mode] = [all_modes].[mode]
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = @measure;
END
GO

-- add metadata for [rp_2021].[sp_pm_ad1]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad1', 'MS_Description', 'performance measure AD-1 Mode Share'
GO




-- create stored procedure for performance measure AD-5 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad5]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad5]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 1  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-5 Daily Transit Boardings.
    Total boardings and total boardings for Tier 1 + Tier 2 transit routes
    are provided. Tier 1 + Tier 2 routes are hardcoded based on route numbers.

filters:   >
    [transit_route].[config] / 1000 IN (581, 582, 583)
        Tier 1 transit routes
    [transit_route].[config] / 1000 NOT IN (581, 582, 583) AND [mode_transit_route_description] IN ('Light Rail','Commuter Rail')
        Tier 2 transit routes

revisions:
    - author: None
      modification: None
      date: None
**/
BEGIN
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove AD-5 result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-5'

    -- insert AD-5 results into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
        @scenario_id AS [scenario_id]
        ,'AD-5' AS [measure]
        ,CONCAT('Daily Transit Boardings - ', [tier]) AS [metric]
        ,ISNULL([boardings], 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL(CASE  WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
                            OR ([transit_route].[config] / 1000 NOT IN (581, 582, 583)
                                AND [mode_transit_route_description] IN ('Light Rail','Commuter Rail'))
                         THEN 'Tier 1 and Tier 2'
                         ELSE 'No Tier' END, 'Total') AS [tier]
               ,SUM([boardings]) AS [boardings]
        FROM
               [fact].[transit_onoff]
        INNER JOIN
               [dimension].[transit_route]
        ON
               [transit_onoff].[scenario_id] = [transit_route].[scenario_id]
               AND [transit_onoff].[transit_route_id] = [transit_route].[transit_route_id]
        INNER JOIN
            [dimension].[mode_transit_route]
        ON
            [transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
        WHERE
               [transit_onoff].[scenario_id] = @scenario_id
               AND [transit_route].[scenario_id] = @scenario_id
        GROUP BY
            CASE  WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
                                    OR ([transit_route].[config] / 1000 NOT IN (581, 582, 583)
                                        AND [mode_transit_route_description] IN ('Light Rail','Commuter Rail'))
                                 THEN 'Tier 1 and Tier 2'
                                 ELSE 'No Tier' END
        WITH ROLLUP) AS [boardings]
    WHERE
        [tier] IN ('Tier 1 and Tier 2', 'Total')
END


-- if silent switch is selected then do not output a result set
IF(@silent = 1)
    RETURN;
ELSE
    -- return the result set
    SELECT
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-5';
END
GO

-- add metadata for [rp_2021].[sp_pm_ad5]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad5', 'MS_Description', 'performance measure AD-5 Transit Boardings'
GO




-- create stored procedure for performance measure AD-6 activity per capita --
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad6_activity]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad6_activity]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-6, person-level time engaged in
    transportation-related physical activity per capita (minutes). Physical
    activity is defined as any biking, walking, or micro-mobility.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual',
                                              'Internal-External',
                                              'Joint')
        ABM resident sub-models

revisions:
    - author: None
      modification: None
      date: None
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure AD-6 Activity per Capita result for the
    -- given ABM scenario from the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-6 Transportation-Related Physical Activity per Capita'


    -- create table variable to hold population with
    -- Community of Concern (CoC) attributes
    DECLARE @coc_pop TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(15) NOT NULL,
        [minority] nvarchar(15) NOT NULL,
        [low_income] nvarchar(15) NOT NULL)


    -- assign CoC attributes to each person and insert into a table variable
    INSERT INTO @coc_pop
    SELECT
        [person_id]
        ,[senior]
        ,[minority]
        ,[low_income]
    FROM
        [rp_2021].[fn_person_coc] (@scenario_id)
    WHERE
        [person_id] > 0;  -- remove Not Applicable record


    with [agg_coc_pop] AS (
        -- aggregate the CoC populations and pivot from wide to long
        SELECT
            [pop_segmentation]
            ,[persons]
        FROM (
            SELECT
                SUM(CASE    WHEN [senior] = 'Senior'
                            THEN 1
                            ELSE 0 END) AS [Senior]
                ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                            THEN 1
                            ELSE 0 END) AS [Non-Senior]
                ,SUM(CASE   WHEN [minority] = 'Minority'
                            THEN 1
                            ELSE 0 END) AS [Minority]
                ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                            THEN 1
                            ELSE 0 END) AS [Non-Minority]
                ,SUM(CASE   WHEN [low_income] = 'Low Income'
                            THEN 1
                            ELSE 0 END) AS [Low Income]
                ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            THEN 1
                            ELSE 0 END) AS [Non-Low Income]
                ,COUNT([person_id]) AS [Total]
            FROM
	            @coc_pop) AS [to_unpvt]
        UNPIVOT (
            [persons] FOR [pop_segmentation] IN
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
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Senior]
                ,SUM(CASE   WHEN [senior] = 'Non-Senior'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Non-Senior]
                ,SUM(CASE   WHEN [minority] = 'Minority'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Minority]
                ,SUM(CASE   WHEN [minority] = 'Non-Minority'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Non-Minority]
                ,SUM(CASE   WHEN [low_income] = 'Low Income'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Low Income]
                ,SUM(CASE   WHEN [low_income] = 'Non-Low Income'
                            THEN [weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])
                            ELSE 0 END) AS [Non-Low Income]
                ,SUM([weight_person_trip] * ([time_walk] + [time_bike] + [time_mm])) AS [Total]
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
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'AD-6 Transportation-Related Physical Activity per Capita' AS [measure]
	    ,[agg_coc_pop].[pop_segmentation] AS [metric]
	    ,ISNULL([agg_activity].[physical_activity], 0) / [agg_coc_pop].[persons] AS [value]
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
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-6 Transportation-Related Physical Activity per Capita';
GO

-- add metadata for [rp_2021].[sp_pm_ad6_activity]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad6_activity', 'MS_Description', 'performance metric AD-6 Physical Activity per Capita'
GO




-- create stored procedure for performance metric AD-6 percentage engaged ----
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad6_pct]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad6_pct]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-6, percent of population
    engaging in more than 20 minutes of daily transportation related
    physical activity. Physical activity is defined as any biking, walking,
    or micro-mobility.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual',
                                              'Internal-External',
                                              'Joint')
        ABM resident sub-models

revisions:
    - author: None
      modification: None
      date: None
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure AD-6 Percentage Engaged result for the
    -- given ABM scenario from the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-6 Percentage of Population Engaged in Transportation-Related Physical Activity'


    -- create temporary table to store person-level results
    DECLARE @person_results TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [activity] float NOT NULL);


    -- insert person result set into a temporary table
    INSERT INTO @person_results
    SELECT
	    [person_coc].[person_id]
        ,[senior]
	    ,[minority]
	    ,[low_income]
	    ,ISNULL([physical_activity].[activity], 0) AS [activity]
    FROM (
	    SELECT
		    [person_id]
		    ,[senior]
		    ,[minority]
		    ,[low_income]
	    FROM
		    [rp_2021].[fn_person_coc] (@scenario_id)
         WHERE  -- remove Not Applicable records
            [person_id] > 0) AS [person_coc]
    LEFT OUTER JOIN ( -- keep persons who do not travel
	    SELECT
		    [person_id]
		    ,SUM([time_walk] + [time_bike]) AS [activity]
	    FROM
		    [fact].[person_trip]
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
            AND [person_id] > 0  -- remove Not Applicable records
	    GROUP BY
		    [person_id]) AS [physical_activity]
    ON
	    [person_coc].[person_id] = [physical_activity].[person_id]


    -- aggregate person result set transportation-related physical activity
    -- to Community of Concern groups
    -- insert result set into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
        @scenario_id AS [scenario_id]
        ,'AD-6 Percentage of Population Engaged in Transportation-Related Physical Activity' AS [measure]
	    ,[pop_segmentation] AS [metric]
	    ,[activity] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
    SELECT
        100.0 * SUM(CASE WHEN [senior] = 'Senior' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                SUM(CASE WHEN [senior] = 'Senior' THEN 1 ELSE 0 END) AS [Senior]
        ,100.0 * SUM(CASE WHEN [senior] = 'Non-Senior' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                 SUM(CASE WHEN [senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [Non-Senior]
        ,100.0 * SUM(CASE WHEN [minority] = 'Minority' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                 SUM(CASE WHEN [minority] = 'Minority' THEN 1 ELSE 0 END) AS [Minority]
        ,100.0 * SUM(CASE WHEN [minority] = 'Non-Minority' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                 SUM(CASE WHEN [minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [Non-Minority]
        ,100.0 * SUM(CASE WHEN [low_income] = 'Low Income' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                 SUM(CASE WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [Low Income]
        ,100.0 * SUM(CASE WHEN [low_income] = 'Non-Low Income' AND [activity] >= 20 THEN 1 ELSE 0 END) /
                 SUM(CASE WHEN [low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [Non-Low Income]
        ,100.0 * SUM(CASE WHEN [activity] >= 20 THEN 1 ELSE 0 END) / COUNT([person_id]) AS [Total]
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
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-6 Percentage of Population Engaged in Transportation-Related Physical Activity';
GO

-- add metadata for [rp_2021].[sp_pm_ad6_pct]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad6_pct', 'MS_Description', 'performance metric AD-6 Percentage of Population Engaged in Transportation-Related Physical Activity'
GO




-- create stored procedure for performance measure AD-7 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad7]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad7]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-7, average trip travel time for
    Commercial Vehicles and Trucks to/from freight distribution hubs.
    Freight distribution hubs are defined by the table
    [rp_2021].[freight_distribution_hubs].

filters:   >
    [model_trip].[model_trip_description] IN ('Commercial Vehicle', 'Truck')
        ABM Commercial Vehicle and Truck sub-models
    [geography_trip_origin].[trip_origin_taz_13] IN [freight_distribution_hubs].[taz_13]
        part of OR condition with trip destination Series 13 TAZs
        origin or destination is a freight distribution hub
    [geography_trip_destination].[trip_destination_taz_13] IN [freight_distribution_hubs].[taz_13]
        part of OR condition with trip origin Series 13 TAZs
        origin or destination is a freight distribution hub
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure AD-7 result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-7'

    -- calculate average trip travel time in minutes to/from freight
    -- distribution hubs for Commercial Vehicle and Truck sub-models
    -- insert result set into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'AD-7' AS [measure]
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
        [rp_2021].[freight_distribution_hubs] AS [hub_origin]
    ON
        [geography_trip_origin].[trip_origin_taz_13] = [hub_origin].[taz_13]
    LEFT OUTER JOIN  -- left outer join for later OR condition
        [rp_2021].[freight_distribution_hubs] AS [hub_destination]
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
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-7';
GO

-- add metadata for [rp_2021].[sp_pm_ad7]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad7', 'MS_Description', 'performance measure AD-7, Average truck/commercial vehicle travel times to and around regional gateways and distribution hubs (minutes)'
GO




-- create stored procedure for performance measure AD-10 ---------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_ad10]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_ad10]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure AD-10, percent of household income
    consumed by transportation costs. Transportation costs fall into 6
    categories; auto fare costs (Taxi and TNC), micro-mobility/micro-transit
    fare costs, parking costs, auto operating cost, toll cost, and transit
    fare. Only households with members who travelled are considered in this
    calculation. Costs are multiplied by 300 to estimate annual costs and are
    capped at total household income.

    Auto fare, parking, auto operating, and toll costs are split amongst
    all trip participants excepting non-Joint TNC trips where fare costs are
    assigned to each trip participant. Note auto operating cost and toll cost
    do not apply to Taxi/TNC trips as it is assumed the driver pays for the
    costs. Zero-passenger AV trip costs (parking, auto operating, and toll costs)
    are assigned at the household level.

    Micro-mobility/micro-transit fare costs and transit fare costs are
    assigned to each trip participant. Transit fare costs are reduced by 50%
    for persons aged 60 or over and a person’s transit travel costs are capped
    at $12 or $5 depending if they used premium or non-premium transit mode.


filters:   >
    [model_trip].[model_trip_description] IN ('Individual',
                                              'Internal-External',
                                              'Joint',
                                              'AV 0-Passenger')
        ABM resident sub-models and zero-passenger AV trips of AVs owned
        by synthetic population households
    [dimension].[household]
        limited to households with members who travelled

revisions:
    - author: None
      modification: None
      date: None
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure AD-10 result for the given ABM scenario from
    -- the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-10';


    -- create temporary table to store household-level results
    DECLARE @hh_results TABLE (
        [household_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [household_income] integer NOT NULL,
        [annual_cost] float NOT NULL);

    -- sum costs to ([person_id], [household_id]) level
    with [costs] AS (
	    SELECT
		    [person_trip].[person_id]
		    ,[person_trip].[household_id]
            -- split auto fare cost amongst participants if Joint trip
            -- otherwise assign to each trip participant
            ,SUM(CASE WHEN [model_trip].[model_trip_description] = 'Joint'
                      THEN [cost_fare_drive] * [weight_trip]
                      ELSE [cost_fare_drive] * [weight_person_trip]
                      END) AS [cost_fare_drive]
            -- assign micro-mobility/micro-transit fare costs to each trip participant
            ,SUM(([cost_fare_mm] + [cost_fare_mt]) * [weight_person_trip]) AS [cost_fare_mm_mt]
            -- split parking costs amongst trip participants
            -- note this also captures parking costs for 0-passenger AV trips
            ,SUM([cost_parking] * [weight_trip]) AS [cost_parking]
            -- split auto operating cost amongst trip participants
            -- do not include if Taxi/TNC trip
            -- note this also captures operating costs for 0-passenger AV trips
            ,SUM(CASE WHEN [mode_trip].[mode_trip_description] IN ('TNC to Transit - Local Bus',
                                                                   'TNC to Transit - Premium Transit',
                                                                   'TNC to Transit - Local Bus and Premium Transit',
                                                                   'Taxi',
                                                                   'Non-Pooled TNC',
                                                                   'Pooled TNC')
                      THEN 0
                      ELSE [cost_operating_drive] * [weight_trip]
                      END) AS [cost_operating drive]
            -- split auto toll costs amongst trip participants
            -- do not include if Taxi/TNC trip
            -- note this also captures toll costs for 0-passenger AV trips
            ,SUM(CASE WHEN [mode_trip].[mode_trip_description] IN ('TNC to Transit - Local Bus',
                                                                   'TNC to Transit - Premium Transit',
                                                                   'TNC to Transit - Local Bus and Premium Transit',
                                                                   'Taxi',
                                                                   'Non-Pooled TNC',
                                                                   'Pooled TNC')
                      THEN 0
                      ELSE [cost_toll_drive] * [weight_trip]
                      END) AS [cost_toll_drive]
		    ,SUM(CASE WHEN [person].[age] >= 60 THEN [weight_person_trip] * [cost_fare_transit] * .5
					  ELSE [weight_person_trip] * [cost_fare_transit] END) AS [cost_transit]
		    ,MAX(CASE WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus and Premium Transit',
																   'Kiss and Ride to Transit - Premium Transit Only',
																   'Park and Ride to Transit - Local Bus and Premium Transit',
																   'TNC to Transit - Premium Transit Only',
                                                                   'TNC to Transit - Local Bus and Premium Transit',
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
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
		    AND [person].[scenario_id] = @scenario_id
		    AND [household].[scenario_id] = @scenario_id
            -- San Diego Resident models that use synthetic population
            -- and Zombie AV trips assigned to a synthetic population household
		    AND [model_trip].[model_trip_description] IN ('Individual',
													      'Internal-External',
													      'Joint',
                                                          'AV 0-Passenger')
            -- remove trips not assigned to a synthetic person or household
            AND ([person].[person_id] > 0 OR [household].[household_id] > 0)
	    GROUP BY
		    [person_trip].[person_id]
		    ,[person_trip].[household_id]),
    -- sum costs to [household_id] level
    [total_costs] AS (
	    SELECT
		    -- multiply the cost by 300 to get annual cost and sum over the household to get household costs
		    -- cap person transit costs at $12 or $5 depending on if they used premium or non-premium transit
		    [costs].[household_id]
		    ,SUM(300.0 * ([cost_fare_drive] + [cost_fare_mm_mt] + [cost_parking] +
                          [cost_operating drive] + [cost_toll_drive] +
			              CASE	WHEN [premium_transit_indicator] = 1 AND [cost_transit] > 12 THEN 12
					            WHEN [premium_transit_indicator] = 0 AND [cost_transit] > 5 THEN 5
					            ELSE [cost_transit] END)) AS [annual_cost]
	    FROM
		    [costs]
	    GROUP BY
		    [costs].[household_id])
    -- insert household level total costs into a temporary table
    INSERT INTO @hh_results
    SELECT
        [total_costs].[household_id]
	    ,[senior]
	    ,[minority]
	    ,[low_income]
	    ,[household_income]
	    ,[annual_cost]
    FROM
	    [total_costs]
    INNER JOIN (  -- only keep households that actually travelled
        SELECT
	        [household].[household_id]
	        ,MAX([household].[household_income]) AS [household_income]
	        ,CASE   WHEN MAX(CASE WHEN [senior] = 'Senior' THEN 1 ELSE 0 END) = 1
                    THEN 'Senior' ELSE 'Non-Senior' END AS [senior]
	        ,CASE   WHEN MAX(CASE WHEN [minority] = 'Minority' THEN 1 ELSE 0 END) = 1
                    THEN 'Minority' ELSE 'Non-Minority' END AS [minority]
	        ,CASE   WHEN MAX(CASE WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END) = 1
                    THEN 'Low Income' ELSE 'Non-Low Income' END AS [low_income]
        FROM
	        [dimension].[household]
        INNER JOIN
	        [rp_2021].[fn_person_coc] (@scenario_id)
        ON
	        [household].[scenario_id] = [fn_person_coc].[scenario_id]
	        AND [household].[household_id] = [fn_person_coc].[household_id]
        WHERE
	        [household].[scenario_id] = @scenario_id
            AND [household].[household_id] > 0  -- remove Not Applicable records
        GROUP BY
	        [household].[household_id]) AS [coc_households]
    ON
	    [total_costs].[household_id] = [coc_households].[household_id]


    -- aggregate household result set transportation costs as a percentage of
    -- household income to Community of Concern household groups
    -- insert result set into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    )
    SELECT
        @scenario_id AS [scenario_id]
        ,'AD-10' AS [measure]
	    ,[pop_segmentation] AS [metric]
	    ,[annual_cost] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            100.0 * SUM(CASE    WHEN [senior] = 'Senior' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [senior] = 'Senior' THEN 1  ELSE 0 END) AS [Senior]
            ,100.0 * SUM(CASE    WHEN [senior] = 'Non-Senior' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [senior] = 'Non-Senior' THEN 1  ELSE 0 END) AS [Non-Senior]
            ,100.0 * SUM(CASE    WHEN [minority] = 'Minority' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [minority] = 'Minority' THEN 1  ELSE 0 END) AS [Minority]
            ,100.0 * SUM(CASE    WHEN [minority] = 'Non-Minority' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [minority] = 'Non-Minority' THEN 1  ELSE 0 END) AS [Non-Minority]
            ,100.0 * SUM(CASE    WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [low_income] = 'Low Income' THEN 1  ELSE 0 END) AS [Low Income]
            ,100.0 * SUM(CASE    WHEN [low_income] = 'Non-Low Income' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		                CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        SUM(CASE    WHEN [low_income] = 'Non-Low Income' THEN 1  ELSE 0 END) AS [Non-Low Income]
            ,100.0 * SUM(CASE   WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                                THEN 1 ELSE [annual_cost] / [household_income] END) /
		        COUNT([household_id]) AS [Total]
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
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'AD-10';
GO

-- add metadata for [rp_2021].[sp_pm_ad10]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_ad10', 'MS_Description', 'performance measure AD-10, Percent of Income Consumed by Out-of-Pocket Transportation Costs'
GO




-- create stored procedure for performance metric M-4 ------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_m4]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_m4]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[sp_pm_2b] table instead of
        -- grabbing the results from the [rp_2021].[sp_pm_2b] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[sp_pm_2b] table is updated with no output
AS

/**
summary:   >
    Performance Measure M-4, network VMT per capita and regionwide for a given
    ABM scenario.

filters:   >
    None

revisions:
    - author: None
      modification: None
      date: None
**/
SET NOCOUNT ON;


-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure M-4 result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'M-4'


    -- subquery for total synthetic population
    DECLARE @population integer = (
        SELECT
            COUNT([person_id])
        FROM
            [dimension].[person]
        WHERE
            [scenario_id] = @scenario_id
            AND [person_id] > 0  -- remove Not Applicable record
    )


    -- insert VMT per capita into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'M-4' AS [measure]
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
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'M-4' AS [measure]
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
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date]
    FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'M-4';
GO

-- add metadata for [rp_2021].[sp_pm_m4]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_m4', 'MS_Description', 'performance metric M-4 Vehicle Miles Travelled (VMT)'
GO




-- define [rp_2021] schema permissions -----------------------------------------
-- drop [rp_2021] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'rp_2021_user'

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

    DROP ROLE [rp_2021_user]
END
GO
-- create user role for [rp_2021] schema
CREATE ROLE [rp_2021_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [rp_2021] stored procedures
GRANT EXECUTE ON SCHEMA :: [rp_2021] TO [rp_2021_user];
GRANT SELECT ON SCHEMA :: [rp_2021] TO [rp_2021_user];
GRANT VIEW DEFINITION ON SCHEMA :: [rp_2021] TO [rp_2021_user];
-- deny insert+update+delete on [rp_2021].[particulate_matter_grid]
DENY DELETE ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
DENY INSERT ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
DENY UPDATE ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
-- deny insert and update on [rp_2021].[pm_results] so user can only
-- add new information via stored procedures, allow deletes
GRANT DELETE ON [rp_2021].[pm_results] TO [rp_2021_user];
DENY INSERT ON [rp_2021].[pm_results] TO [rp_2021_user];
DENY UPDATE ON [rp_2021].[pm_results] TO [rp_2021_user];