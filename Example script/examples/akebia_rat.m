%% akebia_rat.m
% Simple script to track bubbles with a slow and rapid tracking profile on
% non-interpolated beamformed data
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
varList = "IQ";                                                 % Name of the data in the .mat file
[fileList, blockSize, warningMsg] = LoadData(varList);                      % Load data
disp(warningMsg);
nFiles = length(fileList);                                                  % Number of files
if nFiles == 0
  return
end

%% Define tracking profiles
% Acquisition parameters
frameRate = 500;                                                            % [Hz]
xPix2Lambda = 0.52;                                                         % [λ]
zPix2Lambda = 0.5;                                                          % [λ]
transmitFreq = 15;                                                          % [MHz]
speedOfSound = 1540;                                                        % [m/s]
lambda2mm = (speedOfSound * 1e3) / (transmitFreq * 1e6);                    % [mm]
res = 2.5;                                                                  % [without unit]

% Rapid
trackingParams(1) = CreateTrackingProfile(name = 'Rapid', ...               % name of your tracking profile
  dType = 'nointerp', ...                                              % type of IQ data (no interp for rats, and interp for clinical data)
  numberOfParticles = 200, ...                                            % estimated number of microbubbles localized in one frame
  maxGapClosing = 0, ...                                                  % number of [frames] jumped to pair 2 microbubbles
  minLength = 20, ...                                                     % minimum duration of the track [frames]
  maxLinkingDistance = 1.5, ...                                           % distance between 2 microbubbles to be paired [pixel unit], here [λ]
  res = res, ...                                                          % resolution factor, factor that multiplies initial grid size [without unit]
  fwhm = [5, 5], ...                                                      % Size [pixel] of the mask for localization. (3x3 for pixel at lambda, 5x5 at lambda/2). [fmwhz fmwhx]
  locMethod = 'radial', ...                                               % Localization method, see LOTUS
  useBandpass = false, ...                                                % Use or not of butter filter
  bandpassBounds = [20, 90], ...                                          % Threshold for bandpass filter [Hz]
  useSVD = true, ...                                                      % Use or not of SVD
  svdBounds = [40, 800], ...                                              % Threshold for SVD filter [eigen values]
  varNameInFile = 'IQ', ...                                               % Name of the file for "Rapid" profile tracking
  frameRate = frameRate, ...                                              % Number of frame per second [Hz]
  xPixelSize = xPix2Lambda, ...                                           % With of pixel in [λ]
  zPixelSize = zPix2Lambda, ...                                           % Height of pixel in [λ]
  speedOfSound = speedOfSound, ...                                        % Speed of sound in media [m/sec]
  transmitFreq = transmitFreq, ...                                        % Frequency of the transducer [MHz]
  blockSize = blockSize);                                                 % Number of frames in a block [frames]

% Slow
trackingParams(2) = CreateTrackingProfile(name = 'Slow', ...                % name of your tracking profile
  dType = 'nointerp', ...                                              % type of IQ data (no interp for rats, and interp for clinical data)
  numberOfParticles = 400, ...                                            % estimated number of microbubbles localized in one frame
  maxGapClosing = 0, ...                                                  % number of [frames] jumped to pair 2 microbubbles
  minLength = 20, ...                                                     % duration of the track [frames]
  maxLinkingDistance = 0.8, ...                                           % distance between 2 microbubbles to be paired [pixel unit], here [λ]
  res = res, ...                                                          % resolution factor, factor that multiplies initial grid size [without unit]
  fwhm = [5, 5], ...                                                      % Size [pixel] of the mask for localization. (3x3 for pixel at lambda, 5x5 at lambda/2). [fmwhz fmwhx]
  locMethod = 'radial', ...                                               % Localization method, see LOTUS
  useBandpass = true, ...                                                % Use or not butter filter
  bandpassBounds = [5, 80], ...                                          % Threshold for bandpass filter [Hz]
  useSVD = true, ...                                                     % Use or not of SVD
  svdBounds = [10, 800], ...                                               % Threshold for SVD filter [eigen values]
  varNameInFile = 'IQ', ...                                           % Name of the file for "Slow" profile tracking
  frameRate = frameRate, ...                                              % Number of frame per second [Hz]
  xPixelSize = xPix2Lambda, ...                                           % With of pixel in [λ]
  zPixelSize = zPix2Lambda, ...                                           % Height of pixel in [λ]
  speedOfSound = speedOfSound, ...                                        % Speed of sound in media [m/sec]
  transmitFreq = transmitFreq, ...                                        % Frequency of the transducer [MHz]
  blockSize = blockSize);                                                 % Number of frames in a block [frames]

nProfs = numel(trackingParams);                                            % Number of tracking profiles (1 fast and 1 slow in the article)

%% Define plot parameters
% Density map
denSig = [0.5, 0.5];                                                        % Smooth factor for both tracking profile
denExp = [0.5, 1];                                                          % Power factor for both tracking profile
denSat = [0, 2.5];                                                          % Saturation for both tracking profile

% Directivity map
denSatForDirMap = [0, 2.5];                                                 % Saturation for both tracking profile
denExpForDirMap = [1/1.8, 1];                                               % Power factor for both tracking profile
denSigForDirMap = [0.7, 0.7];                                               % Smooth factor for both tracking profile
cDirExp = 1/1.2;                                                            % Power factor for total directivity map
cDirSig = 0.7;                                                              % Smooth factor for total directivity map

% Velocity map
vMaxDisp = 20;                                                              % Maximum velocity [mm/sec] to normalize with
cDenSat = 0;                                                                % Saturation for total velocity map
cVelSig = 0.5;                                                              % Smooth for total velocity map
cDenExp = 1/3;                                                              % Power for total velocity map

%% Compute tracks
disp('Compute tracks ...')
tracksPerBlock = cell([nFiles, nProfs]);                                    % Total number of tracks, cell of n Files x n tracking profiles

parfor iFile = 1:min(90, nFiles)                                            % parfor when possible to accelerate calculation
  % for iFile = 1:nFiles                                                       % Comment previous line and uncomment this line if you don't know how many workers your computer has
  % for each file : filter, localize and track
  fprintf('File n°%d ...', iFile);
  tracksPerBlock(iFile, :) = BlockNoInterp2Track(fileList{iFile}, trackingParams);
  fprintf(' done \n');
end

% Reshape data
gatheredTracks = cell([1, nProfs]);                                         % each row = a file, each column = a tracking profile
for iProf = 1:nProfs
  gatheredTracks{iProf} = vertcat(tracksPerBlock{1:end, iProf});
end

%% Compute mats from tracks
% Construct density MatOut
[denMat, ~, ~] = Track2MatOut_multi(gatheredTracks, trackingParams(1).SRsize(1:2));

% Construct directivity and Velocity MatOut
[~, cDirMat, cVelMat] = Track2MatOut_multi({vertcat(gatheredTracks{1}, gatheredTracks{2})}, trackingParams(1).SRsize(1:2));
cDirMat = cDirMat{1};                                                       % Reshape to display
cVelMat = cVelMat{1};                                                       % Reshape to display

%% Plot maps
Spix2mm = [zPix2Lambda, xPix2Lambda] * lambda2mm / res;                     % SuperPixel value in [mm]

% Plot density matrix
PlotDensity(axes(figure('Name', 'Density')), Spix2mm, denMat(1:2), denSat, denExp, denSig);

% Plot directivity matrix
PlotDirectivity(axes(figure('Name', 'Directivity')), Spix2mm, denMat(1:2), denSatForDirMap, denExpForDirMap, denSigForDirMap, cDirMat, cDirExp, cDirSig);

% Plot velocity matrix
cVelMat=cVelMat*lambda2mm;                                                  % convert from lambda/sec to mm/sec
PlotVelocity(axes(figure('Name', 'Velocity')), Spix2mm, vMaxDisp, denMat(1:2), cDenSat, cDenExp, cVelMat, cVelSig);
