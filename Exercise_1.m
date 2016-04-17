
ratio_of_corruption = 0.4;
images_sizes = [192 168];
number_of_pixels = images_sizes(1) * images_sizes(2);
number_of_preserved_pixels = int32(floor((1 - ratio_of_corruption) * number_of_pixels));
images_folder = 'YaleB-Dataset/images/yaleB01/';
images_regex = 'yaleB01_P00A*.pgm';

full_regex = strcat(images_folder, images_regex);

images_handler = dir(full_regex);

%% Reconstruction part

images_number = length(images_handler);

images_array = zeros(number_of_pixels, images_number, 'double');
missing_values_matrix = zeros(number_of_pixels, images_number, 'double');

for image_number = 1:images_number
   
    current_img = imread(strcat(images_folder, images_handler(image_number).name));
    current_img_vector = reshape(current_img, [], 1);
    images_array(:, image_number) = current_img_vector;
    
    current_missing_values_vector = zeros(number_of_pixels, 1);
    current_missing_values_vector(randsample(number_of_pixels,number_of_preserved_pixels )) = 1;
    missing_values_matrix(:, image_number) = current_missing_values_vector;
    
end

X = images_array .* missing_values_matrix;

reconstructed = lrmc(X, 4 * 10000, missing_values_matrix);

%% Mean face and eigenfaces

%Compute the mean face
mean_face = mean(reconstructed, 2);

%Prepare the mean face for the visualization
mean_face_vis = uint8(reshape(mean_face, images_sizes));

centered_faces = bsxfun(@minus, reconstructed, mean_face);

%covariance_matrix = centered_faces * (centered_faces');

reduced_covariance_matrix = (centered_faces') * centered_faces;



%[U, ~, ~] = svd(covariance_matrix, 'econ'); 

[V, D] = eig(reduced_covariance_matrix);

imshow(mean_face_vis);
%% Finding the eigen vectors using the trick from the original paper
% to save computation power.

% Visualize the eigenface with biggest eigenvalue;
% By changing the end to end-1, end - 2, you can get second and third
% eigenvectors.

test = V(:, end);

eig_vect = centered_faces * test;

% Making eigenvectors displayable
max_el = max(eig_vect);
min_el = min(eig_vect);
eig_vect = (eig_vect - min_el) / (max_el - min_el);
eig_vect = eig_vect * 255;

eig_vect = reshape(eig_vect, images_sizes);

imshow(uint8(eig_vect));

%% Computing the frobenius norm of the errors.

% Displaying the frobenius norm of error
error = sum(sum((images_array - reconstructed).^2))

