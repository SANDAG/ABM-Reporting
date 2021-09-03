# ABM-Reporting

The ABM-Reporting repository houses all general reporting procedures for the Activity-Based model that do not require or have not yet been migrated to their own self-contained repositories. For example, this repository contains procedures to output datasets for the 2020 Federal Regional Transportation Plan but does not contain anything related to the [Benefit-Cost Tool](https://github.com/SANDAG/bca) as that exists in its own repository.

This repository's release branches are tagged with the [Activity-Based Model Software](https://github.com/SANDAG/ABM) version they rely on and are compatible with. The main branch is the most recent development branch. See the [Trunk-Based Development](https://trunkbaseddevelopment.com/) site for more information regarding the branching strategy employed in this repository.


## Contents

The repository houses the build script for the general ABM reporting database and the objects that populate it. In addition there are Python procedures, environments, and Excel templates used in conjunction with, and in addition to, the ABM reporting database. All objects are organized by type and then by project.


### ABM General Reporting Database

The build scripts to create the general reporting database are found in **sql\db** and a .bat file that controls the creation process is located at **resources\db**. Once created, the general reporting database provides the space to hold SQL objects created in the ABM-Reporting repository.


### emfac

All Python and SQL objects necessary to create inputs to EMFAC from the Activity-Based Model are included in this repository. These include SQL objects at **sql\emfac** that are built to the ABM general reporting database as well as Python scripts and the environment necessary to run them at **python\emfac**.


### mode_choice_report

A set of stored procedures and a PowerBI template file used to create the automated Service Bureau Mode Choice report.

### rp_2021

All Excel, Python, and SQL objects necessary to output reporting metrics for the 2021 Regional Transportation Plan are included in this repository. These include SQL objects at **sql\rp_2021** that are built to the ABM general reporting database, Python scripts and the environment necessary to run them at **python\rp_2021**, and an Excel template populated by a Python script at **resources\rp_2021\templates**. 


### sensitivity

All Excel, Python, and SQL objects necessary to output reporting metrics for sensitivity testing are included in this repository. These include SQL objects at **sql\sensitivity** that are built to the ABM general reporting database, Python scripts and the environment necessary to run them at **python\sensitivity**, and two Excel templates populated by a Python script at **resources\sensitivity\templates**. 


### report

General ABM reporting metrics that do not necessarily fall within a single project are kept under the report project/schema. Currently this only includes SQL objects found in **sql\report** and built to the ABM general reporting database.
