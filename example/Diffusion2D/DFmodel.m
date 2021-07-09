classdef DFmodel < muiDataSet
    %class for Diffusion2D to implement a 2D diffusion model
    %
    %----------------------------------------------------------------------
    % Simulating the 2-D Diffusion equation by the Finite Difference Method 
    % Numerical scheme used is a first order upwind in time and a second 
    % order central difference in space (Implicit and Explicit).
    % Core model is based on the code of Suraj Shanka, Copyright (c) 2012
    % See Licence agreement for details of rights and permissions). 
    % Downloaded from the Matlab Exchange Forum 3-Jan-2018.
    %
    % AUTHOR
    % Ian Townend
    %
    % COPYRIGHT
    % CoastalSEA, (c) Dec 2020
    %----------------------------------------------------------------------
    %
    properties
        %inherits Data, RunParam, MetaData and CaseIndex from muiDataSet
        CourantNumber
    end
    
    methods (Access = private)
        function obj = DFmodel()
            %class constructor
        end
    end 
%%
    methods (Static)        
%--------------------------------------------------------------------------
% Model implementation
%--------------------------------------------------------------------------         
        function obj = runDiffusionModel(mobj)
            %function to run a simple 2D diffusion model
            obj = DFmodel;         %instantiate object
            dsp = modelDSproperties(obj);
            
            %now check that the input data has been entered
            %isValidModel checks the InputHandles defined in ModelUI
            if ~isValidModel(mobj, metaclass(obj).Name)
                warndlg('Use Setup to define model input parameters');
                return;
            end
            setRunParam(obj,mobj);  %assign the run parameters to the model instance
%--------------------------------------------------------------------------
% Model code
%--------------------------------------------------------------------------
            inp = mobj.Inputs.DFparams;
            run = mobj.Inputs.DFrunprops;
            [results,xy,modeltime] = diffusion2Dmodel(inp,run);
            %now assign results to object properties  
            modeltime = seconds(modeltime);  %durataion data for rows        
            %each variable should be an array in the 'results' cell array
            %model returns single variable as array of doubles: so use {results}
            dst = dstable(results,'RowNames',modeltime,'DSproperties',dsp);
            dst.Dimensions.X = xy{:,1};     %grid x-coordinate
            dst.Dimensions.Y = xy{:,2};     %grid y-coordinate
            if run.is3D     %flag to generate pseudo 3D output
                dst.Dimensions.Z = xy{:,3}; %grid z-coordinate 
            end
            dx = inp.Xlength/(inp.Xint-1);
            obj.CourantNumber.X = inp.DiffCoeff*run.TimeStep/dx;
            dy = inp.Ylength/(inp.Yint-1);
            obj.CourantNumber.Y = inp.DiffCoeff*run.TimeStep/dy;
%--------------------------------------------------------------------------
% End of Model code
%--------------------------------------------------------------------------                         
            %assign metadata about model
            dst.Source = metaclass(obj).Name;
            dst.MetaData = sprintf('X&Y Courant Nos: %.3f and %.3f',...
                                obj.CourantNumber.X,obj.CourantNumber.Y);
            %save results
            setDataSetRecord(obj,mobj.Cases,dst,'model');
            getdialog('Run complete');
        end
    end
%%
    methods
        function tabPlot(obj,src) %abstract class for muiDataSet
            %generate plot for display on Plot tab
            %data is retrieved by muiModelUI.getTabData
            
            %get data for variable and dimensions x,y,t
            datasetname = getDataSetName(obj);
            dst = obj.Data.(datasetname);
            t = dst.RowNames;
            u = dst.u;            
            x = dst.Dimensions.X;
            y = dst.Dimensions.Y;
            %metatdata for model and run case description
            casedesc = sprintf('%s using %s',dst.Description,dst.Source);
            CNx = obj.CourantNumber.X;
            CNy = obj.CourantNumber.Y;
            DiffCoeff = obj.RunParam.DFparams.DiffCoeff;
            
            %check data can be plotted (in case 3D model used)            
            if ndims(u)>3
                warndlg('Unable to plot data. Use Plot Gui to make data selection')
                return;
            end
            
            %clear any existing plot on the tab
            ht = findobj(src,'Type','axes');
            delete(ht);
            
            %create base plot
            ax = axes('Parent',src,'Tag','Surface');
            ui = squeeze(u(1,:,:))';
            h = surf(ax,x,y,ui,'EdgeColor','none'); 
            shading interp
            axis ([0 max(x) 0 max(y) 0 max(u,[],'all')])
            h.ZDataSource = 'ui';
            xlabel('X co-ordinate'); 
            ylabel('Y co-ordinate');  
            zlabel('Transport property') 
            
            %animate plot as a function of time
            hold(ax,'on')
            ax.ZLimMode = 'manual';
            for i=2:length(t)
                ui = squeeze(u(i,:,:))'; %#ok<NASGU>
                refreshdata(h,'caller')
                txt1 = sprintf('2-D Diffusion with \x03BD = %g; Courant number in x = %.3f and y = %.3f',...
                                               DiffCoeff,CNx,CNy);
                txt2 = sprintf('Time = %s', string(t(i)));
                title(sprintf('%s\n%s\n %s',casedesc,txt1,txt2))
                drawnow; 
            end
            hold(ax,'off')
            ax.Color = [0.96,0.96,0.96];  %needs to be set after plot
        end         
    end 
%%    
    methods (Access = private)
        function dsp = modelDSproperties(~)
            dsp = struct('Variables',[],'Row',[],'Dimensions',[]);           
            dsp.Variables = struct(...   %cell arrays can be column or row vectors
                'Name',{'u'},...
                'Description',{'Transport property'},...
                'Unit',{'m/s'},...
                'Label',{'Transport property'},...
                'QCflag',{'model'}); 
            dsp.Row = struct(...
                'Name',{'Time'},...
                'Description',{'Time'},...
                'Unit',{'s'},...
                'Label',{'Time (s)'},...
                'Format',{'s'});        
            dsp.Dimensions = struct(...    
                'Name',{'X','Y','Z'},...
                'Description',{'X co-ordinate','Y co-ordinate','Z co-ordinate'},...
                'Unit',{'m','m','m'},...
                'Label',{'X co-ordinate (m)','Y co-ordinate (m)','Z co-ordinate (m)'},...
                'Format',{'-','-','-'});  
        end
    end    
end
