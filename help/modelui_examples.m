%% ModelUI Examples
% A number of models are provided to illustrate a range of possible
% applications. This requires the ModelUI App to be installed.
% The details of each model set-up are given in the 
% <matlab:open_manual manual>. The files for the demonstration models can be found in
% the example folder <matlab:example_folder here>. The models are:
%%
% * Vertical Profile - model to compute vertical structure of tidal
% currents using several different eddy viscosity formulations.
% * Simple tide - a tide emulator to output a synthetic data set of
% elevations or velocities.
% * 2D Diffusion - implements the 2-D Diffusion equation to illustrate the
% handling of multi-dimensional variables and the underlying model is from 
% the Matlab (c) Forum by Suraj Shanka, Copyright (c) 2012.
%%
% ModelUI implements the _Vertical Profile_ model and illustrates a model with
% several output variables that are a funciton of one space dimension. 
%%
% _Simple Tide_ inherits ModelUI and modifies the calls to the particualar 
% application (see <matlab:doc('modelui_gettingstarted') Getting Started> for
% details of how to do this).
%%
% _2D Diffusion_ implements the muiModelUI interface and has a similar 
% layout to the ModelUI implementation of the muiModelUI interface.
% Implementing the muiModelUI interface, rather than simiply inheriting 
% the ModelUI implementation, provides a greater ability to customise the 
% interface to meet the specific needs of an application. ModelUI Apps, 
% such as CoastalTools and Asmita provide examples of more comple UIs. 
% Details of how to implement a bespoke user interface are detailed in 
% the <matlab:open_manual manual>.
%%
% The use of manipulation of model output, using the Run>Derive Output menu option to
% launch the muiManipUI, is illustrated by the function userderivedoutput.m, 
% which can be found in the ModelUI/example/Diffusion2D folder. 

 
