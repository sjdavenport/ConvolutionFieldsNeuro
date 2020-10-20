global ncfloc %Load the parent directory

set(0,'defaultAxesFontSize', 14); %This sets the default font size.

RSfolder = 'R2Block';

FWHM_vec = 2:5;
nsubj_vec = [10,20,50];

ttindices = {'OT', 'TT'};
tail_names = {'one tail', 'two tail'};
g_names = {'Not Gaussianized', 'Gaussianized'};
ggindices = {'NG', 'G'};

coverage_types = {'cluster', 'conv'};

gauss_set = {[0,1], [0,1], [0,1]};

niters = 1000;

for alpha = 0.05
    load([ncfloc,'Figures/Coverage_plots/' RSfolder, '_statcoverage_', num2str(100*alpha)]);
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I);
        for do2tail = [0,1]
            ttindex = ttindices{do2tail + 1};
            for do_gauss = gauss_set{I}
                gtindex = [ttindex, ggindices{do_gauss+1}];
                
                clf
                plot(FWHM_vec,coverage_forman.(['nsubj_',num2str(nsubj)]).(gtindex).('conv'));
                hold on
                plot(FWHM_vec,coverage_forman.(['nsubj_',num2str(nsubj)]).(gtindex).('cluster'));
                plot(FWHM_vec,coverage_forman.(['nsubj_',num2str(nsubj)]).(gtindex).('lat'));
%                 plot(FWHM_vec,coverage_kiebel.(['nsubj_',num2str(nsubj)]).(gtindex).('conv'));
%                 plot(FWHM_vec,coverage_kiebel.(['nsubj_',num2str(nsubj)]).(gtindex).('cluster'));
%                 plot(FWHM_vec,coverage_kiebel.(['nsubj_',num2str(nsubj)]).(gtindex).('lat'));
                
                title([g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: N = ', num2str(nsubj)])
%                 if alpha == 0.05
%                     ylim([0, 0.07])
%                 elseif alpha == 0.01
%                     ylim([0, 0.014])
%                 end
                abline('h', alpha)
                interval = bernstd( alpha, niters );
                yline(interval(1), '--', 'LineWidth', 2 );
                yline(interval(2), '--', 'LineWidth', 2 );
                xticks(2:6)
                xlabel('Applied FWHM')
                ylabel('FWER error rate')
                
                if nsubj == 50 && do_gauss == 1
                    legend('Forman - Expected number of maxima', ...
                        'Forman - Convolution FWER', 'Forman - Lattice FWER', ...
                        'Kiebel - Expected number of maxima', ...
                        'Kiebel - Convolution FWER', 'Kiebel - Lattice FWER', ...
                        'Location', 'SouthEast')
                end
                filename = [gtindex, '_nsubj_', num2str(nsubj),'_', num2str(100*alpha)];
                export_fig([ncfloc, 'Figures/Coverage_Plots/R2Block_5000/', filename, '.pdf'], '-transparent')
            end
        end
    end
end