function obj = timeseries_format_template(obj,funcall)
    %template to define functions for a timeseries of a given format
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
        case 'getResDef'
            obj = getResDef(obj);
        case 'getTSdata'
            obj = getTSdata(obj);
        case 'dataQC'
            obj = dataQC(obj);
    end
end
%%
function obj = getResDef(obj)
    %define the variables in the dataset
    r = obj.ResDef;
    r.DataVar   = {};
    r.AdnOutVar = {};
    r.varNames  = {};
    r.varDesc   = {};                
    r.varUnits  = {}; 
    r.varLabels = {};                   
    r.xyzDesc   = {};
    r.xyzUnits  = {};
    r.xyzLabels = {};
    r.rowDesc   = {};    %used to identify time data
    r.rowLabels = {};
    r.rowFormat = {'dd-MM-uuuu HH:mm:ss'};
    r.xyDefault = {'Time'};    %can be 'Time','X','Y',or Z' 
    r.Type      = {'data'};
    r.Style     = {'Single'};
    obj.ResDef = r;       
end
%%
function obj = getTSdata(obj)
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
function obj = dataQC(obj)
    %quality control a user data timeseries
    warndlg('No qualtiy control defined for this format');
end