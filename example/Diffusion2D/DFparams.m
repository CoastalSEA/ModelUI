classdef DFparams < muiPropertyUI
%
%-------class help------------------------------------------------------===
% NAME
%   DFparam.m
% PURPOSE
%   Class for input parameters used in muitoolbox example to implement the
%   Diffusion2D model
% USAGE
%   obj = DFparams.setParamInput(mobj); %mobj is a handle to Main UI
% SEE ALSO
%   inherits muiPropertyUI
%
% Author: Ian Townend
% CoastalSEA (c)Nov 2020
%--------------------------------------------------------------------------
%
    properties (Hidden)
        %abstract properties in PropertyInterface to define input variables
        PropertyLabels = {'Length of X dimension',...
                          'Length of Y dimension',...
                          'Number of intervals in X dimension',...
                          'Number of intervals in Y dimension',...
                          'Boundary condition at X=0',...
                          'Boundary condition at X=L',...
                          'Boundary condition at Y=0',...
                          'Boundary condition at Y=L',...
                          'Diffusion coefficient',...
                          'Peak disturbance',...
                          'Size of disturbance (0-1)'}      
        %abstract properties in PropertyInterface for tab display
        TabDisplay   %structure defines how the property table is displayed 
    end    
    
    properties
        Xlength             %Length of X dimension (m)
        Ylength             %Length of Y dimension', (m)
        Xint                %Number of intervals in X dimension
        Yint                %Number of intervals in Y dimension
        uWest = 0;          %Boundary condition at X=0
        uEast = 0;          %Boundary condition at X=L
        uNorth = 0;         %Boundary condition at Y=0
        uSouth = 0;         %Boundary condition at Y=L
        DiffCoeff           %Diffusion coefficient (-) 
        uPeak               %magnitude of initial distrubance
        PkSize              %proportion of X and Y that is disturbed        
    end
%%   
    methods (Access=protected)       
        function obj = DFparams(mobj)  %instantiate class
            %constructor code:            
            %values defined in UI function setTabProperties used to assign
            %the tabname and position on tab for the data to be displayed
            classname = metaclass(obj).Name;
            obj = setTabProps(obj,mobj,classname);  %PropertyInterface fcn
            
            %to use non-numeric entries then one can either pre-assign 
            %the values in properties defintion, above, or specity the 
            %PropertyType as a cell array, e.g.:
            % obj.PropertyType = [{'datetime','string','logical'},...
            %                                       repmat({'double'},1,8)];
        end       
    end
%%
    methods (Static)     
        function setParamInput(mobj,editflag)
            %gui for user to set Input Data Property values
            classname = 'DFparams';    %define classname
            if isfield(mobj.Inputs,classname) && ...
                            isa(mobj.Inputs.(classname),classname)
                obj = mobj.Inputs.(classname);  
            else
                obj = DFparams(mobj);  %instanstiate class instance
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
    