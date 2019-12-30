function   [data] = load_tiff_maxproj(fname,channel)
%method =1;
fname 
info = imfinfo(fname);
num_images = numel(info);
scale =  0.09;  %0.09
 
temp =    imread(fname)  ; %Read only the first to get the size of the stack
[r,c,d] = size(temp);
data = zeros(r,c,num_images);
 
% Load data
for k = 1 : num_images
       
        im =    double(  imread(fname, k)) ; %) , scale  ); %imadjust   imresize( double
        data(:,:,k ) =  (im(:,:,channel));
      % figure; imagesc(data(:,:,k))
end

data = imresize3(data, scale);

temp = sum(data,1);
[ a, b,c ] = size(temp);
axial = zeros(b,c);
for kk = 1  : a
    for jj = 1 : b
        axial(kk,jj) = temp(1,kk,jj);
    end
end
temp = sum(data,2);
sagittal = zeros(b,c);
for kk = 1  : a
    for jj = 1 : b
        sagittal(kk,jj) = temp(kk,1,jj);
    end
end

coronal = sum(data,3);

data = [coronal(:)' axial(:)' sagittal(:)'];

%data = data(:);
        