function output = VPformat(funcall,inp1,inp2)
    %file format defintions for import of Vertical velocity profile data
    
    % funcall - function being called
    % inp1 - function specific input (filename or class instance)
    % inp2 - function specific input (dsp or src)
    %----------------------------------------------------------------------
    % AUTHOR
    % Ian Townend
    %
    % COPYRIGHT
    % CoastalSEA, (c) 2017
    %----------------------------------------------------------------------
    switch funcall
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
function dst = getData(filename,dsp)
    %read data from file (function is at end of file)
    %read and load a data set from a file
    [data,~] = readInputData(filename);             
    if isempty(data), dst = []; return; end

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
    % dataset = getDataSetID(obj); %prompts user to select dataset if more than one
    % dst = obj.Data{dataset};     %selected dstable
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



