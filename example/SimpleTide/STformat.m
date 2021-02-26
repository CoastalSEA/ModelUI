function output = STformat(funcall,inp1,inp2)
    %file format defintions for import of tidal elevation data
    
    % funcall - function being called
    % inp1 - function specific input (filename or class instance)
    % inp2 - function specific input (dsp or src)
    %----------------------------------------------------------------------
    % AUTHOR
    % Ian Townend
    %
    % COPYRIGHT
    % CoastalSEA, (c) 2020
    %----------------------------------------------------------------------
    switch funcall
        %standard calls from muiDataSet - do not change if data class 
        %inherits from muiDataSet. The function getPlot is called from the
        %Abstract method tabPlot. The class definition can use tabDefaultPlot
        %define plot function in the class file, or call getPlot
        case 'setDSproperties'
            output = setDSproperties();
        case 'getData'
            output = getData(inp1,inp2);
        case 'dataQC'
            output = dataQC(inp1);
        case 'getPlot'
            output = getPlot(inp1,inp2);
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
function dst = getData(filename,dsp)
    %read and load a data set from a file
    [data,~] = readInputData(filename);             
    if isempty(data), dst = []; return; end

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
function ok = getPlot(obj,src)
    %generate a plot on the src graphical object handle    
    ok = 0;  %ok=0 if no plot implemented in getPlot
    %return some other value if a plot is implemented here
end



