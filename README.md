# ABM-Reporting

The ABM-Reporting repository houses all general reporting procedures for the Activity-Based model that do not require or have not yet been migrated to their own self-contained repositories. For example, this repository contains procedures to output datasets for the 2020 Federal Regional Transportation Plan but does not contain anything related to the [Benefit-Cost Tool](https://github.com/SANDAG/bca) as that exists in its own repository.

This repository's release branches are tagged with the [Activity-Based Model Software](https://github.com/SANDAG/ABM) version it relies on and is compatible with.


## Contents

The repository houses the build script for the general ABM reporting database and the objects that populate it. In addition there are Python procedures, environments, and Excel templates used in conjunction with, and in addition to, the ABM reporting database. All objects are organized by type and then by project.


### ABM General Reporting Database

The build scripts to create the general reporting database are found in **sql\db** and a .bat file that controls the creation process is located at **resources\db**. Once created, the general reporting database provides the space to hold SQL objects created in the ABM-Reporting repository.


### emfac

All SQL objects necessary to create inputs from the Activity-Based Model to EMFAC are included at **sql\emfac** and built to the ABM general reporting database.


### fed_rtp_20

All Excel, Python, and SQL objects necessary to output reporting metrics for the Federal 2020 Regional Transportation Plan are included in this repository. These include SQL objects at **sql\fed_rtp_20** that are built to the ABM general reporting database, Python scripts and the environment necessary to run them at **python\fed_rtp_20**, and an Excel template populated by a Python script at **resources\fed_rtp_20**. 


### report

General ABM reporting metrics that do not necessarily fall within a single project are kept under the report project/schema. Currently this only includes SQL objects found in **sql\report** and built to the ABM general reporting database.
