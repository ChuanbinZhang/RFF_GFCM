function [R, P] = segmentation_covering(seg, groundTruth)
regionsGT = [];
total_gt = 0;
for s = 1 : numel(groundTruth)
    groundTruth{s} = double(groundTruth{s});
    regionsTmp = regionprops(groundTruth{s}, 'Area');
    regionsGT = [regionsGT; regionsTmp];
    total_gt = total_gt + max(groundTruth{s}(:));
end

cnt = 0;
matches = zeros(total_gt, max(seg(:)));
nGroundTruth = numel(groundTruth);
for s = 1 : nGroundTruth
    gt = groundTruth{s};

    num1 = max(gt(:)) + 1; 
    num2 = max(seg(:)) + 1;
    confcounts = zeros(num1, num2);

    % joint histogram
    sumim = 1 + gt + seg*num1;

    hs = histc(sumim(:), 1:num1*num2);
    confcounts(:) = confcounts(:) + hs(:);

    accuracies = zeros(num1-1, num2-1);
    for j = 1:num1
        for i = 1:num2
            gtj = sum(confcounts(j, :));
            resj = sum(confcounts(:, i));
            gtjresj = confcounts(j, i);
            accuracies(j, i) = gtjresj / (gtj + resj - gtjresj);
        end
    end
    matches(cnt+1:cnt+max(gt(:)), :) = accuracies(2:end, 2:end);
    cnt = cnt + max(gt(:));
end

matches = matches';

cntR = 0;
sumR = 0;
cntP = 0;
sumP = 0;

matchesSeg = max(matches, [], 2);
matchesGT = max(matches, [], 1);

regionsSeg = regionprops(seg, 'Area');
for r = 1 : numel(regionsSeg)
    cntP = cntP + regionsSeg(r).Area*matchesSeg(r);
    sumP = sumP + regionsSeg(r).Area;
end
    
for r = 1 : numel(regionsGT)
    cntR = cntR +  regionsGT(r).Area*matchesGT(r);
    sumR = sumR + regionsGT(r).Area;
end

R = cntR ./ (sumR + (sumR==0));
P = cntP ./ (sumP + (sumP==0));