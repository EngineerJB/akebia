%% Akebia_example_script.m
% Simple script to track bubbles with a slow and rapid tracking profile on
% beamformed data : choose interpolated or non interpolated in this script.
%
%% Authors: Louise Denis, Jacques Battaglia.
% Directed by Olivier Couture, Research Director CNRS, Sorbonne Université, INSERM.
% Laboratoire d'Imagerie Biomédicale, Team PPM. 15 rue de l'École de Médecine, 75006
% Paris, France.
% CNRS, Sorbonne Université, INSERM.
% Strongly inspired by LOTUS, created by Arthur Chavignon and Baptiste Heiles
%
%% Version
% * Created by Louise Denis and modified by Jacques Battaglia
% * v1.0 - 15.01.2023 - Initial release
%
%% License
% Code Available under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (see https://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%% Academic references to be cited :
% * "Ultrasound Localization Microscopy reveals glomeruli microcirculation in living rats
%   and humans", In prep, 2023.
% * "Performance benchmarking of microbubble-localization algorithms for ultrasound
%   localization microscopy", Nature Biomedical Engineering, 2022.
% * "Ultrasound localization microscopy and super-resolution: A state of the art", IEEE
%   UFFC, 2018.

%% Close and clear workspace
close('all'); clearvars;

%% Add paths
addpath(genpath('./src/')); % Add to your path: your functions folders
addpath(genpath('./lib/')); % and your tools folder
addpath(genpath('./examples')); % and your script folders

%% Interpolated or non interpolated data
Interpolated = 1;

if Interpolated
  akebia_human;
else
  akebia_rat;
end
