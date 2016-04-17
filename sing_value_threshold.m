function [ thresholded ] = sing_value_threshold( input, tau )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    % Compute SVD of input matrix
    [U, D, V] = svd(input, 'econ');
    
    % Create matrix from singular values by putting them on diagonal
    diag_matrix = diag(D);
    
    % Subtract tau and check for threshold
    res = diag_matrix - tau;
    
    % Threshold value to zero if less than tau
    res = max(res, 0);
    
    % Create diag matrix using output values
    new_sing_values = diag(res);
    
    % Reconstruct back
    thresholded = U * new_sing_values * V';
end

