function [HR_image] = Test_Final(lr_image, training_manifold, overlap, k)
    training = training_manifold;%load(training_manifold);
    training_lr_patches = cell2mat(training(:,3)');
    %    training_lr_patches_norm = cell2mat(training(:,3)');

  
    patch_size = size(cell2mat(training(1,1)),1);
        
    delta = patch_size-overlap;
    %lr_image = imresize(lr_image, 2);
    [input_rows, input_cols] = size(lr_image);

   
    range = 1:delta:input_rows;
    padding_rows = range(end)+patch_size-1-input_rows;
    for i = 1: padding_rows
        lr_image = [lr_image; lr_image(end, :)];
    end
    
    range = 1:delta:input_cols;
    padding_cols = range(end)+patch_size-1-input_cols;
    for i = 1: padding_cols
        lr_image = [lr_image lr_image(:, end)];
    end
    
    [input_rows, input_cols] = size(lr_image);
    output_rows = input_rows;
    output_cols = input_cols;
    
    HR_image = double(zeros(output_rows, output_cols));
    HR_image = HR_image - double(ones(output_rows, output_cols));
    
    
    HR_patches = cell(0,1);
    for row = 1:delta:input_rows-overlap
        %fprintf('Row %i. \n',row)
        for col=1:delta:input_cols-overlap
            input_patch = lr_image(row:row+patch_size-1,col:col+patch_size-1);
            input_patch = reshape(input_patch,patch_size^2,1);
            
            input_patch = double(input_patch);            
            input_patch = input_patch./255;
            
            neighbour_indexes = knnsearch(double(training_lr_patches)',double(input_patch)', 'k', k);

            X = double(training_lr_patches(:,neighbour_indexes));
            
            %%%RIDGE REG., NORMALIZATION by zero mean unit var (centering)
            %lambda = 1 *10^-6, L knn lr, X = input lr

       
            %weights = inv((X'*X+eye(size(X,2))*10e-6))*X'*double(input_patch);
            one_col = ones(k,1);
            Gq = (input_patch*one_col' - X)' * (input_patch*one_col' - X);
            Gq = Gq + (eye(k)*10e-6);
            weights = linsolve(Gq,one_col);
            weights = weights/sum(weights);
            
            current_HR_patch = double(zeros(patch_size));
            neighbours = training(neighbour_indexes,1);

            for neighbour_index = 1:k%size(X,2)
                    current_HR_patch = current_HR_patch + (neighbours{neighbour_index,1} .* weights(neighbour_index));
            end
            HR_patches{end+1,1} = current_HR_patch;
        end
    end
    
    counter = 1;
    for row = 1:delta:output_rows-overlap
        for col=1:delta*(patch_size/patch_size):output_cols-overlap
         current_HR_patch = HR_patches{counter,1};
         counter = counter+1;
         for pixel_r = 1:patch_size
             for pixel_c = 1:patch_size
                     if(HR_image(row+pixel_r-1,col+pixel_c-1) == -1)
                         HR_image(row+pixel_r-1, col+pixel_c-1) = current_HR_patch(pixel_r,pixel_c);
                     else
                         HR_image(row+pixel_r-1, col+pixel_c-1) = (HR_image(row+pixel_r-1, col+pixel_c-1)+current_HR_patch(pixel_r,pixel_c))/2;
                     end
             end
         end
        end
    end
    HR_image = HR_image(1:end-padding_rows, 1:end-padding_cols);
    HR_image = uint8(HR_image);
end