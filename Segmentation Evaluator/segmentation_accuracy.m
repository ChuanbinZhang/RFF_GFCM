function [asa] = segmentation_accuracy(seg,gt)
[imWidth,imHeight]=size(seg);
[imWidth2,imHeight2]=size(gt);
N=imWidth*imHeight;
if (imWidth~=imWidth2)||(imHeight~=imHeight2)
    disp( 'Input sizes: ' );
    disp( size(seg) );
    disp( size(gt) );
    error('Input sizes do not match in compare_segmentations.m');
end

% make the group indices start at 1
if min(min(seg)) < 1
    seg = seg - min(min(seg)) + 1;
end
if min(min(gt)) < 1
    gt = gt - min(min(gt)) + 1;
end


% number of ground truth labels and segmentation labels of "seg"
num1 = max(gt(:)) + 1;
num2 = max(seg(:)) + 1;
confcounts = zeros(num1, num2);

% creates a matrix of labels as follows: for each label from 1 to num1
% in gt there are num2 "sublabels"
sumim = 1 + gt + seg*num1;

% histc computes a simple histogram counting the number of values in
% sumim to fall in the ranges given by 1:num1*num2
hs = histc(sumim(:), 1:num1*num2);

% confcounts is a mtrix of size num1 x num2 and in entry (i,j) it
% stores the number of pixels belonging to both label i-1 in ground
% truth and label j-1 in given segmentation
confcounts(:) = confcounts(:) + hs(:);
sumASA=0;
for j = 1: num2
    maxj = max(confcounts(:, j));
    sumASA = sumASA + maxj;
end
asa = sumASA / N;
end

