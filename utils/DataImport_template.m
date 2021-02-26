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
    
    methods 
        function obj = DataImport_template()                 % << Edit to classname
            %class constructor
            %initialise list of available input file formats. Format is:
            %{'label 1','function name 1';'label 2','function name 2'; etc}
            obj.DataFormats = {'UserData',formatfile};
            %define file specification, format is: {multiselect,file etnsion types}
            obj.FileSpec = {'on','*.txt;*.csv'};
        end
%%
        function tabPlot(obj,src)
            %generate plot for display on Q-Plot tab
            funcname = 'getPlot';
            dst = obj.Data{1};
            [var,ok] = callFileFormatFcn(obj,funcname,dst,src);
            if ok<1, return; end
            
            if var==0  %no plot defined so use muiDataSet default plot
                tabDefaultPlot(obj,src);
            end
        end 
%%
        function ok = dataQC(obj)
            %quality control a dataset
            % dataset = getDataSetID(obj); %prompts user to select dataset if more than one
            % dst = obj.Data{dataset};     %selected dstable
            warndlg('No qualtiy control defined for this format');
            ok = 0;    %ok=0 if no QC implemented in dataQC
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
            [data,header] = readinputfile(filename,nhead,dataSpec);
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