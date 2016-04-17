function [ output ] = l21_threshold( input, tau )
    %L21_THRESHOLD
    
    x = sqrt(sum(input .* input));
    
    d1 = soft_threshold(x, tau);
    
    % Make a copy because we need x as it is
    x_copy = x;
    
    for i = 1:length(x)
       
        if(x_copy(i) == 0)
            x_copy(i) = 1;
        end
    end
    
    d2 = 1 ./ x_copy;
    output = input * diag(d1 .* d2);
end

