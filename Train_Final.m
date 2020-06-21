function [training] = Train_Final(folder, number_of_patches, rotation, block_size)
    %block_size = 5;
    %lr_block_size = 3;
    %magnification = hr_block_size/lr_block_size;
    rng(5);
    images_folder = dir(folder);
    training = cell(0,3);
    
    patches_per_image = round(number_of_patches/(length(images_folder)-2));
    for i = 3:length(images_folder)   % first 2 are '.' and '..'
        %open image
        image_path = strcat(folder, '\', images_folder(i).name);
        current_image = imread(image_path);
        if size(current_image,3)==3
            current_image = rgb2gray(current_image);
        end
        lr_image = imresize(current_image, 1/2);
        lr_image = imresize(lr_image, 2);
        
        [image_height, image_width] = size(current_image);
        

        cols = randi(image_width-block_size,patches_per_image,1);
        rows = randi(image_height-block_size, patches_per_image,1);

        for j = 1:patches_per_image
            patch = current_image(rows(j):rows(j)+block_size-1,cols(j):cols(j)+block_size-1);
            patch = double(patch);
            patch_lr = lr_image(rows(j):rows(j)+block_size-1,cols(j):cols(j)+block_size-1);
            patch_lr = double(patch_lr);
            training{end+1,1} = patch;
            training{end,2} = reshape(patch_lr,(block_size)^2,1);
            training{end,3} = reshape(patch_lr./255,(block_size)^2,1);

            
            if(rotation)
                patch = rot90(patch);
                patch_lr = rot90(patch_lr);
                training{end+1,1} = patch;
                training{end,2} = reshape(patch_lr,(block_size)^2,1);
                training{end,3} = reshape(patch_lr./255,(block_size)^2,1);

                patch = rot90(patch);
                patch_lr = rot90(patch_lr);
                training{end+1,1} = patch;
                training{end,2} = reshape(patch_lr,(block_size)^2,1);
                training{end,3} = reshape(patch_lr./255,(block_size)^2,1);
                
                patch = rot90(patch);
                patch_lr = rot90(patch_lr);
                training{end+1,1} = patch;
                training{end,2} = reshape(patch_lr,(block_size)^2,1);
                training{end,3} = reshape(patch_lr./255,(block_size)^2,1);
            end
        end
    end
end