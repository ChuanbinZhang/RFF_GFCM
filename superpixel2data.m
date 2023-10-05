function [data,num_p,neighbor_p,image_label]=superpixel2data(src,feature,labels)
% If the source is RGB image, it will be converted to LAB color space for processing;
% else if it is gray scale image, it will be directly processed
%Input
%	src: the original image
%	labels: the label image
%Output
%   image_label: the result of segmentation
%   center_p: the mu and sigma of superpixel
%   num_p: the number of pixels in superpixel
%   neighbor: the neighbors of each superpixel
C = size(src, 3);
[M, N, D] = size(feature);
num_area=max(max(labels)); %The number of segmented areas
data=zeros(num_area, D);
num_p=zeros(num_area,1);
image_label=zeros(M, N, C);
neighbor_p=zeros(num_area);

se=strel('square',2);
for i=1:num_area
    index=labels==i;
    num_p(i)=sum(index, "all");

    se_index=imdilate(index,se);

    for j=unique(reshape(labels(se_index), 1, []))
        neighbor_p(i, j) = 1;
        neighbor_p(j, i) = 1;
    end
    
%     for c=1:C
%         src_c=src(:,:,c);
%         src_pixels=src_c(index);
%         src_mu=mean2(src_pixels);
%         image_label(:,:,c)=image_label(:,:,c)+index*src_mu;
%     end
    
    for d=1:D
        feature_d=feature(:,:,d);
        pixels=feature_d(index);
        data(i,d)=mean(pixels);
    end
end
% image_label=uint8(image_label);