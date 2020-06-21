%Using 4,2 config

load('Training_4_Manifold');
neighbours = [100 150 200 250 300 350 400 450 500 550 600];
LR_images = cell(0,0);
HR_images = cell(0,0);
images_folder = dir('Test_Images/LR');

for i = 3:length(images_folder)   % first 2 are '.' and '..'
    %open image
    image_path = strcat('Test_Images/LR', '\', images_folder(i).name);
    current_image = imread(image_path);
    LR_images{end+1,1} = current_image;    
end

images_folder = dir('Test_Images/HR');
for i = 3:length(images_folder)   % first 2 are '.' and '..'
    %open image
    image_path = strcat('Test_Images/HR', '\', images_folder(i).name);
    current_image = imread(image_path);
    HR_images{end+1,1} = current_image;    
end

results = cell(size(LR_images,1),size(neighbours,2));
number_of_images = size(LR_images,1);

for config = 1:size(neighbours,2)
    config
    n = neighbours(config);
    parfor image = 1:number_of_images
        current_lr_image = LR_images{image,:};
        output = Test_Final(current_lr_image,training_4,2,n);
        results{image,config} = psnr(output,HR_images{image,:});
    end
end

save('Neighbours_Results');