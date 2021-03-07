function output = STformat(funcall,varargin)
%
%-------function help------------------------------------------------------
% NAME
%   STformat.m
% PURPOSE
%   file format defintions for import of tidal elevation data
% USAGE
%   obj = STformat(funcall,varargin)
% INPUTS
%   funcall - function being called
%   varargin - function specific input (filename,class instance,dsp,src, etc)
% OUTPUT
%   output - function specific output
%
% Author: Ian Townend
% CoastalSEA (c)Feb 2021
%--------------------------------------------------------------------------
%
    switch funcall
        %standard calls from muiDataSet - do not change if data class 
        %inherits from muiDataSet. The function getPlot is called from the
        %Abstract method tabPlot. The class definition can use tabDefaultPlot
        %define plot function in the class file, or call getPlot
        case 'getData'
            output = getData(varargin{:});
        case 'dataQC'
            output = dataQC(varargin{:});
        case 'getPlot'
            output = getPlot(varargin{:});
    end
end
%%
%--------------------------------------------------------------------------
% dataDSproperties
%--------------------------------------------------------------------------
function dsp = setDSproperties()
    %define the variables in the dataset
    %define the metadata properties for the demo data set
    dsp = struct('Variables',[],'Row',[],'Dimensions',[]);  
    %define each variable to be included in the data table and any
    %information about the dimensions. dstable Row and Dimensions can
    %accept most data types but the values in each vector must be unique

    %struct entries are cell arrays and can be column or row vectors
    dsp.Variables = struct(...  
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
%%
%--------------------------------------------------------------------------
% getData
%--------------------------------------------------------------------------
function dst = getData(~,filename)
    %read and load a data set from a file
    [data,~] = readInputData(filename);             
    if isempty(data), dst = []; return; end
    %set metadata
    dsp = setDSproperties;
    
    %code to parse input data and assign to vardata
    mdat = datetime(strip(data{1},''''));
    mtim = datetime(strip(data{2},''''));
    myDatetime = mdat + timeofday(mtim);

    % concatenate date and time
    myDatetime = myDatetime-myDatetime(1);
    myDatetime.Format = dsp.Row.Format;
    vardata = data(3:end);             %sorted data to be loaded

    %load the results into a dstable  
    dst = dstable(vardata{:},'RowNames',myDatetime,'DSproperties',dsp); 
end
%%
function [data,header] = readInputData(filename)
    %read tidal elevation data.
    dataSpec = '%s %s %f %f %f'; 
    nhead = 1;     %number of header lines
    [data,header] = readinputfile(filename,nhead,dataSpec); %see muifunctions
end
%%
%--------------------------------------------------------------------------
% dataQC
%--------------------------------------------------------------------------
function ok = dataQC(obj)
    %quality control a dataset
    % dataset = getDataSetID(obj); %prompts user to select dataset if more than one
    % dst = obj.Data{dataset};     %selected dstable
    warndlg('No qualtiy control defined for this format');
    ok = 0;    %ok=0 if no QC implemented in dataQC
end
%%
%--------------------------------------------------------------------------
% getPlot
%--------------------------------------------------------------------------
function ok = getPlot(dst,src)
    %generate a plot on the src graphical object handle    
    ok = 0;  %ok=0 if no plot implemented in getPlot
    %return some other value if a plot is implemented here
end



