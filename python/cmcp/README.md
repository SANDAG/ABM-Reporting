# README: How To Setup and Run CMCP Performance Measures (PM) 

### Author: Cundo Arellano

### Revisions by Michael Wehrmeyer for GitHub Version Control (Nov. 29, 2022)
<br/>

## File Locations 

The CMCP PM tool file path structure should be the same for different projects. An example Project Path would be **T:\projects\sr14\OWP\CMCP\i805_purple_line** 

* CMCP PM Python Scripts: 
***[Project Path]*\analysis\ABM-Reporting-master\python\cmcp** 

* CMCP Input Files: 
***[Project Path]*\analysis\ABM-Reporting-master\resources\cmcp\input**

* CMCP Report Outputs: 
***[Project Path]*\analysis\ABM-Reporting-master**

* Python Environment File: 
***[Project Path]*\analysis\ABM-Reporting-master\environment.yml** 

<br/>

## Initial Setup 
In your Anaconda3 command prompt, navigate to your project's analsysis directory (eg,**T:\projects\sr14\OWP\CMCP\i805_purple_line\analysis**). Then, clone the repository by running:
```
git clone https://github.com/SANDAG/ABM-Reporting.git
```

If it’s your first time running CMCP PMs, you should read in an environment YAML file (which in turn creates/clones an Anaconda environment) into your instance of Anaconda. By reading in the environment file, it ensures you will be running the Python script with all the relevant libraries required to run the Python scripts.  

To create the environment, open “Anaconda Prompt (Anaconda3)” and type in the following command: 
```
conda env create -f "[Project Path]\analysis\ABM-Reporting-master\python\cmcp\environment.yml" 
```
If no errors appear, you can check if the environment was created/cloned successfully by typing in the following command: 
```
conda env list 
```
A list should appear with all your Anaconda virtual environments including the default “base” and newly created “cmcp” 

<br/>

## Configuring Database Connections
Database specifications are obscured from the public GitHub, so alterations to the database specifications file are required for the CMCP Python script from GitHub. The yaml file is here: ***[Project Path]*\analysis\ABM-Reporting-master\resources\cmcp\database-specs.yaml**, and the database information that needs to be added should be structured like:
```yaml
server1:
  name: "INSERT_server_name1"
  db1_1: "INSERT_database_name1"
server2:
  name: "INSERT_server_name2"
  db2_1: "INSERT_database_name2"
```

<br/>

## Running CMCP PMs Python Scripts 

Prior to running the CMCP PM Python scripts, there are 2 processes that need to be run: 

1. Ensure the GIS PM script has been run. The GIS PM script generates results that are stored in the GIS database. Typically, GIS staff run the GIS PM script. A way to ensure the GIS PMs have been run is the following: 

    i. Navigate to SQL Server Management Studio (SSMS) 

    ii. Connect to [SANDAG Database]

    iii. Run the following SQL query: 
        
        SELECT * 
        FROM [CMCP].[dbo].[cmcp_pm_results] 
        WHERE scenario_id = [your_scenario_id] 
        

    iv. Verify the query produces results that are relevant to your scenario (there should be ~44 results per scenario id) 

2. Run the walk transit shed process to generate the walkMgraWithin30Min_MD.csv and walkMgraWithin45Min_AM.csv files. For instructions on how to run this process, refer to the following document on SharePoint: Performance Measure Procedures.docx 

To run the CMCP Python scripts, open “Anaconda Prompt (Anaconda3)” and activate the cmcp environment by typing the following command: 
```
conda activate cmcp 
```
If the environment was successfully activated, the next line in your Anaconda Prompt should begin with “(cmcp)” and not “(base)” or any other environment names. 

Navigate to the CMCP PM Python Scripts directory and copy the path of the main.py script (Shift + Right-Click > Copy as Path). In the Anaconda Prompt, type in the following command: 
```
python path_to_main.py 
```
Click Enter and the script will run. Run time will depend on how many CMCPs and scenarios have been selected. 

<br/>

## Making Edits to CMCP PM Python Scripts 

The following edits should be made with caution and with relatively sound knowledge of Python syntax 

This section will describe typical edits that can be done to the CMCP PM Python Scripts to modify things such as what CMCPs and/or scenarios should be run. 

### Scenarios 

If you want to specify which scenario will be run, open the settings.py script (under CMCP PM Python Scripts directory) and navigate to lines 10 through 22 (these line numbers are subject to change) where scenarios are listed. If you want to omit any of the listed scenarios, add a pound/hashtag (#) symbol just before the number, as shown below.
```python
scenarios: {
  458: "2016",
  461: "2025nb",
  #469: "2035nb",
  450: ""2050nb"
}
```

Running the script with the above edit would run all scenarios except for scenarios 469 and 459.  

### CMCP Corridors 

If you want to specify which CMCP corridors will be run, open the settings.py script and navigate to lines 43 through 50 (these line numbers are subject to change). If you want to omit any of the listed CMCP corridors, add a pound/hashtag (#) symbol just before the corridor name, as shown below. 
```python
 #list of CMCP corridors
 cmcp_corridor = [
  # "Coast, Canyons, and Trails",
  "North County",
  #"San Vicente",
  #"South Bay to Sorrento",
  "Region"
  ]
```

Running the script with the above edit would only generate PMs for North County and Region. This would mean there would only be 2 PM summary Excel spreadsheets generated. 
