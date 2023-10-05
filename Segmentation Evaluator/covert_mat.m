clear;
clc;

labelPath = './database/MSRC/clear_groundTruth/';
out_path = './database/MSRC/groundTruth/';

ext = {'*.mat'};
imageList = [];
for e = 1:numel(ext)
    imageList = [imageList; dir(fullfile(labelPath, ext{e}))];
end

for i=1:length(imageList)
    fprintf('Processing %s\n',imageList(i).name);
    segs_gt = load(imageList(i).name);
    [filepath, name, ext] = fileparts(imageList(i).name);
    groundTruth = cell(1);
    Segmentation = segs_gt.newseg;
    groundTruth{1}.Segmentation = Segmentation;
    name = name(1:end-3);
    save(sprintf('%s/%s.mat', labelPath, name), 'groundTruth');
end