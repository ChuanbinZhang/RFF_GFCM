function [PRI, SC, VOI, GCE, BDE] = evaluate_single_image(prediction, labelFilename)
if isempty(dir(labelFilename))
    [filepath, name, ~] = fileparts(labelFilename);
    
    labelFilename = fullfile(filepath, sprintf('%s.*', name));
    labelFilename = dir(labelFilename);
    if isempty(labelFilename)
        % The bench data for this image is not available
        warning(['Cannot find the label file for ' predImageList(imageIndex).name]);
        return;
    end
    labelFilename = fullfile(labelFilename(1).folder, labelFilename(1).name);
    Segmentation=imread(labelFilename);
    if size(Segmentation,3)>1
        Segmentation=rgb2gray(Segmentation);
    end
    groundTruth = cell(1,1);
    groundTruth{1,1} = double(Segmentation);
else
    segs_gt = load(labelFilename);
    groundTruth = cell(1,length(segs_gt.groundTruth));
    for i = 1:length(segs_gt.groundTruth)
        groundTruth{1,i} = double(segs_gt.groundTruth{1,i}.Segmentation);
    end
end

out_vals  = eval_segmentation(prediction, groundTruth);
PRI = out_vals.PRI;
VOI = out_vals.VoI;
GCE = out_vals.GCE;
BDE = out_vals.BDE;

SC = segmentation_covering(prediction, groundTruth);
end