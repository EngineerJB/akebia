function [denMat, dirMat, velMat] = Track2MatOut_multi(tracks, gridSize)
  %% function [denMat, dirMat, velMat] = Track2MatOut_multi(tracks, gridSize)
  % Computes the density, directivity and velocity matrices whose dimensions are gridSize
  % from the tracks.
  %
  %% Inputs
  % * tracks, cell[1, nProf] : each cell is the tracks computed for a tracking profile
  % * gridSize, double[1, 2] : matrice dimensions for denMat, dirMat and velMat
  %
  %% Outputs
  % * denMat, cell[1, nProf] : each cell is a density matrix whose dimensions are
  %                            gridSize for a tracking profile
  % * dirMat, cell[1, nProf] : each cell is a directivity matrix whose dimensions are
  %                            gridSize for a tracking profile
  % * velMat, cell[1, nProf] : each cell is a velocity matrix whose dimensions are
  %                            gridSize for a tracking profile
  %
  %% Description
  % Track2MatOut_multi computes the density, directivity and velocity matrix from each
  % cell of tracks. The dimensions of those matrices are gridSize and are stored
  % respectively in a cell of denMat, dirMat and velMat.
  % Matout are constructed by calling 'ULM_Track2MatOut.m' function.
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
    tracks (1, :) cell {mustBeNonempty};
    gridSize (1, 2) {mustBeNonempty, mustBeInteger, mustBePositive};
  end
  
  % Initialize outputs
  denMat = cell(size(tracks));
  dirMat = cell(size(tracks));
  velMat = cell(size(tracks));
  
  for iProf = 1:numel(tracks)
    % Convert tracks into density map
    denMat{iProf} = ULM_Track2MatOut(tracks{iProf}, gridSize);
    
    % Convert tracks into directivity map
    dirMat{iProf} = ULM_Track2MatOut(tracks{iProf}, gridSize, 'mode', '2D_vel_z');
    
    % Convert tracks into velocity map
    velMat{iProf} = ULM_Track2MatOut(tracks{iProf}, gridSize, 'mode', '2D_velnorm');
  end
  
end
