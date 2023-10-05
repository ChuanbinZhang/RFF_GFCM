function L=MMGR_WT(feature, se_start, min_impro, max_itr, display)
%% MMLR-WT achieves superpixel segmentation using adaptive and multiscale morphological gradient reconstruction
% L is lable image with line
switch nargin
    case 2
        min_impro = 0.0001;
        max_itr = 50;
        display = 0;
    case 3
        max_itr = 50;
        display = 0;
    case 4
        display = 0;
end

%% step 1. compute gradient image
[r,c,d]=size(feature);
f_g=zeros(r,c);
for i=1:d
    f_g = f_g+image_gradient(feature(:,:,i)).^2;
end
f_g=sqrt(f_g);
% figure;
% imshow(normalized(f_g),'border','tight','initialmagnification','fit');
% colormap parula;
% set (gcf,'Position',[0,0,size(f_g,2),size(f_g,1)]);  % 368为图片的列，640为图片的行
% axis normal;
%% step 2. multiscale morphological gradient reconstruction
IR=MMR_C(f_g,se_start, min_impro, max_itr);

%% step 3. watershed
L=watershed(IR);
L=imdilate(L,strel('square',3));

if display
    subplot_row=ceil((d+3)/2);
    figure;
    for i=1:d
        subplot(subplot_row,2,i),mesh(feature(:,:,i));
    end
    subplot(subplot_row,2,d+1),mesh(f_g);
    subplot(subplot_row,2,d+2),mesh(IR);
    subplot(subplot_row,2,d+3),imshow(label2rgb(L));
end
end