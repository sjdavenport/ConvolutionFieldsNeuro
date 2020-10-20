global ncfloc

RSfolder = 'R2Block';

FWHM_vec = 2:6;
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