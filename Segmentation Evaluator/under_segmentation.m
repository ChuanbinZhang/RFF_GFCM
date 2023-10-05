function [ue] = under_segmentation(seg,gt)

ue = 0;
% nSegs is the number of ground truth segmentations

% number of ground truth labels and segmentation labels of "seg"
num1 = max(gt,[],"all") + 1;
num2 = max(seg,[],"all") + 1;
confcounts = zeros(num1, num2);
N = size(seg, 1)*size(seg,2);

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

for j = 1: num1
    for i = 1: num2
        resj = sum(confcounts(:, i));
        gtjresj = confcounts(j, i);
        ue = ue + min(gtjresj, resj - gtjresj);
    end
end
ue = ue/N;
end

