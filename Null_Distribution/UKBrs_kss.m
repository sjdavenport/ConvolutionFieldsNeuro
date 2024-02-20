%% Status: couldn't find the file used to run this, 
% next step is to rewrite such a file and re-run the analysis but on
% smoother data to see what you get!!
image_loc = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Null_Distribution\';

sumofmasks = imgload([image_loc, 'R2Block_SOM.nii']);
rs_sum = imgload([image_loc, 'R2Block_fullsum.nii']);
rs_sqsum = imgload([image_loc, 'R2Block_full_sqsum.nii']);
rs_power4 = imgload([image_loc, 'R2Block_full_power4.nii']);

%%
intersection_mask = (sumofmasks == 6968);

%%
rs_var = rs_sqsum/6968 - (rs_sum.^2)/6968^2;
rs_kurtosis = nan2zero((rs_power4/6968)./rs_var.^2).*intersection_mask;
imagesc(nan2zero(rs_kurtosis(:,:,30)))

%%
brainmove(rs_kurtosis, [0,0,30], intersection_mask, 0, 1)

%%
histogram(rs_kurtosis(~(rs_kurtosis.*intersection_mask==0)))

%%
histogram(rs_var(~(rs_var==0)))

%%


%%
nsim = 10000;
% a = randn(1,nsim);
a = wfield( nsim, 1, 'T', 3).field;
(sum(a.^4)/nsim)/var(a)^2