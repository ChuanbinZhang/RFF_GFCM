function out=label2image(pred,label_image)
out=zeros(size(label_image));
r=label_image(:,:,1);
g=label_image(:,:,2);
b=label_image(:,:,3);
for c=1:max(max(pred))
    iid = pred==c;
    if sum(iid,"all") < 1
        continue
    end
    out=out+cat(3,iid.*mean2(r(iid)),iid.*mean2(g(iid)),iid.*mean2(b(iid)));
end
out=uint8(out);
mask = boundarymask(pred);
out=imoverlay(out,mask,'red');
end

