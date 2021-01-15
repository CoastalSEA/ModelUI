classdef STdata < muiDataSet
%
%-------class help------------------------------------------------------===
% NAME
%   STdata.m
% PURPOSE
%   Class to illustrate importing a data set, adding the results to dstable
%   and a record in a dscatlogue with a method to plot the output
% USAGE
%   obj = DataImport_template.loadData(catobj), where catobj is a handle to a dscatalogue
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
            obj = demoData;               %initialise class object
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
            setDataRecord(obj,muicat,dst,'data');           
        end 
    end 
%%
    methods
        function tabPlot(obj,src)
            %generate plot for display on Q-Plot tab
            
            %add code to define plot format or call default tabplot using:
            tabDSplot(obj,src);
        end   
    end
%%
    methods (Access = private)
        function [data,header,filename] = readInputData(~)
            %read wind data (read format is file specific).
            [fname,path,~] = getfiles('FileType','*.txt');
            filename = [path fname];
            dataSpec = '%d %d %s %s %s %s'; 
            nhead = 1;     %number of header lines
            [header,data] = readinputfile(filename,nhead,dataSpec);
        end     
%%        
        function [varData,myDatetime] = getData(~,data,dsp)
            %format data from file
            mdat = data{1};       %date
            mtim = data{2};       %hour 24hr clock
            idx = mtim==24;
            mdat(idx) = mdat(idx)+1;
            mtim(idx) = 0;
            mdat = datetime(mdat,'ConvertFrom','yyyymmdd');
            mtim = hours(mtim);
            % concatenate date and time
            myDatetime = mdat + mtim;            %datetime for rows
            myDatetime.Format = dsp.Row.Format;
            %remove text string flags
            data(:,3:6) = cellfun(@str2double,data(:,3:6),'UniformOutput',false);
            %reorder to be speed direction speed direction
            temp = data(:,3);
            data(:,3) = data(:,4);
            data(:,4) = temp;
            temp = data(:,5);
            data(:,5) = data(:,6);
            data(:,6) = temp;
            varData = data(1,3:end);             %sorted data to be loaded
        end  
%%        
        function dsp = dataDSproperties(~)
            %define the metadata properties for the demo data set
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]);           
            dsp.Variables = struct(...   %cell arrays can be column or row vectors
                'Name',{'Var1','Var2'},...
                'Description',{'Variable 1','Variable 2'},...
                'Unit',{'m/s','m/s'},...
                'Label',{'Plot label 1','Plot label 2'},...
                'QCflag',{'model','model'}); 
            dsp.Row = struct(...
                'Name',{'Time'},...
                'Description',{'Time'},...
                'Unit',{'h'},...
                'Label',{'Time'},...
                'Format',{'dd-MM-uuuu HH:mm:ss'});        
            dsp.Dimensions = struct(...    
                'Name',{''},...
                'Description',{''},...
                'Unit',{''},...
                'Label',{''},...
                'Format',{''});  
        end
    end
end