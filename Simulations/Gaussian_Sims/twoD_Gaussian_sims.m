%% Run 2D Gaussian coverage simulations
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
global ncfloc

FWHM_vec = 2;
nsubj_vec = 30:30:150;
resadd = 1; niters = 5000;

do_gauss = 0;

for I = 1:length(nsubj_vec)
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( [FWHM, FWHM], resadd );
        rng(mod(FWHM,5) + nsubj)
        
%         spfn = @(nsubj) wfield( mask2D, nsubj ); Old version, not masked!
%         Okay as didn't Gaussianize.
        if do_gauss == 1
            spfn = @(nsubj) Gaussianize(Mask(wfield( mask2D, nsubj )));
        else
            spfn = @(nsubj) Mask(wfield( mask2D, nsubj ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters);
        
        save([ncfloc, 'Simulations/Gaussian_Sims/Coverage/FWHM_',...
            num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss)],'coverage')
    end
end

%% Run 2D Gaussian coverage simulations (no mask)
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
global ncfloc

FWHM_vec = 6;
nsubj_vec = [20,50,100];
resadd = 1; niters = 5000;

do_gauss = 1;

for I = 1:length(nsubj_vec)
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( [FWHM, FWHM], resadd );
        rng(mod(FWHM,5) + nsubj)
        
%         spfn = @(nsubj) wfield( mask2D, nsubj ); Old version, not masked!
%         Okay as didn't Gaussianize.
        if do_gauss == 1
            spfn = @(nsubj) Gaussianize(wfield( mask2D, nsubj ));
        else
            spfn = @(nsubj) Mask(wfield( mask2D, nsubj ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters);
        
        save([ncfloc, 'Simulations/Gaussian_Sims/Coverage/NM_FWHM_',...
            num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss)],'coverage')
    end
end


%%
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
params = ConvFieldParams([3,3], 0, 0);
spfn = @(nsubj) Gaussianize(convfield(Mask(wfield( mask2D, nsubj )), params));

spfn(20)

%%
resadd = 3;
params = ConvFieldParams([3,3], resadd, 0);
out = convfield(wfield( [50,50], nsubj ), params);
est_smooth(out.field)
% spfn(20)

%%
clf
nsubj = 20;
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
spfn = @(nsubj) Gaussianize(Mask(wfield( mask2D, nsubj )));
a = spfn(nsubj);

spfn = @(nsubj) wfield( mask2D, nsubj);
wn = spfn(nsubj);

FWHM = 4;
smooth_fields = convfield(a, FWHM);
smooth_fields_wn = convfield(wn, FWHM);

data = [];
data_wn = [];
for I = 1:nsubj
%     I
    sm = smooth_fields.field(:,:,I);
    sm_wn = smooth_fields_wn.field(:,:,I);
    data = [data, sm(mask2D)];
    data_wn = [data_wn, sm_wn(mask2D)];
end
histogram(data)
hold on
histogram(data_wn(:))

%%
decorr(smooth_fields)

%% 3D data
MNImask = imgload('MNImask');
[ ~, mask3D ] = mask_bounds( MNImask );
spfn = @(nsubj) Gaussianize(Mask(wfield( mask3D, nsubj )));

spfn(50)

%% std smoothing testing

%%
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
spfn = @(nsubj) Mask(wfield( mask2D, nsubj ));

data = spfn(50)

%%
params = ConvFieldParams([4,4], 0, 0);
smoothedstd = convfield(std(data), params);
imagesc(Mask(smoothedstd))

%%
isequal(std(data).field, std(data.field,0,3))

%% Smo!
nsubj = 50;
FWHM_vec = 2:6;
coveragestore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Orig\FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1.mat'])
    coveragestore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)