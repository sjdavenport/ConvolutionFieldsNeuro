global RFTcodeloc
directory = [RFTcodeloc, 'RSD/Task/PermutationTaskRuns/'];
global ncfloc

for nsubj = 10:10:100
    clf
    nongauss = load([directory, 'FDR_DG_0_nsubj_', num2str(nsubj)]);
    gauss = load([directory, 'FDR_DG_1_nsubj_', num2str(nsubj)]);
    
    iters_so_far = min(find(gauss.nabovethresh > 0, 1, 'last'), find(nongauss.nabovethresh > 0, 1, 'last'));
    plot(nongauss.nabovethresh(1:iters_so_far), gauss.nabovethresh(1:iters_so_far), '*')
    
    alltogether = [nongauss.nabovethresh(1:iters_so_far), gauss.nabovethresh(1:iters_so_far)];
    hold on
    plot(1:max(alltogether), 1:max(alltogether), '--');
    xlabel('No Gaussianization')
    ylabel('Gaussianization')
    title(['Number of voxels above the FDR threshold for ', num2str(nsubj), ' subjects'])
    filename = ['fdrplot_nsubj', num2str(nsubj)];
    export_fig([ncfloc, 'Figures/Gaussianization_Power_Figs/FDR_UKBtask/', filename, '.pdf'], '-transparent')
end