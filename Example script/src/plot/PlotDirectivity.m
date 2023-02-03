function PlotDirectivity(fig, pix2mm, denMat, denSat, denExp, denSig, cDirMat, cDirExp, cDirSig)
  %% function PlotDirectivity(fig, pix2mm, denMat, denSat, denExp, denSig, cDirMat,
  %%                          cDirExp, cDirSig)
  % Plots the directivity map from 2 saturated, highlighted and smoothed density matrices
  % and a smoothed composite directivity matrix.
  %
  %% Inputs
  % * fig, Axes[1, 1] : window in which plot is done
  % * pix2mm, double[1, 2] : pixel size along z and x axis in mm
  % * denMat, cell[1, 2] : density matrix of 2 tracking profiles
  % * denSat, double[1, 2] : percentage used for the saturation of density matrix using
  %                          its corresponding percentile value
  % * denExp, double[1, 2] : exponent value used for highlighting the density matrix
  % * denSig, double[1, 2] : standard deviation for the gaussian filter applied to
  %                          density matrix
  % * cDirMat, double[height, width] : composite directivity matrix
  % * cDirExp, double[1, 1] : exponent value used for highlighting the directivity map
  % * cDirSig, double[1, 1] : standard deviation for the gaussian filter applied to
  %                           directivity matrix
  %% Description
  % PlotDirectivity plots the composite directivity map using 2 density matrix and a
  % composite directivity matrix. First the density matrice are saturated by its
  % percentile value at denSat percentage (excluding zeros). Then it is hightlighted
  % by raising it to the power of expVal and is smoothed by a gaussian filter with
  % the standard deviation denSig. Finally the directivity map is computed by summing
  % the 2 density matrices, raising the power of the sum to cDirExp and multiplying
  % the result by the sign of the smoothed directivity matrix.
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
    fig (1, 1) {mustBeA(fig, ["matlab.ui.control.UIAxes", "matlab.graphics.axis.Axes"])};
    pix2mm (1, 2) double {mustBePositive, mustBeFinite};
    denMat (1, 2) cell;
    denSat (1, 2) double {mustBeInRange(denSat, 0, 100)};
    denExp (1, 2) double {mustBeInRange(denExp, 0, 1)};
    denSig (1, 2) double {mustBePositive};
    cDirMat (:, :) double {mustBeFinite};
    cDirExp (1, 1) double {mustBeInRange(cDirExp, 0, 1)};
    cDirSig (1, 1) double {mustBePositive};
  end
  
  % Display in terminal
  fprintf('Plot directivity ... ');
  
  % Adjust the density matrices
  for iProf = 1:2
    newMax = prctile(denMat{iProf}(denMat{iProf}(:) ~= 0), 100 - denSat(iProf));
    denMat{iProf}(denMat{iProf} > newMax) = newMax;
    denMat{iProf} = imgaussfilt(denMat{iProf}.^denExp(iProf), denSig(iProf));
  end
  
  % Compute the directivity map
  dirMap = (denMat{1} + denMat{2}).^cDirExp .* sign(imgaussfilt(cDirMat, cDirSig));
  
  % Plot the directivity map
  cla(fig, 'reset');
  imgHandle = imagesc(fig, dirMap);
  imgHandle.CData = imgHandle.CData - sign(imgHandle.CData) / 2;
  cc = caxis(fig);
  axis(fig, "off");
  cla(fig, 'reset');
  imshow(dirMap, 'Parent', fig);
  velColormap = cat(1, flip(flip(hot(128), 1), 2), hot(128));
  velColormap = velColormap(5:end - 5, :);
  colormap(fig, velColormap);
  caxis(fig, [-1, 1] * max(cc));
  PlotScaleBar(fig, pix2mm);
  
  % Display end of function
  disp('done');
  
end
