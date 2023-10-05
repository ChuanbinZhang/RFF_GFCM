algorithms = [
%     "FCM_M2",
%     "FCM_S1",
%     "Enfcm",
%     "FGFCM",
%     "FGFCM_S1",
%     "FGFCM_S2",
%     "FLICM",
%     "FCM_SICM"
%     "SFFCM"
%     "AFCF",
%     "LSFCM",
% "KWFLICM"
% "DSFCM_N"
% "CAS"
% "WSGL"
% "SLIC"
% "FSC_LNML"
% "CGFFCM"
% "AF-graph"
% "DBSCAN"
% "FuzzySLIC"
% "SCoW"
% "SNIC"
% "LSC"
% "MISP"
% "MISP_GGD"
% "MRF_SFCM"
"MVFCMG"
]';

datasets = [
%     "MSRC_HQGT"
    "MSRC"
%     "BSDS500"
%     "BCSS";
%     "GLAS";
    ]';

for dataset=datasets
    disp(dataset);
    fprintf('Algorithm\tPRI\tSC\tVOI\tGCE\tBDE\n');

    for algorithm=algorithms
        [averagePRI, averageSC, averageVOI, averageGCE, averageBDE]=image_segmentation_evaluation(dataset,algorithm);
        fprintf('%s\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n', algorithm, averagePRI, averageSC, averageVOI, averageGCE, averageBDE);
    end
end