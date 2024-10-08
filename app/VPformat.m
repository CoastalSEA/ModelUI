function output = VPformat(funcall,varargin)
%
%-------function help------------------------------------------------------
% NAME
%   VPformat.m
% PURPOSE
%   file format defintions for import of Vertical velocity profile data
% USAGE
%   obj = VPformat(funcall,varargin)
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
%     varargin = varargin{:};
    
    switch funcall
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
    dsp.Variables = struct(...   %cell arrays can be column or row vectors
        'Name',{'uObs'},...
        'Description',{'Observed'},...
        'Unit',{'m/s'},...
        'Label',{'Velocity (m/s)'},...
        'QCflag',{'raw'}); 
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
%%
%--------------------------------------------------------------------------
% getData
%--------------------------------------------------------------------------
function dst = getData(~,filename)
    %read data from file (function is at end of file)
    %read and load a data set from a file
    [data,~] = readInputData(filename);             
    if isempty(data), dst = []; return; end
    %set metadata
    dsp = setDSproperties;
    
    %do any formatting of data necessary (eg sort out date and time
    %inputs)
    
    %load the results into a dstable  
    dd = reshape(data{2},[1,size(data{2})]);
    dst = dstable(dd,'DSproperties',dsp);
    dst.Dimensions.Z = data{1};     %grid z-coordinate    
end
%%
function [data,header] = readInputData(filename)
    %read wind data (read format is file specific).
    dataSpec = '%f %f'; 
    nhead = 2;     %number of header lines
    [data,header] = readinputfile(filename,nhead,dataSpec); %see muifunctions
end    
%%
%--------------------------------------------------------------------------
% dataQC
%--------------------------------------------------------------------------
function ok = dataQC(obj) %#ok<INUSD>
    %quality control a user data timeseries
    % datasetname = getDataSetName(obj); %prompts user to select dataset if more than one
    % dst = obj.Data.(datasetname);      %selected dstable
    warndlg('No quality control defined for this format');
    ok = 0;    %ok=0 if no QC implemented in dataQC
end
%%
%--------------------------------------------------------------------------
% dataDSproperties
%--------------------------------------------------------------------------
function ok = getPlot(dst,src)
    %generate a plot on the src graphical object handle    
    ok = 1;  %ok=0 if no plot implemented in getPlot
    %get data for variable and dimension z

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



