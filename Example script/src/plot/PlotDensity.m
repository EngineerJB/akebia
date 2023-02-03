function PlotDensity(fig, pix2mm, denMat, sat, expVal, sigma)
  %% function PlotDensity(fig, pix2mm, denMat, sat, expVal, sigma)
  % Plots the density map from 2 density matrices which are highlighted, saturated and
  % smoothed.
  %
  %% Inputs
  % * fig, Axes[1, 1] : window in which plot is done
  % * pix2mm, double[1, 2] : pixel size along z and x axis in mm
  % * denMat, cell[1, 2] : density matrix of 2 tracking profiles
  % * sat, double[1, 2] : percentage used for the saturation of density matrix using
  %                       its corresponding percentile value
  % * expVal, double[1, 2] : exponent value used for highlighting the density matrix
  % * sigma, double[1, 2] : standard deviation for the gaussian filter
  %
  %% Description
  % PlotDensity plots the composite density map of 2 density matrix. First the density
  % matrice are saturated by its percentile value at sat percentage (excluding zeros).
  % Then it is hightlighted by raising it to the power of expVal and is smoothed by a
  % gaussian filter with the standard deviation sigma. Finally the density map is
  % computed from the density matrices using 'imfuse' matlab function.
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
    sat (1, 2) double {mustBeInRange(sat, 0, 100)};
    expVal (1, 2) double {mustBeInRange(expVal, 0, 1)};
    sigma (1, 2) double {mustBeInRange(sigma, 0.1, 2)};
  end
  
  % Display in terminal
  fprintf('Plot density ... ');
  
  % Adjust the density matrices
  for iProf = 1:2
    newMax = prctile(denMat{iProf}(denMat{iProf}(:) ~= 0), 100 - sat(iProf));
    denMat{iProf}(denMat{iProf} > newMax) = newMax;
    denMat{iProf} = imgaussfilt(denMat{iProf}.^expVal(iProf), sigma(iProf));
  end
  
  % Fuse the density matrices
  denMap = imfuse(denMat{:});
  
  % Display density map
  cla(fig, 'reset')
  imshow(denMap, 'Parent', fig);
  axis(fig, 'off');
  PlotScaleBar(fig, pix2mm);
  
  % Display end of function
  disp('done');
end
