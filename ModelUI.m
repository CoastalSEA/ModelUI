classdef ModelUI < muiModelUI
%
%-------class help---------------------------------------------------------
% NAME
%   ModelUI.m
% PURPOSE
%   Main GUI for a generic model interface, which implements the 
%   muiModelUI class to define main menus.
% SEE ALSO
%   Abstract class muiModelUI.m and tools provided in muitoolbox
%
% Author: Ian Townend
% CoastalSEA (c)  December 2020
%--------------------------------------------------------------------------
%
    properties  (Access = protected)
        %implement properties defined as Abstract in muiModelUI
        vNumber = '2.0'
        vDate   = 'December 2020'
        modelName = 'ModelUI'
        %Properties defined in muiModelUI that need to be defined in setGui
        % ModelInputs  %classes required by model: used in isValidModel check 
        % DataUItabs   %struct to define type of muiDataUI tabs for each use 
    end
%%
    methods
        function obj = ModelUI
            %constructor function initialises GUI
            obj = setMUI(obj); %use setMUI so that classes that inherit
                               %ModelUI can overload the function
        end
    end
%% ------------------------------------------------------------------------
% Definition of GUI Settings
%--------------------------------------------------------------------------  
    methods (Access = protected)
        function obj = setMUI(obj)
            %initialise standard figure and menus 
            modelLogo = 'mui_logo.jpg';  %default splash figure - edit to alternative
            
            %classes required to run model,format:           
            %obj.ModelInputs.<model classname> = {'Param_class1',Param_class2',etc}
            obj.ModelInputs.VPmodel = {'VPparam'};

            %tabs to include in DataUIs for plotting and statistical analysis
            %select which of the options are needed and delete the rest
            obj.DataUItabs.Plot = {'2D','3D','4D','2DT','3DT','4DT'};   
            obj.DataUItabs.Stats = {'General','Timeseries','Taylor','Intervals'};             
            
            initialiseUI(obj,modelLogo);        %initialise menus and tabs                   
        end    
%% ------------------------------------------------------------------------
% Definition of Menu Settings
%--------------------------------------------------------------------------
        function menu = setMenus(obj)
            %define top level menu items and any submenus
            %MenuLabels can any text but should avoid these case-sensitive 
            %reserved words: "default", "remove", and "factory". If label 
            %is not a valid Matlab field name this the struct entry
            %is modified to a valid name (eg removes space if two words).
            %The 'gcbo:' Callback text triggers an additional level in the 
            %menu. Main menu labels are defined in sequential order and 
            %submenus in order following each brach to the lowest level 
            %before defining the next branch.         
            
            MenuLabels = {'File','Tools','Project','Setup','Run',...
                                                        'Analysis','Help'};
            menu = menuStruct(obj,MenuLabels);  %create empty menu struct
            %
            %% File menu --------------------------------------------------
            %list as per muiModelUI.fileMenuOptions
            menu.File.List = {'New','Open','Save','Save as','Exit'};
            menu.File.Callback = repmat({@obj.fileMenuOptions},[1,5]);
            
            %% Tools menu -------------------------------------------------
            %list as per muiModelUI.toolsMenuOptions
            menu.Tools(1).List = {'Refresh','Clear all'};
            menu.Tools(1).Callback = {@obj.refresh, 'gcbo;'};  
            
            % submenu for 'Clear all'
            menu.Tools(2).List = {'Model','Figures','Cases'};
            menu.Tools(2).Callback = repmat({@obj.toolsMenuOptions},[1,3]);

            %% Project menu -----------------------------------------------
            menu.Project(1).List = {'Project Info','Cases','Import/Export'};
            menu.Project(1).Callback = {@obj.editProjectInfo,'gcbo;','gcbo;'};
            
            %list as per muiModelUI.projectMenuOptions
            % submenu for Scenarios
            menu.Project(2).List = {'Edit Description','Edit Data Set',...
                                    'Save Data Set','Delete Case','Reload Case',...
                                    'View Case Settings'};                                               
            menu.Project(2).Callback = repmat({@obj.projectMenuOptions},[1,6]);
            
            % submenu for 'Import/Export'                                          
            menu.Project(3).List = {'Import Case','Export Case'};
            menu.Project(3).Callback = repmat({@obj.projectMenuOptions},[1,2]);
            
            %% Setup menu -------------------------------------------------
            menu.Setup(1).List = {'Import Data','Input parameters','Model Constants'};                                    
            menu.Setup(1).Callback = [{'gcbo;'},repmat({@obj.setupMenuOptions},[1,2])];
            
            % submenu for Import Data (if these are changed need to edit
            % loadMenuOptions to be match)
            menu.Setup(2).List = {'Load','Add','Delete','Quality Control'};
            menu.Setup(2).Callback = repmat({@obj.loadMenuOptions},[1,4]);
            
            %% Run menu ---------------------------------------------------
            menu.Run(1).List = {'Run Model','Derive Output'};
            menu.Run(1).Callback = repmat({@obj.runMenuOptions},[1,2]);
            
            %% Analysis menu --------------------------------------------------  
            menu.Analysis(1).List = {'Plots','Statistics'};
            menu.Analysis(1).Callback = repmat({@obj.analysisMenuOptions},[1,2]);
            
            %% Help menu --------------------------------------------------
            menu.Help(1).Callback = {@obj.Help}; %make model specific?
            
        end
%% ------------------------------------------------------------------------
% Definition of Tab Settings
%--------------------------------------------------------------------------
        function [tabs,subtabs] = setTabs(obj)
            %define main tabs and any subtabs required. struct field is 
            %used to set the uitab Tag (prefixed with sub for subtabs). 
            %Order of assignment to struct determines order of tabs in figure.
            %format for tabs: 
            %    tabs.<tagname> = {<tab label>,<callback function>};
            %format for subtabs: 
            %    subtabs.<tagname>(i,:) = {<subtab label>,<callback function>};
            %where <tagname> is the struct fieldname for the top level tab.
            tabs.Cases  = {'   Cases  ',@obj.refresh};
            tabs.Inputs = {'  Inputs  ',@obj.InputTabSummary};
            tabs.Plot   = {'  Q-Plot  ',@obj.getTabData}; %quick plot option
            tabs.Stats = {'   Stats   ','gcbo;'};
            subtabs.Stats(1,:) = {' General ',@obj.getTabData};
            subtabs.Stats(2,:) = {' Extremes ',@obj.getTabData};
        end
%%
        function props = setTabProperties(~)
            %define the tab and position to display class data tables
            %props format: {class name, tab tag name, position, ...
            %               column width, table title}
            props = {...
                'VPparam','Inputs',[0.95,0.48],{180,60},'Input parameters:'};
        end
%%
        function setTabAction(~,src,cobj)
            %function required by GUIinterface and sets action for selected
            %tab (src)
            switch src.Tag
                case 'Plot'
                    tabPlot(cobj,src);
                case 'Stats'
                    tabStats(cobj,src);
            end
        end      
%% ------------------------------------------------------------------------
% Callback functions used by menus and tabs
%--------------------------------------------------------------------------           

        %% File menu ------------------------------------------------------
        %use default menu functions defined in muiModelUI
            
        %% Tools menu -----------------------------------------------------
        %use default menu functions defined in muiModelUI
                
        %% Project menu ---------------------------------------------------
        %use default menu functions defined in muiModelUI           

        %% Setup menu -----------------------------------------------------
        function setupMenuOptions(obj,src,~)
            %callback functions for data input
            switch src.Text
                case 'Input parameters'
                    VPparam.setParamInput(obj);                             
                    tabsrc = findobj(obj.mUI.Tabs,'Tag','Inputs');
                    InputTabSummary(obj,tabsrc);
                case 'Import Data'
                    % muiData.loadData(obj.Cases); %direct call
                    fname = 'muiData.loadData';
                    callStaticFunction(obj,fname,obj.Cases);
                case 'Model Constants'
                    obj.Constants = editProperties(obj.Constants);
            end
        end
        %%
        function loadMenuOptions(obj,src,~)
            %callback functions to import data
            switch src.Parent.Text
                case 'Waves'
                    
                case 'Water levels'
                    
                case 'Winds'
                     
                case 'Beach profiles'
                        
                case 'Shoreline'
                         
                case 'BlueKenue data'
                    
                case 'User dataset'                      
                    classname = 'UserData';                     
            end            
            
            switch src.Text
                case 'Load'
                    fname = sprintf('%s.loadData',classname);
                case 'Add'
                    fname = sprintf('%s.addData',classname);
                case 'Delete'
                    fname = sprintf('%s.deleteData',classname);
                case 'Quality Control'
                    fname = sprintf('%s.qcData',classname);
            end
            
            callStaticFunction(obj,fname,obj.Cases);
        end
        
        %% Run menu -------------------------------------------------------
        function runMenuOptions(obj,src,~)
            %callback functions to run model
            switch src.Text
                case 'Run Model'
                    VPmodel.runModel(obj); 
                case 'Derive Output'
                    obj.mUI.ManipUI = muiManipUI.getManipUI(obj);
            end            
        end              
            
        %% Analysis menu ------------------------------------------------------
        function analysisMenuOptions(obj,src,~)
            switch src.Text
                case 'Plots'
                    obj.mUI.PlotsUI = muiPlotsUI.getPlotsUI(obj);
                case 'Statistics'
                    obj.mUI.StatsUI = muiStatsUI.getStatsUI(obj);
            end            
        end

        %% Help menu ------------------------------------------------------
        function Help(~,~,~)
            doc ModelUI
        end   
    end    
end