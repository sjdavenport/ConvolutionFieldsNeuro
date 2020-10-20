nsubj_vec = [10,20,50];
FWHM_vec = 2:5;
FWHM = 2;
do_gauss = 0;

% Find the length of the vectors
n_subject_cases = length(nsubj_vec);
n_FWHM = length(FWHM_vec);

% Initialize the LKC storage vectors
LKCs_forman_mean = zeros(n_subject_cases, n_FWHM, 3);
LKCs_kiebel_mean = zeros(n_subject_cases, n_FWHM, 3);

LKCs_forman_std = zeros(n_subject_cases, n_FWHM, 3);
LKCs_kiebel_std = zeros(n_subject_cases, n_FWHM, 3);

LKCs_nonstat_mean = zeros(n_subject_cases, n_FWHM, 3);
LKCs_nonstat_std = zeros(n_subject_cases, n_FWHM, 3);

for J = 1:length(nsubj_vec)
    nsubj = nsubj_vec(J);
    for K = 1:length(FWHM_vec)
        FWHM = FWHM_vec(K);
        
        statlkcstore = load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro', ...
            '\Coverage\Stationary_LKCs\FWHM_', num2str(FWHM),'_nsubj_',num2str(nsubj), 'DG_', num2str(do_gauss),'.mat']);
        
        
        LKCs_kiebel = struct();
        LKCs_forman = struct();
        
        LKCs_kiebel.L = zeros(3,1000);
        LKCs_kiebel.L0 = statlkcstore.L0_kiebel;
        
        for I = 1:length(statlkcstore.L_kiebel)
            LKCs_kiebel.L(:,I) = statlkcstore.L_kiebel{I};
        end
        
        LKCs_forman.L = zeros(3,1000);
        LKCs_forman.L0 = statlkcstore.L0_forman;
        
        for I = 1:length(statlkcstore.L_kiebel)
            LKCs_forman.L(:,I) = statlkcstore.L_forman{I};
        end
        
        LKCs_forman_mean(J,K,:) = mean(LKCs_forman.L,2)';
        LKCs_kiebel_mean(J,K,:) = mean(LKCs_kiebel.L,2)';
        
        LKCs_forman_std(J,K,:) = std(LKCs_forman.L,0,2)';
        LKCs_kiebel_std(J,K,:) = std(LKCs_kiebel.L,0,2)';
        
        if do_gauss == 1
            NGadd = '';
        else
            NGadd = '_NG';
        end
        
        nonstatstore = load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro', ...
            '\Coverage\R2Block_coverage5000\FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1', NGadd,'.mat']);
        
        donesofar = length(nonstatstore.maxnmin.alphathresholds);
        LKCs_nonstat_mean(J,K,:) = mean(nonstatstore.LKCs.L(:,1:donesofar),2)';
        LKCs_nonstat_std(J,K,:) = std(nonstatstore.LKCs.L(:,1:donesofar),0,2)';
        
    end
end

global ncfloc
save([ncfloc, 'Coverage/Stationary_LKCs/meanLKCs_DG_',num2str(do_gauss)], ...
    'LKCs_forman_mean', 'LKCs_forman_std', 'LKCs_kiebel_mean', 'LKCs_kiebel_std', ...
                        'LKCs_nonstat_mean', 'LKCs_nonstat_std')
                    