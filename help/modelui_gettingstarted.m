%% ModelUI - Getting Started
% The steps below outline how to setup a bespoke application of ModelUI
% by modifying the default UI. How to develop more complex UIs is explained
% more in the <matlab:open_manual ModelUI manual>.
%%
% # Decide on what components are needed. These might include: <br>
%   o UI - the main interface for the application  <br>
%   o Data import - load different types of data <br>
%   o Properties input - define properties needed for application <br>
%   o Model(s) - the models to be run by the application.  <br>
% # Give names to each component, e.g.: <br>
%   ModelUI, demoData, demoProps, demoModel
% # Copy the class templates for the components from here to your working folder
% # Create classes for each component by editing the templates as set out for each template below.

%% Main UI
% Text
%
% <include>../utils/UseUI_template.m</include>
%
%% Data import
% text
%
% <include>../utils/DataImport_template.m</include>
%
%% Data properties 
% For each set of _input properties_, define a classname and edit the
% template where indicated using the classname. Define the _input
% properties_ required in the properties block and provide a description 
% (used in the input UI) for each property as a cell array of strings in 
% the PropertyLabels property.
%
% <include>../utils/PropsInput_template.m</include>
%
%% Models
% text
%
% <include>../utils/Model_template</include>
%
	





