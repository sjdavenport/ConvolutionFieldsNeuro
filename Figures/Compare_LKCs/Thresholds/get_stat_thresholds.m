global ncfloc

RSfolder = 'R2Block';
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

%%
FWHM_vec = 2:5;
nsubj_vec = [10,20,50];

coverage_types = {'finelat', 'lat', 'conv', 'cluster'};

coverage = struct();
coverage.FWHM_vec = FWHM_vec;

gauss_set = {[0,1], [0,1], [0,1]};

alpha = 0.01;

for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I)
    
    % OTG: one tail gaussianized, TTG: two tail gaussianized
    % OTG: one tail not gaussianized, TTG: two tail not gaussianized
    for K = 1:length(coverage_types)
        coverage.(['nsubj_',num2str(nsubj)]).OTG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
        coverage.(['nsubj_',num2str(nsubj)]).TTG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
        coverage.(['nsubj_',num2str(nsubj)]).OTNG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
        coverage.(['nsubj_',num2str(nsubj)]).TTNG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
    end
    
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J)
        
        % 1 tail analysis
        for do_gauss = gauss_set{I}
            if do_gauss == 1
                gindex = 'G';
                storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
            else
                gindex = 'NG';
                storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1_NG'];
            end
            
            load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);
            maxnmin.nsubj = nsubj;
            
            for do_2tail = [0,1]
                if do_2tail == 1
                    gtindex = ['TT',gindex];
                else
                    gtindex = ['OT',gindex];
                end

                % Obtain the coverage
                [voxcoverage, clustercoverage] = calc_coverage( maxnmin, LKCs, do_2tail, alpha);
                
                % Record the voxel coverage
                for K = 1:3
                    coverage.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{K})(J) = voxcoverage.(coverage_types{K});
                end
                
                % Record the cluster error rate
                coverage.(['nsubj_',num2str(nsubj)]).(gtindex).('cluster')(J) = clustercoverage;
                
            end
        end
    end
end

global ncfloc
save([ncfloc,'Figures/Coverage_plots/R2Block_coverage5000_', num2str(100*alpha)], 'coverage')