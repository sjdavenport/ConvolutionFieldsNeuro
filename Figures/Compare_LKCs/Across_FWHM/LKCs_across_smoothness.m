do_gauss = 1;

load([ncfloc, 'Coverage/Stationary_LKCs/meanLKCs_DG_',num2str(do_gauss)], ...
    'LKCs_forman_mean', 'LKCs_forman_std', 'LKCs_kiebel_mean', 'LKCs_kiebel_std', ...
                        'LKCs_nonstat_mean', 'LKCs_nonstat_std')
                    
nsubj_vec = [10,20,50];

nsubj2use = [10,20,50];
FWHM_vec = 2:5;

for I = 1:length(nsubj2use)
    clf
    nsubj = nsubj2use(I);
    nsubj_index = find(nsubj_vec == nsubj);
    
    plot(FWHM_vec, log(LKCs_forman_mean(nsubj_index, :, 3)));
    hold on 
    plot(FWHM_vec, log(LKCs_kiebel_mean(nsubj_index, :, 3)));
    plot(FWHM_vec, log(LKCs_nonstat_mean(nsubj_index, :, 3)));
    legend('Forman', 'Kiebel', 'Non-stationary')
    title(['L_3 for N = ', num2str(nsubj)])
    xlabel('Applied FWHM per voxel')
    ylabel('log(L_3)')
    export_fig([ncfloc, 'Figures/Compare_LKCs/Across_FWHM/L3_nsubj_', num2str(nsubj), '_DG_', num2str(do_gauss), '.pdf'], '-transparent')
    clf
    plot(FWHM_vec, log(LKCs_forman_mean(nsubj_index, :, 2)));
    hold on 
    plot(FWHM_vec, log(LKCs_kiebel_mean(nsubj_index, :, 2)));
    plot(FWHM_vec, log(LKCs_nonstat_mean(nsubj_index, :, 2)));
    legend('Forman', 'Kiebel', 'Non-stationary')
    title(['L_2 for N = ', num2str(nsubj)])
    xlabel('Applied FWHM per voxel')
    ylabel('log(L_2)')
    export_fig([ncfloc, 'Figures/Compare_LKCs/Across_FWHM/L2_nsubj_', num2str(nsubj), '_DG_', num2str(do_gauss), '.pdf'], '-transparent')
end