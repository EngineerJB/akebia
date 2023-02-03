function locs = ULM_localization2D_interp(frameBlock, threshold, sigma)
  %% function locs = ULM_localization2D_interp(frameBlock, trackParams)
  % Locates the bubbles whose intensity reachs a threshold inside a block of smoothed
  % frames.
  %
  %% Inputs
  % * frameBlock, complex or double[height, width, nFrames] : block of frames
  % * threshold, double[1, 1] : bubble intensity threshold in dB
  % * sigma, double[1, 1] : standard deviation of gaussian filter
  %
  %% Outputs
  % * locs, double[nParticles * nFrames, 4] : bubble position matrix whose columns are
  %                                           intensity, pixel position along z and x,
  %                                           and frame number
  %
  %% Description
  % ULM_localization2D_interp identifies the regonal maxima in each frame by smoothing it
  % with a gaussian filter and selects the bubbles for which the intensity is greater
  % than a threshold. Finally it stores the bubbles parameters inside a matrix.
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
    frameBlock {validateattributes(frameBlock, 'numeric', {'3d', 'nonempty', 'finite', 'nonnan'})};
    threshold (1, 1) double;
    sigma (1, 1) double;
  end
  
  % Initialize output
  locs = cell(1, size(frameBlock, 3));
  
  for iFrame = 1:size(frameBlock, 3)
    % Extract the frame of block
    frame = frameBlock(:, :, iFrame);
    
    % Mark the bubble intensity that is greater than a threshold
    isABubble = imregionalmax(imgaussfilt(frame, sigma)) .* frame;
    isABubble = (isABubble >= threshold);
    
    % Extract the bubble intensity
    intensity = frame(isABubble);
    
    % Locate the bubbles which corresponds to 1 in binary matrix
    [zPos, xPos] = find(isABubble);
    
    % Create a time index for the located bubbles
    frameNo = iFrame * ones(size(zPos));
    
    % Store the result
    locs{iFrame} = horzcat(intensity, zPos, xPos, frameNo);
  end
  
  locs = vertcat(locs{:});
end
