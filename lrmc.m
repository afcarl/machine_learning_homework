function [ A ] = lrmc( X, tau, W )
    %LRMC
    
    % Constants
    number_of_iterations = 500;
    
    % Size of input data matrix
    [D, N] = size(X);
    
    % Sum up all the abs values from each matrix cell
    sum_abs_values = sum(sum(abs(X)));
    
    % Precompute beta parameter
    beta = N*D / (4*sum_abs_values);
    
    % Current interation data
    current = zeros(D, N);
    
    % Make specified number of iterations
    for i = 1:number_of_iterations
        
        p = current .* W;
        A = sing_value_threshold(p, tau);
        
        % Update matrix
        current = current + beta * (X - A) .*W;
    end
end



