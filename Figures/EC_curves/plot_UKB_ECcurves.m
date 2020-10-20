load('C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\ECcurves\UKB_ECcurves\UKB_ECcurves_FWHM_2_nsubj_10DG_0.mat')

store_curves = squeeze(store_curves);
mean_ECcurve = mean(store_curves,1);

plot(thresholds, mean_ECcurve)
hold on
plot(thresholds, store_curves(1,:))

%%
isequal(store_curves(1,:), store_curves(2,:))