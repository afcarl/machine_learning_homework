function [ output_2, output_1 ] = rpca_admm( X, tau, method )
    %RPCA_ADMM
    
    number_of_iterations = 500;
    
    data_dims = size(X);
    
    delta = zeros(data_dims);
    
    output_1 = zeros(data_dims);
    
    output_2 = zeros(data_dims);
    
    sum_of_abs_values = sum(sum(abs(X)));
    
    beta = data_dims(1) * data_dims(2) / (4 * sum_of_abs_values);
    
    for i = 1:number_of_iterations
        
        precomputed = (1/beta)*delta;
       
        output_2 = sing_value_threshold(X-output_1 + precomputed, 1 / beta);
        
        if(strcmp(method, 'L1'))
            
            output_1 = soft_threshold(X - output_2 + precomputed, tau/beta);
        end
        
        if(strcmp(method, 'L21'))
           
            output_1 = l21_threshold(X - output_2 + precomputed, tau/beta);
        end
        
        delta = delta + beta*(X - output_2 - output_1);
    end
end

