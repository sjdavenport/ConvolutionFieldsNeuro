global ncfloc %Load the parent directory

set(0,'defaultAxesFontSize', 15); %This sets the default font size. 

RSfolder = 'R2Block';

FWHM_vec = 2:6;
nsubj_vec = [10,20,50];

ttindices = {'OT', 'TT'};
tail_names = {'one tail', 'two tail'};
g_names = {'Not Gaussianized', 'Gaussianized'};
ggindices = {'NG', 'G'};

coverage_types = {'cluster', 'conv', 'finelat', 'lat'};

gauss_set = {[0,1], [0,1], [0,1]};

alpha = 0.01;

load([ncfloc,'Figures/Coverage_plots/' RSfolder, '_coverage5000_', num2str(100*alpha)]);

do_one = 0;
if do_one
    nsubj_vec = 10;
end

niters = 5000;

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
            
            title([g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: N = ', num2str(nsubj)])
            if alpha == 0.05
                ylim([0, 0.07])
            elseif alpha == 0.01
                ylim([0, 0.014])
            end
            abline('h', alpha)
            interval = bernstd( alpha, niters );
            yline(interval(1), '--', 'LineWidth', 2 );
            yline(interval(2), '--', 'LineWidth', 2 );
            xticks(2:6)
            xlabel('Applied FWHM')
            ylabel('FWER error rate')
            
            if nsubj == 50 && do_gauss == 1
                legend('Expected number of maxima', 'Convolution FWER', 'Fine Lattice FWER', 'Lattice FWER', 'Location', 'SouthEast')
            end
            filename = [gtindex, '_nsubj_', num2str(nsubj),'_', num2str(100*alpha)];
            export_fig([ncfloc, 'Figures/Coverage_Plots/R2Block_5000/', filename, '.pdf'], '-transparent')
        end
    end
end
%% convolution, fine lattice and original lattice
global ncfloc %Load the parent directory

set(0,'defaultAxesFontSize', 15); %This sets the default font size. 

RSfolder = 'R2Block';

FWHM_vec = 2:6;
nsubj_vec = [10,20,50];

ttindices = {'OT', 'TT'};
tail_names = {'one tail', 'two tail'};
g_names = {'Not Gaussianized', 'Gaussianized'};
ggindices = {'NG', 'G'};

coverage_types = {'conv', 'finelat', 'lat'};

gauss_set = {[0,1], [0,1], [0,1]};

alpha = 0.05;

load([ncfloc,'Figures/Coverage_plots/' RSfolder, '_coverage5000_', num2str(100*alpha)]);

do_one = 0;
if do_one
    nsubj_vec = 10;
end

niters = 5000;
colors = {'red', 'yellow', 'blue'};
for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I);
    for do2tail = [0,1]
        ttindex = ttindices{do2tail + 1};
        for do_gauss = gauss_set{I}
            gtindex = [ttindex, ggindices{do_gauss+1}];
            
            clf
            n_K = 3;
            for K = 1:3
                plot(FWHM_vec,coverage.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{n_K - K + 1}), 'linewidth', 4, 'color', def_col(colors{K}));
                hold on
            end
            
            title([g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: N = ', num2str(nsubj)])
            if alpha == 0.05
                ylim([0, 0.07])
            elseif alpha == 0.01
                ylim([0, 0.014])
            end
            abline('h', alpha)
            interval = bernstd( alpha, niters );
            yline(interval(1), '--', 'LineWidth', 2 );
            yline(interval(2), '--', 'LineWidth', 2 );
            xticks(2:6)
            xlabel('Applied FWHM')
            ylabel('FWER error rate')
            
            if nsubj == 50 && do_gauss == 1
                legend('Lattice FWER', 'Fine Lattice FWER', 'Convolution FWER', 'Location', 'SouthEast')
            end
            filename = [gtindex, '_nsubj_', num2str(nsubj),'_', num2str(100*alpha)];
%             squarescreen
%             BigFont
            export_fig([ncfloc, 'Figures/Coverage_Plots/R2Block_5000/', filename, 'EC0.pdf'], '-transparent')
        end
    end
end

%% Only convolution and lattice
global ncfloc %Load the parent directory

set(0,'defaultAxesFontSize', 15); %This sets the default font size. 

RSfolder = 'R2Block';

FWHM_vec = 2:6;
nsubj_vec = [10,20,50];

ttindices = {'OT', 'TT'};
tail_names = {'one tail', 'two tail'};
g_names = {'Not Gaussianized', 'Gaussianized'};
ggindices = {'NG', 'G'};

coverage_types = {'conv', 'lat'};

gauss_set = {[0,1], [0,1], [0,1]};

alpha = 0.05;

load([ncfloc,'Figures/Coverage_plots/' RSfolder, '_coverage5000_', num2str(100*alpha)]);

do_one = 0;
if do_one
    nsubj_vec = 10;
end

niters = 5000;
colors = {'red', 'blue'};
for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I);
    for do2tail = [0,1]
        ttindex = ttindices{do2tail + 1};
        for do_gauss = gauss_set{I}
            gtindex = [ttindex, ggindices{do_gauss+1}];
            
            clf
            n_K = 2;
            for K = 1:2
                plot(FWHM_vec,coverage.(['nsubj_',num2str(nsubj)]).(gtindex).(coverage_types{n_K - K + 1}), 'linewidth', 4, 'color', def_col(colors{K}));
                hold on
            end
            
            title([g_names{do_gauss+1},' ', tail_names{do2tail+1},' coverage: N = ', num2str(nsubj)])
            if alpha == 0.05
                ylim([0, 0.07])
            elseif alpha == 0.01
                ylim([0, 0.014])
            end
            abline('h', alpha)
            interval = bernstd( alpha, niters );
            yline(interval(1), '--', 'LineWidth', 2 );
            yline(interval(2), '--', 'LineWidth', 2 );
            xticks(2:6)
            xlabel('Applied FWHM')
            ylabel('FWER error rate')
            
            if do_gauss == 1
                legend('Lattice FWER', 'Convolution FWER', 'Location', 'SouthEast')
            end
            filename = [gtindex, '_nsubj_', num2str(nsubj),'_', num2str(100*alpha)];
            squarescreen
            BigFont
            export_fig([ncfloc, 'Figures/Coverage_Plots/R2Block_5000/', filename, 'EC-1.pdf'], '-transparent')
        end
    end
end