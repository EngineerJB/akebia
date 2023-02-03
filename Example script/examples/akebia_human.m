%% akebia_human.m
% Simple script to track bubbles with a slow and rapid tracking profile on interpolated
% beamformed data
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

%% Load data
varList = "bubbles";                                                        % Name of the data in the .mat file
[fileList, blockSize, warningMsg] = LoadData(varList);                      % Load data
disp(warningMsg);
nFiles = numel(fileList);                                                  % Number of files
if nFiles == 0
  return
end

%% Define tracking profiles
% Acquisition parameters
frameRate = 22;                                                             % [Hz]
xPix2mm = 0.12;                                                             % [mm]
zPix2mm = 0.12;                                                             % [mm]

% Rapid
trackingParams(1) = CreateTrackingProfile(name = 'Rapid', ...               % name of your tracking profile
  dType = 'interp', ...                                                % type of IQ data (no interp for rats, and interp for clinical data)
  threshold = 100, ...                                                    % Intensity threshold for localization [dB]
  maxLinkingDistance = 15, ...                                            % Maximum linking distance between two frames to reject pairing : [pixel units]
  maxGapClosing = 0, ...                                                  % Allowed gap in microbubbles' pairing : [frames]
  minLength = 5, ...                                                      % Minimum allowed length of the tracks in time : [frames]
  sigma = 1, ...                                                          % Smoothing factor for localizaton
  useBandpass = true, ...                                                 % Use or not of butter filter
  bandpassBounds = [1, 5.5], ...                                          % Frequency cutoffs for bandpass filter [Hz]
  frameRate = frameRate, ...                                              % Number of frame per second [Hz]
  xPixelSize = xPix2mm, ...                                               % Width of pixel in [mm]
  zPixelSize = zPix2mm, ...                                               % Height of pixel in [mm]
  blockSize = blockSize, ...                                              % Number of frames in a block [frames]
  varNameInFile = 'bubbles');                                             % Name of the data in the .mat file

% Slow
trackingParams(2) = CreateTrackingProfile(name = 'Slow', ...               % name of your tracking profile
  dType = 'interp', ...                                                % type of IQ data (no interp for rats, and interp for clinical data)
  threshold = 100, ...                                                    % Intensity threshold for localization [dB]
  maxLinkingDistance = 4, ...                                             % Maximum linking distance between two frames to reject pairing : [pixel units]
  maxGapClosing = 0, ...                                                  % Allowed gap in microbubbles' pairing : [frames]
  minLength = 10, ...                                                     % Minimum allowed length of the tracks in time : [frames]
  sigma = 1, ...                                                          % Smoothing factor for localizaton
  useBandpass = false, ...                                                % Use or not of butter filter
  bandpassBounds = [0.05, 1], ...                                         % Frequency cutoffs for bandpass filter [Hz]
  frameRate = frameRate, ...                                              % Number of frame per second [Hz]
  xPixelSize = xPix2mm, ...                                               % Width of pixel in [mm]
  zPixelSize = zPix2mm, ...                                               % Height of pixel in [mm]
  blockSize = blockSize, ...                                              % Number of frames in a block [frames]
  varNameInFile = 'bubbles');                                             % Name of the data in the .mat file

nProfs = numel(trackingParams);                                            % Number of tracking profiles (1 fast and 1 slow in the article)

%% Plot parameters
% Density map
denSig = [0.7, 0.7];                                                        % standard deviation for the smoothing filter
denExp = [0.5, 1];                                                          % exponent value for raising power of density matrices
denSat = [0, 7];                                                            % saturation percentage

% Directivity map
denSatForDirMap = [0, 6];                                                   % saturation percentage for the density matrices
denExpForDirMap = [1/1.8, 1];                                               % exponent value for raising power of density matrices
denSigForDirMap = [0.7, 0.7];                                               % std for the smoothing filter of density matrix
cDirExp = 1/1.3;                                                            % exponent value for raising power of composite directivity matrix
cDirSig = 0.7;                                                              % standard deviation for the smoothing filter of composite directivity mat

% Velocity map
vMaxDisp = 15;                                                              % Maximal velocity in velocity map
cDenSat = 0;                                                                % saturation percentage for the composite density matrix
cVelSig = 0.5;                                                              % std for the smoothing filter of composite density matrix
cDenExp = 1/3;                                                              % exponent value for raising power of composite density matrix

%% Compute tracks
disp('Compute tracks ...')
tracksPerBlock = cell([nFiles, nProfs]);                                    % Total number of tracks, cell of n Files x n tracking profiles

parfor iFile = 1:min(90,nFiles)                                             % parfor when possible to accelerate calculation
  %for iFile = 1:nFiles                                                       % Comment previous line and uncomment this line if you don't know how many workers your computer has
  % for each file : filter, localize and track
  fprintf('File n°%d ...', iFile);
  tracksPerBlock(iFile, :) = BlockInterp2Track(fileList{iFile}, iFile, trackingParams);
  fprintf(' done \n');
end

% Reshape data
gatheredTracks = cell([1, nProfs]);                                         % each row = a file, each column = a tracking profile
for iProf = 1:nProfs
  gatheredTracks{iProf} = vertcat(tracksPerBlock{1:end, iProf});
end


%% Compute mats from tracks
% Construct density MatOut
[denMat, ~,~] = Track2MatOut_multi(gatheredTracks, trackingParams(1).size(1:2));

% Construct directivity and Velocity MatOut
[~, cDirMat, cVelMat] = Track2MatOut_multi({vertcat(gatheredTracks{1}, gatheredTracks{2})}, trackingParams(1).size(1:2));
cDirMat = cDirMat{1};                                                       % Reshape to display
cVelMat = cVelMat{1};                                                       % Reshape to display

%% Plot maps
pix2mm = [zPix2mm, xPix2mm];                                                % Pixel value in [mm]

% Plot density matrix
PlotDensity(axes(figure('Name', 'Density')), pix2mm, denMat(1:2), denSat, denExp, denSig);

% Plot directivity matrix
PlotDirectivity(axes(figure('Name', 'Directivity')), pix2mm, denMat(1:2), denSatForDirMap, denExpForDirMap, denSigForDirMap, cDirMat, cDirExp, cDirSig);

% Plot velocity matrix
cVelMat=cVelMat*xPix2mm;                                                    % convert from pixel/sec to mm/sec
PlotVelocity(axes(figure('Name', 'Velocity')), pix2mm, vMaxDisp, denMat(1:2), cDenSat, cDenExp, cVelMat, cVelSig);
