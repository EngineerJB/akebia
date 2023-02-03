function [fileList, blockSize, warningMsg] = LoadData(varList)
  %% function [fileList, blockSize, warningMsg] = LoadData(varList)
  % Allows the user to select .mat files having a list of variables of same dimensions.
  %
  %% Outputs
  % * fileList, cell[1, nFiles] : each cell is a filepath to a valid .mat file
  % * blockSize, double[1, 3] : frame block dimensions
  % * warningMsg, string[1, nWarnings] : warning message
  %
  %% Description
  % LoadData allows the user to select frame block files containing the variables
  % listed in varList. It filters the files so that the variable dimensions are
  % uniform amongst the selected files and returns a warning message.
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
    varList (1, :) string {mustBeNonempty};
  end
  
  % Initialize outputs
  blockSize = [];
  warningMsg = [];
  
  % Select the '.mat' files from explorer
  fprintf('Choose files ... ');
  [fileList, path] = uigetfile('.mat', 'MultiSelect', 'on');
  
  % Return if no file was selected
  if isequal(fileList, 0)
    fileList = {};
    warningMsg = "No file was selected";
    return
  end
  
  % Cast to cell if there is only 1 selection
  if ischar(fileList)
    fileList = {fileList};
  end
  
  % Append path to fileList
  fileList = fullfile(path, fileList);
  
  % Keep files containing the variables
  containsVars = cellfun(@(filePath) all(ismember(varList, who(matfile(filePath)))), fileList);
  if any(~containsVars)
    warningMsg = horzcat(warningMsg, sprintf("Some files were removed since they didn't contain : %s", join(varList, ', ')));
  end
  
  fileList = fileList(containsVars);
  if isempty(fileList)
    return
  end
  
  % Get blockSize from the 1st variable of the 1st file
  blockSize = size(matfile(fileList{1}), char(varList(1)));
  
  % Keep file containing the same z,x block size
  varsHasSameSize = false(size(fileList));
  for iFile = 1:numel(fileList)
    varHasSameSize = false(size(varList));
    for iVar = 1:numel(varList)
      varHasSameSize(iVar) = isequal(blockSize(1:2), [size(matfile(fileList{iFile}), char(varList(iVar)), 1), size(matfile(fileList{iFile}), char(varList(iVar)), 2)]);
    end
    varsHasSameSize(iFile) = all(varHasSameSize);
  end
  
  if any(~varsHasSameSize)
    warningMsg = horzcat(warningMsg, sprintf("Some files were removed as they didn't have the same frame block size : %s", num2str(blockSize)));
  end
  
  fileList = fileList(varsHasSameSize);
  
  % Concatenate warning message
  if ~isempty(warningMsg)
    warningMsg = strjoin(warningMsg, newline);
  end
  % Display end of function
  disp('done');
end
