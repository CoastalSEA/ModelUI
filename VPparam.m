classdef VPparam < muiPropertyUI           
%
%-------class help------------------------------------------------------===
% NAME
%   VPparam.m
% PURPOSE
%   Class for input properties for the Vertical Profile model
% USAGE
%   obj = PropsInput_template.setPropsInput(mobj); %mobj is a handle to Main UI
% SEE ALSO
%   inherits muiPropertyUI
%
% Author: Ian Townend
% CoastalSEA (c) Jan 2021
%--------------------------------------------------------------------------
%      
    properties (Hidden)
        %abstract properties in muiPropertyUI to define input parameters
        PropertyLabels = {'Bed friction coefficient',...
                          'Nikaurades friction coefficient',...
                          'Tidal period (hours)',...
                          'Roughness length',...
                          'Height of velocity measurement above bed (m)',...
                          'Velocity at depth z (m/s)',...
                          'Water depth (m)','Number of intervals in vertical (-)'};
        %abstract properties in muiPropertyUI for tab display
        TabDisplay   %structure defines how the properties table is displayed 
    end
    
    properties
        cDfriction                %bed friction coefficient
        NKfriction                %Nikaurades friction coefficient
        TidalPeriod               %tidal period (hours)
        Rounghness                %roughness length
        zVelocity                 %height of velocity measurement above bed(m)
        uVelocity                 %velocity at depth z (m/s)
        WaterDepth                %water depth (m)
        nint = 20                 %number of intervals to construct profile
    end    

%%   
    methods (Access=protected)
        function obj = VPparam(mobj) 
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
            classname = 'VPparam';
            obj = getClassObj(mobj,'Inputs',classname);
            if isempty(obj)
                obj = VPparam(mobj);            
            end
            %use muiPropertyUI function to generate UI
            if nargin<2 || editflag
                %add nrec to limit length of props UI (default=12)
                obj = editProperties(obj);  
                %add any additional manipulation of the input here
            end
            setClassObj(mobj,'Inputs',classname,obj);
        end     
    end
%%        
        %add other functions to operate on properties as required   
end