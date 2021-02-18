classdef DataImport_template < muiDataSet                    % << Edit to classname
%
%-------class help------------------------------------------------------===
% NAME
%   DataImport_temaplate.m
% PURPOSE
%   Class to illustrate importing a data set, adding the results to dstable
%   and a record in a dscatlogue (as a property of muiCatalogue)
% USAGE
%   obj = DataImport_template.loadData(catobj), where catobj is a handle to a muiCatalogue
% SEE ALSO
%   inherits muiDataSet and uses dstable and dscatalogue
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
%    
    properties  
        %inherits Data, RunParam, MetaData and CaseIndex from muiDataSet
        %Additional properties:  
    end
    
    methods (Access = private)
        function obj = DataImport_template()                 % << Edit to classname
            %class constructor
        end
    end
    
%%    
    methods (Static)
        function loadData(muicat)
            %read and load a data set from a file
            obj = DataImport_template;                       % << Edit to classname
            [data,~,filename] = readInputData(obj);             
            if isempty(data), return; end
           
            %initialise dsproperties for data
            dsp = dataDSproperties(obj);  
            
            %do any formatting of data necessary (eg sort out date and time
            %inputs)
            time = data{1};
            data = data(2:end);
            
            %load the results into a dstable                 % << Edit to dimensions of dataset
            dst = dstable(data{:},'RowNames',time,'DSproperties',dsp);
            %if dimensions then extract from input file or load and read
            % dst.Dimensions.X = dims     
            
            %assign metadata about data
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
        function [data,header,filename] = readInputData(~)   % << Edit to file format being used
            %read wind data (read format is file specific).
            [fname,path,~] = getfiles('FileType','*.txt');
            filename = [path fname];
            dataSpec = '%d %d %s %s %s %s'; 
            nhead = 1;     %number of header lines
            [header,data] = readinputfile(filename,nhead,dataSpec);
        end       
%%        
        function dsp = dataDSproperties(~)
            %define the metadata properties for the demo data set
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]);  
            %define each variable to be included in the data table and any
            %information about the dimensions. dstable Row and Dimensions can
            %accept most data types but the values in each vector must be unique
            
            %struct entries are cell arrays and can be column or row vectors
            dsp.Variables = struct(...
                'Name',{'Var1','Var2'},...                   % <<Edit metadata to suit model
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