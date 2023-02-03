function tracks = BlockNoInterp2Track(filePath, trackingParams)
  %% function tracks = Block2Track_nointerp(filePath, trackingParams)
  % Tracks the bubbles inside a not-interpolated frame block according to the tracking parameters.
  %
  %% Inputs
  % * filePath, string[1, 1] : path to .mat file
  % * trackingParams, struct[1, nProf] : tracking parameters
  %
  %% Outputs
  % * tracks, cell[1, nProf] : each cell is a 1D cell array of a track matrix
  %
  %% Description
  % Block2Track_nointerp loads a block of frames that is located at filePath.
  % At first, the block of frames may be processed with a svd and a butterworth filter.
  % Then the bubbles are localized from this block by calling 'ULM_localization2D.m' function.
  % Finally the bubble tracks are computed from their localization in each frame by using
  % 'ULM_tracking2D.m' function and stored in a cell of tracks.
  %
  % See also "https://github.com/AChavignon/PALA"
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
    trackingParams (1, :) struct;
  end
  
  % Initialize output
  tracks = cell(size(trackingParams));
  
  for iProf = 1:numel(trackingParams)
    % Get tracking parameters
    params = trackingParams(iProf);
    
    % Load data
    dataSource = double(matfile(filePath).(params.varNameInFile));
    
    % SVD filter
    if params.svd.use
      dataSource = SVDfilter(dataSource, params.svd.bounds);
    end
    
    % Temporal filter
    bp = params.bandpass;
    
    if bp.use
      dataSource = filter(bp.rationalTF.denominator, bp.rationalTF.numerator, dataSource, [], 3);
    end
    
    dataSource(~isfinite(dataSource)) = 0;
    
    % Localisation in [pixels]
    Locs = ULM_localization2D(abs(dataSource), params);
    
    % Convert the localisation from [pixels] to [λ]
    Locs(:, 2:3) = (Locs(:, 2:3) - [1, 1]) .* params.scale(1:2);
    
    % Tracking in [λ]
    tracks{iProf} = ULM_tracking2D(Locs, params);
    
    % Convert z,x from lambdas to superpixels [0.2λ]
    tracks{iProf} = cellfun(@(track) horzcat((track(:, [1 2]) + [1, 1]) / params.SRscale, track(:, 3:end)), ...
      tracks{iProf}, 'UniformOutput', 0);
    
  end
  
end
