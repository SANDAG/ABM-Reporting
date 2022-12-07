# README - Scenario Model Comparison (Sensitivity) Tool

1. Open your Anaconda Prompt
2. Change directory to the project folder
3. Create the Python environment by typing
	"conda env create -f environment.yml"
4. Activate the Python environment by typing
	"conda activate sensitivity"
5. Add the scenario project folder path to the file: 
	"..\..\resources\sensitivity\Scenario Metadata.csv" (if not already in the file)
	Note: each row represents one scenario project folder. 
6. Run the Python process by typing
	"python main.py"
7. The process prompts you to specify scenario project folders
  separated by pipe (|) characters. You can choose to run the process
  for a single scenario with more detail or for up to twenty scenarios.
	(note: no spaces between folder names just a pipe.)
8. When the process finishes a new Excel workbook is written to the
  project folder. The process will overwrite any existing workbooks that
  have already been created in the project folder with the same naming
  convention.
