do_gauss = 1;
RSfolder = 'R2Block';
spfn = getUKBspfn( RSfolder, do_gauss, 'sample_intersect' );

tic; lat_data = spfn(1:20); toc
FWHM = 3; resadd = 1;
params = ConvFieldParams([FWHM,FWHM,FWHM], resadd);

tic; cfield = convfield(lat_data, params); toc
tic; dcfield = convfield(lat_data, params, 1); toc

tic; [ L, L0, nonstatInt ] = LKC_voxmfd_est( cfield, dcfield ); toc

tic; [ output_image, threshold, maximum, L ] = vRFT(lat_data, params ); toc;

subsets = {1:20};
tic; rc = record_coverage( spfn, subsets, params, 1); toc
