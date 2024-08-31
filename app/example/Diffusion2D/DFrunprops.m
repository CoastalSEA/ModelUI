classdef DFrunprops < muiPropertyUI
%
%-------class help------------------------------------------------------===
% NAME
%   DFrunprops.m
% PURPOSE
%   Class to manage run time data for Diffusion2D
% USAGE
%   obj = DFrunprops.setRunProps(mobj); %mobj is a handle to Main UI
% SEE ALSO
%   inherits muiPropertyUI
%
% Author: Ian Townend
% CoastalSEA (c)Nov 2020
%--------------------------------------------------------------------------
%
    properties (Hidden)
        %abstract properties in PropertyInterface to define run time variables
        PropertyLabels = {'Duration of time step (s)',...
                          'Number of time steps ',...
                          'Boundary condition (1=Dirichlet,2=Neumann)',...
                          'Numerical Scheme (1=Implicit,2=Explicit)',...
                          'Pseudo-3D output'};
        %abstract properties in PropertyInterface for tab display
        TabDisplay   %structure defines how the property table is displayed 
    end    
    
    properties
        TimeStep = 0.1           %time step duration (seconds)
        NumStep = 100            %number of time steps(-)
        BCoption = 1             %selected boundary condition (1 or 2)  
        NumScheme = 1            %selected numerical scheme (1 or 2)
        is3D = false             %option to output pseudo-3D output
    end      
%%   
    methods (Access=protected)       
        function obj = DFrunprops(mobj)  %instantiate class
            %constructor code:            
            %values defined in UI function setTabProperties used to assign
            %the tabname and position on tab for the data to be displayed
            classname = metaclass(obj).Name;
            obj = setTabProps(obj,mobj,classname);  %muiPropertyUI fcn
            
            %to use non-numeric entries then one can either pre-assign 
            %the values in properties defintion, above, or specity the 
            %PropertyType as a cell array, e.g.:
            % obj.PropertyType = [{'datetime','string','logical'},...
            %                                       repmat({'double'},1,8)];
        end       
    end        
%%
    methods (Static)       
        function setRunProps(mobj,editflag)
            %gui for user to set Run Data Property values
            classname = 'DFrunprops';    %define classname
            obj = getClassObj(mobj,'Inputs',classname);
            if isempty(obj)
                obj = DFrunprops(mobj);        
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
    