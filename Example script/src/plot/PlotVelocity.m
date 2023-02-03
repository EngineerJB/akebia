function PlotVelocity(fig, scalePix, vMaxDisp, denMat, cDenSat, cDenExp, cVelMat, cVelSig)
  %% function PlotVelocity(fig, scalePix, vMaxDisp, denMat, cDenSat, cDenExp, cVelMat,
  %%                       cVelSig)
  % Plots the velocity map from a saturated, normalized and highlighted composite density
  % matrix made from 2 density matrices, and a composite velocity matrix that is
  % normalized and smoothed.
  %
  %% Inputs
  % * fig, Axes[1, 1] : window in which plot is done
  % * scalePix, double[1, 2] : pixel size along z and x axis in mm
  % * vMaxDisp, double[1, 1] : maximal velocity displayed in mm/sec
  % * denMat, cell[1, 2] : density matrix of 2 tracking profiles
  % * cDenSat, double[1, 1] : percentage used for the saturation of the composite density
  %                           matrix using its corresponding percentile value
  % * cDenExp, double[1, 1] : exponent value used for highlighting the composite density
  %                           matrix
  % * cVelMat, double[height, width] : composite velocity matrix
  % * cVelSig, double[1, 1] : standard deviation for the gaussian filter applied to
  %                           composite velocity matrix
  %
  %% Description
  % PlotVelocity plots the composite velocity map using 2 density matrix and a
  % composite velocity matrix. First the composite density matrix is computed by summing
  % the density matrices, then the composite density matrix is saturated by its
  % percentile value at cDenSat percentage (excluding zeros), normalized and hightlighted
  % by raising it to the power of cDenExp. Secondly, the composite velocity matrix is
  % normalized by vMaxDisp and smoothed by a gaussian filter with the standard deviation
  % cVelSig. Finally the velocity map is computed and plotted from those 2 matrices.
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
  
  % Specify arguments types and sizes
  arguments
    fig (1, 1) {mustBeA(fig, ["matlab.ui.control.UIAxes", "matlab.graphics.axis.Axes"])};
    scalePix (1, 2) double {mustBePositive, mustBeFinite};
    vMaxDisp (1, 1) double {mustBePositive};
    denMat (1, 2) cell;
    cDenSat (1, 1) double {mustBeInRange(cDenSat, 0, 100)};
    cDenExp (1, 1) double {mustBeInRange(cDenExp, 0, 1)};
    cVelMat (:, :) double {mustBeFinite};
    cVelSig (1, 1) double {mustBePositive};
  end
  
  % Display in terminal
  fprintf('Plot velocity ... ');
  
  % Adjust the composite density matrix
  clbsize = [180, 50];
  cDenMat = denMat{1} + denMat{2};
  newMax = prctile(cDenMat(cDenMat(:) ~= 0), 100 - cDenSat);
  cDenMat(cDenMat > newMax) = newMax;
  cDenMat = cDenMat ./ max(cDenMat, [], 'all');
  cDenMat(1:clbsize(1), 1:clbsize(2)) = repmat(linspace(0, 1, clbsize(2)), clbsize(1), 1);
  cDenMat = cDenMat.^cDenExp;
  
  % Adjust the composite velocity matrix
  cVelMat = cVelMat / vMaxDisp;
  cVelMat (1:clbsize(1), 1:clbsize(2)) = repmat(linspace(1, 0, clbsize(1))', 1, clbsize(2));
  cVelMat = cVelMat.^(1/1.5);
  cVelMat(cVelMat > 1) = 1;
  cVelMat = imgaussfilt(cVelMat, cVelSig);
  
  % Compute the velocity map
  velMap = ind2rgb(round(cVelMat * 256), jet(256)) .* cDenMat;
  
  % Plot the cVelMat map
  cla(fig, 'reset');
  imshow(velMap, 'Parent', fig);
  title(fig, ['Velocity [0-', num2str(vMaxDisp), '] mm/sec'])
  PlotScaleBar(fig, scalePix);
  
  % Display end of function
  disp('done');
  
end
