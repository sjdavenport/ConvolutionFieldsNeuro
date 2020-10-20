global ncfloc
RSfolder = 'R2Block';
nsubj_vec = [10,20,50];
FWHM_vec = 2:5;

quantile = 0.05;
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
            
            [~,~,x] = ECcurveanal( data.maxnmin, nsubj, averageLKCs', L0, quantile );
            hold on
            
            EC_forman = EEC( x, squeeze(LKCs_forman_mean(nsubj_index, FWHM_index,:))', statlkcstore.L0_kiebel(1), 'T', nsubj-1 );
            EC_kiebel = EEC( x, squeeze(LKCs_kiebel_mean(nsubj_index, FWHM_index,:))', statlkcstore.L0_kiebel(1), 'T', nsubj-1 );
            
            plot(x, EC_forman)
            plot(x, EC_kiebel)
            
            legend('Convolution Maximum', 'EEC - Non Stationary', ...
                'Empirical average EC curve', 'EEC - Forman', 'EEC - Kiebel')
            title(['Empirical vs Expected EC curve for N = ', ...
                    num2str(nsubj),' and FWHM = ', num2str(FWHM)]);
            xlabel('Threshold: u')
            ylabel('EC curve')
            export_fig([ncfloc, 'Figures/EC_curves/All_EC_curves/tailECcurve_FWHM', ...
                num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss), '.pdf']...
                                                        ,'-transparent');
        end
    end
end

%%
FWHM = 2; nsub = 10;
storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
data = load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);
[curve,x] = maxECcurve( data.maxnmin.convmaxima );
plot(x, curve)
hold on
[ECmean, ECstd, x] = tailECcurve(data.maxnmin.convmaxima);

isequal(ECmean, curve')
%%
xlimits = [5,max(data.maxnmin.allmaxima(1,:))];
subplot(3,1,1)
histogram(data.maxnmin.allmaxima(1,:))
xlim(xlimits)
title('Highest')
subplot(3,1,2)
histogram(data.maxnmin.allmaxima(2,:))
xlim(xlimits)
title('2nd highest')
subplot(3,1,3)
histogram(data.maxnmin.allmaxima(3,:))
xlim(xlimits)
title('3rd highest')
