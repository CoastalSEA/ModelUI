classdef UseUI_template < ModelUI                            % << Edit to classname
%
%-------class help---------------------------------------------------------
% NAME
%   UseUI_template.m
% PURPOSE
%   Main GUI for a generic model interface, which implements the 
%   muiModelUI class to define main menus.
% SEE ALSO
%   Abstract class muiModelUI.m and tools provided in muitoolbox
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
% 
    properties
        vNumber = '1.0'
        vDate   = 'Jan 2021'
        modelName = 'UseUI_template'                         % << Edit to application name
        %Properties defined in muiModelUI that need to be defined in setGui
        % ModelInputs  %classes required by model: used in isValidModel check 
        % DataUItabs   %struct to define type of muiDataUI tabs for each use                         
    end
    
    methods (Static)
        function obj = UseUI_template                         % << Edit to classname
            %constructor function initialises GUI
            obj.vNumber = '1.0';           %overload ModelUI values
            obj.vDate   = 'Jan 2021';
            obj. modelName = 'UseUI_template';                % << Edit to application name
            obj = setMUI(obj);             
        end
    end
%% ------------------------------------------------------------------------
% Definition of GUI Settings
%--------------------------------------------------------------------------  
    methods (Access = protected)
        function obj = setMUI(obj)
            %initialise standard figure and menus    
            %classes required to run model             
            %format:                                         % << Edit to model and input parameters classnames 
            %obj.ModelInputs.<model classname> = {'Param_class1',Param_class2',etc}
            obj.ModelInputs.Model_template = {'ParamInput_template'};
            %tabs to include in DataUIs for plotting and statistical analysis
            %select which of the options are needed and delete the rest
            %Plot options: '2D','3D','4D','2DT','3DT','4DT'
            obj.DataUItabs.Plot = {'2D','3D','4D','2DT','3DT','4DT'};  
            %Statistics options: 'General','Timeseries','Taylor','Intervals'
            obj.DataUItabs.Stats = {'General','Timeseries','Taylor','Intervals'};  
            
            modelLogo = 'mui_logo.jpg';  %default splash figure - edit to alternative
            initialiseUI(obj,modelLogo); %initialise menus and tabs                  
        end    
        
%% ------------------------------------------------------------------------
% Definition of Menu Settings
%--------------------------------------------------------------------------
        %Use default settings
        
%% ------------------------------------------------------------------------
% Definition of Tab Settings
%--------------------------------------------------------------------------
        %Use default settings
        
 %%
        function props = setTabProperties(~)
            %define the tab and position to display class data tables
            %props format: {class name, tab tag name, position, ...
            %               column width, table title}
                                                             % << Edit input properties classnames 
            props = {...                                     % << Add additional inputs and adjust layout
                'ParamInput_template','Inputs',[0.95,0.48],{180,60},'Input parameters:'};
        end      
        
%% ------------------------------------------------------------------------
% Callback functions used by menus and tabs
%-------------------------------------------------------------------------- 
        %Use defaults except:
        %% Setup menu -----------------------------------------------------
        function setupMenuOptions(obj,src,~)
            %callback functions for data input
            switch src.Text
                case 'Input parameters'                      % << Edit to call Parameter Input class
                    ParamInput_template.setParamInput(obj);                             
                    tabsrc = findobj(obj.mUI.Tabs,'Tag','Inputs');
                    InputTabSummary(obj,tabsrc);
                case 'Imported Data'                         % << Edit to call Data Import class
                    
                case 'Model Constants'
                    obj.Constants = editProperties(obj.Constants);
            end
        end             
        %% Run menu -------------------------------------------------------
        function runMenuOptions(obj,src,~)
            %callback functions to run model
            switch src.Text                   
                case 'Run Model'                             % << Edit to call Model class
                    demoModel.runModel(obj); 
                case 'Derive Output'
                    obj.mUI.Manip = muiManipUI.getManipUI(obj);
            end            
        end                    
    end
end    
    
    
    
    
    
    
    
    
    
    