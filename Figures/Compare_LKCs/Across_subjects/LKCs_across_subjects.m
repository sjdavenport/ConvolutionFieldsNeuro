do_gauss = 1;

load([ncfloc, 'Coverage/Stationary_LKCs/meanLKCs_DG_',num2str(do_gauss)], ...
    'LKCs_forman_mean', 'LKCs_forman_std', 'LKCs_kiebel_mean', 'LKCs_kiebel_std', ...
                        'LKCs_nonstat_mean', 'LKCs_nonstat_std')
                    
nsubj_vec = [10,20,50];
FWHM_vec = 2:5;

for I = 1:length(FWHM_vec)
    clf
    FWHM = FWHM_vec(I);
    
    for L = 1:3
        clf
        plot(nsubj_vec, LKCs_forman_mean(:, I, L));
        hold on
        plot(nsubj_vec, LKCs_kiebel_mean(:, I, L));
        plot(nsubj_vec, LKCs_nonstat_mean(:, I, L));
        legend('Forman', 'Kiebel', 'Non-stationary')
        title(['L_', num2str(L),' for FWHM = ', num2str(FWHM)])
        xlabel('Number of Subjects')
        ylabel(['L_', num2str(L)])
        export_fig([ncfloc, 'Figures/Compare_LKCs/Across_subjects/L', num2str(L),'_FWHM_', num2str(FWHM), '_DG_', num2str(do_gauss), '.pdf'], '-transparent')
    end
    
end