%% Menu Options
% Summary of the options available for each drop down menu.

%% File
% * *New*: clears any existing model (prompting to save if not already saved) and a popup dialog box prompts for Project name and Date (default is current date). 
% * *Open*: existing Asmita models are saved as *.mat files. User selects a model from dialog box.
% * *Save*: save a file that has already been saved.
% * *Save as*: save a file with a new or different name.
% * *Exit*: exit the program. The close window button has the same effect.

%% Tools
% * *Refresh*: updates Scenarios tab.
% * *Clear all > Model*: deletes the current model.
% * *Clear all > Figures*: deletes all results plot figures (useful if a large number of plots have been produced).
% * *Clear all > Scenarios*: deletes all scenarios listed on the Scenarios tab but does not affect the model setup.

%% Project
% * *Project Info*: edit the Project name and Date
% * *Scenarios > Edit Description*: user selects a scenario to edit scenario description.
% * *Scenarios > Edit Data Set*: initialises the Edit Data UI for editing data sets.
% * *Scenarios > Save*: user selects a scenario to be saved from a list box of scenarios and the is then prompted to name the file. The data are written to an Excel spreadsheet. 
% * *Scenarios > Delete*: user selects a scenario to be deleted from a list box of scenarios and results are then deleted (model setup is not changed).
% * *Scenarios > Reload*: user selects a scenario to reload as the current parameter settings.
% * *Scenarios > View settings*: user selects a scenario to display a table listing the parameters used for the selected scenario. 
% * *Export/Import > Export*: user selects a scenario to export as a mat file.
% * *Export/Import > Import*: user selects an exported scenario (mat file) to be loaded.

%% Setup
% * *Input Data*: dialogue to define model parameters.
% * *Imported Data*: dialogue to import data from a file.
% * *Model Constants*: a number of constants are used in the model. Generally, the default values are appropriate but these can be adjusted and saved with the project if required.

%% Run
% * *Run Model*: runs model, prompts for scenarios description which is added to the listing on the Scenarios tab.
% * *Derive Output*: initialises the Derive Output UI to select and define manipulations of the data or call external functions and load the result as new data set.

%% Analysis
% * *Plot Menu*: initialises the Plot UI to select variables and produce various types of plot. The user selects the Scenario, Model element (or All elements), the Variable to used and the Scaling option from a series of drop down lists, 
% * *Statistics*: initialiss the Statistics UI to select data and run a range of standard statistical methods.

%% See Also
% The <matlab:open_manual manual> provides further details of setup and 
% configuration of the model.