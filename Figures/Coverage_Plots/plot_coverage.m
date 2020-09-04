global ncfloc %Load the parent directory
RSfolder = 'R2Block';

FWHM_vec = 2:6;
nsubj_vec = [10,20,50];

ttindices = {'OT', 'TT'};
tail_names = {'one tail', 'two tail'};
g_names = {'Not Gaussianized', 'Gaussianized'};
ggindices = {'NG', 'G'};

coverage_types = {'finelat', 'lat', 'conv', 'cluster'};

gauss_set = {[0,1], 1, 1};

load([ncfloc,'Figures/Coverage_plots/' RSfolder, '_coverage']);

for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I);
    for do2tail = [0,1]
        ttindex = ttindices{do2tail + 1};
        for do_gauss = gauss_set{I}
            gtindex = [ttindex, ggindices{do_gauss+1}];
            
            clf
            for K = 1:4
                plot(FWHM_vec,coverage.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{K}));
                hold on
            end
            
            title2use = [g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: nsubj = ', num2str(nsubj)];
            title([g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: nsubj = ', num2str(nsubj)])
            ylim([0, 0.06])
            abline('h', 0.05)
            
            legend('finelat', 'lat', 'conv', 'cluster')
            
            filename = [gtindex, '_nsubj_', num2str(nsubj)];
            export_fig([ncfloc, 'Figures/Coverage_Plots/R2Block/', filename, '.pdf'], '-transparent')
        end
    end
end