nsubj_vec = [10,20,50];
FWHM_vec = 2:5;
RSfolder = 'R2Block';
global ncfloc

coverage_types = {'finelat', 'lat', 'conv', 'cluster'};
coverage_forman = struct();
coverage_kiebel = struct();
coverage.FWHM_vec = FWHM_vec;

n_subject_cases = length(nsubj_vec);
n_FWHM = length(FWHM_vec);

alpha = 0.01;

for do_gauss = [0,1]
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I)
        for K = 1:length(coverage_types)
            coverage.(['nsubj_',num2str(nsubj)]).OTG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
            coverage.(['nsubj_',num2str(nsubj)]).TTG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
            coverage.(['nsubj_',num2str(nsubj)]).OTNG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
            coverage.(['nsubj_',num2str(nsubj)]).TTNG.(coverage_types{K}) = zeros(1, length(FWHM_vec));
        end
        for J = 1:length(FWHM_vec)
            FWHM = FWHM_vec(J)

            % Obtain the coverage
            if do_gauss == 1
                gindex = 'G';
                storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
            else
                gindex = 'NG';
                storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1_NG'];
            end
            load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);
            maxnmin.nsubj = nsubj;

            statlkcstore = load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro', ...
                '\Coverage\Stationary_LKCs\FWHM_', num2str(FWHM),'_nsubj_',num2str(nsubj), 'DG_', num2str(do_gauss),'.mat']);
            
            LKCs_kiebel = struct();
            LKCs_forman = struct();
            
            LKCs_kiebel.L = zeros(3,1000);
            LKCs_kiebel.L0 = statlkcstore.L0_kiebel;
            
            for K = 1:length(statlkcstore.L_kiebel)
                LKCs_kiebel.L(:,K) = statlkcstore.L_kiebel{K};
            end
            
            LKCs_forman.L = zeros(3,1000);
            LKCs_forman.L0 = statlkcstore.L0_forman;
            
            for K = 1:length(statlkcstore.L_kiebel)
                LKCs_forman.L(:,K) = statlkcstore.L_forman{K};
            end
            
            for do_2tail = [0,1]
                if do_2tail == 1
                    gtindex = ['TT',gindex];
                else
                    gtindex = ['OT',gindex];
                end
                
                [voxcoverage_forman, clustercoverage_forman] = calc_coverage( maxnmin, LKCs_forman, do_2tail, alpha);
                [voxcoverage_kiebel, clustercoverage_kiebel] = calc_coverage( maxnmin, LKCs_kiebel, do_2tail, alpha);
                
                % Record the voxel coverage
                for K = 1:3
                    coverage_forman.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{K})(J) ...
                        = voxcoverage_forman.(coverage_types{K});
                    coverage_kiebel.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{K})(J) ...
                        = voxcoverage_kiebel.(coverage_types{K});
                end
                
                % Record the cluster error rate
                coverage_forman.(['nsubj_',num2str(nsubj)]).(gtindex).('cluster')(J) = clustercoverage_forman;
                coverage_kiebel.(['nsubj_',num2str(nsubj)]).(gtindex).('cluster')(J) = clustercoverage_kiebel;
            end
            
        end
    end
end

save([ncfloc,'Figures/Coverage_plots/R2Block_statcoverage_', ...
                num2str(100*alpha)], 'coverage_forman', 'coverage_kiebel');