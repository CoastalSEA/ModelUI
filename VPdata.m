classdef VPdata
%
%-------class help------------------------------------------------------===
% NAME
%   VPdata.m
% PURPOSE
%   Class to illustrate importing a data set, adding the results to dstable
%   and a record in a dscatlogue with a method to plot the output
% USAGE
%   obj = VPdata.loadData(catobj), where catobj is a handle to a dscatalogue
% SEE ALSO
%   VPdata_ff.m which inherits muiDataSet and uses a format file
%
% Author: Ian Townend
% CoastalSEA (c)Nov 2020
%--------------------------------------------------------------------------
%    
    properties  
        Data        %cell array of datasets. These can be multiple dstables, 
                    %or a mix of tables and other data types. The data are 
                    %indexed using the MetaData property.
        RunParam    %instance of run parameter classes defining settings used
        MetaData    %cell array of names for the datasets held in data. 
                    %Implementing classes need to define a name for each
                    %type of output data.
    end
    
    properties (Hidden, SetAccess=private)
        CaseIndex       %case index assigned when class instance is loaded
    end
    
    methods (Access = private)
        function obj = VPdata()
            %class constructor
        end
    end
    
%%    
    methods (Static)
        function loadData(muicat,~)
            %read and load a data set from a file
            obj = VPdata;               %initialise class object
            [data,~,filename] = readInputData(obj);             
            if isempty(data), return; end
            dsp = setDSproperties(obj);  %initialise dsproperties for data
            %load the results into a dstable            
            dst = dstable(data{2},'DSproperties',dsp);
            dst.Dimensions.Z = data{1};     %grid z-coordinate
            %assign metadata about data
            dst.Source{1} = filename;
            %setDataRecord classobj, muiCatalogue obj, dataset, classtype
            setDataSetRecord(obj,muicat,dst,'data');           
        end 
    end 
%%
    methods
        function addData(obj,classrec,catrec,muicat) 
            %add additional data to an existing user dataset
            dataset = getDataSetID(obj);
            dst = obj.Data{dataset};  
            
            [data,~,filename] = readInputData(obj);             
            if isempty(data), return; end
            dsp = setDSproperties(obj);  %initialise dsproperties for data
            %load the results into a dstable            
            adn_dst = dstable(data{2},'DSproperties',dsp);
            adn_dst.Dimensions.Z = data{1};     %grid z-coordinate
            if isempty(adn_dst), return; end
            
            %data is stored as single row with an X dimension, so
            %concatentate accordingly
            temp = dst.Dimensions.Z;
            dst.Dimensions.Z = [dst.Dimensions.Z;adn_dst.Dimensions.Z];
            if isnan(dst.Dimensions.Z) 
                dst.Dimensions.Z = temp;
                return;
            end
            dst = vertcat(dst,adn_dst);
            
            %assign metadata about data
            nfile = length(dst.Source);
            dst.Source{nfile+1} = filename;
            
            obj.Data{dataset} = dst;  
            updateCase(muicat,obj,classrec);
            getdialog(sprintf('Data added to: %s',catrec.CaseDescription));
        end
%%
        function deleteData(obj,classrec,catrec,muicat)
            %delete variable or rows from a dataset
            dataset = getDataSetID(obj);
            dst = obj.Data{dataset};
            
            delist = dst.VariableNames;
            %select variable to use
            promptxt = {sprintf('Select Variable')}; 
            att2use = 1;
            if length(delist)>1
                [att2use,ok] = listdlg('PromptString',promptxt,...
                                 'Name',title,'SelectionMode','single',...
                                 'ListSize',[250,100],'ListString',delist);
                if ok<1, return; end  
            end
            promptxt = sprintf('Delete variable: %s?',delist{att2use});
            selopt = questdlg(promptxt,'Delete variable',...
                                      'Yes','No','No');
            if strcmp(selopt,'Yes')
                dst.(delist{att2use}) = [];  %delete selected variable

                obj.Data{dataset} = dst;            
                updateCase(muicat,obj,classrec);
                getdialog(sprintf('Data deleted from: %s',catrec.CaseDescription));
            end
        end
%%
        function qcData(obj,classrec,catrec,muicat)
            %quality control a dataset
            warndlg('No qualtiy control defined for this format');
        end     
%%
        function tabPlot(obj,src)
            %generate plot for display on Q-Plot tab
            
            %get data for variable and dimension z
            dst = obj.Data{1};
            z = dst.Dimensions.Z;%z co-ordinate data
            
            %now plot results
            ht = findobj(src,'Type','axes');
            delete(ht);
            ax = axes('Parent',src,'Tag','Profile');
            plot(dst.uObs,z);
            xlabel(dst.VariableLabels{1}); 
            ylabel(dst.DimensionLabels{1}); 
            title(dst.Description);
            ax.Color = [0.96,0.96,0.96];  %needs to be set after plot
        end   
    end
%%
    methods (Access = private)
        function setDataSetRecord(obj,muicat,dataset,datatype)
            %assign dataset to class Data property and update catalogue
            obj.Data = {dataset}; 
            classname = metaclass(obj).Name;            
            %add record to the catalogue and update mui.Cases.DataSets
            caserec = addRecord(muicat,classname,datatype);
            casedef = getRecord(muicat,caserec);
            obj.CaseIndex = casedef.CaseID;
            obj.Data{end}.Description = casedef.CaseDescription;
            if isempty(muicat.DataSets) || ~isfield(muicat.DataSets,classname) ||...
                    isempty(muicat.DataSets.(classname))
                idrec = 1;
            else
                idrec = length(muicat.DataSets.(classname))+1;
            end
            muicat.DataSets.(classname)(idrec) = obj;
        end  
%%
        function dataset = getDataSetID(obj)
            %check whether there is more than one dstable and select
            dataset = 1;
            if ~isempty(obj.MetaData) && length(obj.MetaData)>1
                promptxt = {'Select dataset'};
                title = 'Save dataset';
                [dataset,ok] = listdlg('PromptString',promptxt,...
                           'SelectionMode','single','Name',title,...
                           'ListSize',[300,100],'ListString',obj.MetaData);
                if ok<1, return; end       
            end            
        end        
%%        
        function [data,header,filename] = readInputData(~)
            %read wind data (read format is file specific).
            [fname,path,~] = getfiles('FileType','*.txt');
            filename = [path fname];
            dataSpec = '%f %f'; 
            nhead = 2;     %number of header lines
            [data,header] = readinputfile(filename,nhead,dataSpec);
        end      
%%        
        function dsp = setDSproperties(~)
            %define the metadata properties for the demo data set
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]);           
            dsp.Variables = struct(...   %cell arrays can be column or row vectors
                'Name',{'uObs'},...
                'Description',{'Observed'},...
                'Unit',{'m/s'},...
                'Label',{'Velocity (m/s)'},...
                'QCflag',{'data'}); 
            dsp.Row = struct(...
                'Name',{''},...
                'Description',{''},...
                'Unit',{''},...
                'Label',{''},...
                'Format',{''});        
            dsp.Dimensions = struct(...    
                'Name',{'Z'},...
                'Description',{'zLevels'},...
                'Unit',{'m'},...
                'Label',{'Elevation (mAboveBed)'},...
                'Format',{'-'});   
        end
    end
end