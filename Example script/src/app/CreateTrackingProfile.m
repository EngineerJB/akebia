function trackingParams = CreateTrackingProfile(options)
  %% function trackingParams = CreateTrackingProfile(options)
  % Create a tracking profile from the inputted parameters.
  %
  % Inputs
  % * name, string[1, 1] : name of tracking profile
  % * frameRate, double[1, 1] : frame rate in Hz
  % * varNameInFile, string[1, 1] : variable name inside the data files
  % * blockSize, double[1, 3] : frame block dimensions
  % * dType, string[1, 1] : type of data (interp or nointerp)
  % * xPixelSize, double[1, 1] : pixel size along x in user specified units
  % * zPixelSize, double[1, 1] : pixel size along z in user specified units
  % * maxLinkingDistance, double[1, 1] : Maximum linking distance between two frames to
  %                                      reject pairing in the same units as xPixelSize
  %                                      and zPixelSize
  % * minLength, double[1, 1] : Minimum allowed length of the tracks in frames
  % * maxGapClosing, double[1, 1] : Allowed gap for microbubbles' pairing in frames
  % * useBandpass, logical[1, 1] : flag allows the use of bandpass filtering of
  %                                beamformed data
  % * bandpassBounds, double[1, 1] : bandpass cutoff frequencies in Hz
  %
  %% Outputs
  % * fileList, cell[1, nFiles] : each cell is a filepath to a valid .mat file
  % * blockSize, double[1, 3] : frame block dimensions
  % * warningMsg, string[1, nWarnings] : warning message
  %
  %% Description
  % CreateTrackingProfile create a tracking profile suited from the input parameters
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
  % * "Sensing Ultrasound Localization Microscopy for the visualization of glomeruli in living rats
  %   and humans", In prep, 2023.
  % * "Performance benchmarking of microbubble-localization algorithms for ultrasound
  %   localization microscopy", Nature Biomedical Engineering, 2022.
  % * "Ultrasound localization microscopy and super-resolution: A state of the art", IEEE
  %   UFFC, 2018.
  
  % Specify argument types and attributes
  arguments
    options.varNameInFile (1, 1) string {mustBeNonempty};
    options.blockSize (1, 3) double {mustBeInteger};
    options.name (1, 1) string {mustBeNonempty, mustBeValidVariableName};
    options.dType (1, 1) string {mustBeNonempty, mustBeMember(options.dType, {'interp', 'nointerp'})};
    
    options.frameRate (1, 1) double {mustBeNonempty, mustBePositive}; % [Hz]
    options.xPixelSize (1, 1) double {mustBeNonempty, mustBePositive}; % [pixel units]
    options.zPixelSize (1, 1) double {mustBeNonempty, mustBePositive}; % [pixel units]
    
    options.maxLinkingDistance (1, 1) double {mustBeNonempty}; % [pixel units]
    options.minLength (1, 1) double {mustBeNonempty}; % [frames]
    options.maxGapClosing (1, 1) double {mustBeNonempty}; % [frames]
    
    options.res (1, 1) double {mustBeNonempty, mustBePositive} = 1; % [1]
    
    options.useBandpass (1, 1) logical{mustBeNonempty};
    options.bandpassBounds (1, 2) double {mustBeNonempty}; % [Hz]
    
    options.threshold (1, 1) double {mustBeNonempty, mustBePositive}; % [dB]
    options.sigma (1, 1) double {mustBePositive}; % [1]
    
    options.numberOfParticles (1, 1) double {mustBeInteger};
    options.fwhm (1, 2) double {mustBeInteger};
    options.locMethod (1, 1) string {mustBeMember(options.locMethod, {'radial', 'nolocalization', 'wa', 'curvefitting', 'interp-triangle', 'interp-cubic', 'interp-lanczos3'})};
    options.useSVD (1, 1) logical;
    options.svdBounds (1, 2) double {mustBePositive, mustBeInteger}; % must be adapted to block size
    options.nLocalMax (1, 1) double {mustBeInteger, mustBePositive};
    options.snrMin (1, 1) double {mustBePositive}; % Minimal SNR detection : [dB]
    options.transmitFreq (1, 1) double {mustBePositive}; % [MHz]
    options.speedOfSound (1, 1) double {mustBePositive}; % [m / s]
  end
  
  if strcmp(options.dType, 'interp')
    neededFields = ["threshold", "sigma"];
  elseif strcmp(options.dType, 'nointerp')
    neededFields = ["numberOfParticles", "fwhm", "locMethod", "useSVD", "svdBounds", ...
      "transmitFreq", "speedOfSound"];
  end
  
  for paramName = neededFields
    mustBeNonempty(options.(paramName));
  end
  
  % Create tracking profile
  trackingParams = rmfield(options, {'maxLinkingDistance', 'blockSize', 'minLength', 'maxGapClosing', 'useBandpass', 'bandpassBounds'});
  
  % Rename field for sULM
  trackingParams.max_linking_distance = options.maxLinkingDistance;
  trackingParams.max_gap_closing = options.maxGapClosing;
  trackingParams.min_length = options.minLength;
  trackingParams.size = options.blockSize;
  trackingParams.scale = [options.zPixelSize, options.xPixelSize, 1 / options.frameRate]; %[pixel units, pixel units, s]
  
  % Compute the bandpass filter
  mustBeInRange(options.bandpassBounds, 0, options.frameRate, "exclusive");
  trackingParams.bandpass.use = options.useBandpass;
  trackingParams.bandpass.cutoffFrequencies = options.bandpassBounds;
  [rTF.denominator, rTF.numerator] = butter(1, options.bandpassBounds / (options.frameRate / 2), 'bandpass');
  trackingParams.bandpass.rationalTF = rTF;
  
  % Add fields for not interpolated data
  if strcmp(options.dType, 'nointerp')
    trackingParams.speedOfSound = options.speedOfSound;
    trackingParams.transmitFreq = options.transmitFreq;
    trackingParams.lambda2mm = (trackingParams.speedOfSound * 1e3) / (trackingParams.transmitFreq * 1e6);
    trackingParams.Spix2mm = trackingParams.scale(1:2) * trackingParams.lambda2mm / trackingParams.res;
    trackingParams.SRscale = trackingParams.scale(1) / trackingParams.res;
    trackingParams.SRsize = round(trackingParams.size(1:2) .* trackingParams.scale(1:2) / trackingParams.SRscale);
    trackingParams.svd.use = options.useSVD;
    mustBeInRange(options.svdBounds, 1, options.blockSize(3));
    trackingParams.svd.bounds = options.svdBounds;
    trackingParams.parameters.NLocalMax = 9;
    trackingParams.SNRmin = 2;
  end
  
  % Add fields for interpolated data
  if strcmp(options.dType, 'interp')
    trackingParams.pix2mm = trackingParams.scale(1:2);
  end
  
end
