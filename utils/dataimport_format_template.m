function obj = dataimport_format_template(obj,funcall,src)
    %template to define functions for a dataset of a given format
    %obj - timeseries class object
    %funcall - function being called
    %----------------------------------------------------------------------
    % AUTHOR
    % Ian Townend
    %
    % COPYRIGHT
    % CoastalSEA, (c) 2017
    %----------------------------------------------------------------------
    switch funcall
        case 'setDSproperties'
            obj = setDSproperties();
        case 'getData'
            obj = getData(obj);
        case 'dataQC'
            obj = dataQC(obj);
        case 'getPlot'
            getPlot(obj,src)
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
%%
%--------------------------------------------------------------------------
% getData
%--------------------------------------------------------------------------
function obj = getData(obj)
    %read data from file (function is at end of file)
    [~,data] = readInputData(obj);  
    if isempty(data)
        obj.stsc = [];
        return; 
    end

    %code to parse input data and assign to varData
    
    varData = [];
    %assign data to a timeseries collection
    tsc = setCollection(obj,varData,'Time',myDatetime,...
                                    'xyzData',{Latitude,Longitude});
    if isempty(tsc), return; end      %trap error before assigning to obj
    obj.stsc = tsc;
    obj.stsc.Name = obj.filename;
end
%%
function [header,data] = readInputData(obj)
    %read wave data (read format is file specific).
    fid = fopen(obj.filename, 'r');
    if fid<0
        errordlg('Could not open file for reading','File write error','modal')
        header = ''; data = [];
        return;
    end

    %code to read header and data, eg:
    header = fgets(fid);
    dataSpec = header; %NB: header defines file format
    %read numeric data            
    data = textscan(fid,dataSpec);
    
    if isempty(data)
        warndlg('No data. Check file format selected')
    end
    fclose(fid);
end
%%
%--------------------------------------------------------------------------
% dataQC
%--------------------------------------------------------------------------
function obj = dataQC(obj)
    %quality control a user data timeseries
    warndlg('No qualtiy control defined for this format');
end
%%
%--------------------------------------------------------------------------
% getPlot
%--------------------------------------------------------------------------
function ok = getPlot(obj,src)
    %generate a plot on the src graphical object handle    
    ok = 0;  %ok=0 if no plot implemented in getPlot
    %return some other value if a plot is implemented here
    
end



