classdef Diffusion2D < muiModelUI
%
%-------class help---------------------------------------------------------
% NAME
%   Diffusion2D.m
% PURPOSE
%   Main UI for the Diffusion model, which implements the 
%   muiModelUI to define main menus.
% SEE ALSO
%   Abstract class muiModelUI.m and tools propvide in muitoolbox
%
% Author: Ian Townend
% CoastalSEA (c)  December 2020
%--------------------------------------------------------------------------
%
    properties (Access = protected)
        %implement properties defined as Abstract in muiModelUI
        vNumber = '2.0'
        vDate   = 'December 2020'
        modelName = 'Diffusion2D'
        %Properties defined in muiModelUI that need to be defined in setGui
        % ModelInputs  %classes required by model: used in isValidModel check 
        % DataUItabs   %struct to define type of muiDataUI tabs for each use 
    end
    
    methods
        function obj = Diffusion2D
            %model constructor function  
            obj = setMUI(obj);
        end
    end
%% ------------------------------------------------------------------------
% Definition of GUI Settings
%--------------------------------------------------------------------------  
    methods (Access = protected)
        function obj = setMUI(obj)
            %initialise standard figure and menus
            %classess required to run model
            obj.ModelInputs.DFmodel = {'DFparams','DFrunprops'}; 
            %tabs to include in DataUIs for plotting and statistical analysis
            obj.DataUItabs.Plot = {'2D','3D','4D','2DT','3DT','4DT'};   
            obj.DataUItabs.Stats = {'General','Timeseries','Taylor','Intervals'};  
            
            modelLogo = 'Diffusion_logo.jpg';
            initialiseUI(obj,modelLogo);    %initialise menus and tabs
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
            menu.File.List = {'New','Open','Save','Save as','Exit'};
            menu.File.Callback = repmat({@obj.fileMenuOptions},[1,5]);
            
            %% Tools menu -------------------------------------------------
            menu.Tools(1).List = {'Refresh','Clear all'};
            menu.Tools(1).Callback = {@obj.refresh, 'gcbo;'};  
            
            % submenu for 'Clear all'
            menu.Tools(2).List = {'Model','Figures','Cases'};
            menu.Tools(2).Callback = repmat({@obj.toolsMenuOptions},[1,3]);

            %% Project menu -----------------------------------------------
            menu.Project(1).List = {'Project Info','Scenarios','Export/Import'};
            menu.Project(1).Callback = {@obj.editProjectInfo,'gcbo;','gcbo;'};
            
            % submenu for Scenarios
            menu.Project(2).List = {'Edit Description','Edit Data Set',...
                                 'Save','Delete','Reload','View settings'};                                               
            menu.Project(2).Callback = repmat({@obj.projectMenuOptions},[1,6]);
            
            % submenu for 'Export/Import'                                          
            menu.Project(3).List = {'Export','Import'};
            menu.Project(3).Callback = repmat({@obj.projectMenuOptions},[1,2]);
            
            %% Setup menu -------------------------------------------------
            menu.Setup(1).List = {'Input parameters','Run properties','Model Constants'};                                    
            menu.Setup(1).Callback = repmat({@obj.setupMenuOptions},[1,3]);
            
            
            %% Run menu ---------------------------------------------------
            menu.Run(1).List = {'Run Model','Derive Output'};
            menu.Run(1).Callback = repmat({@obj.runMenuOptions},[1,2]);
            
            %% Plot menu --------------------------------------------------  
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
            tabs.Plot   = {'  Q-Plot  ',@obj.getTabData};
            subtabs = [];
            % tabs.calcs = {'   Calcs   ',@obj.getTabData};
            % subtabs.calcs(1,:) = {'  Calc  ',@obj.test};
            % subtabs.calcs(2,:) = {'  Stats  ',@obj.test};
        end
       
%%
        function props = setTabProperties(~)
            %define the tab and position to display class data tables
            %props format: {class name, tab tag name, position, ...
            %               column width, table title}                 
            props = {...
                'DFparams','Inputs',[0.95,0.48],{180,60},'Model input:';... %DiffusionData
                'DFrunprops','Inputs',[0.32,0.58],{240,60},'Run properties:'};   %DiffRunProps
        end   
 %%
        function setTabAction(~,src,cobj)
            %function required by GUIinterface and sets action for selected
            %tab (src)
            %REVIEW HOW THIS WORKS IF DATA IS NO LONGER HELD BY obj.
            switch src.Tag
                case 'Plot'
                     tabPlot(cobj,src);
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
            %model specific data setup function calls
            switch src.Text
                case 'Input parameters'
                    DFparams.setParamInput(obj);                             
                    tabsrc = findobj(obj.mUI.Tabs,'Tag','Inputs');
                    InputTabSummary(obj,tabsrc);
                case 'Run properties'
                    DFrunprops.setRunProps(obj);                    
                    tabsrc = findobj(obj.mUI.Tabs,'Tag','Inputs');
                    InputTabSummary(obj,tabsrc);
                case 'Model Constants'
                    obj.Constants = editProperties(obj.Constants);
            end
        end   
        
        %% Run menu -------------------------------------------------------
        function runMenuOptions(obj,src,~)
            %callback functions to run model
            switch src.Text
                case 'Run Model'
                    DFmodel.runDiffusionModel(obj); 
                case 'Derive Output'
                    obj.mUI.Manip = muiManipUI.getManipUI(obj);
            end            
        end              
            
        %% Analysis menu ------------------------------------------------------
        function analysisMenuOptions(obj,src,~)
            switch src.Text
                case 'Plots'
                    obj.mUI.Plots = muiPlotsUI.getPlotsUI(obj);
                case 'Statistics'
                    obj.mUI.Stats = muiStatsUI.getStatsUI(obj);
            end            
        end

        %% Help menu ------------------------------------------------------
        function Help(~,~,~)
            doc Diffusion
        end     
    end
end    
    
    
    
    
    
    
    
    
    
    