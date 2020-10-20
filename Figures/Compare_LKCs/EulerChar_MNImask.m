MNImask = imgload('MNImask');

L0 = EulerChar( MNImask, 0.5, 3 )

global jalaloc
int_mask = imgload([jalaloc, 'feat_stuff/runfeat/R2Block/Images/R2Block_intersection_mask.nii']);

L0 = EulerChar( int_mask, 0.5, 3 )
L0 = EulerChar( int_mask.*MNImask, 0.5, 3 )


subplot(2,1,1)
imagesc(int_mask(:,:,50))
subplot(2,1,2)
imagesc(int_mask(:,:,50).*MNImask(:,:,50))

%%
white_noise = wfield(logical(int_mask));
FWHM = 2; resadd = 1;
params = ConvFieldParams([FWHM, FWHM, FWHM], resadd);
smooth_noise = convfield(white_noise, params);

EulerChar( smooth_noise.mask, 0.5, 3 )