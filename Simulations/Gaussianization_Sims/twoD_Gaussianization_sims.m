MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
global ncfloc

field_type = 'L';  %Options are: 'T', 'L', 'S', 'S2', 'N' see wfield for details
field_params = 3; % Only relevant if field_type is 'T' or 'L'

if strcmp(field_type, 'L')
    foldername = 'Laplacian';
elseif strcmp(field_type, 'L')
    foldername = 'tfield';
end

do_gauss = 1;
nsubj_vec = 10;
FWHM_vec = 5;

saveloc = [ncfloc, 'Simulations/Gaussianization_Sims/Coverage/', foldername];

comp_gauss_coverage( field_type, field_params, mask2D, nsubj_vec, ...
                                        FWHM_vec, do_gauss, saveloc)

%% Test the masking
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );

field_type = 'T'; field_params = 3;
spfn = @(nsubj) Gaussianize(wfield( mask2D, nsubj, field_type, field_params ));

spfn(50)

%% Gaussianize validity demonstration
where_davenpor = 'C:/Users/12Sda/davenpor/';
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D );
field_type = 'T'; field_params = 3;

FWHM = 3; resadd = 0; params = ConvFieldParams([FWHM, FWHM], resadd);

niters = 1000;

for nsubj = [20,50,100]
    rng(mod(FWHM,5) + nsubj)
    orig_pval_store = [];
    G_pval_store = [];
    for I = 1:niters
        I
        Y = Mask(wfield(mask2D, nsubj, field_type, field_params));
        orig_tfield = convfield_t( Y, params );
        G_Y = Gaussianize(Y);
        G_tfield = convfield_t( G_Y, params );
        orig_pval_store = [orig_pval_store, 1 - tcdf(orig_tfield.field(orig_tfield.mask), nsubj-1)'];
        G_pval_store = [G_pval_store, 1 - tcdf(G_tfield.field(G_tfield.mask), nsubj-1)'];
    end
    save([where_davenpor, 'Data/Sim_Data/FWHM',  num2str(FWHM), '_nsubj', num2str(nsubj)],...
        'orig_pval_store', 'G_pval_store')
end
% subplot(2,1,1)
% histogram(orig_pvalues, 'BinWidth', 0.05)
% title('Pvalues - No Gaussianization')
% subplot(2,1,2)
% histogram(G_pvalues, 'BinWidth', 0.05)
% title('Pvalues - Gaussianized')

%%
FWHM = 3; nsubj = 100;
load([where_davenpor, 'Data/Sim_Data/FWHM', num2str(FWHM), '_nsubj', num2str(nsubj)],...
                    'orig_pval_store', 'G_pval_store')
clf
alpha = 0.05;
[F, X] = ecdf(orig_pval_store);
plot(X, F)
xlim([0,alpha])
ylim([0,alpha])
hold on
[G_F, G_X] = ecdf(G_pval_store);
plot(G_X,G_F)
plot([0,alpha], [0,alpha])
legend('Original p-values', 'Gaussianized p-values', 'y = x', 'Location', 'SE')
xlabel('x'); ylabel('F(x)'); title('Comparing the p-value distributia')
global ncfloc
export_fig([ncfloc,'Figures/Simulations/pvalue-plots/nsubj_', num2str(nsubj),...
                            'FWHM', num2str(FWHM), '.pdf'], '-transparent')

%% Compare the histograms
subplot(2,1,1);
histogram(G_pval_store);
title('Gaussianized')
subplot(2,1,2);
histogram(orig_pval_store)
title('Original')
%%
index = 10000:1000:length(G_pval_store);
onevoxel_orig = orig_pval_store(index);
onevoxel_G = G_pval_store(index);

alpha = 0.05;
[F, X] = ecdf(onevoxel_orig);
plot(X, F)
xlim([0,alpha])
ylim([0,alpha])
hold on
[G_F, G_X] = ecdf(onevoxel_G);
plot(G_X,G_F)
plot([0,alpha], [0,alpha])
legend('Original p-values', 'Gaussianized p-values', 'y = x', 'Location', 'SE')
xlabel('x'); ylabel('F(x)');

%% Analyse Gaussianize on t data
wfield( mask2D, nsubj, field_type, field_params )

%% Smo!
nsubj = 10;
FWHM_vec = 2:6;
coveragestore = zeros(1,length(FWHM_vec));

for I = 1:length(FWHM_vec)
    load(['C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Simulations\Gaussian_Sims\Coverage\Smo\1D_FWHM_',num2str(FWHM_vec(I)),'_nsubj', num2str(nsubj),'_DG_1smo3.mat'])
    coveragestore(I) = coverage.conv;
end
plot(FWHM_vec, coveragestore)

ylim([0,0.09])
xlim([2,6])
hold on
yline(0.05, '--', 'LineWidth', 2)

%% Orig!
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