function PlotScaleBar(fig, pix2mm)
  %% function PlotScaleBar(fig, pix2mm)
  % Plots a scalebar at the left upper corner of figure.
  %
  %% Inputs
  % * fig, Axes[1, 1] : window in which plot is done
  % * pix2mm, double[1, 2] : pixel size along z and x axis in mm
  %
  %% Description
  % PlotScaleBar plots a scalebar of 5mm at the upper left corner of figure.
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
    pix2mm (1, 2) double;
  end
  
  % Keep current plot
  hold(fig, 'on');
  
  % Plot scale bar
  mm2pix = 1 ./ pix2mm * 5;
  xScaleBar = zeros([2, 2]);
  xScaleBar(:, 1) = [0, mm2pix(1)] + 5;
  xScaleBar(:, 2) = 5;
  plot(fig, xScaleBar(:, 1), xScaleBar(:, 2), 'Color', 'white', 'LineStyle', '-')
  yScaleBar = zeros(2);
  yScaleBar(:, 1) = xScaleBar(1, 1);
  yScaleBar(:, 2) = [0, mm2pix(2)] + 5;
  hold(fig, 'on');
  
  % Plot measurement
  plot(fig, yScaleBar(:, 1), yScaleBar(:, 2), 'Color', 'white', 'LineStyle', '-')
  text(fig, 'String', '5 mm', 'Position', [9, 12], 'HorizontalAlignment', 'left', 'Color', 'white')
  
end
