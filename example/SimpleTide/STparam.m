classdef STparam < muiPropertyUI                
%
%-------class help------------------------------------------------------===
% NAME
%   STparam.m
% PURPOSE
%   Class for input parameters for the SimpleTide model
% USAGE
%   obj = STparam.setParamInput(mobj); %mobj is a handle to Main UI
% SEE ALSO
%   inherits muiPropertyUI
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
%      
    properties (Hidden)
        %abstract properties in muiPropertyUI to define input parameters
        PropertyLabels = {'Duration (d)','Time interval (mins)'...
                          'Mean tide level (mOD)',...
                          'Tidal amplitude (m)',...
                          'Elevation phase (deg)',...
                          'Velocity amplitude (m/s)',...
                          'Velocity phase (deg)',...
                          'M2 tidal amplitude (m)',...
                          'S2 tidal amplitude (m)',...
                          'O1 tidal amplitude (m)'};
        %abstract properties in muiPropertyUI for tab display
        TabDisplay   %structure defines how the property table is displayed 
    end
    
    properties
        Duration                  %duration (days)
        Tinterval                 %time interrval for simulation (mins)
        z0                        %mean tidel level to ordnance datum (mOD)
        TidalAmp                  %tidal elevation amplitude (m)
        ElevPhase                 %phase of elevation (ie k.x) (rads)
        VelocityAmp               %tidal velocity amplitude (m/s)
        VelocityPhase             %phase of velocity (ie k.x+phi) (rads)
        aM2                       %M2 tidal amplitude (m)
        aS2                       %S2 tidal amplitude (m)
        aO1                       %O1 tidal amplitude (m) 
    end    

%%   
    methods (Access=protected)
        function obj = STparam(mobj)            
            %constructor code:            
            %values defined in UI function setTabProperties used to assign
            %the tabname and position on tab for the data to be displayed
            obj = setTabProps(obj,mobj);  %muiPropertyUI fcn
            
            %to use non-numeric entries then one can either pre-assign 
            %the values in properties defintion, above, or specity the 
            %PropertyType as a cell array, e.g.:
            % obj.PropertyType = [{'datetime','string','logical'},...
            %                                       repmat({'double'},1,8)];
        end 
    end
%%  
    methods (Static)  
        function obj = setInput(mobj,editflag)
            %gui for user to set Parameter Input values
            classname = 'STparam';           
            if isfield(mobj.Inputs,classname) && ...
                            isa(mobj.Inputs.(classname),classname)
                obj = mobj.Inputs.(classname);  
            else
                obj = STparam(mobj);            
            end
            %use muiPropertyUI function to generate UI
            if nargin<2 || editflag
                %add nrec to limit length of props UI (default=12)
                obj = editProperties(obj);  
                %add any additional manipulation of the input here
            end
            mobj.Inputs.(classname) = obj;
        end     
    end
%%        
        %add other functions to operate on properties as required   
end