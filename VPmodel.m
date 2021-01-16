classdef VPmodel < muiDataSet                        
%
%-------class help------------------------------------------------------
% NAME
%   VPmodel.m
% PURPOSE
%   Class description - Class for the Vertical Proofile model
% SEE ALSO
%   muiDataSet
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
%     
    properties
        %inherits Data, RunProps, MetaData and CaseIndex from muiDataSet
        %Additional properties:     
        uBar
    end
    
    methods (Access = private)
        function obj = VPmodel()                      
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
            obj = VPmodel;                            
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
            inp = mobj.Inputs.VPparam;
            res = verticalprofile(inp);
%--------------------------------------------------------------------------
% Asign model output to a dstable using the defined dsproperties meta-data
%--------------------------------------------------------------------------                   
            %each variable should be an array in the 'results' cell array
            %if model returns single variable as array of doubles, use {results}
            dst = dstable(res.results{:},'DSproperties',dsp);
            dst.Dimensions.Z = res.xyzdata{1};     %grid z-coordinate
            obj.uBar = res.addnprops;
%--------------------------------------------------------------------------
% Save results
%--------------------------------------------------------------------------                        
            %assign metadata about model
            dst.Source = 'DiffusionModel';
            dst.MetaData = sprintf('Model run for cD=%.2f, NK=%.2f, r=%.3f',...
                            inp.cDfriction,inp.NKfriction,inp.Rounghness);
            %save results
            setDataRecord(obj,mobj.Cases,dst,'model');
            getdialog('Run complete');
            mobj.DrawMap;
        end
    end
%%
    methods
        function tabPlot(obj,src) %abstract class for muiDataSet
            %generate plot for display on Q-Plot tab

            %get data for variable and dimension z
            dst = obj.Data{1};
            z = dst.Dimensions.Z;%z co-ordinate data
            ev = dst.VariableNames;
            %now plot results
            ht = findobj(src,'Type','axes');
            delete(ht);
            ax = axes('Parent',src,'Tag','Profile');
            plot(dst.uB,z,dst.uK,z,dst.uS,z);
            xlabel(dst.VariableLabels{1}); 
            ylabel(dst.DimensionLabels{1}); 
            title(dst.Description);          
            for k=1:length(ev)
                leg{k} = sprintf('%s uBar=%.3g',ev{k},obj.uBar(k));
            end
            legend(leg,'Location','best');
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
            dsp.Variables = struct(...                       % <<Edit metadata to suit model
                'Name',{'uB','uK','uS'},...
                'Description',{'uBowden','uKraav','uSoulsby'},...
                'Unit',{'m/s','m/s','m/s'},...
                'Label',repmat({'Velocity (m/s)'},[1,3]),...
                'QCflag',repmat({'model'},[1,3])); 
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
    end    
end
