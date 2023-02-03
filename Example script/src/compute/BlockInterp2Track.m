function tracks = BlockInterp2Track(filePath, blockNo, trackingParams)
  %% function tracks = Block2Track_interp(filePath, blockNo, trackingParams)
  % Tracks the bubbles inside the nth frame block according to the tracking parameters.
  %
  %% Inputs
  % * filePath, string[1, 1] : path to .mat file which contains a 'bubbles' variable
  % * blockNo, integer[1, 1] : block number amongst the loaded blocks
  % * trackingParams, struct[1, nProf] : tracking parameters
  %
  %% Outputs
  % * tracks, cell[1, nProf] : each cell is a 1D cell array of an interpolated track
  %                            matrix
  %
  %% Description
  % Block2Track_interp loads a block of frames that is located at filePath and that is
  % the blockNo-th block of an acquisition sequence. This block is then processed
  % according different tracking parameters.
  % At first, the block of frames may be processed with a butterworth filter. Then the
  % bubbles are localized from this block by calling 'ULM_localization2D_interp.m' script.
  % Finally the bubble tracks are computed from their localization in each frame by using
  % 'ULM_tracking2D.m' script and stored in a cell of tracks.
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
  
  % Specify argument class and attributes
  arguments
    filePath (1, 1) string {mustBeFile};
    blockNo (1, 1) {mustBePositive, mustBeInteger};
    trackingParams (1, :) struct;
  end
  
  % Initialize output
  tracks = cell(size(trackingParams));
  
  for iProf = 1:numel(trackingParams)
    % Get tracking parameters
    params = trackingParams(iProf);
    
    % Load data
    dataSource = double(matfile(filePath).(params.varNameInFile));
    
    % Filter the block of frames
    bp = params.bandpass;
    
    if bp.use
      dataSource = filter(bp.rationalTF.denominator, bp.rationalTF.numerator, dataSource, [], 3);
    end
    
    % Localisation in [pixels]
    bubbleLocs = ULM_localization2D_interp(dataSource, params.threshold, params.sigma);
    
    % Tracking in [pixels]
    tracks{iProf} = ULM_tracking2D(bubbleLocs, params);
    
  end
  
end
