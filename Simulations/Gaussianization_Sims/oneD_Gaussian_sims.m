%% Run 1D Gaussian coverage simulations
nvox = 100;
global ncfloc

FWHM_vec = 6;
nsubj_vec = 10:20:100;
resadd = 1; niters = 5000;
field_type = 'T';  %Options are: 'T', 'L', 'S', 'S2', 'N' see wfield for details
field_params = 3; % Only relevant if field_type is 'T' or 'L'

do_gauss = 1;
smo = 0;
for I = 1:length(nsubj_vec)
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( [FWHM], resadd );
        rng(mod(FWHM,5) + nsubj)
        
        %         spfn = @(nsubj) wfield( mask2D, nsubj ); Old version, not masked!
        %         Okay as didn't Gaussianize.
        if do_gauss == 1
            spfn = @(nsubj) Gaussianize(wfield( [nvox,1], nsubj, field_type, field_params ), smo);
        else
            spfn = @(nsubj) Mask(wfield( [nvox,1], nsubj, field_type, field_params ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters);
        
        if smo == 0
            save([ncfloc, 'Simulations/Gaussianization_Sims/Coverage/1D_FWHM_',...
                num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss)],'coverage')
        else
            save([ncfloc, 'Simulations/Gaussianization_Sims/Coverage/Smo/1D_FWHM_',...
                num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss), 'smo', num2str(smo)],'coverage')
        end
    end
end

%% Run 1D Gaussian coverage simulations
nvox = 100;
global ncfloc

FWHM_vec = 2:6;
nsubj_vec = [10,20,50];
resadd = 1; niters = 5000;
field_type = 'T';  %Options are: 'T', 'L', 'S', 'S2', 'N' see wfield for details
field_params = 3; % Only relevant if field_type is 'T' or 'L'

do_gauss = 1;
for I = 1:length(nsubj_vec)
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( [FWHM], resadd );
        rng(mod(FWHM,5) + nsubj)
        
        %         spfn = @(nsubj) wfield( mask2D, nsubj ); Old version, not masked!
        %         Okay as didn't Gaussianize.
        if do_gauss == 1
            spfn = @(nsubj) Gaussianize(wfield( [nvox,1], nsubj, field_type, field_params ), 0, 2);
        else
            spfn = @(nsubj) Mask(wfield( [nvox,1], nsubj, field_type, field_params ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters);
        
        save([ncfloc, 'Simulations/Gaussianization_Sims/Coverage/Squareroot/1D_FWHM_',...
                num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss)],'coverage')
    end
end


%%
niters = 10000;
max_locs_G3 = zeros(1,niters);
for I = 1:niters
    modul(I,100)
    spfn = @(nsubj) Gaussianize(wfield( [nvox,1], nsubj, field_type, field_params ), 5);
    a = spfn(50);
    b = convfield_t(a,6);
    
    max_locs_G3(I) = find(b.field == max(b.field));
end
%%
nvox = 100
spfn = @(nsubj) Gaussianize(wfield( [nvox,1], nsubj ), 5);

spfn(50)

%%
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
spfn = @(nsubj) Gaussianize(Mask(wfield( mask2D, nsubj )));

spfn(50)

%% 3D data
MNImask = imgload('MNImask');
[ ~, mask3D ] = mask_bounds( MNImask );
spfn = @(nsubj) Gaussianize(Mask(wfield( mask3D, nsubj )));

spfn(50)
%%
nsubj = 100;
use1D = 0;
FWHM_vec = 2:6;
coveragestore = zeros(1,length(FWHM_vec));
for I = 1:length(FWHM_vec)
    if use1D
        load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    else
        load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Orig\FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    end
    coveragestore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore)
if nsubj == 10
    ylim([0,0.15])
else
    ylim([0,0.09])
end
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)

%% Less vs More
nsubj = 50;
FWHM_vec = 2:5;
coveragestore1Dt2tless = zeros(1,length(FWHM_vec));
coveragestore1Dt2tmore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Less\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore1Dt2tless(I) = coverage.conv;
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\More\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore1Dt2tmore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore1Dt2tless)
hold on
plot(FWHM_vec, coveragestore1Dt2tmore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)
legend('less','more')

%% Less vs Orig
nsubj = 20;
FWHM_vec = 2:5;
coveragestore1Dt2tless = zeros(1,length(FWHM_vec));
coveragestore1Dt2tmore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Less\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore1Dt2tless(I) = coverage.conv;
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Orig\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore1Dt2tmore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore1Dt2tless)
hold on
plot(FWHM_vec, coveragestore1Dt2tmore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)
legend('less','Orig')


%% Smo!
nsubj = 100;
FWHM_vec = 2:6;
coveragestore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussianization_Sims\Coverage\Smo\Nonedgeadjust\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1smo5.mat'])
    coveragestore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)


%% Orig!
nsubj = 100;
FWHM_vec = 2:6;
coveragestore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussianization_Sims\Coverage\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)

%% Compare results
nsubj = 100;
FWHM_vec = 2:6;
coveragestoreprechange = zeros(1,length(FWHM_vec));
coveragestorepostchange = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussianization_Sims\Coverage\Smo\Nonedgeadjust\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1smo5.mat'])
    coveragestoreprechange(I) = coverage.conv;
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussianization_Sims\Coverage\Smo\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1smo5.mat'])
    coveragestorepostchange(I) = coverage.conv;
end
plot(FWHM_vec, coveragestoreprechange)
hold on
plot(FWHM_vec, coveragestorepostchange)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)
