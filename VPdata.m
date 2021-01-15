classdef VPdata < muiDataSet
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
%   inherits muiDataSet and uses dstable and dscatalogue
%
% Author: Ian Townend
% CoastalSEA (c)Nov 2020
%--------------------------------------------------------------------------
%    
    properties  
        %inherits Data, RunParam, MetaData and CaseIndex from muiDataSet
        %Additional properties:  
    end
    
    methods (Access = private)
        function obj =VPdata()
            %class constructor
        end
    end
    
%%    
    methods (Static)
        function loadData(muicat)
            %read and load a data set from a file
            obj = VPdata;               %initialise class object
            [data,~,filename] = readInputData(obj);             
            if isempty(data), return; end
            dsp = dataDSproperties(obj);  %initialise dsproperties for data
            
            %load the data
%             [data,time] = getData(obj,data,dsp);
            %load the results into a dstable            
            dst = dstable(data{2},'DSproperties',dsp);
            dst.Dimensions.Z = data{1};     %grid z-coordinate
            %assign metadata about dagta
            dst.Source = filename;
            %setDataRecord classobj, muiCatalogue obj, dataset, classtype
            setDataRecord(obj,muicat,dst,'data');           
        end 
    end 
%%
    methods
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
        function [data,header,filename] = readInputData(~)
            %read wind data (read format is file specific).
            [fname,path,~] = getfiles('FileType','*.txt');
            filename = [path fname];
            dataSpec = '%f %f'; 
            nhead = 2;     %number of header lines
            [header,data] = readinputfile(filename,nhead,dataSpec);
        end      
%%        
        function dsp = dataDSproperties(~)
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