A = imread("data_fruit/image_1.png");
dimensions = size(A);
length = prod(dimensions);
oneD_image = reshape(A,[1,length]);
oneD_image = double(oneD_image);
% mean = sum(oneD_image)/length;
% mean_matrix = ones(1, length)*mean;
centered_matrix = oneD_image/255;
% sum(centered_matrix)
reshaped_Image = reshape(centered_matrix, [80, 80, 3]);
image(reshaped_Image);