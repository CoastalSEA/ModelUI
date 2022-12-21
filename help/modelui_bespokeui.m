%% Using ModelUI to create bespoke UIs
% The steps below outline how to setup a bespoke application of ModelUI
% by modifying the default UI. How to develop more complex UIs is explained
% in the <matlab:mui_open_manual ModelUI manual>.

%% Implementation steps
% # Decide on what components are needed. These might include: <br>
%   o UI - the main interface for the application  <br>
%   o Data import - load different types of data <br>
%   o Input parameters - define any parameters needed for the application <br>
%   o Model(s) - initialise and call any models to be run by the application.  <br>
% # Give names to each component, e.g.: <br>
%   ModelUI, demoData, demoProps, demoModel
% # Copy the class templates for the components from here to your working folder
% # Create classes for each component by editing the templates as illustrated
%   for each template below.

%%
% Templates for the main components are provided in the muitemplates 
% folder, which can be found <matlab:mui_template_folder here>. The templates 
% provide the code for each component and the comments highlight where the 
% files need to be edited to adapt the templates to a different application. 
%%
% The  <matlab:doc('muitoolbox') muitoolbox> 
% _Getting Started_ documentation provides further details 
% of how to modify each of the templates.

%% See Also
% A full list of the <matlab:doc('muitemplates') Templates> which can be found in
% the templates folder <matlab:mui_template_folder here>.  <br>
% <matlab:doc('modelui_examples') Examples> of using the interface for
% different applications. The files for these examples can be found in
% the example folder <matlab:mui_example_folder here>.  <br>
% <matlab:doc('muitoolbox') muitoolbox> documentation for details of the
% _muiModelUI_ abstract interface class and the other UIs used in _ModelUI_. <br>
% <matlab:doc('dstoolbox') dstoolbox> documentation for details of 
% _dstable_ and _dsproperties_. <br>
% The demonstration UI provided in the <matlab:doc('modelui') ModelUI> App. 






