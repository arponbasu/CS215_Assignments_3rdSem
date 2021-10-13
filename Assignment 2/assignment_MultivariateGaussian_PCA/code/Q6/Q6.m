clear all;
images = dir(fullfile("data_fruit/", '*.png'));
list = cell(length(images), 1);

for k = 1:length(images)
    input_image = images(k).name;
    list{k} = imread("data_fruit/"+input_image);
    list{k} = im2double(list{k});
end


dimensions = size(list{1});
length = prod(dimensions);
oneD_image = reshape(A,[1,length]);
oneD_image = double(oneD_image);
% mean = sum(oneD_image)/length;
% mean_matrix = ones(1, length)*mean;
centered_matrix = oneD_image/255;
% sum(centered_matrix)
reshaped_Image = reshape(centered_matrix, [80, 80, 3]);
image(reshaped_Image);