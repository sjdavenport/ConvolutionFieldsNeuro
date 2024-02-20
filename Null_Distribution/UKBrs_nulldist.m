rsdataloc = '/vols/Scratch/ukbiobank/nichols/SelectiveInf/feat_runs/R2Block_warped/';
subjcopefiles = filesindir(rsdataloc, '_cope5_');
subjmaskfiles = filesindir(rsdataloc, '_mask_');
% subjcopeids = zeros(1,6970);
subjmaskids = zeros(1,6968);
for I = 1:6968
    subjmaskids(I) = str2double(subjmaskfiles{I}(1:7));
end
% for I = 1:6970
%     subjcopeids(I) = str2double(subjcopefiles{I}(1:7));
% end
% missing_subj_ids = setdiff(subjcopeids, )

saved_image_loc = '/vols/Scratch/ukbiobank/nichols/SelectiveInf/ConvolutionFieldsNeuro/Null_Distribution/';
sumofmasks = imgload([saved_image_loc, 'R2Block_SOM.nii']);
rs_sum = imgload([saved_image_loc, 'R2Block_fullsum.nii']);
rs_sqsum = imgload([saved_image_loc, 'R2Block_full_sqsum.nii']);
rs_power4 = imgload([saved_image_loc, 'R2Block_full_power4.nii']);
intersection_mask = (sumofmasks == 6968);
intersection_mask = intersection_mask > 0;

rs_var = rs_sqsum/6968 - (rs_sum.^2)/6968^2;
rs_var_masked = rs_var(intersection_mask);
rs_std_masked = sqrt(rs_var_masked);
rs_mean = rs_sum/6968;
rs_mean_masked = rs_mean(intersection_mask);

x_vals = -7:0.01:7;
marg_dist = zeros(1, length(x_vals));
marg_dist_demeaned = zeros(1, length(x_vals));

ex_indices = [15000,100000,30000,40000,50000,60000];
ex_data = zeros(2, length(ex_indices), 6968);

for I = 1:6968
    I
    im = imgload([rsdataloc, num2str(subjmaskids(I)), '_cope5_MNI.nii.gz']);
    im_masked = im(intersection_mask);
    im_masked_dm_ds = (im_masked - rs_mean_masked)./rs_std_masked;
    im_masked_ds = im_masked./rs_std_masked;
    for J = 1:length(x_vals)
        marg_dist(J) = marg_dist(J) + sum(im_masked_dm_ds < x_vals(J));
        marg_dist_demeaned(J) = marg_dist_demeaned(J) + sum(im_masked_ds < x_vals(J));
    end
    ex_data(1,:,I) = im_masked_dm_ds(ex_indices);
    ex_data(2,:,I) = im_masked_ds(ex_indices);
end

marg_dist = marg_dist/(6968*sum(intersection_mask(:)));
marg_dist_demeaned = marg_dist_demeaned/(6968*sum(intersection_mask(:)));
save([saved_image_loc, 'nulldist'], 'marg_dist', 'marg_dist_demeaned', 'ex_data');