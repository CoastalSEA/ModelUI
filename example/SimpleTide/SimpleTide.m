classdef SimpleTide < ModelUI                           
%
%-------class help---------------------------------------------------------
% NAME
%   SimpleTide.m
% PURPOSE
%   Main GUI for a SimpleTide UI, which inherits ModelUI to define main menus.
% SEE ALSO
%   Abstract class ModelUI.m, muiModelUI.m and tools provided in muitoolbox
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
% 
    properties (Access = protected)                     
        %Properties defined in muiModelUI that need to be defined in setGui
        % ModelInputs  %classes required by model: used in isValidModel check 
        % DataUItabs   %struct to define type of muiDataUI tabs for each use                         
    end
    
    methods (Static)
        function obj = SimpleTide
            %constructor function initialises UI using ModelUI constructor            
        end
    end
%% ------------------------------------------------------------------------
% Definition of GUI Settings
%--------------------------------------------------------------------------  
    methods (Access = protected)
        function obj = setMUI(obj)
            %initialise standard figure and menus   
            modelLogo = 'ST_logo.jpg';   %splash figure  
            
            %classes required to run model, format:                                        
            %obj.ModelInputs.<model classname> = {'Param_class1',Param_class2',etc}
            obj.ModelInputs.STmodel = {'STparam'};
            
            %tabs to include in DataUIs for plotting and statistical analysis
            %select which of the options are needed
            %Plot options: '2D','3D','4D','2DT','3DT','4DT'
            obj.DataUItabs.Plot = {'2D','2DT'};  
            %Statistics options: 'General','Timeseries','Taylor','Intervals'
            obj.DataUItabs.Stats = {'General','Timeseries','Taylor'};
            
            %inherit from ModelUI constructor and overload some setup values
            obj.vNumber = '1.0';           
            obj.vDate   = 'Jan 2021';
            obj. modelName = 'SimpleTide';
      
            initialiseUI(obj,modelLogo); %initialise menus and tabs  
            %if required call setAdditionalMenus and setAdditionalTabs
            setAdditionalMenus(obj);
        end    
        
%% ------------------------------------------------------------------------
% Definition of Menu Settings
%--------------------------------------------------------------------------
        %Use default settings
        function setAdditionalMenus(obj)
            %remove the sub-menus assigned to Import Data and add new callback 
            menuname = 'Setup';
            hm = findSubMenu(obj,menuname,'Import Data');
            hm.MenuSelectedFcn=@obj.setupMenuOptions; %change menu call fcn
            delete(hm.Children);                      %delete sub-submenu
        end 
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
                'STparam','Inputs',[0.95,0.48],{180,60},'Input parameters:'};
        end      
        
%% ------------------------------------------------------------------------
% Callback functions used by menus and tabs
%-------------------------------------------------------------------------- 
        %Use defaults except:
        %% Setup menu -----------------------------------------------------
        function setupMenuOptions(obj,src,~)
            %callback functions for data input
            switch src.Text
                case 'Input parameters'                      
                    STparam.setInput(obj);                             
                    tabsrc = findobj(obj.mUI.Tabs,'Tag','Inputs');
                    InputTabSummary(obj,tabsrc);
                case 'Import Data'
                    STdata.loadData(obj.Cases);
                case 'Model Constants'
                    obj.Constants = setInput(obj.Constants);
            end
        end             
        %% Run menu -------------------------------------------------------
        function runMenuOptions(obj,src,~)
            %callback functions to run model
            switch src.Text                   
                case 'Run Model'                             % << Edit to call Model class
                    STmodel.runModel(obj); 
                case 'Derive Output'
                    obj.mUI.Manip = muiManipUI.getManipUI(obj);
            end            
        end                    
    end
end    
    
    
    
    
    
    
    
    
    
    