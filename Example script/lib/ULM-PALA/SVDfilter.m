function IQf = SVDfilter(IQ, cutoff)
  %SVDfilter Filter the IQ signal by truncating its SVD
  % IQf = SVDfilter(IQ, cutoff) performs a singular value decomposition (SVD) of IQ signal and
  % truncates the SVD using the given bounds.
  % IQ must be a 3D numeric array for which the dimensions are [imgHeight, imgWidth, nImg] and cutoff must be
  % a rising integer array of 1 or 2 elements which are within [1, nImg].
  % If cutoff results in an empty array or is the array (1:nImg), then IQf = IQ.
  % Created by Arthur Chavignon 2019 and commented by Jacques Battaglia in 2022
  
  % Assert arguments
  assert(isnumeric(IQ), "IQ must be a numeric argument.");
  assert(isreal(cutoff), "cutoff must a real number array.");
  assert(any(numel(cutoff) == [1, 2]), "cutoff must be an integer array of 1 or 2 elements.");
  
  % Construct truncation indices
  if numel(cutoff) == 1
    cutoff = [cutoff, size(IQ, 3)];
  end
  cutoff = sort(floor(cutoff));
  cutoff = cutoff(1):cutoff(2);
  cutoff = cutoff((1 <= cutoff) & (cutoff <= size(IQ, 3)));
  
  % Check truncation indices
  if isempty(cutoff)
    noFilter = true;
  else
    noFilter = isequal(cutoff([1, end]), [1, size(IQ, 3)]);
  end
  if noFilter
    IQf = IQ;
    return
  end
  
  % Reshape into Casorati matrix
  C = reshape(IQ, prod(size(IQ, [1, 2])), size(IQ, 3));
  
  % Perform the SVD of the autocorrelated matrix
  [V, ~, ~] = svd(C' * C); % C' * C = V * D^2 * V' and C * C' = U * D^2 * U'
  
  % Computes the singular vectors
  UD = C * V; % C = U * D * V' <=> C * V = U * D * V' * V = U * D
  
  % Truncate the SVD
  IQf = UD(:, cutoff) * V(:, cutoff)';
  
  % Reconstruct the filtered IQ
  IQf = reshape(IQf, size(IQ));
  
end
