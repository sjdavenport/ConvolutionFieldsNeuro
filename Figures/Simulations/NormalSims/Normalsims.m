%%
nsubj_vec = [10,20,50];
FWHM_vec = 2:6;

conv_FWER = zeros(2,length(nsubj_vec), length(FWHM_vec));
fine_FWER = zeros(2,length(nsubj_vec), length(FWHM_vec));
lat_FWER = zeros(2,length(nsubj_vec), length(FWHM_vec));
EECest = zeros(2,length(nsubj_vec), length(FWHM_vec));

for do_gauss = [0,1]
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I);
        for J = 1:length(FWHM_vec)
            FWHM = FWHM_vec(J);
            if do_gauss
                load([ncfloc, '\Simulations\Gaussian_Sims\Coverage\FWHM_', num2str(FWHM)...
                    '_nsubj', num2str(nsubj),'_DG_1.mat'])
            else
                load([ncfloc, '\Simulations\Gaussian_Sims\Coverage\FWHM_', num2str(FWHM)...
                    '_nsubj', num2str(nsubj),'.mat'])
            end
            conv_FWER(do_gauss+1, I, J) = coverage.conv;
            fine_FWER(do_gauss+1, I, J) = coverage.finelat;
            lat_FWER(do_gauss+1,I, J) = coverage.lat;
            findonesabovethresh = coverage.allmaxima > coverage.thresholds;
            EECest(do_gauss+1,I, J) = sum(findonesabovethresh(:))/length(coverage.thresholds);
        end
    end
end

%%
set(0,'defaultAxesFontSize', 18); %This sets the default font size. 
set(gcf, 'position', [0,0,700,525])

niters = 5000; alpha = 0.05;
for do_gauss = [0,1]
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I);
        clf
        h(1) = yline(alpha, '-', 'LineWidth', 1 );
        hold on
        interval = bernstd( alpha, niters );
        h(2) = yline(interval(1), ':', 'LineWidth', 2 );
        h(3) = yline(interval(2), ':', 'LineWidth', 2 );
        h(4) = plot(FWHM_vec, squeeze(EECest(do_gauss+1,I,:)));
        hold on
        h(5) = plot(FWHM_vec, squeeze(conv_FWER(do_gauss+1,I,:)));
        h(6) = plot(FWHM_vec, squeeze(fine_FWER(do_gauss+1,I,:)));
        h(7) = plot(FWHM_vec, squeeze(lat_FWER(do_gauss+1,I,:)));
        xlabel('FWHM'); ylabel('FWER');
%         ylim([0,0.06])
        xticks(FWHM_vec)
        if nsubj == 50
            legend(h(4:7), 'Expected number of maxima',...
                'Convolution FWER', 'Fine Lattice FWER', ...
                'Lattice FWER', 'Location', 'SE')
        end
        title(['FWER vs applied smoothness for N = ', num2str(nsubj)]);
        if do_gauss == 1
            export_fig([ncfloc, 'Figures/Simulations/NormalSims/tmarg_nsubj', num2str(nsubj), '_DG_1.pdf'], '-transparent')
        else
            export_fig([ncfloc, 'Figures/Simulations/NormalSims/tmarg_nsubj', num2str(nsubj), '.pdf'], '-transparent')
        end
    end
end
%%
FWHM = 4;
quantile = 0.05;
for do_gauss = [0,1]
    for nsubj = [20,50,100]
        clf
        load([ncfloc, '\Simulations\Gaussianization_Sims\Coverage\FWHM_', num2str(FWHM)...
            '_nsubj', num2str(nsubj),'_DG_', num2str(do_gauss),'.mat'])
        [ECmean, ECstd, x] = tailECcurve(coverage.allmaxima, quantile);
        h(1) = plot(x, ECmean, 'color', def_col('blue'));
        hold on
        
        % Add error bars
        h(2) = plot(x, ECmean+(norminv(0.975)/sqrt(length(coverage.latmaxima)))*ECstd,...
            '--', 'color', def_col('blue'));
        h(3) = plot(x, max(0,ECmean-(norminv(0.975)/sqrt(length(coverage.latmaxima)))*ECstd),...
            '--', 'color', def_col('blue'));
        
        EC_nonstat = EEC( x, mean(coverage.storeLKCs,2)', 1, 'T', nsubj-1 );
        h(4) = plot(x, EC_nonstat, 'color', def_col('red'));
        if do_gauss == 1
            title(['EC curves for the Gaussianized data for N = ', num2str(nsubj)])
        else
            title(['EC curves for the original data for N = ', num2str(nsubj)])
        end
        if nsubj == 50
            xlim([4.5,6.5])
        elseif nsubj == 100
            xlim([4.2,5.6])
        end
        xlabel('Threshold')
        ylabel('Euler characteristic')
        ylim([0,0.05])
        export_fig([ncfloc, 'Figures/Simulations/ECcurves/EC_nsubj', num2str(nsubj),...
            'FWHM', num2str(FWHM), 'DG_', num2str(do_gauss),'.pdf'], '-transparent')
    end
end
%%
global ncfloc

for FWHM = [2,5]
    clf
    nsubj_vec = 10:10:150;
%     nsubj_vec = [10:10:80,100:10:150];
    conv_FWER = zeros(2, length(nsubj_vec));
    fine_FWER = zeros(2, length(nsubj_vec));
    lat_FWER = zeros(2, length(nsubj_vec));
    
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I);
        for do_gauss = [0,1]
            load([ncfloc, '\Simulations\Gaussian_Sims\Coverage\Orig\FWHM_', num2str(FWHM)...
                '_nsubj', num2str(nsubj),'_DG_', num2str(do_gauss),'.mat'])
            conv_FWER(do_gauss+1, I) = coverage.conv;
            fine_FWER(do_gauss+1, I) = coverage.finelat;
            lat_FWER(do_gauss+1, I) = coverage.lat;
        end
    end
    
    set(0,'defaultAxesFontSize', 15); %This sets the default font size.
    
    alpha = 0.05; niters = 5000;
    h(1) = yline(alpha, '-', 'LineWidth', 1 );
    hold on
    interval = bernstd( alpha, niters );
    h(2) = yline(interval(1), ':', 'LineWidth', 2 );
    h(3) = yline(interval(2), ':', 'LineWidth', 2 );
    h(4) = plot(nsubj_vec,conv_FWER(1,:));
    h(5) = plot(nsubj_vec,conv_FWER(2,:));
    h(6) = plot(nsubj_vec,lat_FWER(1,:), '--','color', def_col('blue'));
    h(7) = plot(nsubj_vec,lat_FWER(2,:), '--','color', def_col('red'));
    
    xlabel('N: number of subjects')
    ylabel('FWER')
    xlim([10,150])
    if FWHM == 5
        legend(h(4:7), 'Original data - Convolution FWER',...
            'Gaussianized data - Convolution FWER', 'Original data - Lattice FWER', ...
            'Gaussianized data - Lattice FWER', 'Location', 'SE')
    end
    title(['FWER vs N for FWHM = ', num2str(FWHM)])
    ylim([0,0.09])
    yticks(0:0.01:0.09)
    export_fig([ncfloc, 'Figures/Simulations/NormalSims/tmarg_FWER/tmarg_FWHM', num2str(FWHM), '.pdf'], '-transparent')
    % yline(0.05, '--','Linewidth', 2)
end

