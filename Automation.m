load('Training_Manifolds');
block_overlap = [3 1; 3 2; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 5 4; 6 1; 6 2; 6 3; 6 4; 6 5];
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

results = cell(size(LR_images,1),size(block_overlap,1));
number_of_images = size(LR_images,1);

for config = 1:size(block_overlap,1)
    config
    block = block_overlap(config,1);
    overlap = block_overlap(config,2);
    if(block == 3)
        manifold = training_3;
    elseif(block == 4)
        manifold = training_4;
    elseif(block == 5)
        manifold = training_5;
    elseif(block == 6)
        manifold = training_6;
    end
    parfor image = 1:number_of_images
        current_lr_image = LR_images{image,:};
        output = Test_Final(current_lr_image,manifold, overlap,150);
        results{image,config} = psnr(output,HR_images{image,:});
    end
end

save('Block_Overlap_Results');