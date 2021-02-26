classdef STmodel < muiDataSet                     
%
%-------class help------------------------------------------------------
% NAME
%   STmodel.m
% PURPOSE
%   Generate time series of tidal amplitude, vertical and horizontal
%   velocity using a simple harmonic tidal prediction method'
%   This is a simple representation of the diurnal-semidiurnal and 
%   spring-neap variations in the tide based on a summation of 
%   M2, S2 and O1 contributions, scaled to the defined tidal range. 
%   Tidal currents are derived in a similar way and scaled to the 
%   defined tidal velocity amplitude.
% SEE ALSO
%   muiDataSet
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
        function obj = STmodel()                      
            %class constructor
        end
    end      
%%
    methods (Static)        
%--------------------------------------------------------------------------
% Model implementation
%--------------------------------------------------------------------------         
        function obj = runModel(mobj)
            %function to run a simple 2D diffusion model
            obj = STmodel;                        
            dsp = modelDSproperties(obj);
            
            %now check that the input data has been entered
            %isValidModel checks the InputHandles defined in ModelUI
            if ~isValidModel(mobj, metaclass(obj).Name)  
                warndlg('Use Setup to define model input parameters');
                return;
            end
            %assign the run parameters to the model instance
            setRunParam(obj,mobj); 
%--------------------------------------------------------------------------
% Model code  <<INSERT MODEL CODE or CALL MODEL>>
%--------------------------------------------------------------------------
            inp = mobj.Inputs.STparam;       
            res = simple_tide(inp);
            %now assign results to object properties  
            modeltime = seconds(res.t);  %durataion data for rows
            modeltime.Format = 'd';
%--------------------------------------------------------------------------
% Asign model output to a dstable using the defined dsproperties meta-data
%--------------------------------------------------------------------------                   
            %each variable should be an array in the 'results' cell array
            %if model returns single variable as array of doubles, use {results}
            res = struct2cell(res);
            dst = dstable(res{2:end},'RowNames',modeltime,'DSproperties',dsp);
%--------------------------------------------------------------------------
% Save results
%--------------------------------------------------------------------------                        
            %assign metadata about model
            dst.Source = metaclass(obj).Name;
            dst.MetaData = sprintf('Model run for %d days',inp.Duration);
            %save results
            obj.MetaData = {'dst1','dst2'};
            setDataSetRecord(obj,mobj.Cases,{dst,dst},'model');
            getdialog('Run complete');
        end
    end
%%
    methods
        function tabPlot(obj,src) %abstract class for muiDataSet
            %generate plot for display on Q-Plot tab
            dst = obj.Data{1};
            ht = findobj(src,'Type','axes');
            delete(ht);
            ax = axes('Parent',src,'Tag','Qplot');
            plot(dst.RowNames,dst.h);     %plot time v elevation
            xlabel(dst.RowLabel); 
            ylabel(dst.VariableLabels{1});             
            title(dst.Description);    
            ax.Color = [0.96,0.96,0.96];  %needs to be set after plot 
        end
    end 
%%    
    methods (Access = private)
        function dsp = modelDSproperties(~) 
            %define a dsproperties struct and add the model metadata
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]); 
            %define each variable to be included in the data table and any
            %information about the dimensions. dstable Row and Dimensions can
            %accept most data types but the values in each vector must be unique
            
            %struct entries are cell arrays and can be column or row vectors
            dsp.Variables = struct(...                      
                'Name',{'h','uV','uH'},...
                'Description',{'Elevation','Vertical velocity',...
                                            'Horizontal velocity'},...
                'Unit',{'mAD','m/s','m/s'},...
                'Label',{'Elevation (mOD)','Velocity (m/s)','Velocity (m/s)'},...
                'QCflag',{'model','model','model'}); 
            dsp.Row = struct(...
                'Name',{'Time'},...
                'Description',{'Time'},...
                'Unit',{'d'},...
                'Label',{'Time (d)'},...
                'Format',{'d'});        
            dsp.Dimensions = struct(...    
                'Name',{''},...
                'Description',{''},...
                'Unit',{''},...
                'Label',{''},...
                'Format',{''});  
        end
    end    
end
