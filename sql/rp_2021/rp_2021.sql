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
    hubs. These are used in the stored procedure [rp_2021].[sp_pm_sm7] for
    the 2021 Regional Plan Performance Measure SM-7, the average Truck and
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




-- create table holding series 13 MGRA mobility hubs -------------------------
DROP TABLE IF EXISTS [rp_2021].[mobility_hubs]
/**
summary:   >
    Create table holding series 13 MGRAs identified as mobility hubs.
    hubs. These are used in the stored procedure [rp_2021].[sp_pm_sm5] for
    the 2021 Regional Plan Performance Measure SM-5 and for all access-based
    Primary Measures.
**/
BEGIN
    -- create table to hold mobility hubs
	CREATE TABLE [rp_2021].[mobility_hubs] (
        [mgra_13] nvarchar(20) NOT NULL,
        [mobility_hub_name] nvarchar(50) NOT NULL,
        [mobility_hub_type] nvarchar(50) NOT NULL,
        [has_carshare2035] bit NOT NULL,
		CONSTRAINT pk_mobilityhubs PRIMARY KEY ([mgra_13]))
	WITH (DATA_COMPRESSION = PAGE)

    -- insert data into mobility hub table
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('1','Urban Core','Urban',1),
        ('2','Urban Core','Urban',1),
        ('3','Urban Core','Urban',1),
        ('4','Urban Core','Urban',1),
        ('5','Urban Core','Urban',1),
        ('6','Urban Core','Urban',1),
        ('7','Urban Core','Urban',1),
        ('8','Urban Core','Urban',1),
        ('9','Urban Core','Urban',1),
        ('10','Urban Core','Urban',1),
        ('11','Urban Core','Urban',1),
        ('12','Urban Core','Urban',1),
        ('13','Urban Core','Urban',1),
        ('14','Urban Core','Urban',1),
        ('15','Urban Core','Urban',1),
        ('16','Urban Core','Urban',1),
        ('17','Urban Core','Urban',1),
        ('18','Urban Core','Urban',1),
        ('19','Urban Core','Urban',1),
        ('20','Urban Core','Urban',1),
        ('21','Urban Core','Urban',1),
        ('22','Urban Core','Urban',1),
        ('23','Urban Core','Urban',1),
        ('24','Urban Core','Urban',1),
        ('25','Urban Core','Urban',1),
        ('26','Urban Core','Urban',1),
        ('27','Urban Core','Urban',1),
        ('28','Urban Core','Urban',1),
        ('29','Urban Core','Urban',1),
        ('30','Urban Core','Urban',1),
        ('31','Urban Core','Urban',1),
        ('32','Urban Core','Urban',1),
        ('33','Urban Core','Urban',1),
        ('34','Urban Core','Urban',1),
        ('35','Urban Core','Urban',1),
        ('36','Urban Core','Urban',1),
        ('37','Urban Core','Urban',1),
        ('38','Urban Core','Urban',1),
        ('39','Urban Core','Urban',1),
        ('40','Urban Core','Urban',1),
        ('41','Urban Core','Urban',1),
        ('42','Urban Core','Urban',1),
        ('43','Urban Core','Urban',1),
        ('44','Urban Core','Urban',1),
        ('45','Urban Core','Urban',1),
        ('46','Urban Core','Urban',1),
        ('47','Urban Core','Urban',1),
        ('48','Urban Core','Urban',1),
        ('49','Urban Core','Urban',1),
        ('50','Urban Core','Urban',1),
        ('51','Urban Core','Urban',1),
        ('52','Urban Core','Urban',1),
        ('53','Urban Core','Urban',1),
        ('54','Urban Core','Urban',1),
        ('55','Urban Core','Urban',1),
        ('56','Urban Core','Urban',1),
        ('57','Urban Core','Urban',1),
        ('58','Urban Core','Urban',1),
        ('59','Urban Core','Urban',1),
        ('60','Urban Core','Urban',1),
        ('61','Urban Core','Urban',1),
        ('62','Urban Core','Urban',1),
        ('63','Urban Core','Urban',1),
        ('64','Urban Core','Urban',1),
        ('65','Urban Core','Urban',1),
        ('66','Urban Core','Urban',1),
        ('67','Urban Core','Urban',1),
        ('68','Urban Core','Urban',1),
        ('69','Urban Core','Urban',1),
        ('70','Urban Core','Urban',1),
        ('71','Urban Core','Urban',1),
        ('72','Urban Core','Urban',1),
        ('73','Urban Core','Urban',1),
        ('74','Urban Core','Urban',1),
        ('75','Urban Core','Urban',1),
        ('76','Urban Core','Urban',1),
        ('77','Urban Core','Urban',1),
        ('78','Urban Core','Urban',1),
        ('79','Urban Core','Urban',1),
        ('80','Urban Core','Urban',1),
        ('81','Urban Core','Urban',1),
        ('82','Urban Core','Urban',1),
        ('83','Urban Core','Urban',1),
        ('84','Urban Core','Urban',1),
        ('85','Urban Core','Urban',1),
        ('86','Urban Core','Urban',1),
        ('87','Urban Core','Urban',1),
        ('88','Urban Core','Urban',1),
        ('89','Urban Core','Urban',1),
        ('90','Urban Core','Urban',1),
        ('91','Urban Core','Urban',1),
        ('92','Urban Core','Urban',1),
        ('93','Urban Core','Urban',1),
        ('94','Urban Core','Urban',1),
        ('95','Urban Core','Urban',1),
        ('96','Urban Core','Urban',1),
        ('97','Urban Core','Urban',1),
        ('98','Urban Core','Urban',1),
        ('99','Urban Core','Urban',1),
        ('100','Urban Core','Urban',1),
        ('101','Urban Core','Urban',1),
        ('102','Urban Core','Urban',1),
        ('103','Urban Core','Urban',1),
        ('104','Urban Core','Urban',1),
        ('105','Urban Core','Urban',1),
        ('106','Urban Core','Urban',1),
        ('107','Urban Core','Urban',1),
        ('108','Urban Core','Urban',1),
        ('109','Urban Core','Urban',1),
        ('110','Urban Core','Urban',1),
        ('111','Urban Core','Urban',1),
        ('112','Urban Core','Urban',1),
        ('113','Urban Core','Urban',1),
        ('114','Urban Core','Urban',1),
        ('115','Urban Core','Urban',1),
        ('116','Urban Core','Urban',1),
        ('117','Urban Core','Urban',1),
        ('118','Urban Core','Urban',1),
        ('119','Urban Core','Urban',1),
        ('120','Urban Core','Urban',1),
        ('121','Urban Core','Urban',1),
        ('122','Urban Core','Urban',1),
        ('123','Urban Core','Urban',1),
        ('124','Urban Core','Urban',1),
        ('125','Urban Core','Urban',1),
        ('126','Urban Core','Urban',1),
        ('127','Urban Core','Urban',1),
        ('128','Urban Core','Urban',1),
        ('129','Urban Core','Urban',1),
        ('130','Urban Core','Urban',1),
        ('131','Urban Core','Urban',1),
        ('132','Urban Core','Urban',1),
        ('133','Urban Core','Urban',1),
        ('134','Urban Core','Urban',1),
        ('135','Urban Core','Urban',1),
        ('136','Urban Core','Urban',1),
        ('137','Urban Core','Urban',1),
        ('138','Urban Core','Urban',1),
        ('139','Urban Core','Urban',1),
        ('140','Urban Core','Urban',1),
        ('141','Urban Core','Urban',1),
        ('142','Urban Core','Urban',1),
        ('143','Urban Core','Urban',1),
        ('144','Urban Core','Urban',1),
        ('145','Urban Core','Urban',1),
        ('146','Urban Core','Urban',1),
        ('147','Urban Core','Urban',1),
        ('148','Urban Core','Urban',1),
        ('149','Urban Core','Urban',1),
        ('150','Urban Core','Urban',1),
        ('151','Urban Core','Urban',1),
        ('152','Urban Core','Urban',1),
        ('153','Urban Core','Urban',1),
        ('154','Urban Core','Urban',1),
        ('155','Urban Core','Urban',1),
        ('156','Urban Core','Urban',1),
        ('157','Urban Core','Urban',1),
        ('158','Urban Core','Urban',1),
        ('159','Urban Core','Urban',1),
        ('160','Urban Core','Urban',1),
        ('161','Urban Core','Urban',1),
        ('162','Urban Core','Urban',1),
        ('163','Urban Core','Urban',1),
        ('164','Urban Core','Urban',1),
        ('165','Urban Core','Urban',1),
        ('166','Urban Core','Urban',1),
        ('167','Urban Core','Urban',1),
        ('168','Urban Core','Urban',1),
        ('169','Urban Core','Urban',1),
        ('170','Urban Core','Urban',1),
        ('171','Urban Core','Urban',1),
        ('172','Urban Core','Urban',1),
        ('173','Urban Core','Urban',1),
        ('174','Urban Core','Urban',1),
        ('175','Urban Core','Urban',1),
        ('176','Urban Core','Urban',1),
        ('177','Urban Core','Urban',1),
        ('178','Urban Core','Urban',1),
        ('179','Urban Core','Urban',1),
        ('180','Urban Core','Urban',1),
        ('181','Urban Core','Urban',1),
        ('182','Urban Core','Urban',1),
        ('183','Urban Core','Urban',1),
        ('184','Urban Core','Urban',1),
        ('185','Urban Core','Urban',1),
        ('186','Urban Core','Urban',1),
        ('187','Urban Core','Urban',1),
        ('188','Urban Core','Urban',1),
        ('189','Urban Core','Urban',1),
        ('190','Urban Core','Urban',1),
        ('191','Urban Core','Urban',1),
        ('192','Urban Core','Urban',1),
        ('193','Urban Core','Urban',1),
        ('194','Urban Core','Urban',1),
        ('195','Urban Core','Urban',1),
        ('196','Urban Core','Urban',1),
        ('197','Urban Core','Urban',1),
        ('198','Urban Core','Urban',1),
        ('199','Urban Core','Urban',1),
        ('200','Urban Core','Urban',1),
        ('201','Urban Core','Urban',1),
        ('202','Urban Core','Urban',1),
        ('203','Urban Core','Urban',1),
        ('204','Urban Core','Urban',1),
        ('205','Urban Core','Urban',1),
        ('206','Urban Core','Urban',1),
        ('207','Urban Core','Urban',1),
        ('208','Urban Core','Urban',1),
        ('209','Urban Core','Urban',1),
        ('210','Urban Core','Urban',1),
        ('211','Urban Core','Urban',1),
        ('212','Urban Core','Urban',1),
        ('213','Urban Core','Urban',1),
        ('214','Urban Core','Urban',1),
        ('215','Urban Core','Urban',1),
        ('216','Urban Core','Urban',1),
        ('217','Urban Core','Urban',1),
        ('218','Urban Core','Urban',1),
        ('219','Urban Core','Urban',1),
        ('220','Urban Core','Urban',1),
        ('221','Urban Core','Urban',1),
        ('222','Urban Core','Urban',1),
        ('223','Urban Core','Urban',1),
        ('224','Urban Core','Urban',1),
        ('225','Urban Core','Urban',1),
        ('226','Urban Core','Urban',1),
        ('227','Urban Core','Urban',1),
        ('228','Urban Core','Urban',1),
        ('229','Urban Core','Urban',1),
        ('230','Urban Core','Urban',1),
        ('231','Urban Core','Urban',1),
        ('232','Urban Core','Urban',1),
        ('233','Urban Core','Urban',1),
        ('234','Urban Core','Urban',1),
        ('235','Urban Core','Urban',1),
        ('236','Urban Core','Urban',1),
        ('237','Urban Core','Urban',1),
        ('238','Urban Core','Urban',1),
        ('239','Urban Core','Urban',1),
        ('240','Urban Core','Urban',1),
        ('241','Urban Core','Urban',1),
        ('242','Urban Core','Urban',1),
        ('243','Urban Core','Urban',1),
        ('244','Urban Core','Urban',1),
        ('245','Urban Core','Urban',1),
        ('246','Urban Core','Urban',1),
        ('247','Urban Core','Urban',1),
        ('248','Urban Core','Urban',1),
        ('249','Urban Core','Urban',1),
        ('250','Urban Core','Urban',1),
        ('251','Urban Core','Urban',1),
        ('252','Urban Core','Urban',1),
        ('253','Urban Core','Urban',1),
        ('254','Urban Core','Urban',1),
        ('255','Urban Core','Urban',1),
        ('256','Urban Core','Urban',1),
        ('257','Urban Core','Urban',1),
        ('258','Urban Core','Urban',1),
        ('259','Urban Core','Urban',1),
        ('260','Urban Core','Urban',1),
        ('261','Urban Core','Urban',1),
        ('262','Urban Core','Urban',1),
        ('263','Urban Core','Urban',1),
        ('264','Urban Core','Urban',1),
        ('265','Urban Core','Urban',1),
        ('266','Urban Core','Urban',1),
        ('267','Urban Core','Urban',1),
        ('268','Urban Core','Urban',1),
        ('269','Urban Core','Urban',1),
        ('270','Urban Core','Urban',1),
        ('271','Urban Core','Urban',1),
        ('272','Urban Core','Urban',1),
        ('273','Urban Core','Urban',1),
        ('274','Urban Core','Urban',1),
        ('275','Urban Core','Urban',1),
        ('276','Urban Core','Urban',1),
        ('277','Urban Core','Urban',1),
        ('278','Urban Core','Urban',1),
        ('279','Urban Core','Urban',1),
        ('280','Urban Core','Urban',1),
        ('281','Urban Core','Urban',1),
        ('282','Urban Core','Urban',1),
        ('283','Urban Core','Urban',1),
        ('284','Urban Core','Urban',1),
        ('285','Urban Core','Urban',1),
        ('286','Urban Core','Urban',1),
        ('287','Urban Core','Urban',1),
        ('288','Urban Core','Urban',1),
        ('289','Urban Core','Urban',1),
        ('290','Urban Core','Urban',1),
        ('291','Urban Core','Urban',1),
        ('292','Urban Core','Urban',1),
        ('293','Urban Core','Urban',1),
        ('294','Urban Core','Urban',1),
        ('295','Urban Core','Urban',1),
        ('296','Urban Core','Urban',1),
        ('297','Urban Core','Urban',1),
        ('298','Urban Core','Urban',1),
        ('299','Urban Core','Urban',1),
        ('300','Urban Core','Urban',1),
        ('301','Urban Core','Urban',1),
        ('302','Urban Core','Urban',1),
        ('303','Urban Core','Urban',1),
        ('304','Urban Core','Urban',1),
        ('305','Urban Core','Urban',1),
        ('306','Urban Core','Urban',1),
        ('307','Urban Core','Urban',1),
        ('308','Urban Core','Urban',1),
        ('309','Urban Core','Urban',1),
        ('310','Urban Core','Urban',1),
        ('311','Urban Core','Urban',1),
        ('312','Urban Core','Urban',1),
        ('313','Urban Core','Urban',1),
        ('314','Urban Core','Urban',1),
        ('315','Urban Core','Urban',1),
        ('316','Urban Core','Urban',1),
        ('317','Urban Core','Urban',1),
        ('318','Urban Core','Urban',1),
        ('319','Urban Core','Urban',1),
        ('320','Urban Core','Urban',1),
        ('321','Urban Core','Urban',1),
        ('322','Urban Core','Urban',1),
        ('323','Urban Core','Urban',1),
        ('324','Urban Core','Urban',1),
        ('325','Urban Core','Urban',1),
        ('326','Urban Core','Urban',1),
        ('327','Urban Core','Urban',1),
        ('328','Urban Core','Urban',1),
        ('329','Urban Core','Urban',1),
        ('330','Urban Core','Urban',1),
        ('331','Urban Core','Urban',1),
        ('332','Urban Core','Urban',1),
        ('333','Urban Core','Urban',1),
        ('334','Urban Core','Urban',1),
        ('335','Urban Core','Urban',1),
        ('336','Urban Core','Urban',1),
        ('337','Urban Core','Urban',1),
        ('338','Urban Core','Urban',1),
        ('339','Urban Core','Urban',1),
        ('340','Urban Core','Urban',1),
        ('341','Urban Core','Urban',1),
        ('342','Urban Core','Urban',1),
        ('343','Urban Core','Urban',1),
        ('344','Urban Core','Urban',1),
        ('345','Urban Core','Urban',1),
        ('346','Urban Core','Urban',1),
        ('347','Urban Core','Urban',1),
        ('348','Urban Core','Urban',1),
        ('349','Urban Core','Urban',1),
        ('350','Urban Core','Urban',1),
        ('351','Urban Core','Urban',1),
        ('352','Urban Core','Urban',1),
        ('353','Urban Core','Urban',1),
        ('354','Urban Core','Urban',1),
        ('355','Urban Core','Urban',1),
        ('356','Urban Core','Urban',1),
        ('357','Urban Core','Urban',1),
        ('358','Urban Core','Urban',1),
        ('359','Urban Core','Urban',1),
        ('360','Urban Core','Urban',1),
        ('361','Urban Core','Urban',1),
        ('362','Urban Core','Urban',1),
        ('363','Urban Core','Urban',1),
        ('364','Urban Core','Urban',1),
        ('365','Urban Core','Urban',1),
        ('366','Urban Core','Urban',1),
        ('367','Urban Core','Urban',1),
        ('368','Urban Core','Urban',1),
        ('369','Urban Core','Urban',1),
        ('370','Urban Core','Urban',1),
        ('371','Urban Core','Urban',1),
        ('372','Urban Core','Urban',1),
        ('373','Urban Core','Urban',1),
        ('374','Urban Core','Urban',1),
        ('375','Urban Core','Urban',1),
        ('376','Urban Core','Urban',1),
        ('377','Urban Core','Urban',1),
        ('378','Urban Core','Urban',1),
        ('379','Urban Core','Urban',1),
        ('380','Urban Core','Urban',1),
        ('381','Urban Core','Urban',1),
        ('382','Urban Core','Urban',1),
        ('383','Urban Core','Urban',1),
        ('384','Urban Core','Urban',1),
        ('385','Urban Core','Urban',1),
        ('386','Urban Core','Urban',1),
        ('387','Urban Core','Urban',1),
        ('388','Urban Core','Urban',1),
        ('389','Urban Core','Urban',1),
        ('390','Urban Core','Urban',1),
        ('391','Urban Core','Urban',1),
        ('392','Urban Core','Urban',1),
        ('393','Urban Core','Urban',1),
        ('394','Urban Core','Urban',1),
        ('395','Urban Core','Urban',1),
        ('396','Urban Core','Urban',1),
        ('397','Urban Core','Urban',1),
        ('398','Urban Core','Urban',1),
        ('399','Urban Core','Urban',1),
        ('400','Urban Core','Urban',1),
        ('401','Urban Core','Urban',1),
        ('402','Urban Core','Urban',1),
        ('403','Urban Core','Urban',1),
        ('404','Urban Core','Urban',1),
        ('405','Urban Core','Urban',1),
        ('406','Urban Core','Urban',1),
        ('407','Urban Core','Urban',1),
        ('408','Urban Core','Urban',1),
        ('409','Urban Core','Urban',1),
        ('410','Urban Core','Urban',1),
        ('411','Urban Core','Urban',1),
        ('412','Urban Core','Urban',1),
        ('413','Urban Core','Urban',1),
        ('414','Urban Core','Urban',1),
        ('415','Urban Core','Urban',1),
        ('416','Urban Core','Urban',1),
        ('417','Urban Core','Urban',1),
        ('418','Urban Core','Urban',1),
        ('419','Urban Core','Urban',1),
        ('420','Urban Core','Urban',1),
        ('421','Urban Core','Urban',1),
        ('422','Urban Core','Urban',1),
        ('423','Urban Core','Urban',1),
        ('424','Urban Core','Urban',1),
        ('425','Urban Core','Urban',1),
        ('426','Urban Core','Urban',1),
        ('427','Urban Core','Urban',1),
        ('428','Urban Core','Urban',1),
        ('429','Urban Core','Urban',1),
        ('430','Urban Core','Urban',1),
        ('431','Urban Core','Urban',1),
        ('432','Urban Core','Urban',1),
        ('433','Urban Core','Urban',1),
        ('434','Urban Core','Urban',1),
        ('435','Urban Core','Urban',1),
        ('436','Urban Core','Urban',1),
        ('437','Urban Core','Urban',1),
        ('438','Urban Core','Urban',1),
        ('439','Urban Core','Urban',1),
        ('440','Urban Core','Urban',1),
        ('441','Urban Core','Urban',1),
        ('442','Urban Core','Urban',1),
        ('443','Urban Core','Urban',1),
        ('444','Urban Core','Urban',1),
        ('445','Urban Core','Urban',1),
        ('446','Urban Core','Urban',1),
        ('447','Urban Core','Urban',1),
        ('448','Urban Core','Urban',1),
        ('449','Urban Core','Urban',1),
        ('450','Urban Core','Urban',1),
        ('451','Urban Core','Urban',1),
        ('452','Urban Core','Urban',1),
        ('453','Urban Core','Urban',1),
        ('454','Urban Core','Urban',1),
        ('455','Urban Core','Urban',1),
        ('456','Urban Core','Urban',1),
        ('457','Urban Core','Urban',1),
        ('458','Urban Core','Urban',1),
        ('459','Urban Core','Urban',1),
        ('460','Urban Core','Urban',1),
        ('461','Urban Core','Urban',1),
        ('462','Urban Core','Urban',1),
        ('463','Urban Core','Urban',1),
        ('464','Urban Core','Urban',1),
        ('465','Urban Core','Urban',1),
        ('466','Urban Core','Urban',1),
        ('467','Urban Core','Urban',1),
        ('468','Urban Core','Urban',1),
        ('469','Urban Core','Urban',1),
        ('470','Urban Core','Urban',1),
        ('471','Urban Core','Urban',1),
        ('472','Urban Core','Urban',1),
        ('473','Urban Core','Urban',1),
        ('474','Urban Core','Urban',1),
        ('475','Urban Core','Urban',1),
        ('476','Urban Core','Urban',1),
        ('477','Urban Core','Urban',1),
        ('478','Urban Core','Urban',1),
        ('479','Urban Core','Urban',1),
        ('480','Urban Core','Urban',1),
        ('481','Urban Core','Urban',1),
        ('482','Urban Core','Urban',1),
        ('483','Urban Core','Urban',1),
        ('484','Urban Core','Urban',1),
        ('485','Urban Core','Urban',1),
        ('486','Urban Core','Urban',1),
        ('487','Urban Core','Urban',1),
        ('488','Urban Core','Urban',1),
        ('489','Urban Core','Urban',1),
        ('490','Urban Core','Urban',1),
        ('491','Urban Core','Urban',1),
        ('492','Urban Core','Urban',1),
        ('493','Urban Core','Urban',1),
        ('494','Urban Core','Urban',1),
        ('495','Urban Core','Urban',1),
        ('496','Urban Core','Urban',1),
        ('497','Urban Core','Urban',1),
        ('498','Urban Core','Urban',1),
        ('499','Urban Core','Urban',1),
        ('500','Urban Core','Urban',1),
        ('501','Urban Core','Urban',1),
        ('502','Urban Core','Urban',1),
        ('503','Urban Core','Urban',1),
        ('504','Urban Core','Urban',1),
        ('505','Urban Core','Urban',1),
        ('506','Urban Core','Urban',1),
        ('507','Urban Core','Urban',1),
        ('508','Urban Core','Urban',1),
        ('509','Urban Core','Urban',1),
        ('510','Urban Core','Urban',1),
        ('511','Urban Core','Urban',1),
        ('512','Urban Core','Urban',1),
        ('513','Urban Core','Urban',1),
        ('514','Urban Core','Urban',1),
        ('515','Urban Core','Urban',1),
        ('516','Urban Core','Urban',1),
        ('517','Urban Core','Urban',1),
        ('518','Urban Core','Urban',1),
        ('519','Urban Core','Urban',1),
        ('520','Urban Core','Urban',1),
        ('521','Urban Core','Urban',1),
        ('522','Urban Core','Urban',1),
        ('523','Urban Core','Urban',1),
        ('524','Urban Core','Urban',1),
        ('525','Urban Core','Urban',1),
        ('526','Urban Core','Urban',1),
        ('527','Urban Core','Urban',1),
        ('528','Urban Core','Urban',1),
        ('529','Urban Core','Urban',1),
        ('530','Urban Core','Urban',1),
        ('531','Urban Core','Urban',1),
        ('532','Urban Core','Urban',1),
        ('533','Urban Core','Urban',1),
        ('534','Urban Core','Urban',1),
        ('535','Urban Core','Urban',1),
        ('536','Urban Core','Urban',1),
        ('537','Urban Core','Urban',1),
        ('538','Urban Core','Urban',1),
        ('539','Urban Core','Urban',1),
        ('540','Urban Core','Urban',1),
        ('541','Urban Core','Urban',1),
        ('542','Urban Core','Urban',1),
        ('543','Urban Core','Urban',1),
        ('544','Urban Core','Urban',1),
        ('545','Urban Core','Urban',1),
        ('546','Urban Core','Urban',1),
        ('547','Urban Core','Urban',1),
        ('548','Urban Core','Urban',1),
        ('549','Urban Core','Urban',1),
        ('550','Urban Core','Urban',1),
        ('551','Urban Core','Urban',1),
        ('552','Urban Core','Urban',1),
        ('553','Urban Core','Urban',1),
        ('554','Urban Core','Urban',1),
        ('555','Urban Core','Urban',1),
        ('556','Urban Core','Urban',1),
        ('557','Urban Core','Urban',1),
        ('558','Urban Core','Urban',1),
        ('559','Urban Core','Urban',1),
        ('560','Urban Core','Urban',1),
        ('561','Urban Core','Urban',1),
        ('562','Urban Core','Urban',1),
        ('563','Urban Core','Urban',1),
        ('564','Urban Core','Urban',1),
        ('565','Urban Core','Urban',1),
        ('566','Urban Core','Urban',1),
        ('567','Urban Core','Urban',1),
        ('568','Urban Core','Urban',1),
        ('569','Urban Core','Urban',1),
        ('570','Urban Core','Urban',1),
        ('571','Urban Core','Urban',1),
        ('572','Urban Core','Urban',1),
        ('573','Urban Core','Urban',1),
        ('574','Urban Core','Urban',1),
        ('575','Urban Core','Urban',1),
        ('576','Urban Core','Urban',1),
        ('577','Urban Core','Urban',1),
        ('578','Urban Core','Urban',1),
        ('579','Urban Core','Urban',1),
        ('580','Urban Core','Urban',1),
        ('581','Urban Core','Urban',1),
        ('582','Urban Core','Urban',1),
        ('583','Urban Core','Urban',1),
        ('584','Urban Core','Urban',1),
        ('585','Urban Core','Urban',1),
        ('586','Urban Core','Urban',1),
        ('587','Urban Core','Urban',1),
        ('588','Urban Core','Urban',1),
        ('589','Urban Core','Urban',1),
        ('590','Urban Core','Urban',1),
        ('591','Urban Core','Urban',1),
        ('592','Urban Core','Urban',1),
        ('593','Urban Core','Urban',1),
        ('594','Mission Valley','Major Employment Center',1),
        ('595','Mission Valley','Major Employment Center',1),
        ('596','Urban Core','Urban',1),
        ('597','Urban Core','Urban',1),
        ('598','Urban Core','Urban',1),
        ('599','Urban Core','Urban',1),
        ('600','Urban Core','Urban',1),
        ('601','Urban Core','Urban',1),
        ('602','Urban Core','Urban',1),
        ('603','Urban Core','Urban',1),
        ('604','Urban Core','Urban',1),
        ('605','Urban Core','Urban',1),
        ('606','Urban Core','Urban',1),
        ('607','Urban Core','Urban',1),
        ('608','Urban Core','Urban',1),
        ('609','Urban Core','Urban',1),
        ('610','Urban Core','Urban',1),
        ('611','Urban Core','Urban',1),
        ('612','Urban Core','Urban',1),
        ('613','Urban Core','Urban',1),
        ('614','Urban Core','Urban',1),
        ('615','Urban Core','Urban',1),
        ('616','Urban Core','Urban',1),
        ('617','Urban Core','Urban',1),
        ('618','Urban Core','Urban',1),
        ('619','Urban Core','Urban',1),
        ('620','Urban Core','Urban',1),
        ('621','Urban Core','Urban',1),
        ('622','Urban Core','Urban',1),
        ('623','Urban Core','Urban',1),
        ('624','Urban Core','Urban',1),
        ('625','Urban Core','Urban',1),
        ('626','Urban Core','Urban',1),
        ('627','Urban Core','Urban',1),
        ('628','Urban Core','Urban',1),
        ('629','Urban Core','Urban',1),
        ('630','Urban Core','Urban',1),
        ('631','Urban Core','Urban',1),
        ('632','Urban Core','Urban',1),
        ('633','Urban Core','Urban',1),
        ('634','Urban Core','Urban',1),
        ('635','Urban Core','Urban',1),
        ('636','Urban Core','Urban',1),
        ('637','Urban Core','Urban',1),
        ('638','Urban Core','Urban',1),
        ('639','Urban Core','Urban',1),
        ('640','Urban Core','Urban',1),
        ('641','Urban Core','Urban',1),
        ('642','Urban Core','Urban',1),
        ('643','Urban Core','Urban',1),
        ('644','Urban Core','Urban',1),
        ('645','Urban Core','Urban',1),
        ('646','Urban Core','Urban',1),
        ('647','Urban Core','Urban',1),
        ('648','Urban Core','Urban',1),
        ('649','Urban Core','Urban',1),
        ('650','Urban Core','Urban',1),
        ('651','Urban Core','Urban',1),
        ('652','Urban Core','Urban',1),
        ('653','Urban Core','Urban',1),
        ('654','Urban Core','Urban',1),
        ('655','Urban Core','Urban',1),
        ('656','Urban Core','Urban',1),
        ('657','Urban Core','Urban',1),
        ('658','Urban Core','Urban',1),
        ('659','Urban Core','Urban',1),
        ('660','Urban Core','Urban',1),
        ('661','Urban Core','Urban',1),
        ('662','Urban Core','Urban',1),
        ('663','Urban Core','Urban',1),
        ('664','Urban Core','Urban',1),
        ('665','Urban Core','Urban',1),
        ('666','Urban Core','Urban',1),
        ('667','Urban Core','Urban',1),
        ('668','Urban Core','Urban',1),
        ('669','Urban Core','Urban',1),
        ('670','Urban Core','Urban',1),
        ('671','Urban Core','Urban',1),
        ('672','Urban Core','Urban',1),
        ('673','Urban Core','Urban',1),
        ('674','Urban Core','Urban',1),
        ('675','Urban Core','Urban',1),
        ('676','Urban Core','Urban',1),
        ('677','Urban Core','Urban',1),
        ('678','Urban Core','Urban',1),
        ('679','Urban Core','Urban',1),
        ('680','Urban Core','Urban',1),
        ('681','Urban Core','Urban',1),
        ('682','Urban Core','Urban',1),
        ('683','Urban Core','Urban',1),
        ('684','Urban Core','Urban',1),
        ('685','Urban Core','Urban',1),
        ('686','Urban Core','Urban',1),
        ('687','Urban Core','Urban',1),
        ('688','Urban Core','Urban',1),
        ('689','Urban Core','Urban',1),
        ('690','Urban Core','Urban',1),
        ('691','Urban Core','Urban',1),
        ('692','Urban Core','Urban',1),
        ('693','Urban Core','Urban',1),
        ('694','Urban Core','Urban',1),
        ('695','Urban Core','Urban',1),
        ('696','Urban Core','Urban',1),
        ('697','Urban Core','Urban',1),
        ('698','Urban Core','Urban',1),
        ('699','Urban Core','Urban',1),
        ('700','Urban Core','Urban',1),
        ('701','Urban Core','Urban',1),
        ('702','Urban Core','Urban',1),
        ('703','Urban Core','Urban',1),
        ('704','Urban Core','Urban',1),
        ('705','Urban Core','Urban',1),
        ('706','Urban Core','Urban',1),
        ('707','Urban Core','Urban',1),
        ('708','Urban Core','Urban',1),
        ('709','Urban Core','Urban',1),
        ('710','Urban Core','Urban',1),
        ('711','Urban Core','Urban',1),
        ('712','Urban Core','Urban',1),
        ('713','Urban Core','Urban',1),
        ('714','Urban Core','Urban',1),
        ('715','Urban Core','Urban',1),
        ('716','Urban Core','Urban',1),
        ('717','Urban Core','Urban',1),
        ('718','Urban Core','Urban',1),
        ('719','Urban Core','Urban',1),
        ('720','Urban Core','Urban',1),
        ('721','Urban Core','Urban',1),
        ('722','Urban Core','Urban',1),
        ('723','Urban Core','Urban',1),
        ('724','Urban Core','Urban',1),
        ('725','Urban Core','Urban',1),
        ('726','Urban Core','Urban',1),
        ('727','Urban Core','Urban',1),
        ('728','Urban Core','Urban',1),
        ('729','Urban Core','Urban',1),
        ('730','Urban Core','Urban',1),
        ('731','Urban Core','Urban',1),
        ('732','Urban Core','Urban',1),
        ('733','Urban Core','Urban',1),
        ('734','Urban Core','Urban',1),
        ('735','Urban Core','Urban',1),
        ('736','Urban Core','Urban',1),
        ('737','Urban Core','Urban',1),
        ('738','Urban Core','Urban',1),
        ('739','Urban Core','Urban',1),
        ('740','Urban Core','Urban',1),
        ('741','Urban Core','Urban',1),
        ('742','Urban Core','Urban',1),
        ('743','Urban Core','Urban',1),
        ('744','Urban Core','Urban',1),
        ('745','Urban Core','Urban',1),
        ('746','Urban Core','Urban',1),
        ('747','Urban Core','Urban',1),
        ('748','Urban Core','Urban',1),
        ('749','Urban Core','Urban',1),
        ('750','Urban Core','Urban',1),
        ('751','Urban Core','Urban',1),
        ('752','Urban Core','Urban',1),
        ('753','Urban Core','Urban',1),
        ('754','Urban Core','Urban',1),
        ('755','Urban Core','Urban',1),
        ('756','Urban Core','Urban',1),
        ('757','Urban Core','Urban',1),
        ('758','Urban Core','Urban',1),
        ('759','Urban Core','Urban',1),
        ('760','Urban Core','Urban',1),
        ('761','Urban Core','Urban',1),
        ('762','Urban Core','Urban',1),
        ('763','Urban Core','Urban',1),
        ('764','Urban Core','Urban',1),
        ('765','Urban Core','Urban',1),
        ('766','Urban Core','Urban',1),
        ('767','Urban Core','Urban',1),
        ('768','Urban Core','Urban',1),
        ('769','Urban Core','Urban',1),
        ('770','Urban Core','Urban',1),
        ('771','Urban Core','Urban',1),
        ('772','Urban Core','Urban',1),
        ('773','Urban Core','Urban',1),
        ('774','Urban Core','Urban',1),
        ('775','Urban Core','Urban',1),
        ('776','Urban Core','Urban',1),
        ('777','Urban Core','Urban',1),
        ('778','Urban Core','Urban',1),
        ('779','Urban Core','Urban',1),
        ('780','Urban Core','Urban',1),
        ('781','Urban Core','Urban',1),
        ('782','Urban Core','Urban',1),
        ('783','Urban Core','Urban',1),
        ('784','Urban Core','Urban',1),
        ('785','Urban Core','Urban',1),
        ('786','Urban Core','Urban',1),
        ('787','Urban Core','Urban',1),
        ('788','Urban Core','Urban',1),
        ('789','Urban Core','Urban',1),
        ('790','Urban Core','Urban',1),
        ('791','Urban Core','Urban',1),
        ('792','Urban Core','Urban',1),
        ('793','Urban Core','Urban',1),
        ('794','Urban Core','Urban',1),
        ('795','Urban Core','Urban',1),
        ('796','Urban Core','Urban',1),
        ('797','Urban Core','Urban',1),
        ('798','Urban Core','Urban',1),
        ('799','Urban Core','Urban',1),
        ('800','Urban Core','Urban',1),
        ('801','Urban Core','Urban',1),
        ('802','Urban Core','Urban',1),
        ('803','Urban Core','Urban',1),
        ('804','Urban Core','Urban',1),
        ('805','Urban Core','Urban',1),
        ('806','Urban Core','Urban',1),
        ('807','Urban Core','Urban',1),
        ('818','Urban Core','Urban',1),
        ('819','Urban Core','Urban',1),
        ('820','Urban Core','Urban',1),
        ('821','Urban Core','Urban',1),
        ('822','Urban Core','Urban',1),
        ('823','Urban Core','Urban',1),
        ('824','Urban Core','Urban',1),
        ('825','Urban Core','Urban',1),
        ('826','Urban Core','Urban',1),
        ('827','Urban Core','Urban',1),
        ('828','Urban Core','Urban',1),
        ('829','Urban Core','Urban',1),
        ('830','Urban Core','Urban',1),
        ('831','Urban Core','Urban',1),
        ('832','Urban Core','Urban',1),
        ('833','Urban Core','Urban',1),
        ('834','Urban Core','Urban',1),
        ('835','Urban Core','Urban',1),
        ('836','Urban Core','Urban',1),
        ('837','Urban Core','Urban',1),
        ('838','Urban Core','Urban',1),
        ('839','Urban Core','Urban',1),
        ('840','Urban Core','Urban',1),
        ('841','Urban Core','Urban',1),
        ('842','Urban Core','Urban',1),
        ('843','Urban Core','Urban',1),
        ('844','Urban Core','Urban',1),
        ('845','Urban Core','Urban',1),
        ('846','Urban Core','Urban',1),
        ('847','Urban Core','Urban',1),
        ('848','Urban Core','Urban',1),
        ('849','Urban Core','Urban',1),
        ('850','Urban Core','Urban',1),
        ('851','Urban Core','Urban',1),
        ('852','Urban Core','Urban',1),
        ('853','Urban Core','Urban',1),
        ('854','Urban Core','Urban',1),
        ('855','Urban Core','Urban',1),
        ('856','Urban Core','Urban',1),
        ('857','Urban Core','Urban',1),
        ('858','Urban Core','Urban',1),
        ('859','Urban Core','Urban',1),
        ('860','Urban Core','Urban',1),
        ('861','Urban Core','Urban',1),
        ('862','Urban Core','Urban',1),
        ('863','Urban Core','Urban',1),
        ('864','Urban Core','Urban',1),
        ('865','Urban Core','Urban',1),
        ('866','Urban Core','Urban',1),
        ('867','Urban Core','Urban',1),
        ('868','Urban Core','Urban',1),
        ('869','Urban Core','Urban',1),
        ('870','Urban Core','Urban',1),
        ('871','Urban Core','Urban',1),
        ('872','Urban Core','Urban',1),
        ('873','Urban Core','Urban',1),
        ('874','Urban Core','Urban',1),
        ('875','Urban Core','Urban',1),
        ('876','Urban Core','Urban',1),
        ('877','Urban Core','Urban',1),
        ('878','Urban Core','Urban',1),
        ('879','Urban Core','Urban',1),
        ('880','Urban Core','Urban',1),
        ('881','Urban Core','Urban',1),
        ('882','Urban Core','Urban',1),
        ('883','Urban Core','Urban',1),
        ('884','Urban Core','Urban',1),
        ('885','Urban Core','Urban',1),
        ('886','Urban Core','Urban',1),
        ('887','Urban Core','Urban',1),
        ('888','Urban Core','Urban',1),
        ('889','Urban Core','Urban',1),
        ('890','Urban Core','Urban',1),
        ('891','Urban Core','Urban',1),
        ('892','Urban Core','Urban',1),
        ('893','Urban Core','Urban',1),
        ('894','Urban Core','Urban',1),
        ('895','College Area','Suburban',0),
        ('896','College Area','Suburban',0),
        ('897','College Area','Suburban',0),
        ('898','College Area','Suburban',0),
        ('899','College Area','Suburban',0),
        ('900','College Area','Suburban',0),
        ('901','College Area','Suburban',0),
        ('902','College Area','Suburban',0),
        ('903','College Area','Suburban',0),
        ('904','College Area','Suburban',0),
        ('905','College Area','Suburban',0),
        ('906','College Area','Suburban',0),
        ('907','College Area','Suburban',0),
        ('911','College Area','Suburban',0),
        ('912','College Area','Suburban',0),
        ('913','College Area','Suburban',0),
        ('914','College Area','Suburban',0),
        ('915','College Area','Suburban',0),
        ('916','College Area','Suburban',0),
        ('917','Urban Core','Urban',1),
        ('918','College Area','Suburban',0),
        ('921','College Area','Suburban',0),
        ('922','College Area','Suburban',0),
        ('923','College Area','Suburban',0),
        ('966','Urban Core','Urban',1),
        ('967','Urban Core','Urban',1),
        ('968','Urban Core','Urban',1),
        ('969','Urban Core','Urban',1),
        ('970','Urban Core','Urban',1),
        ('971','Urban Core','Urban',1),
        ('972','Urban Core','Urban',1),
        ('973','Urban Core','Urban',1),
        ('974','Urban Core','Urban',1),
        ('975','Urban Core','Urban',1),
        ('976','Urban Core','Urban',1),
        ('977','Urban Core','Urban',1),
        ('978','Urban Core','Urban',1),
        ('979','Urban Core','Urban',1),
        ('980','Urban Core','Urban',1),
        ('981','Urban Core','Urban',1),
        ('982','Urban Core','Urban',1),
        ('983','Urban Core','Urban',1),
        ('984','Urban Core','Urban',1),
        ('985','Urban Core','Urban',1),
        ('986','Urban Core','Urban',1),
        ('987','Urban Core','Urban',1),
        ('988','Urban Core','Urban',1),
        ('989','Urban Core','Urban',1),
        ('990','Urban Core','Urban',1),
        ('991','Urban Core','Urban',1),
        ('992','Urban Core','Urban',1),
        ('993','Urban Core','Urban',1),
        ('994','Urban Core','Urban',1),
        ('995','Urban Core','Urban',1),
        ('996','Urban Core','Urban',1),
        ('997','Urban Core','Urban',1),
        ('998','Urban Core','Urban',1),
        ('999','Urban Core','Urban',1),
        ('1000','Urban Core','Urban',1),
        ('1001','Urban Core','Urban',1),
        ('1002','Urban Core','Urban',1),
        ('1003','Urban Core','Urban',1),
        ('1004','Urban Core','Urban',1),
        ('1005','Urban Core','Urban',1),
        ('1006','Urban Core','Urban',1),
        ('1007','Urban Core','Urban',1),
        ('1008','Urban Core','Urban',1),
        ('1009','Urban Core','Urban',1),
        ('1010','Urban Core','Urban',1),
        ('1011','Urban Core','Urban',1),
        ('1012','Urban Core','Urban',1),
        ('1013','Urban Core','Urban',1),
        ('1014','Urban Core','Urban',1),
        ('1015','Urban Core','Urban',1),
        ('1016','Urban Core','Urban',1),
        ('1017','Urban Core','Urban',1),
        ('1018','Urban Core','Urban',1),
        ('1019','Urban Core','Urban',1),
        ('1020','Urban Core','Urban',1),
        ('1021','Urban Core','Urban',1),
        ('1022','Urban Core','Urban',1),
        ('1023','Urban Core','Urban',1),
        ('1024','Urban Core','Urban',1),
        ('1025','Urban Core','Urban',1),
        ('1026','Urban Core','Urban',1),
        ('1027','Urban Core','Urban',1),
        ('1028','Urban Core','Urban',1),
        ('1029','Urban Core','Urban',1),
        ('1030','Urban Core','Urban',1),
        ('1065','College Area','Suburban',0),
        ('1066','College Area','Suburban',0),
        ('1068','College Area','Suburban',0),
        ('1069','College Area','Suburban',0),
        ('1070','College Area','Suburban',0),
        ('1071','College Area','Suburban',0),
        ('1072','College Area','Suburban',0),
        ('1073','College Area','Suburban',0),
        ('1074','College Area','Suburban',0),
        ('1075','College Area','Suburban',0),
        ('1076','College Area','Suburban',0),
        ('1077','College Area','Suburban',0),
        ('1078','College Area','Suburban',0)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('1079','Urban Core','Urban',1),
        ('1080','Urban Core','Urban',1),
        ('1081','Urban Core','Urban',1),
        ('1082','Urban Core','Urban',1),
        ('1083','Urban Core','Urban',1),
        ('1084','Urban Core','Urban',1),
        ('1085','Urban Core','Urban',1),
        ('1086','Urban Core','Urban',1),
        ('1087','Urban Core','Urban',1),
        ('1088','Urban Core','Urban',1),
        ('1089','Urban Core','Urban',1),
        ('1090','Urban Core','Urban',1),
        ('1091','College Area','Suburban',0),
        ('1092','College Area','Suburban',0),
        ('1093','Urban Core','Urban',1),
        ('1094','Urban Core','Urban',1),
        ('1095','Urban Core','Urban',1),
        ('1096','College Area','Suburban',0),
        ('1097','College Area','Suburban',0),
        ('1098','College Area','Suburban',0),
        ('1099','College Area','Suburban',0),
        ('1100','College Area','Suburban',0),
        ('1101','College Area','Suburban',0),
        ('1102','College Area','Suburban',0),
        ('1103','College Area','Suburban',0),
        ('1104','College Area','Suburban',0),
        ('1105','College Area','Suburban',0),
        ('1106','College Area','Suburban',0),
        ('1107','College Area','Suburban',0),
        ('1108','College Area','Suburban',0),
        ('1109','College Area','Suburban',0),
        ('1110','College Area','Suburban',0),
        ('1111','College Area','Suburban',0),
        ('1112','College Area','Suburban',0),
        ('1113','College Area','Suburban',0),
        ('1114','College Area','Suburban',0),
        ('1115','College Area','Suburban',0),
        ('1116','College Area','Suburban',0),
        ('1117','College Area','Suburban',0),
        ('1118','College Area','Suburban',0),
        ('1119','College Area','Suburban',0),
        ('1120','College Area','Suburban',0),
        ('1121','College Area','Suburban',0),
        ('1122','College Area','Suburban',0),
        ('1123','College Area','Suburban',0),
        ('1124','College Area','Suburban',0),
        ('1125','College Area','Suburban',0),
        ('1126','College Area','Suburban',0),
        ('1127','College Area','Suburban',0),
        ('1128','College Area','Suburban',0),
        ('1129','College Area','Suburban',0),
        ('1130','College Area','Suburban',0),
        ('1131','College Area','Suburban',0),
        ('1132','College Area','Suburban',0),
        ('1133','College Area','Suburban',0),
        ('1134','College Area','Suburban',0),
        ('1135','College Area','Suburban',0),
        ('1136','College Area','Suburban',0),
        ('1137','College Area','Suburban',0),
        ('1138','College Area','Suburban',0),
        ('1139','College Area','Suburban',0),
        ('1140','College Area','Suburban',0),
        ('1141','College Area','Suburban',0),
        ('1142','College Area','Suburban',0),
        ('1143','College Area','Suburban',0),
        ('1144','College Area','Suburban',0),
        ('1146','College Area','Suburban',0),
        ('1147','College Area','Suburban',0),
        ('1148','College Area','Suburban',0),
        ('1149','College Area','Suburban',0),
        ('1150','College Area','Suburban',0),
        ('1151','College Area','Suburban',0),
        ('1152','College Area','Suburban',0),
        ('1153','College Area','Suburban',0),
        ('1154','College Area','Suburban',0),
        ('1155','College Area','Suburban',0),
        ('1156','College Area','Suburban',0),
        ('1157','College Area','Suburban',0),
        ('1158','College Area','Suburban',0),
        ('1159','College Area','Suburban',0),
        ('1160','College Area','Suburban',0),
        ('1161','College Area','Suburban',0),
        ('1162','College Area','Suburban',0),
        ('1163','College Area','Suburban',0),
        ('1164','College Area','Suburban',0),
        ('1165','College Area','Suburban',0),
        ('1166','College Area','Suburban',0),
        ('1167','College Area','Suburban',0),
        ('1168','College Area','Suburban',0),
        ('1169','College Area','Suburban',0),
        ('1170','College Area','Suburban',0),
        ('1171','College Area','Suburban',0),
        ('1172','College Area','Suburban',0),
        ('1173','College Area','Suburban',0),
        ('1175','College Area','Suburban',0),
        ('1184','College Area','Suburban',0),
        ('1198','College Area','Suburban',0),
        ('1199','College Area','Suburban',0),
        ('1200','College Area','Suburban',0),
        ('1201','College Area','Suburban',0),
        ('1202','College Area','Suburban',0),
        ('1203','College Area','Suburban',0),
        ('1204','College Area','Suburban',0),
        ('1205','College Area','Suburban',0),
        ('1206','College Area','Suburban',0),
        ('1207','College Area','Suburban',0),
        ('1208','College Area','Suburban',0),
        ('1209','College Area','Suburban',0),
        ('1210','College Area','Suburban',0),
        ('1211','College Area','Suburban',0),
        ('1212','College Area','Suburban',0),
        ('1213','College Area','Suburban',0),
        ('1214','College Area','Suburban',0),
        ('1215','College Area','Suburban',0),
        ('1216','College Area','Suburban',0),
        ('1217','College Area','Suburban',0),
        ('1218','College Area','Suburban',0),
        ('1219','College Area','Suburban',0),
        ('1220','College Area','Suburban',0),
        ('1221','College Area','Suburban',0),
        ('1222','College Area','Suburban',0),
        ('1223','College Area','Suburban',0),
        ('1224','College Area','Suburban',0),
        ('1225','College Area','Suburban',0),
        ('1226','College Area','Suburban',0),
        ('1227','College Area','Suburban',0),
        ('1228','College Area','Suburban',0),
        ('1229','College Area','Suburban',0),
        ('1230','College Area','Suburban',0),
        ('1231','College Area','Suburban',0),
        ('1232','College Area','Suburban',0),
        ('1233','College Area','Suburban',0),
        ('1234','College Area','Suburban',0),
        ('1235','College Area','Suburban',0),
        ('1236','La Mesa','Suburban',1),
        ('1237','La Mesa','Suburban',1),
        ('1238','La Mesa','Suburban',1),
        ('1239','La Mesa','Suburban',1),
        ('1240','La Mesa','Suburban',1),
        ('1241','La Mesa','Suburban',1),
        ('1242','La Mesa','Suburban',1),
        ('1243','La Mesa','Suburban',1),
        ('1244','La Mesa','Suburban',1),
        ('1245','La Mesa','Suburban',1),
        ('1246','La Mesa','Suburban',1),
        ('1247','La Mesa','Suburban',1),
        ('1248','La Mesa','Suburban',1),
        ('1249','La Mesa','Suburban',1),
        ('1250','College Area','Suburban',0),
        ('1251','College Area','Suburban',0),
        ('1252','College Area','Suburban',0),
        ('1253','College Area','Suburban',0),
        ('1254','College Area','Suburban',0),
        ('1255','College Area','Suburban',0),
        ('1256','College Area','Suburban',0),
        ('1257','College Area','Suburban',0),
        ('1258','College Area','Suburban',0),
        ('1272','Southeast San Diego','Suburban',0),
        ('1273','Southeast San Diego','Suburban',0),
        ('1281','Southeast San Diego','Suburban',0),
        ('1282','Southeast San Diego','Suburban',0),
        ('1284','Southeast San Diego','Suburban',0),
        ('1285','Southeast San Diego','Suburban',0),
        ('1290','Lemon Grove','Suburban',0),
        ('1316','Lemon Grove','Suburban',0),
        ('1336','Southeast San Diego','Suburban',0),
        ('1337','Southeast San Diego','Suburban',0),
        ('1338','Southeast San Diego','Suburban',0),
        ('1339','Southeast San Diego','Suburban',0),
        ('1340','Southeast San Diego','Suburban',0),
        ('1341','Southeast San Diego','Suburban',0),
        ('1342','Southeast San Diego','Suburban',0),
        ('1448','Southeast San Diego','Suburban',0),
        ('1449','Southeast San Diego','Suburban',0),
        ('1451','Southeast San Diego','Suburban',0),
        ('1452','Southeast San Diego','Suburban',0),
        ('1453','Southeast San Diego','Suburban',0),
        ('1454','Southeast San Diego','Suburban',0),
        ('1456','Southeast San Diego','Suburban',0),
        ('1459','Southeast San Diego','Suburban',0),
        ('1460','Southeast San Diego','Suburban',0),
        ('1462','Southeast San Diego','Suburban',0),
        ('1829','Southeast San Diego','Suburban',0),
        ('1830','Southeast San Diego','Suburban',0),
        ('1831','Southeast San Diego','Suburban',0),
        ('1832','Southeast San Diego','Suburban',0),
        ('1833','Southeast San Diego','Suburban',0),
        ('1834','Southeast San Diego','Suburban',0),
        ('1835','Southeast San Diego','Suburban',0),
        ('1836','Southeast San Diego','Suburban',0),
        ('1837','Southeast San Diego','Suburban',0),
        ('1838','Southeast San Diego','Suburban',0),
        ('1839','Southeast San Diego','Suburban',0),
        ('1840','Southeast San Diego','Suburban',0),
        ('1841','Southeast San Diego','Suburban',0),
        ('1842','Southeast San Diego','Suburban',0),
        ('1843','Southeast San Diego','Suburban',0),
        ('1844','Southeast San Diego','Suburban',0),
        ('1845','Southeast San Diego','Suburban',0),
        ('1846','Southeast San Diego','Suburban',0),
        ('1847','Southeast San Diego','Suburban',0),
        ('1848','Southeast San Diego','Suburban',0),
        ('1849','Southeast San Diego','Suburban',0),
        ('1850','Southeast San Diego','Suburban',0),
        ('1851','Southeast San Diego','Suburban',0),
        ('1852','Southeast San Diego','Suburban',0),
        ('1853','National City','Major Employment Center',1),
        ('1854','Southeast San Diego','Suburban',0),
        ('1855','Southeast San Diego','Suburban',0),
        ('1856','Southeast San Diego','Suburban',0),
        ('1857','Southeast San Diego','Suburban',0),
        ('1858','Southeast San Diego','Suburban',0),
        ('1859','Southeast San Diego','Suburban',0),
        ('1860','Southeast San Diego','Suburban',0),
        ('1861','Southeast San Diego','Suburban',0),
        ('1862','Southeast San Diego','Suburban',0),
        ('1863','Southeast San Diego','Suburban',0),
        ('1864','Southeast San Diego','Suburban',0),
        ('1865','Southeast San Diego','Suburban',0),
        ('1866','Southeast San Diego','Suburban',0),
        ('1867','Southeast San Diego','Suburban',0),
        ('1868','Southeast San Diego','Suburban',0),
        ('1869','Southeast San Diego','Suburban',0),
        ('1870','Southeast San Diego','Suburban',0),
        ('1871','Southeast San Diego','Suburban',0),
        ('1872','Southeast San Diego','Suburban',0),
        ('1873','Southeast San Diego','Suburban',0),
        ('1874','Southeast San Diego','Suburban',0),
        ('1875','Southeast San Diego','Suburban',0),
        ('1876','Southeast San Diego','Suburban',0),
        ('1877','Southeast San Diego','Suburban',0),
        ('1878','Southeast San Diego','Suburban',0),
        ('1879','Southeast San Diego','Suburban',0),
        ('1880','Southeast San Diego','Suburban',0),
        ('1881','Southeast San Diego','Suburban',0),
        ('1882','Southeast San Diego','Suburban',0),
        ('1883','Southeast San Diego','Suburban',0),
        ('1884','Southeast San Diego','Suburban',0),
        ('1885','Southeast San Diego','Suburban',0),
        ('1886','Southeast San Diego','Suburban',0),
        ('1887','Southeast San Diego','Suburban',0),
        ('1888','Southeast San Diego','Suburban',0),
        ('1889','Southeast San Diego','Suburban',0),
        ('1890','Southeast San Diego','Suburban',0),
        ('1891','Southeast San Diego','Suburban',0),
        ('1892','Southeast San Diego','Suburban',0),
        ('1893','Southeast San Diego','Suburban',0),
        ('1894','Southeast San Diego','Suburban',0),
        ('1895','Southeast San Diego','Suburban',0),
        ('1896','Southeast San Diego','Suburban',0),
        ('1897','Southeast San Diego','Suburban',0),
        ('1898','Southeast San Diego','Suburban',0),
        ('1899','Southeast San Diego','Suburban',0),
        ('1900','Urban Core','Urban',1),
        ('1933','Southeast San Diego','Suburban',0),
        ('1934','Southeast San Diego','Suburban',0),
        ('1935','Southeast San Diego','Suburban',0),
        ('1936','Southeast San Diego','Suburban',0),
        ('1937','Southeast San Diego','Suburban',0),
        ('1938','Southeast San Diego','Suburban',0),
        ('1939','Southeast San Diego','Suburban',0),
        ('1940','Southeast San Diego','Suburban',0),
        ('1941','Southeast San Diego','Suburban',0),
        ('1942','Southeast San Diego','Suburban',0),
        ('1943','Southeast San Diego','Suburban',0),
        ('1944','Southeast San Diego','Suburban',0),
        ('1945','Southeast San Diego','Suburban',0),
        ('1946','Southeast San Diego','Suburban',0),
        ('1947','Southeast San Diego','Suburban',0),
        ('1948','Southeast San Diego','Suburban',0),
        ('1949','Southeast San Diego','Suburban',0),
        ('1950','Southeast San Diego','Suburban',0),
        ('1951','Southeast San Diego','Suburban',0),
        ('1952','Southeast San Diego','Suburban',0),
        ('1953','Southeast San Diego','Suburban',0),
        ('1954','Southeast San Diego','Suburban',0),
        ('1955','Southeast San Diego','Suburban',0),
        ('1956','Southeast San Diego','Suburban',0),
        ('1957','Southeast San Diego','Suburban',0),
        ('1958','Southeast San Diego','Suburban',0),
        ('1959','Southeast San Diego','Suburban',0),
        ('1960','Southeast San Diego','Suburban',0),
        ('1962','Southeast San Diego','Suburban',0),
        ('1963','Southeast San Diego','Suburban',0),
        ('1964','Southeast San Diego','Suburban',0),
        ('1965','Southeast San Diego','Suburban',0),
        ('1966','Southeast San Diego','Suburban',0),
        ('1967','Southeast San Diego','Suburban',0),
        ('1968','Southeast San Diego','Suburban',0),
        ('1969','Southeast San Diego','Suburban',0),
        ('1970','Southeast San Diego','Suburban',0),
        ('1971','Southeast San Diego','Suburban',0),
        ('1972','Southeast San Diego','Suburban',0),
        ('1973','Southeast San Diego','Suburban',0),
        ('1974','Southeast San Diego','Suburban',0),
        ('1975','Southeast San Diego','Suburban',0),
        ('1976','Southeast San Diego','Suburban',0),
        ('1977','Southeast San Diego','Suburban',0),
        ('1978','Southeast San Diego','Suburban',0),
        ('1979','Southeast San Diego','Suburban',0),
        ('1980','Southeast San Diego','Suburban',0),
        ('1981','Southeast San Diego','Suburban',0),
        ('1982','Southeast San Diego','Suburban',0),
        ('1983','Southeast San Diego','Suburban',0),
        ('1984','Southeast San Diego','Suburban',0),
        ('1985','Southeast San Diego','Suburban',0),
        ('1986','Southeast San Diego','Suburban',0),
        ('1987','Southeast San Diego','Suburban',0),
        ('1988','Southeast San Diego','Suburban',0),
        ('1989','Southeast San Diego','Suburban',0),
        ('1990','Southeast San Diego','Suburban',0),
        ('1991','Southeast San Diego','Suburban',0),
        ('1992','Southeast San Diego','Suburban',0),
        ('1993','Southeast San Diego','Suburban',0),
        ('1994','Southeast San Diego','Suburban',0),
        ('1995','Southeast San Diego','Suburban',0),
        ('1996','Southeast San Diego','Suburban',0),
        ('1997','Southeast San Diego','Suburban',0),
        ('1998','Southeast San Diego','Suburban',0),
        ('1999','Southeast San Diego','Suburban',0),
        ('2000','Southeast San Diego','Suburban',0),
        ('2001','Southeast San Diego','Suburban',0),
        ('2002','Southeast San Diego','Suburban',0),
        ('2003','Southeast San Diego','Suburban',0),
        ('2004','Southeast San Diego','Suburban',0),
        ('2005','Southeast San Diego','Suburban',0),
        ('2006','Southeast San Diego','Suburban',0),
        ('2007','Southeast San Diego','Suburban',0),
        ('2008','Southeast San Diego','Suburban',0),
        ('2009','Southeast San Diego','Suburban',0),
        ('2010','Southeast San Diego','Suburban',0),
        ('2011','Southeast San Diego','Suburban',0),
        ('2012','Southeast San Diego','Suburban',0),
        ('2013','Southeast San Diego','Suburban',0),
        ('2014','Southeast San Diego','Suburban',0),
        ('2015','Southeast San Diego','Suburban',0),
        ('2016','Southeast San Diego','Suburban',0),
        ('2017','Southeast San Diego','Suburban',0),
        ('2018','Southeast San Diego','Suburban',0),
        ('2019','Southeast San Diego','Suburban',0),
        ('2020','Southeast San Diego','Suburban',0),
        ('2021','Southeast San Diego','Suburban',0),
        ('2022','Southeast San Diego','Suburban',0),
        ('2023','Southeast San Diego','Suburban',0),
        ('2024','Urban Core','Urban',1),
        ('2025','Urban Core','Urban',1),
        ('2026','Urban Core','Urban',1),
        ('2027','Urban Core','Urban',1),
        ('2028','Urban Core','Urban',1),
        ('2029','Urban Core','Urban',1),
        ('2030','Urban Core','Urban',1),
        ('2031','Urban Core','Urban',1),
        ('2032','Urban Core','Urban',1),
        ('2033','Southeast San Diego','Suburban',0),
        ('2034','Southeast San Diego','Suburban',0),
        ('2035','Southeast San Diego','Suburban',0),
        ('2036','Southeast San Diego','Suburban',0),
        ('2037','Southeast San Diego','Suburban',0),
        ('2038','Southeast San Diego','Suburban',0),
        ('2039','Southeast San Diego','Suburban',0),
        ('2040','Southeast San Diego','Suburban',0),
        ('2041','Southeast San Diego','Suburban',0),
        ('2042','Southeast San Diego','Suburban',0),
        ('2043','Southeast San Diego','Suburban',0),
        ('2044','Southeast San Diego','Suburban',0),
        ('2045','Southeast San Diego','Suburban',0),
        ('2046','Southeast San Diego','Suburban',0),
        ('2047','Southeast San Diego','Suburban',0),
        ('2048','Southeast San Diego','Suburban',0),
        ('2049','Southeast San Diego','Suburban',0),
        ('2050','Southeast San Diego','Suburban',0),
        ('2051','Southeast San Diego','Suburban',0),
        ('2052','Southeast San Diego','Suburban',0),
        ('2053','Southeast San Diego','Suburban',0),
        ('2054','Southeast San Diego','Suburban',0),
        ('2055','Southeast San Diego','Suburban',0),
        ('2056','Southeast San Diego','Suburban',0),
        ('2057','Southeast San Diego','Suburban',0),
        ('2058','Southeast San Diego','Suburban',0),
        ('2059','Southeast San Diego','Suburban',0),
        ('2060','Southeast San Diego','Suburban',0),
        ('2061','Southeast San Diego','Suburban',0),
        ('2062','Southeast San Diego','Suburban',0),
        ('2063','Southeast San Diego','Suburban',0),
        ('2064','Southeast San Diego','Suburban',0),
        ('2065','Southeast San Diego','Suburban',0),
        ('2066','Southeast San Diego','Suburban',0),
        ('2067','Southeast San Diego','Suburban',0),
        ('2068','Southeast San Diego','Suburban',0),
        ('2069','Southeast San Diego','Suburban',0),
        ('2070','Southeast San Diego','Suburban',0),
        ('2071','Southeast San Diego','Suburban',0),
        ('2072','Southeast San Diego','Suburban',0),
        ('2073','Southeast San Diego','Suburban',0),
        ('2074','Southeast San Diego','Suburban',0),
        ('2075','Southeast San Diego','Suburban',0),
        ('2076','Southeast San Diego','Suburban',0),
        ('2077','Southeast San Diego','Suburban',0),
        ('2078','Southeast San Diego','Suburban',0),
        ('2079','Southeast San Diego','Suburban',0),
        ('2080','Southeast San Diego','Suburban',0),
        ('2081','Southeast San Diego','Suburban',0),
        ('2082','Southeast San Diego','Suburban',0),
        ('2083','Southeast San Diego','Suburban',0),
        ('2084','Southeast San Diego','Suburban',0),
        ('2085','Southeast San Diego','Suburban',0),
        ('2086','Southeast San Diego','Suburban',0),
        ('2087','Southeast San Diego','Suburban',0),
        ('2088','Southeast San Diego','Suburban',0),
        ('2089','Southeast San Diego','Suburban',0),
        ('2090','Urban Core','Urban',1),
        ('2091','Urban Core','Urban',1),
        ('2092','Urban Core','Urban',1),
        ('2093','Urban Core','Urban',1),
        ('2094','Urban Core','Urban',1),
        ('2095','Urban Core','Urban',1),
        ('2096','Urban Core','Urban',1),
        ('2097','Urban Core','Urban',1),
        ('2098','Urban Core','Urban',1),
        ('2099','Urban Core','Urban',1),
        ('2100','Urban Core','Urban',1),
        ('2101','Urban Core','Urban',1),
        ('2102','Urban Core','Urban',1),
        ('2103','Urban Core','Urban',1),
        ('2104','Urban Core','Urban',1),
        ('2105','Urban Core','Urban',1),
        ('2106','Urban Core','Urban',1),
        ('2107','Urban Core','Urban',1),
        ('2108','Urban Core','Urban',1),
        ('2109','Urban Core','Urban',1),
        ('2110','Urban Core','Urban',1),
        ('2111','Urban Core','Urban',1),
        ('2112','Urban Core','Urban',1),
        ('2113','Urban Core','Urban',1),
        ('2114','Urban Core','Urban',1),
        ('2115','Urban Core','Urban',1),
        ('2116','Urban Core','Urban',1),
        ('2117','Urban Core','Urban',1),
        ('2118','Urban Core','Urban',1),
        ('2119','Urban Core','Urban',1),
        ('2120','Urban Core','Urban',1),
        ('2121','Urban Core','Urban',1),
        ('2122','Urban Core','Urban',1),
        ('2123','Urban Core','Urban',1),
        ('2124','Urban Core','Urban',1),
        ('2125','Urban Core','Urban',1),
        ('2126','Urban Core','Urban',1),
        ('2127','Urban Core','Urban',1),
        ('2128','Urban Core','Urban',1),
        ('2129','Urban Core','Urban',1),
        ('2130','Urban Core','Urban',1),
        ('2131','Urban Core','Urban',1),
        ('2132','Urban Core','Urban',1),
        ('2133','Urban Core','Urban',1),
        ('2134','Urban Core','Urban',1),
        ('2135','Urban Core','Urban',1),
        ('2136','Urban Core','Urban',1),
        ('2137','Urban Core','Urban',1),
        ('2138','Urban Core','Urban',1),
        ('2139','Urban Core','Urban',1),
        ('2140','Urban Core','Urban',1),
        ('2141','Urban Core','Urban',1),
        ('2142','Urban Core','Urban',1),
        ('2143','Urban Core','Urban',1),
        ('2144','Urban Core','Urban',1),
        ('2145','Urban Core','Urban',1),
        ('2146','Urban Core','Urban',1),
        ('2147','Urban Core','Urban',1),
        ('2148','Urban Core','Urban',1),
        ('2149','Urban Core','Urban',1),
        ('2150','Urban Core','Urban',1),
        ('2151','Urban Core','Urban',1),
        ('2152','Urban Core','Urban',1),
        ('2153','Urban Core','Urban',1),
        ('2154','Urban Core','Urban',1),
        ('2155','Urban Core','Urban',1),
        ('2156','Urban Core','Urban',1),
        ('2157','Urban Core','Urban',1),
        ('2158','Urban Core','Urban',1),
        ('2159','Urban Core','Urban',1),
        ('2160','Urban Core','Urban',1),
        ('2161','Urban Core','Urban',1),
        ('2162','Urban Core','Urban',1),
        ('2163','Urban Core','Urban',1),
        ('2164','Urban Core','Urban',1),
        ('2165','Urban Core','Urban',1),
        ('2166','Urban Core','Urban',1),
        ('2167','Urban Core','Urban',1),
        ('2168','Urban Core','Urban',1),
        ('2169','Urban Core','Urban',1),
        ('2170','Urban Core','Urban',1),
        ('2171','Urban Core','Urban',1),
        ('2172','Urban Core','Urban',1),
        ('2173','Urban Core','Urban',1),
        ('2174','Urban Core','Urban',1),
        ('2175','Urban Core','Urban',1),
        ('2176','Urban Core','Urban',1),
        ('2177','Urban Core','Urban',1),
        ('2178','Urban Core','Urban',1),
        ('2179','Urban Core','Urban',1),
        ('2180','Urban Core','Urban',1),
        ('2181','Urban Core','Urban',1),
        ('2182','Urban Core','Urban',1),
        ('2183','Urban Core','Urban',1),
        ('2184','Urban Core','Urban',1),
        ('2185','Urban Core','Urban',1),
        ('2186','Urban Core','Urban',1),
        ('2187','Urban Core','Urban',1),
        ('2188','Urban Core','Urban',1),
        ('2189','Urban Core','Urban',1),
        ('2190','Urban Core','Urban',1),
        ('2191','Urban Core','Urban',1),
        ('2192','Urban Core','Urban',1),
        ('2193','Urban Core','Urban',1),
        ('2194','Urban Core','Urban',1),
        ('2195','Urban Core','Urban',1),
        ('2196','Urban Core','Urban',1),
        ('2197','Urban Core','Urban',1),
        ('2198','Urban Core','Urban',1),
        ('2199','Urban Core','Urban',1),
        ('2200','Urban Core','Urban',1),
        ('2201','Urban Core','Urban',1),
        ('2202','Urban Core','Urban',1),
        ('2203','Urban Core','Urban',1),
        ('2204','Urban Core','Urban',1),
        ('2205','Urban Core','Urban',1),
        ('2206','Urban Core','Urban',1),
        ('2207','Urban Core','Urban',1),
        ('2208','Urban Core','Urban',1),
        ('2209','Urban Core','Urban',1),
        ('2210','Urban Core','Urban',1),
        ('2211','Urban Core','Urban',1),
        ('2212','Urban Core','Urban',1),
        ('2213','Urban Core','Urban',1),
        ('2214','Urban Core','Urban',1),
        ('2215','Urban Core','Urban',1),
        ('2216','Urban Core','Urban',1),
        ('2217','Urban Core','Urban',1),
        ('2218','Urban Core','Urban',1),
        ('2219','Urban Core','Urban',1),
        ('2220','Urban Core','Urban',1),
        ('2221','Urban Core','Urban',1),
        ('2222','Urban Core','Urban',1),
        ('2223','Urban Core','Urban',1),
        ('2224','Urban Core','Urban',1),
        ('2225','Urban Core','Urban',1),
        ('2226','Urban Core','Urban',1),
        ('2227','Urban Core','Urban',1),
        ('2228','Urban Core','Urban',1),
        ('2229','Urban Core','Urban',1),
        ('2230','Urban Core','Urban',1),
        ('2231','Urban Core','Urban',1),
        ('2232','Urban Core','Urban',1),
        ('2233','Urban Core','Urban',1),
        ('2234','Urban Core','Urban',1),
        ('2235','Urban Core','Urban',1),
        ('2236','Urban Core','Urban',1),
        ('2237','Urban Core','Urban',1),
        ('2238','Urban Core','Urban',1),
        ('2239','Urban Core','Urban',1),
        ('2240','Urban Core','Urban',1),
        ('2241','Urban Core','Urban',1),
        ('2242','Urban Core','Urban',1),
        ('2243','Urban Core','Urban',1),
        ('2244','Urban Core','Urban',1),
        ('2245','Urban Core','Urban',1),
        ('2246','Urban Core','Urban',1),
        ('2247','Urban Core','Urban',1),
        ('2248','Urban Core','Urban',1),
        ('2249','Urban Core','Urban',1),
        ('2250','Urban Core','Urban',1),
        ('2251','Urban Core','Urban',1),
        ('2252','Urban Core','Urban',1),
        ('2253','Urban Core','Urban',1),
        ('2254','Urban Core','Urban',1),
        ('2255','Urban Core','Urban',1),
        ('2256','Urban Core','Urban',1),
        ('2257','Urban Core','Urban',1),
        ('2258','Urban Core','Urban',1),
        ('2259','Urban Core','Urban',1),
        ('2260','Urban Core','Urban',1),
        ('2261','Urban Core','Urban',1),
        ('2262','Urban Core','Urban',1),
        ('2263','Urban Core','Urban',1),
        ('2264','Urban Core','Urban',1),
        ('2265','Urban Core','Urban',1),
        ('2266','Urban Core','Urban',1),
        ('2267','Urban Core','Urban',1),
        ('2268','Urban Core','Urban',1),
        ('2269','Urban Core','Urban',1),
        ('2270','Urban Core','Urban',1),
        ('2271','Urban Core','Urban',1),
        ('2272','Urban Core','Urban',1),
        ('2273','Urban Core','Urban',1),
        ('2274','Urban Core','Urban',1),
        ('2275','Urban Core','Urban',1),
        ('2276','Urban Core','Urban',1),
        ('2277','Urban Core','Urban',1),
        ('2278','Urban Core','Urban',1),
        ('2279','Urban Core','Urban',1),
        ('2280','Urban Core','Urban',1),
        ('2281','Urban Core','Urban',1),
        ('2282','Urban Core','Urban',1),
        ('2283','Urban Core','Urban',1),
        ('2284','Urban Core','Urban',1),
        ('2285','Urban Core','Urban',1),
        ('2286','Urban Core','Urban',1),
        ('2287','Urban Core','Urban',1),
        ('2288','Urban Core','Urban',1),
        ('2289','Urban Core','Urban',1),
        ('2290','Urban Core','Urban',1),
        ('2291','Urban Core','Urban',1),
        ('2292','Urban Core','Urban',1),
        ('2293','Urban Core','Urban',1),
        ('2294','Urban Core','Urban',1),
        ('2295','Urban Core','Urban',1),
        ('2296','Urban Core','Urban',1),
        ('2297','Urban Core','Urban',1),
        ('2298','Urban Core','Urban',1),
        ('2299','Urban Core','Urban',1),
        ('2300','Urban Core','Urban',1),
        ('2301','Urban Core','Urban',1),
        ('2302','Urban Core','Urban',1),
        ('2303','Urban Core','Urban',1),
        ('2304','Urban Core','Urban',1),
        ('2305','Urban Core','Urban',1),
        ('2306','Urban Core','Urban',1),
        ('2307','Urban Core','Urban',1),
        ('2308','Urban Core','Urban',1),
        ('2309','Urban Core','Urban',1),
        ('2310','Urban Core','Urban',1),
        ('2311','Urban Core','Urban',1),
        ('2312','Urban Core','Urban',1),
        ('2313','Urban Core','Urban',1),
        ('2314','Urban Core','Urban',1),
        ('2315','Urban Core','Urban',1),
        ('2316','Urban Core','Urban',1),
        ('2317','Urban Core','Urban',1),
        ('2318','Urban Core','Urban',1),
        ('2319','Urban Core','Urban',1),
        ('2320','Urban Core','Urban',1),
        ('2321','Urban Core','Urban',1),
        ('2322','Urban Core','Urban',1),
        ('2323','Urban Core','Urban',1),
        ('2324','Urban Core','Urban',1),
        ('2325','Urban Core','Urban',1),
        ('2326','Urban Core','Urban',1),
        ('2327','Urban Core','Urban',1),
        ('2328','Urban Core','Urban',1),
        ('2329','Urban Core','Urban',1),
        ('2330','Urban Core','Urban',1),
        ('2331','Urban Core','Urban',1),
        ('2332','Urban Core','Urban',1),
        ('2333','Urban Core','Urban',1),
        ('2334','Urban Core','Urban',1),
        ('2335','Urban Core','Urban',1),
        ('2336','Urban Core','Urban',1),
        ('2337','Urban Core','Urban',1),
        ('2338','Urban Core','Urban',1),
        ('2339','Urban Core','Urban',1),
        ('2340','Urban Core','Urban',1),
        ('2341','Urban Core','Urban',1),
        ('2342','Urban Core','Urban',1),
        ('2343','Urban Core','Urban',1),
        ('2344','Urban Core','Urban',1),
        ('2345','Urban Core','Urban',1),
        ('2346','Urban Core','Urban',1),
        ('2347','Urban Core','Urban',1),
        ('2348','Urban Core','Urban',1),
        ('2349','Urban Core','Urban',1),
        ('2350','Urban Core','Urban',1),
        ('2351','Urban Core','Urban',1),
        ('2352','Urban Core','Urban',1),
        ('2353','Urban Core','Urban',1),
        ('2354','Urban Core','Urban',1),
        ('2355','Urban Core','Urban',1),
        ('2356','Urban Core','Urban',1),
        ('2357','Urban Core','Urban',1),
        ('2358','Urban Core','Urban',1),
        ('2359','Urban Core','Urban',1),
        ('2360','Urban Core','Urban',1),
        ('2361','Urban Core','Urban',1),
        ('2362','Urban Core','Urban',1),
        ('2363','Urban Core','Urban',1),
        ('2364','Urban Core','Urban',1),
        ('2365','Urban Core','Urban',1),
        ('2366','Urban Core','Urban',1),
        ('2367','Urban Core','Urban',1),
        ('2368','Urban Core','Urban',1),
        ('2369','Urban Core','Urban',1),
        ('2370','Urban Core','Urban',1),
        ('2371','Urban Core','Urban',1),
        ('2372','Urban Core','Urban',1),
        ('2373','Urban Core','Urban',1),
        ('2374','Urban Core','Urban',1),
        ('2375','Urban Core','Urban',1),
        ('2376','Urban Core','Urban',1),
        ('2377','Urban Core','Urban',1),
        ('2378','Urban Core','Urban',1),
        ('2379','Urban Core','Urban',1),
        ('2380','Urban Core','Urban',1),
        ('2381','Urban Core','Urban',1),
        ('2382','Urban Core','Urban',1),
        ('2383','Urban Core','Urban',1),
        ('2384','Urban Core','Urban',1),
        ('2385','Urban Core','Urban',1),
        ('2386','Urban Core','Urban',1),
        ('2387','Urban Core','Urban',1),
        ('2388','Urban Core','Urban',1),
        ('2389','Urban Core','Urban',1),
        ('2390','Urban Core','Urban',1),
        ('2391','Urban Core','Urban',1),
        ('2392','Urban Core','Urban',1),
        ('2393','Urban Core','Urban',1),
        ('2394','Urban Core','Urban',1),
        ('2395','Urban Core','Urban',1),
        ('2396','Urban Core','Urban',1),
        ('2397','Urban Core','Urban',1),
        ('2398','Urban Core','Urban',1),
        ('2399','Urban Core','Urban',1),
        ('2400','Urban Core','Urban',1),
        ('2401','Urban Core','Urban',1),
        ('2402','Urban Core','Urban',1),
        ('2403','Urban Core','Urban',1),
        ('2404','Urban Core','Urban',1),
        ('2405','Urban Core','Urban',1),
        ('2406','Urban Core','Urban',1),
        ('2407','Urban Core','Urban',1),
        ('2408','Urban Core','Urban',1),
        ('2409','Urban Core','Urban',1),
        ('2410','Urban Core','Urban',1),
        ('2411','Urban Core','Urban',1),
        ('2412','Urban Core','Urban',1),
        ('2413','Urban Core','Urban',1),
        ('2414','Urban Core','Urban',1),
        ('2415','Urban Core','Urban',1),
        ('2416','Urban Core','Urban',1),
        ('2417','Urban Core','Urban',1),
        ('2418','Urban Core','Urban',1),
        ('2419','Urban Core','Urban',1),
        ('2420','Urban Core','Urban',1),
        ('2421','Urban Core','Urban',1),
        ('2422','Urban Core','Urban',1),
        ('2423','Urban Core','Urban',1),
        ('2424','Urban Core','Urban',1),
        ('2425','Urban Core','Urban',1),
        ('2426','Urban Core','Urban',1),
        ('2427','Urban Core','Urban',1),
        ('2428','Urban Core','Urban',1),
        ('2429','Urban Core','Urban',1),
        ('2430','Urban Core','Urban',1),
        ('2431','Urban Core','Urban',1),
        ('2432','Urban Core','Urban',1),
        ('2433','Urban Core','Urban',1),
        ('2434','Urban Core','Urban',1),
        ('2435','Urban Core','Urban',1),
        ('2436','Urban Core','Urban',1),
        ('2437','Urban Core','Urban',1),
        ('2438','Urban Core','Urban',1),
        ('2439','Urban Core','Urban',1),
        ('2440','Urban Core','Urban',1),
        ('2441','Urban Core','Urban',1),
        ('2442','Urban Core','Urban',1),
        ('2443','Urban Core','Urban',1),
        ('2444','Urban Core','Urban',1),
        ('2445','Urban Core','Urban',1),
        ('2446','Urban Core','Urban',1),
        ('2447','Urban Core','Urban',1),
        ('2448','Urban Core','Urban',1),
        ('2449','Urban Core','Urban',1),
        ('2450','Urban Core','Urban',1),
        ('2451','Urban Core','Urban',1),
        ('2452','Urban Core','Urban',1),
        ('2453','Urban Core','Urban',1),
        ('2454','Urban Core','Urban',1),
        ('2455','Urban Core','Urban',1),
        ('2456','Urban Core','Urban',1),
        ('2457','Urban Core','Urban',1),
        ('2458','Urban Core','Urban',1),
        ('2459','Urban Core','Urban',1),
        ('2460','Urban Core','Urban',1),
        ('2461','Urban Core','Urban',1),
        ('2462','Urban Core','Urban',1),
        ('2463','Urban Core','Urban',1),
        ('2464','Urban Core','Urban',1),
        ('2465','Urban Core','Urban',1),
        ('2466','Urban Core','Urban',1),
        ('2467','Urban Core','Urban',1),
        ('2468','Urban Core','Urban',1),
        ('2469','Urban Core','Urban',1),
        ('2470','Urban Core','Urban',1),
        ('2471','Urban Core','Urban',1),
        ('2472','Urban Core','Urban',1),
        ('2473','Urban Core','Urban',1),
        ('2474','Urban Core','Urban',1),
        ('2475','Urban Core','Urban',1),
        ('2476','Urban Core','Urban',1),
        ('2477','Urban Core','Urban',1),
        ('2478','Urban Core','Urban',1),
        ('2479','Urban Core','Urban',1),
        ('2480','Urban Core','Urban',1),
        ('2481','Urban Core','Urban',1),
        ('2482','Urban Core','Urban',1),
        ('2483','Urban Core','Urban',1),
        ('2484','Urban Core','Urban',1),
        ('2485','Urban Core','Urban',1),
        ('2486','Urban Core','Urban',1),
        ('2487','Urban Core','Urban',1),
        ('2488','Urban Core','Urban',1),
        ('2489','Urban Core','Urban',1),
        ('2490','Urban Core','Urban',1),
        ('2491','Urban Core','Urban',1),
        ('2492','Urban Core','Urban',1),
        ('2493','Urban Core','Urban',1),
        ('2494','Urban Core','Urban',1),
        ('2495','Urban Core','Urban',1),
        ('2496','Urban Core','Urban',1),
        ('2497','Urban Core','Urban',1),
        ('2498','Urban Core','Urban',1),
        ('2499','Urban Core','Urban',1),
        ('2500','Urban Core','Urban',1),
        ('2501','Urban Core','Urban',1),
        ('2502','Urban Core','Urban',1),
        ('2503','Urban Core','Urban',1),
        ('2504','Urban Core','Urban',1),
        ('2505','Urban Core','Urban',1),
        ('2506','Urban Core','Urban',1),
        ('2507','Urban Core','Urban',1),
        ('2508','Urban Core','Urban',1),
        ('2509','Urban Core','Urban',1),
        ('2510','Urban Core','Urban',1),
        ('2511','Urban Core','Urban',1),
        ('2512','Urban Core','Urban',1),
        ('2513','Urban Core','Urban',1),
        ('2514','Urban Core','Urban',1),
        ('2515','Urban Core','Urban',1),
        ('2516','Urban Core','Urban',1),
        ('2517','Urban Core','Urban',1),
        ('2518','Urban Core','Urban',1),
        ('2519','Urban Core','Urban',1),
        ('2520','Urban Core','Urban',1),
        ('2521','Urban Core','Urban',1),
        ('2522','Urban Core','Urban',1),
        ('2523','Urban Core','Urban',1),
        ('2524','Urban Core','Urban',1),
        ('2525','Urban Core','Urban',1),
        ('2526','Urban Core','Urban',1),
        ('2527','Urban Core','Urban',1),
        ('2528','Urban Core','Urban',1),
        ('2529','Urban Core','Urban',1),
        ('2530','Urban Core','Urban',1),
        ('2531','Urban Core','Urban',1),
        ('2532','Urban Core','Urban',1),
        ('2533','Urban Core','Urban',1),
        ('2534','Urban Core','Urban',1),
        ('2535','Urban Core','Urban',1),
        ('2536','Urban Core','Urban',1),
        ('2537','Urban Core','Urban',1),
        ('2538','Urban Core','Urban',1),
        ('2539','Urban Core','Urban',1),
        ('2540','Urban Core','Urban',1),
        ('2541','Urban Core','Urban',1),
        ('2542','Urban Core','Urban',1),
        ('2543','Urban Core','Urban',1),
        ('2544','Urban Core','Urban',1),
        ('2545','Urban Core','Urban',1),
        ('2546','Urban Core','Urban',1),
        ('2547','Urban Core','Urban',1),
        ('2548','Urban Core','Urban',1),
        ('2549','Urban Core','Urban',1),
        ('2550','Urban Core','Urban',1),
        ('2551','Urban Core','Urban',1),
        ('2552','Urban Core','Urban',1),
        ('2553','Urban Core','Urban',1),
        ('2554','Urban Core','Urban',1),
        ('2555','Urban Core','Urban',1),
        ('2556','Urban Core','Urban',1),
        ('2557','Urban Core','Urban',1),
        ('2558','Urban Core','Urban',1),
        ('2559','Urban Core','Urban',1),
        ('2560','Urban Core','Urban',1),
        ('2561','Urban Core','Urban',1),
        ('2562','Urban Core','Urban',1),
        ('2563','Urban Core','Urban',1),
        ('2564','Urban Core','Urban',1),
        ('2565','Urban Core','Urban',1),
        ('2566','Urban Core','Urban',1),
        ('2567','Urban Core','Urban',1),
        ('2568','Urban Core','Urban',1),
        ('2569','Urban Core','Urban',1),
        ('2570','Urban Core','Urban',1),
        ('2571','Urban Core','Urban',1),
        ('2572','Urban Core','Urban',1),
        ('2573','Urban Core','Urban',1),
        ('2574','Urban Core','Urban',1),
        ('2575','Urban Core','Urban',1),
        ('2576','Urban Core','Urban',1),
        ('2577','Urban Core','Urban',1),
        ('2578','Urban Core','Urban',1),
        ('2579','Urban Core','Urban',1),
        ('2580','Urban Core','Urban',1),
        ('2581','Urban Core','Urban',1),
        ('2582','Urban Core','Urban',1),
        ('2583','Urban Core','Urban',1),
        ('2584','Urban Core','Urban',1),
        ('2585','Urban Core','Urban',1),
        ('2586','Urban Core','Urban',1),
        ('2587','Urban Core','Urban',1),
        ('2588','Urban Core','Urban',1),
        ('2589','Urban Core','Urban',1),
        ('2590','Urban Core','Urban',1),
        ('2591','Urban Core','Urban',1),
        ('2592','Urban Core','Urban',1),
        ('2593','Urban Core','Urban',1),
        ('2594','Urban Core','Urban',1),
        ('2595','Urban Core','Urban',1),
        ('2596','Urban Core','Urban',1),
        ('2597','Urban Core','Urban',1),
        ('2598','Urban Core','Urban',1),
        ('2599','Urban Core','Urban',1),
        ('2600','Urban Core','Urban',1),
        ('2601','Urban Core','Urban',1),
        ('2602','Urban Core','Urban',1),
        ('2603','Urban Core','Urban',1),
        ('2604','Urban Core','Urban',1),
        ('2605','Urban Core','Urban',1),
        ('2606','Urban Core','Urban',1),
        ('2607','Urban Core','Urban',1),
        ('2608','Urban Core','Urban',1),
        ('2609','Urban Core','Urban',1),
        ('2610','Urban Core','Urban',1),
        ('2611','Urban Core','Urban',1),
        ('2612','Urban Core','Urban',1),
        ('2613','Urban Core','Urban',1),
        ('2614','Urban Core','Urban',1),
        ('2615','Urban Core','Urban',1),
        ('2616','Urban Core','Urban',1),
        ('2617','Urban Core','Urban',1),
        ('2618','Urban Core','Urban',1),
        ('2619','Urban Core','Urban',1),
        ('2620','Urban Core','Urban',1),
        ('2621','Urban Core','Urban',1),
        ('2622','Urban Core','Urban',1),
        ('2623','Urban Core','Urban',1),
        ('2624','Urban Core','Urban',1),
        ('2625','Urban Core','Urban',1),
        ('2626','Urban Core','Urban',1),
        ('2627','Urban Core','Urban',1),
        ('2628','Urban Core','Urban',1),
        ('2629','Urban Core','Urban',1),
        ('2630','Urban Core','Urban',1),
        ('2631','Urban Core','Urban',1),
        ('2632','Urban Core','Urban',1),
        ('2633','Urban Core','Urban',1),
        ('2634','Urban Core','Urban',1),
        ('2635','Urban Core','Urban',1),
        ('2636','Urban Core','Urban',1),
        ('2637','Urban Core','Urban',1),
        ('2638','Urban Core','Urban',1),
        ('2639','Urban Core','Urban',1),
        ('2640','Urban Core','Urban',1),
        ('2641','Urban Core','Urban',1),
        ('2642','Urban Core','Urban',1),
        ('2643','Urban Core','Urban',1),
        ('2644','Urban Core','Urban',1),
        ('2645','Urban Core','Urban',1),
        ('2646','Urban Core','Urban',1),
        ('2647','Urban Core','Urban',1),
        ('2648','Urban Core','Urban',1),
        ('2649','Urban Core','Urban',1),
        ('2650','Urban Core','Urban',1),
        ('2651','Urban Core','Urban',1),
        ('2652','Urban Core','Urban',1),
        ('2653','Urban Core','Urban',1),
        ('2654','Urban Core','Urban',1),
        ('2656','Urban Core','Urban',1),
        ('2657','Urban Core','Urban',1),
        ('2658','Urban Core','Urban',1),
        ('2659','Urban Core','Urban',1),
        ('2660','Urban Core','Urban',1),
        ('2661','Urban Core','Urban',1),
        ('2662','Urban Core','Urban',1),
        ('2663','Urban Core','Urban',1),
        ('2664','Urban Core','Urban',1),
        ('2665','Urban Core','Urban',1),
        ('2666','Urban Core','Urban',1),
        ('2667','Urban Core','Urban',1),
        ('2668','Urban Core','Urban',1),
        ('2669','Urban Core','Urban',1),
        ('2670','Urban Core','Urban',1),
        ('2671','Urban Core','Urban',1),
        ('2672','Urban Core','Urban',1),
        ('2673','Urban Core','Urban',1),
        ('2674','Urban Core','Urban',1),
        ('2675','Urban Core','Urban',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('2676','Urban Core','Urban',1),
        ('2677','Urban Core','Urban',1),
        ('2678','Urban Core','Urban',1),
        ('2679','Urban Core','Urban',1),
        ('2680','Urban Core','Urban',1),
        ('2681','Urban Core','Urban',1),
        ('2682','Urban Core','Urban',1),
        ('2683','Urban Core','Urban',1),
        ('2684','Urban Core','Urban',1),
        ('2685','Urban Core','Urban',1),
        ('2686','Urban Core','Urban',1),
        ('2687','Urban Core','Urban',1),
        ('2688','Urban Core','Urban',1),
        ('2689','Urban Core','Urban',1),
        ('2690','Urban Core','Urban',1),
        ('2691','Urban Core','Urban',1),
        ('2692','Urban Core','Urban',1),
        ('2693','Urban Core','Urban',1),
        ('2694','Urban Core','Urban',1),
        ('2695','Urban Core','Urban',1),
        ('2696','Urban Core','Urban',1),
        ('2697','Urban Core','Urban',1),
        ('2698','Urban Core','Urban',1),
        ('2699','Urban Core','Urban',1),
        ('2700','Urban Core','Urban',1),
        ('2701','Urban Core','Urban',1),
        ('2702','Urban Core','Urban',1),
        ('2703','Urban Core','Urban',1),
        ('2704','Urban Core','Urban',1),
        ('2705','Urban Core','Urban',1),
        ('2706','Urban Core','Urban',1),
        ('2707','Urban Core','Urban',1),
        ('2708','Urban Core','Urban',1),
        ('2709','Urban Core','Urban',1),
        ('2710','Urban Core','Urban',1),
        ('2711','Urban Core','Urban',1),
        ('2712','Urban Core','Urban',1),
        ('2713','Urban Core','Urban',1),
        ('2714','Urban Core','Urban',1),
        ('2715','Urban Core','Urban',1),
        ('2716','Urban Core','Urban',1),
        ('2717','Urban Core','Urban',1),
        ('2718','Urban Core','Urban',1),
        ('2719','Urban Core','Urban',1),
        ('2720','Urban Core','Urban',1),
        ('2721','Urban Core','Urban',1),
        ('2722','Urban Core','Urban',1),
        ('2723','Urban Core','Urban',1),
        ('2724','Urban Core','Urban',1),
        ('2725','Urban Core','Urban',1),
        ('2726','Urban Core','Urban',1),
        ('2727','Urban Core','Urban',1),
        ('2728','Urban Core','Urban',1),
        ('2729','Urban Core','Urban',1),
        ('2730','Urban Core','Urban',1),
        ('2731','Urban Core','Urban',1),
        ('2732','Urban Core','Urban',1),
        ('2733','Urban Core','Urban',1),
        ('2734','Urban Core','Urban',1),
        ('2735','Urban Core','Urban',1),
        ('2736','Urban Core','Urban',1),
        ('2737','Urban Core','Urban',1),
        ('2738','Urban Core','Urban',1),
        ('2739','Urban Core','Urban',1),
        ('2740','Urban Core','Urban',1),
        ('2741','Urban Core','Urban',1),
        ('2742','Urban Core','Urban',1),
        ('2743','Urban Core','Urban',1),
        ('2744','Urban Core','Urban',1),
        ('2745','Urban Core','Urban',1),
        ('2746','Urban Core','Urban',1),
        ('2747','Urban Core','Urban',1),
        ('2748','Urban Core','Urban',1),
        ('2749','Urban Core','Urban',1),
        ('2750','Urban Core','Urban',1),
        ('2751','Urban Core','Urban',1),
        ('2752','Urban Core','Urban',1),
        ('2753','Urban Core','Urban',1),
        ('2754','Urban Core','Urban',1),
        ('2755','Urban Core','Urban',1),
        ('2756','Urban Core','Urban',1),
        ('2757','Urban Core','Urban',1),
        ('2758','Urban Core','Urban',1),
        ('2759','Urban Core','Urban',1),
        ('2760','Urban Core','Urban',1),
        ('2761','Urban Core','Urban',1),
        ('2762','Urban Core','Urban',1),
        ('2763','Urban Core','Urban',1),
        ('2764','Urban Core','Urban',1),
        ('2765','Urban Core','Urban',1),
        ('2766','Urban Core','Urban',1),
        ('2767','Urban Core','Urban',1),
        ('2768','Urban Core','Urban',1),
        ('2769','Urban Core','Urban',1),
        ('2770','Urban Core','Urban',1),
        ('2771','Urban Core','Urban',1),
        ('2772','Urban Core','Urban',1),
        ('2773','Urban Core','Urban',1),
        ('2774','Urban Core','Urban',1),
        ('2775','Urban Core','Urban',1),
        ('2776','Urban Core','Urban',1),
        ('2777','Urban Core','Urban',1),
        ('2778','Urban Core','Urban',1),
        ('2779','Urban Core','Urban',1),
        ('2780','Urban Core','Urban',1),
        ('2781','Urban Core','Urban',1),
        ('2782','Urban Core','Urban',1),
        ('2783','Urban Core','Urban',1),
        ('2784','Urban Core','Urban',1),
        ('2785','Urban Core','Urban',1),
        ('2786','Urban Core','Urban',1),
        ('2787','Urban Core','Urban',1),
        ('2788','Urban Core','Urban',1),
        ('2789','Urban Core','Urban',1),
        ('2790','Urban Core','Urban',1),
        ('2791','Urban Core','Urban',1),
        ('2792','Urban Core','Urban',1),
        ('2793','Urban Core','Urban',1),
        ('2794','Urban Core','Urban',1),
        ('2795','Urban Core','Urban',1),
        ('2796','Urban Core','Urban',1),
        ('2797','Urban Core','Urban',1),
        ('2798','Urban Core','Urban',1),
        ('2799','Urban Core','Urban',1),
        ('2800','Urban Core','Urban',1),
        ('2801','Urban Core','Urban',1),
        ('2802','Urban Core','Urban',1),
        ('2803','Urban Core','Urban',1),
        ('2804','Urban Core','Urban',1),
        ('2805','Urban Core','Urban',1),
        ('2806','Urban Core','Urban',1),
        ('2807','Urban Core','Urban',1),
        ('2808','Urban Core','Urban',1),
        ('2809','Urban Core','Urban',1),
        ('2810','Urban Core','Urban',1),
        ('2811','Urban Core','Urban',1),
        ('2812','Urban Core','Urban',1),
        ('2813','Urban Core','Urban',1),
        ('2814','Urban Core','Urban',1),
        ('2815','Urban Core','Urban',1),
        ('2816','Urban Core','Urban',1),
        ('2817','Urban Core','Urban',1),
        ('2818','Urban Core','Urban',1),
        ('2819','Urban Core','Urban',1),
        ('2820','Urban Core','Urban',1),
        ('2821','Urban Core','Urban',1),
        ('2822','Urban Core','Urban',1),
        ('2823','Urban Core','Urban',1),
        ('2824','Urban Core','Urban',1),
        ('2825','Urban Core','Urban',1),
        ('2826','Urban Core','Urban',1),
        ('2827','Urban Core','Urban',1),
        ('2828','Urban Core','Urban',1),
        ('2829','Urban Core','Urban',1),
        ('2830','Urban Core','Urban',1),
        ('2831','Urban Core','Urban',1),
        ('2832','Urban Core','Urban',1),
        ('2833','Urban Core','Urban',1),
        ('2834','Urban Core','Urban',1),
        ('2835','Urban Core','Urban',1),
        ('2836','Urban Core','Urban',1),
        ('2837','Urban Core','Urban',1),
        ('2838','Urban Core','Urban',1),
        ('2839','Urban Core','Urban',1),
        ('2840','Urban Core','Urban',1),
        ('2841','Urban Core','Urban',1),
        ('2842','Urban Core','Urban',1),
        ('2843','Urban Core','Urban',1),
        ('2844','Urban Core','Urban',1),
        ('2845','Urban Core','Urban',1),
        ('2846','Urban Core','Urban',1),
        ('2847','Urban Core','Urban',1),
        ('2848','Urban Core','Urban',1),
        ('2849','Urban Core','Urban',1),
        ('2850','Urban Core','Urban',1),
        ('2851','Urban Core','Urban',1),
        ('2852','Urban Core','Urban',1),
        ('2853','Urban Core','Urban',1),
        ('2854','Urban Core','Urban',1),
        ('2855','Urban Core','Urban',1),
        ('2856','Urban Core','Urban',1),
        ('2857','Urban Core','Urban',1),
        ('2858','Urban Core','Urban',1),
        ('2859','Urban Core','Urban',1),
        ('2860','Urban Core','Urban',1),
        ('2861','Urban Core','Urban',1),
        ('2862','Urban Core','Urban',1),
        ('2863','Urban Core','Urban',1),
        ('2864','Urban Core','Urban',1),
        ('2865','Urban Core','Urban',1),
        ('2866','Urban Core','Urban',1),
        ('2867','Urban Core','Urban',1),
        ('2868','Urban Core','Urban',1),
        ('2869','Urban Core','Urban',1),
        ('2870','Urban Core','Urban',1),
        ('2871','Urban Core','Urban',1),
        ('2872','Urban Core','Urban',1),
        ('2873','Urban Core','Urban',1),
        ('2874','Urban Core','Urban',1),
        ('2875','Urban Core','Urban',1),
        ('2876','Urban Core','Urban',1),
        ('2877','Urban Core','Urban',1),
        ('2878','Urban Core','Urban',1),
        ('2879','Urban Core','Urban',1),
        ('2880','Urban Core','Urban',1),
        ('2881','Urban Core','Urban',1),
        ('2882','Urban Core','Urban',1),
        ('2883','Urban Core','Urban',1),
        ('2884','Urban Core','Urban',1),
        ('2885','Urban Core','Urban',1),
        ('2886','Urban Core','Urban',1),
        ('2887','Urban Core','Urban',1),
        ('2888','Urban Core','Urban',1),
        ('2889','Urban Core','Urban',1),
        ('2890','Urban Core','Urban',1),
        ('2891','Urban Core','Urban',1),
        ('2892','Urban Core','Urban',1),
        ('2893','Urban Core','Urban',1),
        ('2894','Urban Core','Urban',1),
        ('2895','Urban Core','Urban',1),
        ('2896','Urban Core','Urban',1),
        ('2897','Urban Core','Urban',1),
        ('2898','Urban Core','Urban',1),
        ('2899','Urban Core','Urban',1),
        ('2900','Urban Core','Urban',1),
        ('2901','Urban Core','Urban',1),
        ('2902','Urban Core','Urban',1),
        ('2903','Urban Core','Urban',1),
        ('2904','Urban Core','Urban',1),
        ('2905','Urban Core','Urban',1),
        ('2906','Urban Core','Urban',1),
        ('2907','Urban Core','Urban',1),
        ('2908','Urban Core','Urban',1),
        ('2909','Urban Core','Urban',1),
        ('2910','Urban Core','Urban',1),
        ('2911','Urban Core','Urban',1),
        ('2912','Urban Core','Urban',1),
        ('2913','Urban Core','Urban',1),
        ('2914','Urban Core','Urban',1),
        ('2915','Urban Core','Urban',1),
        ('2916','Urban Core','Urban',1),
        ('2917','Urban Core','Urban',1),
        ('2918','Urban Core','Urban',1),
        ('2919','Urban Core','Urban',1),
        ('2920','Urban Core','Urban',1),
        ('2921','Urban Core','Urban',1),
        ('2922','Urban Core','Urban',1),
        ('2923','Urban Core','Urban',1),
        ('2924','Urban Core','Urban',1),
        ('2925','Urban Core','Urban',1),
        ('2926','Urban Core','Urban',1),
        ('2927','Urban Core','Urban',1),
        ('2928','Urban Core','Urban',1),
        ('2929','Urban Core','Urban',1),
        ('2930','Urban Core','Urban',1),
        ('2931','Urban Core','Urban',1),
        ('2932','Urban Core','Urban',1),
        ('2933','Urban Core','Urban',1),
        ('2934','Urban Core','Urban',1),
        ('2935','Urban Core','Urban',1),
        ('2936','Urban Core','Urban',1),
        ('2937','Urban Core','Urban',1),
        ('2938','Urban Core','Urban',1),
        ('2939','Urban Core','Urban',1),
        ('2940','Urban Core','Urban',1),
        ('2941','Urban Core','Urban',1),
        ('2942','Urban Core','Urban',1),
        ('2943','Urban Core','Urban',1),
        ('2944','Urban Core','Urban',1),
        ('2945','Urban Core','Urban',1),
        ('2946','Urban Core','Urban',1),
        ('2947','Urban Core','Urban',1),
        ('2948','Urban Core','Urban',1),
        ('2949','Urban Core','Urban',1),
        ('2950','Urban Core','Urban',1),
        ('2951','Urban Core','Urban',1),
        ('2952','Urban Core','Urban',1),
        ('2953','Urban Core','Urban',1),
        ('2954','Urban Core','Urban',1),
        ('2955','Urban Core','Urban',1),
        ('2956','Urban Core','Urban',1),
        ('2957','Urban Core','Urban',1),
        ('2958','Urban Core','Urban',1),
        ('2959','Urban Core','Urban',1),
        ('2960','Urban Core','Urban',1),
        ('2961','Urban Core','Urban',1),
        ('2962','Urban Core','Urban',1),
        ('2963','Urban Core','Urban',1),
        ('2964','Urban Core','Urban',1),
        ('2965','Urban Core','Urban',1),
        ('2966','Urban Core','Urban',1),
        ('2967','Urban Core','Urban',1),
        ('2968','Urban Core','Urban',1),
        ('2969','Urban Core','Urban',1),
        ('2970','Urban Core','Urban',1),
        ('2971','Urban Core','Urban',1),
        ('2972','Urban Core','Urban',1),
        ('2973','Urban Core','Urban',1),
        ('2974','Urban Core','Urban',1),
        ('2975','Urban Core','Urban',1),
        ('2976','Urban Core','Urban',1),
        ('2977','Urban Core','Urban',1),
        ('2978','Urban Core','Urban',1),
        ('2979','Urban Core','Urban',1),
        ('2980','Urban Core','Urban',1),
        ('2981','Urban Core','Urban',1),
        ('2982','Urban Core','Urban',1),
        ('2983','Urban Core','Urban',1),
        ('2984','Urban Core','Urban',1),
        ('2985','Urban Core','Urban',1),
        ('2986','Urban Core','Urban',1),
        ('2987','Urban Core','Urban',1),
        ('2988','Urban Core','Urban',1),
        ('2989','Urban Core','Urban',1),
        ('2990','Urban Core','Urban',1),
        ('2991','Urban Core','Urban',1),
        ('2992','Urban Core','Urban',1),
        ('2993','Urban Core','Urban',1),
        ('2994','Urban Core','Urban',1),
        ('2995','Urban Core','Urban',1),
        ('2996','Urban Core','Urban',1),
        ('2997','Urban Core','Urban',1),
        ('2998','Urban Core','Urban',1),
        ('2999','Urban Core','Urban',1),
        ('3000','Urban Core','Urban',1),
        ('3001','Urban Core','Urban',1),
        ('3002','Urban Core','Urban',1),
        ('3006','Urban Core','Urban',1),
        ('3013','Urban Core','Urban',1),
        ('3014','Urban Core','Urban',1),
        ('3015','Urban Core','Urban',1),
        ('3016','Urban Core','Urban',1),
        ('3017','Urban Core','Urban',1),
        ('3018','Urban Core','Urban',1),
        ('3019','Urban Core','Urban',1),
        ('3020','Urban Core','Urban',1),
        ('3021','Urban Core','Urban',1),
        ('3022','Urban Core','Urban',1),
        ('3023','Urban Core','Urban',1),
        ('3024','Urban Core','Urban',1),
        ('3025','Urban Core','Urban',1),
        ('3026','Urban Core','Urban',1),
        ('3027','Urban Core','Urban',1),
        ('3028','Urban Core','Urban',1),
        ('3029','Urban Core','Urban',1),
        ('3030','Urban Core','Urban',1),
        ('3031','Urban Core','Urban',1),
        ('3032','Urban Core','Urban',1),
        ('3033','Urban Core','Urban',1),
        ('3034','Urban Core','Urban',1),
        ('3035','Urban Core','Urban',1),
        ('3036','Urban Core','Urban',1),
        ('3037','Urban Core','Urban',1),
        ('3038','Urban Core','Urban',1),
        ('3039','Urban Core','Urban',1),
        ('3040','Urban Core','Urban',1),
        ('3041','Urban Core','Urban',1),
        ('3042','Urban Core','Urban',1),
        ('3043','Urban Core','Urban',1),
        ('3044','Urban Core','Urban',1),
        ('3045','Urban Core','Urban',1),
        ('3046','Urban Core','Urban',1),
        ('3047','Urban Core','Urban',1),
        ('3048','Urban Core','Urban',1),
        ('3049','Urban Core','Urban',1),
        ('3050','Urban Core','Urban',1),
        ('3051','Urban Core','Urban',1),
        ('3052','Urban Core','Urban',1),
        ('3053','Urban Core','Urban',1),
        ('3054','Urban Core','Urban',1),
        ('3055','Urban Core','Urban',1),
        ('3056','Urban Core','Urban',1),
        ('3057','Urban Core','Urban',1),
        ('3058','Urban Core','Urban',1),
        ('3059','Urban Core','Urban',1),
        ('3060','Urban Core','Urban',1),
        ('3061','Urban Core','Urban',1),
        ('3062','Urban Core','Urban',1),
        ('3063','Urban Core','Urban',1),
        ('3064','Urban Core','Urban',1),
        ('3065','Urban Core','Urban',1),
        ('3066','Urban Core','Urban',1),
        ('3067','Urban Core','Urban',1),
        ('3068','Urban Core','Urban',1),
        ('3069','Urban Core','Urban',1),
        ('3070','Urban Core','Urban',1),
        ('3071','Urban Core','Urban',1),
        ('3072','Urban Core','Urban',1),
        ('3073','Urban Core','Urban',1),
        ('3074','Urban Core','Urban',1),
        ('3075','Urban Core','Urban',1),
        ('3076','Urban Core','Urban',1),
        ('3077','Urban Core','Urban',1),
        ('3078','Urban Core','Urban',1),
        ('3079','Urban Core','Urban',1),
        ('3080','Urban Core','Urban',1),
        ('3081','Urban Core','Urban',1),
        ('3082','Urban Core','Urban',1),
        ('3083','Urban Core','Urban',1),
        ('3084','Urban Core','Urban',1),
        ('3085','Urban Core','Urban',1),
        ('3086','Urban Core','Urban',1),
        ('3087','Urban Core','Urban',1),
        ('3088','Urban Core','Urban',1),
        ('3089','Urban Core','Urban',1),
        ('3090','Urban Core','Urban',1),
        ('3091','Urban Core','Urban',1),
        ('3092','Urban Core','Urban',1),
        ('3093','Urban Core','Urban',1),
        ('3094','Urban Core','Urban',1),
        ('3095','Urban Core','Urban',1),
        ('3096','Urban Core','Urban',1),
        ('3097','Urban Core','Urban',1),
        ('3098','Urban Core','Urban',1),
        ('3099','Urban Core','Urban',1),
        ('3100','Urban Core','Urban',1),
        ('3101','Urban Core','Urban',1),
        ('3102','Urban Core','Urban',1),
        ('3103','Urban Core','Urban',1),
        ('3104','Urban Core','Urban',1),
        ('3105','Urban Core','Urban',1),
        ('3106','Urban Core','Urban',1),
        ('3107','Urban Core','Urban',1),
        ('3108','Urban Core','Urban',1),
        ('3109','Urban Core','Urban',1),
        ('3110','Urban Core','Urban',1),
        ('3111','Urban Core','Urban',1),
        ('3112','Urban Core','Urban',1),
        ('3113','Urban Core','Urban',1),
        ('3114','Urban Core','Urban',1),
        ('3115','Urban Core','Urban',1),
        ('3118','Ocean Beach','Coastal',1),
        ('3120','Urban Core','Urban',1),
        ('3121','Ocean Beach','Coastal',1),
        ('3123','Ocean Beach','Coastal',1),
        ('3124','Ocean Beach','Coastal',1),
        ('3125','Urban Core','Urban',1),
        ('3126','Urban Core','Urban',1),
        ('3127','Urban Core','Urban',1),
        ('3128','Urban Core','Urban',1),
        ('3129','Urban Core','Urban',1),
        ('3130','Urban Core','Urban',1),
        ('3131','Urban Core','Urban',1),
        ('3132','Urban Core','Urban',1),
        ('3133','Urban Core','Urban',1),
        ('3134','Urban Core','Urban',1),
        ('3135','Urban Core','Urban',1),
        ('3136','Urban Core','Urban',1),
        ('3137','Urban Core','Urban',1),
        ('3138','Urban Core','Urban',1),
        ('3139','Urban Core','Urban',1),
        ('3140','Urban Core','Urban',1),
        ('3141','Urban Core','Urban',1),
        ('3142','Urban Core','Urban',1),
        ('3143','Ocean Beach','Coastal',1),
        ('3145','Ocean Beach','Coastal',1),
        ('3146','Urban Core','Urban',1),
        ('3147','Ocean Beach','Coastal',1),
        ('3148','Ocean Beach','Coastal',1),
        ('3149','Ocean Beach','Coastal',1),
        ('3167','Ocean Beach','Coastal',1),
        ('3168','Ocean Beach','Coastal',1),
        ('3358','Ocean Beach','Coastal',1),
        ('3359','Ocean Beach','Coastal',1),
        ('3411','Ocean Beach','Coastal',1),
        ('3412','Ocean Beach','Coastal',1),
        ('3413','Ocean Beach','Coastal',1),
        ('3414','Ocean Beach','Coastal',1),
        ('3415','Ocean Beach','Coastal',1),
        ('3416','Ocean Beach','Coastal',1),
        ('3417','Ocean Beach','Coastal',1),
        ('3418','Ocean Beach','Coastal',1),
        ('3419','Ocean Beach','Coastal',1),
        ('3420','Ocean Beach','Coastal',1),
        ('3421','Ocean Beach','Coastal',1),
        ('3422','Ocean Beach','Coastal',1),
        ('3423','Ocean Beach','Coastal',1),
        ('3424','Ocean Beach','Coastal',1),
        ('3425','Ocean Beach','Coastal',1),
        ('3426','Ocean Beach','Coastal',1),
        ('3427','Ocean Beach','Coastal',1),
        ('3428','Ocean Beach','Coastal',1),
        ('3429','Ocean Beach','Coastal',1),
        ('3430','Ocean Beach','Coastal',1),
        ('3431','Ocean Beach','Coastal',1),
        ('3432','Ocean Beach','Coastal',1),
        ('3433','Ocean Beach','Coastal',1),
        ('3434','Ocean Beach','Coastal',1),
        ('3435','Ocean Beach','Coastal',1),
        ('3436','Ocean Beach','Coastal',1),
        ('3437','Ocean Beach','Coastal',1),
        ('3438','Ocean Beach','Coastal',1),
        ('3439','Ocean Beach','Coastal',1),
        ('3440','Ocean Beach','Coastal',1),
        ('3441','Ocean Beach','Coastal',1),
        ('3442','Ocean Beach','Coastal',1),
        ('3443','Ocean Beach','Coastal',1),
        ('3444','Ocean Beach','Coastal',1),
        ('3445','Ocean Beach','Coastal',1),
        ('3446','Ocean Beach','Coastal',1),
        ('3447','Ocean Beach','Coastal',1),
        ('3448','Ocean Beach','Coastal',1),
        ('3449','Ocean Beach','Coastal',1),
        ('3450','Ocean Beach','Coastal',1),
        ('3451','Ocean Beach','Coastal',1),
        ('3452','Ocean Beach','Coastal',1),
        ('3453','Ocean Beach','Coastal',1),
        ('3454','Ocean Beach','Coastal',1),
        ('3455','Ocean Beach','Coastal',1),
        ('3456','Ocean Beach','Coastal',1),
        ('3457','Ocean Beach','Coastal',1),
        ('3459','Ocean Beach','Coastal',1),
        ('3468','Ocean Beach','Coastal',1),
        ('3469','Ocean Beach','Coastal',1),
        ('3471','Ocean Beach','Coastal',1),
        ('3480','Ocean Beach','Coastal',1),
        ('3481','Ocean Beach','Coastal',1),
        ('3483','Ocean Beach','Coastal',1),
        ('3491','Ocean Beach','Coastal',1),
        ('3492','Ocean Beach','Coastal',1),
        ('3493','Ocean Beach','Coastal',1),
        ('3494','Ocean Beach','Coastal',1),
        ('3495','Ocean Beach','Coastal',1),
        ('3496','Ocean Beach','Coastal',1),
        ('3497','Ocean Beach','Coastal',1),
        ('3498','Ocean Beach','Coastal',1),
        ('3499','Ocean Beach','Coastal',1),
        ('3500','Ocean Beach','Coastal',1),
        ('3501','Ocean Beach','Coastal',1),
        ('3502','Ocean Beach','Coastal',1),
        ('3503','Ocean Beach','Coastal',1),
        ('3504','Ocean Beach','Coastal',1),
        ('3505','Ocean Beach','Coastal',1),
        ('3506','Ocean Beach','Coastal',1),
        ('3507','Ocean Beach','Coastal',1),
        ('3508','Ocean Beach','Coastal',1),
        ('3509','Ocean Beach','Coastal',1),
        ('3510','Ocean Beach','Coastal',1),
        ('3511','Ocean Beach','Coastal',1),
        ('3512','Ocean Beach','Coastal',1),
        ('3513','Ocean Beach','Coastal',1),
        ('3514','Ocean Beach','Coastal',1),
        ('3515','Ocean Beach','Coastal',1),
        ('3537','Ocean Beach','Coastal',1),
        ('3538','Ocean Beach','Coastal',1),
        ('3539','Ocean Beach','Coastal',1),
        ('3550','Ocean Beach','Coastal',1),
        ('3551','Ocean Beach','Coastal',1),
        ('3552','Ocean Beach','Coastal',1),
        ('3553','Ocean Beach','Coastal',1),
        ('3554','Ocean Beach','Coastal',1),
        ('3555','Ocean Beach','Coastal',1),
        ('3556','Ocean Beach','Coastal',1),
        ('3557','Ocean Beach','Coastal',1),
        ('3558','Ocean Beach','Coastal',1),
        ('3559','Ocean Beach','Coastal',1),
        ('3560','Ocean Beach','Coastal',1),
        ('3561','Ocean Beach','Coastal',1),
        ('3562','Ocean Beach','Coastal',1),
        ('3563','Ocean Beach','Coastal',1),
        ('3564','Ocean Beach','Coastal',1),
        ('3565','Ocean Beach','Coastal',1),
        ('3566','Ocean Beach','Coastal',1),
        ('3567','Ocean Beach','Coastal',1),
        ('3568','Ocean Beach','Coastal',1),
        ('3569','Ocean Beach','Coastal',1),
        ('3570','Ocean Beach','Coastal',1),
        ('3571','Ocean Beach','Coastal',1),
        ('3572','Ocean Beach','Coastal',1),
        ('3573','Ocean Beach','Coastal',1),
        ('3574','Ocean Beach','Coastal',1),
        ('3575','Ocean Beach','Coastal',1),
        ('3576','Ocean Beach','Coastal',1),
        ('3577','Ocean Beach','Coastal',1),
        ('3578','Ocean Beach','Coastal',1),
        ('3579','Ocean Beach','Coastal',1),
        ('3580','Ocean Beach','Coastal',1),
        ('3581','Ocean Beach','Coastal',1),
        ('3582','Ocean Beach','Coastal',1),
        ('3583','Ocean Beach','Coastal',1),
        ('3584','Ocean Beach','Coastal',1),
        ('3585','Ocean Beach','Coastal',1),
        ('3586','Ocean Beach','Coastal',1),
        ('3587','Ocean Beach','Coastal',1),
        ('3588','Ocean Beach','Coastal',1),
        ('3589','Ocean Beach','Coastal',1),
        ('3590','Ocean Beach','Coastal',1),
        ('3591','Ocean Beach','Coastal',1),
        ('3592','Ocean Beach','Coastal',1),
        ('3593','Ocean Beach','Coastal',1),
        ('3594','Ocean Beach','Coastal',1),
        ('3595','Ocean Beach','Coastal',1),
        ('3596','Ocean Beach','Coastal',1),
        ('3597','Ocean Beach','Coastal',1),
        ('3598','Ocean Beach','Coastal',1),
        ('3599','Ocean Beach','Coastal',1),
        ('3600','Ocean Beach','Coastal',1),
        ('3601','Ocean Beach','Coastal',1),
        ('3602','Ocean Beach','Coastal',1),
        ('3603','Ocean Beach','Coastal',1),
        ('3604','Ocean Beach','Coastal',1),
        ('3605','Ocean Beach','Coastal',1),
        ('3606','Ocean Beach','Coastal',1),
        ('3607','Ocean Beach','Coastal',1),
        ('3608','Ocean Beach','Coastal',1),
        ('3609','Ocean Beach','Coastal',1),
        ('3610','Ocean Beach','Coastal',1),
        ('3611','Ocean Beach','Coastal',1),
        ('3612','Ocean Beach','Coastal',1),
        ('3613','Ocean Beach','Coastal',1),
        ('3614','Ocean Beach','Coastal',1),
        ('3615','Ocean Beach','Coastal',1),
        ('3616','Ocean Beach','Coastal',1),
        ('3617','Ocean Beach','Coastal',1),
        ('3618','Ocean Beach','Coastal',1),
        ('3619','Ocean Beach','Coastal',1),
        ('3620','Ocean Beach','Coastal',1),
        ('3621','Ocean Beach','Coastal',1),
        ('3622','Ocean Beach','Coastal',1),
        ('3623','Ocean Beach','Coastal',1),
        ('3624','Ocean Beach','Coastal',1),
        ('3625','Ocean Beach','Coastal',1),
        ('3626','Ocean Beach','Coastal',1),
        ('3627','Ocean Beach','Coastal',1),
        ('3628','Ocean Beach','Coastal',1),
        ('3629','Pacific Beach','Coastal',1),
        ('3631','Pacific Beach','Coastal',1),
        ('3632','Pacific Beach','Coastal',1),
        ('3644','Pacific Beach','Coastal',1),
        ('3645','Pacific Beach','Coastal',1),
        ('3697','Pacific Beach','Coastal',1),
        ('3698','Pacific Beach','Coastal',1),
        ('3699','Pacific Beach','Coastal',1),
        ('3700','Pacific Beach','Coastal',1),
        ('3701','Pacific Beach','Coastal',1),
        ('3702','Pacific Beach','Coastal',1),
        ('3703','Pacific Beach','Coastal',1),
        ('3704','Pacific Beach','Coastal',1),
        ('3713','Pacific Beach','Coastal',1),
        ('3714','Pacific Beach','Coastal',1),
        ('3715','Pacific Beach','Coastal',1),
        ('3716','Pacific Beach','Coastal',1),
        ('3717','Pacific Beach','Coastal',1),
        ('3718','Pacific Beach','Coastal',1),
        ('3719','Pacific Beach','Coastal',1),
        ('3720','Pacific Beach','Coastal',1),
        ('3721','Pacific Beach','Coastal',1),
        ('3722','Pacific Beach','Coastal',1),
        ('3723','Pacific Beach','Coastal',1),
        ('3724','Pacific Beach','Coastal',1),
        ('3725','Pacific Beach','Coastal',1),
        ('3726','Pacific Beach','Coastal',1),
        ('3727','Pacific Beach','Coastal',1),
        ('3728','Pacific Beach','Coastal',1),
        ('3729','Pacific Beach','Coastal',1),
        ('3730','Pacific Beach','Coastal',1),
        ('3731','Pacific Beach','Coastal',1),
        ('3737','Pacific Beach','Coastal',1),
        ('3738','Pacific Beach','Coastal',1),
        ('3739','Pacific Beach','Coastal',1),
        ('3741','Pacific Beach','Coastal',1),
        ('3747','Pacific Beach','Coastal',1),
        ('3748','Pacific Beach','Coastal',1),
        ('3749','Pacific Beach','Coastal',1),
        ('3750','Pacific Beach','Coastal',1),
        ('3751','Pacific Beach','Coastal',1),
        ('3752','Pacific Beach','Coastal',1),
        ('3753','Pacific Beach','Coastal',1),
        ('3754','Pacific Beach','Coastal',1),
        ('3755','Pacific Beach','Coastal',1),
        ('3756','Pacific Beach','Coastal',1),
        ('3757','Pacific Beach','Coastal',1),
        ('3758','Pacific Beach','Coastal',1),
        ('3759','Pacific Beach','Coastal',1),
        ('3760','Pacific Beach','Coastal',1),
        ('3761','Pacific Beach','Coastal',1),
        ('3762','Pacific Beach','Coastal',1),
        ('3763','Pacific Beach','Coastal',1),
        ('3764','Pacific Beach','Coastal',1),
        ('3765','Pacific Beach','Coastal',1),
        ('3766','Pacific Beach','Coastal',1),
        ('3767','Pacific Beach','Coastal',1),
        ('3768','Pacific Beach','Coastal',1),
        ('3769','Pacific Beach','Coastal',1),
        ('3770','Pacific Beach','Coastal',1),
        ('3771','Pacific Beach','Coastal',1),
        ('3772','Pacific Beach','Coastal',1),
        ('3773','Pacific Beach','Coastal',1),
        ('3774','Pacific Beach','Coastal',1),
        ('3775','Pacific Beach','Coastal',1),
        ('3776','Pacific Beach','Coastal',1),
        ('3777','Pacific Beach','Coastal',1),
        ('3778','Pacific Beach','Coastal',1),
        ('3779','Pacific Beach','Coastal',1),
        ('3780','Pacific Beach','Coastal',1),
        ('3781','Pacific Beach','Coastal',1),
        ('3782','Pacific Beach','Coastal',1),
        ('3783','Pacific Beach','Coastal',1),
        ('3786','Pacific Beach','Coastal',1),
        ('3787','Pacific Beach','Coastal',1),
        ('3788','Pacific Beach','Coastal',1),
        ('3789','Pacific Beach','Coastal',1),
        ('3790','Pacific Beach','Coastal',1),
        ('3791','Pacific Beach','Coastal',1),
        ('3792','Pacific Beach','Coastal',1),
        ('3793','Pacific Beach','Coastal',1),
        ('3794','Pacific Beach','Coastal',1),
        ('3795','Pacific Beach','Coastal',1),
        ('3796','Pacific Beach','Coastal',1),
        ('3797','Pacific Beach','Coastal',1),
        ('3798','Pacific Beach','Coastal',1),
        ('3799','Pacific Beach','Coastal',1),
        ('3800','Pacific Beach','Coastal',1),
        ('3801','Pacific Beach','Coastal',1),
        ('3802','Pacific Beach','Coastal',1),
        ('3806','Pacific Beach','Coastal',1),
        ('3807','Pacific Beach','Coastal',1),
        ('3808','Pacific Beach','Coastal',1),
        ('3809','Pacific Beach','Coastal',1),
        ('3810','Pacific Beach','Coastal',1),
        ('3811','Pacific Beach','Coastal',1),
        ('3812','Pacific Beach','Coastal',1),
        ('3813','Pacific Beach','Coastal',1),
        ('3814','Pacific Beach','Coastal',1),
        ('3815','Pacific Beach','Coastal',1),
        ('3816','Pacific Beach','Coastal',1),
        ('3817','Pacific Beach','Coastal',1),
        ('3818','Pacific Beach','Coastal',1),
        ('3819','Pacific Beach','Coastal',1),
        ('3820','Pacific Beach','Coastal',1),
        ('3821','Pacific Beach','Coastal',1),
        ('3822','Pacific Beach','Coastal',1),
        ('3823','Pacific Beach','Coastal',1),
        ('3824','Pacific Beach','Coastal',1),
        ('3825','Pacific Beach','Coastal',1),
        ('3826','Pacific Beach','Coastal',1),
        ('3827','Pacific Beach','Coastal',1),
        ('3828','Pacific Beach','Coastal',1),
        ('3829','Pacific Beach','Coastal',1),
        ('3830','Pacific Beach','Coastal',1),
        ('3831','Pacific Beach','Coastal',1),
        ('3832','Pacific Beach','Coastal',1),
        ('3833','Pacific Beach','Coastal',1),
        ('3834','Pacific Beach','Coastal',1),
        ('3835','Pacific Beach','Coastal',1),
        ('3836','Pacific Beach','Coastal',1),
        ('3837','Pacific Beach','Coastal',1),
        ('3838','Pacific Beach','Coastal',1),
        ('3839','Pacific Beach','Coastal',1),
        ('3840','Pacific Beach','Coastal',1),
        ('3841','Pacific Beach','Coastal',1),
        ('3842','Pacific Beach','Coastal',1),
        ('3843','Pacific Beach','Coastal',1),
        ('3844','Pacific Beach','Coastal',1),
        ('3845','Pacific Beach','Coastal',1),
        ('3846','Pacific Beach','Coastal',1),
        ('3847','Pacific Beach','Coastal',1),
        ('3848','Pacific Beach','Coastal',1),
        ('3849','Pacific Beach','Coastal',1),
        ('3850','Pacific Beach','Coastal',1),
        ('3851','Pacific Beach','Coastal',1),
        ('3852','Pacific Beach','Coastal',1),
        ('3853','Pacific Beach','Coastal',1),
        ('3854','Pacific Beach','Coastal',1),
        ('3855','Pacific Beach','Coastal',1),
        ('3856','Pacific Beach','Coastal',1),
        ('3857','Pacific Beach','Coastal',1),
        ('3858','Pacific Beach','Coastal',1),
        ('3859','Pacific Beach','Coastal',1),
        ('3860','Pacific Beach','Coastal',1),
        ('3861','Pacific Beach','Coastal',1),
        ('3862','Pacific Beach','Coastal',1),
        ('3863','Pacific Beach','Coastal',1),
        ('3864','Pacific Beach','Coastal',1),
        ('3865','Pacific Beach','Coastal',1),
        ('3866','Pacific Beach','Coastal',1),
        ('3867','Pacific Beach','Coastal',1),
        ('3868','Pacific Beach','Coastal',1),
        ('3869','Pacific Beach','Coastal',1),
        ('3870','Pacific Beach','Coastal',1),
        ('3871','Pacific Beach','Coastal',1),
        ('3872','Pacific Beach','Coastal',1),
        ('3873','Pacific Beach','Coastal',1),
        ('3874','Pacific Beach','Coastal',1),
        ('3875','Pacific Beach','Coastal',1),
        ('3876','Pacific Beach','Coastal',1),
        ('3877','Pacific Beach','Coastal',1),
        ('3878','Pacific Beach','Coastal',1),
        ('3879','Pacific Beach','Coastal',1),
        ('3880','Pacific Beach','Coastal',1),
        ('3881','Pacific Beach','Coastal',1),
        ('3882','Pacific Beach','Coastal',1),
        ('3883','Pacific Beach','Coastal',1),
        ('3884','Pacific Beach','Coastal',1),
        ('3885','Pacific Beach','Coastal',1),
        ('3886','Pacific Beach','Coastal',1),
        ('3887','Pacific Beach','Coastal',1),
        ('3888','Pacific Beach','Coastal',1),
        ('3889','Pacific Beach','Coastal',1),
        ('3890','Pacific Beach','Coastal',1),
        ('3891','Pacific Beach','Coastal',1),
        ('3892','Pacific Beach','Coastal',1),
        ('3893','Pacific Beach','Coastal',1),
        ('3894','Pacific Beach','Coastal',1),
        ('3895','Pacific Beach','Coastal',1),
        ('3896','Pacific Beach','Coastal',1),
        ('3897','Pacific Beach','Coastal',1),
        ('3898','Pacific Beach','Coastal',1),
        ('3899','Pacific Beach','Coastal',1),
        ('3900','Pacific Beach','Coastal',1),
        ('3901','Pacific Beach','Coastal',1),
        ('3902','Pacific Beach','Coastal',1),
        ('3903','Pacific Beach','Coastal',1),
        ('3904','Pacific Beach','Coastal',1),
        ('3905','Pacific Beach','Coastal',1),
        ('3906','Pacific Beach','Coastal',1),
        ('3907','Pacific Beach','Coastal',1),
        ('3908','Pacific Beach','Coastal',1),
        ('3909','Pacific Beach','Coastal',1),
        ('3910','Pacific Beach','Coastal',1),
        ('3911','Pacific Beach','Coastal',1),
        ('3912','Pacific Beach','Coastal',1),
        ('3913','Pacific Beach','Coastal',1),
        ('3914','Pacific Beach','Coastal',1),
        ('3915','Pacific Beach','Coastal',1),
        ('3916','Pacific Beach','Coastal',1),
        ('3917','Pacific Beach','Coastal',1),
        ('3918','Pacific Beach','Coastal',1),
        ('3919','Pacific Beach','Coastal',1),
        ('3920','Pacific Beach','Coastal',1),
        ('3921','Pacific Beach','Coastal',1),
        ('3922','Pacific Beach','Coastal',1),
        ('3923','Pacific Beach','Coastal',1),
        ('3924','Pacific Beach','Coastal',1),
        ('3925','Pacific Beach','Coastal',1),
        ('3926','Pacific Beach','Coastal',1),
        ('3927','Pacific Beach','Coastal',1),
        ('3928','Pacific Beach','Coastal',1),
        ('3929','Pacific Beach','Coastal',1),
        ('3930','Pacific Beach','Coastal',1),
        ('3931','Pacific Beach','Coastal',1),
        ('3932','Pacific Beach','Coastal',1),
        ('3933','Pacific Beach','Coastal',1),
        ('3934','Pacific Beach','Coastal',1),
        ('3935','Pacific Beach','Coastal',1),
        ('3936','Pacific Beach','Coastal',1),
        ('3937','Pacific Beach','Coastal',1),
        ('3938','Pacific Beach','Coastal',1),
        ('3939','Pacific Beach','Coastal',1),
        ('3940','Pacific Beach','Coastal',1),
        ('3941','Pacific Beach','Coastal',1),
        ('3944','Pacific Beach','Coastal',1),
        ('3945','Pacific Beach','Coastal',1),
        ('3946','Pacific Beach','Coastal',1),
        ('3954','Pacific Beach','Coastal',1),
        ('3955','Pacific Beach','Coastal',1),
        ('3961','Pacific Beach','Coastal',1),
        ('3966','Pacific Beach','Coastal',1),
        ('3967','Pacific Beach','Coastal',1),
        ('3973','Pacific Beach','Coastal',1),
        ('3974','Pacific Beach','Coastal',1),
        ('3975','Pacific Beach','Coastal',1),
        ('3982','Pacific Beach','Coastal',1),
        ('4001','La Jolla','Coastal',1),
        ('4002','La Jolla','Coastal',1),
        ('4003','La Jolla','Coastal',1),
        ('4004','La Jolla','Coastal',1),
        ('4005','La Jolla','Coastal',1),
        ('4006','La Jolla','Coastal',1),
        ('4007','La Jolla','Coastal',1),
        ('4008','La Jolla','Coastal',1),
        ('4009','La Jolla','Coastal',1),
        ('4010','La Jolla','Coastal',1),
        ('4011','La Jolla','Coastal',1),
        ('4012','La Jolla','Coastal',1),
        ('4013','La Jolla','Coastal',1),
        ('4014','La Jolla','Coastal',1),
        ('4015','La Jolla','Coastal',1),
        ('4016','La Jolla','Coastal',1),
        ('4017','La Jolla','Coastal',1),
        ('4018','La Jolla','Coastal',1),
        ('4019','La Jolla','Coastal',1),
        ('4020','La Jolla','Coastal',1),
        ('4021','La Jolla','Coastal',1),
        ('4028','La Jolla','Coastal',1),
        ('4029','La Jolla','Coastal',1),
        ('4064','La Jolla','Coastal',1),
        ('4065','La Jolla','Coastal',1),
        ('4066','La Jolla','Coastal',1),
        ('4067','La Jolla','Coastal',1),
        ('4068','La Jolla','Coastal',1),
        ('4069','La Jolla','Coastal',1),
        ('4070','La Jolla','Coastal',1),
        ('4071','La Jolla','Coastal',1),
        ('4072','La Jolla','Coastal',1),
        ('4073','La Jolla','Coastal',1),
        ('4074','La Jolla','Coastal',1),
        ('4075','La Jolla','Coastal',1),
        ('4076','La Jolla','Coastal',1),
        ('4077','La Jolla','Coastal',1),
        ('4078','La Jolla','Coastal',1),
        ('4079','La Jolla','Coastal',1),
        ('4080','La Jolla','Coastal',1),
        ('4081','La Jolla','Coastal',1),
        ('4082','La Jolla','Coastal',1),
        ('4083','La Jolla','Coastal',1),
        ('4084','La Jolla','Coastal',1),
        ('4085','La Jolla','Coastal',1),
        ('4086','La Jolla','Coastal',1),
        ('4087','La Jolla','Coastal',1),
        ('4088','La Jolla','Coastal',1),
        ('4089','La Jolla','Coastal',1),
        ('4090','La Jolla','Coastal',1),
        ('4091','La Jolla','Coastal',1),
        ('4092','La Jolla','Coastal',1),
        ('4093','La Jolla','Coastal',1),
        ('4094','La Jolla','Coastal',1),
        ('4095','La Jolla','Coastal',1),
        ('4096','La Jolla','Coastal',1),
        ('4097','La Jolla','Coastal',1),
        ('4098','La Jolla','Coastal',1),
        ('4099','La Jolla','Coastal',1),
        ('4100','La Jolla','Coastal',1),
        ('4101','La Jolla','Coastal',1),
        ('4102','La Jolla','Coastal',1),
        ('4110','Pacific Beach','Coastal',1),
        ('4111','Pacific Beach','Coastal',1),
        ('4128','La Jolla','Coastal',1),
        ('4129','La Jolla','Coastal',1),
        ('4130','La Jolla','Coastal',1),
        ('4131','La Jolla','Coastal',1),
        ('4132','La Jolla','Coastal',1),
        ('4134','La Jolla','Coastal',1),
        ('4135','La Jolla','Coastal',1),
        ('4137','La Jolla','Coastal',1),
        ('4138','La Jolla','Coastal',1),
        ('4140','La Jolla','Coastal',1),
        ('4149','La Jolla','Coastal',1),
        ('4154','La Jolla','Coastal',1),
        ('4170','University Community','Major Employment Center',1),
        ('4171','University Community','Major Employment Center',1),
        ('4172','University Community','Major Employment Center',1),
        ('4173','University Community','Major Employment Center',1),
        ('4174','University Community','Major Employment Center',1),
        ('4175','University Community','Major Employment Center',1),
        ('4176','University Community','Major Employment Center',1),
        ('4177','University Community','Major Employment Center',1),
        ('4178','University Community','Major Employment Center',1),
        ('4179','University Community','Major Employment Center',1),
        ('4180','University Community','Major Employment Center',1),
        ('4181','University Community','Major Employment Center',1),
        ('4182','University Community','Major Employment Center',1),
        ('4183','University Community','Major Employment Center',1),
        ('4184','University Community','Major Employment Center',1),
        ('4185','University Community','Major Employment Center',1),
        ('4186','University Community','Major Employment Center',1),
        ('4295','University Community','Major Employment Center',1),
        ('4296','University Community','Major Employment Center',1),
        ('4297','University Community','Major Employment Center',1),
        ('4298','University Community','Major Employment Center',1),
        ('4300','University Community','Major Employment Center',1),
        ('4301','University Community','Major Employment Center',1),
        ('4306','University Community','Major Employment Center',1),
        ('4307','University Community','Major Employment Center',1),
        ('4308','University Community','Major Employment Center',1),
        ('4309','University Community','Major Employment Center',1),
        ('4310','University Community','Major Employment Center',1),
        ('4311','University Community','Major Employment Center',1),
        ('4312','University Community','Major Employment Center',1),
        ('4313','University Community','Major Employment Center',1),
        ('4324','University Community','Major Employment Center',1),
        ('4331','University Community','Major Employment Center',1),
        ('4346','La Jolla','Coastal',1),
        ('4347','University Community','Major Employment Center',1),
        ('4353','University Community','Major Employment Center',1),
        ('4403','Carmel Valley','Suburban',1),
        ('4404','Carmel Valley','Suburban',1),
        ('4409','Carmel Valley','Suburban',1),
        ('4410','Carmel Valley','Suburban',1),
        ('4415','Carmel Valley','Suburban',1),
        ('4441','Carmel Valley','Suburban',1),
        ('4442','Carmel Valley','Suburban',1),
        ('4443','Carmel Valley','Suburban',1),
        ('4444','Carmel Valley','Suburban',1),
        ('4445','Carmel Valley','Suburban',1),
        ('4446','Carmel Valley','Suburban',1),
        ('4447','Carmel Valley','Suburban',1),
        ('4448','Carmel Valley','Suburban',1),
        ('4449','Carmel Valley','Suburban',1),
        ('4450','Carmel Valley','Suburban',1),
        ('4451','Carmel Valley','Suburban',1),
        ('4452','Carmel Valley','Suburban',1),
        ('4453','Carmel Valley','Suburban',1),
        ('4454','Carmel Valley','Suburban',1),
        ('4455','Carmel Valley','Suburban',1),
        ('4456','Carmel Valley','Suburban',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('4457','Carmel Valley','Suburban',1),
        ('4458','Carmel Valley','Suburban',1),
        ('4459','Carmel Valley','Suburban',1),
        ('4460','Carmel Valley','Suburban',1),
        ('4461','Carmel Valley','Suburban',1),
        ('4462','Carmel Valley','Suburban',1),
        ('4463','Carmel Valley','Suburban',1),
        ('4464','Carmel Valley','Suburban',1),
        ('4465','Carmel Valley','Suburban',1),
        ('4466','Carmel Valley','Suburban',1),
        ('4467','Carmel Valley','Suburban',1),
        ('4468','Carmel Valley','Suburban',1),
        ('4469','Carmel Valley','Suburban',1),
        ('4470','Carmel Valley','Suburban',1),
        ('4471','Carmel Valley','Suburban',1),
        ('4472','Carmel Valley','Suburban',1),
        ('4476','Carmel Valley','Suburban',1),
        ('4477','Carmel Valley','Suburban',1),
        ('4478','Carmel Valley','Suburban',1),
        ('4480','Carmel Valley','Suburban',1),
        ('4482','Carmel Valley','Suburban',1),
        ('4483','Carmel Valley','Suburban',1),
        ('4484','Carmel Valley','Suburban',1),
        ('4485','Carmel Valley','Suburban',1),
        ('4486','Carmel Valley','Suburban',1),
        ('4487','Carmel Valley','Suburban',1),
        ('4488','Carmel Valley','Suburban',1),
        ('4489','Carmel Valley','Suburban',1),
        ('4490','Carmel Valley','Suburban',1),
        ('4491','Carmel Valley','Suburban',1),
        ('4492','Carmel Valley','Suburban',1),
        ('4493','Carmel Valley','Suburban',1),
        ('4494','Carmel Valley','Suburban',1),
        ('4495','Carmel Valley','Suburban',1),
        ('4496','Carmel Valley','Suburban',1),
        ('4497','Carmel Valley','Suburban',1),
        ('4498','Carmel Valley','Suburban',1),
        ('4499','Carmel Valley','Suburban',1),
        ('4504','Carmel Valley','Suburban',1),
        ('4508','Carmel Valley','Suburban',1),
        ('4524','Carmel Valley','Suburban',1),
        ('4525','Carmel Valley','Suburban',1),
        ('4529','Carmel Valley','Suburban',1),
        ('4534','Carmel Valley','Suburban',1),
        ('4536','Carmel Valley','Suburban',1),
        ('4541','Carmel Valley','Suburban',1),
        ('4542','Carmel Valley','Suburban',1),
        ('4543','Carmel Valley','Suburban',1),
        ('4544','Carmel Valley','Suburban',1),
        ('4549','Carmel Valley','Suburban',1),
        ('4630','University Community','Major Employment Center',1),
        ('4632','University Community','Major Employment Center',1),
        ('4634','University Community','Major Employment Center',1),
        ('4635','Sorrento Valley','Major Employment Center',1),
        ('4636','Sorrento Valley','Major Employment Center',1),
        ('4637','Sorrento Valley','Major Employment Center',1),
        ('4638','University Community','Major Employment Center',1),
        ('4639','Sorrento Valley','Major Employment Center',1),
        ('4640','University Community','Major Employment Center',1),
        ('4641','Sorrento Valley','Major Employment Center',1),
        ('4642','Sorrento Valley','Major Employment Center',1),
        ('4643','Sorrento Valley','Major Employment Center',1),
        ('4645','University Community','Major Employment Center',1),
        ('4646','University Community','Major Employment Center',1),
        ('4647','University Community','Major Employment Center',1),
        ('4648','University Community','Major Employment Center',1),
        ('4649','University Community','Major Employment Center',1),
        ('4650','University Community','Major Employment Center',1),
        ('4651','University Community','Major Employment Center',1),
        ('4652','University Community','Major Employment Center',1),
        ('4653','University Community','Major Employment Center',1),
        ('4654','University Community','Major Employment Center',1),
        ('4655','University Community','Major Employment Center',1),
        ('4656','University Community','Major Employment Center',1),
        ('4657','University Community','Major Employment Center',1),
        ('4658','University Community','Major Employment Center',1),
        ('4659','University Community','Major Employment Center',1),
        ('4660','University Community','Major Employment Center',1),
        ('4661','University Community','Major Employment Center',1),
        ('4662','University Community','Major Employment Center',1),
        ('4663','University Community','Major Employment Center',1),
        ('4664','University Community','Major Employment Center',1),
        ('4665','University Community','Major Employment Center',1),
        ('4666','University Community','Major Employment Center',1),
        ('4667','University Community','Major Employment Center',1),
        ('4668','University Community','Major Employment Center',1),
        ('4669','University Community','Major Employment Center',1),
        ('4670','University Community','Major Employment Center',1),
        ('4671','University Community','Major Employment Center',1),
        ('4672','University Community','Major Employment Center',1),
        ('4673','University Community','Major Employment Center',1),
        ('4674','University Community','Major Employment Center',1),
        ('4675','University Community','Major Employment Center',1),
        ('4676','University Community','Major Employment Center',1),
        ('4677','University Community','Major Employment Center',1),
        ('4678','University Community','Major Employment Center',1),
        ('4679','University Community','Major Employment Center',1),
        ('4680','University Community','Major Employment Center',1),
        ('4681','University Community','Major Employment Center',1),
        ('4682','University Community','Major Employment Center',1),
        ('4683','University Community','Major Employment Center',1),
        ('4684','University Community','Major Employment Center',1),
        ('4685','University Community','Major Employment Center',1),
        ('4686','University Community','Major Employment Center',1),
        ('4687','University Community','Major Employment Center',1),
        ('4689','University Community','Major Employment Center',1),
        ('4690','University Community','Major Employment Center',1),
        ('4691','University Community','Major Employment Center',1),
        ('4692','University Community','Major Employment Center',1),
        ('4693','University Community','Major Employment Center',1),
        ('4694','University Community','Major Employment Center',1),
        ('4695','University Community','Major Employment Center',1),
        ('4696','University Community','Major Employment Center',1),
        ('4697','University Community','Major Employment Center',1),
        ('4698','University Community','Major Employment Center',1),
        ('4699','University Community','Major Employment Center',1),
        ('4700','University Community','Major Employment Center',1),
        ('4701','University Community','Major Employment Center',1),
        ('4702','University Community','Major Employment Center',1),
        ('4703','University Community','Major Employment Center',1),
        ('4704','University Community','Major Employment Center',1),
        ('4705','University Community','Major Employment Center',1),
        ('4706','University Community','Major Employment Center',1),
        ('4707','University Community','Major Employment Center',1),
        ('4708','University Community','Major Employment Center',1),
        ('4709','University Community','Major Employment Center',1),
        ('4710','University Community','Major Employment Center',1),
        ('4711','University Community','Major Employment Center',1),
        ('4712','University Community','Major Employment Center',1),
        ('4713','University Community','Major Employment Center',1),
        ('4714','University Community','Major Employment Center',1),
        ('4715','University Community','Major Employment Center',1),
        ('4716','University Community','Major Employment Center',1),
        ('4717','University Community','Major Employment Center',1),
        ('4718','University Community','Major Employment Center',1),
        ('4723','University Community','Major Employment Center',1),
        ('4767','Sorrento Valley','Major Employment Center',1),
        ('4768','Sorrento Valley','Major Employment Center',1),
        ('4769','Sorrento Valley','Major Employment Center',1),
        ('4770','Sorrento Valley','Major Employment Center',1),
        ('4771','Sorrento Valley','Major Employment Center',1),
        ('4772','Sorrento Valley','Major Employment Center',1),
        ('4773','Sorrento Valley','Major Employment Center',1),
        ('4774','Sorrento Valley','Major Employment Center',1),
        ('4775','Sorrento Valley','Major Employment Center',1),
        ('4776','Sorrento Valley','Major Employment Center',1),
        ('4777','Sorrento Valley','Major Employment Center',1),
        ('4778','Sorrento Valley','Major Employment Center',1),
        ('4779','Sorrento Valley','Major Employment Center',1),
        ('4780','Sorrento Valley','Major Employment Center',1),
        ('4781','Sorrento Valley','Major Employment Center',1),
        ('4782','Sorrento Valley','Major Employment Center',1),
        ('4783','Sorrento Valley','Major Employment Center',1),
        ('4784','Sorrento Valley','Major Employment Center',1),
        ('4785','Sorrento Valley','Major Employment Center',1),
        ('4786','Sorrento Valley','Major Employment Center',1),
        ('4787','Sorrento Valley','Major Employment Center',1),
        ('4788','Sorrento Valley','Major Employment Center',1),
        ('4789','Sorrento Valley','Major Employment Center',1),
        ('4790','Sorrento Valley','Major Employment Center',1),
        ('4791','Sorrento Valley','Major Employment Center',1),
        ('4792','Sorrento Valley','Major Employment Center',1),
        ('4793','Sorrento Valley','Major Employment Center',1),
        ('4794','Sorrento Valley','Major Employment Center',1),
        ('4795','Sorrento Valley','Major Employment Center',1),
        ('4796','Sorrento Valley','Major Employment Center',1),
        ('4797','Sorrento Valley','Major Employment Center',1),
        ('4798','Sorrento Valley','Major Employment Center',1),
        ('4799','Sorrento Valley','Major Employment Center',1),
        ('4803','Sorrento Valley','Major Employment Center',1),
        ('4804','Sorrento Valley','Major Employment Center',1),
        ('4805','Sorrento Valley','Major Employment Center',1),
        ('4806','Sorrento Valley','Major Employment Center',1),
        ('4856','Sorrento Valley','Major Employment Center',1),
        ('4859','Sorrento Valley','Major Employment Center',1),
        ('4865','Mira Mesa','Suburban',0),
        ('4870','Mira Mesa','Suburban',0),
        ('4871','Mira Mesa','Suburban',0),
        ('4872','Mira Mesa','Suburban',0),
        ('4875','Mira Mesa','Suburban',0),
        ('4876','Mira Mesa','Suburban',0),
        ('4877','Mira Mesa','Suburban',0),
        ('4878','Sorrento Valley','Major Employment Center',1),
        ('4879','Sorrento Valley','Major Employment Center',1),
        ('4880','Sorrento Valley','Major Employment Center',1),
        ('4881','Sorrento Valley','Major Employment Center',1),
        ('4882','Sorrento Valley','Major Employment Center',1),
        ('4883','Sorrento Valley','Major Employment Center',1),
        ('4884','Sorrento Valley','Major Employment Center',1),
        ('4885','Sorrento Valley','Major Employment Center',1),
        ('4886','Sorrento Valley','Major Employment Center',1),
        ('4887','Sorrento Valley','Major Employment Center',1),
        ('4888','Sorrento Valley','Major Employment Center',1),
        ('4889','Sorrento Valley','Major Employment Center',1),
        ('4890','Sorrento Valley','Major Employment Center',1),
        ('4892','Sorrento Valley','Major Employment Center',1),
        ('4893','Sorrento Valley','Major Employment Center',1),
        ('4894','Sorrento Valley','Major Employment Center',1),
        ('4898','Sorrento Valley','Major Employment Center',1),
        ('4899','Sorrento Valley','Major Employment Center',1),
        ('4903','Sorrento Valley','Major Employment Center',1),
        ('4904','Sorrento Valley','Major Employment Center',1),
        ('4905','Sorrento Valley','Major Employment Center',1),
        ('4906','Sorrento Valley','Major Employment Center',1),
        ('4910','Sorrento Valley','Major Employment Center',1),
        ('4911','Sorrento Valley','Major Employment Center',1),
        ('4912','Sorrento Valley','Major Employment Center',1),
        ('4913','Sorrento Valley','Major Employment Center',1),
        ('4914','Sorrento Valley','Major Employment Center',1),
        ('4919','Sorrento Valley','Major Employment Center',1),
        ('4921','Sorrento Valley','Major Employment Center',1),
        ('4925','Mira Mesa','Suburban',0),
        ('4932','Sorrento Valley','Major Employment Center',1),
        ('4934','Sorrento Valley','Major Employment Center',1),
        ('4935','Mira Mesa','Suburban',0),
        ('4939','Mira Mesa','Suburban',0),
        ('4942','Sorrento Valley','Major Employment Center',1),
        ('4952','Sorrento Valley','Major Employment Center',1),
        ('4953','Sorrento Valley','Major Employment Center',1),
        ('4954','Sorrento Valley','Major Employment Center',1),
        ('4955','Sorrento Valley','Major Employment Center',1),
        ('4956','Sorrento Valley','Major Employment Center',1),
        ('4957','Sorrento Valley','Major Employment Center',1),
        ('4958','Sorrento Valley','Major Employment Center',1),
        ('4959','Sorrento Valley','Major Employment Center',1),
        ('4960','Sorrento Valley','Major Employment Center',1),
        ('4963','Sorrento Valley','Major Employment Center',1),
        ('4964','Sorrento Valley','Major Employment Center',1),
        ('4965','Sorrento Valley','Major Employment Center',1),
        ('4966','Sorrento Valley','Major Employment Center',1),
        ('4967','Sorrento Valley','Major Employment Center',1),
        ('4968','Sorrento Valley','Major Employment Center',1),
        ('4969','Sorrento Valley','Major Employment Center',1),
        ('4970','Sorrento Valley','Major Employment Center',1),
        ('4971','Sorrento Valley','Major Employment Center',1),
        ('4972','Sorrento Valley','Major Employment Center',1),
        ('4973','Sorrento Valley','Major Employment Center',1),
        ('4974','Sorrento Valley','Major Employment Center',1),
        ('4975','Sorrento Valley','Major Employment Center',1),
        ('4976','Sorrento Valley','Major Employment Center',1),
        ('4977','Sorrento Valley','Major Employment Center',1),
        ('4978','Sorrento Valley','Major Employment Center',1),
        ('4979','Sorrento Valley','Major Employment Center',1),
        ('4980','Sorrento Valley','Major Employment Center',1),
        ('4981','Sorrento Valley','Major Employment Center',1),
        ('4984','Sorrento Valley','Major Employment Center',1),
        ('4993','Sorrento Valley','Major Employment Center',1),
        ('4994','Sorrento Valley','Major Employment Center',1),
        ('4995','Mira Mesa','Suburban',0),
        ('4996','Mira Mesa','Suburban',0),
        ('4997','Mira Mesa','Suburban',0),
        ('4999','Mira Mesa','Suburban',0),
        ('5000','Mira Mesa','Suburban',0),
        ('5002','Mira Mesa','Suburban',0),
        ('5005','Mira Mesa','Suburban',0),
        ('5043','Mira Mesa','Suburban',0),
        ('5044','Mira Mesa','Suburban',0),
        ('5064','Mira Mesa','Suburban',0),
        ('5068','Mira Mesa','Suburban',0),
        ('5069','Mira Mesa','Suburban',0),
        ('5070','Mira Mesa','Suburban',0),
        ('5071','Mira Mesa','Suburban',0),
        ('5072','Mira Mesa','Suburban',0),
        ('5073','Mira Mesa','Suburban',0),
        ('5074','Mira Mesa','Suburban',0),
        ('5075','Mira Mesa','Suburban',0),
        ('5076','Mira Mesa','Suburban',0),
        ('5077','Mira Mesa','Suburban',0),
        ('5083','Mira Mesa','Suburban',0),
        ('5084','Mira Mesa','Suburban',0),
        ('5085','Mira Mesa','Suburban',0),
        ('5086','Mira Mesa','Suburban',0),
        ('5087','Mira Mesa','Suburban',0),
        ('5088','Mira Mesa','Suburban',0),
        ('5089','Mira Mesa','Suburban',0),
        ('5090','Mira Mesa','Suburban',0),
        ('5091','Mira Mesa','Suburban',0),
        ('5092','Mira Mesa','Suburban',0),
        ('5093','Mira Mesa','Suburban',0),
        ('5094','Mira Mesa','Suburban',0),
        ('5095','Mira Mesa','Suburban',0),
        ('5096','Mira Mesa','Suburban',0),
        ('5097','Mira Mesa','Suburban',0),
        ('5098','Mira Mesa','Suburban',0),
        ('5099','Mira Mesa','Suburban',0),
        ('5100','Mira Mesa','Suburban',0),
        ('5101','Mira Mesa','Suburban',0),
        ('5102','Mira Mesa','Suburban',0),
        ('5103','Mira Mesa','Suburban',0),
        ('5104','Mira Mesa','Suburban',0),
        ('5105','Mira Mesa','Suburban',0),
        ('5106','Mira Mesa','Suburban',0),
        ('5107','Mira Mesa','Suburban',0),
        ('5108','Mira Mesa','Suburban',0),
        ('5109','Mira Mesa','Suburban',0),
        ('5110','Mira Mesa','Suburban',0),
        ('5111','Mira Mesa','Suburban',0),
        ('5112','Mira Mesa','Suburban',0),
        ('5113','Mira Mesa','Suburban',0),
        ('5114','Mira Mesa','Suburban',0),
        ('5115','Mira Mesa','Suburban',0),
        ('5116','Mira Mesa','Suburban',0),
        ('5117','Mira Mesa','Suburban',0),
        ('5118','Mira Mesa','Suburban',0),
        ('5119','Mira Mesa','Suburban',0),
        ('5120','Mira Mesa','Suburban',0),
        ('5121','Mira Mesa','Suburban',0),
        ('5122','Mira Mesa','Suburban',0),
        ('5123','Mira Mesa','Suburban',0),
        ('5124','Mira Mesa','Suburban',0),
        ('5125','Mira Mesa','Suburban',0),
        ('5126','Mira Mesa','Suburban',0),
        ('5127','Mira Mesa','Suburban',0),
        ('5128','Mira Mesa','Suburban',0),
        ('5129','Mira Mesa','Suburban',0),
        ('5130','Mira Mesa','Suburban',0),
        ('5131','Mira Mesa','Suburban',0),
        ('5132','Mira Mesa','Suburban',0),
        ('5133','Mira Mesa','Suburban',0),
        ('5134','Mira Mesa','Suburban',0),
        ('5135','Mira Mesa','Suburban',0),
        ('5136','Mira Mesa','Suburban',0),
        ('5137','Mira Mesa','Suburban',0),
        ('5138','Mira Mesa','Suburban',0),
        ('5139','Mira Mesa','Suburban',0),
        ('5140','Mira Mesa','Suburban',0),
        ('5141','Mira Mesa','Suburban',0),
        ('5142','Mira Mesa','Suburban',0),
        ('5143','Mira Mesa','Suburban',0),
        ('5144','Mira Mesa','Suburban',0),
        ('5145','Mira Mesa','Suburban',0),
        ('5146','Mira Mesa','Suburban',0),
        ('5147','Mira Mesa','Suburban',0),
        ('5148','Mira Mesa','Suburban',0),
        ('5149','Mira Mesa','Suburban',0),
        ('5150','Mira Mesa','Suburban',0),
        ('5151','Mira Mesa','Suburban',0),
        ('5152','Mira Mesa','Suburban',0),
        ('5154','Mira Mesa','Suburban',0),
        ('5155','Mira Mesa','Suburban',0),
        ('5156','Mira Mesa','Suburban',0),
        ('5157','Mira Mesa','Suburban',0),
        ('5158','Mira Mesa','Suburban',0),
        ('5159','Mira Mesa','Suburban',0),
        ('5160','Mira Mesa','Suburban',0),
        ('5161','Mira Mesa','Suburban',0),
        ('5162','Mira Mesa','Suburban',0),
        ('5163','Mira Mesa','Suburban',0),
        ('5164','Mira Mesa','Suburban',0),
        ('5165','Mira Mesa','Suburban',0),
        ('5166','Mira Mesa','Suburban',0),
        ('5167','Mira Mesa','Suburban',0),
        ('5168','Mira Mesa','Suburban',0),
        ('5169','Mira Mesa','Suburban',0),
        ('5171','Mira Mesa','Suburban',0),
        ('5172','Mira Mesa','Suburban',0),
        ('5173','Mira Mesa','Suburban',0),
        ('5174','Mira Mesa','Suburban',0),
        ('5175','Mira Mesa','Suburban',0),
        ('5176','Mira Mesa','Suburban',0),
        ('5177','Mira Mesa','Suburban',0),
        ('5178','Mira Mesa','Suburban',0),
        ('5179','University Community','Major Employment Center',1),
        ('5180','University Community','Major Employment Center',1),
        ('5181','University Community','Major Employment Center',1),
        ('5182','University Community','Major Employment Center',1),
        ('5183','University Community','Major Employment Center',1),
        ('5184','University Community','Major Employment Center',1),
        ('5185','University Community','Major Employment Center',1),
        ('5186','University Community','Major Employment Center',1),
        ('5187','University Community','Major Employment Center',1),
        ('5189','University Community','Major Employment Center',1),
        ('5193','University Community','Major Employment Center',1),
        ('5194','University Community','Major Employment Center',1),
        ('5195','University Community','Major Employment Center',1),
        ('5196','University Community','Major Employment Center',1),
        ('5197','University Community','Major Employment Center',1),
        ('5198','University Community','Major Employment Center',1),
        ('5201','University Community','Major Employment Center',1),
        ('5202','University Community','Major Employment Center',1),
        ('5203','University Community','Major Employment Center',1),
        ('5205','University Community','Major Employment Center',1),
        ('5206','University Community','Major Employment Center',1),
        ('5207','University Community','Major Employment Center',1),
        ('5328','Pacific Beach','Coastal',1),
        ('5343','Pacific Beach','Coastal',1),
        ('5505','Kearny Mesa','Major Employment Center',1),
        ('5509','Kearny Mesa','Major Employment Center',1),
        ('5510','Kearny Mesa','Major Employment Center',1),
        ('5511','Kearny Mesa','Major Employment Center',1),
        ('5512','Kearny Mesa','Major Employment Center',1),
        ('5514','Kearny Mesa','Major Employment Center',1),
        ('5536','Kearny Mesa','Major Employment Center',1),
        ('5537','Kearny Mesa','Major Employment Center',1),
        ('5538','Kearny Mesa','Major Employment Center',1),
        ('5540','Kearny Mesa','Major Employment Center',1),
        ('5542','Kearny Mesa','Major Employment Center',1),
        ('5555','Kearny Mesa','Major Employment Center',1),
        ('5562','Kearny Mesa','Major Employment Center',1),
        ('5563','Kearny Mesa','Major Employment Center',1),
        ('5564','Kearny Mesa','Major Employment Center',1),
        ('5565','Kearny Mesa','Major Employment Center',1),
        ('5566','Kearny Mesa','Major Employment Center',1),
        ('5567','Kearny Mesa','Major Employment Center',1),
        ('5568','Kearny Mesa','Major Employment Center',1),
        ('5570','Kearny Mesa','Major Employment Center',1),
        ('5571','Kearny Mesa','Major Employment Center',1),
        ('5573','Kearny Mesa','Major Employment Center',1),
        ('5575','Kearny Mesa','Major Employment Center',1),
        ('5576','Kearny Mesa','Major Employment Center',1),
        ('5577','Kearny Mesa','Major Employment Center',1),
        ('5578','Kearny Mesa','Major Employment Center',1),
        ('5579','Kearny Mesa','Major Employment Center',1),
        ('5580','Kearny Mesa','Major Employment Center',1),
        ('5581','Kearny Mesa','Major Employment Center',1),
        ('5583','Kearny Mesa','Major Employment Center',1),
        ('5584','Kearny Mesa','Major Employment Center',1),
        ('5585','Kearny Mesa','Major Employment Center',1),
        ('5586','Kearny Mesa','Major Employment Center',1),
        ('5587','Kearny Mesa','Major Employment Center',1),
        ('5588','Kearny Mesa','Major Employment Center',1),
        ('5589','Kearny Mesa','Major Employment Center',1),
        ('5590','Kearny Mesa','Major Employment Center',1),
        ('5591','Kearny Mesa','Major Employment Center',1),
        ('5592','Kearny Mesa','Major Employment Center',1),
        ('5593','Kearny Mesa','Major Employment Center',1),
        ('5594','Kearny Mesa','Major Employment Center',1),
        ('5595','Kearny Mesa','Major Employment Center',1),
        ('5596','Kearny Mesa','Major Employment Center',1),
        ('5597','Kearny Mesa','Major Employment Center',1),
        ('5598','Kearny Mesa','Major Employment Center',1),
        ('5599','Kearny Mesa','Major Employment Center',1),
        ('5600','Kearny Mesa','Major Employment Center',1),
        ('5601','Kearny Mesa','Major Employment Center',1),
        ('5602','Kearny Mesa','Major Employment Center',1),
        ('5603','Kearny Mesa','Major Employment Center',1),
        ('5604','Kearny Mesa','Major Employment Center',1),
        ('5605','Kearny Mesa','Major Employment Center',1),
        ('5606','Kearny Mesa','Major Employment Center',1),
        ('5607','Kearny Mesa','Major Employment Center',1),
        ('5608','Kearny Mesa','Major Employment Center',1),
        ('5609','Kearny Mesa','Major Employment Center',1),
        ('5610','Kearny Mesa','Major Employment Center',1),
        ('5611','Kearny Mesa','Major Employment Center',1),
        ('5612','Kearny Mesa','Major Employment Center',1),
        ('5613','Kearny Mesa','Major Employment Center',1),
        ('5614','Kearny Mesa','Major Employment Center',1),
        ('5615','Kearny Mesa','Major Employment Center',1),
        ('5616','Kearny Mesa','Major Employment Center',1),
        ('5617','Kearny Mesa','Major Employment Center',1),
        ('5618','Kearny Mesa','Major Employment Center',1),
        ('5619','Kearny Mesa','Major Employment Center',1),
        ('5620','Kearny Mesa','Major Employment Center',1),
        ('5621','Kearny Mesa','Major Employment Center',1),
        ('5622','Kearny Mesa','Major Employment Center',1),
        ('5623','Kearny Mesa','Major Employment Center',1),
        ('5624','Kearny Mesa','Major Employment Center',1),
        ('5625','Kearny Mesa','Major Employment Center',1),
        ('5626','Kearny Mesa','Major Employment Center',1),
        ('5627','Kearny Mesa','Major Employment Center',1),
        ('5628','Kearny Mesa','Major Employment Center',1),
        ('5629','Kearny Mesa','Major Employment Center',1),
        ('5630','Kearny Mesa','Major Employment Center',1),
        ('5631','Kearny Mesa','Major Employment Center',1),
        ('5632','Kearny Mesa','Major Employment Center',1),
        ('5633','Kearny Mesa','Major Employment Center',1),
        ('5634','Kearny Mesa','Major Employment Center',1),
        ('5635','Kearny Mesa','Major Employment Center',1),
        ('5636','Kearny Mesa','Major Employment Center',1),
        ('5637','Kearny Mesa','Major Employment Center',1),
        ('5638','Kearny Mesa','Major Employment Center',1),
        ('5639','Kearny Mesa','Major Employment Center',1),
        ('5640','Kearny Mesa','Major Employment Center',1),
        ('5641','Kearny Mesa','Major Employment Center',1),
        ('5642','Kearny Mesa','Major Employment Center',1),
        ('5643','Kearny Mesa','Major Employment Center',1),
        ('5644','Kearny Mesa','Major Employment Center',1),
        ('5645','Kearny Mesa','Major Employment Center',1),
        ('5646','Kearny Mesa','Major Employment Center',1),
        ('5647','Kearny Mesa','Major Employment Center',1),
        ('5648','Kearny Mesa','Major Employment Center',1),
        ('5649','Kearny Mesa','Major Employment Center',1),
        ('5650','Kearny Mesa','Major Employment Center',1),
        ('5651','Kearny Mesa','Major Employment Center',1),
        ('5652','Kearny Mesa','Major Employment Center',1),
        ('5653','Kearny Mesa','Major Employment Center',1),
        ('5654','Kearny Mesa','Major Employment Center',1),
        ('5655','Kearny Mesa','Major Employment Center',1),
        ('5656','Kearny Mesa','Major Employment Center',1),
        ('5657','Kearny Mesa','Major Employment Center',1),
        ('5658','Kearny Mesa','Major Employment Center',1),
        ('5659','Kearny Mesa','Major Employment Center',1),
        ('5660','Kearny Mesa','Major Employment Center',1),
        ('5661','Kearny Mesa','Major Employment Center',1),
        ('5662','Kearny Mesa','Major Employment Center',1),
        ('5663','Kearny Mesa','Major Employment Center',1),
        ('5664','Kearny Mesa','Major Employment Center',1),
        ('5665','Kearny Mesa','Major Employment Center',1),
        ('5666','Kearny Mesa','Major Employment Center',1),
        ('5667','Kearny Mesa','Major Employment Center',1),
        ('5668','Kearny Mesa','Major Employment Center',1),
        ('5669','Kearny Mesa','Major Employment Center',1),
        ('5670','Kearny Mesa','Major Employment Center',1),
        ('5671','Kearny Mesa','Major Employment Center',1),
        ('5672','Kearny Mesa','Major Employment Center',1),
        ('5673','Kearny Mesa','Major Employment Center',1),
        ('5674','Kearny Mesa','Major Employment Center',1),
        ('5675','Kearny Mesa','Major Employment Center',1),
        ('5676','Kearny Mesa','Major Employment Center',1),
        ('5677','Kearny Mesa','Major Employment Center',1),
        ('5678','Kearny Mesa','Major Employment Center',1),
        ('5679','Kearny Mesa','Major Employment Center',1),
        ('5680','Kearny Mesa','Major Employment Center',1),
        ('5681','Kearny Mesa','Major Employment Center',1),
        ('5682','Kearny Mesa','Major Employment Center',1),
        ('5683','Kearny Mesa','Major Employment Center',1),
        ('5684','Kearny Mesa','Major Employment Center',1),
        ('5685','Kearny Mesa','Major Employment Center',1),
        ('5686','Kearny Mesa','Major Employment Center',1),
        ('5687','Kearny Mesa','Major Employment Center',1),
        ('5688','Kearny Mesa','Major Employment Center',1),
        ('5689','Kearny Mesa','Major Employment Center',1),
        ('5690','Kearny Mesa','Major Employment Center',1),
        ('5691','Kearny Mesa','Major Employment Center',1),
        ('5771','Kearny Mesa','Major Employment Center',1),
        ('5776','Kearny Mesa','Major Employment Center',1),
        ('5777','Kearny Mesa','Major Employment Center',1),
        ('5782','Kearny Mesa','Major Employment Center',1),
        ('5783','Kearny Mesa','Major Employment Center',1),
        ('5784','Kearny Mesa','Major Employment Center',1),
        ('5785','Kearny Mesa','Major Employment Center',1),
        ('5791','Mission Valley','Major Employment Center',1),
        ('5792','Mission Valley','Major Employment Center',1),
        ('5793','Mission Valley','Major Employment Center',1),
        ('5794','Mission Valley','Major Employment Center',1),
        ('5795','Mission Valley','Major Employment Center',1),
        ('5796','Mission Valley','Major Employment Center',1),
        ('5804','Kearny Mesa','Major Employment Center',1),
        ('5825','Mission Valley','Major Employment Center',1),
        ('5838','Mission Valley','Major Employment Center',1),
        ('5839','Mission Valley','Major Employment Center',1),
        ('5841','Mission Valley','Major Employment Center',1),
        ('5842','Mission Valley','Major Employment Center',1),
        ('5843','Mission Valley','Major Employment Center',1),
        ('5844','Mission Valley','Major Employment Center',1),
        ('5845','Mission Valley','Major Employment Center',1),
        ('5846','Mission Valley','Major Employment Center',1),
        ('5847','Mission Valley','Major Employment Center',1),
        ('5848','Mission Valley','Major Employment Center',1),
        ('5849','Mission Valley','Major Employment Center',1),
        ('5850','Mission Valley','Major Employment Center',1),
        ('5851','Mission Valley','Major Employment Center',1),
        ('5852','Mission Valley','Major Employment Center',1),
        ('5853','Mission Valley','Major Employment Center',1),
        ('5854','Mission Valley','Major Employment Center',1),
        ('5855','Mission Valley','Major Employment Center',1),
        ('5856','Mission Valley','Major Employment Center',1),
        ('5857','Mission Valley','Major Employment Center',1),
        ('5858','Mission Valley','Major Employment Center',1),
        ('5859','Mission Valley','Major Employment Center',1),
        ('5860','Mission Valley','Major Employment Center',1),
        ('5861','Mission Valley','Major Employment Center',1),
        ('5862','Mission Valley','Major Employment Center',1),
        ('5863','Mission Valley','Major Employment Center',1),
        ('5864','Mission Valley','Major Employment Center',1),
        ('5865','Mission Valley','Major Employment Center',1),
        ('5866','Mission Valley','Major Employment Center',1),
        ('5867','Mission Valley','Major Employment Center',1),
        ('5868','Mission Valley','Major Employment Center',1),
        ('5869','Mission Valley','Major Employment Center',1),
        ('5870','Mission Valley','Major Employment Center',1),
        ('5871','Mission Valley','Major Employment Center',1),
        ('5872','Mission Valley','Major Employment Center',1),
        ('5873','Mission Valley','Major Employment Center',1),
        ('5874','Mission Valley','Major Employment Center',1),
        ('5875','Mission Valley','Major Employment Center',1),
        ('5876','Mission Valley','Major Employment Center',1),
        ('5877','Mission Valley','Major Employment Center',1),
        ('5878','Mission Valley','Major Employment Center',1),
        ('5879','Mission Valley','Major Employment Center',1),
        ('5880','Mission Valley','Major Employment Center',1),
        ('5881','Mission Valley','Major Employment Center',1),
        ('5882','Mission Valley','Major Employment Center',1),
        ('5890','Mission Valley','Major Employment Center',1),
        ('5897','Mission Valley','Major Employment Center',1),
        ('5901','Pacific Beach','Coastal',1),
        ('5905','Pacific Beach','Coastal',1),
        ('5932','Pacific Beach','Coastal',1),
        ('5933','Pacific Beach','Coastal',1),
        ('5934','Pacific Beach','Coastal',1),
        ('5936','Pacific Beach','Coastal',1),
        ('5937','Pacific Beach','Coastal',1),
        ('5938','Pacific Beach','Coastal',1),
        ('5983','Mission Valley','Major Employment Center',1),
        ('5984','Mission Valley','Major Employment Center',1),
        ('5986','Mission Valley','Major Employment Center',1),
        ('5987','Mission Valley','Major Employment Center',1),
        ('5988','Mission Valley','Major Employment Center',1),
        ('5991','Mission Valley','Major Employment Center',1),
        ('5992','Mission Valley','Major Employment Center',1),
        ('5993','Mission Valley','Major Employment Center',1),
        ('5994','Mission Valley','Major Employment Center',1),
        ('5995','Mission Valley','Major Employment Center',1),
        ('5997','Mission Valley','Major Employment Center',1),
        ('5998','Mission Valley','Major Employment Center',1),
        ('5999','Mission Valley','Major Employment Center',1),
        ('6000','Mission Valley','Major Employment Center',1),
        ('6001','Mission Valley','Major Employment Center',1),
        ('6003','Mission Valley','Major Employment Center',1),
        ('6004','Mission Valley','Major Employment Center',1),
        ('6005','Mission Valley','Major Employment Center',1),
        ('6006','Mission Valley','Major Employment Center',1),
        ('6007','Mission Valley','Major Employment Center',1),
        ('6008','Mission Valley','Major Employment Center',1),
        ('6009','Mission Valley','Major Employment Center',1),
        ('6010','Mission Valley','Major Employment Center',1),
        ('6011','Mission Valley','Major Employment Center',1),
        ('6012','Mission Valley','Major Employment Center',1),
        ('6013','Mission Valley','Major Employment Center',1),
        ('6014','Mission Valley','Major Employment Center',1),
        ('6015','Mission Valley','Major Employment Center',1),
        ('6023','Mission Valley','Major Employment Center',1),
        ('6026','Mission Valley','Major Employment Center',1),
        ('6028','Mission Valley','Major Employment Center',1),
        ('6029','Mission Valley','Major Employment Center',1),
        ('6030','Mission Valley','Major Employment Center',1),
        ('6031','Mission Valley','Major Employment Center',1),
        ('6032','Mission Valley','Major Employment Center',1),
        ('6033','Mission Valley','Major Employment Center',1),
        ('6034','Mission Valley','Major Employment Center',1),
        ('6035','Mission Valley','Major Employment Center',1),
        ('6036','Mission Valley','Major Employment Center',1),
        ('6037','Mission Valley','Major Employment Center',1),
        ('6038','Mission Valley','Major Employment Center',1),
        ('6039','Mission Valley','Major Employment Center',1),
        ('6040','Mission Valley','Major Employment Center',1),
        ('6041','Mission Valley','Major Employment Center',1),
        ('6042','Mission Valley','Major Employment Center',1),
        ('6043','Mission Valley','Major Employment Center',1),
        ('6044','Mission Valley','Major Employment Center',1),
        ('6045','Mission Valley','Major Employment Center',1),
        ('6046','Mission Valley','Major Employment Center',1),
        ('6047','Mission Valley','Major Employment Center',1),
        ('6048','Mission Valley','Major Employment Center',1),
        ('6049','Mission Valley','Major Employment Center',1),
        ('6050','Mission Valley','Major Employment Center',1),
        ('6051','Mission Valley','Major Employment Center',1),
        ('6052','Mission Valley','Major Employment Center',1),
        ('6053','Mission Valley','Major Employment Center',1),
        ('6054','Mission Valley','Major Employment Center',1),
        ('6055','Mission Valley','Major Employment Center',1),
        ('6056','Mission Valley','Major Employment Center',1),
        ('6057','Mission Valley','Major Employment Center',1),
        ('6058','Mission Valley','Major Employment Center',1),
        ('6059','Mission Valley','Major Employment Center',1),
        ('6060','Mission Valley','Major Employment Center',1),
        ('6061','Mission Valley','Major Employment Center',1),
        ('6062','Mission Valley','Major Employment Center',1),
        ('6063','Mission Valley','Major Employment Center',1),
        ('6064','Mission Valley','Major Employment Center',1),
        ('6065','Mission Valley','Major Employment Center',1),
        ('6066','Mission Valley','Major Employment Center',1),
        ('6067','Mission Valley','Major Employment Center',1),
        ('6068','Mission Valley','Major Employment Center',1),
        ('6069','Mission Valley','Major Employment Center',1),
        ('6070','Mission Valley','Major Employment Center',1),
        ('6071','Mission Valley','Major Employment Center',1),
        ('6072','Mission Valley','Major Employment Center',1),
        ('6073','Mission Valley','Major Employment Center',1),
        ('6074','Mission Valley','Major Employment Center',1),
        ('6075','Mission Valley','Major Employment Center',1),
        ('6076','Mission Valley','Major Employment Center',1),
        ('6077','Mission Valley','Major Employment Center',1),
        ('6078','Mission Valley','Major Employment Center',1),
        ('6079','Mission Valley','Major Employment Center',1),
        ('6080','Mission Valley','Major Employment Center',1),
        ('6081','Mission Valley','Major Employment Center',1),
        ('6082','Mission Valley','Major Employment Center',1),
        ('6083','Mission Valley','Major Employment Center',1),
        ('6084','Kearny Mesa','Major Employment Center',1),
        ('6085','Kearny Mesa','Major Employment Center',1),
        ('6086','Kearny Mesa','Major Employment Center',1),
        ('6087','Kearny Mesa','Major Employment Center',1),
        ('6088','Kearny Mesa','Major Employment Center',1),
        ('6089','Kearny Mesa','Major Employment Center',1),
        ('6090','Kearny Mesa','Major Employment Center',1),
        ('6091','Kearny Mesa','Major Employment Center',1),
        ('6092','Kearny Mesa','Major Employment Center',1),
        ('6093','Kearny Mesa','Major Employment Center',1),
        ('6094','Kearny Mesa','Major Employment Center',1),
        ('6099','Kearny Mesa','Major Employment Center',1),
        ('6100','Kearny Mesa','Major Employment Center',1),
        ('6101','Kearny Mesa','Major Employment Center',1),
        ('6102','Mission Valley','Major Employment Center',1),
        ('6103','Mission Valley','Major Employment Center',1),
        ('6104','Mission Valley','Major Employment Center',1),
        ('6105','Mission Valley','Major Employment Center',1),
        ('6106','Mission Valley','Major Employment Center',1),
        ('6107','Mission Valley','Major Employment Center',1),
        ('6108','Mission Valley','Major Employment Center',1),
        ('6109','Mission Valley','Major Employment Center',1),
        ('6110','Mission Valley','Major Employment Center',1),
        ('6111','Mission Valley','Major Employment Center',1),
        ('6112','Mission Valley','Major Employment Center',1),
        ('6120','Mission Valley','Major Employment Center',1),
        ('6121','Mission Valley','Major Employment Center',1),
        ('6123','Mission Valley','Major Employment Center',1),
        ('6124','Kearny Mesa','Major Employment Center',1),
        ('6125','Kearny Mesa','Major Employment Center',1),
        ('6126','Kearny Mesa','Major Employment Center',1),
        ('6127','Kearny Mesa','Major Employment Center',1),
        ('6139','Kearny Mesa','Major Employment Center',1),
        ('6140','Kearny Mesa','Major Employment Center',1),
        ('6141','Kearny Mesa','Major Employment Center',1),
        ('6142','Kearny Mesa','Major Employment Center',1),
        ('6143','Kearny Mesa','Major Employment Center',1),
        ('6144','Kearny Mesa','Major Employment Center',1),
        ('6145','Kearny Mesa','Major Employment Center',1),
        ('6151','Kearny Mesa','Major Employment Center',1),
        ('6152','Kearny Mesa','Major Employment Center',1),
        ('6153','Kearny Mesa','Major Employment Center',1),
        ('6154','Kearny Mesa','Major Employment Center',1),
        ('6155','Kearny Mesa','Major Employment Center',1),
        ('6156','Kearny Mesa','Major Employment Center',1),
        ('6157','Kearny Mesa','Major Employment Center',1),
        ('6158','Kearny Mesa','Major Employment Center',1),
        ('6159','Kearny Mesa','Major Employment Center',1),
        ('6160','Kearny Mesa','Major Employment Center',1),
        ('6161','Kearny Mesa','Major Employment Center',1),
        ('6162','Kearny Mesa','Major Employment Center',1),
        ('6163','Mission Valley','Major Employment Center',1),
        ('6164','Mission Valley','Major Employment Center',1),
        ('6165','Mission Valley','Major Employment Center',1),
        ('6166','Mission Valley','Major Employment Center',1),
        ('6167','Mission Valley','Major Employment Center',1),
        ('6168','Mission Valley','Major Employment Center',1),
        ('6169','Mission Valley','Major Employment Center',1),
        ('6170','Mission Valley','Major Employment Center',1),
        ('6171','Mission Valley','Major Employment Center',1),
        ('6172','Mission Valley','Major Employment Center',1),
        ('6173','Mission Valley','Major Employment Center',1),
        ('6174','Mission Valley','Major Employment Center',1),
        ('6175','Mission Valley','Major Employment Center',1),
        ('6176','Mission Valley','Major Employment Center',1),
        ('6177','Mission Valley','Major Employment Center',1),
        ('6178','Mission Valley','Major Employment Center',1),
        ('6179','Mission Valley','Major Employment Center',1),
        ('6180','Mission Valley','Major Employment Center',1),
        ('6181','Mission Valley','Major Employment Center',1),
        ('6182','Mission Valley','Major Employment Center',1),
        ('6183','Mission Valley','Major Employment Center',1),
        ('6184','Mission Valley','Major Employment Center',1),
        ('6185','Mission Valley','Major Employment Center',1),
        ('6186','Mission Valley','Major Employment Center',1),
        ('6187','Mission Valley','Major Employment Center',1),
        ('6188','Mission Valley','Major Employment Center',1),
        ('6189','Mission Valley','Major Employment Center',1),
        ('6190','Mission Valley','Major Employment Center',1),
        ('6191','Mission Valley','Major Employment Center',1),
        ('6192','Mission Valley','Major Employment Center',1),
        ('6193','Mission Valley','Major Employment Center',1),
        ('6194','Mission Valley','Major Employment Center',1),
        ('6195','Mission Valley','Major Employment Center',1),
        ('6196','Mission Valley','Major Employment Center',1),
        ('6197','Mission Valley','Major Employment Center',1),
        ('6198','Mission Valley','Major Employment Center',1),
        ('6199','Mission Valley','Major Employment Center',1),
        ('6200','Mission Valley','Major Employment Center',1),
        ('6201','Mission Valley','Major Employment Center',1),
        ('6202','Mission Valley','Major Employment Center',1),
        ('6203','Mission Valley','Major Employment Center',1),
        ('6226','Kearny Mesa','Major Employment Center',1),
        ('6227','Kearny Mesa','Major Employment Center',1),
        ('6228','Kearny Mesa','Major Employment Center',1),
        ('6229','Kearny Mesa','Major Employment Center',1),
        ('6237','Kearny Mesa','Major Employment Center',1),
        ('6238','Kearny Mesa','Major Employment Center',1),
        ('6243','Kearny Mesa','Major Employment Center',1),
        ('6255','Kearny Mesa','Major Employment Center',1),
        ('6256','Kearny Mesa','Major Employment Center',1),
        ('6257','Kearny Mesa','Major Employment Center',1),
        ('6258','Kearny Mesa','Major Employment Center',1),
        ('6259','Kearny Mesa','Major Employment Center',1),
        ('6260','Kearny Mesa','Major Employment Center',1),
        ('6261','Kearny Mesa','Major Employment Center',1),
        ('6268','Sorrento Valley','Major Employment Center',1),
        ('6269','Sorrento Valley','Major Employment Center',1),
        ('6406','Mission Valley','Major Employment Center',1),
        ('6469','Mission Valley','Major Employment Center',1),
        ('6470','Mission Valley','Major Employment Center',1),
        ('6471','Mission Valley','Major Employment Center',1),
        ('6472','Mission Valley','Major Employment Center',1),
        ('6473','Mission Valley','Major Employment Center',1),
        ('6474','Mission Valley','Major Employment Center',1),
        ('6475','Mission Valley','Major Employment Center',1),
        ('6476','Mission Valley','Major Employment Center',1),
        ('6477','Mission Valley','Major Employment Center',1),
        ('6478','Mission Valley','Major Employment Center',1),
        ('6479','Mission Valley','Major Employment Center',1),
        ('6480','Mission Valley','Major Employment Center',1),
        ('6481','Mission Valley','Major Employment Center',1),
        ('6482','Mission Valley','Major Employment Center',1),
        ('6483','Mission Valley','Major Employment Center',1),
        ('6484','Mission Valley','Major Employment Center',1),
        ('6485','Mission Valley','Major Employment Center',1),
        ('6486','Mission Valley','Major Employment Center',1),
        ('6487','Mission Valley','Major Employment Center',1),
        ('6488','Mission Valley','Major Employment Center',1),
        ('6489','Mission Valley','Major Employment Center',1),
        ('6490','Mission Valley','Major Employment Center',1),
        ('6491','Mission Valley','Major Employment Center',1),
        ('6492','Mission Valley','Major Employment Center',1),
        ('6493','Mission Valley','Major Employment Center',1),
        ('6494','Mission Valley','Major Employment Center',1),
        ('6506','Mission Valley','Major Employment Center',1),
        ('6508','Mission Valley','Major Employment Center',1),
        ('6509','Mission Valley','Major Employment Center',1),
        ('6510','Mission Valley','Major Employment Center',1),
        ('6513','Mission Valley','Major Employment Center',1),
        ('6514','Mission Valley','Major Employment Center',1),
        ('6515','Mission Valley','Major Employment Center',1),
        ('6518','Mission Valley','Major Employment Center',1),
        ('6519','Mission Valley','Major Employment Center',1),
        ('6520','Mission Valley','Major Employment Center',1),
        ('6522','Mission Valley','Major Employment Center',1),
        ('6523','Mission Valley','Major Employment Center',1),
        ('6524','Mission Valley','Major Employment Center',1),
        ('6525','Mission Valley','Major Employment Center',1),
        ('6526','Mission Valley','Major Employment Center',1),
        ('6527','Mission Valley','Major Employment Center',1),
        ('6528','Mission Valley','Major Employment Center',1),
        ('6529','Mission Valley','Major Employment Center',1),
        ('6788','Urban Core','Urban',1),
        ('6811','Southwest Chula Vista','Suburban',0),
        ('6841','US-Mexico Border','Gateway',1),
        ('6842','US-Mexico Border','Gateway',1),
        ('6843','US-Mexico Border','Gateway',1),
        ('6844','US-Mexico Border','Gateway',1),
        ('6845','US-Mexico Border','Gateway',1),
        ('6846','US-Mexico Border','Gateway',1),
        ('6847','US-Mexico Border','Gateway',1),
        ('6848','US-Mexico Border','Gateway',1),
        ('6849','US-Mexico Border','Gateway',1),
        ('6850','US-Mexico Border','Gateway',1),
        ('6851','US-Mexico Border','Gateway',1),
        ('6852','US-Mexico Border','Gateway',1),
        ('6853','US-Mexico Border','Gateway',1),
        ('6854','US-Mexico Border','Gateway',1),
        ('6857','US-Mexico Border','Gateway',1),
        ('6858','US-Mexico Border','Gateway',1),
        ('6860','US-Mexico Border','Gateway',1),
        ('6861','US-Mexico Border','Gateway',1),
        ('6862','US-Mexico Border','Gateway',1),
        ('6863','US-Mexico Border','Gateway',1),
        ('6864','US-Mexico Border','Gateway',1),
        ('6865','US-Mexico Border','Gateway',1),
        ('6866','US-Mexico Border','Gateway',1),
        ('6867','US-Mexico Border','Gateway',1),
        ('6896','US-Mexico Border','Gateway',1),
        ('6897','US-Mexico Border','Gateway',1),
        ('6898','US-Mexico Border','Gateway',1),
        ('6899','US-Mexico Border','Gateway',1),
        ('6900','US-Mexico Border','Gateway',1),
        ('6901','US-Mexico Border','Gateway',1),
        ('6902','US-Mexico Border','Gateway',1),
        ('6903','US-Mexico Border','Gateway',1),
        ('6904','US-Mexico Border','Gateway',1),
        ('6905','US-Mexico Border','Gateway',1),
        ('6906','US-Mexico Border','Gateway',1),
        ('6907','US-Mexico Border','Gateway',1),
        ('6908','US-Mexico Border','Gateway',1),
        ('6909','US-Mexico Border','Gateway',1),
        ('6910','US-Mexico Border','Gateway',1),
        ('6911','US-Mexico Border','Gateway',1),
        ('6912','US-Mexico Border','Gateway',1),
        ('6913','US-Mexico Border','Gateway',1),
        ('6914','US-Mexico Border','Gateway',1),
        ('6915','US-Mexico Border','Gateway',1),
        ('6916','US-Mexico Border','Gateway',1),
        ('6917','US-Mexico Border','Gateway',1),
        ('6931','US-Mexico Border','Gateway',1),
        ('6932','US-Mexico Border','Gateway',1),
        ('6941','US-Mexico Border','Gateway',1),
        ('6942','US-Mexico Border','Gateway',1),
        ('6947','US-Mexico Border','Gateway',1),
        ('6950','US-Mexico Border','Gateway',1),
        ('6951','US-Mexico Border','Gateway',1),
        ('6970','US-Mexico Border','Gateway',1),
        ('6973','US-Mexico Border','Gateway',1),
        ('6975','US-Mexico Border','Gateway',1),
        ('6978','US-Mexico Border','Gateway',1),
        ('6979','US-Mexico Border','Gateway',1),
        ('6981','US-Mexico Border','Gateway',1),
        ('6982','US-Mexico Border','Gateway',1),
        ('6983','US-Mexico Border','Gateway',1),
        ('6984','US-Mexico Border','Gateway',1),
        ('6985','US-Mexico Border','Gateway',1),
        ('6986','US-Mexico Border','Gateway',1),
        ('6987','US-Mexico Border','Gateway',1),
        ('6988','US-Mexico Border','Gateway',1),
        ('6989','US-Mexico Border','Gateway',1),
        ('6990','US-Mexico Border','Gateway',1),
        ('6991','US-Mexico Border','Gateway',1),
        ('6992','US-Mexico Border','Gateway',1),
        ('6993','US-Mexico Border','Gateway',1),
        ('6994','US-Mexico Border','Gateway',1),
        ('6995','US-Mexico Border','Gateway',1),
        ('6996','US-Mexico Border','Gateway',1),
        ('6997','US-Mexico Border','Gateway',1),
        ('6998','US-Mexico Border','Gateway',1),
        ('6999','US-Mexico Border','Gateway',1),
        ('7000','US-Mexico Border','Gateway',1),
        ('7001','US-Mexico Border','Gateway',1),
        ('7002','US-Mexico Border','Gateway',1),
        ('7003','US-Mexico Border','Gateway',1),
        ('7004','US-Mexico Border','Gateway',1),
        ('7005','US-Mexico Border','Gateway',1),
        ('7006','US-Mexico Border','Gateway',1),
        ('7007','US-Mexico Border','Gateway',1),
        ('7008','US-Mexico Border','Gateway',1),
        ('7009','US-Mexico Border','Gateway',1),
        ('7010','US-Mexico Border','Gateway',1),
        ('7011','US-Mexico Border','Gateway',1),
        ('7012','US-Mexico Border','Gateway',1),
        ('7013','US-Mexico Border','Gateway',1),
        ('7014','US-Mexico Border','Gateway',1),
        ('7015','US-Mexico Border','Gateway',1),
        ('7016','US-Mexico Border','Gateway',1),
        ('7017','US-Mexico Border','Gateway',1),
        ('7018','US-Mexico Border','Gateway',1),
        ('7019','US-Mexico Border','Gateway',1),
        ('7020','US-Mexico Border','Gateway',1),
        ('7021','US-Mexico Border','Gateway',1),
        ('7022','US-Mexico Border','Gateway',1),
        ('7023','US-Mexico Border','Gateway',1),
        ('7024','US-Mexico Border','Gateway',1),
        ('7025','US-Mexico Border','Gateway',1),
        ('7026','US-Mexico Border','Gateway',1),
        ('7027','US-Mexico Border','Gateway',1),
        ('7028','US-Mexico Border','Gateway',1),
        ('7029','US-Mexico Border','Gateway',1),
        ('7030','US-Mexico Border','Gateway',1),
        ('7031','US-Mexico Border','Gateway',1),
        ('7032','US-Mexico Border','Gateway',1),
        ('7033','US-Mexico Border','Gateway',1),
        ('7034','US-Mexico Border','Gateway',1),
        ('7035','US-Mexico Border','Gateway',1),
        ('7036','US-Mexico Border','Gateway',1),
        ('7037','US-Mexico Border','Gateway',1),
        ('7038','US-Mexico Border','Gateway',1),
        ('7039','US-Mexico Border','Gateway',1),
        ('7040','US-Mexico Border','Gateway',1),
        ('7041','US-Mexico Border','Gateway',1),
        ('7042','US-Mexico Border','Gateway',1),
        ('7043','US-Mexico Border','Gateway',1),
        ('7044','US-Mexico Border','Gateway',1),
        ('7045','US-Mexico Border','Gateway',1),
        ('7046','US-Mexico Border','Gateway',1),
        ('7047','US-Mexico Border','Gateway',1),
        ('7048','US-Mexico Border','Gateway',1),
        ('7049','US-Mexico Border','Gateway',1),
        ('7050','US-Mexico Border','Gateway',1),
        ('7051','US-Mexico Border','Gateway',1),
        ('7052','US-Mexico Border','Gateway',1),
        ('7053','US-Mexico Border','Gateway',1),
        ('7054','US-Mexico Border','Gateway',1),
        ('7055','US-Mexico Border','Gateway',1),
        ('7056','US-Mexico Border','Gateway',1),
        ('7057','US-Mexico Border','Gateway',1),
        ('7058','US-Mexico Border','Gateway',1),
        ('7059','US-Mexico Border','Gateway',1),
        ('7060','US-Mexico Border','Gateway',1),
        ('7061','US-Mexico Border','Gateway',1),
        ('7062','US-Mexico Border','Gateway',1),
        ('7063','US-Mexico Border','Gateway',1),
        ('7064','US-Mexico Border','Gateway',1),
        ('7065','US-Mexico Border','Gateway',1),
        ('7066','US-Mexico Border','Gateway',1),
        ('7067','US-Mexico Border','Gateway',1),
        ('7068','US-Mexico Border','Gateway',1),
        ('7069','US-Mexico Border','Gateway',1),
        ('7070','US-Mexico Border','Gateway',1),
        ('7071','US-Mexico Border','Gateway',1),
        ('7072','US-Mexico Border','Gateway',1),
        ('7073','US-Mexico Border','Gateway',1),
        ('7074','US-Mexico Border','Gateway',1),
        ('7075','US-Mexico Border','Gateway',1),
        ('7076','US-Mexico Border','Gateway',1),
        ('7077','US-Mexico Border','Gateway',1),
        ('7078','US-Mexico Border','Gateway',1),
        ('7079','US-Mexico Border','Gateway',1),
        ('7080','US-Mexico Border','Gateway',1),
        ('7081','US-Mexico Border','Gateway',1),
        ('7082','US-Mexico Border','Gateway',1),
        ('7083','US-Mexico Border','Gateway',1),
        ('7084','US-Mexico Border','Gateway',1),
        ('7085','US-Mexico Border','Gateway',1),
        ('7086','US-Mexico Border','Gateway',1),
        ('7087','US-Mexico Border','Gateway',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('7088','US-Mexico Border','Gateway',1),
        ('7089','US-Mexico Border','Gateway',1),
        ('7090','US-Mexico Border','Gateway',1),
        ('7091','US-Mexico Border','Gateway',1),
        ('7103','US-Mexico Border','Gateway',1),
        ('7104','US-Mexico Border','Gateway',1),
        ('7110','US-Mexico Border','Gateway',1),
        ('7121','US-Mexico Border','Gateway',1),
        ('7143','Imperial Beach','Coastal',1),
        ('7144','Imperial Beach','Coastal',1),
        ('7145','Imperial Beach','Coastal',1),
        ('7146','Imperial Beach','Coastal',1),
        ('7147','Imperial Beach','Coastal',1),
        ('7148','Imperial Beach','Coastal',1),
        ('7150','Imperial Beach','Coastal',1),
        ('7151','Imperial Beach','Coastal',1),
        ('7152','Imperial Beach','Coastal',1),
        ('7153','Imperial Beach','Coastal',1),
        ('7154','Imperial Beach','Coastal',1),
        ('7155','Imperial Beach','Coastal',1),
        ('7156','Imperial Beach','Coastal',1),
        ('7157','Imperial Beach','Coastal',1),
        ('7158','Imperial Beach','Coastal',1),
        ('7159','Imperial Beach','Coastal',1),
        ('7160','Imperial Beach','Coastal',1),
        ('7161','Imperial Beach','Coastal',1),
        ('7162','Imperial Beach','Coastal',1),
        ('7163','Imperial Beach','Coastal',1),
        ('7164','Imperial Beach','Coastal',1),
        ('7165','Imperial Beach','Coastal',1),
        ('7166','Imperial Beach','Coastal',1),
        ('7167','Imperial Beach','Coastal',1),
        ('7172','Imperial Beach','Coastal',1),
        ('7173','Imperial Beach','Coastal',1),
        ('7174','Imperial Beach','Coastal',1),
        ('7175','Imperial Beach','Coastal',1),
        ('7176','Imperial Beach','Coastal',1),
        ('7177','Imperial Beach','Coastal',1),
        ('7178','Imperial Beach','Coastal',1),
        ('7179','Imperial Beach','Coastal',1),
        ('7180','Imperial Beach','Coastal',1),
        ('7181','Imperial Beach','Coastal',1),
        ('7182','Imperial Beach','Coastal',1),
        ('7183','Imperial Beach','Coastal',1),
        ('7184','Imperial Beach','Coastal',1),
        ('7185','Imperial Beach','Coastal',1),
        ('7186','Imperial Beach','Coastal',1),
        ('7187','Imperial Beach','Coastal',1),
        ('7188','Imperial Beach','Coastal',1),
        ('7189','Southwest Chula Vista','Suburban',0),
        ('7190','Southwest Chula Vista','Suburban',0),
        ('7191','Southwest Chula Vista','Suburban',0),
        ('7192','Southwest Chula Vista','Suburban',0),
        ('7193','Southwest Chula Vista','Suburban',0),
        ('7194','Southwest Chula Vista','Suburban',0),
        ('7195','Imperial Beach','Coastal',1),
        ('7196','Imperial Beach','Coastal',1),
        ('7197','Imperial Beach','Coastal',1),
        ('7198','Imperial Beach','Coastal',1),
        ('7199','Imperial Beach','Coastal',1),
        ('7204','Imperial Beach','Coastal',1),
        ('7205','Imperial Beach','Coastal',1),
        ('7218','Imperial Beach','Coastal',1),
        ('7219','Imperial Beach','Coastal',1),
        ('7220','Imperial Beach','Coastal',1),
        ('7221','Imperial Beach','Coastal',1),
        ('7222','Imperial Beach','Coastal',1),
        ('7223','Imperial Beach','Coastal',1),
        ('7224','Imperial Beach','Coastal',1),
        ('7225','Imperial Beach','Coastal',1),
        ('7226','Imperial Beach','Coastal',1),
        ('7227','Imperial Beach','Coastal',1),
        ('7228','Imperial Beach','Coastal',1),
        ('7229','Imperial Beach','Coastal',1),
        ('7230','Imperial Beach','Coastal',1),
        ('7231','Imperial Beach','Coastal',1),
        ('7232','Imperial Beach','Coastal',1),
        ('7234','US-Mexico Border','Gateway',1),
        ('7235','US-Mexico Border','Gateway',1),
        ('7236','US-Mexico Border','Gateway',1),
        ('7237','US-Mexico Border','Gateway',1),
        ('7238','US-Mexico Border','Gateway',1),
        ('7239','Imperial Beach','Coastal',1),
        ('7240','Imperial Beach','Coastal',1),
        ('7241','Imperial Beach','Coastal',1),
        ('7242','Imperial Beach','Coastal',1),
        ('7244','Imperial Beach','Coastal',1),
        ('7246','Imperial Beach','Coastal',1),
        ('7247','Imperial Beach','Coastal',1),
        ('7248','Imperial Beach','Coastal',1),
        ('7249','Imperial Beach','Coastal',1),
        ('7250','Imperial Beach','Coastal',1),
        ('7251','Imperial Beach','Coastal',1),
        ('7252','Imperial Beach','Coastal',1),
        ('7253','Imperial Beach','Coastal',1),
        ('7260','Imperial Beach','Coastal',1),
        ('7261','Imperial Beach','Coastal',1),
        ('7262','Imperial Beach','Coastal',1),
        ('7263','Imperial Beach','Coastal',1),
        ('7264','Imperial Beach','Coastal',1),
        ('7265','Imperial Beach','Coastal',1),
        ('7266','Imperial Beach','Coastal',1),
        ('7267','Imperial Beach','Coastal',1),
        ('7268','Imperial Beach','Coastal',1),
        ('7269','Imperial Beach','Coastal',1),
        ('7270','Imperial Beach','Coastal',1),
        ('7271','Imperial Beach','Coastal',1),
        ('7272','Imperial Beach','Coastal',1),
        ('7273','Imperial Beach','Coastal',1),
        ('7274','Imperial Beach','Coastal',1),
        ('7275','Imperial Beach','Coastal',1),
        ('7276','Imperial Beach','Coastal',1),
        ('7277','Imperial Beach','Coastal',1),
        ('7278','Imperial Beach','Coastal',1),
        ('7279','Imperial Beach','Coastal',1),
        ('7280','Imperial Beach','Coastal',1),
        ('7281','Imperial Beach','Coastal',1),
        ('7282','Imperial Beach','Coastal',1),
        ('7283','Imperial Beach','Coastal',1),
        ('7284','Imperial Beach','Coastal',1),
        ('7285','Imperial Beach','Coastal',1),
        ('7286','Imperial Beach','Coastal',1),
        ('7287','Imperial Beach','Coastal',1),
        ('7288','Imperial Beach','Coastal',1),
        ('7289','Imperial Beach','Coastal',1),
        ('7290','Imperial Beach','Coastal',1),
        ('7291','Imperial Beach','Coastal',1),
        ('7292','Imperial Beach','Coastal',1),
        ('7293','Imperial Beach','Coastal',1),
        ('7294','Imperial Beach','Coastal',1),
        ('7295','Imperial Beach','Coastal',1),
        ('7296','Imperial Beach','Coastal',1),
        ('7297','Imperial Beach','Coastal',1),
        ('7298','Imperial Beach','Coastal',1),
        ('7299','Imperial Beach','Coastal',1),
        ('7300','Imperial Beach','Coastal',1),
        ('7301','Imperial Beach','Coastal',1),
        ('7302','Imperial Beach','Coastal',1),
        ('7303','Imperial Beach','Coastal',1),
        ('7304','Imperial Beach','Coastal',1),
        ('7305','Imperial Beach','Coastal',1),
        ('7306','Imperial Beach','Coastal',1),
        ('7307','Imperial Beach','Coastal',1),
        ('7308','Imperial Beach','Coastal',1),
        ('7309','Imperial Beach','Coastal',1),
        ('7310','Imperial Beach','Coastal',1),
        ('7311','Imperial Beach','Coastal',1),
        ('7312','Imperial Beach','Coastal',1),
        ('7313','Imperial Beach','Coastal',1),
        ('7314','Imperial Beach','Coastal',1),
        ('7315','Imperial Beach','Coastal',1),
        ('7316','Imperial Beach','Coastal',1),
        ('7317','Imperial Beach','Coastal',1),
        ('7318','Imperial Beach','Coastal',1),
        ('7319','Imperial Beach','Coastal',1),
        ('7320','Imperial Beach','Coastal',1),
        ('7321','Imperial Beach','Coastal',1),
        ('7322','Imperial Beach','Coastal',1),
        ('7323','Imperial Beach','Coastal',1),
        ('7324','Imperial Beach','Coastal',1),
        ('7325','Imperial Beach','Coastal',1),
        ('7326','Imperial Beach','Coastal',1),
        ('7327','Imperial Beach','Coastal',1),
        ('7328','Imperial Beach','Coastal',1),
        ('7330','Imperial Beach','Coastal',1),
        ('7331','Imperial Beach','Coastal',1),
        ('7332','Imperial Beach','Coastal',1),
        ('7333','Imperial Beach','Coastal',1),
        ('7334','Imperial Beach','Coastal',1),
        ('7335','Imperial Beach','Coastal',1),
        ('7336','Imperial Beach','Coastal',1),
        ('7337','Imperial Beach','Coastal',1),
        ('7338','Imperial Beach','Coastal',1),
        ('7339','Imperial Beach','Coastal',1),
        ('7340','Imperial Beach','Coastal',1),
        ('7341','Imperial Beach','Coastal',1),
        ('7342','Imperial Beach','Coastal',1),
        ('7343','Imperial Beach','Coastal',1),
        ('7344','Imperial Beach','Coastal',1),
        ('7345','Imperial Beach','Coastal',1),
        ('7346','Imperial Beach','Coastal',1),
        ('7347','Imperial Beach','Coastal',1),
        ('7348','Imperial Beach','Coastal',1),
        ('7349','Imperial Beach','Coastal',1),
        ('7350','Imperial Beach','Coastal',1),
        ('7351','Imperial Beach','Coastal',1),
        ('7352','Imperial Beach','Coastal',1),
        ('7353','Imperial Beach','Coastal',1),
        ('7354','Imperial Beach','Coastal',1),
        ('7355','Imperial Beach','Coastal',1),
        ('7372','Coronado','Coastal',0),
        ('7373','Coronado','Coastal',0),
        ('7374','Coronado','Coastal',0),
        ('7375','Coronado','Coastal',0),
        ('7376','Coronado','Coastal',0),
        ('7377','Coronado','Coastal',0),
        ('7378','Coronado','Coastal',0),
        ('7379','Coronado','Coastal',0),
        ('7380','Coronado','Coastal',0),
        ('7381','Coronado','Coastal',0),
        ('7382','Coronado','Coastal',0),
        ('7383','Coronado','Coastal',0),
        ('7384','Coronado','Coastal',0),
        ('7385','Coronado','Coastal',0),
        ('7386','Coronado','Coastal',0),
        ('7387','Coronado','Coastal',0),
        ('7388','Coronado','Coastal',0),
        ('7389','Coronado','Coastal',0),
        ('7390','Coronado','Coastal',0),
        ('7391','Coronado','Coastal',0),
        ('7392','Coronado','Coastal',0),
        ('7393','Coronado','Coastal',0),
        ('7394','Coronado','Coastal',0),
        ('7395','Coronado','Coastal',0),
        ('7396','Coronado','Coastal',0),
        ('7397','Coronado','Coastal',0),
        ('7398','Coronado','Coastal',0),
        ('7399','Coronado','Coastal',0),
        ('7400','Coronado','Coastal',0),
        ('7401','Coronado','Coastal',0),
        ('7402','Coronado','Coastal',0),
        ('7403','Coronado','Coastal',0),
        ('7404','Coronado','Coastal',0),
        ('7405','Coronado','Coastal',0),
        ('7406','Coronado','Coastal',0),
        ('7407','Coronado','Coastal',0),
        ('7408','Coronado','Coastal',0),
        ('7409','Coronado','Coastal',0),
        ('7410','Coronado','Coastal',0),
        ('7411','Coronado','Coastal',0),
        ('7412','Coronado','Coastal',0),
        ('7413','Coronado','Coastal',0),
        ('7414','Coronado','Coastal',0),
        ('7415','Coronado','Coastal',0),
        ('7416','Coronado','Coastal',0),
        ('7417','Coronado','Coastal',0),
        ('7418','Coronado','Coastal',0),
        ('7419','Coronado','Coastal',0),
        ('7420','Coronado','Coastal',0),
        ('7421','Coronado','Coastal',0),
        ('7422','Coronado','Coastal',0),
        ('7423','Coronado','Coastal',0),
        ('7424','Coronado','Coastal',0),
        ('7425','Coronado','Coastal',0),
        ('7426','Coronado','Coastal',0),
        ('7427','Coronado','Coastal',0),
        ('7428','Coronado','Coastal',0),
        ('7429','Coronado','Coastal',0),
        ('7430','Coronado','Coastal',0),
        ('7431','Coronado','Coastal',0),
        ('7432','Coronado','Coastal',0),
        ('7433','Coronado','Coastal',0),
        ('7434','Coronado','Coastal',0),
        ('7435','Coronado','Coastal',0),
        ('7436','Coronado','Coastal',0),
        ('7437','Coronado','Coastal',0),
        ('7438','Coronado','Coastal',0),
        ('7439','Coronado','Coastal',0),
        ('7440','Coronado','Coastal',0),
        ('7441','Coronado','Coastal',0),
        ('7442','Coronado','Coastal',0),
        ('7443','Coronado','Coastal',0),
        ('7444','Coronado','Coastal',0),
        ('7445','Coronado','Coastal',0),
        ('7446','Coronado','Coastal',0),
        ('7447','Coronado','Coastal',0),
        ('7448','Coronado','Coastal',0),
        ('7449','Coronado','Coastal',0),
        ('7450','Coronado','Coastal',0),
        ('7451','Coronado','Coastal',0),
        ('7452','Coronado','Coastal',0),
        ('7453','Coronado','Coastal',0),
        ('7454','Coronado','Coastal',0),
        ('7455','Coronado','Coastal',0),
        ('7456','Coronado','Coastal',0),
        ('7457','Coronado','Coastal',0),
        ('7458','Coronado','Coastal',0),
        ('7459','Coronado','Coastal',0),
        ('7460','Coronado','Coastal',0),
        ('7461','Coronado','Coastal',0),
        ('7462','Coronado','Coastal',0),
        ('7463','Coronado','Coastal',0),
        ('7464','Coronado','Coastal',0),
        ('7465','Coronado','Coastal',0),
        ('7466','Coronado','Coastal',0),
        ('7467','Coronado','Coastal',0),
        ('7468','Coronado','Coastal',0),
        ('7469','Coronado','Coastal',0),
        ('7470','Coronado','Coastal',0),
        ('7471','Coronado','Coastal',0),
        ('7472','Coronado','Coastal',0),
        ('7473','Coronado','Coastal',0),
        ('7474','Coronado','Coastal',0),
        ('7475','Coronado','Coastal',0),
        ('7476','Coronado','Coastal',0),
        ('7477','Coronado','Coastal',0),
        ('7478','Coronado','Coastal',0),
        ('7479','Coronado','Coastal',0),
        ('7480','Coronado','Coastal',0),
        ('7481','Coronado','Coastal',0),
        ('7482','Coronado','Coastal',0),
        ('7483','Coronado','Coastal',0),
        ('7484','Coronado','Coastal',0),
        ('7485','Coronado','Coastal',0),
        ('7486','Coronado','Coastal',0),
        ('7487','Coronado','Coastal',0),
        ('7488','Coronado','Coastal',0),
        ('7489','Coronado','Coastal',0),
        ('7490','Coronado','Coastal',0),
        ('7491','Coronado','Coastal',0),
        ('7492','Coronado','Coastal',0),
        ('7493','Coronado','Coastal',0),
        ('7494','Coronado','Coastal',0),
        ('7495','Coronado','Coastal',0),
        ('7496','Coronado','Coastal',0),
        ('7497','Coronado','Coastal',0),
        ('7498','Coronado','Coastal',0),
        ('7499','Coronado','Coastal',0),
        ('7500','Coronado','Coastal',0),
        ('7501','Coronado','Coastal',0),
        ('7502','Coronado','Coastal',0),
        ('7503','Coronado','Coastal',0),
        ('7504','Coronado','Coastal',0),
        ('7505','Coronado','Coastal',0),
        ('7506','Coronado','Coastal',0),
        ('7507','Coronado','Coastal',0),
        ('7508','Coronado','Coastal',0),
        ('7509','Coronado','Coastal',0),
        ('7510','Coronado','Coastal',0),
        ('7511','Coronado','Coastal',0),
        ('7512','Coronado','Coastal',0),
        ('7513','Coronado','Coastal',0),
        ('7514','Coronado','Coastal',0),
        ('7515','Coronado','Coastal',0),
        ('7516','Coronado','Coastal',0),
        ('7517','Coronado','Coastal',0),
        ('7518','Coronado','Coastal',0),
        ('7519','Coronado','Coastal',0),
        ('7520','Coronado','Coastal',0),
        ('7522','Coronado','Coastal',0),
        ('7523','Coronado','Coastal',0),
        ('7526','National City','Major Employment Center',1),
        ('7527','National City','Major Employment Center',1),
        ('7528','National City','Major Employment Center',1),
        ('7529','National City','Major Employment Center',1),
        ('7530','National City','Major Employment Center',1),
        ('7531','National City','Major Employment Center',1),
        ('7532','National City','Major Employment Center',1),
        ('7533','National City','Major Employment Center',1),
        ('7534','National City','Major Employment Center',1),
        ('7535','National City','Major Employment Center',1),
        ('7536','National City','Major Employment Center',1),
        ('7537','National City','Major Employment Center',1),
        ('7538','National City','Major Employment Center',1),
        ('7539','National City','Major Employment Center',1),
        ('7540','National City','Major Employment Center',1),
        ('7541','National City','Major Employment Center',1),
        ('7542','National City','Major Employment Center',1),
        ('7543','National City','Major Employment Center',1),
        ('7544','National City','Major Employment Center',1),
        ('7545','National City','Major Employment Center',1),
        ('7546','National City','Major Employment Center',1),
        ('7547','National City','Major Employment Center',1),
        ('7548','National City','Major Employment Center',1),
        ('7549','National City','Major Employment Center',1),
        ('7550','National City','Major Employment Center',1),
        ('7551','National City','Major Employment Center',1),
        ('7552','National City','Major Employment Center',1),
        ('7553','National City','Major Employment Center',1),
        ('7554','National City','Major Employment Center',1),
        ('7555','National City','Major Employment Center',1),
        ('7556','National City','Major Employment Center',1),
        ('7557','National City','Major Employment Center',1),
        ('7558','National City','Major Employment Center',1),
        ('7559','National City','Major Employment Center',1),
        ('7560','National City','Major Employment Center',1),
        ('7561','National City','Major Employment Center',1),
        ('7562','National City','Major Employment Center',1),
        ('7563','National City','Major Employment Center',1),
        ('7564','National City','Major Employment Center',1),
        ('7565','National City','Major Employment Center',1),
        ('7566','National City','Major Employment Center',1),
        ('7567','National City','Major Employment Center',1),
        ('7568','National City','Major Employment Center',1),
        ('7569','National City','Major Employment Center',1),
        ('7570','National City','Major Employment Center',1),
        ('7571','National City','Major Employment Center',1),
        ('7572','National City','Major Employment Center',1),
        ('7573','National City','Major Employment Center',1),
        ('7574','National City','Major Employment Center',1),
        ('7575','National City','Major Employment Center',1),
        ('7576','National City','Major Employment Center',1),
        ('7577','National City','Major Employment Center',1),
        ('7578','National City','Major Employment Center',1),
        ('7579','National City','Major Employment Center',1),
        ('7580','National City','Major Employment Center',1),
        ('7581','National City','Major Employment Center',1),
        ('7582','National City','Major Employment Center',1),
        ('7583','Downtown Chula Vista','Suburban',0),
        ('7584','National City','Major Employment Center',1),
        ('7585','National City','Major Employment Center',1),
        ('7586','National City','Major Employment Center',1),
        ('7587','National City','Major Employment Center',1),
        ('7588','National City','Major Employment Center',1),
        ('7589','National City','Major Employment Center',1),
        ('7590','National City','Major Employment Center',1),
        ('7591','National City','Major Employment Center',1),
        ('7592','National City','Major Employment Center',1),
        ('7593','National City','Major Employment Center',1),
        ('7594','National City','Major Employment Center',1),
        ('7595','National City','Major Employment Center',1),
        ('7596','National City','Major Employment Center',1),
        ('7597','National City','Major Employment Center',1),
        ('7598','National City','Major Employment Center',1),
        ('7599','National City','Major Employment Center',1),
        ('7600','National City','Major Employment Center',1),
        ('7601','National City','Major Employment Center',1),
        ('7602','National City','Major Employment Center',1),
        ('7603','National City','Major Employment Center',1),
        ('7604','National City','Major Employment Center',1),
        ('7605','National City','Major Employment Center',1),
        ('7606','National City','Major Employment Center',1),
        ('7607','National City','Major Employment Center',1),
        ('7608','National City','Major Employment Center',1),
        ('7609','National City','Major Employment Center',1),
        ('7610','National City','Major Employment Center',1),
        ('7611','National City','Major Employment Center',1),
        ('7612','National City','Major Employment Center',1),
        ('7613','National City','Major Employment Center',1),
        ('7614','National City','Major Employment Center',1),
        ('7615','National City','Major Employment Center',1),
        ('7616','National City','Major Employment Center',1),
        ('7617','National City','Major Employment Center',1),
        ('7618','National City','Major Employment Center',1),
        ('7619','National City','Major Employment Center',1),
        ('7620','National City','Major Employment Center',1),
        ('7621','National City','Major Employment Center',1),
        ('7622','National City','Major Employment Center',1),
        ('7623','National City','Major Employment Center',1),
        ('7624','National City','Major Employment Center',1),
        ('7625','National City','Major Employment Center',1),
        ('7626','National City','Major Employment Center',1),
        ('7627','National City','Major Employment Center',1),
        ('7628','National City','Major Employment Center',1),
        ('7629','National City','Major Employment Center',1),
        ('7630','National City','Major Employment Center',1),
        ('7631','National City','Major Employment Center',1),
        ('7632','National City','Major Employment Center',1),
        ('7633','National City','Major Employment Center',1),
        ('7634','National City','Major Employment Center',1),
        ('7635','National City','Major Employment Center',1),
        ('7636','National City','Major Employment Center',1),
        ('7637','National City','Major Employment Center',1),
        ('7638','National City','Major Employment Center',1),
        ('7639','National City','Major Employment Center',1),
        ('7640','National City','Major Employment Center',1),
        ('7641','National City','Major Employment Center',1),
        ('7642','National City','Major Employment Center',1),
        ('7643','National City','Major Employment Center',1),
        ('7644','National City','Major Employment Center',1),
        ('7645','National City','Major Employment Center',1),
        ('7646','National City','Major Employment Center',1),
        ('7647','National City','Major Employment Center',1),
        ('7648','National City','Major Employment Center',1),
        ('7649','National City','Major Employment Center',1),
        ('7650','National City','Major Employment Center',1),
        ('7651','National City','Major Employment Center',1),
        ('7652','National City','Major Employment Center',1),
        ('7653','National City','Major Employment Center',1),
        ('7654','National City','Major Employment Center',1),
        ('7655','National City','Major Employment Center',1),
        ('7656','National City','Major Employment Center',1),
        ('7657','National City','Major Employment Center',1),
        ('7658','National City','Major Employment Center',1),
        ('7659','National City','Major Employment Center',1),
        ('7660','National City','Major Employment Center',1),
        ('7661','National City','Major Employment Center',1),
        ('7662','National City','Major Employment Center',1),
        ('7663','National City','Major Employment Center',1),
        ('7664','National City','Major Employment Center',1),
        ('7665','National City','Major Employment Center',1),
        ('7666','National City','Major Employment Center',1),
        ('7667','National City','Major Employment Center',1),
        ('7668','National City','Major Employment Center',1),
        ('7669','National City','Major Employment Center',1),
        ('7670','National City','Major Employment Center',1),
        ('7671','National City','Major Employment Center',1),
        ('7672','National City','Major Employment Center',1),
        ('7673','National City','Major Employment Center',1),
        ('7674','National City','Major Employment Center',1),
        ('7675','National City','Major Employment Center',1),
        ('7676','National City','Major Employment Center',1),
        ('7677','National City','Major Employment Center',1),
        ('7678','National City','Major Employment Center',1),
        ('7679','National City','Major Employment Center',1),
        ('7680','National City','Major Employment Center',1),
        ('7681','National City','Major Employment Center',1),
        ('7682','National City','Major Employment Center',1),
        ('7683','National City','Major Employment Center',1),
        ('7684','National City','Major Employment Center',1),
        ('7685','National City','Major Employment Center',1),
        ('7686','National City','Major Employment Center',1),
        ('7687','National City','Major Employment Center',1),
        ('7688','National City','Major Employment Center',1),
        ('7689','National City','Major Employment Center',1),
        ('7690','National City','Major Employment Center',1),
        ('7691','National City','Major Employment Center',1),
        ('7692','National City','Major Employment Center',1),
        ('7693','National City','Major Employment Center',1),
        ('7694','National City','Major Employment Center',1),
        ('7695','National City','Major Employment Center',1),
        ('7696','National City','Major Employment Center',1),
        ('7697','National City','Major Employment Center',1),
        ('7698','National City','Major Employment Center',1),
        ('7699','National City','Major Employment Center',1),
        ('7700','National City','Major Employment Center',1),
        ('7701','National City','Major Employment Center',1),
        ('7702','National City','Major Employment Center',1),
        ('7703','National City','Major Employment Center',1),
        ('7704','National City','Major Employment Center',1),
        ('7705','National City','Major Employment Center',1),
        ('7706','National City','Major Employment Center',1),
        ('7707','National City','Major Employment Center',1),
        ('7708','National City','Major Employment Center',1),
        ('7709','National City','Major Employment Center',1),
        ('7710','National City','Major Employment Center',1),
        ('7711','National City','Major Employment Center',1),
        ('7712','National City','Major Employment Center',1),
        ('7713','National City','Major Employment Center',1),
        ('7714','National City','Major Employment Center',1),
        ('7715','National City','Major Employment Center',1),
        ('7716','National City','Major Employment Center',1),
        ('7717','National City','Major Employment Center',1),
        ('7718','National City','Major Employment Center',1),
        ('7719','National City','Major Employment Center',1),
        ('7720','National City','Major Employment Center',1),
        ('7721','National City','Major Employment Center',1),
        ('7722','National City','Major Employment Center',1),
        ('7723','National City','Major Employment Center',1),
        ('7724','National City','Major Employment Center',1),
        ('7725','National City','Major Employment Center',1),
        ('7726','National City','Major Employment Center',1),
        ('7727','National City','Major Employment Center',1),
        ('7728','National City','Major Employment Center',1),
        ('7729','National City','Major Employment Center',1),
        ('7730','National City','Major Employment Center',1),
        ('7731','National City','Major Employment Center',1),
        ('7732','National City','Major Employment Center',1),
        ('7733','National City','Major Employment Center',1),
        ('7734','National City','Major Employment Center',1),
        ('7735','National City','Major Employment Center',1),
        ('7736','National City','Major Employment Center',1),
        ('7737','National City','Major Employment Center',1),
        ('7738','National City','Major Employment Center',1),
        ('7739','National City','Major Employment Center',1),
        ('7740','National City','Major Employment Center',1),
        ('7741','National City','Major Employment Center',1),
        ('7742','National City','Major Employment Center',1),
        ('7743','National City','Major Employment Center',1),
        ('7744','National City','Major Employment Center',1),
        ('7745','National City','Major Employment Center',1),
        ('7746','National City','Major Employment Center',1),
        ('7747','National City','Major Employment Center',1),
        ('7751','National City','Major Employment Center',1),
        ('7752','National City','Major Employment Center',1),
        ('7753','National City','Major Employment Center',1),
        ('7754','National City','Major Employment Center',1),
        ('7755','National City','Major Employment Center',1),
        ('7756','National City','Major Employment Center',1),
        ('7757','National City','Major Employment Center',1),
        ('7758','National City','Major Employment Center',1),
        ('7759','National City','Major Employment Center',1),
        ('7760','National City','Major Employment Center',1),
        ('7761','National City','Major Employment Center',1),
        ('7762','National City','Major Employment Center',1),
        ('7763','National City','Major Employment Center',1),
        ('7764','National City','Major Employment Center',1),
        ('7765','National City','Major Employment Center',1),
        ('7766','National City','Major Employment Center',1),
        ('7767','National City','Major Employment Center',1),
        ('7768','National City','Major Employment Center',1),
        ('7769','Southeast San Diego','Suburban',0),
        ('7770','National City','Major Employment Center',1),
        ('7771','National City','Major Employment Center',1),
        ('7772','National City','Major Employment Center',1),
        ('7773','National City','Major Employment Center',1),
        ('7774','National City','Major Employment Center',1),
        ('7776','National City','Major Employment Center',1),
        ('7777','National City','Major Employment Center',1),
        ('7778','National City','Major Employment Center',1),
        ('7779','National City','Major Employment Center',1),
        ('7780','National City','Major Employment Center',1),
        ('7787','National City','Major Employment Center',1),
        ('7788','National City','Major Employment Center',1),
        ('7789','National City','Major Employment Center',1),
        ('7790','National City','Major Employment Center',1),
        ('7791','National City','Major Employment Center',1),
        ('7792','National City','Major Employment Center',1),
        ('7793','National City','Major Employment Center',1),
        ('7794','National City','Major Employment Center',1),
        ('7795','National City','Major Employment Center',1),
        ('7796','National City','Major Employment Center',1),
        ('7797','National City','Major Employment Center',1),
        ('7798','National City','Major Employment Center',1),
        ('7799','National City','Major Employment Center',1),
        ('7800','National City','Major Employment Center',1),
        ('7801','National City','Major Employment Center',1),
        ('7802','National City','Major Employment Center',1),
        ('7803','National City','Major Employment Center',1),
        ('7804','National City','Major Employment Center',1),
        ('7805','National City','Major Employment Center',1),
        ('7806','National City','Major Employment Center',1),
        ('7807','National City','Major Employment Center',1),
        ('7808','National City','Major Employment Center',1),
        ('7809','National City','Major Employment Center',1),
        ('7810','National City','Major Employment Center',1),
        ('7811','National City','Major Employment Center',1),
        ('7812','National City','Major Employment Center',1),
        ('7813','National City','Major Employment Center',1),
        ('7814','National City','Major Employment Center',1),
        ('7815','National City','Major Employment Center',1),
        ('7816','National City','Major Employment Center',1),
        ('7817','National City','Major Employment Center',1),
        ('7818','National City','Major Employment Center',1),
        ('7819','National City','Major Employment Center',1),
        ('7820','National City','Major Employment Center',1),
        ('7821','National City','Major Employment Center',1),
        ('7822','National City','Major Employment Center',1),
        ('7823','National City','Major Employment Center',1),
        ('7824','National City','Major Employment Center',1),
        ('7825','National City','Major Employment Center',1),
        ('7826','National City','Major Employment Center',1),
        ('7827','National City','Major Employment Center',1),
        ('7828','National City','Major Employment Center',1),
        ('7829','National City','Major Employment Center',1),
        ('7830','National City','Major Employment Center',1),
        ('7831','National City','Major Employment Center',1),
        ('7832','National City','Major Employment Center',1),
        ('7833','National City','Major Employment Center',1),
        ('7834','National City','Major Employment Center',1),
        ('7835','National City','Major Employment Center',1),
        ('7836','National City','Major Employment Center',1),
        ('7837','National City','Major Employment Center',1),
        ('7838','National City','Major Employment Center',1),
        ('7839','National City','Major Employment Center',1),
        ('7840','National City','Major Employment Center',1),
        ('7841','National City','Major Employment Center',1),
        ('7842','National City','Major Employment Center',1),
        ('7843','National City','Major Employment Center',1),
        ('7844','National City','Major Employment Center',1),
        ('7845','National City','Major Employment Center',1),
        ('7846','National City','Major Employment Center',1),
        ('7847','National City','Major Employment Center',1),
        ('7848','National City','Major Employment Center',1),
        ('7849','National City','Major Employment Center',1),
        ('7850','National City','Major Employment Center',1),
        ('7852','National City','Major Employment Center',1),
        ('7853','National City','Major Employment Center',1),
        ('7854','National City','Major Employment Center',1),
        ('7855','National City','Major Employment Center',1),
        ('7856','National City','Major Employment Center',1),
        ('7857','National City','Major Employment Center',1),
        ('7858','National City','Major Employment Center',1),
        ('7859','National City','Major Employment Center',1),
        ('7861','National City','Major Employment Center',1),
        ('7862','National City','Major Employment Center',1),
        ('7864','National City','Major Employment Center',1),
        ('7865','National City','Major Employment Center',1),
        ('7866','National City','Major Employment Center',1),
        ('7867','National City','Major Employment Center',1),
        ('7868','National City','Major Employment Center',1),
        ('7869','National City','Major Employment Center',1),
        ('7870','National City','Major Employment Center',1),
        ('7871','National City','Major Employment Center',1),
        ('7872','National City','Major Employment Center',1),
        ('7873','National City','Major Employment Center',1),
        ('7874','National City','Major Employment Center',1),
        ('7887','National City','Major Employment Center',1),
        ('7889','National City','Major Employment Center',1),
        ('7892','National City','Major Employment Center',1),
        ('7897','Downtown Chula Vista','Suburban',0),
        ('7898','Downtown Chula Vista','Suburban',0),
        ('7899','Downtown Chula Vista','Suburban',0),
        ('7900','Downtown Chula Vista','Suburban',0),
        ('7901','Downtown Chula Vista','Suburban',0),
        ('7902','Downtown Chula Vista','Suburban',0),
        ('7903','Downtown Chula Vista','Suburban',0),
        ('7904','Downtown Chula Vista','Suburban',0),
        ('7905','Downtown Chula Vista','Suburban',0),
        ('7906','Downtown Chula Vista','Suburban',0),
        ('7907','Downtown Chula Vista','Suburban',0),
        ('7910','Downtown Chula Vista','Suburban',0),
        ('7911','Downtown Chula Vista','Suburban',0),
        ('7914','Downtown Chula Vista','Suburban',0),
        ('7915','Downtown Chula Vista','Suburban',0),
        ('7916','Downtown Chula Vista','Suburban',0),
        ('7917','Downtown Chula Vista','Suburban',0),
        ('7918','Downtown Chula Vista','Suburban',0),
        ('7919','Downtown Chula Vista','Suburban',0),
        ('7920','Downtown Chula Vista','Suburban',0),
        ('7921','Downtown Chula Vista','Suburban',0),
        ('7922','Downtown Chula Vista','Suburban',0),
        ('7923','Downtown Chula Vista','Suburban',0),
        ('7924','Downtown Chula Vista','Suburban',0),
        ('7925','Downtown Chula Vista','Suburban',0),
        ('7926','Downtown Chula Vista','Suburban',0),
        ('7927','Downtown Chula Vista','Suburban',0),
        ('7931','Downtown Chula Vista','Suburban',0),
        ('7932','Downtown Chula Vista','Suburban',0),
        ('7933','Downtown Chula Vista','Suburban',0),
        ('7934','Downtown Chula Vista','Suburban',0),
        ('7935','Downtown Chula Vista','Suburban',0),
        ('7936','Downtown Chula Vista','Suburban',0),
        ('7937','Downtown Chula Vista','Suburban',0),
        ('7938','Downtown Chula Vista','Suburban',0),
        ('7939','Downtown Chula Vista','Suburban',0),
        ('7946','Downtown Chula Vista','Suburban',0),
        ('7947','Downtown Chula Vista','Suburban',0),
        ('7948','Downtown Chula Vista','Suburban',0),
        ('7949','Downtown Chula Vista','Suburban',0),
        ('7950','Downtown Chula Vista','Suburban',0),
        ('7951','Downtown Chula Vista','Suburban',0),
        ('7952','National City','Major Employment Center',1),
        ('7953','National City','Major Employment Center',1),
        ('7954','National City','Major Employment Center',1),
        ('7955','Downtown Chula Vista','Suburban',0),
        ('7956','Downtown Chula Vista','Suburban',0),
        ('7957','Downtown Chula Vista','Suburban',0),
        ('7958','Downtown Chula Vista','Suburban',0),
        ('7959','Downtown Chula Vista','Suburban',0),
        ('7960','Downtown Chula Vista','Suburban',0),
        ('7961','Downtown Chula Vista','Suburban',0),
        ('7962','Downtown Chula Vista','Suburban',0),
        ('7963','Downtown Chula Vista','Suburban',0),
        ('7964','Downtown Chula Vista','Suburban',0),
        ('7965','Downtown Chula Vista','Suburban',0),
        ('7966','Downtown Chula Vista','Suburban',0),
        ('7967','Downtown Chula Vista','Suburban',0),
        ('7968','Downtown Chula Vista','Suburban',0),
        ('7969','Downtown Chula Vista','Suburban',0),
        ('7970','Downtown Chula Vista','Suburban',0),
        ('7971','Downtown Chula Vista','Suburban',0),
        ('7972','Downtown Chula Vista','Suburban',0),
        ('7973','Downtown Chula Vista','Suburban',0),
        ('7974','Downtown Chula Vista','Suburban',0),
        ('7975','Downtown Chula Vista','Suburban',0),
        ('7976','Downtown Chula Vista','Suburban',0),
        ('7977','Downtown Chula Vista','Suburban',0),
        ('7978','Downtown Chula Vista','Suburban',0),
        ('7979','Downtown Chula Vista','Suburban',0),
        ('7980','Downtown Chula Vista','Suburban',0),
        ('7981','Downtown Chula Vista','Suburban',0),
        ('7982','Downtown Chula Vista','Suburban',0),
        ('7983','Downtown Chula Vista','Suburban',0),
        ('7984','Downtown Chula Vista','Suburban',0),
        ('7985','Downtown Chula Vista','Suburban',0),
        ('7986','Downtown Chula Vista','Suburban',0),
        ('7987','Downtown Chula Vista','Suburban',0),
        ('7988','Downtown Chula Vista','Suburban',0),
        ('7989','Downtown Chula Vista','Suburban',0),
        ('7990','Downtown Chula Vista','Suburban',0),
        ('7993','Downtown Chula Vista','Suburban',0),
        ('7994','Downtown Chula Vista','Suburban',0),
        ('7995','Downtown Chula Vista','Suburban',0),
        ('7997','Downtown Chula Vista','Suburban',0),
        ('7998','Downtown Chula Vista','Suburban',0),
        ('7999','Downtown Chula Vista','Suburban',0),
        ('8000','Downtown Chula Vista','Suburban',0),
        ('8001','Downtown Chula Vista','Suburban',0),
        ('8002','Downtown Chula Vista','Suburban',0),
        ('8003','Downtown Chula Vista','Suburban',0),
        ('8004','Downtown Chula Vista','Suburban',0),
        ('8005','Downtown Chula Vista','Suburban',0),
        ('8006','Downtown Chula Vista','Suburban',0),
        ('8007','Downtown Chula Vista','Suburban',0),
        ('8008','Downtown Chula Vista','Suburban',0),
        ('8009','Downtown Chula Vista','Suburban',0),
        ('8010','Downtown Chula Vista','Suburban',0),
        ('8013','Downtown Chula Vista','Suburban',0),
        ('8014','Downtown Chula Vista','Suburban',0),
        ('8016','Downtown Chula Vista','Suburban',0),
        ('8018','Downtown Chula Vista','Suburban',0),
        ('8019','Downtown Chula Vista','Suburban',0),
        ('8020','Downtown Chula Vista','Suburban',0),
        ('8021','Downtown Chula Vista','Suburban',0),
        ('8023','Downtown Chula Vista','Suburban',0),
        ('8025','Downtown Chula Vista','Suburban',0),
        ('8026','Downtown Chula Vista','Suburban',0),
        ('8030','Downtown Chula Vista','Suburban',0),
        ('8031','Downtown Chula Vista','Suburban',0),
        ('8032','Downtown Chula Vista','Suburban',0),
        ('8033','Downtown Chula Vista','Suburban',0),
        ('8034','Downtown Chula Vista','Suburban',0),
        ('8035','Downtown Chula Vista','Suburban',0),
        ('8036','Southwest Chula Vista','Suburban',0),
        ('8037','Southwest Chula Vista','Suburban',0),
        ('8038','Southwest Chula Vista','Suburban',0),
        ('8039','Downtown Chula Vista','Suburban',0),
        ('8040','Downtown Chula Vista','Suburban',0),
        ('8041','Downtown Chula Vista','Suburban',0),
        ('8042','Downtown Chula Vista','Suburban',0),
        ('8043','Downtown Chula Vista','Suburban',0),
        ('8044','Downtown Chula Vista','Suburban',0),
        ('8045','Downtown Chula Vista','Suburban',0),
        ('8046','Downtown Chula Vista','Suburban',0),
        ('8047','Downtown Chula Vista','Suburban',0),
        ('8048','Downtown Chula Vista','Suburban',0),
        ('8049','Downtown Chula Vista','Suburban',0),
        ('8050','Downtown Chula Vista','Suburban',0),
        ('8051','Downtown Chula Vista','Suburban',0),
        ('8052','Downtown Chula Vista','Suburban',0),
        ('8053','Downtown Chula Vista','Suburban',0),
        ('8054','Downtown Chula Vista','Suburban',0),
        ('8055','Downtown Chula Vista','Suburban',0),
        ('8056','Downtown Chula Vista','Suburban',0),
        ('8057','Downtown Chula Vista','Suburban',0),
        ('8058','Downtown Chula Vista','Suburban',0),
        ('8061','Downtown Chula Vista','Suburban',0),
        ('8062','Downtown Chula Vista','Suburban',0),
        ('8066','Downtown Chula Vista','Suburban',0),
        ('8068','Downtown Chula Vista','Suburban',0),
        ('8070','Downtown Chula Vista','Suburban',0),
        ('8071','Downtown Chula Vista','Suburban',0),
        ('8072','Downtown Chula Vista','Suburban',0),
        ('8073','Downtown Chula Vista','Suburban',0),
        ('8074','Downtown Chula Vista','Suburban',0),
        ('8075','Downtown Chula Vista','Suburban',0),
        ('8076','Downtown Chula Vista','Suburban',0),
        ('8077','Downtown Chula Vista','Suburban',0),
        ('8078','Downtown Chula Vista','Suburban',0),
        ('8080','Downtown Chula Vista','Suburban',0),
        ('8084','Southwest Chula Vista','Suburban',0),
        ('8085','Southwest Chula Vista','Suburban',0),
        ('8086','Southwest Chula Vista','Suburban',0),
        ('8096','Downtown Chula Vista','Suburban',0),
        ('8097','Downtown Chula Vista','Suburban',0),
        ('8098','Downtown Chula Vista','Suburban',0),
        ('8100','Downtown Chula Vista','Suburban',0),
        ('8101','Downtown Chula Vista','Suburban',0),
        ('8102','Downtown Chula Vista','Suburban',0),
        ('8103','Downtown Chula Vista','Suburban',0),
        ('8104','Downtown Chula Vista','Suburban',0),
        ('8105','Downtown Chula Vista','Suburban',0),
        ('8106','Downtown Chula Vista','Suburban',0),
        ('8107','Downtown Chula Vista','Suburban',0),
        ('8108','Downtown Chula Vista','Suburban',0),
        ('8109','Downtown Chula Vista','Suburban',0),
        ('8110','Downtown Chula Vista','Suburban',0),
        ('8111','Downtown Chula Vista','Suburban',0),
        ('8112','Downtown Chula Vista','Suburban',0),
        ('8113','Downtown Chula Vista','Suburban',0),
        ('8114','Downtown Chula Vista','Suburban',0),
        ('8115','Downtown Chula Vista','Suburban',0),
        ('8116','Downtown Chula Vista','Suburban',0),
        ('8117','Southwest Chula Vista','Suburban',0),
        ('8118','Southwest Chula Vista','Suburban',0),
        ('8119','Southwest Chula Vista','Suburban',0),
        ('8120','Southwest Chula Vista','Suburban',0),
        ('8121','Southwest Chula Vista','Suburban',0),
        ('8122','Southwest Chula Vista','Suburban',0),
        ('8123','Southwest Chula Vista','Suburban',0),
        ('8124','Downtown Chula Vista','Suburban',0),
        ('8125','Downtown Chula Vista','Suburban',0),
        ('8126','Downtown Chula Vista','Suburban',0),
        ('8127','Downtown Chula Vista','Suburban',0),
        ('8128','Downtown Chula Vista','Suburban',0),
        ('8129','Downtown Chula Vista','Suburban',0),
        ('8132','Southwest Chula Vista','Suburban',0),
        ('8133','Southwest Chula Vista','Suburban',0),
        ('8135','Southwest Chula Vista','Suburban',0),
        ('8136','Southwest Chula Vista','Suburban',0),
        ('8137','Southwest Chula Vista','Suburban',0),
        ('8138','Southwest Chula Vista','Suburban',0),
        ('8139','Southwest Chula Vista','Suburban',0),
        ('8140','Southwest Chula Vista','Suburban',0),
        ('8141','Southwest Chula Vista','Suburban',0),
        ('8142','Southwest Chula Vista','Suburban',0),
        ('8143','Southwest Chula Vista','Suburban',0),
        ('8144','Southwest Chula Vista','Suburban',0),
        ('8145','Southwest Chula Vista','Suburban',0),
        ('8146','Southwest Chula Vista','Suburban',0),
        ('8147','Southwest Chula Vista','Suburban',0),
        ('8148','Southwest Chula Vista','Suburban',0),
        ('8149','Southwest Chula Vista','Suburban',0),
        ('8150','Southwest Chula Vista','Suburban',0),
        ('8151','Southwest Chula Vista','Suburban',0),
        ('8152','Southwest Chula Vista','Suburban',0),
        ('8153','Southwest Chula Vista','Suburban',0),
        ('8154','Southwest Chula Vista','Suburban',0),
        ('8155','Southwest Chula Vista','Suburban',0),
        ('8157','Southwest Chula Vista','Suburban',0),
        ('8159','Southwest Chula Vista','Suburban',0),
        ('8160','Southwest Chula Vista','Suburban',0),
        ('8161','Southwest Chula Vista','Suburban',0),
        ('8162','Southwest Chula Vista','Suburban',0),
        ('8163','Southwest Chula Vista','Suburban',0),
        ('8164','Southwest Chula Vista','Suburban',0),
        ('8165','Southwest Chula Vista','Suburban',0),
        ('8166','Southwest Chula Vista','Suburban',0),
        ('8167','Southwest Chula Vista','Suburban',0),
        ('8168','Southwest Chula Vista','Suburban',0),
        ('8169','Southwest Chula Vista','Suburban',0),
        ('8170','Southwest Chula Vista','Suburban',0),
        ('8171','Southwest Chula Vista','Suburban',0),
        ('8172','Southwest Chula Vista','Suburban',0),
        ('8173','Southwest Chula Vista','Suburban',0),
        ('8174','Southwest Chula Vista','Suburban',0),
        ('8175','Southwest Chula Vista','Suburban',0),
        ('8176','Southwest Chula Vista','Suburban',0),
        ('8177','Southwest Chula Vista','Suburban',0),
        ('8178','Southwest Chula Vista','Suburban',0),
        ('8179','Southwest Chula Vista','Suburban',0),
        ('8180','Southwest Chula Vista','Suburban',0),
        ('8181','Southwest Chula Vista','Suburban',0),
        ('8182','Southwest Chula Vista','Suburban',0),
        ('8183','Southwest Chula Vista','Suburban',0),
        ('8184','Southwest Chula Vista','Suburban',0),
        ('8185','Southwest Chula Vista','Suburban',0),
        ('8186','Southwest Chula Vista','Suburban',0),
        ('8187','Southwest Chula Vista','Suburban',0),
        ('8188','Southwest Chula Vista','Suburban',0),
        ('8189','Southwest Chula Vista','Suburban',0),
        ('8190','Southwest Chula Vista','Suburban',0),
        ('8191','Southwest Chula Vista','Suburban',0),
        ('8192','Southwest Chula Vista','Suburban',0),
        ('8193','Southwest Chula Vista','Suburban',0),
        ('8194','Southwest Chula Vista','Suburban',0),
        ('8195','Southwest Chula Vista','Suburban',0),
        ('8196','Southwest Chula Vista','Suburban',0),
        ('8197','Southwest Chula Vista','Suburban',0),
        ('8198','Southwest Chula Vista','Suburban',0),
        ('8199','Southwest Chula Vista','Suburban',0),
        ('8200','Southwest Chula Vista','Suburban',0),
        ('8201','Southwest Chula Vista','Suburban',0),
        ('8202','Southwest Chula Vista','Suburban',0),
        ('8203','Southwest Chula Vista','Suburban',0),
        ('8204','Southwest Chula Vista','Suburban',0),
        ('8205','Southwest Chula Vista','Suburban',0),
        ('8206','Southwest Chula Vista','Suburban',0),
        ('8207','Southwest Chula Vista','Suburban',0),
        ('8208','Southwest Chula Vista','Suburban',0),
        ('8209','Southwest Chula Vista','Suburban',0),
        ('8210','Southwest Chula Vista','Suburban',0),
        ('8211','Southwest Chula Vista','Suburban',0),
        ('8212','Southwest Chula Vista','Suburban',0),
        ('8213','Southwest Chula Vista','Suburban',0),
        ('8214','Southwest Chula Vista','Suburban',0),
        ('8215','Southwest Chula Vista','Suburban',0),
        ('8216','Southwest Chula Vista','Suburban',0),
        ('8217','Southwest Chula Vista','Suburban',0),
        ('8218','Southwest Chula Vista','Suburban',0),
        ('8219','Southwest Chula Vista','Suburban',0),
        ('8220','Southwest Chula Vista','Suburban',0),
        ('8221','Southwest Chula Vista','Suburban',0),
        ('8222','Southwest Chula Vista','Suburban',0),
        ('8223','Southwest Chula Vista','Suburban',0),
        ('8224','Southwest Chula Vista','Suburban',0),
        ('8225','Southwest Chula Vista','Suburban',0),
        ('8226','Southwest Chula Vista','Suburban',0),
        ('8227','Southwest Chula Vista','Suburban',0),
        ('8228','Southwest Chula Vista','Suburban',0),
        ('8229','Southwest Chula Vista','Suburban',0),
        ('8230','Southwest Chula Vista','Suburban',0),
        ('8231','Southwest Chula Vista','Suburban',0),
        ('8232','Southwest Chula Vista','Suburban',0),
        ('8233','Southwest Chula Vista','Suburban',0),
        ('8234','Southwest Chula Vista','Suburban',0),
        ('8235','Southwest Chula Vista','Suburban',0),
        ('8236','Southwest Chula Vista','Suburban',0),
        ('8237','Southwest Chula Vista','Suburban',0),
        ('8238','Southwest Chula Vista','Suburban',0),
        ('8239','Southwest Chula Vista','Suburban',0),
        ('8240','Southwest Chula Vista','Suburban',0),
        ('8241','Southwest Chula Vista','Suburban',0),
        ('8242','Southwest Chula Vista','Suburban',0),
        ('8243','Southwest Chula Vista','Suburban',0),
        ('8244','Southwest Chula Vista','Suburban',0),
        ('8245','Southwest Chula Vista','Suburban',0),
        ('8246','Southwest Chula Vista','Suburban',0),
        ('8247','Southwest Chula Vista','Suburban',0),
        ('8248','Southwest Chula Vista','Suburban',0),
        ('8249','Southwest Chula Vista','Suburban',0),
        ('8250','Southwest Chula Vista','Suburban',0),
        ('8251','Southwest Chula Vista','Suburban',0),
        ('8252','Southwest Chula Vista','Suburban',0),
        ('8253','Southwest Chula Vista','Suburban',0),
        ('8254','Southwest Chula Vista','Suburban',0),
        ('8255','Southwest Chula Vista','Suburban',0),
        ('8256','Southwest Chula Vista','Suburban',0),
        ('8258','Southwest Chula Vista','Suburban',0),
        ('8259','Southwest Chula Vista','Suburban',0),
        ('8261','Southwest Chula Vista','Suburban',0),
        ('8262','Southwest Chula Vista','Suburban',0),
        ('8263','Southwest Chula Vista','Suburban',0),
        ('8264','Southwest Chula Vista','Suburban',0),
        ('8265','Southwest Chula Vista','Suburban',0),
        ('8266','Southwest Chula Vista','Suburban',0)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('8267','Southwest Chula Vista','Suburban',0),
        ('8268','Southwest Chula Vista','Suburban',0),
        ('8296','Southwest Chula Vista','Suburban',0),
        ('8301','Southwest Chula Vista','Suburban',0),
        ('8303','Southwest Chula Vista','Suburban',0),
        ('8304','Southwest Chula Vista','Suburban',0),
        ('8305','Southwest Chula Vista','Suburban',0),
        ('8306','Southwest Chula Vista','Suburban',0),
        ('8307','Southwest Chula Vista','Suburban',0),
        ('8308','Southwest Chula Vista','Suburban',0),
        ('8311','Southwest Chula Vista','Suburban',0),
        ('8344','Southwest Chula Vista','Suburban',0),
        ('8345','Southwest Chula Vista','Suburban',0),
        ('8346','Southwest Chula Vista','Suburban',0),
        ('8347','Southwest Chula Vista','Suburban',0),
        ('8349','Southwest Chula Vista','Suburban',0),
        ('8367','Southwest Chula Vista','Suburban',0),
        ('8398','Otay Ranch','Suburban',0),
        ('8399','Otay Ranch','Suburban',0),
        ('8405','Otay Ranch','Suburban',0),
        ('8406','Otay Ranch','Suburban',0),
        ('8407','Otay Ranch','Suburban',0),
        ('8408','Otay Ranch','Suburban',0),
        ('8409','Otay Ranch','Suburban',0),
        ('8410','Otay Ranch','Suburban',0),
        ('8411','Otay Ranch','Suburban',0),
        ('8412','Otay Ranch','Suburban',0),
        ('8415','Otay Ranch','Suburban',0),
        ('8416','Otay Ranch','Suburban',0),
        ('8417','Otay Ranch','Suburban',0),
        ('8418','Otay Ranch','Suburban',0),
        ('8419','Otay Ranch','Suburban',0),
        ('8420','Otay Ranch','Suburban',0),
        ('8421','Otay Ranch','Suburban',0),
        ('8422','Otay Ranch','Suburban',0),
        ('8423','Otay Ranch','Suburban',0),
        ('8424','Otay Ranch','Suburban',0),
        ('8425','Otay Ranch','Suburban',0),
        ('8426','Otay Ranch','Suburban',0),
        ('8427','Otay Ranch','Suburban',0),
        ('8428','Otay Ranch','Suburban',0),
        ('8429','Otay Ranch','Suburban',0),
        ('8430','Otay Ranch','Suburban',0),
        ('8431','Otay Ranch','Suburban',0),
        ('8432','Otay Ranch','Suburban',0),
        ('8433','Otay Ranch','Suburban',0),
        ('8434','Otay Ranch','Suburban',0),
        ('8449','Otay Ranch','Suburban',0),
        ('8450','Otay Ranch','Suburban',0),
        ('8451','Otay Ranch','Suburban',0),
        ('8452','Otay Ranch','Suburban',0),
        ('8453','Otay Ranch','Suburban',0),
        ('8454','Otay Ranch','Suburban',0),
        ('8455','Otay Ranch','Suburban',0),
        ('8456','Otay Ranch','Suburban',0),
        ('8457','Otay Ranch','Suburban',0),
        ('8458','Otay Ranch','Suburban',0),
        ('8459','Otay Ranch','Suburban',0),
        ('8461','Otay Ranch','Suburban',0),
        ('8462','Otay Ranch','Suburban',0),
        ('8463','Otay Ranch','Suburban',0),
        ('8464','Otay Ranch','Suburban',0),
        ('8466','Otay Ranch','Suburban',0),
        ('8468','Otay Ranch','Suburban',0),
        ('8470','Otay Ranch','Suburban',0),
        ('8471','Otay Ranch','Suburban',0),
        ('8481','Otay Ranch','Suburban',0),
        ('8482','Otay Ranch','Suburban',0),
        ('8499','Otay Ranch','Suburban',0),
        ('8501','Otay Ranch','Suburban',0),
        ('8502','Otay Ranch','Suburban',0),
        ('8503','Otay Ranch','Suburban',0),
        ('8504','Otay Ranch','Suburban',0),
        ('8505','Otay Ranch','Suburban',0),
        ('8506','Otay Ranch','Suburban',0),
        ('8507','Otay Ranch','Suburban',0),
        ('8508','Otay Ranch','Suburban',0),
        ('8509','Otay Ranch','Suburban',0),
        ('8510','Otay Ranch','Suburban',0),
        ('8511','Otay Ranch','Suburban',0),
        ('8512','Otay Ranch','Suburban',0),
        ('8514','Otay Ranch','Suburban',0),
        ('8516','Otay Ranch','Suburban',0),
        ('8518','Otay Ranch','Suburban',0),
        ('8519','Otay Ranch','Suburban',0),
        ('8520','Otay Ranch','Suburban',0),
        ('8522','Otay Ranch','Suburban',0),
        ('8523','Otay Ranch','Suburban',0),
        ('8526','Otay Ranch','Suburban',0),
        ('8665','Otay Ranch','Suburban',0),
        ('8674','Otay Ranch','Suburban',0),
        ('8675','Otay Ranch','Suburban',0),
        ('8680','Otay Ranch','Suburban',0),
        ('8681','Otay Ranch','Suburban',0),
        ('8682','Otay Ranch','Suburban',0),
        ('8683','Otay Ranch','Suburban',0),
        ('8684','Otay Ranch','Suburban',0),
        ('8692','Otay Ranch','Suburban',0),
        ('8694','Otay Ranch','Suburban',0),
        ('8695','Otay Ranch','Suburban',0),
        ('8707','Otay Ranch','Suburban',0),
        ('8708','Otay Ranch','Suburban',0),
        ('8717','Otay Ranch','Suburban',0),
        ('8723','Otay Ranch','Suburban',0),
        ('8728','Otay Ranch','Suburban',0),
        ('8729','Otay Ranch','Suburban',0),
        ('8730','Otay Ranch','Suburban',0),
        ('8731','Otay Ranch','Suburban',0),
        ('9220','Lemon Grove','Suburban',0),
        ('9221','Lemon Grove','Suburban',0),
        ('9222','Lemon Grove','Suburban',0),
        ('9223','Lemon Grove','Suburban',0),
        ('9224','Lemon Grove','Suburban',0),
        ('9225','Lemon Grove','Suburban',0),
        ('9226','Lemon Grove','Suburban',0),
        ('9227','Lemon Grove','Suburban',0),
        ('9228','Lemon Grove','Suburban',0),
        ('9229','Lemon Grove','Suburban',0),
        ('9230','Lemon Grove','Suburban',0),
        ('9231','Lemon Grove','Suburban',0),
        ('9232','Lemon Grove','Suburban',0),
        ('9234','Lemon Grove','Suburban',0),
        ('9235','Lemon Grove','Suburban',0),
        ('9236','Lemon Grove','Suburban',0),
        ('9237','Lemon Grove','Suburban',0),
        ('9238','Lemon Grove','Suburban',0),
        ('9239','Lemon Grove','Suburban',0),
        ('9240','Lemon Grove','Suburban',0),
        ('9241','Lemon Grove','Suburban',0),
        ('9242','Lemon Grove','Suburban',0),
        ('9243','Lemon Grove','Suburban',0),
        ('9244','Lemon Grove','Suburban',0),
        ('9245','Lemon Grove','Suburban',0),
        ('9246','Lemon Grove','Suburban',0),
        ('9247','Lemon Grove','Suburban',0),
        ('9248','Lemon Grove','Suburban',0),
        ('9249','Lemon Grove','Suburban',0),
        ('9250','Lemon Grove','Suburban',0),
        ('9251','Lemon Grove','Suburban',0),
        ('9252','Lemon Grove','Suburban',0),
        ('9253','Lemon Grove','Suburban',0),
        ('9254','Lemon Grove','Suburban',0),
        ('9255','Lemon Grove','Suburban',0),
        ('9256','Lemon Grove','Suburban',0),
        ('9257','Lemon Grove','Suburban',0),
        ('9264','Lemon Grove','Suburban',0),
        ('9265','Lemon Grove','Suburban',0),
        ('9266','Lemon Grove','Suburban',0),
        ('9267','Lemon Grove','Suburban',0),
        ('9268','Lemon Grove','Suburban',0),
        ('9269','Lemon Grove','Suburban',0),
        ('9270','Lemon Grove','Suburban',0),
        ('9271','Lemon Grove','Suburban',0),
        ('9272','Lemon Grove','Suburban',0),
        ('9273','Lemon Grove','Suburban',0),
        ('9274','Lemon Grove','Suburban',0),
        ('9279','Lemon Grove','Suburban',0),
        ('9280','Lemon Grove','Suburban',0),
        ('9281','Lemon Grove','Suburban',0),
        ('9282','Lemon Grove','Suburban',0),
        ('9283','Lemon Grove','Suburban',0),
        ('9284','Lemon Grove','Suburban',0),
        ('9285','Lemon Grove','Suburban',0),
        ('9286','Lemon Grove','Suburban',0),
        ('9287','Lemon Grove','Suburban',0),
        ('9288','Lemon Grove','Suburban',0),
        ('9289','Lemon Grove','Suburban',0),
        ('9290','Lemon Grove','Suburban',0),
        ('9291','Lemon Grove','Suburban',0),
        ('9292','Lemon Grove','Suburban',0),
        ('9293','Lemon Grove','Suburban',0),
        ('9294','Lemon Grove','Suburban',0),
        ('9295','Lemon Grove','Suburban',0),
        ('9296','Lemon Grove','Suburban',0),
        ('9297','Lemon Grove','Suburban',0),
        ('9298','Lemon Grove','Suburban',0),
        ('9299','Lemon Grove','Suburban',0),
        ('9300','Lemon Grove','Suburban',0),
        ('9301','Lemon Grove','Suburban',0),
        ('9302','Lemon Grove','Suburban',0),
        ('9313','Lemon Grove','Suburban',0),
        ('9315','Lemon Grove','Suburban',0),
        ('9318','Lemon Grove','Suburban',0),
        ('9319','Lemon Grove','Suburban',0),
        ('9320','Lemon Grove','Suburban',0),
        ('9321','Lemon Grove','Suburban',0),
        ('9322','Lemon Grove','Suburban',0),
        ('9323','Lemon Grove','Suburban',0),
        ('9324','Lemon Grove','Suburban',0),
        ('9325','Lemon Grove','Suburban',0),
        ('9326','Lemon Grove','Suburban',0),
        ('9327','Lemon Grove','Suburban',0),
        ('9328','Lemon Grove','Suburban',0),
        ('9329','Lemon Grove','Suburban',0),
        ('9330','Lemon Grove','Suburban',0),
        ('9331','Lemon Grove','Suburban',0),
        ('9332','Lemon Grove','Suburban',0),
        ('9333','Lemon Grove','Suburban',0),
        ('9334','Lemon Grove','Suburban',0),
        ('9335','Lemon Grove','Suburban',0),
        ('9336','Lemon Grove','Suburban',0),
        ('9337','Lemon Grove','Suburban',0),
        ('9338','Lemon Grove','Suburban',0),
        ('9339','Lemon Grove','Suburban',0),
        ('9340','Lemon Grove','Suburban',0),
        ('9341','Lemon Grove','Suburban',0),
        ('9342','Lemon Grove','Suburban',0),
        ('9343','Lemon Grove','Suburban',0),
        ('9344','Lemon Grove','Suburban',0),
        ('9345','Lemon Grove','Suburban',0),
        ('9346','Lemon Grove','Suburban',0),
        ('9347','Lemon Grove','Suburban',0),
        ('9348','Lemon Grove','Suburban',0),
        ('9349','Lemon Grove','Suburban',0),
        ('9350','Lemon Grove','Suburban',0),
        ('9351','Lemon Grove','Suburban',0),
        ('9352','Lemon Grove','Suburban',0),
        ('9353','Lemon Grove','Suburban',0),
        ('9354','Lemon Grove','Suburban',0),
        ('9355','Lemon Grove','Suburban',0),
        ('9356','Lemon Grove','Suburban',0),
        ('9357','Lemon Grove','Suburban',0),
        ('9358','Lemon Grove','Suburban',0),
        ('9359','Lemon Grove','Suburban',0),
        ('9360','Lemon Grove','Suburban',0),
        ('9361','Lemon Grove','Suburban',0),
        ('9362','Lemon Grove','Suburban',0),
        ('9363','Lemon Grove','Suburban',0),
        ('9364','Lemon Grove','Suburban',0),
        ('9365','Lemon Grove','Suburban',0),
        ('9367','Lemon Grove','Suburban',0),
        ('9368','Lemon Grove','Suburban',0),
        ('9369','Lemon Grove','Suburban',0),
        ('9370','Lemon Grove','Suburban',0),
        ('9371','Lemon Grove','Suburban',0),
        ('9372','Lemon Grove','Suburban',0),
        ('9373','Lemon Grove','Suburban',0),
        ('9374','Lemon Grove','Suburban',0),
        ('9375','Lemon Grove','Suburban',0),
        ('9376','Lemon Grove','Suburban',0),
        ('9377','Lemon Grove','Suburban',0),
        ('9378','Lemon Grove','Suburban',0),
        ('9380','Lemon Grove','Suburban',0),
        ('9381','Lemon Grove','Suburban',0),
        ('9382','Lemon Grove','Suburban',0),
        ('9383','Lemon Grove','Suburban',0),
        ('9384','Lemon Grove','Suburban',0),
        ('9385','Lemon Grove','Suburban',0),
        ('9386','Lemon Grove','Suburban',0),
        ('9387','Lemon Grove','Suburban',0),
        ('9388','Lemon Grove','Suburban',0),
        ('9389','Lemon Grove','Suburban',0),
        ('9390','Lemon Grove','Suburban',0),
        ('9391','Lemon Grove','Suburban',0),
        ('9392','Lemon Grove','Suburban',0),
        ('9393','Lemon Grove','Suburban',0),
        ('9394','Lemon Grove','Suburban',0),
        ('9395','Lemon Grove','Suburban',0),
        ('9396','Lemon Grove','Suburban',0),
        ('9397','Lemon Grove','Suburban',0),
        ('9398','Lemon Grove','Suburban',0),
        ('9399','Lemon Grove','Suburban',0),
        ('9400','Lemon Grove','Suburban',0),
        ('9401','Lemon Grove','Suburban',0),
        ('9402','Lemon Grove','Suburban',0),
        ('9403','Lemon Grove','Suburban',0),
        ('9404','Lemon Grove','Suburban',0),
        ('9405','Lemon Grove','Suburban',0),
        ('9406','Lemon Grove','Suburban',0),
        ('9408','Lemon Grove','Suburban',0),
        ('9409','Lemon Grove','Suburban',0),
        ('9410','Lemon Grove','Suburban',0),
        ('9411','Lemon Grove','Suburban',0),
        ('9412','Lemon Grove','Suburban',0),
        ('9413','Lemon Grove','Suburban',0),
        ('9414','Lemon Grove','Suburban',0),
        ('9415','Lemon Grove','Suburban',0),
        ('9416','Lemon Grove','Suburban',0),
        ('9417','Lemon Grove','Suburban',0),
        ('9418','Lemon Grove','Suburban',0),
        ('9419','Lemon Grove','Suburban',0),
        ('9420','Lemon Grove','Suburban',0),
        ('9421','Lemon Grove','Suburban',0),
        ('9422','Lemon Grove','Suburban',0),
        ('9423','Lemon Grove','Suburban',0),
        ('9424','Lemon Grove','Suburban',0),
        ('9425','Lemon Grove','Suburban',0),
        ('9426','Lemon Grove','Suburban',0),
        ('9427','Lemon Grove','Suburban',0),
        ('9428','Lemon Grove','Suburban',0),
        ('9429','Lemon Grove','Suburban',0),
        ('9432','La Mesa','Suburban',1),
        ('9449','La Mesa','Suburban',1),
        ('9458','La Mesa','Suburban',1),
        ('9459','La Mesa','Suburban',1),
        ('9460','La Mesa','Suburban',1),
        ('9461','La Mesa','Suburban',1),
        ('9462','La Mesa','Suburban',1),
        ('9463','La Mesa','Suburban',1),
        ('9464','La Mesa','Suburban',1),
        ('9465','La Mesa','Suburban',1),
        ('9466','La Mesa','Suburban',1),
        ('9467','La Mesa','Suburban',1),
        ('9468','La Mesa','Suburban',1),
        ('9469','La Mesa','Suburban',1),
        ('9470','La Mesa','Suburban',1),
        ('9471','La Mesa','Suburban',1),
        ('9472','La Mesa','Suburban',1),
        ('9473','La Mesa','Suburban',1),
        ('9474','La Mesa','Suburban',1),
        ('9475','La Mesa','Suburban',1),
        ('9476','La Mesa','Suburban',1),
        ('9477','La Mesa','Suburban',1),
        ('9478','La Mesa','Suburban',1),
        ('9479','La Mesa','Suburban',1),
        ('9480','La Mesa','Suburban',1),
        ('9481','La Mesa','Suburban',1),
        ('9482','La Mesa','Suburban',1),
        ('9483','La Mesa','Suburban',1),
        ('9484','La Mesa','Suburban',1),
        ('9485','La Mesa','Suburban',1),
        ('9486','La Mesa','Suburban',1),
        ('9487','La Mesa','Suburban',1),
        ('9488','La Mesa','Suburban',1),
        ('9489','La Mesa','Suburban',1),
        ('9490','La Mesa','Suburban',1),
        ('9491','La Mesa','Suburban',1),
        ('9492','La Mesa','Suburban',1),
        ('9493','La Mesa','Suburban',1),
        ('9495','La Mesa','Suburban',1),
        ('9496','La Mesa','Suburban',1),
        ('9497','La Mesa','Suburban',1),
        ('9498','La Mesa','Suburban',1),
        ('9499','La Mesa','Suburban',1),
        ('9500','La Mesa','Suburban',1),
        ('9501','La Mesa','Suburban',1),
        ('9502','La Mesa','Suburban',1),
        ('9503','La Mesa','Suburban',1),
        ('9504','La Mesa','Suburban',1),
        ('9505','La Mesa','Suburban',1),
        ('9506','La Mesa','Suburban',1),
        ('9507','La Mesa','Suburban',1),
        ('9508','La Mesa','Suburban',1),
        ('9509','La Mesa','Suburban',1),
        ('9510','La Mesa','Suburban',1),
        ('9511','La Mesa','Suburban',1),
        ('9512','La Mesa','Suburban',1),
        ('9513','La Mesa','Suburban',1),
        ('9514','La Mesa','Suburban',1),
        ('9515','La Mesa','Suburban',1),
        ('9516','La Mesa','Suburban',1),
        ('9517','La Mesa','Suburban',1),
        ('9518','La Mesa','Suburban',1),
        ('9519','La Mesa','Suburban',1),
        ('9520','La Mesa','Suburban',1),
        ('9521','La Mesa','Suburban',1),
        ('9522','La Mesa','Suburban',1),
        ('9523','La Mesa','Suburban',1),
        ('9524','La Mesa','Suburban',1),
        ('9525','La Mesa','Suburban',1),
        ('9528','La Mesa','Suburban',1),
        ('9529','La Mesa','Suburban',1),
        ('9530','La Mesa','Suburban',1),
        ('9531','La Mesa','Suburban',1),
        ('9543','La Mesa','Suburban',1),
        ('9544','La Mesa','Suburban',1),
        ('9545','La Mesa','Suburban',1),
        ('9546','La Mesa','Suburban',1),
        ('9547','La Mesa','Suburban',1),
        ('9548','La Mesa','Suburban',1),
        ('9549','La Mesa','Suburban',1),
        ('9550','La Mesa','Suburban',1),
        ('9551','La Mesa','Suburban',1),
        ('9552','La Mesa','Suburban',1),
        ('9553','La Mesa','Suburban',1),
        ('9554','La Mesa','Suburban',1),
        ('9555','La Mesa','Suburban',1),
        ('9556','La Mesa','Suburban',1),
        ('9557','La Mesa','Suburban',1),
        ('9558','La Mesa','Suburban',1),
        ('9559','La Mesa','Suburban',1),
        ('9560','La Mesa','Suburban',1),
        ('9561','La Mesa','Suburban',1),
        ('9562','La Mesa','Suburban',1),
        ('9563','La Mesa','Suburban',1),
        ('9564','La Mesa','Suburban',1),
        ('9565','La Mesa','Suburban',1),
        ('9566','La Mesa','Suburban',1),
        ('9567','La Mesa','Suburban',1),
        ('9568','La Mesa','Suburban',1),
        ('9569','La Mesa','Suburban',1),
        ('9570','La Mesa','Suburban',1),
        ('9571','La Mesa','Suburban',1),
        ('9572','La Mesa','Suburban',1),
        ('9573','La Mesa','Suburban',1),
        ('9574','La Mesa','Suburban',1),
        ('9575','La Mesa','Suburban',1),
        ('9576','La Mesa','Suburban',1),
        ('9577','La Mesa','Suburban',1),
        ('9581','La Mesa','Suburban',1),
        ('9596','La Mesa','Suburban',1),
        ('9597','La Mesa','Suburban',1),
        ('9598','La Mesa','Suburban',1),
        ('9599','La Mesa','Suburban',1),
        ('9600','La Mesa','Suburban',1),
        ('9601','La Mesa','Suburban',1),
        ('9602','La Mesa','Suburban',1),
        ('9603','La Mesa','Suburban',1),
        ('9604','La Mesa','Suburban',1),
        ('9605','La Mesa','Suburban',1),
        ('9606','La Mesa','Suburban',1),
        ('9607','La Mesa','Suburban',1),
        ('9608','La Mesa','Suburban',1),
        ('9609','La Mesa','Suburban',1),
        ('9610','La Mesa','Suburban',1),
        ('9611','La Mesa','Suburban',1),
        ('9612','La Mesa','Suburban',1),
        ('9613','La Mesa','Suburban',1),
        ('9614','La Mesa','Suburban',1),
        ('9615','La Mesa','Suburban',1),
        ('9616','La Mesa','Suburban',1),
        ('9617','La Mesa','Suburban',1),
        ('9618','La Mesa','Suburban',1),
        ('9619','La Mesa','Suburban',1),
        ('9620','La Mesa','Suburban',1),
        ('9621','La Mesa','Suburban',1),
        ('9622','La Mesa','Suburban',1),
        ('9623','La Mesa','Suburban',1),
        ('9624','La Mesa','Suburban',1),
        ('9625','La Mesa','Suburban',1),
        ('9626','La Mesa','Suburban',1),
        ('9627','La Mesa','Suburban',1),
        ('9628','La Mesa','Suburban',1),
        ('9629','La Mesa','Suburban',1),
        ('9630','La Mesa','Suburban',1),
        ('9631','La Mesa','Suburban',1),
        ('9632','La Mesa','Suburban',1),
        ('9633','La Mesa','Suburban',1),
        ('9634','La Mesa','Suburban',1),
        ('9635','La Mesa','Suburban',1),
        ('9636','La Mesa','Suburban',1),
        ('9637','La Mesa','Suburban',1),
        ('9638','La Mesa','Suburban',1),
        ('9639','La Mesa','Suburban',1),
        ('9640','La Mesa','Suburban',1),
        ('9641','La Mesa','Suburban',1),
        ('9642','La Mesa','Suburban',1),
        ('9643','La Mesa','Suburban',1),
        ('9644','La Mesa','Suburban',1),
        ('9645','La Mesa','Suburban',1),
        ('9646','La Mesa','Suburban',1),
        ('9647','La Mesa','Suburban',1),
        ('9648','La Mesa','Suburban',1),
        ('9649','La Mesa','Suburban',1),
        ('9650','La Mesa','Suburban',1),
        ('9651','La Mesa','Suburban',1),
        ('9652','La Mesa','Suburban',1),
        ('9653','La Mesa','Suburban',1),
        ('9654','La Mesa','Suburban',1),
        ('9657','La Mesa','Suburban',1),
        ('9658','La Mesa','Suburban',1),
        ('9659','La Mesa','Suburban',1),
        ('9660','La Mesa','Suburban',1),
        ('9661','La Mesa','Suburban',1),
        ('9662','La Mesa','Suburban',1),
        ('9663','La Mesa','Suburban',1),
        ('9664','La Mesa','Suburban',1),
        ('9665','La Mesa','Suburban',1),
        ('9666','La Mesa','Suburban',1),
        ('9667','La Mesa','Suburban',1),
        ('9668','La Mesa','Suburban',1),
        ('9669','La Mesa','Suburban',1),
        ('9670','La Mesa','Suburban',1),
        ('9671','La Mesa','Suburban',1),
        ('9672','La Mesa','Suburban',1),
        ('9673','La Mesa','Suburban',1),
        ('9674','La Mesa','Suburban',1),
        ('9675','La Mesa','Suburban',1),
        ('9676','La Mesa','Suburban',1),
        ('9677','La Mesa','Suburban',1),
        ('9678','La Mesa','Suburban',1),
        ('9679','La Mesa','Suburban',1),
        ('9680','La Mesa','Suburban',1),
        ('9681','La Mesa','Suburban',1),
        ('9682','La Mesa','Suburban',1),
        ('9683','La Mesa','Suburban',1),
        ('9684','La Mesa','Suburban',1),
        ('9685','La Mesa','Suburban',1),
        ('9686','La Mesa','Suburban',1),
        ('9687','La Mesa','Suburban',1),
        ('9688','La Mesa','Suburban',1),
        ('9689','La Mesa','Suburban',1),
        ('9690','La Mesa','Suburban',1),
        ('9691','La Mesa','Suburban',1),
        ('9692','La Mesa','Suburban',1),
        ('9693','La Mesa','Suburban',1),
        ('9694','La Mesa','Suburban',1),
        ('9695','La Mesa','Suburban',1),
        ('9696','La Mesa','Suburban',1),
        ('9697','La Mesa','Suburban',1),
        ('9698','La Mesa','Suburban',1),
        ('9699','La Mesa','Suburban',1),
        ('9700','La Mesa','Suburban',1),
        ('9701','La Mesa','Suburban',1),
        ('9702','La Mesa','Suburban',1),
        ('9703','La Mesa','Suburban',1),
        ('9704','La Mesa','Suburban',1),
        ('9705','La Mesa','Suburban',1),
        ('9706','La Mesa','Suburban',1),
        ('9707','La Mesa','Suburban',1),
        ('9708','La Mesa','Suburban',1),
        ('9709','La Mesa','Suburban',1),
        ('9710','La Mesa','Suburban',1),
        ('9711','La Mesa','Suburban',1),
        ('9712','La Mesa','Suburban',1),
        ('9713','La Mesa','Suburban',1),
        ('9714','La Mesa','Suburban',1),
        ('9715','La Mesa','Suburban',1),
        ('9716','La Mesa','Suburban',1),
        ('9717','La Mesa','Suburban',1),
        ('9718','La Mesa','Suburban',1),
        ('9719','La Mesa','Suburban',1),
        ('9720','La Mesa','Suburban',1),
        ('9721','La Mesa','Suburban',1),
        ('9722','La Mesa','Suburban',1),
        ('9723','La Mesa','Suburban',1),
        ('9724','La Mesa','Suburban',1),
        ('9725','La Mesa','Suburban',1),
        ('9726','La Mesa','Suburban',1),
        ('9727','La Mesa','Suburban',1),
        ('9728','La Mesa','Suburban',1),
        ('9729','La Mesa','Suburban',1),
        ('9730','La Mesa','Suburban',1),
        ('9731','La Mesa','Suburban',1),
        ('9732','La Mesa','Suburban',1),
        ('9733','La Mesa','Suburban',1),
        ('9734','La Mesa','Suburban',1),
        ('9735','La Mesa','Suburban',1),
        ('9736','La Mesa','Suburban',1),
        ('9737','La Mesa','Suburban',1),
        ('9738','La Mesa','Suburban',1),
        ('9739','La Mesa','Suburban',1),
        ('9740','La Mesa','Suburban',1),
        ('9741','La Mesa','Suburban',1),
        ('9742','La Mesa','Suburban',1),
        ('9743','La Mesa','Suburban',1),
        ('9744','La Mesa','Suburban',1),
        ('9745','La Mesa','Suburban',1),
        ('9746','La Mesa','Suburban',1),
        ('9747','La Mesa','Suburban',1),
        ('9748','La Mesa','Suburban',1),
        ('9749','La Mesa','Suburban',1),
        ('9750','La Mesa','Suburban',1),
        ('9751','La Mesa','Suburban',1),
        ('9752','La Mesa','Suburban',1),
        ('9753','La Mesa','Suburban',1),
        ('9754','La Mesa','Suburban',1),
        ('9755','La Mesa','Suburban',1),
        ('9756','La Mesa','Suburban',1),
        ('9757','La Mesa','Suburban',1),
        ('9758','La Mesa','Suburban',1),
        ('9759','La Mesa','Suburban',1),
        ('9760','La Mesa','Suburban',1),
        ('9761','La Mesa','Suburban',1),
        ('9762','La Mesa','Suburban',1),
        ('9763','La Mesa','Suburban',1),
        ('9764','La Mesa','Suburban',1),
        ('9765','La Mesa','Suburban',1),
        ('9766','La Mesa','Suburban',1),
        ('9767','La Mesa','Suburban',1),
        ('9768','La Mesa','Suburban',1),
        ('9769','La Mesa','Suburban',1),
        ('9770','La Mesa','Suburban',1),
        ('9771','La Mesa','Suburban',1),
        ('9772','La Mesa','Suburban',1),
        ('9773','La Mesa','Suburban',1),
        ('9774','La Mesa','Suburban',1),
        ('9775','La Mesa','Suburban',1),
        ('9776','La Mesa','Suburban',1),
        ('9777','La Mesa','Suburban',1),
        ('9778','La Mesa','Suburban',1),
        ('9779','La Mesa','Suburban',1),
        ('9780','La Mesa','Suburban',1),
        ('9781','La Mesa','Suburban',1),
        ('9782','La Mesa','Suburban',1),
        ('9783','La Mesa','Suburban',1),
        ('9784','La Mesa','Suburban',1),
        ('9785','La Mesa','Suburban',1),
        ('9786','La Mesa','Suburban',1),
        ('9787','La Mesa','Suburban',1),
        ('9788','La Mesa','Suburban',1),
        ('9789','La Mesa','Suburban',1),
        ('9790','La Mesa','Suburban',1),
        ('9791','La Mesa','Suburban',1),
        ('9792','La Mesa','Suburban',1),
        ('9793','La Mesa','Suburban',1),
        ('9794','La Mesa','Suburban',1),
        ('9795','La Mesa','Suburban',1),
        ('9796','La Mesa','Suburban',1),
        ('9797','La Mesa','Suburban',1),
        ('9798','La Mesa','Suburban',1),
        ('9799','La Mesa','Suburban',1),
        ('9800','La Mesa','Suburban',1),
        ('9801','La Mesa','Suburban',1),
        ('9802','La Mesa','Suburban',1),
        ('9803','La Mesa','Suburban',1),
        ('9804','La Mesa','Suburban',1),
        ('9807','La Mesa','Suburban',1),
        ('9808','La Mesa','Suburban',1),
        ('9809','La Mesa','Suburban',1),
        ('9810','La Mesa','Suburban',1),
        ('9811','La Mesa','Suburban',1),
        ('9812','La Mesa','Suburban',1),
        ('9813','La Mesa','Suburban',1),
        ('9814','La Mesa','Suburban',1),
        ('9815','La Mesa','Suburban',1),
        ('9816','La Mesa','Suburban',1),
        ('9817','La Mesa','Suburban',1),
        ('9818','La Mesa','Suburban',1),
        ('9819','La Mesa','Suburban',1),
        ('9820','La Mesa','Suburban',1),
        ('9821','La Mesa','Suburban',1),
        ('9822','La Mesa','Suburban',1),
        ('9823','La Mesa','Suburban',1),
        ('9824','La Mesa','Suburban',1),
        ('9825','La Mesa','Suburban',1),
        ('9826','La Mesa','Suburban',1),
        ('9827','La Mesa','Suburban',1),
        ('9828','La Mesa','Suburban',1),
        ('9829','La Mesa','Suburban',1),
        ('9830','La Mesa','Suburban',1),
        ('9831','La Mesa','Suburban',1),
        ('9832','La Mesa','Suburban',1),
        ('9833','La Mesa','Suburban',1),
        ('9834','La Mesa','Suburban',1),
        ('9835','La Mesa','Suburban',1),
        ('9836','La Mesa','Suburban',1),
        ('9837','La Mesa','Suburban',1),
        ('9838','La Mesa','Suburban',1),
        ('9839','La Mesa','Suburban',1),
        ('9840','La Mesa','Suburban',1),
        ('9841','La Mesa','Suburban',1),
        ('9842','La Mesa','Suburban',1),
        ('9843','La Mesa','Suburban',1),
        ('9844','La Mesa','Suburban',1),
        ('9845','La Mesa','Suburban',1),
        ('9846','La Mesa','Suburban',1),
        ('9847','La Mesa','Suburban',1),
        ('9848','La Mesa','Suburban',1),
        ('9849','La Mesa','Suburban',1),
        ('9850','La Mesa','Suburban',1),
        ('9851','La Mesa','Suburban',1),
        ('9852','La Mesa','Suburban',1),
        ('9853','La Mesa','Suburban',1),
        ('9854','La Mesa','Suburban',1),
        ('9855','La Mesa','Suburban',1),
        ('9856','La Mesa','Suburban',1),
        ('9857','La Mesa','Suburban',1),
        ('9858','La Mesa','Suburban',1),
        ('9859','La Mesa','Suburban',1),
        ('9860','La Mesa','Suburban',1),
        ('9881','La Mesa','Suburban',1),
        ('9882','La Mesa','Suburban',1),
        ('9883','La Mesa','Suburban',1),
        ('9884','La Mesa','Suburban',1),
        ('9890','La Mesa','Suburban',1),
        ('9891','La Mesa','Suburban',1),
        ('9923','La Mesa','Suburban',1),
        ('9924','La Mesa','Suburban',1),
        ('9925','La Mesa','Suburban',1),
        ('9926','La Mesa','Suburban',1),
        ('9927','La Mesa','Suburban',1),
        ('9928','La Mesa','Suburban',1),
        ('9929','La Mesa','Suburban',1),
        ('9930','La Mesa','Suburban',1),
        ('9931','La Mesa','Suburban',1),
        ('9932','La Mesa','Suburban',1),
        ('9933','La Mesa','Suburban',1),
        ('9934','La Mesa','Suburban',1),
        ('9935','La Mesa','Suburban',1),
        ('9936','La Mesa','Suburban',1),
        ('9938','La Mesa','Suburban',1),
        ('9943','La Mesa','Suburban',1),
        ('9952','El Cajon','Gateway',1),
        ('9953','El Cajon','Gateway',1),
        ('9954','El Cajon','Gateway',1),
        ('9955','El Cajon','Gateway',1),
        ('9956','El Cajon','Gateway',1),
        ('9957','El Cajon','Gateway',1),
        ('9958','El Cajon','Gateway',1),
        ('9959','El Cajon','Gateway',1),
        ('9960','El Cajon','Gateway',1),
        ('9961','El Cajon','Gateway',1),
        ('9962','El Cajon','Gateway',1),
        ('9963','El Cajon','Gateway',1),
        ('9964','El Cajon','Gateway',1),
        ('9965','El Cajon','Gateway',1),
        ('10031','El Cajon','Gateway',1),
        ('10032','El Cajon','Gateway',1),
        ('10033','El Cajon','Gateway',1),
        ('10034','El Cajon','Gateway',1),
        ('10035','El Cajon','Gateway',1),
        ('10036','El Cajon','Gateway',1),
        ('10037','El Cajon','Gateway',1),
        ('10038','El Cajon','Gateway',1),
        ('10039','El Cajon','Gateway',1),
        ('10040','El Cajon','Gateway',1),
        ('10044','El Cajon','Gateway',1),
        ('10045','El Cajon','Gateway',1),
        ('10046','El Cajon','Gateway',1),
        ('10047','El Cajon','Gateway',1),
        ('10048','El Cajon','Gateway',1),
        ('10050','El Cajon','Gateway',1),
        ('10070','El Cajon','Gateway',1),
        ('10071','El Cajon','Gateway',1),
        ('10072','El Cajon','Gateway',1),
        ('10073','El Cajon','Gateway',1),
        ('10074','El Cajon','Gateway',1),
        ('10075','El Cajon','Gateway',1),
        ('10076','El Cajon','Gateway',1),
        ('10077','El Cajon','Gateway',1),
        ('10078','El Cajon','Gateway',1),
        ('10079','El Cajon','Gateway',1),
        ('10080','El Cajon','Gateway',1),
        ('10081','El Cajon','Gateway',1),
        ('10082','El Cajon','Gateway',1),
        ('10083','El Cajon','Gateway',1),
        ('10084','El Cajon','Gateway',1),
        ('10085','El Cajon','Gateway',1),
        ('10215','El Cajon','Gateway',1),
        ('10216','El Cajon','Gateway',1),
        ('10217','El Cajon','Gateway',1),
        ('10218','El Cajon','Gateway',1),
        ('10219','El Cajon','Gateway',1),
        ('10220','El Cajon','Gateway',1),
        ('10221','El Cajon','Gateway',1),
        ('10222','El Cajon','Gateway',1),
        ('10223','El Cajon','Gateway',1),
        ('10224','El Cajon','Gateway',1),
        ('10225','El Cajon','Gateway',1),
        ('10226','El Cajon','Gateway',1),
        ('10227','El Cajon','Gateway',1),
        ('10228','El Cajon','Gateway',1),
        ('10230','El Cajon','Gateway',1),
        ('10231','El Cajon','Gateway',1),
        ('10238','El Cajon','Gateway',1),
        ('10239','El Cajon','Gateway',1),
        ('10240','El Cajon','Gateway',1),
        ('10241','El Cajon','Gateway',1),
        ('10242','El Cajon','Gateway',1),
        ('10268','El Cajon','Gateway',1),
        ('10269','El Cajon','Gateway',1),
        ('10273','El Cajon','Gateway',1),
        ('10280','El Cajon','Gateway',1),
        ('10281','El Cajon','Gateway',1),
        ('10282','El Cajon','Gateway',1),
        ('10283','El Cajon','Gateway',1),
        ('10284','El Cajon','Gateway',1),
        ('10285','El Cajon','Gateway',1),
        ('10286','El Cajon','Gateway',1),
        ('10287','El Cajon','Gateway',1),
        ('10288','El Cajon','Gateway',1),
        ('10289','El Cajon','Gateway',1),
        ('10290','El Cajon','Gateway',1),
        ('10291','El Cajon','Gateway',1),
        ('10292','El Cajon','Gateway',1),
        ('10293','El Cajon','Gateway',1),
        ('10294','El Cajon','Gateway',1),
        ('10295','El Cajon','Gateway',1),
        ('10296','El Cajon','Gateway',1),
        ('10297','El Cajon','Gateway',1),
        ('10298','El Cajon','Gateway',1),
        ('10299','El Cajon','Gateway',1),
        ('10300','El Cajon','Gateway',1),
        ('10301','El Cajon','Gateway',1),
        ('10302','El Cajon','Gateway',1),
        ('10303','El Cajon','Gateway',1),
        ('10304','El Cajon','Gateway',1),
        ('10305','El Cajon','Gateway',1),
        ('10306','El Cajon','Gateway',1),
        ('10307','El Cajon','Gateway',1),
        ('10308','El Cajon','Gateway',1),
        ('10309','El Cajon','Gateway',1),
        ('10310','El Cajon','Gateway',1),
        ('10311','El Cajon','Gateway',1),
        ('10312','El Cajon','Gateway',1),
        ('10313','El Cajon','Gateway',1),
        ('10314','El Cajon','Gateway',1),
        ('10315','El Cajon','Gateway',1),
        ('10316','El Cajon','Gateway',1),
        ('10317','El Cajon','Gateway',1),
        ('10318','El Cajon','Gateway',1),
        ('10319','El Cajon','Gateway',1),
        ('10320','El Cajon','Gateway',1),
        ('10321','El Cajon','Gateway',1),
        ('10322','El Cajon','Gateway',1),
        ('10323','El Cajon','Gateway',1),
        ('10324','El Cajon','Gateway',1),
        ('10325','El Cajon','Gateway',1),
        ('10326','El Cajon','Gateway',1),
        ('10327','El Cajon','Gateway',1),
        ('10328','El Cajon','Gateway',1),
        ('10329','El Cajon','Gateway',1),
        ('10330','El Cajon','Gateway',1),
        ('10331','El Cajon','Gateway',1),
        ('10332','El Cajon','Gateway',1),
        ('10333','El Cajon','Gateway',1),
        ('10334','El Cajon','Gateway',1),
        ('10335','El Cajon','Gateway',1),
        ('10336','El Cajon','Gateway',1),
        ('10337','El Cajon','Gateway',1),
        ('10338','El Cajon','Gateway',1),
        ('10339','El Cajon','Gateway',1),
        ('10340','El Cajon','Gateway',1),
        ('10341','El Cajon','Gateway',1),
        ('10342','El Cajon','Gateway',1),
        ('10343','El Cajon','Gateway',1),
        ('10344','El Cajon','Gateway',1),
        ('10345','El Cajon','Gateway',1),
        ('10346','El Cajon','Gateway',1),
        ('10347','El Cajon','Gateway',1),
        ('10348','El Cajon','Gateway',1),
        ('10349','El Cajon','Gateway',1),
        ('10350','El Cajon','Gateway',1),
        ('10351','El Cajon','Gateway',1),
        ('10352','El Cajon','Gateway',1),
        ('10353','El Cajon','Gateway',1),
        ('10354','El Cajon','Gateway',1),
        ('10355','El Cajon','Gateway',1),
        ('10356','El Cajon','Gateway',1),
        ('10357','El Cajon','Gateway',1),
        ('10358','El Cajon','Gateway',1),
        ('10359','El Cajon','Gateway',1),
        ('10360','El Cajon','Gateway',1),
        ('10361','El Cajon','Gateway',1),
        ('10362','El Cajon','Gateway',1),
        ('10363','El Cajon','Gateway',1),
        ('10364','El Cajon','Gateway',1),
        ('10365','El Cajon','Gateway',1),
        ('10366','El Cajon','Gateway',1),
        ('10367','El Cajon','Gateway',1),
        ('10368','El Cajon','Gateway',1),
        ('10369','El Cajon','Gateway',1),
        ('10370','El Cajon','Gateway',1),
        ('10371','El Cajon','Gateway',1),
        ('10372','El Cajon','Gateway',1),
        ('10373','El Cajon','Gateway',1),
        ('10374','El Cajon','Gateway',1),
        ('10375','El Cajon','Gateway',1),
        ('10376','El Cajon','Gateway',1),
        ('10377','El Cajon','Gateway',1),
        ('10378','El Cajon','Gateway',1),
        ('10379','El Cajon','Gateway',1),
        ('10380','El Cajon','Gateway',1),
        ('10381','El Cajon','Gateway',1),
        ('10382','El Cajon','Gateway',1),
        ('10383','El Cajon','Gateway',1),
        ('10384','El Cajon','Gateway',1),
        ('10385','El Cajon','Gateway',1),
        ('10386','El Cajon','Gateway',1),
        ('10387','El Cajon','Gateway',1),
        ('10388','El Cajon','Gateway',1),
        ('10389','El Cajon','Gateway',1),
        ('10390','El Cajon','Gateway',1),
        ('10391','El Cajon','Gateway',1),
        ('10392','El Cajon','Gateway',1),
        ('10393','El Cajon','Gateway',1),
        ('10394','El Cajon','Gateway',1),
        ('10395','El Cajon','Gateway',1),
        ('10396','El Cajon','Gateway',1),
        ('10397','El Cajon','Gateway',1),
        ('10398','El Cajon','Gateway',1),
        ('10399','El Cajon','Gateway',1),
        ('10400','El Cajon','Gateway',1),
        ('10401','El Cajon','Gateway',1),
        ('10402','El Cajon','Gateway',1),
        ('10403','El Cajon','Gateway',1),
        ('10404','El Cajon','Gateway',1),
        ('10405','El Cajon','Gateway',1),
        ('10406','El Cajon','Gateway',1),
        ('10407','El Cajon','Gateway',1),
        ('10408','El Cajon','Gateway',1),
        ('10409','El Cajon','Gateway',1),
        ('10410','El Cajon','Gateway',1),
        ('10411','El Cajon','Gateway',1),
        ('10412','El Cajon','Gateway',1),
        ('10413','El Cajon','Gateway',1),
        ('10414','El Cajon','Gateway',1),
        ('10415','El Cajon','Gateway',1),
        ('10416','El Cajon','Gateway',1),
        ('10417','El Cajon','Gateway',1),
        ('10418','El Cajon','Gateway',1),
        ('10419','El Cajon','Gateway',1),
        ('10420','El Cajon','Gateway',1),
        ('10421','El Cajon','Gateway',1),
        ('10422','El Cajon','Gateway',1),
        ('10423','El Cajon','Gateway',1),
        ('10424','El Cajon','Gateway',1),
        ('10425','El Cajon','Gateway',1),
        ('10426','El Cajon','Gateway',1),
        ('10427','El Cajon','Gateway',1),
        ('10428','El Cajon','Gateway',1),
        ('10429','El Cajon','Gateway',1),
        ('10430','El Cajon','Gateway',1),
        ('10431','El Cajon','Gateway',1),
        ('10432','El Cajon','Gateway',1),
        ('10433','El Cajon','Gateway',1),
        ('10434','El Cajon','Gateway',1),
        ('10435','El Cajon','Gateway',1),
        ('10436','El Cajon','Gateway',1),
        ('10437','El Cajon','Gateway',1),
        ('10438','El Cajon','Gateway',1),
        ('10439','El Cajon','Gateway',1),
        ('10440','El Cajon','Gateway',1),
        ('10443','El Cajon','Gateway',1),
        ('10444','El Cajon','Gateway',1),
        ('10445','El Cajon','Gateway',1),
        ('10446','El Cajon','Gateway',1),
        ('10459','El Cajon','Gateway',1),
        ('10460','El Cajon','Gateway',1),
        ('10461','El Cajon','Gateway',1),
        ('10462','El Cajon','Gateway',1),
        ('10463','El Cajon','Gateway',1),
        ('10464','El Cajon','Gateway',1),
        ('10466','El Cajon','Gateway',1),
        ('10469','El Cajon','Gateway',1),
        ('10491','El Cajon','Gateway',1),
        ('10492','El Cajon','Gateway',1),
        ('10493','El Cajon','Gateway',1),
        ('10494','El Cajon','Gateway',1),
        ('10495','El Cajon','Gateway',1),
        ('10496','El Cajon','Gateway',1),
        ('10497','El Cajon','Gateway',1),
        ('10498','El Cajon','Gateway',1),
        ('10499','El Cajon','Gateway',1),
        ('10501','El Cajon','Gateway',1),
        ('10502','El Cajon','Gateway',1),
        ('10503','El Cajon','Gateway',1),
        ('10504','El Cajon','Gateway',1),
        ('10505','El Cajon','Gateway',1),
        ('10507','El Cajon','Gateway',1),
        ('10510','El Cajon','Gateway',1),
        ('10511','El Cajon','Gateway',1),
        ('10514','El Cajon','Gateway',1),
        ('10515','El Cajon','Gateway',1),
        ('10533','El Cajon','Gateway',1),
        ('10534','El Cajon','Gateway',1),
        ('10535','El Cajon','Gateway',1),
        ('10536','El Cajon','Gateway',1),
        ('10537','El Cajon','Gateway',1),
        ('10538','El Cajon','Gateway',1),
        ('10539','El Cajon','Gateway',1),
        ('10540','El Cajon','Gateway',1),
        ('10541','El Cajon','Gateway',1),
        ('10542','El Cajon','Gateway',1),
        ('10543','El Cajon','Gateway',1),
        ('10544','El Cajon','Gateway',1),
        ('10545','El Cajon','Gateway',1),
        ('10546','El Cajon','Gateway',1),
        ('10547','El Cajon','Gateway',1),
        ('10548','El Cajon','Gateway',1),
        ('10549','El Cajon','Gateway',1),
        ('10550','El Cajon','Gateway',1),
        ('10551','El Cajon','Gateway',1),
        ('10552','El Cajon','Gateway',1),
        ('10553','El Cajon','Gateway',1),
        ('10554','El Cajon','Gateway',1),
        ('10555','El Cajon','Gateway',1),
        ('10556','El Cajon','Gateway',1),
        ('10557','El Cajon','Gateway',1),
        ('10558','El Cajon','Gateway',1),
        ('10559','El Cajon','Gateway',1),
        ('10560','El Cajon','Gateway',1),
        ('10561','El Cajon','Gateway',1),
        ('10562','El Cajon','Gateway',1),
        ('10563','El Cajon','Gateway',1),
        ('10564','El Cajon','Gateway',1),
        ('10565','El Cajon','Gateway',1),
        ('10566','El Cajon','Gateway',1),
        ('10567','El Cajon','Gateway',1),
        ('10568','El Cajon','Gateway',1),
        ('10569','El Cajon','Gateway',1),
        ('10570','El Cajon','Gateway',1),
        ('10571','El Cajon','Gateway',1),
        ('10572','El Cajon','Gateway',1),
        ('10573','El Cajon','Gateway',1),
        ('10574','El Cajon','Gateway',1),
        ('10575','El Cajon','Gateway',1),
        ('10576','El Cajon','Gateway',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('10577','El Cajon','Gateway',1),
        ('10578','El Cajon','Gateway',1),
        ('10579','El Cajon','Gateway',1),
        ('10580','El Cajon','Gateway',1),
        ('10581','El Cajon','Gateway',1),
        ('10582','El Cajon','Gateway',1),
        ('10583','El Cajon','Gateway',1),
        ('10584','El Cajon','Gateway',1),
        ('10585','El Cajon','Gateway',1),
        ('10586','El Cajon','Gateway',1),
        ('10587','El Cajon','Gateway',1),
        ('10588','El Cajon','Gateway',1),
        ('10589','El Cajon','Gateway',1),
        ('10590','El Cajon','Gateway',1),
        ('10591','El Cajon','Gateway',1),
        ('10592','El Cajon','Gateway',1),
        ('10593','El Cajon','Gateway',1),
        ('10594','El Cajon','Gateway',1),
        ('10595','El Cajon','Gateway',1),
        ('10596','El Cajon','Gateway',1),
        ('10597','El Cajon','Gateway',1),
        ('10598','El Cajon','Gateway',1),
        ('10599','El Cajon','Gateway',1),
        ('10600','El Cajon','Gateway',1),
        ('10601','El Cajon','Gateway',1),
        ('10602','El Cajon','Gateway',1),
        ('10603','El Cajon','Gateway',1),
        ('10604','El Cajon','Gateway',1),
        ('10605','El Cajon','Gateway',1),
        ('10606','El Cajon','Gateway',1),
        ('10607','El Cajon','Gateway',1),
        ('10608','El Cajon','Gateway',1),
        ('10609','El Cajon','Gateway',1),
        ('10610','El Cajon','Gateway',1),
        ('10611','El Cajon','Gateway',1),
        ('10612','El Cajon','Gateway',1),
        ('10613','El Cajon','Gateway',1),
        ('10614','El Cajon','Gateway',1),
        ('10615','El Cajon','Gateway',1),
        ('10616','El Cajon','Gateway',1),
        ('10617','El Cajon','Gateway',1),
        ('10618','El Cajon','Gateway',1),
        ('10619','El Cajon','Gateway',1),
        ('10620','El Cajon','Gateway',1),
        ('10621','El Cajon','Gateway',1),
        ('10622','El Cajon','Gateway',1),
        ('10623','El Cajon','Gateway',1),
        ('10624','El Cajon','Gateway',1),
        ('10625','El Cajon','Gateway',1),
        ('10626','El Cajon','Gateway',1),
        ('10631','El Cajon','Gateway',1),
        ('10632','El Cajon','Gateway',1),
        ('10633','El Cajon','Gateway',1),
        ('10634','El Cajon','Gateway',1),
        ('10635','El Cajon','Gateway',1),
        ('10636','El Cajon','Gateway',1),
        ('10637','El Cajon','Gateway',1),
        ('10638','El Cajon','Gateway',1),
        ('10639','El Cajon','Gateway',1),
        ('10640','El Cajon','Gateway',1),
        ('10641','El Cajon','Gateway',1),
        ('10642','El Cajon','Gateway',1),
        ('10643','El Cajon','Gateway',1),
        ('10644','El Cajon','Gateway',1),
        ('10645','El Cajon','Gateway',1),
        ('10646','El Cajon','Gateway',1),
        ('10648','El Cajon','Gateway',1),
        ('10649','El Cajon','Gateway',1),
        ('10650','El Cajon','Gateway',1),
        ('10651','El Cajon','Gateway',1),
        ('10652','El Cajon','Gateway',1),
        ('10653','El Cajon','Gateway',1),
        ('10655','El Cajon','Gateway',1),
        ('10659','El Cajon','Gateway',1),
        ('10695','El Cajon','Gateway',1),
        ('10696','El Cajon','Gateway',1),
        ('10697','El Cajon','Gateway',1),
        ('10698','El Cajon','Gateway',1),
        ('10699','El Cajon','Gateway',1),
        ('10700','El Cajon','Gateway',1),
        ('10701','El Cajon','Gateway',1),
        ('10702','El Cajon','Gateway',1),
        ('10703','El Cajon','Gateway',1),
        ('10704','El Cajon','Gateway',1),
        ('10705','El Cajon','Gateway',1),
        ('10706','El Cajon','Gateway',1),
        ('10707','El Cajon','Gateway',1),
        ('10708','El Cajon','Gateway',1),
        ('10709','El Cajon','Gateway',1),
        ('10710','El Cajon','Gateway',1),
        ('10711','El Cajon','Gateway',1),
        ('10712','El Cajon','Gateway',1),
        ('10713','El Cajon','Gateway',1),
        ('10714','El Cajon','Gateway',1),
        ('10715','El Cajon','Gateway',1),
        ('10716','El Cajon','Gateway',1),
        ('10717','El Cajon','Gateway',1),
        ('10718','El Cajon','Gateway',1),
        ('10719','El Cajon','Gateway',1),
        ('10720','El Cajon','Gateway',1),
        ('10721','El Cajon','Gateway',1),
        ('10722','El Cajon','Gateway',1),
        ('10723','El Cajon','Gateway',1),
        ('10724','El Cajon','Gateway',1),
        ('10725','El Cajon','Gateway',1),
        ('10726','El Cajon','Gateway',1),
        ('10727','El Cajon','Gateway',1),
        ('10728','El Cajon','Gateway',1),
        ('10729','El Cajon','Gateway',1),
        ('10730','El Cajon','Gateway',1),
        ('10731','El Cajon','Gateway',1),
        ('10732','El Cajon','Gateway',1),
        ('10733','El Cajon','Gateway',1),
        ('10734','El Cajon','Gateway',1),
        ('10735','El Cajon','Gateway',1),
        ('10736','El Cajon','Gateway',1),
        ('10737','El Cajon','Gateway',1),
        ('10738','El Cajon','Gateway',1),
        ('10739','El Cajon','Gateway',1),
        ('10740','El Cajon','Gateway',1),
        ('10741','El Cajon','Gateway',1),
        ('10742','El Cajon','Gateway',1),
        ('10743','El Cajon','Gateway',1),
        ('10744','El Cajon','Gateway',1),
        ('10745','El Cajon','Gateway',1),
        ('10746','El Cajon','Gateway',1),
        ('10747','El Cajon','Gateway',1),
        ('10748','El Cajon','Gateway',1),
        ('10749','El Cajon','Gateway',1),
        ('10750','El Cajon','Gateway',1),
        ('10751','El Cajon','Gateway',1),
        ('10752','El Cajon','Gateway',1),
        ('10753','El Cajon','Gateway',1),
        ('10754','El Cajon','Gateway',1),
        ('10755','El Cajon','Gateway',1),
        ('10756','El Cajon','Gateway',1),
        ('10757','El Cajon','Gateway',1),
        ('10758','El Cajon','Gateway',1),
        ('10759','El Cajon','Gateway',1),
        ('10760','El Cajon','Gateway',1),
        ('10761','El Cajon','Gateway',1),
        ('10762','El Cajon','Gateway',1),
        ('10763','El Cajon','Gateway',1),
        ('10764','El Cajon','Gateway',1),
        ('10765','El Cajon','Gateway',1),
        ('10766','El Cajon','Gateway',1),
        ('10767','El Cajon','Gateway',1),
        ('10768','El Cajon','Gateway',1),
        ('10769','El Cajon','Gateway',1),
        ('10770','El Cajon','Gateway',1),
        ('10771','El Cajon','Gateway',1),
        ('10772','El Cajon','Gateway',1),
        ('10773','El Cajon','Gateway',1),
        ('10774','El Cajon','Gateway',1),
        ('10775','El Cajon','Gateway',1),
        ('10776','El Cajon','Gateway',1),
        ('10777','El Cajon','Gateway',1),
        ('10778','El Cajon','Gateway',1),
        ('10779','El Cajon','Gateway',1),
        ('10780','El Cajon','Gateway',1),
        ('10781','El Cajon','Gateway',1),
        ('10782','El Cajon','Gateway',1),
        ('10783','El Cajon','Gateway',1),
        ('10784','El Cajon','Gateway',1),
        ('10785','El Cajon','Gateway',1),
        ('10786','El Cajon','Gateway',1),
        ('10832','El Cajon','Gateway',1),
        ('10849','El Cajon','Gateway',1),
        ('10850','El Cajon','Gateway',1),
        ('10933','El Cajon','Gateway',1),
        ('10934','El Cajon','Gateway',1),
        ('10935','El Cajon','Gateway',1),
        ('10936','El Cajon','Gateway',1),
        ('10937','El Cajon','Gateway',1),
        ('10938','El Cajon','Gateway',1),
        ('10939','El Cajon','Gateway',1),
        ('10940','El Cajon','Gateway',1),
        ('10941','El Cajon','Gateway',1),
        ('10942','El Cajon','Gateway',1),
        ('10955','El Cajon','Gateway',1),
        ('10956','El Cajon','Gateway',1),
        ('10957','El Cajon','Gateway',1),
        ('10958','El Cajon','Gateway',1),
        ('10959','El Cajon','Gateway',1),
        ('10960','El Cajon','Gateway',1),
        ('10961','El Cajon','Gateway',1),
        ('10962','El Cajon','Gateway',1),
        ('10963','El Cajon','Gateway',1),
        ('10964','El Cajon','Gateway',1),
        ('10965','El Cajon','Gateway',1),
        ('10966','El Cajon','Gateway',1),
        ('10967','El Cajon','Gateway',1),
        ('10968','El Cajon','Gateway',1),
        ('10969','El Cajon','Gateway',1),
        ('10971','El Cajon','Gateway',1),
        ('10972','El Cajon','Gateway',1),
        ('10973','El Cajon','Gateway',1),
        ('10974','El Cajon','Gateway',1),
        ('10975','El Cajon','Gateway',1),
        ('10977','El Cajon','Gateway',1),
        ('10978','El Cajon','Gateway',1),
        ('10979','El Cajon','Gateway',1),
        ('10980','El Cajon','Gateway',1),
        ('10981','El Cajon','Gateway',1),
        ('10982','El Cajon','Gateway',1),
        ('10983','El Cajon','Gateway',1),
        ('10984','El Cajon','Gateway',1),
        ('10985','El Cajon','Gateway',1),
        ('10986','El Cajon','Gateway',1),
        ('10988','El Cajon','Gateway',1),
        ('10991','El Cajon','Gateway',1),
        ('10993','El Cajon','Gateway',1),
        ('10996','El Cajon','Gateway',1),
        ('10998','El Cajon','Gateway',1),
        ('10999','El Cajon','Gateway',1),
        ('11000','El Cajon','Gateway',1),
        ('11002','El Cajon','Gateway',1),
        ('11004','El Cajon','Gateway',1),
        ('11005','El Cajon','Gateway',1),
        ('11006','El Cajon','Gateway',1),
        ('11007','El Cajon','Gateway',1),
        ('11008','El Cajon','Gateway',1),
        ('11009','El Cajon','Gateway',1),
        ('11010','El Cajon','Gateway',1),
        ('11011','El Cajon','Gateway',1),
        ('11012','El Cajon','Gateway',1),
        ('11013','El Cajon','Gateway',1),
        ('11014','El Cajon','Gateway',1),
        ('11015','El Cajon','Gateway',1),
        ('11016','El Cajon','Gateway',1),
        ('11017','El Cajon','Gateway',1),
        ('11018','El Cajon','Gateway',1),
        ('11019','El Cajon','Gateway',1),
        ('11020','El Cajon','Gateway',1),
        ('11021','El Cajon','Gateway',1),
        ('11022','El Cajon','Gateway',1),
        ('11023','El Cajon','Gateway',1),
        ('11024','El Cajon','Gateway',1),
        ('11025','El Cajon','Gateway',1),
        ('11026','El Cajon','Gateway',1),
        ('11027','El Cajon','Gateway',1),
        ('11028','El Cajon','Gateway',1),
        ('11029','El Cajon','Gateway',1),
        ('11030','El Cajon','Gateway',1),
        ('11031','El Cajon','Gateway',1),
        ('11034','El Cajon','Gateway',1),
        ('11035','El Cajon','Gateway',1),
        ('11036','El Cajon','Gateway',1),
        ('11037','El Cajon','Gateway',1),
        ('11038','El Cajon','Gateway',1),
        ('11039','El Cajon','Gateway',1),
        ('11040','El Cajon','Gateway',1),
        ('11041','El Cajon','Gateway',1),
        ('11042','El Cajon','Gateway',1),
        ('11043','El Cajon','Gateway',1),
        ('11044','El Cajon','Gateway',1),
        ('11045','El Cajon','Gateway',1),
        ('11046','El Cajon','Gateway',1),
        ('11047','El Cajon','Gateway',1),
        ('11048','El Cajon','Gateway',1),
        ('11049','El Cajon','Gateway',1),
        ('11420','West Bernardo','Major Employment Center',1),
        ('11421','West Bernardo','Major Employment Center',1),
        ('11422','West Bernardo','Major Employment Center',1),
        ('11423','West Bernardo','Major Employment Center',1),
        ('11424','West Bernardo','Major Employment Center',1),
        ('11425','West Bernardo','Major Employment Center',1),
        ('11431','West Bernardo','Major Employment Center',1),
        ('11637','Mira Mesa','Suburban',0),
        ('11640','Mira Mesa','Suburban',0),
        ('11645','Mira Mesa','Suburban',0),
        ('11646','Mira Mesa','Suburban',0),
        ('11647','Mira Mesa','Suburban',0),
        ('11648','Mira Mesa','Suburban',0),
        ('11649','Mira Mesa','Suburban',0),
        ('11650','Mira Mesa','Suburban',0),
        ('11651','Mira Mesa','Suburban',0),
        ('11652','Mira Mesa','Suburban',0),
        ('11655','Mira Mesa','Suburban',0),
        ('11657','Mira Mesa','Suburban',0),
        ('11659','Mira Mesa','Suburban',0),
        ('11663','Mira Mesa','Suburban',0),
        ('11664','Mira Mesa','Suburban',0),
        ('11665','Mira Mesa','Suburban',0),
        ('11756','West Bernardo','Major Employment Center',1),
        ('11760','West Bernardo','Major Employment Center',1),
        ('11769','West Bernardo','Major Employment Center',1),
        ('11773','West Bernardo','Major Employment Center',1),
        ('11820','West Bernardo','Major Employment Center',1),
        ('11823','West Bernardo','Major Employment Center',1),
        ('11826','West Bernardo','Major Employment Center',1),
        ('11827','West Bernardo','Major Employment Center',1),
        ('11828','West Bernardo','Major Employment Center',1),
        ('11833','West Bernardo','Major Employment Center',1),
        ('11863','West Bernardo','Major Employment Center',1),
        ('11877','West Bernardo','Major Employment Center',1),
        ('11878','West Bernardo','Major Employment Center',1),
        ('11879','West Bernardo','Major Employment Center',1),
        ('11880','West Bernardo','Major Employment Center',1),
        ('11881','West Bernardo','Major Employment Center',1),
        ('11882','West Bernardo','Major Employment Center',1),
        ('11883','West Bernardo','Major Employment Center',1),
        ('11884','West Bernardo','Major Employment Center',1),
        ('11885','West Bernardo','Major Employment Center',1),
        ('11886','West Bernardo','Major Employment Center',1),
        ('11887','West Bernardo','Major Employment Center',1),
        ('11888','West Bernardo','Major Employment Center',1),
        ('11889','West Bernardo','Major Employment Center',1),
        ('11890','West Bernardo','Major Employment Center',1),
        ('11891','West Bernardo','Major Employment Center',1),
        ('11892','West Bernardo','Major Employment Center',1),
        ('11893','West Bernardo','Major Employment Center',1),
        ('11894','West Bernardo','Major Employment Center',1),
        ('11895','West Bernardo','Major Employment Center',1),
        ('11896','West Bernardo','Major Employment Center',1),
        ('11897','West Bernardo','Major Employment Center',1),
        ('11898','West Bernardo','Major Employment Center',1),
        ('11899','West Bernardo','Major Employment Center',1),
        ('11900','West Bernardo','Major Employment Center',1),
        ('11901','West Bernardo','Major Employment Center',1),
        ('11902','West Bernardo','Major Employment Center',1),
        ('11903','West Bernardo','Major Employment Center',1),
        ('11904','West Bernardo','Major Employment Center',1),
        ('11905','West Bernardo','Major Employment Center',1),
        ('11906','West Bernardo','Major Employment Center',1),
        ('11907','West Bernardo','Major Employment Center',1),
        ('11908','West Bernardo','Major Employment Center',1),
        ('11909','West Bernardo','Major Employment Center',1),
        ('11910','West Bernardo','Major Employment Center',1),
        ('11911','West Bernardo','Major Employment Center',1),
        ('11912','West Bernardo','Major Employment Center',1),
        ('11913','West Bernardo','Major Employment Center',1),
        ('11914','West Bernardo','Major Employment Center',1),
        ('11915','West Bernardo','Major Employment Center',1),
        ('11916','West Bernardo','Major Employment Center',1),
        ('11917','West Bernardo','Major Employment Center',1),
        ('11918','West Bernardo','Major Employment Center',1),
        ('11919','West Bernardo','Major Employment Center',1),
        ('11920','West Bernardo','Major Employment Center',1),
        ('11921','West Bernardo','Major Employment Center',1),
        ('11922','West Bernardo','Major Employment Center',1),
        ('11923','West Bernardo','Major Employment Center',1),
        ('11924','West Bernardo','Major Employment Center',1),
        ('11925','West Bernardo','Major Employment Center',1),
        ('11926','West Bernardo','Major Employment Center',1),
        ('11927','West Bernardo','Major Employment Center',1),
        ('11928','West Bernardo','Major Employment Center',1),
        ('11929','West Bernardo','Major Employment Center',1),
        ('11930','West Bernardo','Major Employment Center',1),
        ('11931','West Bernardo','Major Employment Center',1),
        ('11932','West Bernardo','Major Employment Center',1),
        ('11934','West Bernardo','Major Employment Center',1),
        ('11935','West Bernardo','Major Employment Center',1),
        ('11936','West Bernardo','Major Employment Center',1),
        ('11937','West Bernardo','Major Employment Center',1),
        ('11938','West Bernardo','Major Employment Center',1),
        ('11939','West Bernardo','Major Employment Center',1),
        ('11940','West Bernardo','Major Employment Center',1),
        ('11941','West Bernardo','Major Employment Center',1),
        ('11942','West Bernardo','Major Employment Center',1),
        ('11943','West Bernardo','Major Employment Center',1),
        ('11944','West Bernardo','Major Employment Center',1),
        ('11945','West Bernardo','Major Employment Center',1),
        ('11972','West Bernardo','Major Employment Center',1),
        ('12227','Mira Mesa','Suburban',0),
        ('12228','Mira Mesa','Suburban',0),
        ('12496','West Bernardo','Major Employment Center',1),
        ('13060','Solana Beach','Coastal',0),
        ('13061','Solana Beach','Coastal',0),
        ('13077','Solana Beach','Coastal',0),
        ('13078','Solana Beach','Coastal',0),
        ('13079','Solana Beach','Coastal',0),
        ('13080','Solana Beach','Coastal',0),
        ('13122','Solana Beach','Coastal',0),
        ('13123','Solana Beach','Coastal',0),
        ('13124','Solana Beach','Coastal',0),
        ('13125','Solana Beach','Coastal',0),
        ('13126','Solana Beach','Coastal',0),
        ('13127','Solana Beach','Coastal',0),
        ('13128','Solana Beach','Coastal',0),
        ('13129','Solana Beach','Coastal',0),
        ('13130','Solana Beach','Coastal',0),
        ('13131','Solana Beach','Coastal',0),
        ('13132','Solana Beach','Coastal',0),
        ('13133','Solana Beach','Coastal',0),
        ('13134','Solana Beach','Coastal',0),
        ('13135','Solana Beach','Coastal',0),
        ('13136','Solana Beach','Coastal',0),
        ('13137','Solana Beach','Coastal',0),
        ('13138','Solana Beach','Coastal',0),
        ('13140','Solana Beach','Coastal',0),
        ('13142','Solana Beach','Coastal',0),
        ('13150','Solana Beach','Coastal',0),
        ('13151','Solana Beach','Coastal',0),
        ('13152','Solana Beach','Coastal',0),
        ('13153','Solana Beach','Coastal',0),
        ('13154','Solana Beach','Coastal',0),
        ('13155','Solana Beach','Coastal',0),
        ('13156','Solana Beach','Coastal',0),
        ('13157','Solana Beach','Coastal',0),
        ('13158','Solana Beach','Coastal',0),
        ('13159','Solana Beach','Coastal',0),
        ('13160','Solana Beach','Coastal',0),
        ('13161','Solana Beach','Coastal',0),
        ('13168','Solana Beach','Coastal',0),
        ('13170','Solana Beach','Coastal',0),
        ('13171','Solana Beach','Coastal',0),
        ('13172','Solana Beach','Coastal',0),
        ('13173','Solana Beach','Coastal',0),
        ('13174','Solana Beach','Coastal',0),
        ('13175','Solana Beach','Coastal',0),
        ('13176','Solana Beach','Coastal',0),
        ('13177','Solana Beach','Coastal',0),
        ('13178','Solana Beach','Coastal',0),
        ('13179','Solana Beach','Coastal',0),
        ('13180','Solana Beach','Coastal',0),
        ('13181','Solana Beach','Coastal',0),
        ('13182','Solana Beach','Coastal',0),
        ('13183','Solana Beach','Coastal',0),
        ('13184','Solana Beach','Coastal',0),
        ('13185','Solana Beach','Coastal',0),
        ('13186','Solana Beach','Coastal',0),
        ('13187','Solana Beach','Coastal',0),
        ('13188','Solana Beach','Coastal',0),
        ('13190','Solana Beach','Coastal',0),
        ('13191','Solana Beach','Coastal',0),
        ('13192','Solana Beach','Coastal',0),
        ('13193','Solana Beach','Coastal',0),
        ('13194','Solana Beach','Coastal',0),
        ('13195','Solana Beach','Coastal',0),
        ('13196','Solana Beach','Coastal',0),
        ('13197','Solana Beach','Coastal',0),
        ('13198','Solana Beach','Coastal',0),
        ('13199','Solana Beach','Coastal',0),
        ('13200','Solana Beach','Coastal',0),
        ('13201','Solana Beach','Coastal',0),
        ('13202','Solana Beach','Coastal',0),
        ('13203','Solana Beach','Coastal',0),
        ('13204','Solana Beach','Coastal',0),
        ('13205','Solana Beach','Coastal',0),
        ('13206','Solana Beach','Coastal',0),
        ('13207','Solana Beach','Coastal',0),
        ('13208','Solana Beach','Coastal',0),
        ('13210','Solana Beach','Coastal',0),
        ('13213','Solana Beach','Coastal',0),
        ('13214','Solana Beach','Coastal',0),
        ('13215','Solana Beach','Coastal',0),
        ('13216','Solana Beach','Coastal',0),
        ('13217','Solana Beach','Coastal',0),
        ('13218','Solana Beach','Coastal',0),
        ('13219','Solana Beach','Coastal',0),
        ('13220','Solana Beach','Coastal',0),
        ('13221','Solana Beach','Coastal',0),
        ('13222','Solana Beach','Coastal',0),
        ('13223','Solana Beach','Coastal',0),
        ('13224','Solana Beach','Coastal',0),
        ('13225','Solana Beach','Coastal',0),
        ('13226','Solana Beach','Coastal',0),
        ('13227','Solana Beach','Coastal',0),
        ('13228','Solana Beach','Coastal',0),
        ('13229','Solana Beach','Coastal',0),
        ('13230','Solana Beach','Coastal',0),
        ('13231','Solana Beach','Coastal',0),
        ('13232','Solana Beach','Coastal',0),
        ('13233','Solana Beach','Coastal',0),
        ('13234','Solana Beach','Coastal',0),
        ('13235','Solana Beach','Coastal',0),
        ('13236','Solana Beach','Coastal',0),
        ('13237','Solana Beach','Coastal',0),
        ('13238','Solana Beach','Coastal',0),
        ('13239','Solana Beach','Coastal',0),
        ('13240','Solana Beach','Coastal',0),
        ('13241','Solana Beach','Coastal',0),
        ('13242','Solana Beach','Coastal',0),
        ('13243','Solana Beach','Coastal',0),
        ('13244','Solana Beach','Coastal',0),
        ('13245','Solana Beach','Coastal',0),
        ('13246','Solana Beach','Coastal',0),
        ('13247','Solana Beach','Coastal',0),
        ('13248','Solana Beach','Coastal',0),
        ('13249','Solana Beach','Coastal',0),
        ('13250','Solana Beach','Coastal',0),
        ('13251','Solana Beach','Coastal',0),
        ('13252','Solana Beach','Coastal',0),
        ('13272','Solana Beach','Coastal',0),
        ('13291','Solana Beach','Coastal',0),
        ('13314','Solana Beach','Coastal',0),
        ('13370','Encinitas','Coastal',0),
        ('13371','Encinitas','Coastal',0),
        ('13372','Encinitas','Coastal',0),
        ('13373','Encinitas','Coastal',0),
        ('13375','Encinitas','Coastal',0),
        ('13634','Encinitas','Coastal',0),
        ('13635','Encinitas','Coastal',0),
        ('13636','Encinitas','Coastal',0),
        ('13637','Encinitas','Coastal',0),
        ('13638','Encinitas','Coastal',0),
        ('13639','Encinitas','Coastal',0),
        ('13640','Encinitas','Coastal',0),
        ('13641','Encinitas','Coastal',0),
        ('13642','Encinitas','Coastal',0),
        ('13643','Encinitas','Coastal',0),
        ('13644','Encinitas','Coastal',0),
        ('13645','Encinitas','Coastal',0),
        ('13646','Encinitas','Coastal',0),
        ('13647','Encinitas','Coastal',0),
        ('13648','Encinitas','Coastal',0),
        ('13649','Encinitas','Coastal',0),
        ('13650','Encinitas','Coastal',0),
        ('13651','Encinitas','Coastal',0),
        ('13652','Encinitas','Coastal',0),
        ('13653','Encinitas','Coastal',0),
        ('13654','Encinitas','Coastal',0),
        ('13655','Encinitas','Coastal',0),
        ('13656','Encinitas','Coastal',0),
        ('13657','Encinitas','Coastal',0),
        ('13658','Encinitas','Coastal',0),
        ('13659','Encinitas','Coastal',0),
        ('13660','Encinitas','Coastal',0),
        ('13661','Encinitas','Coastal',0),
        ('13662','Encinitas','Coastal',0),
        ('13663','Encinitas','Coastal',0),
        ('13664','Encinitas','Coastal',0),
        ('13665','Encinitas','Coastal',0),
        ('13666','Encinitas','Coastal',0),
        ('13667','Encinitas','Coastal',0),
        ('13668','Encinitas','Coastal',0),
        ('13669','Encinitas','Coastal',0),
        ('13670','Encinitas','Coastal',0),
        ('13671','Encinitas','Coastal',0),
        ('13672','Encinitas','Coastal',0),
        ('13673','Encinitas','Coastal',0),
        ('13674','Encinitas','Coastal',0),
        ('13675','Encinitas','Coastal',0),
        ('13676','Encinitas','Coastal',0),
        ('13677','Encinitas','Coastal',0),
        ('13678','Encinitas','Coastal',0),
        ('13679','Encinitas','Coastal',0),
        ('13680','Encinitas','Coastal',0),
        ('13681','Encinitas','Coastal',0),
        ('13682','Encinitas','Coastal',0),
        ('13683','Encinitas','Coastal',0),
        ('13684','Encinitas','Coastal',0),
        ('13685','Encinitas','Coastal',0),
        ('13686','Encinitas','Coastal',0),
        ('13687','Encinitas','Coastal',0),
        ('13688','Encinitas','Coastal',0),
        ('13689','Encinitas','Coastal',0),
        ('13690','Encinitas','Coastal',0),
        ('13691','Encinitas','Coastal',0),
        ('13692','Encinitas','Coastal',0),
        ('13693','Encinitas','Coastal',0),
        ('13694','Encinitas','Coastal',0),
        ('13695','Encinitas','Coastal',0),
        ('13696','Encinitas','Coastal',0),
        ('13697','Encinitas','Coastal',0),
        ('13698','Encinitas','Coastal',0),
        ('13699','Encinitas','Coastal',0),
        ('13700','Encinitas','Coastal',0),
        ('13701','Encinitas','Coastal',0),
        ('13702','Encinitas','Coastal',0),
        ('13703','Encinitas','Coastal',0),
        ('13704','Encinitas','Coastal',0),
        ('13705','Encinitas','Coastal',0),
        ('13706','Encinitas','Coastal',0),
        ('13707','Encinitas','Coastal',0),
        ('13708','Encinitas','Coastal',0),
        ('13709','Encinitas','Coastal',0),
        ('13710','Encinitas','Coastal',0),
        ('13711','Encinitas','Coastal',0),
        ('13712','Encinitas','Coastal',0),
        ('13713','Encinitas','Coastal',0),
        ('13714','Encinitas','Coastal',0),
        ('13715','Encinitas','Coastal',0),
        ('13716','Encinitas','Coastal',0),
        ('13717','Encinitas','Coastal',0),
        ('13718','Encinitas','Coastal',0),
        ('13719','Encinitas','Coastal',0),
        ('13720','Encinitas','Coastal',0),
        ('13721','Encinitas','Coastal',0),
        ('13722','Encinitas','Coastal',0),
        ('13723','Encinitas','Coastal',0),
        ('13725','Encinitas','Coastal',0),
        ('13727','Encinitas','Coastal',0),
        ('13728','Encinitas','Coastal',0),
        ('13730','Encinitas','Coastal',0),
        ('13733','Encinitas','Coastal',0),
        ('13738','Encinitas','Coastal',0),
        ('13739','Encinitas','Coastal',0),
        ('13740','Encinitas','Coastal',0),
        ('13741','Encinitas','Coastal',0),
        ('13742','Encinitas','Coastal',0),
        ('13743','Encinitas','Coastal',0),
        ('13750','Encinitas','Coastal',0),
        ('13751','Encinitas','Coastal',0),
        ('13752','Encinitas','Coastal',0),
        ('13753','Encinitas','Coastal',0),
        ('13756','Encinitas','Coastal',0),
        ('13757','Encinitas','Coastal',0),
        ('13760','Encinitas','Coastal',0),
        ('13761','Encinitas','Coastal',0),
        ('13762','Encinitas','Coastal',0),
        ('13763','Encinitas','Coastal',0),
        ('13766','Encinitas','Coastal',0),
        ('13769','Encinitas','Coastal',0),
        ('13773','Encinitas','Coastal',0),
        ('13836','Encinitas','Coastal',0),
        ('13837','Encinitas','Coastal',0),
        ('13838','Encinitas','Coastal',0),
        ('13839','Encinitas','Coastal',0),
        ('13840','Encinitas','Coastal',0),
        ('13841','Encinitas','Coastal',0),
        ('13842','Encinitas','Coastal',0),
        ('13843','Encinitas','Coastal',0),
        ('13844','Encinitas','Coastal',0),
        ('13845','Encinitas','Coastal',0),
        ('13846','Encinitas','Coastal',0),
        ('13847','Encinitas','Coastal',0),
        ('13848','Encinitas','Coastal',0),
        ('13849','Encinitas','Coastal',0),
        ('13850','Encinitas','Coastal',0),
        ('13851','Encinitas','Coastal',0),
        ('13852','Encinitas','Coastal',0),
        ('13853','Encinitas','Coastal',0),
        ('13854','Encinitas','Coastal',0),
        ('13855','Encinitas','Coastal',0),
        ('13856','Encinitas','Coastal',0),
        ('13867','Encinitas','Coastal',0),
        ('13869','Encinitas','Coastal',0),
        ('13870','Encinitas','Coastal',0),
        ('13871','Encinitas','Coastal',0),
        ('13872','Encinitas','Coastal',0),
        ('13873','Encinitas','Coastal',0),
        ('13874','Encinitas','Coastal',0),
        ('13875','Encinitas','Coastal',0),
        ('13904','Encinitas','Coastal',0),
        ('13909','Encinitas','Coastal',0),
        ('13910','Encinitas','Coastal',0),
        ('13911','Encinitas','Coastal',0),
        ('13913','Encinitas','Coastal',0),
        ('13914','Encinitas','Coastal',0),
        ('13915','Encinitas','Coastal',0),
        ('13916','Encinitas','Coastal',0),
        ('13917','Encinitas','Coastal',0),
        ('13918','Encinitas','Coastal',0),
        ('13919','Encinitas','Coastal',0),
        ('13920','Encinitas','Coastal',0),
        ('13962','Encinitas','Coastal',0),
        ('14000','Encinitas','Coastal',0),
        ('14013','Encinitas','Coastal',0),
        ('14014','Encinitas','Coastal',0),
        ('14015','Encinitas','Coastal',0),
        ('14016','Encinitas','Coastal',0),
        ('14017','Encinitas','Coastal',0),
        ('14018','Encinitas','Coastal',0),
        ('14019','Encinitas','Coastal',0),
        ('14020','Encinitas','Coastal',0),
        ('14021','Encinitas','Coastal',0),
        ('14022','Encinitas','Coastal',0),
        ('14023','Encinitas','Coastal',0),
        ('14024','Encinitas','Coastal',0),
        ('14025','Encinitas','Coastal',0),
        ('14026','Encinitas','Coastal',0),
        ('14027','Encinitas','Coastal',0),
        ('14028','Encinitas','Coastal',0),
        ('14029','Encinitas','Coastal',0),
        ('14030','Encinitas','Coastal',0),
        ('14031','Encinitas','Coastal',0),
        ('14032','Encinitas','Coastal',0),
        ('14033','Encinitas','Coastal',0),
        ('14034','Encinitas','Coastal',0),
        ('14035','Encinitas','Coastal',0),
        ('14036','Encinitas','Coastal',0),
        ('14037','Encinitas','Coastal',0),
        ('14038','Encinitas','Coastal',0),
        ('14039','Encinitas','Coastal',0),
        ('14040','Encinitas','Coastal',0),
        ('14041','Encinitas','Coastal',0),
        ('14042','Encinitas','Coastal',0),
        ('14043','Encinitas','Coastal',0),
        ('14044','Encinitas','Coastal',0),
        ('14045','Encinitas','Coastal',0),
        ('14046','Encinitas','Coastal',0),
        ('14047','Encinitas','Coastal',0),
        ('14048','Encinitas','Coastal',0),
        ('14049','Encinitas','Coastal',0),
        ('14050','Encinitas','Coastal',0),
        ('14051','Encinitas','Coastal',0),
        ('14052','Encinitas','Coastal',0),
        ('14053','Encinitas','Coastal',0),
        ('14054','Encinitas','Coastal',0),
        ('14055','Encinitas','Coastal',0),
        ('14056','Encinitas','Coastal',0),
        ('14057','Encinitas','Coastal',0),
        ('14058','Encinitas','Coastal',0),
        ('14059','Encinitas','Coastal',0),
        ('14060','Encinitas','Coastal',0),
        ('14061','Encinitas','Coastal',0),
        ('14062','Encinitas','Coastal',0),
        ('14063','Encinitas','Coastal',0),
        ('14064','Encinitas','Coastal',0),
        ('14065','Encinitas','Coastal',0),
        ('14066','Encinitas','Coastal',0),
        ('14067','Encinitas','Coastal',0),
        ('14068','Encinitas','Coastal',0),
        ('14069','Encinitas','Coastal',0),
        ('14070','Carlsbad Village','Coastal',0),
        ('14071','Carlsbad Village','Coastal',0),
        ('14072','Carlsbad Village','Coastal',0),
        ('14074','Carlsbad Village','Coastal',0),
        ('14075','Carlsbad Village','Coastal',0),
        ('14076','Carlsbad Village','Coastal',0),
        ('14077','Carlsbad Village','Coastal',0),
        ('14078','Carlsbad Village','Coastal',0),
        ('14079','Carlsbad Village','Coastal',0),
        ('14080','Carlsbad Village','Coastal',0),
        ('14081','Carlsbad Village','Coastal',0),
        ('14082','Carlsbad Village','Coastal',0),
        ('14084','Carlsbad Village','Coastal',0),
        ('14085','Carlsbad Village','Coastal',0),
        ('14086','Carlsbad Village','Coastal',0),
        ('14087','Carlsbad Village','Coastal',0),
        ('14096','Carlsbad Village','Coastal',0),
        ('14166','Carlsbad Village','Coastal',0),
        ('14169','Carlsbad Village','Coastal',0),
        ('14173','Carlsbad Village','Coastal',0),
        ('14199','Carlsbad Palomar','Major Employment Center',1),
        ('14200','Carlsbad Palomar','Major Employment Center',1),
        ('14201','Carlsbad Palomar','Major Employment Center',1),
        ('14202','Carlsbad Palomar','Major Employment Center',1),
        ('14205','Carlsbad Palomar','Major Employment Center',1),
        ('14206','Carlsbad Palomar','Major Employment Center',1),
        ('14207','Carlsbad Palomar','Major Employment Center',1),
        ('14208','Carlsbad Palomar','Major Employment Center',1),
        ('14210','Carlsbad Palomar','Major Employment Center',1),
        ('14211','Carlsbad Palomar','Major Employment Center',1),
        ('14212','Carlsbad Palomar','Major Employment Center',1),
        ('14214','Carlsbad Palomar','Major Employment Center',1),
        ('14247','Carlsbad Palomar','Major Employment Center',1),
        ('14248','Carlsbad Palomar','Major Employment Center',1),
        ('14249','Carlsbad Palomar','Major Employment Center',1),
        ('14250','Carlsbad Palomar','Major Employment Center',1),
        ('14251','Carlsbad Palomar','Major Employment Center',1),
        ('14252','Carlsbad Palomar','Major Employment Center',1),
        ('14253','Carlsbad Palomar','Major Employment Center',1),
        ('14254','Carlsbad Palomar','Major Employment Center',1),
        ('14255','Carlsbad Palomar','Major Employment Center',1),
        ('14256','Carlsbad Palomar','Major Employment Center',1),
        ('14257','Carlsbad Palomar','Major Employment Center',1),
        ('14258','Carlsbad Palomar','Major Employment Center',1),
        ('14259','Carlsbad Palomar','Major Employment Center',1),
        ('14260','Carlsbad Palomar','Major Employment Center',1),
        ('14261','Carlsbad Palomar','Major Employment Center',1),
        ('14262','Carlsbad Palomar','Major Employment Center',1),
        ('14263','Carlsbad Palomar','Major Employment Center',1),
        ('14264','Carlsbad Palomar','Major Employment Center',1),
        ('14265','Carlsbad Palomar','Major Employment Center',1),
        ('14266','Carlsbad Palomar','Major Employment Center',1),
        ('14267','Carlsbad Palomar','Major Employment Center',1),
        ('14269','Carlsbad Palomar','Major Employment Center',1),
        ('14271','Carlsbad Palomar','Major Employment Center',1),
        ('14272','Carlsbad Palomar','Major Employment Center',1),
        ('14279','Carlsbad Village','Coastal',0),
        ('14280','Carlsbad Village','Coastal',0),
        ('14281','Carlsbad Village','Coastal',0),
        ('14282','Carlsbad Village','Coastal',0),
        ('14283','Carlsbad Village','Coastal',0),
        ('14284','Carlsbad Village','Coastal',0),
        ('14285','Carlsbad Village','Coastal',0),
        ('14286','Carlsbad Village','Coastal',0),
        ('14287','Carlsbad Village','Coastal',0),
        ('14288','Carlsbad Village','Coastal',0),
        ('14289','Carlsbad Village','Coastal',0),
        ('14290','Carlsbad Village','Coastal',0),
        ('14291','Carlsbad Village','Coastal',0),
        ('14292','Carlsbad Village','Coastal',0),
        ('14293','Carlsbad Village','Coastal',0),
        ('14294','Carlsbad Village','Coastal',0),
        ('14295','Carlsbad Village','Coastal',0),
        ('14296','Carlsbad Village','Coastal',0),
        ('14297','Carlsbad Village','Coastal',0),
        ('14298','Carlsbad Village','Coastal',0),
        ('14299','Carlsbad Village','Coastal',0),
        ('14300','Carlsbad Village','Coastal',0),
        ('14301','Carlsbad Village','Coastal',0),
        ('14302','Carlsbad Village','Coastal',0),
        ('14303','Carlsbad Village','Coastal',0),
        ('14304','Carlsbad Village','Coastal',0),
        ('14305','Carlsbad Village','Coastal',0),
        ('14306','Carlsbad Village','Coastal',0),
        ('14307','Carlsbad Village','Coastal',0),
        ('14308','Carlsbad Village','Coastal',0),
        ('14309','Carlsbad Village','Coastal',0),
        ('14310','Carlsbad Village','Coastal',0),
        ('14311','Carlsbad Village','Coastal',0),
        ('14312','Carlsbad Village','Coastal',0),
        ('14313','Carlsbad Village','Coastal',0),
        ('14314','Carlsbad Village','Coastal',0),
        ('14315','Carlsbad Village','Coastal',0),
        ('14316','Carlsbad Village','Coastal',0),
        ('14317','Carlsbad Village','Coastal',0),
        ('14318','Carlsbad Village','Coastal',0),
        ('14319','Carlsbad Village','Coastal',0),
        ('14320','Carlsbad Village','Coastal',0),
        ('14321','Carlsbad Village','Coastal',0),
        ('14322','Carlsbad Village','Coastal',0),
        ('14323','Carlsbad Village','Coastal',0),
        ('14324','Carlsbad Village','Coastal',0),
        ('14325','Carlsbad Village','Coastal',0),
        ('14326','Carlsbad Village','Coastal',0),
        ('14327','Carlsbad Village','Coastal',0),
        ('14328','Carlsbad Village','Coastal',0),
        ('14329','Carlsbad Village','Coastal',0),
        ('14330','Carlsbad Village','Coastal',0),
        ('14331','Carlsbad Village','Coastal',0),
        ('14332','Carlsbad Village','Coastal',0),
        ('14333','Carlsbad Village','Coastal',0),
        ('14334','Carlsbad Village','Coastal',0),
        ('14335','Carlsbad Village','Coastal',0),
        ('14336','Carlsbad Village','Coastal',0),
        ('14337','Carlsbad Village','Coastal',0),
        ('14338','Carlsbad Village','Coastal',0),
        ('14339','Carlsbad Village','Coastal',0),
        ('14340','Carlsbad Village','Coastal',0),
        ('14341','Carlsbad Village','Coastal',0),
        ('14342','Carlsbad Village','Coastal',0),
        ('14343','Carlsbad Village','Coastal',0),
        ('14344','Carlsbad Village','Coastal',0),
        ('14345','Carlsbad Village','Coastal',0),
        ('14349','Carlsbad Village','Coastal',0),
        ('14350','Carlsbad Village','Coastal',0),
        ('14351','Carlsbad Village','Coastal',0),
        ('14352','Carlsbad Village','Coastal',0),
        ('14353','Carlsbad Village','Coastal',0),
        ('14354','Carlsbad Village','Coastal',0),
        ('14355','Carlsbad Village','Coastal',0),
        ('14356','Carlsbad Village','Coastal',0),
        ('14357','Carlsbad Village','Coastal',0),
        ('14358','Carlsbad Village','Coastal',0),
        ('14359','Carlsbad Village','Coastal',0),
        ('14360','Carlsbad Village','Coastal',0),
        ('14361','Carlsbad Village','Coastal',0),
        ('14362','Carlsbad Village','Coastal',0),
        ('14363','Carlsbad Village','Coastal',0),
        ('14364','Carlsbad Village','Coastal',0),
        ('14365','Carlsbad Village','Coastal',0),
        ('14366','Carlsbad Village','Coastal',0),
        ('14367','Carlsbad Village','Coastal',0),
        ('14368','Carlsbad Village','Coastal',0),
        ('14369','Carlsbad Village','Coastal',0),
        ('14370','Carlsbad Village','Coastal',0),
        ('14371','Carlsbad Village','Coastal',0),
        ('14372','Carlsbad Village','Coastal',0),
        ('14373','Carlsbad Village','Coastal',0),
        ('14374','Carlsbad Village','Coastal',0),
        ('14375','Carlsbad Village','Coastal',0),
        ('14376','Carlsbad Village','Coastal',0),
        ('14377','Carlsbad Village','Coastal',0),
        ('14378','Carlsbad Village','Coastal',0),
        ('14379','Carlsbad Village','Coastal',0),
        ('14380','Carlsbad Village','Coastal',0),
        ('14381','Carlsbad Village','Coastal',0),
        ('14382','Oceanside','Gateway',1),
        ('14383','Oceanside','Gateway',1),
        ('14384','Oceanside','Gateway',1),
        ('14385','Oceanside','Gateway',1),
        ('14386','Oceanside','Gateway',1),
        ('14387','Oceanside','Gateway',1),
        ('14388','Oceanside','Gateway',1),
        ('14389','Oceanside','Gateway',1),
        ('14390','Oceanside','Gateway',1),
        ('14391','Oceanside','Gateway',1),
        ('14392','Oceanside','Gateway',1),
        ('14393','Oceanside','Gateway',1),
        ('14394','Oceanside','Gateway',1),
        ('14395','Oceanside','Gateway',1),
        ('14396','Oceanside','Gateway',1),
        ('14397','Oceanside','Gateway',1),
        ('14398','Oceanside','Gateway',1),
        ('14399','Oceanside','Gateway',1),
        ('14400','Oceanside','Gateway',1),
        ('14401','Oceanside','Gateway',1),
        ('14402','Oceanside','Gateway',1),
        ('14403','Oceanside','Gateway',1),
        ('14404','Oceanside','Gateway',1),
        ('14405','Oceanside','Gateway',1),
        ('14406','Oceanside','Gateway',1),
        ('14407','Oceanside','Gateway',1),
        ('14408','Oceanside','Gateway',1),
        ('14409','Oceanside','Gateway',1),
        ('14410','Oceanside','Gateway',1),
        ('14411','Oceanside','Gateway',1),
        ('14412','Oceanside','Gateway',1),
        ('14414','Oceanside','Gateway',1),
        ('14415','Oceanside','Gateway',1),
        ('14416','Oceanside','Gateway',1),
        ('14417','Oceanside','Gateway',1),
        ('14418','Oceanside','Gateway',1),
        ('14424','Oceanside','Gateway',1),
        ('14425','Oceanside','Gateway',1),
        ('14426','Oceanside','Gateway',1),
        ('14427','Oceanside','Gateway',1),
        ('14428','Oceanside','Gateway',1),
        ('14429','Oceanside','Gateway',1),
        ('14430','Oceanside','Gateway',1),
        ('14431','Oceanside','Gateway',1),
        ('14432','Oceanside','Gateway',1),
        ('14433','Oceanside','Gateway',1),
        ('14434','Oceanside','Gateway',1),
        ('14435','Oceanside','Gateway',1),
        ('14436','Oceanside','Gateway',1),
        ('14437','Oceanside','Gateway',1),
        ('14438','Oceanside','Gateway',1),
        ('14439','Oceanside','Gateway',1),
        ('14440','Oceanside','Gateway',1),
        ('14441','Oceanside','Gateway',1),
        ('14442','Oceanside','Gateway',1),
        ('14443','Oceanside','Gateway',1),
        ('14444','Oceanside','Gateway',1),
        ('14445','Oceanside','Gateway',1),
        ('14446','Oceanside','Gateway',1),
        ('14447','Oceanside','Gateway',1),
        ('14448','Oceanside','Gateway',1),
        ('14449','Oceanside','Gateway',1),
        ('14450','Oceanside','Gateway',1),
        ('14451','Oceanside','Gateway',1),
        ('14452','Oceanside','Gateway',1),
        ('14453','Oceanside','Gateway',1),
        ('14454','Oceanside','Gateway',1),
        ('14455','Oceanside','Gateway',1),
        ('14456','Oceanside','Gateway',1),
        ('14457','Oceanside','Gateway',1),
        ('14458','Oceanside','Gateway',1),
        ('14459','Oceanside','Gateway',1),
        ('14460','Oceanside','Gateway',1),
        ('14461','Oceanside','Gateway',1),
        ('14462','Oceanside','Gateway',1),
        ('14463','Oceanside','Gateway',1),
        ('14464','Oceanside','Gateway',1),
        ('14465','Oceanside','Gateway',1),
        ('14466','Oceanside','Gateway',1),
        ('14467','Oceanside','Gateway',1),
        ('14468','Oceanside','Gateway',1),
        ('14469','Oceanside','Gateway',1),
        ('14470','Oceanside','Gateway',1),
        ('14471','Oceanside','Gateway',1),
        ('14472','Oceanside','Gateway',1),
        ('14473','Oceanside','Gateway',1),
        ('14474','Oceanside','Gateway',1),
        ('14475','Oceanside','Gateway',1),
        ('14476','Oceanside','Gateway',1),
        ('14477','Oceanside','Gateway',1),
        ('14478','Oceanside','Gateway',1),
        ('14479','Oceanside','Gateway',1),
        ('14480','Oceanside','Gateway',1),
        ('14481','Oceanside','Gateway',1),
        ('14482','Oceanside','Gateway',1),
        ('14483','Oceanside','Gateway',1),
        ('14484','Oceanside','Gateway',1),
        ('14485','Oceanside','Gateway',1),
        ('14486','Oceanside','Gateway',1),
        ('14487','Oceanside','Gateway',1),
        ('14488','Oceanside','Gateway',1),
        ('14489','Oceanside','Gateway',1),
        ('14490','Oceanside','Gateway',1),
        ('14491','Oceanside','Gateway',1),
        ('14492','Oceanside','Gateway',1),
        ('14493','Oceanside','Gateway',1),
        ('14494','Oceanside','Gateway',1),
        ('14495','Oceanside','Gateway',1),
        ('14496','Oceanside','Gateway',1),
        ('14497','Oceanside','Gateway',1),
        ('14498','Oceanside','Gateway',1),
        ('14499','Oceanside','Gateway',1),
        ('14500','Oceanside','Gateway',1),
        ('14501','Oceanside','Gateway',1),
        ('14502','Oceanside','Gateway',1),
        ('14503','Oceanside','Gateway',1),
        ('14504','Oceanside','Gateway',1),
        ('14505','Oceanside','Gateway',1),
        ('14506','Oceanside','Gateway',1),
        ('14507','Oceanside','Gateway',1),
        ('14508','Oceanside','Gateway',1),
        ('14509','Oceanside','Gateway',1),
        ('14510','Oceanside','Gateway',1),
        ('14511','Oceanside','Gateway',1),
        ('14512','Oceanside','Gateway',1),
        ('14513','Oceanside','Gateway',1),
        ('14514','Oceanside','Gateway',1),
        ('14515','Oceanside','Gateway',1),
        ('14516','Oceanside','Gateway',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('14517','Oceanside','Gateway',1),
        ('14518','Oceanside','Gateway',1),
        ('14519','Oceanside','Gateway',1),
        ('14520','Oceanside','Gateway',1),
        ('14521','Oceanside','Gateway',1),
        ('14522','Oceanside','Gateway',1),
        ('14523','Oceanside','Gateway',1),
        ('14524','Oceanside','Gateway',1),
        ('14525','Oceanside','Gateway',1),
        ('14526','Oceanside','Gateway',1),
        ('14527','Oceanside','Gateway',1),
        ('14528','Oceanside','Gateway',1),
        ('14529','Oceanside','Gateway',1),
        ('14530','Oceanside','Gateway',1),
        ('14531','Oceanside','Gateway',1),
        ('14532','Oceanside','Gateway',1),
        ('14533','Oceanside','Gateway',1),
        ('14534','Oceanside','Gateway',1),
        ('14535','Oceanside','Gateway',1),
        ('14536','Oceanside','Gateway',1),
        ('14537','Oceanside','Gateway',1),
        ('14538','Oceanside','Gateway',1),
        ('14539','Oceanside','Gateway',1),
        ('14540','Oceanside','Gateway',1),
        ('14541','Oceanside','Gateway',1),
        ('14542','Oceanside','Gateway',1),
        ('14543','Oceanside','Gateway',1),
        ('14544','Oceanside','Gateway',1),
        ('14545','Oceanside','Gateway',1),
        ('14546','Oceanside','Gateway',1),
        ('14547','Oceanside','Gateway',1),
        ('14548','Oceanside','Gateway',1),
        ('14549','Oceanside','Gateway',1),
        ('14550','Oceanside','Gateway',1),
        ('14551','Oceanside','Gateway',1),
        ('14552','Oceanside','Gateway',1),
        ('14553','Oceanside','Gateway',1),
        ('14554','Oceanside','Gateway',1),
        ('14555','Oceanside','Gateway',1),
        ('14556','Oceanside','Gateway',1),
        ('14557','Oceanside','Gateway',1),
        ('14558','Oceanside','Gateway',1),
        ('14559','Oceanside','Gateway',1),
        ('14560','Oceanside','Gateway',1),
        ('14561','Oceanside','Gateway',1),
        ('14562','Oceanside','Gateway',1),
        ('14563','Oceanside','Gateway',1),
        ('14564','Oceanside','Gateway',1),
        ('14565','Oceanside','Gateway',1),
        ('14566','Oceanside','Gateway',1),
        ('14567','Oceanside','Gateway',1),
        ('14568','Oceanside','Gateway',1),
        ('14569','Oceanside','Gateway',1),
        ('14570','Oceanside','Gateway',1),
        ('14571','Oceanside','Gateway',1),
        ('14572','Oceanside','Gateway',1),
        ('14573','Oceanside','Gateway',1),
        ('14574','Oceanside','Gateway',1),
        ('14575','Oceanside','Gateway',1),
        ('14576','Oceanside','Gateway',1),
        ('14577','Oceanside','Gateway',1),
        ('14578','Oceanside','Gateway',1),
        ('14579','Oceanside','Gateway',1),
        ('14580','Oceanside','Gateway',1),
        ('14581','Oceanside','Gateway',1),
        ('14582','Oceanside','Gateway',1),
        ('14583','Oceanside','Gateway',1),
        ('14584','Oceanside','Gateway',1),
        ('14585','Oceanside','Gateway',1),
        ('14586','Oceanside','Gateway',1),
        ('14587','Oceanside','Gateway',1),
        ('14588','Oceanside','Gateway',1),
        ('14589','Oceanside','Gateway',1),
        ('14590','Oceanside','Gateway',1),
        ('14591','Oceanside','Gateway',1),
        ('14592','Oceanside','Gateway',1),
        ('14593','Oceanside','Gateway',1),
        ('14594','Oceanside','Gateway',1),
        ('14595','Oceanside','Gateway',1),
        ('14596','Oceanside','Gateway',1),
        ('14597','Oceanside','Gateway',1),
        ('14598','Oceanside','Gateway',1),
        ('14599','Oceanside','Gateway',1),
        ('14600','Oceanside','Gateway',1),
        ('14601','Oceanside','Gateway',1),
        ('14602','Oceanside','Gateway',1),
        ('14603','Oceanside','Gateway',1),
        ('14604','Oceanside','Gateway',1),
        ('14605','Oceanside','Gateway',1),
        ('14606','Oceanside','Gateway',1),
        ('14607','Oceanside','Gateway',1),
        ('14608','Oceanside','Gateway',1),
        ('14609','Oceanside','Gateway',1),
        ('14610','Oceanside','Gateway',1),
        ('14611','Oceanside','Gateway',1),
        ('14612','Oceanside','Gateway',1),
        ('14613','Oceanside','Gateway',1),
        ('14614','Oceanside','Gateway',1),
        ('14615','Oceanside','Gateway',1),
        ('14616','Oceanside','Gateway',1),
        ('14617','Oceanside','Gateway',1),
        ('14618','Oceanside','Gateway',1),
        ('14619','Oceanside','Gateway',1),
        ('14620','Oceanside','Gateway',1),
        ('14621','Oceanside','Gateway',1),
        ('14622','Oceanside','Gateway',1),
        ('14623','Oceanside','Gateway',1),
        ('14624','Oceanside','Gateway',1),
        ('14625','Oceanside','Gateway',1),
        ('14626','Oceanside','Gateway',1),
        ('14627','Oceanside','Gateway',1),
        ('14628','Oceanside','Gateway',1),
        ('14629','Oceanside','Gateway',1),
        ('14630','Oceanside','Gateway',1),
        ('14631','Oceanside','Gateway',1),
        ('14632','Oceanside','Gateway',1),
        ('14633','Oceanside','Gateway',1),
        ('14634','Oceanside','Gateway',1),
        ('14635','Oceanside','Gateway',1),
        ('14636','Oceanside','Gateway',1),
        ('14637','Oceanside','Gateway',1),
        ('14638','Oceanside','Gateway',1),
        ('14639','Oceanside','Gateway',1),
        ('14640','Oceanside','Gateway',1),
        ('14641','Oceanside','Gateway',1),
        ('14642','Oceanside','Gateway',1),
        ('14643','Oceanside','Gateway',1),
        ('14644','Oceanside','Gateway',1),
        ('14645','Oceanside','Gateway',1),
        ('14646','Oceanside','Gateway',1),
        ('14647','Oceanside','Gateway',1),
        ('14648','Oceanside','Gateway',1),
        ('14649','Oceanside','Gateway',1),
        ('14650','Oceanside','Gateway',1),
        ('14651','Oceanside','Gateway',1),
        ('14652','Oceanside','Gateway',1),
        ('14653','Oceanside','Gateway',1),
        ('14654','Oceanside','Gateway',1),
        ('14655','Oceanside','Gateway',1),
        ('14656','Oceanside','Gateway',1),
        ('14657','Oceanside','Gateway',1),
        ('14658','Oceanside','Gateway',1),
        ('14659','Oceanside','Gateway',1),
        ('14660','Oceanside','Gateway',1),
        ('14661','Oceanside','Gateway',1),
        ('14662','Oceanside','Gateway',1),
        ('14663','Oceanside','Gateway',1),
        ('14664','Oceanside','Gateway',1),
        ('14665','Oceanside','Gateway',1),
        ('14666','Oceanside','Gateway',1),
        ('14667','Oceanside','Gateway',1),
        ('14668','Oceanside','Gateway',1),
        ('14669','Oceanside','Gateway',1),
        ('14670','Oceanside','Gateway',1),
        ('14671','Oceanside','Gateway',1),
        ('14672','Oceanside','Gateway',1),
        ('14673','Oceanside','Gateway',1),
        ('14674','Oceanside','Gateway',1),
        ('14675','Oceanside','Gateway',1),
        ('14676','Oceanside','Gateway',1),
        ('14677','Oceanside','Gateway',1),
        ('14678','Oceanside','Gateway',1),
        ('14679','Oceanside','Gateway',1),
        ('14680','Oceanside','Gateway',1),
        ('14681','Oceanside','Gateway',1),
        ('14682','Oceanside','Gateway',1),
        ('14683','Oceanside','Gateway',1),
        ('14684','Oceanside','Gateway',1),
        ('14685','Oceanside','Gateway',1),
        ('14686','Oceanside','Gateway',1),
        ('14687','Oceanside','Gateway',1),
        ('14688','Oceanside','Gateway',1),
        ('14689','Oceanside','Gateway',1),
        ('14690','Oceanside','Gateway',1),
        ('14691','Oceanside','Gateway',1),
        ('14692','Oceanside','Gateway',1),
        ('14693','Oceanside','Gateway',1),
        ('14694','Oceanside','Gateway',1),
        ('14695','Oceanside','Gateway',1),
        ('14696','Oceanside','Gateway',1),
        ('14697','Oceanside','Gateway',1),
        ('14698','Oceanside','Gateway',1),
        ('14699','Oceanside','Gateway',1),
        ('14700','Oceanside','Gateway',1),
        ('14701','Oceanside','Gateway',1),
        ('14702','Oceanside','Gateway',1),
        ('14703','Oceanside','Gateway',1),
        ('14704','Oceanside','Gateway',1),
        ('14705','Oceanside','Gateway',1),
        ('14706','Oceanside','Gateway',1),
        ('14707','Oceanside','Gateway',1),
        ('14708','Oceanside','Gateway',1),
        ('14709','Oceanside','Gateway',1),
        ('14710','Oceanside','Gateway',1),
        ('14711','Oceanside','Gateway',1),
        ('14712','Oceanside','Gateway',1),
        ('14713','Oceanside','Gateway',1),
        ('14714','Oceanside','Gateway',1),
        ('14715','Oceanside','Gateway',1),
        ('14718','Oceanside','Gateway',1),
        ('14719','Oceanside','Gateway',1),
        ('14720','Oceanside','Gateway',1),
        ('14721','Oceanside','Gateway',1),
        ('14722','Oceanside','Gateway',1),
        ('14723','Oceanside','Gateway',1),
        ('14724','Oceanside','Gateway',1),
        ('14725','Oceanside','Gateway',1),
        ('14726','Oceanside','Gateway',1),
        ('14727','Oceanside','Gateway',1),
        ('14728','Oceanside','Gateway',1),
        ('14729','Oceanside','Gateway',1),
        ('14730','Oceanside','Gateway',1),
        ('14731','Oceanside','Gateway',1),
        ('14732','Oceanside','Gateway',1),
        ('14733','Oceanside','Gateway',1),
        ('14734','Oceanside','Gateway',1),
        ('14735','Oceanside','Gateway',1),
        ('14736','Oceanside','Gateway',1),
        ('14737','Oceanside','Gateway',1),
        ('14738','Oceanside','Gateway',1),
        ('14739','Oceanside','Gateway',1),
        ('14740','Oceanside','Gateway',1),
        ('14743','Oceanside','Gateway',1),
        ('14779','Oceanside','Gateway',1),
        ('14780','Oceanside','Gateway',1),
        ('14781','Oceanside','Gateway',1),
        ('14782','Oceanside','Gateway',1),
        ('14783','Oceanside','Gateway',1),
        ('14784','Oceanside','Gateway',1),
        ('14785','Oceanside','Gateway',1),
        ('14786','Oceanside','Gateway',1),
        ('14787','Oceanside','Gateway',1),
        ('14788','Oceanside','Gateway',1),
        ('14789','Oceanside','Gateway',1),
        ('14790','Oceanside','Gateway',1),
        ('14791','Oceanside','Gateway',1),
        ('14792','Oceanside','Gateway',1),
        ('14793','Oceanside','Gateway',1),
        ('14794','Oceanside','Gateway',1),
        ('14795','Oceanside','Gateway',1),
        ('14796','Oceanside','Gateway',1),
        ('14797','Oceanside','Gateway',1),
        ('14798','Oceanside','Gateway',1),
        ('14799','Oceanside','Gateway',1),
        ('14800','Oceanside','Gateway',1),
        ('14801','Oceanside','Gateway',1),
        ('14802','Oceanside','Gateway',1),
        ('14803','Oceanside','Gateway',1),
        ('14804','Oceanside','Gateway',1),
        ('14805','Oceanside','Gateway',1),
        ('14806','Oceanside','Gateway',1),
        ('14807','Oceanside','Gateway',1),
        ('14808','Oceanside','Gateway',1),
        ('14809','Oceanside','Gateway',1),
        ('14810','Oceanside','Gateway',1),
        ('14811','Oceanside','Gateway',1),
        ('14812','Oceanside','Gateway',1),
        ('14813','Oceanside','Gateway',1),
        ('14814','Oceanside','Gateway',1),
        ('14815','Oceanside','Gateway',1),
        ('14816','Oceanside','Gateway',1),
        ('14817','Oceanside','Gateway',1),
        ('14818','Oceanside','Gateway',1),
        ('14819','Oceanside','Gateway',1),
        ('14820','Oceanside','Gateway',1),
        ('14821','Oceanside','Gateway',1),
        ('14822','Oceanside','Gateway',1),
        ('14823','Oceanside','Gateway',1),
        ('14824','Oceanside','Gateway',1),
        ('14826','Oceanside','Gateway',1),
        ('14827','Oceanside','Gateway',1),
        ('14828','Oceanside','Gateway',1),
        ('14829','Oceanside','Gateway',1),
        ('14831','Oceanside','Gateway',1),
        ('14833','Oceanside','Gateway',1),
        ('14834','Oceanside','Gateway',1),
        ('14835','Oceanside','Gateway',1),
        ('14836','Oceanside','Gateway',1),
        ('14837','Oceanside','Gateway',1),
        ('14838','Oceanside','Gateway',1),
        ('14839','Oceanside','Gateway',1),
        ('14840','Oceanside','Gateway',1),
        ('14841','Oceanside','Gateway',1),
        ('14842','Oceanside','Gateway',1),
        ('14843','Oceanside','Gateway',1),
        ('14844','Oceanside','Gateway',1),
        ('14845','Oceanside','Gateway',1),
        ('14846','Oceanside','Gateway',1),
        ('14847','Oceanside','Gateway',1),
        ('14848','Oceanside','Gateway',1),
        ('14849','Oceanside','Gateway',1),
        ('14850','Oceanside','Gateway',1),
        ('14851','Oceanside','Gateway',1),
        ('14852','Oceanside','Gateway',1),
        ('14853','Oceanside','Gateway',1),
        ('14854','Oceanside','Gateway',1),
        ('14855','Oceanside','Gateway',1),
        ('14856','Oceanside','Gateway',1),
        ('14857','Oceanside','Gateway',1),
        ('15066','Oceanside','Gateway',1),
        ('15068','Oceanside','Gateway',1),
        ('15069','Oceanside','Gateway',1),
        ('15070','Oceanside','Gateway',1),
        ('15081','Oceanside','Gateway',1),
        ('15082','Oceanside','Gateway',1),
        ('15083','Oceanside','Gateway',1),
        ('15084','Oceanside','Gateway',1),
        ('15085','Oceanside','Gateway',1),
        ('15086','Oceanside','Gateway',1),
        ('15087','Oceanside','Gateway',1),
        ('15088','Oceanside','Gateway',1),
        ('15089','Oceanside','Gateway',1),
        ('15090','Oceanside','Gateway',1),
        ('15091','Oceanside','Gateway',1),
        ('15092','Oceanside','Gateway',1),
        ('15093','Oceanside','Gateway',1),
        ('15094','Oceanside','Gateway',1),
        ('15095','Oceanside','Gateway',1),
        ('15096','Oceanside','Gateway',1),
        ('15097','Oceanside','Gateway',1),
        ('15098','Oceanside','Gateway',1),
        ('15099','Oceanside','Gateway',1),
        ('15100','Oceanside','Gateway',1),
        ('15101','Oceanside','Gateway',1),
        ('15102','Oceanside','Gateway',1),
        ('15103','Oceanside','Gateway',1),
        ('15104','Oceanside','Gateway',1),
        ('15105','Oceanside','Gateway',1),
        ('15106','Oceanside','Gateway',1),
        ('15107','Oceanside','Gateway',1),
        ('15108','Oceanside','Gateway',1),
        ('15109','Oceanside','Gateway',1),
        ('15110','Oceanside','Gateway',1),
        ('15111','Oceanside','Gateway',1),
        ('15112','Oceanside','Gateway',1),
        ('15113','Oceanside','Gateway',1),
        ('15114','Oceanside','Gateway',1),
        ('15115','Oceanside','Gateway',1),
        ('15116','Oceanside','Gateway',1),
        ('15117','Oceanside','Gateway',1),
        ('15118','Oceanside','Gateway',1),
        ('15119','Oceanside','Gateway',1),
        ('15120','Oceanside','Gateway',1),
        ('15121','Oceanside','Gateway',1),
        ('15122','Oceanside','Gateway',1),
        ('15123','Oceanside','Gateway',1),
        ('15124','Oceanside','Gateway',1),
        ('15125','Oceanside','Gateway',1),
        ('15126','Oceanside','Gateway',1),
        ('15127','Oceanside','Gateway',1),
        ('15128','Oceanside','Gateway',1),
        ('15129','Oceanside','Gateway',1),
        ('15130','Oceanside','Gateway',1),
        ('15131','Oceanside','Gateway',1),
        ('15132','Oceanside','Gateway',1),
        ('15133','Oceanside','Gateway',1),
        ('15134','Oceanside','Gateway',1),
        ('15135','Oceanside','Gateway',1),
        ('16814','Vista','Suburban',0),
        ('16815','Vista','Suburban',0),
        ('16818','Vista','Suburban',0),
        ('16819','Vista','Suburban',0),
        ('16820','Vista','Suburban',0),
        ('16821','Vista','Suburban',0),
        ('16822','Vista','Suburban',0),
        ('16823','Vista','Suburban',0),
        ('16824','Vista','Suburban',0),
        ('16825','Vista','Suburban',0),
        ('16826','Vista','Suburban',0),
        ('16827','Vista','Suburban',0),
        ('16828','Vista','Suburban',0),
        ('16829','Vista','Suburban',0),
        ('16830','Vista','Suburban',0),
        ('16831','Vista','Suburban',0),
        ('16832','Vista','Suburban',0),
        ('16833','Vista','Suburban',0),
        ('16834','Vista','Suburban',0),
        ('16835','Vista','Suburban',0),
        ('16836','Vista','Suburban',0),
        ('16837','Vista','Suburban',0),
        ('16838','Vista','Suburban',0),
        ('16839','Vista','Suburban',0),
        ('16840','Vista','Suburban',0),
        ('16841','Vista','Suburban',0),
        ('16842','Vista','Suburban',0),
        ('16843','Vista','Suburban',0),
        ('16844','Vista','Suburban',0),
        ('16845','Vista','Suburban',0),
        ('16846','Vista','Suburban',0),
        ('16847','Vista','Suburban',0),
        ('16848','Vista','Suburban',0),
        ('16849','Vista','Suburban',0),
        ('16850','Vista','Suburban',0),
        ('16851','Vista','Suburban',0),
        ('16852','Vista','Suburban',0),
        ('16853','Vista','Suburban',0),
        ('16854','Vista','Suburban',0),
        ('16855','Vista','Suburban',0),
        ('16958','Vista','Suburban',0),
        ('16959','Vista','Suburban',0),
        ('16960','Vista','Suburban',0),
        ('16961','Vista','Suburban',0),
        ('16962','Vista','Suburban',0),
        ('17182','Vista','Suburban',0),
        ('17183','Vista','Suburban',0),
        ('17185','Vista','Suburban',0),
        ('17187','Vista','Suburban',0),
        ('17188','Vista','Suburban',0),
        ('17189','Vista','Suburban',0),
        ('17206','Vista','Suburban',0),
        ('17213','Vista','Suburban',0),
        ('17220','Vista','Suburban',0),
        ('17227','Vista','Suburban',0),
        ('17229','Vista','Suburban',0),
        ('17232','Vista','Suburban',0),
        ('17274','Vista','Suburban',0),
        ('17276','Vista','Suburban',0),
        ('17278','Vista','Suburban',0),
        ('17279','Vista','Suburban',0),
        ('17280','Vista','Suburban',0),
        ('17281','Vista','Suburban',0),
        ('17282','Vista','Suburban',0),
        ('17290','Vista','Suburban',0),
        ('17291','Vista','Suburban',0),
        ('17292','Vista','Suburban',0),
        ('17293','Vista','Suburban',0),
        ('17295','Vista','Suburban',0),
        ('17296','Vista','Suburban',0),
        ('17297','Vista','Suburban',0),
        ('17298','Vista','Suburban',0),
        ('17299','Vista','Suburban',0),
        ('17300','Vista','Suburban',0),
        ('17301','Vista','Suburban',0),
        ('17302','Vista','Suburban',0),
        ('17303','Vista','Suburban',0),
        ('17304','Vista','Suburban',0),
        ('17305','Vista','Suburban',0),
        ('17306','Vista','Suburban',0),
        ('17307','Vista','Suburban',0),
        ('17308','Vista','Suburban',0),
        ('17309','Vista','Suburban',0),
        ('17310','Vista','Suburban',0),
        ('17311','Vista','Suburban',0),
        ('17312','Vista','Suburban',0),
        ('17313','Vista','Suburban',0),
        ('17314','Vista','Suburban',0),
        ('17315','Vista','Suburban',0),
        ('17316','Vista','Suburban',0),
        ('17317','Vista','Suburban',0),
        ('17318','Vista','Suburban',0),
        ('17319','Vista','Suburban',0),
        ('17320','Vista','Suburban',0),
        ('17321','Vista','Suburban',0),
        ('17322','Vista','Suburban',0),
        ('17323','Vista','Suburban',0),
        ('17324','Vista','Suburban',0),
        ('17325','Vista','Suburban',0),
        ('17326','Vista','Suburban',0),
        ('17327','Vista','Suburban',0),
        ('17328','Vista','Suburban',0),
        ('17329','Vista','Suburban',0),
        ('17330','Vista','Suburban',0),
        ('17331','Vista','Suburban',0),
        ('17332','Vista','Suburban',0),
        ('17333','Vista','Suburban',0),
        ('17334','Vista','Suburban',0),
        ('17335','Vista','Suburban',0),
        ('17336','Vista','Suburban',0),
        ('17337','Vista','Suburban',0),
        ('17338','Vista','Suburban',0),
        ('17339','Vista','Suburban',0),
        ('17340','Vista','Suburban',0),
        ('17341','Vista','Suburban',0),
        ('17342','Vista','Suburban',0),
        ('17343','Vista','Suburban',0),
        ('17344','Vista','Suburban',0),
        ('17345','Vista','Suburban',0),
        ('17346','Vista','Suburban',0),
        ('17347','Vista','Suburban',0),
        ('17348','Vista','Suburban',0),
        ('17349','Vista','Suburban',0),
        ('17350','Vista','Suburban',0),
        ('17351','Vista','Suburban',0),
        ('17352','Vista','Suburban',0),
        ('17353','Vista','Suburban',0),
        ('17354','Vista','Suburban',0),
        ('17355','Vista','Suburban',0),
        ('17356','Vista','Suburban',0),
        ('17357','Vista','Suburban',0),
        ('17358','Vista','Suburban',0),
        ('17359','Vista','Suburban',0),
        ('17360','Vista','Suburban',0),
        ('17361','Vista','Suburban',0),
        ('17362','Vista','Suburban',0),
        ('17363','Vista','Suburban',0),
        ('17364','Vista','Suburban',0),
        ('17365','Vista','Suburban',0),
        ('17366','Vista','Suburban',0),
        ('17367','Vista','Suburban',0),
        ('17368','Vista','Suburban',0),
        ('17369','Vista','Suburban',0),
        ('17370','Vista','Suburban',0),
        ('17371','Vista','Suburban',0),
        ('17372','Vista','Suburban',0),
        ('17373','Vista','Suburban',0),
        ('17374','Vista','Suburban',0),
        ('17375','Vista','Suburban',0),
        ('17376','Vista','Suburban',0),
        ('17377','Vista','Suburban',0),
        ('17378','Vista','Suburban',0),
        ('17379','Vista','Suburban',0),
        ('17380','Vista','Suburban',0),
        ('17381','Vista','Suburban',0),
        ('17382','Vista','Suburban',0),
        ('17383','Vista','Suburban',0),
        ('17384','Vista','Suburban',0),
        ('17385','Vista','Suburban',0),
        ('17386','Vista','Suburban',0),
        ('17387','Vista','Suburban',0),
        ('17388','Vista','Suburban',0),
        ('17389','Vista','Suburban',0),
        ('17390','Vista','Suburban',0),
        ('17391','Vista','Suburban',0),
        ('17392','Vista','Suburban',0),
        ('17393','Vista','Suburban',0),
        ('17395','Vista','Suburban',0),
        ('17398','Vista','Suburban',0),
        ('17399','Vista','Suburban',0),
        ('17400','Vista','Suburban',0),
        ('17401','Vista','Suburban',0),
        ('17405','Vista','Suburban',0),
        ('17406','Vista','Suburban',0),
        ('17408','Vista','Suburban',0),
        ('17409','Vista','Suburban',0),
        ('17410','Vista','Suburban',0),
        ('17411','Vista','Suburban',0),
        ('17412','Vista','Suburban',0),
        ('17413','Vista','Suburban',0),
        ('17414','Vista','Suburban',0),
        ('17415','Vista','Suburban',0),
        ('17417','Vista','Suburban',0),
        ('17418','Vista','Suburban',0),
        ('17419','Vista','Suburban',0),
        ('17420','Vista','Suburban',0),
        ('17421','Vista','Suburban',0),
        ('17422','Vista','Suburban',0),
        ('17423','Vista','Suburban',0),
        ('17424','Vista','Suburban',0),
        ('17425','Vista','Suburban',0),
        ('17426','Vista','Suburban',0),
        ('17427','Vista','Suburban',0),
        ('17428','Vista','Suburban',0),
        ('17429','Vista','Suburban',0),
        ('17430','Vista','Suburban',0),
        ('17431','Vista','Suburban',0),
        ('17432','Vista','Suburban',0),
        ('17433','Vista','Suburban',0),
        ('17434','Vista','Suburban',0),
        ('17440','Vista','Suburban',0),
        ('17441','Vista','Suburban',0),
        ('17442','Vista','Suburban',0),
        ('17443','Vista','Suburban',0),
        ('17444','Vista','Suburban',0),
        ('17445','Vista','Suburban',0),
        ('17447','Vista','Suburban',0),
        ('17448','Vista','Suburban',0),
        ('17450','Vista','Suburban',0),
        ('17451','Vista','Suburban',0),
        ('17452','Vista','Suburban',0),
        ('17453','Vista','Suburban',0),
        ('17455','Vista','Suburban',0),
        ('17456','Vista','Suburban',0),
        ('17458','Vista','Suburban',0),
        ('17480','Vista','Suburban',0),
        ('17496','Vista','Suburban',0),
        ('17497','Vista','Suburban',0),
        ('17498','Vista','Suburban',0),
        ('17499','Vista','Suburban',0),
        ('17500','Vista','Suburban',0),
        ('17501','Vista','Suburban',0),
        ('17502','Vista','Suburban',0),
        ('17503','Vista','Suburban',0),
        ('17528','Vista','Suburban',0),
        ('17532','Vista','Suburban',0),
        ('17534','Vista','Suburban',0),
        ('17535','Vista','Suburban',0),
        ('17550','Vista','Suburban',0),
        ('17551','Vista','Suburban',0),
        ('17552','Vista','Suburban',0),
        ('17553','Vista','Suburban',0),
        ('17554','Vista','Suburban',0),
        ('17555','Vista','Suburban',0),
        ('17556','Vista','Suburban',0),
        ('17557','Vista','Suburban',0),
        ('17558','Vista','Suburban',0),
        ('17560','Vista','Suburban',0),
        ('17561','Vista','Suburban',0),
        ('17562','Vista','Suburban',0),
        ('17564','Vista','Suburban',0),
        ('17567','Vista','Suburban',0),
        ('17568','Vista','Suburban',0),
        ('17569','Vista','Suburban',0),
        ('17570','Vista','Suburban',0),
        ('17571','Vista','Suburban',0),
        ('17572','Vista','Suburban',0),
        ('17573','Vista','Suburban',0),
        ('17574','Vista','Suburban',0),
        ('17575','Vista','Suburban',0),
        ('17576','Vista','Suburban',0),
        ('17577','Vista','Suburban',0),
        ('17578','Vista','Suburban',0),
        ('17579','Vista','Suburban',0),
        ('17702','Carlsbad Palomar','Major Employment Center',1),
        ('17703','Carlsbad Palomar','Major Employment Center',1),
        ('17704','Carlsbad Palomar','Major Employment Center',1),
        ('17705','Carlsbad Palomar','Major Employment Center',1),
        ('17706','Carlsbad Palomar','Major Employment Center',1),
        ('17707','Carlsbad Palomar','Major Employment Center',1),
        ('17708','Carlsbad Palomar','Major Employment Center',1),
        ('17709','Carlsbad Palomar','Major Employment Center',1),
        ('17710','Carlsbad Palomar','Major Employment Center',1),
        ('17711','Carlsbad Palomar','Major Employment Center',1),
        ('17712','Carlsbad Palomar','Major Employment Center',1),
        ('17713','Carlsbad Palomar','Major Employment Center',1),
        ('17714','Carlsbad Palomar','Major Employment Center',1),
        ('17715','Carlsbad Palomar','Major Employment Center',1),
        ('17716','Carlsbad Palomar','Major Employment Center',1),
        ('17717','Carlsbad Palomar','Major Employment Center',1),
        ('17718','Carlsbad Palomar','Major Employment Center',1),
        ('17719','Carlsbad Palomar','Major Employment Center',1),
        ('17720','Carlsbad Palomar','Major Employment Center',1),
        ('17721','Carlsbad Palomar','Major Employment Center',1),
        ('17722','Carlsbad Palomar','Major Employment Center',1),
        ('17723','Carlsbad Palomar','Major Employment Center',1),
        ('17724','Carlsbad Palomar','Major Employment Center',1),
        ('17725','Carlsbad Palomar','Major Employment Center',1),
        ('17726','Carlsbad Palomar','Major Employment Center',1),
        ('17727','Carlsbad Palomar','Major Employment Center',1),
        ('17735','Carlsbad Palomar','Major Employment Center',1),
        ('17736','Carlsbad Palomar','Major Employment Center',1),
        ('17737','Carlsbad Palomar','Major Employment Center',1),
        ('17738','Carlsbad Palomar','Major Employment Center',1),
        ('17739','Carlsbad Palomar','Major Employment Center',1),
        ('17740','Carlsbad Palomar','Major Employment Center',1),
        ('17741','Carlsbad Palomar','Major Employment Center',1),
        ('17742','Carlsbad Palomar','Major Employment Center',1),
        ('17743','Carlsbad Palomar','Major Employment Center',1),
        ('17981','Carlsbad Palomar','Major Employment Center',1),
        ('17982','Carlsbad Palomar','Major Employment Center',1),
        ('17983','Carlsbad Palomar','Major Employment Center',1),
        ('17984','Carlsbad Palomar','Major Employment Center',1),
        ('17985','Carlsbad Palomar','Major Employment Center',1),
        ('17988','Carlsbad Palomar','Major Employment Center',1),
        ('17994','Carlsbad Palomar','Major Employment Center',1),
        ('18015','Carlsbad Palomar','Major Employment Center',1),
        ('18016','Carlsbad Palomar','Major Employment Center',1),
        ('18017','Carlsbad Palomar','Major Employment Center',1),
        ('18018','Carlsbad Palomar','Major Employment Center',1),
        ('18035','Carlsbad Palomar','Major Employment Center',1),
        ('18036','Carlsbad Palomar','Major Employment Center',1),
        ('18179','Carlsbad Palomar','Major Employment Center',1),
        ('18180','Carlsbad Palomar','Major Employment Center',1),
        ('18191','Carlsbad Palomar','Major Employment Center',1),
        ('18194','Carlsbad Palomar','Major Employment Center',1),
        ('18197','Carlsbad Palomar','Major Employment Center',1),
        ('18199','Carlsbad Palomar','Major Employment Center',1),
        ('18200','Carlsbad Palomar','Major Employment Center',1),
        ('18204','Carlsbad Palomar','Major Employment Center',1),
        ('18205','Carlsbad Palomar','Major Employment Center',1),
        ('18221','San Marcos','Major Employment Center',1),
        ('18222','San Marcos','Major Employment Center',1),
        ('18224','San Marcos','Major Employment Center',1),
        ('18225','San Marcos','Major Employment Center',1),
        ('18232','San Marcos','Major Employment Center',1),
        ('18236','San Marcos','Major Employment Center',1),
        ('18255','San Marcos','Major Employment Center',1),
        ('18256','San Marcos','Major Employment Center',1),
        ('18257','San Marcos','Major Employment Center',1),
        ('18259','San Marcos','Major Employment Center',1),
        ('18261','San Marcos','Major Employment Center',1),
        ('18264','Carlsbad Palomar','Major Employment Center',1),
        ('18291','San Marcos','Major Employment Center',1),
        ('18292','San Marcos','Major Employment Center',1),
        ('18293','San Marcos','Major Employment Center',1),
        ('18294','San Marcos','Major Employment Center',1),
        ('18295','San Marcos','Major Employment Center',1),
        ('18296','San Marcos','Major Employment Center',1),
        ('18297','San Marcos','Major Employment Center',1),
        ('18298','San Marcos','Major Employment Center',1),
        ('18299','San Marcos','Major Employment Center',1),
        ('18310','San Marcos','Major Employment Center',1),
        ('18312','San Marcos','Major Employment Center',1),
        ('18313','San Marcos','Major Employment Center',1),
        ('18314','San Marcos','Major Employment Center',1),
        ('18315','San Marcos','Major Employment Center',1),
        ('18316','San Marcos','Major Employment Center',1),
        ('18317','San Marcos','Major Employment Center',1),
        ('18318','San Marcos','Major Employment Center',1),
        ('18319','San Marcos','Major Employment Center',1),
        ('18320','San Marcos','Major Employment Center',1),
        ('18321','San Marcos','Major Employment Center',1),
        ('18322','San Marcos','Major Employment Center',1),
        ('18323','San Marcos','Major Employment Center',1),
        ('18324','San Marcos','Major Employment Center',1),
        ('18325','San Marcos','Major Employment Center',1),
        ('18326','San Marcos','Major Employment Center',1),
        ('18327','San Marcos','Major Employment Center',1),
        ('18328','San Marcos','Major Employment Center',1),
        ('18329','San Marcos','Major Employment Center',1),
        ('18330','San Marcos','Major Employment Center',1),
        ('18331','San Marcos','Major Employment Center',1),
        ('18332','San Marcos','Major Employment Center',1),
        ('18333','San Marcos','Major Employment Center',1),
        ('18334','San Marcos','Major Employment Center',1),
        ('18335','San Marcos','Major Employment Center',1),
        ('18336','San Marcos','Major Employment Center',1),
        ('18337','San Marcos','Major Employment Center',1),
        ('18340','San Marcos','Major Employment Center',1),
        ('18342','San Marcos','Major Employment Center',1),
        ('18355','San Marcos','Major Employment Center',1),
        ('18356','San Marcos','Major Employment Center',1),
        ('18357','San Marcos','Major Employment Center',1),
        ('18358','San Marcos','Major Employment Center',1),
        ('18359','San Marcos','Major Employment Center',1),
        ('18368','San Marcos','Major Employment Center',1),
        ('18369','San Marcos','Major Employment Center',1),
        ('18370','San Marcos','Major Employment Center',1),
        ('18371','San Marcos','Major Employment Center',1),
        ('18373','San Marcos','Major Employment Center',1),
        ('18374','San Marcos','Major Employment Center',1),
        ('18377','San Marcos','Major Employment Center',1),
        ('18378','San Marcos','Major Employment Center',1),
        ('18379','San Marcos','Major Employment Center',1),
        ('18380','San Marcos','Major Employment Center',1),
        ('18382','San Marcos','Major Employment Center',1),
        ('18383','San Marcos','Major Employment Center',1),
        ('18384','San Marcos','Major Employment Center',1),
        ('18385','San Marcos','Major Employment Center',1),
        ('18386','San Marcos','Major Employment Center',1),
        ('18387','San Marcos','Major Employment Center',1),
        ('18388','San Marcos','Major Employment Center',1),
        ('18389','San Marcos','Major Employment Center',1),
        ('18390','San Marcos','Major Employment Center',1),
        ('18391','San Marcos','Major Employment Center',1),
        ('18392','San Marcos','Major Employment Center',1),
        ('18393','San Marcos','Major Employment Center',1),
        ('18394','San Marcos','Major Employment Center',1),
        ('18395','San Marcos','Major Employment Center',1),
        ('18396','San Marcos','Major Employment Center',1),
        ('18397','San Marcos','Major Employment Center',1),
        ('18399','San Marcos','Major Employment Center',1),
        ('18420','Escondido','Gateway',1),
        ('18421','Escondido','Gateway',1),
        ('18422','Escondido','Gateway',1),
        ('18423','Escondido','Gateway',1),
        ('18429','San Marcos','Major Employment Center',1),
        ('18436','San Marcos','Major Employment Center',1),
        ('18445','Escondido','Gateway',1),
        ('18446','Escondido','Gateway',1),
        ('18448','Escondido','Gateway',1),
        ('18449','Escondido','Gateway',1),
        ('18450','San Marcos','Major Employment Center',1),
        ('18451','San Marcos','Major Employment Center',1),
        ('18452','San Marcos','Major Employment Center',1),
        ('18453','San Marcos','Major Employment Center',1),
        ('18454','San Marcos','Major Employment Center',1),
        ('18455','San Marcos','Major Employment Center',1),
        ('18456','San Marcos','Major Employment Center',1),
        ('18457','San Marcos','Major Employment Center',1),
        ('18458','San Marcos','Major Employment Center',1),
        ('18459','San Marcos','Major Employment Center',1),
        ('18460','San Marcos','Major Employment Center',1),
        ('18461','San Marcos','Major Employment Center',1),
        ('18462','San Marcos','Major Employment Center',1),
        ('18463','San Marcos','Major Employment Center',1),
        ('18464','San Marcos','Major Employment Center',1),
        ('18465','San Marcos','Major Employment Center',1),
        ('18466','San Marcos','Major Employment Center',1),
        ('18467','San Marcos','Major Employment Center',1),
        ('18468','San Marcos','Major Employment Center',1),
        ('18469','San Marcos','Major Employment Center',1),
        ('18470','San Marcos','Major Employment Center',1),
        ('18471','San Marcos','Major Employment Center',1),
        ('18472','San Marcos','Major Employment Center',1),
        ('18473','San Marcos','Major Employment Center',1),
        ('18474','San Marcos','Major Employment Center',1),
        ('18475','San Marcos','Major Employment Center',1),
        ('18476','San Marcos','Major Employment Center',1),
        ('18477','San Marcos','Major Employment Center',1),
        ('18478','San Marcos','Major Employment Center',1),
        ('18482','San Marcos','Major Employment Center',1),
        ('18483','San Marcos','Major Employment Center',1),
        ('18484','San Marcos','Major Employment Center',1),
        ('18485','San Marcos','Major Employment Center',1),
        ('18486','San Marcos','Major Employment Center',1),
        ('18487','San Marcos','Major Employment Center',1),
        ('18488','San Marcos','Major Employment Center',1),
        ('18489','San Marcos','Major Employment Center',1),
        ('18490','San Marcos','Major Employment Center',1),
        ('18491','San Marcos','Major Employment Center',1),
        ('18492','San Marcos','Major Employment Center',1),
        ('18493','San Marcos','Major Employment Center',1),
        ('18494','San Marcos','Major Employment Center',1),
        ('18495','San Marcos','Major Employment Center',1),
        ('18496','San Marcos','Major Employment Center',1),
        ('18497','San Marcos','Major Employment Center',1),
        ('18498','San Marcos','Major Employment Center',1),
        ('18499','San Marcos','Major Employment Center',1),
        ('18536','San Marcos','Major Employment Center',1),
        ('18541','San Marcos','Major Employment Center',1),
        ('18542','San Marcos','Major Employment Center',1),
        ('18564','San Marcos','Major Employment Center',1),
        ('18565','San Marcos','Major Employment Center',1),
        ('18566','San Marcos','Major Employment Center',1),
        ('18567','San Marcos','Major Employment Center',1),
        ('18568','San Marcos','Major Employment Center',1),
        ('18569','San Marcos','Major Employment Center',1),
        ('18570','San Marcos','Major Employment Center',1),
        ('18571','San Marcos','Major Employment Center',1),
        ('18572','San Marcos','Major Employment Center',1),
        ('18573','San Marcos','Major Employment Center',1),
        ('18574','San Marcos','Major Employment Center',1),
        ('18575','San Marcos','Major Employment Center',1),
        ('18576','San Marcos','Major Employment Center',1),
        ('18577','San Marcos','Major Employment Center',1),
        ('18578','San Marcos','Major Employment Center',1),
        ('18579','San Marcos','Major Employment Center',1),
        ('18580','San Marcos','Major Employment Center',1),
        ('18581','San Marcos','Major Employment Center',1),
        ('18582','San Marcos','Major Employment Center',1),
        ('18583','San Marcos','Major Employment Center',1),
        ('18584','San Marcos','Major Employment Center',1),
        ('18585','San Marcos','Major Employment Center',1),
        ('18586','San Marcos','Major Employment Center',1),
        ('18587','San Marcos','Major Employment Center',1),
        ('18588','San Marcos','Major Employment Center',1),
        ('18589','San Marcos','Major Employment Center',1),
        ('18590','San Marcos','Major Employment Center',1),
        ('18591','San Marcos','Major Employment Center',1),
        ('18592','San Marcos','Major Employment Center',1),
        ('18593','San Marcos','Major Employment Center',1),
        ('18594','San Marcos','Major Employment Center',1),
        ('18595','San Marcos','Major Employment Center',1),
        ('18596','San Marcos','Major Employment Center',1),
        ('18597','San Marcos','Major Employment Center',1),
        ('18598','San Marcos','Major Employment Center',1),
        ('18599','San Marcos','Major Employment Center',1),
        ('18600','San Marcos','Major Employment Center',1),
        ('18601','San Marcos','Major Employment Center',1),
        ('18602','San Marcos','Major Employment Center',1),
        ('18603','San Marcos','Major Employment Center',1),
        ('18604','San Marcos','Major Employment Center',1),
        ('18605','San Marcos','Major Employment Center',1),
        ('18606','San Marcos','Major Employment Center',1),
        ('18607','San Marcos','Major Employment Center',1),
        ('18608','San Marcos','Major Employment Center',1),
        ('18609','San Marcos','Major Employment Center',1),
        ('18610','San Marcos','Major Employment Center',1),
        ('18611','San Marcos','Major Employment Center',1),
        ('18612','San Marcos','Major Employment Center',1),
        ('18613','San Marcos','Major Employment Center',1),
        ('18614','San Marcos','Major Employment Center',1),
        ('18615','San Marcos','Major Employment Center',1),
        ('18616','San Marcos','Major Employment Center',1),
        ('18635','Escondido','Gateway',1),
        ('18636','Escondido','Gateway',1),
        ('18638','Escondido','Gateway',1),
        ('18776','Escondido','Gateway',1),
        ('18779','Escondido','Gateway',1),
        ('18780','Escondido','Gateway',1),
        ('18781','Escondido','Gateway',1),
        ('18782','Escondido','Gateway',1),
        ('18783','Escondido','Gateway',1),
        ('18784','Escondido','Gateway',1),
        ('18785','Escondido','Gateway',1),
        ('18786','Escondido','Gateway',1),
        ('18787','Escondido','Gateway',1),
        ('18788','Escondido','Gateway',1),
        ('18790','Escondido','Gateway',1),
        ('18791','Escondido','Gateway',1),
        ('18792','Escondido','Gateway',1),
        ('18793','Escondido','Gateway',1),
        ('18794','Escondido','Gateway',1),
        ('18795','Escondido','Gateway',1),
        ('18796','Escondido','Gateway',1),
        ('18797','Escondido','Gateway',1),
        ('18798','Escondido','Gateway',1),
        ('18799','Escondido','Gateway',1),
        ('18800','Escondido','Gateway',1),
        ('18801','Escondido','Gateway',1),
        ('18802','Escondido','Gateway',1),
        ('18803','Escondido','Gateway',1),
        ('18805','Escondido','Gateway',1),
        ('18806','Escondido','Gateway',1),
        ('18807','Escondido','Gateway',1),
        ('18808','Escondido','Gateway',1),
        ('18809','Escondido','Gateway',1),
        ('18810','Escondido','Gateway',1),
        ('18811','Escondido','Gateway',1),
        ('18812','Escondido','Gateway',1),
        ('18813','Escondido','Gateway',1),
        ('18814','Escondido','Gateway',1),
        ('18815','Escondido','Gateway',1),
        ('18824','Escondido','Gateway',1),
        ('18825','Escondido','Gateway',1),
        ('18826','Escondido','Gateway',1),
        ('18827','Escondido','Gateway',1),
        ('18828','Escondido','Gateway',1),
        ('18834','Escondido','Gateway',1),
        ('18835','Escondido','Gateway',1),
        ('18836','Escondido','Gateway',1),
        ('18837','Escondido','Gateway',1),
        ('18838','Escondido','Gateway',1),
        ('18839','Escondido','Gateway',1),
        ('18840','Escondido','Gateway',1),
        ('18841','Escondido','Gateway',1),
        ('18842','Escondido','Gateway',1),
        ('18843','Escondido','Gateway',1),
        ('18844','Escondido','Gateway',1),
        ('18845','Escondido','Gateway',1),
        ('18846','Escondido','Gateway',1),
        ('18847','Escondido','Gateway',1),
        ('18848','Escondido','Gateway',1),
        ('18849','Escondido','Gateway',1),
        ('18850','Escondido','Gateway',1),
        ('18851','Escondido','Gateway',1),
        ('18852','Escondido','Gateway',1),
        ('18853','Escondido','Gateway',1),
        ('18854','Escondido','Gateway',1),
        ('18855','Escondido','Gateway',1),
        ('18856','Escondido','Gateway',1),
        ('18857','Escondido','Gateway',1),
        ('18858','Escondido','Gateway',1),
        ('18859','Escondido','Gateway',1),
        ('18860','Escondido','Gateway',1),
        ('18861','Escondido','Gateway',1),
        ('18862','Escondido','Gateway',1),
        ('18863','Escondido','Gateway',1),
        ('18864','Escondido','Gateway',1),
        ('18865','Escondido','Gateway',1),
        ('18866','Escondido','Gateway',1),
        ('18867','Escondido','Gateway',1),
        ('18868','Escondido','Gateway',1),
        ('18869','Escondido','Gateway',1),
        ('18870','Escondido','Gateway',1),
        ('18871','Escondido','Gateway',1),
        ('18872','Escondido','Gateway',1),
        ('18873','Escondido','Gateway',1),
        ('18874','Escondido','Gateway',1),
        ('18875','Escondido','Gateway',1),
        ('18876','Escondido','Gateway',1),
        ('18877','Escondido','Gateway',1),
        ('18878','Escondido','Gateway',1),
        ('18879','Escondido','Gateway',1),
        ('18880','Escondido','Gateway',1),
        ('18881','Escondido','Gateway',1),
        ('18882','Escondido','Gateway',1),
        ('18883','Escondido','Gateway',1),
        ('18884','Escondido','Gateway',1),
        ('18885','Escondido','Gateway',1),
        ('18886','Escondido','Gateway',1),
        ('18887','Escondido','Gateway',1),
        ('18888','Escondido','Gateway',1),
        ('18889','Escondido','Gateway',1),
        ('18890','Escondido','Gateway',1),
        ('18891','Escondido','Gateway',1),
        ('18892','Escondido','Gateway',1),
        ('18893','Escondido','Gateway',1),
        ('18894','Escondido','Gateway',1),
        ('18895','Escondido','Gateway',1),
        ('18896','Escondido','Gateway',1),
        ('18897','Escondido','Gateway',1),
        ('18898','Escondido','Gateway',1),
        ('18899','Escondido','Gateway',1),
        ('18900','Escondido','Gateway',1),
        ('18901','Escondido','Gateway',1),
        ('18902','Escondido','Gateway',1),
        ('18903','Escondido','Gateway',1),
        ('18904','Escondido','Gateway',1),
        ('18905','Escondido','Gateway',1),
        ('18906','Escondido','Gateway',1),
        ('18907','Escondido','Gateway',1),
        ('18908','Escondido','Gateway',1),
        ('18909','Escondido','Gateway',1),
        ('18910','Escondido','Gateway',1),
        ('18911','Escondido','Gateway',1),
        ('18912','Escondido','Gateway',1),
        ('18913','Escondido','Gateway',1),
        ('18914','Escondido','Gateway',1)
    INSERT INTO [rp_2021].[mobility_hubs] VALUES
        ('18915','Escondido','Gateway',1),
        ('18916','Escondido','Gateway',1),
        ('18917','Escondido','Gateway',1),
        ('18918','Escondido','Gateway',1),
        ('18919','Escondido','Gateway',1),
        ('18920','Escondido','Gateway',1),
        ('18921','Escondido','Gateway',1),
        ('18922','Escondido','Gateway',1),
        ('18923','Escondido','Gateway',1),
        ('18924','Escondido','Gateway',1),
        ('18925','Escondido','Gateway',1),
        ('18926','Escondido','Gateway',1),
        ('18927','Escondido','Gateway',1),
        ('18928','Escondido','Gateway',1),
        ('18929','Escondido','Gateway',1),
        ('18930','Escondido','Gateway',1),
        ('18931','Escondido','Gateway',1),
        ('18932','Escondido','Gateway',1),
        ('18933','Escondido','Gateway',1),
        ('18934','Escondido','Gateway',1),
        ('18935','Escondido','Gateway',1),
        ('18936','Escondido','Gateway',1),
        ('18937','Escondido','Gateway',1),
        ('18938','Escondido','Gateway',1),
        ('18939','Escondido','Gateway',1),
        ('18940','Escondido','Gateway',1),
        ('18941','Escondido','Gateway',1),
        ('18942','Escondido','Gateway',1),
        ('18943','Escondido','Gateway',1),
        ('18944','Escondido','Gateway',1),
        ('18945','Escondido','Gateway',1),
        ('18946','Escondido','Gateway',1),
        ('18947','Escondido','Gateway',1),
        ('18948','Escondido','Gateway',1),
        ('18949','Escondido','Gateway',1),
        ('18950','Escondido','Gateway',1),
        ('18951','Escondido','Gateway',1),
        ('18952','Escondido','Gateway',1),
        ('18953','Escondido','Gateway',1),
        ('18954','Escondido','Gateway',1),
        ('18955','Escondido','Gateway',1),
        ('18956','Escondido','Gateway',1),
        ('18957','Escondido','Gateway',1),
        ('18958','Escondido','Gateway',1),
        ('18959','Escondido','Gateway',1),
        ('18960','Escondido','Gateway',1),
        ('18961','Escondido','Gateway',1),
        ('18962','Escondido','Gateway',1),
        ('18963','Escondido','Gateway',1),
        ('18964','Escondido','Gateway',1),
        ('18965','Escondido','Gateway',1),
        ('18966','Escondido','Gateway',1),
        ('18967','Escondido','Gateway',1),
        ('18968','Escondido','Gateway',1),
        ('18969','Escondido','Gateway',1),
        ('18970','Escondido','Gateway',1),
        ('18971','Escondido','Gateway',1),
        ('18972','Escondido','Gateway',1),
        ('18973','Escondido','Gateway',1),
        ('18974','Escondido','Gateway',1),
        ('18975','Escondido','Gateway',1),
        ('18976','Escondido','Gateway',1),
        ('18977','Escondido','Gateway',1),
        ('18978','Escondido','Gateway',1),
        ('18979','Escondido','Gateway',1),
        ('18980','Escondido','Gateway',1),
        ('18981','Escondido','Gateway',1),
        ('18982','Escondido','Gateway',1),
        ('18983','Escondido','Gateway',1),
        ('18984','Escondido','Gateway',1),
        ('18985','Escondido','Gateway',1),
        ('18986','Escondido','Gateway',1),
        ('18987','Escondido','Gateway',1),
        ('18988','Escondido','Gateway',1),
        ('18989','Escondido','Gateway',1),
        ('18990','Escondido','Gateway',1),
        ('18991','Escondido','Gateway',1),
        ('18992','Escondido','Gateway',1),
        ('18993','Escondido','Gateway',1),
        ('18994','Escondido','Gateway',1),
        ('18995','Escondido','Gateway',1),
        ('18996','Escondido','Gateway',1),
        ('18997','Escondido','Gateway',1),
        ('18998','Escondido','Gateway',1),
        ('18999','Escondido','Gateway',1),
        ('19000','Escondido','Gateway',1),
        ('19001','Escondido','Gateway',1),
        ('19002','Escondido','Gateway',1),
        ('19003','Escondido','Gateway',1),
        ('19004','Escondido','Gateway',1),
        ('19005','Escondido','Gateway',1),
        ('19006','Escondido','Gateway',1),
        ('19007','Escondido','Gateway',1),
        ('19008','Escondido','Gateway',1),
        ('19009','Escondido','Gateway',1),
        ('19010','Escondido','Gateway',1),
        ('19011','Escondido','Gateway',1),
        ('19012','Escondido','Gateway',1),
        ('19013','Escondido','Gateway',1),
        ('19014','Escondido','Gateway',1),
        ('19015','Escondido','Gateway',1),
        ('19016','Escondido','Gateway',1),
        ('19017','Escondido','Gateway',1),
        ('19018','Escondido','Gateway',1),
        ('19019','Escondido','Gateway',1),
        ('19020','Escondido','Gateway',1),
        ('19021','Escondido','Gateway',1),
        ('19022','Escondido','Gateway',1),
        ('19023','Escondido','Gateway',1),
        ('19024','Escondido','Gateway',1),
        ('19025','Escondido','Gateway',1),
        ('19026','Escondido','Gateway',1),
        ('19027','Escondido','Gateway',1),
        ('19028','Escondido','Gateway',1),
        ('19029','Escondido','Gateway',1),
        ('19030','Escondido','Gateway',1),
        ('19031','Escondido','Gateway',1),
        ('19032','Escondido','Gateway',1),
        ('19033','Escondido','Gateway',1),
        ('19034','Escondido','Gateway',1),
        ('19035','Escondido','Gateway',1),
        ('19036','Escondido','Gateway',1),
        ('19037','Escondido','Gateway',1),
        ('19038','Escondido','Gateway',1),
        ('19039','Escondido','Gateway',1),
        ('19040','Escondido','Gateway',1),
        ('19041','Escondido','Gateway',1),
        ('19042','Escondido','Gateway',1),
        ('19043','Escondido','Gateway',1),
        ('19044','Escondido','Gateway',1),
        ('19045','Escondido','Gateway',1),
        ('19046','Escondido','Gateway',1),
        ('19047','Escondido','Gateway',1),
        ('19048','Escondido','Gateway',1),
        ('19049','Escondido','Gateway',1),
        ('19050','Escondido','Gateway',1),
        ('19125','Escondido','Gateway',1),
        ('19130','Escondido','Gateway',1),
        ('19134','Escondido','Gateway',1),
        ('19136','Escondido','Gateway',1),
        ('19137','Escondido','Gateway',1),
        ('19138','Escondido','Gateway',1),
        ('19139','Escondido','Gateway',1),
        ('19141','Escondido','Gateway',1),
        ('19142','Escondido','Gateway',1),
        ('19143','Escondido','Gateway',1),
        ('19144','Escondido','Gateway',1),
        ('19145','Escondido','Gateway',1),
        ('19146','Escondido','Gateway',1),
        ('19147','Escondido','Gateway',1),
        ('19148','Escondido','Gateway',1),
        ('19149','Escondido','Gateway',1),
        ('19150','Escondido','Gateway',1),
        ('19151','Escondido','Gateway',1),
        ('19152','Escondido','Gateway',1),
        ('19153','Escondido','Gateway',1),
        ('19154','Escondido','Gateway',1),
        ('19155','Escondido','Gateway',1),
        ('19156','Escondido','Gateway',1),
        ('19157','Escondido','Gateway',1),
        ('19158','Escondido','Gateway',1),
        ('19159','Escondido','Gateway',1),
        ('19160','Escondido','Gateway',1),
        ('19161','Escondido','Gateway',1),
        ('19162','Escondido','Gateway',1),
        ('19163','Escondido','Gateway',1),
        ('19164','Escondido','Gateway',1),
        ('19165','Escondido','Gateway',1),
        ('19166','Escondido','Gateway',1),
        ('19167','Escondido','Gateway',1),
        ('19168','Escondido','Gateway',1),
        ('19169','Escondido','Gateway',1),
        ('19174','Escondido','Gateway',1),
        ('19175','Escondido','Gateway',1),
        ('19177','Escondido','Gateway',1),
        ('19178','Escondido','Gateway',1),
        ('19181','Escondido','Gateway',1),
        ('19182','Escondido','Gateway',1),
        ('19184','Escondido','Gateway',1),
        ('19188','San Marcos','Major Employment Center',1),
        ('19189','San Marcos','Major Employment Center',1),
        ('19190','San Marcos','Major Employment Center',1),
        ('19191','San Marcos','Major Employment Center',1),
        ('19192','San Marcos','Major Employment Center',1),
        ('19193','San Marcos','Major Employment Center',1),
        ('19194','San Marcos','Major Employment Center',1),
        ('19197','San Marcos','Major Employment Center',1),
        ('19198','Escondido','Gateway',1),
        ('19200','San Marcos','Major Employment Center',1),
        ('19205','San Marcos','Major Employment Center',1),
        ('19206','San Marcos','Major Employment Center',1),
        ('19209','San Marcos','Major Employment Center',1),
        ('19213','San Marcos','Major Employment Center',1),
        ('19214','San Marcos','Major Employment Center',1),
        ('19215','San Marcos','Major Employment Center',1),
        ('19241','San Marcos','Major Employment Center',1),
        ('19243','San Marcos','Major Employment Center',1),
        ('19244','San Marcos','Major Employment Center',1),
        ('19245','San Marcos','Major Employment Center',1),
        ('19246','San Marcos','Major Employment Center',1),
        ('19248','San Marcos','Major Employment Center',1),
        ('19250','San Marcos','Major Employment Center',1),
        ('19251','San Marcos','Major Employment Center',1),
        ('19252','Escondido','Gateway',1),
        ('19253','Escondido','Gateway',1),
        ('19254','Escondido','Gateway',1),
        ('19255','Escondido','Gateway',1),
        ('19256','Escondido','Gateway',1),
        ('19291','Escondido','Gateway',1),
        ('19292','Escondido','Gateway',1),
        ('19293','Escondido','Gateway',1),
        ('19294','Escondido','Gateway',1),
        ('19295','Escondido','Gateway',1),
        ('19296','Escondido','Gateway',1),
        ('19297','Escondido','Gateway',1),
        ('19298','Escondido','Gateway',1),
        ('19299','Escondido','Gateway',1),
        ('19300','Escondido','Gateway',1),
        ('19301','Escondido','Gateway',1),
        ('19302','Escondido','Gateway',1),
        ('19303','Escondido','Gateway',1),
        ('19304','Escondido','Gateway',1),
        ('19305','Escondido','Gateway',1),
        ('19306','Escondido','Gateway',1),
        ('19307','Escondido','Gateway',1),
        ('19308','Escondido','Gateway',1),
        ('19309','Escondido','Gateway',1),
        ('19310','Escondido','Gateway',1),
        ('19311','Escondido','Gateway',1),
        ('19312','Escondido','Gateway',1),
        ('19313','Escondido','Gateway',1),
        ('19314','Escondido','Gateway',1),
        ('19315','Escondido','Gateway',1),
        ('19316','Escondido','Gateway',1),
        ('19317','Escondido','Gateway',1),
        ('19318','Escondido','Gateway',1),
        ('19319','Escondido','Gateway',1),
        ('19320','Escondido','Gateway',1),
        ('19321','Escondido','Gateway',1),
        ('19322','Escondido','Gateway',1),
        ('19323','Escondido','Gateway',1),
        ('19324','Escondido','Gateway',1),
        ('19325','Escondido','Gateway',1),
        ('19326','Escondido','Gateway',1),
        ('19327','Escondido','Gateway',1),
        ('19328','Escondido','Gateway',1),
        ('19329','Escondido','Gateway',1),
        ('19330','Escondido','Gateway',1),
        ('19331','Escondido','Gateway',1),
        ('19332','Escondido','Gateway',1),
        ('19333','Escondido','Gateway',1),
        ('19334','Escondido','Gateway',1),
        ('19335','Escondido','Gateway',1),
        ('19336','Escondido','Gateway',1),
        ('19337','Escondido','Gateway',1),
        ('19338','Escondido','Gateway',1),
        ('19339','Escondido','Gateway',1),
        ('19340','Escondido','Gateway',1),
        ('19341','Escondido','Gateway',1),
        ('19342','Escondido','Gateway',1),
        ('19343','Escondido','Gateway',1),
        ('19344','Escondido','Gateway',1),
        ('19345','Escondido','Gateway',1),
        ('19346','Escondido','Gateway',1),
        ('19347','Escondido','Gateway',1),
        ('19348','Escondido','Gateway',1),
        ('19349','Escondido','Gateway',1),
        ('19350','Escondido','Gateway',1),
        ('19352','Escondido','Gateway',1),
        ('19353','Escondido','Gateway',1),
        ('19354','Escondido','Gateway',1),
        ('19355','Escondido','Gateway',1),
        ('19356','Escondido','Gateway',1),
        ('19358','Escondido','Gateway',1),
        ('19359','Escondido','Gateway',1),
        ('19361','Escondido','Gateway',1),
        ('19362','Escondido','Gateway',1),
        ('19370','Escondido','Gateway',1),
        ('19371','Escondido','Gateway',1),
        ('19372','Escondido','Gateway',1),
        ('19373','Escondido','Gateway',1),
        ('19374','Escondido','Gateway',1),
        ('19375','Escondido','Gateway',1),
        ('19376','Escondido','Gateway',1),
        ('19377','Escondido','Gateway',1),
        ('19378','Escondido','Gateway',1),
        ('19379','Escondido','Gateway',1),
        ('19380','Escondido','Gateway',1),
        ('19381','Escondido','Gateway',1),
        ('19382','Escondido','Gateway',1),
        ('19383','Escondido','Gateway',1),
        ('19384','Escondido','Gateway',1),
        ('19385','Escondido','Gateway',1),
        ('19386','Escondido','Gateway',1),
        ('19387','Escondido','Gateway',1),
        ('19388','Escondido','Gateway',1),
        ('19389','Escondido','Gateway',1),
        ('19392','Escondido','Gateway',1),
        ('19393','Escondido','Gateway',1),
        ('19394','Escondido','Gateway',1),
        ('19395','Escondido','Gateway',1),
        ('19396','Escondido','Gateway',1),
        ('19397','Escondido','Gateway',1),
        ('19398','Escondido','Gateway',1),
        ('19399','Escondido','Gateway',1),
        ('19400','Escondido','Gateway',1),
        ('19401','Escondido','Gateway',1),
        ('19402','Escondido','Gateway',1),
        ('19403','Escondido','Gateway',1),
        ('19404','Escondido','Gateway',1),
        ('19405','Escondido','Gateway',1),
        ('19406','Escondido','Gateway',1),
        ('19407','Escondido','Gateway',1),
        ('19408','Escondido','Gateway',1),
        ('19409','Escondido','Gateway',1),
        ('19410','Escondido','Gateway',1),
        ('19411','Escondido','Gateway',1),
        ('19412','Escondido','Gateway',1),
        ('19413','Escondido','Gateway',1),
        ('19414','Escondido','Gateway',1),
        ('19415','Escondido','Gateway',1),
        ('19416','Escondido','Gateway',1),
        ('19417','Escondido','Gateway',1),
        ('19418','Escondido','Gateway',1),
        ('19419','Escondido','Gateway',1),
        ('19420','Escondido','Gateway',1),
        ('19421','Escondido','Gateway',1),
        ('19422','Escondido','Gateway',1),
        ('19423','Escondido','Gateway',1),
        ('19424','Escondido','Gateway',1),
        ('19425','Escondido','Gateway',1),
        ('19426','Escondido','Gateway',1),
        ('19427','Escondido','Gateway',1),
        ('19428','Escondido','Gateway',1),
        ('19429','Escondido','Gateway',1),
        ('19430','Escondido','Gateway',1),
        ('19431','Escondido','Gateway',1),
        ('19432','Escondido','Gateway',1),
        ('19433','Escondido','Gateway',1),
        ('19434','Escondido','Gateway',1),
        ('19435','Escondido','Gateway',1),
        ('19436','Escondido','Gateway',1),
        ('19437','Escondido','Gateway',1),
        ('19438','Escondido','Gateway',1),
        ('19439','Escondido','Gateway',1),
        ('19482','Escondido','Gateway',1),
        ('19483','Escondido','Gateway',1),
        ('19484','Escondido','Gateway',1),
        ('19485','Escondido','Gateway',1),
        ('19486','Escondido','Gateway',1),
        ('19487','Escondido','Gateway',1),
        ('19488','Escondido','Gateway',1),
        ('19489','Escondido','Gateway',1),
        ('19490','Escondido','Gateway',1),
        ('19491','Escondido','Gateway',1),
        ('19492','Escondido','Gateway',1),
        ('19493','Escondido','Gateway',1),
        ('19494','Escondido','Gateway',1),
        ('19495','Escondido','Gateway',1),
        ('19496','Escondido','Gateway',1),
        ('19497','Escondido','Gateway',1),
        ('19498','Escondido','Gateway',1),
        ('19499','Escondido','Gateway',1),
        ('19500','Escondido','Gateway',1),
        ('19501','Escondido','Gateway',1),
        ('19502','Escondido','Gateway',1),
        ('19503','Escondido','Gateway',1),
        ('19504','Escondido','Gateway',1),
        ('19505','Escondido','Gateway',1),
        ('19506','Escondido','Gateway',1),
        ('19507','Escondido','Gateway',1),
        ('19508','Escondido','Gateway',1),
        ('19509','Escondido','Gateway',1),
        ('19520','Escondido','Gateway',1),
        ('19521','Escondido','Gateway',1),
        ('19522','Escondido','Gateway',1),
        ('19523','Escondido','Gateway',1),
        ('19524','Escondido','Gateway',1),
        ('19525','Escondido','Gateway',1),
        ('19526','Escondido','Gateway',1),
        ('19527','Escondido','Gateway',1),
        ('19528','Escondido','Gateway',1),
        ('19529','Escondido','Gateway',1),
        ('19530','Escondido','Gateway',1),
        ('19531','Escondido','Gateway',1),
        ('19532','Escondido','Gateway',1),
        ('19537','Escondido','Gateway',1),
        ('19538','Escondido','Gateway',1),
        ('19539','Escondido','Gateway',1),
        ('19540','Escondido','Gateway',1),
        ('19541','Escondido','Gateway',1),
        ('19542','Escondido','Gateway',1),
        ('19543','Escondido','Gateway',1),
        ('19546','Escondido','Gateway',1),
        ('19547','Escondido','Gateway',1),
        ('19555','Escondido','Gateway',1),
        ('19556','Escondido','Gateway',1),
        ('19615','Escondido','Gateway',1),
        ('19616','Escondido','Gateway',1),
        ('19617','Escondido','Gateway',1),
        ('19618','Escondido','Gateway',1),
        ('19619','Escondido','Gateway',1),
        ('19620','Escondido','Gateway',1),
        ('19621','Escondido','Gateway',1),
        ('19622','Escondido','Gateway',1),
        ('19623','Escondido','Gateway',1),
        ('19624','Escondido','Gateway',1),
        ('19625','Escondido','Gateway',1),
        ('19626','Escondido','Gateway',1),
        ('19627','Escondido','Gateway',1),
        ('19628','Escondido','Gateway',1),
        ('19629','Escondido','Gateway',1),
        ('19630','Escondido','Gateway',1),
        ('19631','Escondido','Gateway',1),
        ('19632','Escondido','Gateway',1),
        ('19633','Escondido','Gateway',1),
        ('19634','Escondido','Gateway',1),
        ('19635','Escondido','Gateway',1),
        ('19636','Escondido','Gateway',1),
        ('19637','Escondido','Gateway',1),
        ('19638','Escondido','Gateway',1),
        ('19639','Escondido','Gateway',1),
        ('19640','Escondido','Gateway',1),
        ('19641','Escondido','Gateway',1),
        ('19642','Escondido','Gateway',1),
        ('19643','Escondido','Gateway',1),
        ('19644','Escondido','Gateway',1),
        ('19645','Escondido','Gateway',1),
        ('19646','Escondido','Gateway',1),
        ('19647','Escondido','Gateway',1),
        ('19648','Escondido','Gateway',1),
        ('19649','Escondido','Gateway',1),
        ('19650','Escondido','Gateway',1),
        ('19651','Escondido','Gateway',1),
        ('19652','Escondido','Gateway',1),
        ('19653','Escondido','Gateway',1),
        ('19654','Escondido','Gateway',1),
        ('19655','Escondido','Gateway',1),
        ('19656','Escondido','Gateway',1),
        ('19657','Escondido','Gateway',1),
        ('19658','Escondido','Gateway',1),
        ('19659','Escondido','Gateway',1),
        ('19660','Escondido','Gateway',1),
        ('19661','Escondido','Gateway',1),
        ('19662','Escondido','Gateway',1),
        ('19663','Escondido','Gateway',1),
        ('19664','Escondido','Gateway',1),
        ('19665','Escondido','Gateway',1),
        ('19666','Escondido','Gateway',1),
        ('19667','Escondido','Gateway',1),
        ('19668','Escondido','Gateway',1),
        ('19669','Escondido','Gateway',1),
        ('19670','Escondido','Gateway',1),
        ('19671','Escondido','Gateway',1),
        ('19672','Escondido','Gateway',1),
        ('19673','Escondido','Gateway',1),
        ('19674','Escondido','Gateway',1),
        ('19675','Escondido','Gateway',1),
        ('19676','Escondido','Gateway',1),
        ('19677','Escondido','Gateway',1),
        ('19678','Escondido','Gateway',1),
        ('19679','Escondido','Gateway',1),
        ('19680','Escondido','Gateway',1),
        ('19681','Escondido','Gateway',1),
        ('19682','Escondido','Gateway',1),
        ('19683','Escondido','Gateway',1),
        ('19684','Escondido','Gateway',1),
        ('19685','Escondido','Gateway',1),
        ('19686','Escondido','Gateway',1),
        ('19687','Escondido','Gateway',1),
        ('19688','Escondido','Gateway',1),
        ('19689','Escondido','Gateway',1),
        ('19690','Escondido','Gateway',1),
        ('19691','Escondido','Gateway',1),
        ('19692','Escondido','Gateway',1),
        ('19693','Escondido','Gateway',1),
        ('19694','Escondido','Gateway',1),
        ('19695','Escondido','Gateway',1),
        ('19696','Escondido','Gateway',1),
        ('19697','Escondido','Gateway',1),
        ('19698','Escondido','Gateway',1),
        ('19699','Escondido','Gateway',1),
        ('19700','Escondido','Gateway',1),
        ('19701','Escondido','Gateway',1),
        ('19702','Escondido','Gateway',1),
        ('19703','Escondido','Gateway',1),
        ('19704','Escondido','Gateway',1),
        ('19705','Escondido','Gateway',1),
        ('19706','Escondido','Gateway',1),
        ('19707','Escondido','Gateway',1),
        ('19708','Escondido','Gateway',1),
        ('19709','Escondido','Gateway',1),
        ('19710','Escondido','Gateway',1),
        ('19711','Escondido','Gateway',1),
        ('19712','Escondido','Gateway',1),
        ('19713','Escondido','Gateway',1),
        ('19714','Escondido','Gateway',1),
        ('19715','Escondido','Gateway',1),
        ('19716','Escondido','Gateway',1),
        ('19717','Escondido','Gateway',1),
        ('19718','Escondido','Gateway',1),
        ('19719','Escondido','Gateway',1),
        ('19720','Escondido','Gateway',1),
        ('19721','Escondido','Gateway',1),
        ('19722','Escondido','Gateway',1),
        ('19723','Escondido','Gateway',1),
        ('19724','Escondido','Gateway',1),
        ('19725','Escondido','Gateway',1),
        ('19726','Escondido','Gateway',1),
        ('19727','Escondido','Gateway',1),
        ('19728','Escondido','Gateway',1),
        ('19729','Escondido','Gateway',1),
        ('19730','Escondido','Gateway',1),
        ('19731','Escondido','Gateway',1),
        ('19732','Escondido','Gateway',1),
        ('19733','Escondido','Gateway',1),
        ('19734','Escondido','Gateway',1),
        ('19735','Escondido','Gateway',1),
        ('19736','Escondido','Gateway',1),
        ('19737','Escondido','Gateway',1),
        ('19738','Escondido','Gateway',1),
        ('19739','Escondido','Gateway',1),
        ('19740','Escondido','Gateway',1),
        ('19741','Escondido','Gateway',1),
        ('19742','Escondido','Gateway',1),
        ('19743','Escondido','Gateway',1),
        ('19744','Escondido','Gateway',1),
        ('19745','Escondido','Gateway',1),
        ('19746','Escondido','Gateway',1),
        ('19747','Escondido','Gateway',1),
        ('19748','Escondido','Gateway',1),
        ('19749','Escondido','Gateway',1),
        ('19750','Escondido','Gateway',1),
        ('19751','Escondido','Gateway',1),
        ('19752','Escondido','Gateway',1),
        ('19753','Escondido','Gateway',1),
        ('19754','Escondido','Gateway',1),
        ('19755','Escondido','Gateway',1),
        ('19756','Escondido','Gateway',1),
        ('19757','Escondido','Gateway',1),
        ('19758','Escondido','Gateway',1),
        ('19759','Escondido','Gateway',1),
        ('19760','Escondido','Gateway',1),
        ('19761','Escondido','Gateway',1),
        ('19762','Escondido','Gateway',1),
        ('19763','Escondido','Gateway',1),
        ('19764','Escondido','Gateway',1),
        ('19765','Escondido','Gateway',1),
        ('19766','Escondido','Gateway',1),
        ('19767','Escondido','Gateway',1),
        ('19768','Escondido','Gateway',1),
        ('19769','Escondido','Gateway',1),
        ('19770','Escondido','Gateway',1),
        ('19773','Escondido','Gateway',1),
        ('19774','Escondido','Gateway',1),
        ('19775','Escondido','Gateway',1),
        ('19776','Escondido','Gateway',1),
        ('19777','Escondido','Gateway',1),
        ('19778','Escondido','Gateway',1),
        ('19779','Escondido','Gateway',1),
        ('19780','Escondido','Gateway',1),
        ('19781','Escondido','Gateway',1),
        ('19782','Escondido','Gateway',1),
        ('19790','Escondido','Gateway',1),
        ('19791','Escondido','Gateway',1),
        ('19792','Escondido','Gateway',1),
        ('19793','Escondido','Gateway',1),
        ('19794','Escondido','Gateway',1),
        ('19795','Escondido','Gateway',1),
        ('19796','Escondido','Gateway',1),
        ('19797','Escondido','Gateway',1),
        ('19818','Escondido','Gateway',1),
        ('19819','Escondido','Gateway',1),
        ('19820','Escondido','Gateway',1),
        ('19821','Escondido','Gateway',1),
        ('19822','Escondido','Gateway',1),
        ('19823','Escondido','Gateway',1),
        ('19841','Escondido','Gateway',1),
        ('19845','Escondido','Gateway',1),
        ('19904','Escondido','Gateway',1),
        ('19905','Escondido','Gateway',1),
        ('19906','Escondido','Gateway',1),
        ('19907','Escondido','Gateway',1),
        ('19908','Escondido','Gateway',1),
        ('19909','Escondido','Gateway',1),
        ('19910','Escondido','Gateway',1),
        ('19911','Escondido','Gateway',1),
        ('19912','Escondido','Gateway',1),
        ('19913','Escondido','Gateway',1),
        ('19914','Escondido','Gateway',1),
        ('19915','Escondido','Gateway',1),
        ('19916','Escondido','Gateway',1),
        ('19917','Escondido','Gateway',1),
        ('19918','Escondido','Gateway',1),
        ('19919','Escondido','Gateway',1),
        ('19921','Escondido','Gateway',1),
        ('19922','Escondido','Gateway',1),
        ('19923','Escondido','Gateway',1),
        ('19924','Escondido','Gateway',1),
        ('19925','Escondido','Gateway',1),
        ('19926','Escondido','Gateway',1),
        ('19927','Escondido','Gateway',1),
        ('19929','Escondido','Gateway',1),
        ('19930','Escondido','Gateway',1),
        ('19954','Escondido','Gateway',1),
        ('19955','Escondido','Gateway',1),
        ('19956','Escondido','Gateway',1),
        ('20027','Escondido','Gateway',1),
        ('20028','Escondido','Gateway',1),
        ('20029','Escondido','Gateway',1),
        ('20030','Escondido','Gateway',1),
        ('20031','Escondido','Gateway',1),
        ('20032','Escondido','Gateway',1),
        ('20033','Escondido','Gateway',1),
        ('20034','Escondido','Gateway',1),
        ('20035','Escondido','Gateway',1),
        ('20036','Escondido','Gateway',1),
        ('20037','Escondido','Gateway',1),
        ('20038','Escondido','Gateway',1),
        ('20039','Escondido','Gateway',1),
        ('20040','Escondido','Gateway',1),
        ('20045','Escondido','Gateway',1),
        ('20048','Escondido','Gateway',1),
        ('20050','Escondido','Gateway',1),
        ('20058','Escondido','Gateway',1),
        ('20059','Escondido','Gateway',1),
        ('20061','Escondido','Gateway',1),
        ('20062','Escondido','Gateway',1),
        ('20063','Escondido','Gateway',1),
        ('22707','Coronado','Coastal',0),
        ('22708','Coronado','Coastal',0),
        ('22709','Coronado','Coastal',0),
        ('22710','Coronado','Coastal',0),
        ('22711','Coronado','Coastal',0),
        ('22712','Coronado','Coastal',0),
        ('22713','Coronado','Coastal',0),
        ('22714','Coronado','Coastal',0),
        ('22715','Coronado','Coastal',0),
        ('22716','Coronado','Coastal',0),
        ('22717','Coronado','Coastal',0),
        ('22718','Coronado','Coastal',0),
        ('22719','Coronado','Coastal',0),
        ('22720','Coronado','Coastal',0),
        ('22721','Coronado','Coastal',0),
        ('22722','Coronado','Coastal',0),
        ('22723','Coronado','Coastal',0),
        ('22724','Coronado','Coastal',0),
        ('22725','Coronado','Coastal',0),
        ('22726','Coronado','Coastal',0),
        ('22727','Coronado','Coastal',0),
        ('22728','Coronado','Coastal',0),
        ('22729','Coronado','Coastal',0),
        ('22730','Coronado','Coastal',0),
        ('22731','Coronado','Coastal',0),
        ('22732','Coronado','Coastal',0),
        ('22733','Coronado','Coastal',0),
        ('22734','Coronado','Coastal',0),
        ('22735','Coronado','Coastal',0),
        ('22736','Coronado','Coastal',0),
        ('22737','Coronado','Coastal',0),
        ('22738','Coronado','Coastal',0),
        ('22739','Coronado','Coastal',0),
        ('22740','Coronado','Coastal',0),
        ('22741','Coronado','Coastal',0),
        ('22742','Coronado','Coastal',0),
        ('22743','Coronado','Coastal',0),
        ('22744','Coronado','Coastal',0),
        ('22745','Coronado','Coastal',0),
        ('22746','Coronado','Coastal',0),
        ('22747','Coronado','Coastal',0),
        ('22748','Coronado','Coastal',0),
        ('22749','National City','Major Employment Center',1),
        ('22750','National City','Major Employment Center',1),
        ('22751','National City','Major Employment Center',1),
        ('22752','National City','Major Employment Center',1),
        ('22753','National City','Major Employment Center',1),
        ('22754','National City','Major Employment Center',1),
        ('22755','National City','Major Employment Center',1),
        ('22756','National City','Major Employment Center',1),
        ('22757','National City','Major Employment Center',1),
        ('22759','National City','Major Employment Center',1),
        ('22761','National City','Major Employment Center',1),
        ('22762','National City','Major Employment Center',1),
        ('22763','National City','Major Employment Center',1),
        ('22764','National City','Major Employment Center',1),
        ('22766','National City','Major Employment Center',1),
        ('22767','National City','Major Employment Center',1),
        ('22768','National City','Major Employment Center',1),
        ('22769','National City','Major Employment Center',1),
        ('22770','National City','Major Employment Center',1),
        ('22771','National City','Major Employment Center',1),
        ('22772','National City','Major Employment Center',1),
        ('22773','National City','Major Employment Center',1),
        ('22774','National City','Major Employment Center',1),
        ('22775','National City','Major Employment Center',1),
        ('22776','National City','Major Employment Center',1),
        ('22777','National City','Major Employment Center',1),
        ('22778','National City','Major Employment Center',1),
        ('22779','National City','Major Employment Center',1),
        ('22780','National City','Major Employment Center',1),
        ('22781','National City','Major Employment Center',1),
        ('22782','National City','Major Employment Center',1),
        ('22783','National City','Major Employment Center',1),
        ('22784','National City','Major Employment Center',1),
        ('22785','National City','Major Employment Center',1),
        ('22786','National City','Major Employment Center',1),
        ('22787','National City','Major Employment Center',1),
        ('22788','National City','Major Employment Center',1),
        ('22789','National City','Major Employment Center',1),
        ('22790','National City','Major Employment Center',1),
        ('22791','National City','Major Employment Center',1),
        ('22792','National City','Major Employment Center',1),
        ('22793','National City','Major Employment Center',1),
        ('22794','National City','Major Employment Center',1),
        ('22795','National City','Major Employment Center',1),
        ('22796','National City','Major Employment Center',1),
        ('22797','National City','Major Employment Center',1),
        ('22798','National City','Major Employment Center',1),
        ('22799','National City','Major Employment Center',1),
        ('22800','National City','Major Employment Center',1),
        ('22801','National City','Major Employment Center',1),
        ('22802','National City','Major Employment Center',1),
        ('22803','National City','Major Employment Center',1),
        ('22805','National City','Major Employment Center',1),
        ('22807','National City','Major Employment Center',1),
        ('22808','National City','Major Employment Center',1),
        ('22809','National City','Major Employment Center',1),
        ('22810','National City','Major Employment Center',1),
        ('22811','National City','Major Employment Center',1),
        ('22812','National City','Major Employment Center',1),
        ('22813','National City','Major Employment Center',1),
        ('22814','National City','Major Employment Center',1),
        ('22815','National City','Major Employment Center',1),
        ('22816','National City','Major Employment Center',1),
        ('22817','National City','Major Employment Center',1),
        ('22818','National City','Major Employment Center',1),
        ('22819','National City','Major Employment Center',1),
        ('22820','National City','Major Employment Center',1),
        ('22821','National City','Major Employment Center',1),
        ('22822','National City','Major Employment Center',1),
        ('22825','National City','Major Employment Center',1),
        ('22826','National City','Major Employment Center',1),
        ('22827','National City','Major Employment Center',1),
        ('22828','National City','Major Employment Center',1),
        ('22829','National City','Major Employment Center',1),
        ('22831','National City','Major Employment Center',1),
        ('22832','National City','Major Employment Center',1),
        ('22838','Downtown Chula Vista','Suburban',0),
        ('22839','National City','Major Employment Center',1),
        ('22844','National City','Major Employment Center',1),
        ('22845','National City','Major Employment Center',1),
        ('22846','National City','Major Employment Center',1),
        ('22847','National City','Major Employment Center',1),
        ('22848','National City','Major Employment Center',1),
        ('22849','National City','Major Employment Center',1),
        ('22850','National City','Major Employment Center',1),
        ('22851','National City','Major Employment Center',1),
        ('22852','National City','Major Employment Center',1),
        ('22853','National City','Major Employment Center',1),
        ('22854','National City','Major Employment Center',1),
        ('22855','National City','Major Employment Center',1),
        ('22856','National City','Major Employment Center',1),
        ('22857','National City','Major Employment Center',1),
        ('22858','National City','Major Employment Center',1),
        ('22859','National City','Major Employment Center',1),
        ('22860','National City','Major Employment Center',1),
        ('22861','National City','Major Employment Center',1),
        ('22862','National City','Major Employment Center',1),
        ('22863','National City','Major Employment Center',1),
        ('22864','National City','Major Employment Center',1),
        ('22865','National City','Major Employment Center',1),
        ('22866','National City','Major Employment Center',1),
        ('22867','National City','Major Employment Center',1),
        ('22868','National City','Major Employment Center',1),
        ('22869','National City','Major Employment Center',1),
        ('22870','National City','Major Employment Center',1),
        ('22871','National City','Major Employment Center',1),
        ('22872','National City','Major Employment Center',1),
        ('22873','National City','Major Employment Center',1),
        ('22874','National City','Major Employment Center',1),
        ('22875','National City','Major Employment Center',1),
        ('22876','National City','Major Employment Center',1),
        ('22877','National City','Major Employment Center',1),
        ('22878','National City','Major Employment Center',1),
        ('22879','National City','Major Employment Center',1),
        ('22880','National City','Major Employment Center',1),
        ('22881','National City','Major Employment Center',1),
        ('22882','National City','Major Employment Center',1),
        ('22883','National City','Major Employment Center',1),
        ('22884','National City','Major Employment Center',1),
        ('22885','National City','Major Employment Center',1),
        ('22886','National City','Major Employment Center',1),
        ('22887','National City','Major Employment Center',1),
        ('22888','National City','Major Employment Center',1),
        ('22889','National City','Major Employment Center',1),
        ('22890','National City','Major Employment Center',1),
        ('22891','National City','Major Employment Center',1),
        ('22892','National City','Major Employment Center',1),
        ('22893','National City','Major Employment Center',1),
        ('22894','National City','Major Employment Center',1),
        ('22895','National City','Major Employment Center',1),
        ('22896','National City','Major Employment Center',1),
        ('22897','National City','Major Employment Center',1),
        ('22898','National City','Major Employment Center',1),
        ('22899','National City','Major Employment Center',1),
        ('22902','Carlsbad Palomar','Major Employment Center',1),
        ('22903','Carlsbad Palomar','Major Employment Center',1),
        ('22904','Carlsbad Palomar','Major Employment Center',1),
        ('22905','Carlsbad Palomar','Major Employment Center',1),
        ('22906','Carlsbad Palomar','Major Employment Center',1),
        ('22907','Carlsbad Palomar','Major Employment Center',1),
        ('22908','Carlsbad Palomar','Major Employment Center',1),
        ('22909','Carlsbad Palomar','Major Employment Center',1),
        ('22910','Carlsbad Palomar','Major Employment Center',1),
        ('22911','Carlsbad Palomar','Major Employment Center',1),
        ('22912','Carlsbad Palomar','Major Employment Center',1),
        ('22913','Carlsbad Palomar','Major Employment Center',1),
        ('22914','Carlsbad Palomar','Major Employment Center',1),
        ('22915','Carlsbad Palomar','Major Employment Center',1),
        ('22916','Carlsbad Palomar','Major Employment Center',1),
        ('22917','Carlsbad Palomar','Major Employment Center',1),
        ('22918','Carlsbad Palomar','Major Employment Center',1),
        ('22919','Carlsbad Palomar','Major Employment Center',1),
        ('22920','Carlsbad Palomar','Major Employment Center',1),
        ('22921','Carlsbad Palomar','Major Employment Center',1),
        ('22922','Carlsbad Palomar','Major Employment Center',1),
        ('22923','Carlsbad Palomar','Major Employment Center',1),
        ('22924','Carlsbad Palomar','Major Employment Center',1),
        ('22925','Carlsbad Palomar','Major Employment Center',1),
        ('22926','Carlsbad Palomar','Major Employment Center',1),
        ('22927','Carlsbad Palomar','Major Employment Center',1),
        ('22928','Carlsbad Palomar','Major Employment Center',1),
        ('22929','Carlsbad Palomar','Major Employment Center',1),
        ('22930','Carlsbad Palomar','Major Employment Center',1),
        ('22931','Carlsbad Palomar','Major Employment Center',1),
        ('22932','Carlsbad Palomar','Major Employment Center',1),
        ('22933','Carlsbad Palomar','Major Employment Center',1),
        ('22934','Carlsbad Palomar','Major Employment Center',1),
        ('22935','Carlsbad Palomar','Major Employment Center',1),
        ('22936','Carlsbad Palomar','Major Employment Center',1),
        ('22937','Carlsbad Palomar','Major Employment Center',1),
        ('22938','Carlsbad Palomar','Major Employment Center',1),
        ('22939','Carlsbad Palomar','Major Employment Center',1),
        ('22940','Carlsbad Palomar','Major Employment Center',1),
        ('22941','Carlsbad Palomar','Major Employment Center',1),
        ('22942','Carlsbad Palomar','Major Employment Center',1),
        ('22943','Carlsbad Palomar','Major Employment Center',1),
        ('22944','Carlsbad Palomar','Major Employment Center',1),
        ('22945','Carlsbad Palomar','Major Employment Center',1),
        ('22946','Carlsbad Palomar','Major Employment Center',1),
        ('22947','Carlsbad Palomar','Major Employment Center',1),
        ('22948','Carlsbad Palomar','Major Employment Center',1),
        ('22949','Carlsbad Palomar','Major Employment Center',1),
        ('22950','Carlsbad Palomar','Major Employment Center',1),
        ('22951','Carlsbad Palomar','Major Employment Center',1),
        ('22952','Carlsbad Palomar','Major Employment Center',1),
        ('22953','Carlsbad Palomar','Major Employment Center',1),
        ('22954','Carlsbad Palomar','Major Employment Center',1),
        ('22955','Carlsbad Palomar','Major Employment Center',1),
        ('22956','Carlsbad Palomar','Major Employment Center',1),
        ('22957','Carlsbad Palomar','Major Employment Center',1),
        ('22958','Carlsbad Palomar','Major Employment Center',1),
        ('22959','Carlsbad Palomar','Major Employment Center',1),
        ('22960','Carlsbad Palomar','Major Employment Center',1),
        ('22964','Carlsbad Palomar','Major Employment Center',1),
        ('22965','Carlsbad Palomar','Major Employment Center',1),
        ('22966','Carlsbad Palomar','Major Employment Center',1),
        ('22967','Carlsbad Palomar','Major Employment Center',1),
        ('22968','Carlsbad Palomar','Major Employment Center',1),
        ('22972','Carlsbad Palomar','Major Employment Center',1)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'rp_2021.mobility_hubs', 'MS_Description', 'table to hold series 13 MGRAs identified as mobility hubs'
    EXECUTE [db_meta].[add_xp] 'rp_2021.mobility_hubs.mgra_13', 'MS_Description', 'series 13 MGRA geography zones'
    EXECUTE [db_meta].[add_xp] 'rp_2021.mobility_hubs.has_carshare2035', 'MS_Description', 'indicator if zone has car share in 2035'
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
			[mgra_13] != 'Not Applicable' AND geography_set_id = 1) AS [mgras]
	ON
		[particulate_matter_grid].[centroid].STWithin([mgra_13_shape]) = 1

	-- remove grid cells that do not match to a mgra_13
	DELETE FROM [rp_2021].[particulate_matter_grid] WHERE [mgra_13] = 'Not Applicable'
END
GO




-- create function to use as query layer for RP 2021 EIR ---------------------
DROP FUNCTION IF EXISTS [rp_2021].[fn_eir_shp_qry_layer]
GO

CREATE FUNCTION [rp_2021].[fn_eir_shp_qry_layer]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Shape file query layer for RP 2021 EIR.
**/
    SELECT
        @scenario_id AS [scenario_id]
        ,[hwy_link].[hwycov_id]
        ,[hwy_link].[nm]
        ,[hwy_link].[length_mile]
        ,[hwy_link].[ifc]
        ,CASE WHEN [ifc] = 1 THEN 'Freeway'
              WHEN [ifc] = 2 THEN 'Prime Arterial'
              WHEN [ifc] = 3 THEN 'Major Arterial'
              WHEN [ifc] = 4 THEN 'Collector'
              WHEN [ifc] = 5 THEN 'Local Collector'
              WHEN [ifc] = 6 THEN 'Rural Collector'
              WHEN [ifc] = 7 THEN 'Local (non-circulation element) Road'
              WHEN [ifc] = 8 THEN 'Freeway Connector Ramp'
              WHEN [ifc] = 9 THEN 'Local Ramp'
              WHEN [ifc] = 10 THEN 'Zone Connector'
              ELSE NULL END AS [ifc_desc]
        ,[hwy_link].[ihov]
        ,[hwy_link].[itruck]
        ,[hwy_link].[iway]
        ,(ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
          ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
          ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
          ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		  ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		  ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
          ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0) +
          ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
          ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
          ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) +
		  ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		  ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		  ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) +
          ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0)) * [length_mile] AS [vmt]
        ,(ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
          ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
          ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
          ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		  ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		  ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
          ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0)) * [length_mile] AS [ab_vmt]
        ,(ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
          ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
          ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) +
          ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		  ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		  ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) +
          ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0)) * [length_mile] AS [ba_vmt]
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
         ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
         ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
         ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		 ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		 ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
         ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0) +
         ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
         ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
         ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) +
         ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		 ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		 ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) +
         ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0) AS [flow]
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
         ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
         ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
         ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		 ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		 ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
         ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0) AS [ab_flow]
        ,ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
         ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
         ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) +
         ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		 ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		 ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) +
         ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0) AS [ba_flow]    
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_ea_preload_flow], 0) AS [ab_ea_flow]
        ,ISNULL([ab_am_da_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_am_preload_flow], 0) AS [ab_am_flow]
        ,ISNULL([ab_md_da_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_md_preload_flow], 0) AS [ab_md_flow]
        ,ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_pm_preload_flow], 0) AS [ab_pm_flow]
        ,ISNULL([ab_ev_da_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +  ISNULL([ab_ev_preload_flow], 0) AS [ab_ev_flow]
        ,ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_ea_preload_flow], 0) AS [ba_ea_flow]
        ,ISNULL([ba_am_da_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_am_preload_flow], 0) AS [ba_am_flow]
        ,ISNULL([ba_md_da_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_md_preload_flow], 0) AS [ba_md_flow]
        ,ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_pm_preload_flow], 0) AS [ba_pm_flow]
        ,ISNULL([ba_ev_da_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) + ISNULL([ba_ev_preload_flow], 0) AS [ba_ev_flow]
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
         ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
         ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
         ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
         ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
         ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) AS [auto_flow]  
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
         ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
         ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) AS [ab_auto_flow]
        ,ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) +
         ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) +
         ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) AS [ba_auto_flow]
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_ea_sr3_flow], 0) AS [ab_ea_auto_flow]
        ,ISNULL([ab_am_da_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_am_sr3_flow], 0) AS [ab_am_auto_flow]
        ,ISNULL([ab_md_da_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_md_sr3_flow], 0) AS [ab_md_auto_flow]
        ,ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) AS [ab_pm_auto_flow]
        ,ISNULL([ab_ev_da_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) AS [ab_ev_auto_flow]
        ,ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_ea_sr3_flow], 0) AS [ba_ea_auto_flow]
        ,ISNULL([ba_am_da_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_am_sr3_flow], 0) AS [ba_am_auto_flow]
        ,ISNULL([ba_md_da_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_md_sr3_flow], 0) AS [ba_md_auto_flow]
        ,ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) AS [ba_pm_auto_flow]
        ,ISNULL([ba_ev_da_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) AS [ba_ev_auto_flow]
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) +
         ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) AS [da_flow]  
        ,ISNULL([ab_ea_da_flow], 0) + ISNULL([ab_am_da_flow], 0) + ISNULL([ab_md_da_flow], 0) + ISNULL([ab_pm_da_flow], 0) + ISNULL([ab_ev_da_flow], 0) AS [ab_da_flow]
        ,ISNULL([ba_ea_da_flow], 0) + ISNULL([ba_am_da_flow], 0) + ISNULL([ba_md_da_flow], 0) + ISNULL([ba_pm_da_flow], 0) + ISNULL([ba_ev_da_flow], 0) AS [ba_da_flow]
        ,ISNULL([ab_ea_da_flow], 0) AS [ab_ea_da_flow]
        ,ISNULL([ab_am_da_flow], 0) AS [ab_am_da_flow]
        ,ISNULL([ab_md_da_flow], 0) AS [ab_md_da_flow]
        ,ISNULL([ab_pm_da_flow], 0) AS [ab_pm_da_flow]
        ,ISNULL([ab_ev_da_flow], 0) AS [ab_ev_da_flow]
        ,ISNULL([ba_ea_da_flow], 0) AS [ba_ea_da_flow]
        ,ISNULL([ba_am_da_flow], 0) AS [ba_am_da_flow]
        ,ISNULL([ba_md_da_flow], 0) AS [ba_md_da_flow]
        ,ISNULL([ba_pm_da_flow], 0) AS [ba_pm_da_flow]
        ,ISNULL([ba_ev_da_flow], 0) AS [ba_ev_da_flow]
        ,ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) +
         ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) AS [sr2_flow]  
        ,ISNULL([ab_ea_sr2_flow], 0) + ISNULL([ab_am_sr2_flow], 0) + ISNULL([ab_md_sr2_flow], 0) + ISNULL([ab_pm_sr2_flow], 0) + ISNULL([ab_ev_sr2_flow], 0) AS [ab_sr2_flow]
        ,ISNULL([ba_ea_sr2_flow], 0) + ISNULL([ba_am_sr2_flow], 0) + ISNULL([ba_md_sr2_flow], 0) + ISNULL([ba_pm_sr2_flow], 0) + ISNULL([ba_ev_sr2_flow], 0) AS [ba_sr2_flow]
        ,ISNULL([ab_ea_sr2_flow], 0) AS [ab_ea_sr2_flow]
        ,ISNULL([ab_am_sr2_flow], 0) AS [ab_am_sr2_flow]
        ,ISNULL([ab_md_sr2_flow], 0) AS [ab_md_sr2_flow]
        ,ISNULL([ab_pm_sr2_flow], 0) AS [ab_pm_sr2_flow]
        ,ISNULL([ab_ev_sr2_flow], 0) AS [ab_ev_sr2_flow]
        ,ISNULL([ba_ea_sr2_flow], 0) AS [ba_ea_sr2_flow]
        ,ISNULL([ba_am_sr2_flow], 0) AS [ba_am_sr2_flow]
        ,ISNULL([ba_md_sr2_flow], 0) AS [ba_md_sr2_flow]
        ,ISNULL([ba_pm_sr2_flow], 0) AS [ba_pm_sr2_flow]
        ,ISNULL([ba_ev_sr2_flow], 0) AS [ba_ev_sr2_flow]
        ,ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) +
         ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) AS [sr3_flow]  
        ,ISNULL([ab_ea_sr3_flow], 0) + ISNULL([ab_am_sr3_flow], 0) + ISNULL([ab_md_sr3_flow], 0) + ISNULL([ab_pm_sr3_flow], 0) + ISNULL([ab_ev_sr3_flow], 0) AS [ab_sr3_flow]
        ,ISNULL([ba_ea_sr3_flow], 0) + ISNULL([ba_am_sr3_flow], 0) + ISNULL([ba_md_sr3_flow], 0) + ISNULL([ba_pm_sr3_flow], 0) + ISNULL([ba_ev_sr3_flow], 0) AS [ba_sr3_flow]
        ,ISNULL([ab_ea_sr3_flow], 0) AS [ab_ea_sr3_flow]
        ,ISNULL([ab_am_sr3_flow], 0) AS [ab_am_sr3_flow]
        ,ISNULL([ab_md_sr3_flow], 0) AS [ab_md_sr3_flow]
        ,ISNULL([ab_pm_sr3_flow], 0) AS [ab_pm_sr3_flow]
        ,ISNULL([ab_ev_sr3_flow], 0) AS [ab_ev_sr3_flow]
        ,ISNULL([ba_ea_sr3_flow], 0) AS [ba_ea_sr3_flow]
        ,ISNULL([ba_am_sr3_flow], 0) AS [ba_am_sr3_flow]
        ,ISNULL([ba_md_sr3_flow], 0) AS [ba_md_sr3_flow]
        ,ISNULL([ba_pm_sr3_flow], 0) AS [ba_pm_sr3_flow]
        ,ISNULL([ba_ev_sr3_flow], 0) AS [ba_ev_sr3_flow]
		,ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		 ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		 ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
		 ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		 ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		 ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) AS [truck_flow]
		,ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
		 ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
		 ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) AS [ab_truck_flow]
		,ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) +
		 ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) +
		 ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) AS [ba_truck_flow]
        ,ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_ea_hhdt_flow], 0) AS [ab_ea_truck_flow]
        ,ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) AS [ab_am_truck_flow]
		,ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) AS [ab_md_truck_flow]
		,ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) AS [ab_pm_truck_flow]
		,ISNULL([ab_ev_lhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) AS [ab_ev_truck_flow]
		,ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_ea_hhdt_flow], 0) AS [ba_ea_truck_flow]
        ,ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) AS [ba_am_truck_flow]
		,ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) AS [ba_md_truck_flow]
		,ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) AS [ba_pm_truck_flow]
		,ISNULL([ba_ev_lhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) AS [ba_ev_truck_flow]
		,ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) +
        ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) AS [lhdt_flow]
		,ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) +
        ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) AS [mhdt_flow]
		,ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) +
        ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) AS [hhdt_flow]
		,ISNULL([ab_ea_lhdt_flow], 0) + ISNULL([ab_am_lhdt_flow], 0) + ISNULL([ab_md_lhdt_flow], 0) + ISNULL([ab_pm_lhdt_flow], 0) + ISNULL([ab_ev_lhdt_flow], 0) AS [ab_lhdt_flow]
		,ISNULL([ab_ea_mhdt_flow], 0) + ISNULL([ab_am_mhdt_flow], 0) + ISNULL([ab_md_mhdt_flow], 0) + ISNULL([ab_pm_mhdt_flow], 0) + ISNULL([ab_ev_mhdt_flow], 0) AS [ab_mhdt_flow]
		,ISNULL([ab_ea_hhdt_flow], 0) + ISNULL([ab_am_hhdt_flow], 0) + ISNULL([ab_md_hhdt_flow], 0) + ISNULL([ab_pm_hhdt_flow], 0) + ISNULL([ab_ev_hhdt_flow], 0) AS [ab_hhdt_flow]
		,ISNULL([ba_ea_lhdt_flow], 0) + ISNULL([ba_am_lhdt_flow], 0) + ISNULL([ba_md_lhdt_flow], 0) + ISNULL([ba_pm_lhdt_flow], 0) + ISNULL([ba_ev_lhdt_flow], 0) AS [ba_lhdt_flow]
		,ISNULL([ba_ea_mhdt_flow], 0) + ISNULL([ba_am_mhdt_flow], 0) + ISNULL([ba_md_mhdt_flow], 0) + ISNULL([ba_pm_mhdt_flow], 0) + ISNULL([ba_ev_mhdt_flow], 0) AS [ba_mhdt_flow]
		,ISNULL([ba_ea_hhdt_flow], 0) + ISNULL([ba_am_hhdt_flow], 0) + ISNULL([ba_md_hhdt_flow], 0) + ISNULL([ba_pm_hhdt_flow], 0) + ISNULL([ba_ev_hhdt_flow], 0) AS [ba_hhdt_flow]
        ,ISNULL([ab_ea_lhdt_flow], 0) AS [ab_ea_lhdt_flow]
		,ISNULL([ab_ea_mhdt_flow], 0) AS [ab_ea_mhdt_flow]
		,ISNULL([ab_ea_hhdt_flow], 0) AS [ab_ea_hhdt_flow]
        ,ISNULL([ab_am_lhdt_flow], 0) AS [ab_am_lhdt_flow]
		,ISNULL([ab_am_mhdt_flow], 0) AS [ab_am_mhdt_flow]
		,ISNULL([ab_am_hhdt_flow], 0) AS [ab_am_hhdt_flow]
        ,ISNULL([ab_md_lhdt_flow], 0) AS [ab_md_lhdt_flow]
		,ISNULL([ab_md_mhdt_flow], 0) AS [ab_md_mhdt_flow]
		,ISNULL([ab_md_hhdt_flow], 0) AS [ab_md_hhdt_flow]
        ,ISNULL([ab_pm_lhdt_flow], 0) AS [ab_pm_lhdt_flow]
		,ISNULL([ab_pm_mhdt_flow], 0) AS [ab_pm_mhdt_flow]
		,ISNULL([ab_pm_hhdt_flow], 0) AS [ab_pm_hhdt_flow]
        ,ISNULL([ab_ev_lhdt_flow], 0) AS [ab_ev_lhdt_flow]
		,ISNULL([ab_ev_mhdt_flow], 0) AS [ab_ev_mhdt_flow]
		,ISNULL([ab_ev_hhdt_flow], 0) AS [ab_ev_hhdt_flow]
        ,ISNULL([ba_ea_lhdt_flow], 0) AS [ba_ea_lhdt_flow]
		,ISNULL([ba_ea_mhdt_flow], 0) AS [ba_ea_mhdt_flow]
		,ISNULL([ba_ea_hhdt_flow], 0) AS [ba_ea_hhdt_flow]
        ,ISNULL([ba_am_lhdt_flow], 0) AS [ba_am_lhdt_flow]
		,ISNULL([ba_am_mhdt_flow], 0) AS [ba_am_mhdt_flow]
		,ISNULL([ba_am_hhdt_flow], 0) AS [ba_am_hhdt_flow]
        ,ISNULL([ba_md_lhdt_flow], 0) AS [ba_md_lhdt_flow]
		,ISNULL([ba_md_mhdt_flow], 0) AS [ba_md_mhdt_flow]
		,ISNULL([ba_md_hhdt_flow], 0) AS [ba_md_hhdt_flow]
        ,ISNULL([ba_pm_lhdt_flow], 0) AS [ba_pm_lhdt_flow]
		,ISNULL([ba_pm_mhdt_flow], 0) AS [ba_pm_mhdt_flow]
		,ISNULL([ba_pm_hhdt_flow], 0) AS [ba_pm_hhdt_flow]
        ,ISNULL([ba_ev_lhdt_flow], 0) AS [ba_ev_lhdt_flow]
		,ISNULL([ba_ev_mhdt_flow], 0) AS [ba_ev_mhdt_flow]
		,ISNULL([ba_ev_hhdt_flow], 0) AS [ba_ev_hhdt_flow]
        ,ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0) +
         ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0) AS [preload_flow]  
        ,ISNULL([ab_ea_preload_flow], 0) + ISNULL([ab_am_preload_flow], 0) + ISNULL([ab_md_preload_flow], 0) + ISNULL([ab_pm_preload_flow], 0) + ISNULL([ab_ev_preload_flow], 0) AS [ab_preload_flow]
        ,ISNULL([ba_ea_preload_flow], 0) + ISNULL([ba_am_preload_flow], 0) + ISNULL([ba_md_preload_flow], 0) + ISNULL([ba_pm_preload_flow], 0) + ISNULL([ba_ev_preload_flow], 0) AS [ba_preload_flow]
        ,ISNULL([ab_ea_preload_flow], 0) AS [ab_ea_preload_flow]
        ,ISNULL([ab_am_preload_flow], 0) AS [ab_am_preload_flow]
        ,ISNULL([ab_md_preload_flow], 0) AS [ab_md_preload_flow]
        ,ISNULL([ab_pm_preload_flow], 0) AS [ab_pm_preload_flow]
        ,ISNULL([ab_ev_preload_flow], 0) AS [ab_ev_preload_flow]
        ,ISNULL([ba_ea_preload_flow], 0) AS [ba_ea_preload_flow]
        ,ISNULL([ba_am_preload_flow], 0) AS [ba_am_preload_flow]
        ,ISNULL([ba_md_preload_flow], 0) AS [ba_md_preload_flow]
        ,ISNULL([ba_pm_preload_flow], 0) AS [ba_pm_preload_flow]
        ,ISNULL([ba_ev_preload_flow], 0) AS [ba_ev_preload_flow]
        ,[ab_ea_speed]
        ,[ab_am_speed]
        ,[ab_md_speed]
        ,[ab_pm_speed]
        ,[ab_ev_speed]
        ,[ba_ea_speed]
        ,[ba_am_speed]
        ,[ba_md_speed]
        ,[ba_pm_speed]
        ,[ba_ev_speed]
        ,[ab_ea_ln]
        ,[ab_am_ln]
        ,[ab_md_ln]
        ,[ab_pm_ln]
        ,[ab_ev_ln]
        ,[ba_ea_ln]
        ,[ba_am_ln]
        ,[ba_md_ln]
        ,[ba_pm_ln]
        ,[ba_ev_ln]
        ,[hwy_link].[shape].MakeValid() AS [shape]
    FROM (
        SELECT
            [hwy_flow_mode].[hwy_link_id]
            ,CONCAT(CASE WHEN [ab] = 1 THEN 'ab'
                          WHEN [ab] = 0 THEN 'ba'
                          ELSE NULL END,
                     '_',
                     CASE WHEN [abm_5_tod] = '1' THEN 'ea'
                          WHEN [abm_5_tod] = '2' THEN 'am'
                          WHEN [abm_5_tod] = '3' THEN 'md'
                          WHEN [abm_5_tod] = '4' THEN 'pm'
                          WHEN [abm_5_tod] = '5' THEN 'ev'
                          ELSE NULL END,
                      '_',
                     CASE WHEN [mode_description] = 'Highway Network Preload - Bus' THEN 'preload'
                          WHEN [mode_description] = 'Light Heavy Duty Truck' THEN 'lhdt'
                          WHEN [mode_description] = 'Medium Heavy Duty Truck' THEN 'mhdt'
                          WHEN [mode_description] = 'Heavy Heavy Duty Truck' THEN 'hhdt'
                          WHEN [mode_description] = 'Drive Alone' THEN 'da'
                          WHEN [mode_description] = 'Shared Ride 2' THEN 'sr2'
                          WHEN [mode_description] = 'Shared Ride 3+' THEN 'sr3'
                          ELSE NULL END,
                     '_flow') AS [class]
            ,[flow] AS [flow]
        FROM
            [fact].[hwy_flow_mode]
        INNER JOIN
            [dimension].[hwy_link_ab]
        ON
            [hwy_flow_mode].[scenario_id] = [hwy_link_ab].[scenario_id]
            AND [hwy_flow_mode].[hwy_link_ab_id] = [hwy_link_ab].[hwy_link_ab_id]
        INNER JOIN
            [dimension].[time]
        ON
            [hwy_flow_mode].[time_id] = [time].[time_id]
        INNER JOIN
            [dimension].[mode]
        ON
            [hwy_flow_mode].[mode_id] = [mode].[mode_id]
        WHERE
            [hwy_flow_mode].[scenario_id] = @scenario_id
            AND [hwy_link_ab].[scenario_id] = @scenario_id) AS [hwy_flow_mode_to_p]
    PIVOT ( SUM([flow]) FOR [class] IN ([ab_ea_da_flow],
                                        [ab_am_da_flow],
                                        [ab_md_da_flow],
                                        [ab_pm_da_flow],
                                        [ab_ev_da_flow],
                                        [ab_ea_sr2_flow],
                                        [ab_am_sr2_flow],
                                        [ab_md_sr2_flow],
                                        [ab_pm_sr2_flow],
                                        [ab_ev_sr2_flow],
                                        [ab_ea_sr3_flow],
                                        [ab_am_sr3_flow],
                                        [ab_md_sr3_flow],
                                        [ab_pm_sr3_flow],
                                        [ab_ev_sr3_flow],
					[ab_ea_lhdt_flow],
                                        [ab_am_lhdt_flow],
                                        [ab_md_lhdt_flow],
                                        [ab_pm_lhdt_flow],
                                        [ab_ev_lhdt_flow],
                                        [ab_ea_mhdt_flow],
                                        [ab_am_mhdt_flow],
                                        [ab_md_mhdt_flow],
                                        [ab_pm_mhdt_flow],
                                        [ab_ev_mhdt_flow],
					[ab_ea_hhdt_flow],
                                        [ab_am_hhdt_flow],
                                        [ab_md_hhdt_flow],
                                        [ab_pm_hhdt_flow],
                                        [ab_ev_hhdt_flow],
                                        [ab_ea_preload_flow],
                                        [ab_am_preload_flow],
                                        [ab_md_preload_flow],
                                        [ab_pm_preload_flow],
                                        [ab_ev_preload_flow],
                                        [ba_ea_da_flow],
                                        [ba_am_da_flow],
                                        [ba_md_da_flow],
                                        [ba_pm_da_flow],
                                        [ba_ev_da_flow],
                                        [ba_ea_sr2_flow],
                                        [ba_am_sr2_flow],
                                        [ba_md_sr2_flow],
                                        [ba_pm_sr2_flow],
                                        [ba_ev_sr2_flow],
                                        [ba_ea_sr3_flow],
                                        [ba_am_sr3_flow],
                                        [ba_md_sr3_flow],
                                        [ba_pm_sr3_flow],
                                        [ba_ev_sr3_flow],
                                        [ba_ea_lhdt_flow],
                                        [ba_am_lhdt_flow],
                                        [ba_md_lhdt_flow],
                                        [ba_pm_lhdt_flow],
                                        [ba_ev_lhdt_flow],
                                        [ba_ea_mhdt_flow],
                                        [ba_am_mhdt_flow],
                                        [ba_md_mhdt_flow],
                                        [ba_pm_mhdt_flow],
                                        [ba_ev_mhdt_flow],
					[ba_ea_hhdt_flow],
                                        [ba_am_hhdt_flow],
                                        [ba_md_hhdt_flow],
                                        [ba_pm_hhdt_flow],
                                        [ba_ev_hhdt_flow],
                                        [ba_ea_preload_flow],
                                        [ba_am_preload_flow],
                                        [ba_md_preload_flow],
                                        [ba_pm_preload_flow],
                                        [ba_ev_preload_flow])
    ) AS [hwy_flow_mode_p]
    INNER JOIN (
        SELECT
            [hwy_flow].[hwy_link_id]
            ,CONCAT(CASE WHEN [ab] = 1 THEN 'ab'
                            WHEN [ab] = 0 THEN 'ba'
                            ELSE NULL END,
                        '_',
                        CASE WHEN [abm_5_tod] = '1' THEN 'ea'
                            WHEN [abm_5_tod] = '2' THEN 'am'
                            WHEN [abm_5_tod] = '3' THEN 'md'
                            WHEN [abm_5_tod] = '4' THEN 'pm'
                            WHEN [abm_5_tod] = '5' THEN 'ev'
                            ELSE NULL END,
                        '_speed') AS [class]
              ,[speed]
        FROM
            [fact].[hwy_flow]
        INNER JOIN
            [dimension].[hwy_link_ab_tod]
        ON
            [hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
            AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
        INNER JOIN
            [dimension].[time]
        ON
            [hwy_flow].[time_id] = [time].[time_id]
        WHERE
            [hwy_flow].[scenario_id] = @scenario_id
            AND [hwy_link_ab_tod].[scenario_id] = @scenario_id) AS [hwy_speed_to_p]
        PIVOT ( AVG([speed]) FOR [class] IN ([ab_ea_speed],
                                             [ab_am_speed],
                                             [ab_md_speed],
                                             [ab_pm_speed],
                                             [ab_ev_speed],
                                             [ba_ea_speed],
                                             [ba_am_speed],
                                             [ba_md_speed],
                                             [ba_pm_speed],
                                             [ba_ev_speed])
        ) AS [hwy_speed_p]
    ON
        [hwy_flow_mode_p].[hwy_link_id] = [hwy_speed_p].[hwy_link_id]
    INNER JOIN (
        SELECT
            [hwy_link_ab_tod].[hwy_link_id]
            ,CONCAT(CASE WHEN [ab] = 1 THEN 'ab'
                            WHEN [ab] = 0 THEN 'ba'
                            ELSE NULL END,
                        '_',
                        CASE WHEN [abm_5_tod] = '1' THEN 'ea'
                            WHEN [abm_5_tod] = '2' THEN 'am'
                            WHEN [abm_5_tod] = '3' THEN 'md'
                            WHEN [abm_5_tod] = '4' THEN 'pm'
                            WHEN [abm_5_tod] = '5' THEN 'ev'
                            ELSE NULL END,
                        '_ln') AS [class]
              ,CASE WHEN [ln] = 9 THEN 0 ELSE [ln] END AS [ln]
        FROM
            [dimension].[hwy_link_ab_tod]
        INNER JOIN
            [dimension].[time]
        ON
            [hwy_link_ab_tod].[time_id] = [time].[time_id]
        WHERE
            [hwy_link_ab_tod].[scenario_id] = @scenario_id
            AND [hwy_link_ab_tod].[scenario_id] = @scenario_id) AS [hwy_ln_to_p]
        PIVOT ( MAX([ln]) FOR [class] IN ([ab_ea_ln],
                                          [ab_am_ln],
                                          [ab_md_ln],
                                          [ab_pm_ln],
                                          [ab_ev_ln],
                                          [ba_ea_ln],
                                          [ba_am_ln],
                                          [ba_md_ln],
                                          [ba_pm_ln],
                                          [ba_ev_ln])
        ) AS [hwy_ln_p]
    ON
         [hwy_flow_mode_p].[hwy_link_id] = [hwy_ln_p].[hwy_link_id]
    INNER JOIN
        [dimension].[hwy_link]
    ON
        [hwy_flow_mode_p].[hwy_link_id] = [hwy_link].[hwy_link_id]
        AND [hwy_link].[scenario_id] = @scenario_id
GO

-- add metadata for [rp_2021].[fn_eir_shp_qry_layer]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_eir_shp_qry_layer', 'MS_Description', 'shape file query layer for RP 2021 EIR'
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

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

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
	    ,SUM(CASE WHEN [fn_person_coc].[person_id] > 0 THEN [household_sample_weight] ELSE 0 END) AS [persons]  -- remove not applicable records
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Senior' THEN [household_sample_weight] ELSE 0 END) AS [senior]
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Non-Senior' THEN [household_sample_weight] ELSE 0 END) AS [non_senior]
        ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Minority' THEN [household_sample_weight] ELSE 0 END) AS [minority]
	    ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Non-Minority' THEN [household_sample_weight] ELSE 0 END) AS [non_minority]
        ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Low Income' THEN [household_sample_weight] ELSE 0 END) AS [low_income]
	    ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Non-Low Income' THEN [household_sample_weight] ELSE 0 END) AS [non_low_income]
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
		AND [geography_household_location].[geography_household_location_set_id] = @geo_set_id
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

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

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
		AND [geography_household_location].[geography_household_location_set_id] = @geo_set_id
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
	,CASE   WHEN [household].[poverty] < 2
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
                OR [household].[poverty] < 2
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
    the 2021 Regional Plan Performance Meausres SM-2 and SM-3.

    Tier 1: hardcoded routes 581, 582 583 and commuter rail routes
    Tier 2: light rail routes
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
        ,CASE   WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
                    OR [mode_transit_route_description] = 'Commuter Rail'
                THEN 'Tier 1'
                WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
                    AND [mode_transit_route_description] = 'Light Rail'
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
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_transit_node_tiers', 'MS_Description', 'inline function returning list of all Tier <<1,2,3>> transit stop nodes used in performance measures SM-2 and SM-3'
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

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

SELECT
    CONVERT(integer, [geography].[mgra_13]) AS [mgra]
	,CONVERT(integer, [geography].[taz_13]) AS [taz]
    ,ISNULL([mgra_tiers].[tier], 0) AS [employmentCenterTier]  -- used in PM M-5-a and M-5-b
	,[emp_health] AS [empHealth]  -- used in pm M-1-c
	,[parkactive] AS [parkActive]  -- used in pm M-1-b, indicator > .5
	,[emp_retail] AS [empRetail]  -- used in pm M-1-a
    ,[collegeenroll] + [othercollegeenroll] AS [higherLearningEnrollment]  -- used in pm M-5-c
    ,[othercollegeenroll] AS [otherCollegeEnrollment]
FROM
	[fact].[mgra_based_input]
INNER JOIN
	[dimension].[geography]
ON
	[mgra_based_input].[geography_id] = [geography].[geography_id]
	AND [geography].[geography_set_id] = @geo_set_id
LEFT OUTER JOIN (  -- get indicators if MGRAs in Tier 1-4 employment centers
    SELECT
        [mgra_13],
        [tier]
    FROM
        [employment].[employment_centers].[fn_get_mgra_xref](1)
     WHERE
         [tier] IN (1,2,3,4)) AS [mgra_tiers]
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
	@age_18_plus bit = 0,  -- 1/0 switch to limit population to aged 18+
	@age_18_24 bit = 0 -- 1/0 switch to limit population to age between 18 and 24. These two arguments should be mutually exclusive
AS
/**
summary:   >
    Population at the MGRA level used in calculations for the 2021 Regional
    Plan Main Performance Measures M1 and M5. Allows aggregation to MGRA
	or TAZ level for both transit and auto accessibility, optional restriction
	to 18+ for employment and education metrics. Also includes Community of
    Concern designations and Series 13 MGRA Mobility Hub information.
**/
SET NOCOUNT ON;

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

IF @age_18_plus =1 AND @age_18_24 = 1
BEGIN
    RAISERROR('Invalid parameter: The two age arguments can not both be 1',60,0)
    RETURN	 
END

SELECT
	CONVERT(integer, [geography_household_location].[household_location_mgra_13]) AS [mgra]
	,CONVERT(integer, [geography_household_location].[household_location_taz_13]) AS [taz]
	,MAX(CASE WHEN [mobility_hubs].[mgra_13] IS NOT NULL THEN [person_sample_weight] ELSE 0 END) AS [mobilityHub]
	,ISNULL(MAX([mobility_hubs].[mobility_hub_name]), 'Not Applicable') AS [mobilityHubName]
    ,ISNULL(MAX([mobility_hubs].[mobility_hub_type]), 'Not Applicable') AS [mobilityHubType]
	,COUNT([fn_person_coc].[person_id]) AS [pop]
	,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popLowIncome]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonLowIncome]
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
	AND [geography_household_location].[geography_household_location_set_id] = @geo_set_id
LEFT OUTER JOIN
    [rp_2021].[mobility_hubs]
ON
    [geography_household_location].[household_location_mgra_13] = [mobility_hubs].[mgra_13]
WHERE
    [person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND [person].[person_id] > 0  -- remove Not Applicable values
	AND [household].[household_id] > 0  -- remove Not Applicable values
	AND ((@age_18_plus = 1 AND [person].[age] >= 18)		
		OR @age_18_plus = 0)  -- if age 18+ option is selected restrict population to individuals age 18 or older
	AND ((@age_18_24 = 1 AND [person].[age] between 18 and 24)
		OR @age_18_24 = 0) -- if age 18_24 option is selected restrict population to individuals age between 18 and 24
GROUP BY
	[geography_household_location].[household_location_mgra_13]
	,[geography_household_location].[household_location_taz_13]
OPTION (MAXDOP 1)
GO

-- add metadata for [rp_2021].[sp_m1_m5_populations]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_m1_m5_populations', 'MS_Description', 'main performance measures M-1 and M-5 populations'
GO

DROP PROCEDURE IF EXISTS [rp_2021].[sp_m1_m5_populations_18to24]
GO

CREATE PROCEDURE [rp_2021].[sp_m1_m5_populations_18to24]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@age_18_plus bit = 0  -- 1/0 switch to limit population to aged between 18+ and 24
AS
/**
summary:   >
    Population at the MGRA level used in calculations for the 2021 Regional
    Plan Main Performance Measures M1 and M5. Allows aggregation to MGRA
	or TAZ level for both transit and auto accessibility, optional restriction
	to 18+ for employment and education metrics. Also includes Community of
    Concern designations and Series 13 MGRA Mobility Hub indicator.
**/
SET NOCOUNT ON;

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

SELECT
	CONVERT(integer, [geography_household_location].[household_location_mgra_13]) AS [mgra]
	,CONVERT(integer, [geography_household_location].[household_location_taz_13]) AS [taz]
	,MAX(CASE WHEN [mobility_hubs].[mgra_13] IS NOT NULL THEN [person_sample_weight] ELSE 0 END) AS [mobilityHub]
	,mobility_hub_name
	,COUNT([fn_person_coc].[person_id]) AS [pop]
	,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popLowIncome]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonLowIncome]
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
	AND [geography_household_location].[geography_household_location_set_id] = @geo_set_id
LEFT OUTER JOIN
    [rp_2021].[mobility_hubs]
ON
    [geography_household_location].[household_location_mgra_13] = CAST([mobility_hubs].[mgra_13] AS NVARCHAR)
WHERE
    [person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND [person].[person_id] > 0  -- remove Not Applicable values
	AND [household].[household_id] > 0  -- remove Not Applicable values
	AND ((@age_18_plus = 1 AND [person].[age] between 18 and 24)
		OR @age_18_plus = 0)  -- if age 18+ option is selected restrict population to individuals age 18 or older
GROUP BY
	[geography_household_location].[household_location_mgra_13]
	,[geography_household_location].[household_location_taz_13]
    ,mobility_hub_name
OPTION (MAXDOP 1)
GO

DROP PROCEDURE IF EXISTS [rp_2021].[sp_m1_m5_populations_X]
GO

CREATE PROCEDURE [rp_2021].[sp_m1_m5_populations_X]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@age_18_plus bit = 0  -- 1/0 switch to limit population to aged 18+
AS
/**
summary:   >
    Population at the MGRA level used in calculations for the 2021 Regional
    Plan Main Performance Measures M1 and M5. Allows aggregation to MGRA
	or TAZ level for both transit and auto accessibility, optional restriction
	to 18+ for employment and education metrics. Also includes Community of
    Concern designations and Series 13 MGRA Mobility Hub information.
**/
SET NOCOUNT ON;

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

SELECT
	CONVERT(integer, [geography_household_location].[household_location_mgra_13]) AS [mgra]
	,CONVERT(integer, [geography_household_location].[household_location_taz_13]) AS [taz]
	,MAX(CASE WHEN [mobility_hubs].[mgra_13] IS NOT NULL THEN [person_sample_weight] ELSE 0 END) AS [mobilityHub]
	,ISNULL(MAX([mobility_hubs].[mobility_hub_name]), 'Not Applicable') AS [mobilityHubName]
    ,ISNULL(MAX([mobility_hubs].[mobility_hub_type]), 'Not Applicable') AS [mobilityHubType]
	,COUNT([fn_person_coc].[person_id]) AS [pop]
	,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[senior] = 'Non-Senior'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonSenior]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[minority] = 'Non-Minority'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonMinority]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popLowIncome]
    ,SUM(CASE   WHEN [fn_person_coc].[low_income] = 'Non-Low Income'
                THEN [person_sample_weight] ELSE 0 END) AS [popNonLowIncome]
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
	AND [geography_household_location].[geography_household_location_set_id] = @geo_set_id
LEFT OUTER JOIN
    [rp_2021].[mobility_hubs]
ON
    [geography_household_location].[household_location_mgra_13] = [mobility_hubs].[mgra_13]
WHERE
    [person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND [person].[person_id] > 0  -- remove Not Applicable values
	AND [household].[household_id] > 0  -- remove Not Applicable values
	AND ((@age_18_plus = [person_sample_weight] AND [person].[age] >= 18)
		OR @age_18_plus = 0)  -- if age 18+ option is selected restrict population to individuals age 18 or older
GROUP BY
	[geography_household_location].[household_location_mgra_13]
	,[geography_household_location].[household_location_taz_13]
OPTION (MAXDOP 1)
GO

-- create stored procedure for performance measure SM-1 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm1]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm1]
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
    2021 Regional Plan Performance Measure SM-1 Mode Share, Percent of
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
    SET @measure  = 'SM-1 - All Trips'
IF(@work = 0 AND @peak_period = 1)
    SET @measure = 'SM-1 - All Peak Period Trips'
IF(@work = 1 AND @peak_period = 0)
    SET @measure = 'SM-1 - Outbound Work Trips'
IF(@work = 1 AND @peak_period = 1)
    SET @measure = 'SM-1 - Peak Period Outbound Work Trips'

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN
    -- remove SM-1 result for the given ABM scenario from the results table
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
	        ISNULL(CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Super-Walk',
	                                                                           'School Bus',
                                                                               'Taxi',
                                                                               'Non-Pooled TNC',
                                                                               'Pooled TNC')
                        THEN 'Other'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Bike', 'Walk')
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
	        CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Super-Walk',
	                                                                    'School Bus',
                                                                        'Taxi',
                                                                        'Non-Pooled TNC',
                                                                        'Pooled TNC')
                        THEN 'Other'
                        WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Bike', 'Walk')
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
            ISNULL(CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Super-Walk',
                                                                                             'School Bus',
                                                                                             'Taxi',
                                                                                             'Non-Pooled TNC',
                                                                                             'Pooled TNC')
                        THEN 'Other'
                        WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Bike', 'Walk')
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
	        CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Super-Walk',
                                                                                      'School Bus',
                                                                                      'Taxi',
                                                                                      'Non-Pooled TNC',
                                                                                      'Pooled TNC')
                 THEN 'Other'
                 WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN ('Bike', 'Walk')
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
	    ,ISNULL([person_trips] / @total_trips, 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
	    @aggregated_trips
    RIGHT OUTER JOIN (  -- ensure all modes are represented
        SELECT DISTINCT
            CASE WHEN [mode_aggregate_trip_description] IN ('Super-Walk',
                                                            'Taxi',
                                                            'School Bus',
                                                            'Non-Pooled TNC',
                                                            'Pooled TNC')
                 THEN 'Other'
                 WHEN [mode_aggregate_trip_description] IN ('Bike', 'Walk')
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
            CASE WHEN [mode_aggregate_trip_description] IN ('Super-Walk',
                                                            'Taxi',
                                                            'School Bus',
                                                            'Non-Pooled TNC',
                                                            'Pooled TNC')
                 THEN 'Other'
                 WHEN [mode_aggregate_trip_description] IN ('Bike', 'Walk')
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

-- add metadata for [rp_2021].[sp_pm_sm1]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm1', 'MS_Description', 'performance measure SM-1 Mode Share'
GO




-- create stored procedure for performance measure SM-5 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm5]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm5]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @mobilityHubs bit,  -- 1/0 switch to restrict boardings to stops within
        -- mobility hub MGRAs
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 1  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-5 Daily Transit Boardings.
    Total boardings and total boardings for Tier 1, Tier 2, Tier 3, and local
    bus transit routes. are provided. Tier 1 + Tier 2 routes are hardcoded
    based on route numbers.

filters:   >
    [transit_route].[config] / 1000 IN (581, 582, 583) OR [mode_transit_route_description] = 'Commuter Rail'
        Tier 1 transit routes
    [transit_route].[config] / 1000 NOT IN (581, 582, 583) AND [mode_transit_route_description] = 'Light Rail'
        Tier 2 transit routes

revisions:
    - author: None
      modification: None
      date: None
**/
BEGIN
SET NOCOUNT ON;

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)

-- set measure name based on mobility hubs switch
DECLARE @measure nvarchar(20)
IF @mobilityHubs = 1 SET @measure = 'SM-5 Mobility Hubs'
IF @mobilityHubs = 0 SET @measure = 'SM-5'

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF(@update = 1)
BEGIN

    -- remove SM-5 result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = @measure

    -- create table of stops to include boardings of, either all stops or
    -- stops within mobility hubs
    CREATE TABLE #includedStops (
    [transit_stop_id] integer
    PRIMARY KEY ([transit_stop_id]) )

    IF @mobilityHubs = 1
    BEGIN
        INSERT INTO #includedStops
        SELECT DISTINCT
            [transit_stop_id]
        FROM
            [dimension].[transit_stop]
        INNER JOIN (
            SELECT
                [mobility_hubs].[mgra_13]
                ,[geography].[mgra_13_shape]
            FROM
                [rp_2021].[mobility_hubs]
            INNER JOIN
                [dimension].[geography]
            ON
                [mobility_hubs].[mgra_13] = [geography].[mgra_13]
				AND [geography].[geography_set_id] = @geo_set_id
				) AS [moHubs]
        ON
            [transit_stop].[transit_stop_shape].STIntersects([moHubs].[mgra_13_shape]) = 1
        WHERE
            [scenario_id] = @scenario_id
    END
    ELSE
    BEGIN
        INSERT INTO #includedStops
        SELECT
            [transit_stop_id]
        FROM
            [dimension].[transit_stop]
        WHERE
            [scenario_id] = @scenario_id
    END

    -- insert SM-5 results into Performance Measures results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
        @scenario_id AS [scenario_id]
        ,@measure AS [measure]
        ,CONCAT('Daily Transit Boardings - ', [tier]) AS [metric]
        ,ISNULL([boardings], 0) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL(CASE WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
                          OR [mode_transit_route_description] = 'Commuter Rail'
                        THEN 'Tier 1'
                        WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
                          AND [mode_transit_route_description] = 'Light Rail'
                        THEN 'Tier 2'
                        WHEN [mode_transit_route_description] IN ('Freeway Rapid', 'Arterial Rapid')
                        THEN 'Tier 3'
                        WHEN [mode_transit_route_description] = 'Local Bus'
                        THEN 'Local Bus'
                        ELSE 'Other' END, 'Total') AS [tier]
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
        INNER JOIN  -- inner join stops of interest (either in MoHubs or all)
            #includedStops
        ON
            [transit_onoff].[transit_stop_id] = #includedStops.[transit_stop_id]
        WHERE
            [transit_onoff].[scenario_id] = @scenario_id
            AND [transit_route].[scenario_id] = @scenario_id
        GROUP BY
            CASE WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
                   OR [mode_transit_route_description] = 'Commuter Rail'
                 THEN 'Tier 1'
                 WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
                   AND [mode_transit_route_description] = 'Light Rail'
                 THEN 'Tier 2'
                 WHEN [mode_transit_route_description] IN ('Freeway Rapid', 'Arterial Rapid')
                 THEN 'Tier 3'
                WHEN [mode_transit_route_description] = 'Local Bus'
                THEN 'Local Bus'
                ELSE 'Other' END
        WITH ROLLUP) AS [boardings]

    DROP TABLE #includedStops
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

-- add metadata for [rp_2021].[sp_pm_sm5]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm5', 'MS_Description', 'performance measure SM-5 Transit Boardings'
GO




-- create stored procedure for performance measure SM-6 activity per capita --
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm6_activity]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm6_activity]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-6, person-level time engaged in
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
    -- remove Performance Measure SM-6 Activity per Capita result for the
    -- given ABM scenario from the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-6 Transportation-Related Physical Activity per Capita'


    -- create table variable to hold population with
    -- Community of Concern (CoC) attributes
    DECLARE @coc_pop TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(15) NOT NULL,
        [minority] nvarchar(15) NOT NULL,
        [low_income] nvarchar(15) NOT NULL,
		[person_sample_weight] float NOT NULL)

    -- assign CoC attributes to each person and insert into a table variable
    INSERT INTO @coc_pop
    SELECT
        [person].[person_id]
        ,[senior]
        ,[minority]
        ,[low_income]
		,[person_sample_weight]
    FROM
        [rp_2021].[fn_person_coc] (@scenario_id)
	JOIN 
		[dimension].[person]
	ON
		[fn_person_coc].[person_id] = [person].[person_id]
		AND [fn_person_coc].[scenario_id] = [person].[scenario_id]
    WHERE
        [person].[person_id] > 0;  -- remove Not Applicable record


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
                ,CAST(ROUND(SUM([person_sample_weight]),0) AS INT) AS [Total]
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
        ,'SM-6 Transportation-Related Physical Activity per Capita' AS [measure]
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
        AND [measure] = 'SM-6 Transportation-Related Physical Activity per Capita';
GO

-- add metadata for [rp_2021].[sp_pm_sm6_activity]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm6_activity', 'MS_Description', 'performance metric SM-6 Physical Activity per Capita'
GO




-- create stored procedure for performance metric SM-6 percentage engaged ----
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm6_pct]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm6_pct]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-6, percent of population
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
    -- remove Performance Measure SM-6 Percentage Engaged result for the
    -- given ABM scenario from the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity'


    -- create temporary table to store person-level results
    DECLARE @person_results TABLE (
        [person_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [activity] float NOT NULL,
		[person_sample_weight] float NOT NULL);


    -- insert person result set into a temporary table
    INSERT INTO @person_results
    SELECT
	    [person_coc].[person_id]
        ,[senior]
	    ,[minority]
	    ,[low_income]
	    ,ISNULL([physical_activity].[activity], 0) AS [activity]
		,[person_sample_weight]
    FROM (
	    SELECT
		    [person].[person_id]
		    ,[senior]
		    ,[minority]
		    ,[low_income]
			,[person_sample_weight]
	    FROM
		    [rp_2021].[fn_person_coc] (@scenario_id)
		JOIN 
			[dimension].[person]
		ON
			[fn_person_coc].[person_id] = [person].[person_id]
			AND [fn_person_coc].[scenario_id] = [person].[scenario_id]
         WHERE  -- remove Not Applicable records
            [person].[person_id] > 0) AS [person_coc]
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
        ,'SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity' AS [measure]
	    ,[pop_segmentation] AS [metric]
	    ,[activity] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
    SELECT
        1.0 * SUM(CASE WHEN [senior] = 'Senior' AND [activity] >= 20 THEN 1 ELSE 0 END) /
          SUM(CASE WHEN [senior] = 'Senior' THEN 1 ELSE 0 END) AS [Senior]
        ,1.0 * SUM(CASE WHEN [senior] = 'Non-Senior' AND [activity] >= 20 THEN 1 ELSE 0 END) /
           SUM(CASE WHEN [senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [Non-Senior]
        ,1.0 * SUM(CASE WHEN [minority] = 'Minority' AND [activity] >= 20 THEN 1 ELSE 0 END) /
           SUM(CASE WHEN [minority] = 'Minority' THEN 1 ELSE 0 END) AS [Minority]
        ,1.0 * SUM(CASE WHEN [minority] = 'Non-Minority' AND [activity] >= 20 THEN 1 ELSE 0 END) /
           SUM(CASE WHEN [minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [Non-Minority]
        ,1.0 * SUM(CASE WHEN [low_income] = 'Low Income' AND [activity] >= 20 THEN 1 ELSE 0 END) /
           SUM(CASE WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [Low Income]
        ,1.0 * SUM(CASE WHEN [low_income] = 'Non-Low Income' AND [activity] >= 20 THEN 1 ELSE 0 END) /
           SUM(CASE WHEN [low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [Non-Low Income]
        ,1.0 * SUM(CASE WHEN [activity] >= 20 THEN 1 ELSE 0 END) / CAST(ROUND(SUM([person_sample_weight]),0) AS INT) AS [Total]
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
        AND [measure] = 'SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity';
GO

-- add metadata for [rp_2021].[sp_pm_sm6_pct]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm6_pct', 'MS_Description', 'performance metric SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity'
GO




-- create stored procedure for performance measure SM-7 ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm7]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm7]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-7, average trip travel time for
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

DECLARE @geo_set_id integer;
	-- get geography set id
	SET @geo_set_id = 
	(
		SELECT [geography_set_id] FROM [dimension].[scenario]
		WHERE scenario_id = @scenario_id
	)
	
-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure SM-7 result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-7'

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
        ,'SM-7' AS [measure]
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
		AND [geography_trip_origin].[geography_trip_origin_set_id] = @geo_set_id
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
		AND [geography_trip_destination].[geography_trip_destination_set_id] = @geo_set_id
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
        AND [measure] = 'SM-7';
GO

-- add metadata for [rp_2021].[sp_pm_sm7]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm7', 'MS_Description', 'performance measure SM-7, Average truck/commercial vehicle travel times to and around regional gateways and distribution hubs (minutes)'
GO




-- create stored procedure for performance measure SM-9-a --------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm9a]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm9a]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table       
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-9-a, truck travel time index
    (TTI) caluclated as the summation of link-based travel time divided by
    free-flow time weighted by truck mode VMT. Note records where free-flow
    travel time is 0 are not included. Records where travel time is less than
    free-flow travel time have the travel time and free-flow travel time
    assumed to be equal.

filters:   >
    [mode_aggregate_description] IN ('Light Heavy Duty Truck', 'Medium Heavy Duty Truck', 'Heavy Heavy Duty Truck')
        Truck mode flows only.
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [fed_rtp_20].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure SM-9-a result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-9-a'

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
        ,'SM-9-a' AS [measure]
        ,ISNULL(CASE WHEN [ifc] = 1 THEN 'TTI - Highway (SHS)'  -- hardcoded ifc descriptions
		             WHEN [ifc] BETWEEN 2 AND 10 THEN 'TTI - Arterial'  -- hardcoded ifc descriptions
		             ELSE NULL END, 'TTI - All IFCs') AS [facility_type]
        -- calculate travel time divided by free-flow travel time multiplied by vmt
        -- do not include where free-flow travel time is 0 (not applicable)
        -- if travel time is less than free-flow travel time assume they are equal
	    ,SUM( IIF([hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx] = 0, 0,
                  IIF([hwy_flow].[time] < [hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx],
                      [hwy_flow_mode].[flow] * [hwy_link].[length_mile],
                      ([hwy_flow].[time] / ([hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx])) * ([hwy_flow_mode].[flow] * [hwy_link].[length_mile])))) /
         -- divide by VMT
         SUM( IIF([hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx] = 0, 0,
                  [hwy_flow_mode].[flow] * [hwy_link].[length_mile])) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[hwy_flow]
    INNER JOIN
        [dimension].[hwy_link]
    ON
        [hwy_flow].scenario_id = [hwy_link].[scenario_id]
        AND [hwy_flow].hwy_link_id = [hwy_link].[hwy_link_id]
    INNER JOIN
        [dimension].[hwy_link_ab_tod]
    ON
        [hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
        AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
    INNER JOIN
        [dimension].[time]
    ON
        [hwy_flow].[time_id] = [time].[time_id]
    INNER JOIN
        [fact].[hwy_flow_mode]
    ON
        [hwy_link_ab_tod].[scenario_id] = [hwy_flow_mode].[scenario_id]
        AND [hwy_link_ab_tod].[hwy_link_ab_tod_id] = [hwy_flow_mode].[hwy_link_ab_tod_id]
    INNER JOIN
        [dimension].[mode]
    ON
        [hwy_flow_mode].[mode_id] = [mode].[mode_id]
    WHERE
        [hwy_flow].[scenario_id] = @scenario_id
        AND [hwy_link].[scenario_id] = @scenario_id
        AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
        AND [hwy_flow_mode].[scenario_id] = @scenario_id
        -- truck flows only
        AND [mode_aggregate_description] IN ('Light Heavy Duty Truck',
                                             'Median Heavy Duty Truck',
                                             'Heavy Heavy Duty Truck')
    GROUP BY
        CASE WHEN [ifc] = 1 THEN 'TTI - Highway (SHS)'  -- hardcoded ifc descriptions
		     WHEN [ifc] BETWEEN 2 AND 10 THEN 'TTI - Arterial'  -- hardcoded ifc descriptions
		     ELSE NULL END
    WITH ROLLUP
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
        AND [measure] = 'SM-9-a';
GO

-- add metadata for [rp_2021].[sp_pm_sm9a]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm9a', 'MS_Description', 'performance measure SM-9-a, truck travel time index'
GO




-- create stored procedure for performance measure SM-9-b --------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm9b]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm9b]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-9-b, truck delay by facility type.

filters:   >
    [mode_aggregate_description] IN ('Light Heavy Duty Truck', 'Medium Heavy Duty Truck', 'Heavy Heavy Duty Truck')
        Truck mode flows only.
**/
SET NOCOUNT ON;

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[pm_results] table
IF(@update = 1)
BEGIN
    -- remove Performance Measure SM-9-b result for the given ABM scenario from the
    -- Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-9-b'

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
        ,'SM-9-b' AS [measure]
	    ,CONCAT([mode_aggregate_description], ' - ', [facility_type], ' - ', [metric]) AS [metric]
	    ,[value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
	        ISNULL(CASE WHEN [ifc] = 1 THEN 'Highway (SHS)'  -- hardcoded ifc descriptions
		                WHEN [ifc] BETWEEN 2 AND 10 THEN 'Arterial'  -- hardcoded ifc descriptions
		                ELSE NULL END, 'All IFCs') AS [facility_type]
	        ,ISNULL([mode_aggregate_description], 'All Heavy Duty Trucks') AS [mode_aggregate_description]
	        ,SUM(IIF([hwy_flow].[time] < [hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx], 0  -- vhd always >= 0
                     ,[hwy_flow_mode].[flow]* ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0)) AS [VHD]
            ,SUM(CASE WHEN [abm_5_tod] IN ('2','4')  -- abm five time of day peak periods
                      THEN IIF([hwy_flow].[time] < [hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx], 0  -- vhd always >= 0
                               ,[hwy_flow_mode].[flow]* ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0)
                      ELSE 0 END) AS [VHD - Peak Period]
        FROM
            [fact].[hwy_flow]
        INNER JOIN
            [dimension].[hwy_link]
        ON
            [hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
            AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
        INNER JOIN
            [dimension].[hwy_link_ab_tod]
        ON
            [hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
            AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
        INNER JOIN
            [fact].[hwy_flow_mode]
        ON
            [hwy_link_ab_tod].[scenario_id] = [hwy_flow_mode].[scenario_id]
            AND [hwy_link_ab_tod].[hwy_link_ab_tod_id] = [hwy_flow_mode].[hwy_link_ab_tod_id]
        INNER JOIN
            [dimension].[time]
        ON
            [hwy_flow].[time_id] = [time].[time_id]
        INNER JOIN
            [dimension].[mode]
        ON
            [hwy_flow_mode].[mode_id] = [mode].[mode_id]
        WHERE
            [hwy_flow].[scenario_id] = @scenario_id
            AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
            AND [hwy_flow_mode].[scenario_id] = @scenario_id
            -- only select truck flows
            AND [mode_aggregate_description] IN ('Light Heavy Duty Truck',
                                                 'Medium Heavy Duty Truck',
                                                 'Heavy Heavy Duty Truck')
        GROUP BY
            CASE WHEN [ifc] = 1 THEN 'Highway (SHS)'  -- hardcoded ifc descriptions
		         WHEN [ifc] BETWEEN 2 AND 10 THEN 'Arterial'  -- hardcoded ifc descriptions
		         ELSE NULL END
            ,[mode_aggregate_description]
        WITH ROLLUP) AS [p]
    UNPIVOT
        (value FOR metric IN ([VHD], [VHD - Peak Period])) AS [un_p]
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
        AND [measure] = 'SM-9-b';
GO

-- add metadata for [rp_2021].[sp_pm_sm9b]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm9b', 'MS_Description', 'performance measure SM-9-b, truck delay by facility type'
GO




-- create stored procedure for performance measure SM-10 ---------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_pm_sm10]
GO

CREATE PROCEDURE [rp_2021].[sp_pm_sm10]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    2021 Regional Plan Performance Measure SM-10, percent of household income
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
    -- remove Performance Measure SM-10 result for the given ABM scenario from
    -- the Performance Measure results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SM-10';


    -- create temporary table to store household-level results
    DECLARE @hh_results TABLE (
        [household_id] integer PRIMARY KEY NOT NULL,
        [senior] nvarchar(20) NOT NULL,
        [minority] nvarchar(20) NOT NULL,
        [low_income] nvarchar(20) NOT NULL,
        [household_income] integer NOT NULL,
        [annual_cost] float NOT NULL,
		[household_sample_weight] float NOT NULL);

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
		,[household_sample_weight]
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
			,MAX([household_sample_weight]) [household_sample_weight]
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
        ,'SM-10' AS [measure]
	    ,[pop_segmentation] AS [metric]
	    ,[annual_cost] AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            SUM(CASE    WHEN [senior] = 'Senior' THEN 1 ELSE 0 END *
                        -- cap percentage cost at 100% of income
		        CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                        THEN 1 ELSE [annual_cost] / [household_income] END) /
		    SUM(CASE    WHEN [senior] = 'Senior' THEN 1  ELSE 0 END) AS [Senior]
            ,SUM(CASE    WHEN [senior] = 'Non-Senior' THEN 1 ELSE 0 END *
                 -- cap percentage cost at 100% of income
		         CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                         THEN 1 ELSE [annual_cost] / [household_income] END) /
		     SUM(CASE    WHEN [senior] = 'Non-Senior' THEN 1  ELSE 0 END) AS [Non-Senior]
            ,SUM(CASE    WHEN [minority] = 'Minority' THEN 1 ELSE 0 END *
                 -- cap percentage cost at 100% of income
		         CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                         THEN 1 ELSE [annual_cost] / [household_income] END) /
		     SUM(CASE    WHEN [minority] = 'Minority' THEN 1  ELSE 0 END) AS [Minority]
            ,SUM(CASE    WHEN [minority] = 'Non-Minority' THEN 1 ELSE 0 END *
                 -- cap percentage cost at 100% of income
		         CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                         THEN 1 ELSE [annual_cost] / [household_income] END) /
		     SUM(CASE    WHEN [minority] = 'Non-Minority' THEN 1  ELSE 0 END) AS [Non-Minority]
            ,SUM(CASE    WHEN [low_income] = 'Low Income' THEN 1 ELSE 0 END *
                 -- cap percentage cost at 100% of income
		         CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                         THEN 1 ELSE [annual_cost] / [household_income] END) /
		     SUM(CASE    WHEN [low_income] = 'Low Income' THEN 1  ELSE 0 END) AS [Low Income]
            ,SUM(CASE    WHEN [low_income] = 'Non-Low Income' THEN 1 ELSE 0 END *
                 -- cap percentage cost at 100% of income
		         CASE    WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                         THEN 1 ELSE [annual_cost] / [household_income] END) /
		     SUM(CASE    WHEN [low_income] = 'Non-Low Income' THEN 1  ELSE 0 END) AS [Non-Low Income]
            ,SUM(CASE   WHEN [household_income] = 0 OR [annual_cost] / [household_income] > 1
                        THEN 1 ELSE [annual_cost] / [household_income] END) /
			SUM([household_sample_weight]) AS [Total]
		    -- COUNT([household_id]) AS [Total]
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
        AND [measure] = 'SM-10';
GO

-- add metadata for [rp_2021].[sp_pm_sm10]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_pm_sm10', 'MS_Description', 'performance measure SM-10, Percent of Income Consumed by Out-of-Pocket Transportation Costs'
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
            SUM([person_sample_weight])
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




-- create stored procedure for San Diego resident VMT ------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_resident_vmt]
GO

CREATE PROCEDURE [rp_2021].[sp_resident_vmt]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@geography_column nvarchar(max),  -- column in [dimension].[geography]
    -- table used to aggregate activity location to user-specified geography resolution
	@workers bit = 0,  -- select workers only, includes telecommuters but filters to work purpose tours
	@home_location bit = 0,  -- assign activity to home location
	@work_location bit = 0  -- assign activity to workplace location, includes telecommuters
AS

/**
summary:   >
    San Diego resident vehicle miles traveled (VMT) at a user-determined geographic
    resolution. VMT is assigned to either the resident's home or work location.
    Optional filter to select workers only and their work purpose tour VMT.
	Available at any geographic resolution present in the ABM database.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [person].[work_segment] != 'Not Applicable' AND [purpose_tour].[purpose_tour_description] = 'Work'
        if @workers parameter is specified, select only workers and trips on work purpose tours
**/

BEGIN
	-- input parameter checking ----

	-- ensure at least one indicator to assign activity to home or work location is selected
	IF CONVERT(int, @home_location) + CONVERT(int, @work_location) = 0
		RAISERROR ('Select to assign activity to either home or work location.', 16, 1)
	 -- ensure only one of indicator to assign activity to home or work location is selected
	ELSE IF CONVERT(int, @home_location) + CONVERT(int, @work_location) > 1
		RAISERROR ('Select only one indicator to assign activity to either home or work location.', 16, 1)
	-- if activity is assigned to work location then the workers only filter must be selected
	ELSE IF CONVERT(int, @workers) = 0 AND CONVERT(int, @work_location) >= 1
		RAISERROR ('Assigning activity to work location requires selection of workers only filter.', 16, 1)


	-- geography column stored procedure ----
	ELSE IF LEN(@geography_column) > 0
	BEGIN
		-- ensure the input geography column exists
		-- in the [dimension].[geography] table
		-- stop execution if it does not and throw error
		IF COL_LENGTH((SELECT [base_object_name] from sys.synonyms where name = 'geography'), @geography_column) IS NULL
		BEGIN
			RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
		END
		-- if it does exist then continue execution
		ELSE
		BEGIN
			SET NOCOUNT ON;

			-- if all input parameters are valid execute the stored procedure
			-- build dynamic SQL string
			-- note the use of nvarchar(max) throughout to avoid implicit conversion to varchar(8000)
			DECLARE @sql nvarchar(max) = '
			SELECT
				' + CONVERT(nvarchar(max), @scenario_id) + ' AS [scenario_id]
				,CASE	WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 0
						THEN ''All Residents''
						WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 1
						THEN ''Workers Only''
						ELSE NULL END AS [population]
				,CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
						THEN ''Activity Assigned to Home Location''
						WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
						THEN ''Activity Assigned to Workplace Location''
						ELSE NULL END AS [activity_location]
				,[persons].' + @geography_column + '
				,[persons].[persons]
				,ROUND(ISNULL([trips].[trips], 0), 2) AS [trips]
				,ROUND(ISNULL([trips].[trips], 0) /
					NULLIF([persons].[persons], 0), 2) AS [trips_per_capita]
				,ROUND(ISNULL([trips].[vmt], 0), 2) AS [vmt]
				,ROUND(ISNULL([trips].[vmt], 0) /
					NULLIF([persons].[persons], 0), 2) AS [vmt_per_capita]
			FROM ( -- get total population within assigned activity location
				SELECT DISTINCT -- distinct here when only total is wanted
				-- avoids duplicate Total column caused by ROLLUP
					ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
								THEN [geography_household_location].household_location_' + @geography_column + '
								WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
								THEN  [geography_work_location].work_location_' + @geography_column + '
								ELSE NULL
								END, ''Total'') AS ' + @geography_column + '
					,COUNT([person_id]) AS [persons]
				FROM
					[dimension].[person]
				INNER JOIN
					[dimension].[household]
				ON
					[person].[scenario_id] = [household].[scenario_id]
					AND [person].[household_id] = [household].[household_id]
				INNER JOIN
					[dimension].[geography_household_location]
				ON
					[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
				INNER JOIN
					[dimension].[geography_work_location]
				ON
					[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
				WHERE
					[person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
					AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
					AND [person].[person_id] > 0  -- remove Not Applicable records
					-- exclude non-workers if worker filter is selected
					AND (' + CONVERT(nvarchar(max), @workers) + ' = 0
						 OR (' + CONVERT(nvarchar(max), @workers) + ' = 1
							 AND [person].[work_segment] != ''Not Applicable''))
				GROUP BY
					CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
							THEN [geography_household_location].household_location_' + @geography_column + '
							WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
							THEN  [geography_work_location].work_location_' + @geography_column + '
							ELSE NULL END
				WITH ROLLUP) AS [persons]
			LEFT OUTER JOIN ( -- get trips and vmt for each person and assign to activity location
				-- left join keeps zones with residents/employees even if 0 trips/vmt
				SELECT DISTINCT -- distinct here for case when only total is wanted
				-- avoids duplicate Total column caused by ROLLUP
					ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
								THEN [geography_household_location].household_location_' + @geography_column + '
								WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
								THEN  [geography_work_location].work_location_' + @geography_column + '
								ELSE NULL
								END, ''Total'') AS ' + @geography_column + '
					,SUM([person_trip].[weight_trip]) AS [trips]
					,SUM([person_trip].[weight_trip] * [person_trip].[distance_drive]) AS [vmt]
				FROM
					[fact].[person_trip]
				INNER JOIN
					[dimension].[model_trip]
				ON
					[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
				INNER JOIN
					[dimension].[tour]
				ON
					[person_trip].[scenario_id] = [tour].[scenario_id]
					AND [person_trip].[tour_id] = [tour].[tour_id]
				INNER JOIN
					[dimension].[purpose_tour]
				ON
					[tour].[purpose_tour_id] = [purpose_tour].[purpose_tour_id]
				INNER JOIN
					[dimension].[household]
				ON
					[person_trip].[scenario_id] = [household].[scenario_id]
					AND [person_trip].[household_id] = [household].[household_id]
				INNER JOIN
					[dimension].[person]
				ON
					[person_trip].[scenario_id] = [person].[scenario_id]
					AND [person_trip].[person_id] = [person].[person_id]
				INNER JOIN
					[dimension].[geography_household_location]
				ON
					[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
				INNER JOIN
					[dimension].[geography_work_location]
				ON
					[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
				WHERE
					[person_trip].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
					AND [person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
					AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
					-- only resident models use synthetic population
					AND [model_trip].[model_trip_description] IN (''Individual'',
																  ''Internal-External'',
																  ''Joint'')
					-- exclude non-workers if worker filter is selected
					-- only select work tours if worker filter is selected
					AND (' + CONVERT(nvarchar(max), @workers) + ' = 0
						 OR (' + CONVERT(nvarchar(max), @workers) + ' = 1
							 AND [person].[work_segment] != ''Not Applicable''
							 AND [purpose_tour].[purpose_tour_description] = ''Work''))
				GROUP BY
					CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
							THEN [geography_household_location].household_location_' + @geography_column + '
							WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
							THEN  [geography_work_location].work_location_' + @geography_column + '
							ELSE NULL END
				WITH ROLLUP) AS [trips]
			ON
				[persons].' + @geography_column + ' = [trips].' + @geography_column + '
			ORDER BY -- keep sort order of alphabetical with Total at bottom
				CASE WHEN [persons].' + @geography_column + ' = ''Total'' THEN ''ZZ''
				ELSE [persons].' + @geography_column + ' END ASC
				OPTION(MAXDOP 1)'


			-- execute dynamic SQL string
			EXECUTE (@sql)
		END
	END
END
GO

-- add metadata for [rp_2021].[sp_resident_vmt]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_resident_vmt', 'MS_Description', 'trips and vehicle miles travelled by residents and/or resident workers on work tours assigned to their home or workplace location'
GO




-- create stored procedure for sb375 auto ownership --------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_auto_ownership]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_auto_ownership]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 average household auto ownership.

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Auto Ownership'

    -- insert average household auto ownership into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Auto Ownership' AS [measure]
        ,'Average Household Auto Ownership' AS [metric]
        ,1.0 * SUM([autos]) / SUM([household_sample_weight]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [dimension].[household]
    WHERE
        [scenario_id] = @scenario_id
        AND [household_id] > 0  -- remove Not Applicable records
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
        AND [measure] = 'SB375 - Auto Ownership';
GO

-- add metadata for [rp_2021].[sp_sb375_auto_ownership]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_auto_ownership', 'MS_Description', 'sb375 average household auto ownership'
GO




-- create stored procedure for sb375 average headways by transit tier peak and off peak periods ----
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_avg_headways_tier]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_avg_headways_tier]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS
/**
summary:   >
    Average headways by transit tier and peak and off peak period. The average
	is computed using the harmonic mean excluding records where headways = 0.
**/
BEGIN
	SELECT
		@scenario_id AS [scenario_id]
		,CASE WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
				OR [mode_transit_route_description] = 'Commuter Rail'
			  THEN 'Tier 1'
			  WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
				AND [mode_transit_route_description] = 'Light Rail'
			  THEN 'Tier 2'
			  WHEN [mode_transit_route_description] IN ('Freeway Rapid', 'Arterial Rapid')
			  THEN 'Tier 3'
			  ELSE 'Tier 4' END AS [tier]
		,( SUM(CASE WHEN [am_headway] > 0 THEN 1 ELSE 0 END) + SUM(CASE WHEN [pm_headway] > 0 THEN 1 ELSE 0 END) ) /
		   ( SUM(CASE WHEN [am_headway] > 0 THEN 1/[am_headway] ELSE 0 END) + SUM(CASE WHEN [pm_headway] > 0 THEN 1/[pm_headway] ELSE 0 END) ) [avg_peak_headway]
		,SUM(CASE WHEN [op_headway] > 0 THEN 1 ELSE 0 END) / SUM(CASE WHEN [op_headway] > 0 THEN 1/[op_headway] ELSE 0 END) AS [avg_offpeak_headway]
	FROM
		[dimension].[transit_route]
	INNER JOIN
		[dimension].[mode_transit_route]
	ON
		[transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
	WHERE
		[transit_route].[scenario_id] = @scenario_id
	GROUP BY
		CASE WHEN [transit_route].[config] / 1000 IN (581, 582, 583)
			   OR [mode_transit_route_description] = 'Commuter Rail'
			 THEN 'Tier 1'
			 WHEN [transit_route].[config] / 1000 NOT IN (581, 582, 583)
			   AND [mode_transit_route_description] = 'Light Rail'
			 THEN 'Tier 2'
			 WHEN [mode_transit_route_description] IN ('Freeway Rapid', 'Arterial Rapid')
			 THEN 'Tier 3'
			 ELSE 'Tier 4' END
END
GO

-- add metadata for [rp_2021].[sp_sb375_avg_headways_tier]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_avg_headways_tier', 'MS_Description', 'sb375 average headways by trainsit tier and peak/off-peak period'
GO




-- create stored procedure for sb375 housing structures ----------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_housing_structures]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_housing_structures]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 total housing structures, single-family housing structures,
    multi-family housing structures, the percentage of total housing structures
    that are single-family, and the percentage of total housing structures that
    are mult-family. Also includes total households.

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Housing Structures'

    -- insert total housing structures into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Total Housing Structures' AS [metric]
        ,SUM([hs]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert total single-family housing structures into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Total Single-Family Housing Structures' AS [metric]
        ,SUM([hs_sf]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert total multi-family housing structures into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Total Multi-Family Housing Structures' AS [metric]
        ,SUM([hs_mf]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert share of single-family housing structures into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Share of Single-Family Housing Structures' AS [metric]
        ,1.0 * SUM([hs_sf]) / SUM([hs]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert share of multi-family housing structures into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Share of Multi-Family Housing Structures' AS [metric]
        ,1.0 * SUM([hs_mf]) / SUM([hs]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert total households into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Housing Structures' AS [measure]
        ,'Total Households' AS [metric]
        ,SUM([hh]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id
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
        AND [measure] = 'SB375 - Housing Structures';
GO

-- add metadata for [rp_2021].[sp_sb375_housing_structures]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_housing_structures', 'MS_Description', 'sb375 housing structures'
GO




-- create stored procedure for sb375 jobs ------------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_jobs]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_jobs]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 total jobs in the San Diego region.

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Jobs'

    -- insert total jobs into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Jobs' AS [measure]
        ,'Total Jobs' AS [metric]
        ,SUM([emp_total]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id
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
        AND [measure] = 'SB375 - Jobs';
GO

-- add metadata for [rp_2021].[sp_sb375_jobs]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_jobs', 'MS_Description', 'sb375 total jobs'
GO




-- create stored procedure for sb375 median income ---------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_median_income]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_median_income]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 Median Household Income for a given ABM scenario.

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Median Household Income'

    -- insert median household income into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT DISTINCT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Median Household Income' AS [measure]
        ,'Median Household Income' AS [metric]
        ,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [household_income]) OVER () AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [dimension].[household]
    WHERE
        [scenario_id] = @scenario_id
        AND [household_id] > 0  -- remove Not Applicable record
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
        AND [measure] = 'SB375 - Median Household Income';
GO

-- add metadata for [rp_2021].[sp_sb375_median_income]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_median_income', 'MS_Description', 'sb375 median household income'
GO




-- create stored procedure for sb375 mode-based measures ---------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_mode_measures]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_mode_measures]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@measure nvarchar(15),  -- measure of interest to calculate
    @low_income bit = 1,  -- restrict to members of low income households only
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
     Calculate a person trip based measure for ABM resident sub-models by
     by ABM mode. The stored procedure allows the calculation of the
     person trip based travel distance, mode share, travel time, or count
     of person trips. Optionally, can restrict measures to members of low
     income households only.

revisions:
    - author: None
      modification: None
      date: None
**/
SET NOCOUNT ON

-- check input parameter
IF (@measure NOT IN ('distance', 'share', 'time', 'person trips') OR @measure IS NULL)
BEGIN
    RAISERROR('Invalid parameter: @measure must be one of (''distance'', ''share'', ''time'', ''person trips'')', 18, 0)
    RETURN
END

-- create measure name
DECLARE @measure_name nvarchar(100) =
    CASE WHEN @measure = 'distance' THEN 'SB375 - Average Trip Length by Mode'
         WHEN @measure = 'share' THEN 'SB375 - Mode Share'
         WHEN @measure = 'time' THEN 'SB375 - Average Trip Time by Mode'
         WHEN @measure = 'person trips' THEN 'SB375 - Person Trips by Mode'
         ELSE NULL END

IF (@low_income = 1) SET @measure_name = CONCAT(@measure_name, ' for Low Income Residents')

-- if update switch is selected then run the performance measure and replace
-- the value of the result set in the [rp_2021].[results] table
IF (@update = 1)
BEGIN
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = @measure_name

    -- insert mode metric into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
        @scenario_id AS [scenario_id]
        ,@measure_name AS [measure]
        ,ISNULL([modes].[mode], 'error') AS [metric]
        ,CASE   WHEN @measure IN ('distance', 'time') THEN [metric] / [weight_person_trip]
                WHEN @measure = 'person trips' THEN [weight_person_trip]
                WHEN @measure = 'share' THEN [weight_person_trip] / (SUM([weight_person_trip]) OVER() / 2)
                ELSE NULL END AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM (
        SELECT
            ISNULL(CASE WHEN [mode_trip].[mode_trip_description] IN ('Drive Alone',
                                                                     'Shared Ride 2',
                                                                     'Shared Ride 3+',
                                                                     'Bike',
                                                                     'Walk')
                        THEN [mode_trip].[mode_trip_description]
                        WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus',
                                                                     'Kiss and Ride to Transit - Local Bus and Premium Transit',
                                                                     'Kiss and Ride to Transit - Premium Transit',
                                                                     'Park and Ride to Transit - Local Bus',
                                                                     'Park and Ride to Transit - Local Bus and Premium Transit',
                                                                     'Park and Ride to Transit - Premium Transit',
                                                                     'TNC to Transit - Local Bus',
                                                                     'TNC to Transit - Local Bus and Premium Transit',
                                                                     'TNC to Transit - Premium Transit')
                        THEN 'Drive to Transit'
                        WHEN [mode_trip].[mode_trip_description] IN ('Walk to Transit - Local Bus',
                                                                     'Walk to Transit - Local Bus and Premium Transit',
                                                                     'Walk to Transit - Premium Transit')
                        THEN 'Walk to Transit'
                        ELSE 'Other' END, 'All Modes') AS [mode]
            ,SUM([person_trip].[weight_person_trip]) AS [weight_person_trip]
            ,CASE   WHEN @measure IN ('person trips', 'share') THEN 0  -- only weight is used if trips or share is selected
                    WHEN @measure = 'distance' THEN SUM([person_trip].[weight_person_trip] * [person_trip].[distance_total])
                    WHEN @measure = 'time' THEN SUM([person_trip].[weight_person_trip] * [person_trip].[time_total])
                    ELSE NULL END AS [metric]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[model_trip]
        ON
            [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
        INNER JOIN
            [dimension].[mode_trip]
        ON
            [person_trip].[mode_trip_id]  = [mode_trip].[mode_trip_id]
        INNER JOIN
            [dimension].[household]
        ON
            [person_trip].[scenario_id] = [household].[scenario_id]
            AND [person_trip].[household_id] = [household].[household_id]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [household].[scenario_id] = @scenario_id
            AND (@low_income = 0 OR (@low_income = 1 AND [household].[poverty] < 2))  -- restrict to low income populaton if indicated
            AND [model_trip].[model_trip_aggregate_description] = 'Resident Models'  -- Resident Models only
        GROUP BY
            CASE   WHEN [mode_trip].[mode_trip_description] IN ('Drive Alone',
                                                                'Shared Ride 2',
                                                                'Shared Ride 3+',
                                                                'Bike',
                                                                'Walk')
                    THEN [mode_trip].[mode_trip_description]
                    WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus',
                                                                 'Kiss and Ride to Transit - Local Bus and Premium Transit',
                                                                 'Kiss and Ride to Transit - Premium Transit',
                                                                 'Park and Ride to Transit - Local Bus',
                                                                 'Park and Ride to Transit - Local Bus and Premium Transit',
                                                                 'Park and Ride to Transit - Premium Transit',
                                                                 'TNC to Transit - Local Bus',
                                                                 'TNC to Transit - Local Bus and Premium Transit',
                                                                 'TNC to Transit - Premium Transit')
                    THEN 'Drive to Transit'
                    WHEN [mode_trip].[mode_trip_description] IN ('Walk to Transit - Local Bus',
                                                                 'Walk to Transit - Local Bus and Premium Transit',
                                                                 'Walk to Transit - Premium Transit')
                    THEN 'Walk to Transit'
                    ELSE 'Other' END
                    WITH ROLLUP) AS [trips]
    FULL OUTER JOIN (
        -- create table containing all combinations of models and modes of interest
        -- ensures all combinations are represented if not present the scenario
        SELECT
            [mode]
        FROM (
            VALUES
                ('Drive Alone'),
                ('Shared Ride 2'),
                ('Shared Ride 3+'),
                ('Drive to Transit'),
                ('Walk to Transit'),
                ('Bike'),
                ('Walk'),
                ('Other'),
                ('All Modes')) AS [modes] ([mode]) ) AS [modes]
    ON
        [trips].[mode] = [modes].[mode]
    OPTION( MAXDOP 1 )
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
        AND [measure] = @measure_name;
GO

-- add metadata for [rp_2021].[sp_sb375_mode_measures]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_mode_measures', 'MS_Description', 'sb375 mode-based measures'
GO




-- create stored procedure for sb375 population ------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_population]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_population]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 total population (including institutionalized group quarters and
    modeled population (not including institutionalized group quarters).

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Population'

    -- insert total population into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Population' AS [measure]
        ,'Total Population' AS [metric]
        ,SUM([pop]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[mgra_based_input]
    WHERE
        [scenario_id] = @scenario_id

    -- insert total population into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Population' AS [measure]
        ,'Modeled Population' AS [metric]
        ,COUNT([person_id]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [dimension].[person]
    WHERE
        [scenario_id] = @scenario_id
        AND [person_id] > 0  -- remove Not Applicable record
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
        AND [measure] = 'SB375 - Population';
GO

-- add metadata for [rp_2021].[sp_sb375_population]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_population', 'MS_Description', 'sb375 total population measures'
GO




-- create stored procedure for sb375 seat utilization ------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_seat_utilization]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_seat_utilization]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 Seat Utilization for a given ABM scenario. Seat Utilization is
    defined as total passenger miles divided by total seat miles.

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Seat Utilization'

    -- sum of transit flow multiplied by length of segment to get passenger miles
    DECLARE @passenger_miles float = (
        SELECT
	        SUM([transit_flow] * ([to_mp] - [from_mp])) AS [passenger_miles]
        FROM
	        [fact].[transit_flow]
        INNER JOIN
	        [dimension].[time]
        ON
	        [transit_flow].[time_id] = [time].[time_id]
        INNER JOIN
            [dimension].[transit_route]
        ON
            [transit_flow].[scenario_id] = [transit_route].[scenario_id]
	        AND [transit_flow].[transit_route_id] = [transit_route].[transit_route_id]

        WHERE
	        [transit_flow].[scenario_id] = @scenario_id
            AND [transit_route].[scenario_id] = @scenario_id
	        AND [time].[abm_5_tod] BETWEEN 2 AND 4  -- restricted to day time
    )

    -- each mode on each route has a specific seat capacity used in seat miles
    -- each route number has a specific set of headways used in seat miles
    --seat capacity by route type-------------
    --Heavy Rail 130/car (5 car trains)
    --Trolley 64/car (3 car trains)
    --SPRINTER 136/car (2 car trains)
    --Circulator 29/vehicle        -> mode 10 San Marcos Shuttle, Super loop
    --Bus 37/vehicle               -> mode 7, 9, 10 & streetcar (mode 5, route 551-559 + 565)
    --Bus 53/vehicle               -> mode 8 limited express bus (810, 850, 860, 880 in year 2012, no longer exist in future years)
    --Bus 53/vehicle               -> mode 8 limited express bus (810, 850, 860, 880 in year 2012, no longer exist in future years)
    --Bus Rapid Transit 53/vehicle -> mode 6
    DECLARE @seat_miles float = (
        SELECT
            SUM( [tt_route_miles].[route_miles] *
                 ( ISNULL(180 / NULLIF([am_headway], 0), 0) + ISNULL(390 / NULLIF([op_headway], 0) ,0) + ISNULL(210 / NULLIF([pm_headway], 0), 0) ) *
                 CASE WHEN [mode_description] = 'Commuter Rail' THEN 130 * 5  -- coaster and heavy rail
		              WHEN [mode_description] = 'Light Rail' AND [config]/1000 > 500 AND [config]/1000 < 551  THEN 64 * 3  -- trolley
		              WHEN [mode_description] = 'Light Rail' AND [config]/1000 = 399 THEN 136 * 2  -- sprinter
		              WHEN [mode_description] = 'Light Rail' AND (([config] / 1000 >= 551 AND [config] / 1000 <= 559) OR [config] / 1000 = 565) THEN 37  -- streetcar
		              WHEN [mode_description] = 'Light Rail' AND [config]/1000 > 559 AND [config]/1000 < 565  THEN 64 * 3  -- trolley
		              WHEN [mode_description] = 'Light Rail' AND [config]/1000 = 588 THEN 136 * 2  -- sprinter
		              WHEN [mode_description] in ('Freeway Rapid',
			     						          'Arterial Rapid') THEN 53  -- rapid
		              WHEN [mode_description] IN ('Premium Express Bus',
				  					              'Express Bus',
									              'Local Bus') THEN 37  -- bus
		              ELSE 0
		              END ) AS [seat_miles]
        FROM
	        [dimension].[transit_route]
        INNER JOIN
	        [dimension].[mode]
        ON
	        [transit_route].[mode_transit_route_id] = [mode].[mode_id]
        INNER JOIN (  -- get total route miles
	        SELECT
		        [scenario_id]
		        ,[transit_route_id]
		        ,MAX([to_mp]) AS [route_miles]
	        FROM
		        [fact].[transit_flow]
	        WHERE
		        [scenario_id] = @scenario_id
	        GROUP BY
		        [scenario_id]
		        ,[transit_route_id]
		        ) AS [tt_route_miles]
        ON
	        [transit_route].[scenario_id] = [tt_route_miles].[scenario_id]
	        AND [transit_route].[transit_route_id] = [tt_route_miles].[transit_route_id]
        WHERE
            [transit_route].[scenario_id] = @scenario_id
    )

    -- insert seat utilization into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
	    @scenario_id AS [scenario_id]
        ,'SB375 - Seat Utilization' AS [measure]
        ,'Seat Utilization' AS [metric]
        ,@passenger_miles / @seat_miles AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
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
        AND [measure] = 'SB375 - Seat Utilization';
GO

-- add metadata for [rp_2021].[sp_sb375_seat_utilization]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_seat_utilization', 'MS_Description', 'sb375 seat utilization'
GO




-- create stored procedure for sb375 travel time by trip purpose -------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_sb375_travel_time_purpose]
GO

CREATE PROCEDURE [rp_2021].[sp_sb375_travel_time_purpose]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [rp_2021].[results] table instead of
        -- grabbing the results from the [rp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [rp_2021].[results] table is updated with no output
AS

/**
summary:   >
    SB375 travel time by trip purpose for a given ABM scenario.

filters:   >
    [model_trip].[model_trip_aggregate_description] = 'Resident Models'
      San Deigo Resident Models only

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
    -- remove result for the given ABM scenario from the results table
    DELETE FROM
        [rp_2021].[results]
    WHERE
        [scenario_id] = @scenario_id
        AND [measure] = 'SB375 - Travel Time by Purpose'

    -- insert into results table
    INSERT INTO [rp_2021].[results] (
        [scenario_id]
        ,[measure]
        ,[metric]
        ,[value]
        ,[updated_by]
        ,[updated_date])
    SELECT
        @scenario_id AS [scenario_id]
        ,'SB375 - Travel Time by Purpose' AS [measure]
        ,ISNULL(CASE WHEN [purpose_trip_origin_description] = 'Home' AND [purpose_trip_destination_description] = 'Work'
                     THEN 'Outbound Work Trips'
                     ELSE 'Other Trips' END, 'All Trips') AS [metric]
        ,SUM([person_trip].[weight_person_trip] * [person_trip].[time_total]) / SUM([person_trip].[weight_person_trip]) AS [value]
        ,USER_NAME() AS [updated_by]
        ,SYSDATETIME() AS [updated_date]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[model_trip]
    ON
        [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
    INNER JOIN
        [dimension].[purpose_trip_origin]
    ON
        [person_trip].[purpose_trip_origin_id]  = [purpose_trip_origin].[purpose_trip_origin_id]
    INNER JOIN
        [dimension].[purpose_trip_destination]
    ON
        [person_trip].[purpose_trip_destination_id]  = [purpose_trip_destination].[purpose_trip_destination_id]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        AND [model_trip].[model_trip_aggregate_description] = 'Resident Models'  -- Resident Models only
    GROUP BY
        CASE WHEN [purpose_trip_origin_description] = 'Home' AND [purpose_trip_destination_description] = 'Work'
             THEN 'Outbound Work Trips'
             ELSE 'Other Trips' END
    WITH ROLLUP

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
        AND [measure] = 'SB375 - Travel Time by Purpose';
GO

-- add metadata for [rp_2021].[sp_sb375_travel_time_purpose]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_sb375_travel_time_purpose', 'MS_Description', 'sb375 travel time by trip purpose'
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
-- deny insert and update on [rp_2021].[results] so user can only
-- add new information via stored procedures, allow deletes
GRANT DELETE ON [rp_2021].[results] TO [rp_2021_user];
DENY INSERT ON [rp_2021].[results] TO [rp_2021_user];
DENY UPDATE ON [rp_2021].[results] TO [rp_2021_user];
