function   [data] = load_tiff(fname,channel)
 
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

data = data(:);
        