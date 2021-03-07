classdef STdata < muiDataSet
%
%-------class help------------------------------------------------------===
% NAME
%   STdata.m
% PURPOSE
%   Class to illustrate importing a data set, adding the results to dstable
%   and a record in a dscatlogue (as a property of muiCatalogue)
% USAGE
%   obj = STdata.loadData(catobj), where catobj is a handle to a muiCatalogue
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
        function obj = STdata()
            %class constructor
        end
    end
    
%%    
    methods (Static)
        function loadData(muicat)
            %read and load a data set from a file
            obj = STdata;               %initialise class object
            [data,~,filename] = readInputData(obj);             
            if isempty(data), return; end
            dsp = dataDSproperties(obj);  %initialise dsproperties for data
            
            %load the data
            [data,time] = getData(obj,data,dsp);
            %load the results into a dstable            
            dst = dstable(data{:},'RowNames',time,'DSproperties',dsp);
            %assign metadata about dagta
            dst.Source = filename;
            %setDataRecord classobj, muiCatalogue obj, dataset, classtype
            setDataSetRecord(obj,muicat,dst,'data');           
        end 
    end 
%%
    methods
        function tabPlot(obj,src)
            %generate plot for display on Q-Plot tab
            
            %add code to define plot format or call default tabplot using:
            tabDefaultPlot(obj,src);
        end   
    end
%%
    methods (Access = private)
        function [data,header,filename] = readInputData(~)
            %read wind data (read format is file specific).
            [fname,path,~] = getfiles('FileType','*.txt');
            filename = [path fname];
            dataSpec = '%s %s %f %f %f'; 
            nhead = 1;     %number of header lines
            [data,header] = readinputfile(filename,nhead,dataSpec);
        end     
%%        
        function [varData,myDatetime] = getData(~,data,dsp)
            %format data from file
            %code to parse input data and assign to vardata
            mdat = datetime(strip(data{1},''''));
            mtim = datetime(strip(data{2},''''));
            myDatetime = mdat + timeofday(mtim);

            % concatenate date and time
            myDatetime = myDatetime-myDatetime(1);
            myDatetime.Format = dsp.Row.Format;
            varData = data(3:end);             %sorted data to be loaded
        end  
%%        
        function dsp = dataDSproperties(~)
            %define the metadata properties for the demo data set
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]);           
            dsp.Variables = struct(...   %cell arrays can be column or row vectors
                'Name',{'h','u','v'},...
                'Description',{'Elevation','Vertical velocity','Horizontal velocity'},...
                'Unit',{'mAD','m/s','m/s'},...
                'Label',{'Elevation (m)','Velocity (m/s)','Velocity (m/s)'},...
                'QCflag',{'data','data','data'}); 
            dsp.Row = struct(...
                'Name',{'Time'},...
                'Description',{'Time'},...
                'Unit',{'d'},...
                'Label',{'Time'},...
                'Format',{'d'});        
            dsp.Dimensions = struct(...    
                'Name',{''},...
                'Description',{''},...
                'Unit',{''},...
                'Label',{''},...
                'Format',{''});   
        end
    end
end