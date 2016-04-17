function [ output ] = soft_threshold( input, tau )
    %SOFT_THRESHOLD
    
    % Also preserve the sing of variable
    output = max(abs(input) - tau, zeros(size(input))) .* sign(input);
end

