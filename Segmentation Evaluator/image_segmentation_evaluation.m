function [averagePRI, averageSC, averageVOI, averageGCE, averageBDE] = image_segmentation_evaluation(dataset, algorithm, prediction_path, label_path)
if nargin<3
    prediction_path = "..";
    label_path = "../data";
end
predPath = fullfile(prediction_path, algorithm, dataset);
labelPath = fullfile(label_path, dataset, 'groundTruth');

% load predictions
predImageList = dir(fullfile(predPath,'*.mat'));
if isempty(predImageList)
    error('Cannot find the image directories.');
end

N_images = length(predImageList);
%% PRI,VoI,GCE,BDE.
PRI_all = zeros(N_images,1);
SC_all = zeros(N_images,1);
VoI_all = zeros(N_images,1);
GCE_all = zeros(N_images,1);
BDE_all = zeros(N_images,1);

imageCount = 0;
for imageIndex=1:length(predImageList)
    predFilename = fullfile(predPath, predImageList(imageIndex).name);
    labelFilename = fullfile(labelPath, predImageList(imageIndex).name);
    % 保存的文件又一个pdictation的变量
    prediction = load(predFilename, 'prediction');
    prediction = prediction.prediction;
    prediction = prediction{1};
    [PRI, SC, VOI, GCE, BDE] = evaluate_single_image(prediction, labelFilename);
    imageCount = imageCount + 1;
    
    PRI_all(imageIndex) = PRI;
    SC_all(imageIndex) = SC;
    VoI_all(imageIndex) = VOI;
    GCE_all(imageIndex) = GCE;
    BDE_all(imageIndex) = BDE;
end

averagePRI =mean(PRI_all);
averageSC = mean(SC_all);
averageBDE = mean(BDE_all);
averageGCE = mean(GCE_all);
averageVOI = mean(VoI_all);
end