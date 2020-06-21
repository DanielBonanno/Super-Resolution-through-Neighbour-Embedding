images_folder = dir('Test_Images/HR');
for i = 3:length(images_folder)   % first 2 are '.' and '..'
    %open image
    image_path = strcat('Test_Images/HR', '\', images_folder(i).name);
    current_image = imread(image_path);
    current_image_lr = imresize(imresize(current_image,0.5),2);
    name = strcat('Test_Images/LR/',images_folder(i).name);
    imwrite(current_image_lr, name);
end