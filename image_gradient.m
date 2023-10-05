function [grad_v, grad_m]=image_gradient(f)
f=double(f);
h=fspecial('sobel');
gx=imfilter(f,h,'replicate');
gy=imfilter(f,h','replicate');
grad_v=normalized(sqrt(gx.^2+gy.^2));
grad_m = cat(3, gx, gy);
