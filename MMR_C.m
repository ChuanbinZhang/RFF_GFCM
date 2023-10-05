function IR=MMR_C(I, se_start, min_impro, max_itr)
%% MMR-C multiscale morphological reconstruction
switch nargin
    case 2
        min_impro = 0.0001;
        max_itr = 50;
    case 3
        max_itr = 50;
end
IR=zeros(size(I));
for i=1:max_itr
    se=strel('disk',i+se_start-1);
    fe=imerode(I,se);
    fobr=imreconstruct(fe,I);
    fobrc=imcomplement(fobr);
    fobrce=imerode(fobrc,se);
    fr=imcomplement(imreconstruct(fobrce,fobrc));
    f_g2=max(IR,double(fr));
    f_g1=IR;IR=f_g2;
    diff=mean2(abs(f_g1 - f_g2));
    if i > 1 && diff < min_impro
        break;
    end
end
end