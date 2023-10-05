function [n_cluster,label] = getNClusters(labelFilename)
    if isempty(dir(labelFilename))
        [filepath, name, ext] = fileparts(labelFilename);
        labelFilename = dir(fullfile(filepath, sprintf('%s.*', name)));
        if isempty(labelFilename)
            % The bench data for this image is not available
            warning(['Cannot find the label file for ' predImageList(imageIndex).name]);
        end
        labelFilename = fullfile(labelFilename(1).folder, labelFilename(1).name);
        Segmentation=imread(labelFilename);
        if size(Segmentation,3)>1
            Segmentation=rgb2gray(Segmentation);
        end
        groundTruth{1}.Segmentation=Segmentation;
    else
        groundTruth = load(labelFilename, 'groundTruth');
        groundTruth = groundTruth.groundTruth;
    end
    
    nGroundTruth = numel(groundTruth);
    clusters = zeros(nGroundTruth, 1);
    for benchIndex=1:nGroundTruth
        label = groundTruth{benchIndex}.Segmentation;
        clusters(benchIndex) = length(unique(label));
    end
    n_cluster = round(median(clusters));
end

