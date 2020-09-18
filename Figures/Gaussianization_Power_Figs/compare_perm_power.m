global RFTcodeloc
directory = [RFTcodeloc, 'RSD/Task/PermutationTaskRuns/'];

G_above_thresh = 0;
NG_above_thresh = 0;

binwidths = [3,25,50];
nsubj_vec = [10,20,50];
for K = 1:length(nsubj_vec)
    nsubj = nsubj_vec(K);
    all_G_above_thresh = [];
    all_NG_above_thresh = [];
    for do_gauss = [0,1]
        for I = 1:10
            filename = [directory, 'DG_', num2str(do_gauss), '_run_', num2str(I)];
            if nsubj ~= 20
                filename = [filename, '_nsubj_', num2str(nsubj)];
            end
            load(filename);
            if do_gauss == 1
                all_G_above_thresh = [all_G_above_thresh, nabovethresh];
                G_above_thresh = G_above_thresh + sum(nabovethresh);
            else
                all_NG_above_thresh = [all_NG_above_thresh, nabovethresh];
                NG_above_thresh = NG_above_thresh + sum(nabovethresh);
            end
        end
    end
    clf
    G_above_thresh
    NG_above_thresh
    (G_above_thresh - NG_above_thresh)/1000
    
    G_above_thresh/sum(all_G_above_thresh > 0) - NG_above_thresh/sum(all_NG_above_thresh > 0)
    
    plot(all_NG_above_thresh, all_G_above_thresh, '*')
    hold on
    maxval = max([all_NG_above_thresh, all_G_above_thresh]);
    plot(1:maxval, 1:maxval, '--')
    xlabel('No Gaussianization')
    ylabel('Gaussianization')
    title(['Number of voxels above the voxelwise permutation threshold for ', num2str(nsubj), ' subjects'])
    filename = ['vp_nsubj', num2str(nsubj)];
    export_fig([ncfloc, 'Figures/Gaussianization_Power_Figs/VoxPerm_UKBtask/', filename, '.pdf'], '-transparent')
    clf
    histogram(all_G_above_thresh - all_NG_above_thresh, 'BinWidth', binwidths(K))
    filename = ['vp_nsubj', num2str(nsubj),'_hist'];
    export_fig([ncfloc, 'Figures/Gaussianization_Power_Figs/VoxPerm_UKBtask/', filename, '.pdf'], '-transparent')
end
%%
plot(all_G_above_thresh - all_NG_above_thresh)