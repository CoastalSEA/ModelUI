classdef VPdata_ff < muiDataSet
%
%-------class help------------------------------------------------------===
% NAME
%   VPdata_ff.m
% PURPOSE
%   Class to import data sets, adding the results to dstable
%   and a record in a dscatlogue (as a property of muiCatalogue)
% USAGE
%   obj = VPdata_ff.loadData(catobj), where catobj is a handle to a muiCatalogue
% NOTES
%   inherits muiDataSet and uses dstable and dscatalogue
%   format files used to load data of varying formats (variables and file format)
% SEE ALSO
%	VPdata.m which is a stand alone class that does the same thing
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
        function obj = VPdata_ff
            %class constructor
            %initialise list of available input file formats. Format is:
            %{'label 1','formatfile name 1';'label 2','formatfile name 2'; etc}
            obj.DataFormats = {'VPdata','VPformat'};         % << Edit to file list
            %define file specification, format is: {multiselect,file extension types}
            obj.FileSpec = {'on','*.txt;*.csv'};             % << Edit to file types
        end
%%
        function tabPlot(obj,src)
            %generate plot for display on Q-Plot tab
            funcname = 'getPlot';
            dst = obj.Data{1};
            [ok,var] = callFileFormatFcn(obj,funcname,dst,src);
            if ok<1, return; end
            
            if var==0  %no plot defined so use muiDataSet default plot
                tabDSplot(obj,src);
            end
        end   
    end
%%
    %data is stored as single row with an X dimension, so muiDataSet.addData
    %does not handle this. If required an overlaod function would need to
    %be added here. See VPdata.m for an example of the function required.
end