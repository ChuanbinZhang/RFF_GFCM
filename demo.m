clear all
close all

addpath("Segmentation Evaluator")

% parameters
gamma = 5;
samples = 50;
eta = 0.1;
alpha = 0.1;

dataset = "MSRC";
imageName = "2_24_s.bmp";

labelPath = fullfile("./data", dataset, 'groundTruth');
imagePath = fullfile("./data", dataset, 'images');
imageFilename = fullfile(imagePath, imageName);
[filepath, name, ext] = fileparts(imageFilename);
labelFilename = fullfile(labelPath, sprintf('%s.mat', name));
[n_cluster,label] = getNClusters(labelFilename);
f_ori=imread(imageFilename);

%% generate superpixels
I=imgaussfilt3(f_ori,0.5);
I=colorspace('Lab<-RGB',I);
I=normalized(I);
%% generate superpixels
Z = RFF(I, gamma, samples, 0);
L=MMGR_WT(Z,1);
[data,num_p,neighbor_p,image_label]=superpixel2data(I,Z,L);
A=w_neighbors(L, data, neighbor_p, eta);

[prediction, centroid, U, obj] = GFCM(L, data, num_p, A, [alpha,n_cluster]);

% Evaluate prediction
[PRI, SC, VOI, GCE, BDE] = evaluate_single_image(prediction, labelFilename);
fprintf("PRI:%f, SC:%f, VOI:%f, GCE:%f, BDE:%f\n", PRI, SC, VOI, GCE, BDE)

figure;subplot(2,2,1),imshow(f_ori);title("original");
subplot(2,2,2),imshow(label2rgb(label));title("groundTruth");
subplot(2,2,3),imshow(label2rgb(L));title("superpixel");
subplot(2,2,4),imshow(label2image(prediction, f_ori));title("final");
