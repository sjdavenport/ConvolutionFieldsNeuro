global ncfloc
RSfolder = 'R2Block';
nsubj_vec = [10,20,50];
FWHM_vec = 2:5;

set(0,'defaultAxesFontSize', 13); %This sets the default font size.

for quantile = [0.01, 0.05]
    for do_gauss = [0,1]
        for nsubj = nsubj_vec
            for FWHM = FWHM_vec
                clf
                nsubj_index = find(nsubj_vec == nsubj);
                FWHM_index = find(FWHM_vec == FWHM);
                
                % Obtain the non-stationary LKCs
                storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
                if ~do_gauss
                    storefilename = [storefilename, '_NG'];
                end
                data = load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);
                averageLKCs = mean(data.LKCs.L, 2);
                L0 = mean(data.LKCs.L0, 2);
                
                % Obtain the stationary LKCs
                load([ncfloc, 'Coverage/Stationary_LKCs/meanLKCs_DG_',num2str(do_gauss)], ...
                    'LKCs_forman_mean', 'LKCs_forman_std', 'LKCs_kiebel_mean', 'LKCs_kiebel_std', ...
                    'LKCs_nonstat_mean', 'LKCs_nonstat_std')
                
                statlkcstore = load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro', ...
                    '\Coverage\Stationary_LKCs\FWHM_', num2str(FWHM),'_nsubj_',num2str(nsubj), 'DG_', num2str(do_gauss),'.mat']);
                
                [ECmean, ECstd, x] = tailECcurve(data.maxnmin.allmaxima, quantile);
                
                % Plot the empirical mean EC curve
                h(1) = plot(x, ECmean, 'color', def_col('blue'));
                hold on
                
                % Add error bars
                h(2) = plot(x, ECmean+(norminv(0.975)/sqrt(length(data.maxnmin.latmaxima)))*ECstd,...
                    '--', 'color', def_col('blue'));
                h(3) = plot(x, max(0,ECmean-(norminv(0.975)/sqrt(length(data.maxnmin.latmaxima)))*ECstd),...
                    '--', 'color', def_col('blue'));
                
                EC_nonstat = EEC( x, averageLKCs', L0, 'T', nsubj-1 );
                EC_forman = EEC( x, squeeze(LKCs_forman_mean(nsubj_index, FWHM_index,:))', statlkcstore.L0_kiebel(1), 'T', nsubj-1 );
                EC_kiebel = EEC( x, squeeze(LKCs_kiebel_mean(nsubj_index, FWHM_index,:))', statlkcstore.L0_kiebel(1), 'T', nsubj-1 );
                
                h(4) = plot(x, EC_nonstat, 'color', def_col('red'));
                h(5) = plot(x, EC_forman, 'color', def_col('purple'));
                h(6) = plot(x, EC_kiebel, 'color', def_col('green'));
                xlim([min(x), max(x)]);
                ylim([0, max(ECmean)]);
                
                legend(h([1,4:6]),'Empirical average EC curve', ...
                    'EEC - Non Stationary', 'EEC - Forman', 'EEC - Kiebel')
                if do_gauss == 1
                    title(['EC curves for the Gaussianized data: N = ', num2str(nsubj)]);
                else
                    title(['EC curves for the Original data: N = ', num2str(nsubj)]);
                end
                xlabel('Threshold: u')
                ylabel('EC curve')

                export_fig([ncfloc, 'Figures/EC_curves/UKB_ECcurves/tailECcurve_FWHM', ...
                    num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss), ...
                    '_quant', num2str(100*quantile),'.pdf'] ,'-transparent');
            end
        end
    end
end

%%
FWHM = 2; nsub = 10;
storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
data = load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);
[ECmean, ECstd, x] = tailECcurve(data.maxnmin.convmaxima);

% Plot the empirical mean EC curve
plot(x, ECmean)
hold on

% Add error bars
plot(x, ECmean+(norminv(0.975)/sqrt(length(data.maxnmin.latmaxima)))*ECstd,...
    '--', 'color', def_col('blue'))
plot(x, max(0,ECmean-(norminv(0.975)/sqrt(length(data.maxnmin.latmaxima)))*ECstd),...
    '--', 'color', def_col('blue'))
