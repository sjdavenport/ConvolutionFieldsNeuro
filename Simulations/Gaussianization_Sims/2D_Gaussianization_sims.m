% Generate the mask
MNImask = imgload('MNImask');
slice = 45;
mask2D = MNImask(:,:,slice);
[ ~, mask2D ] = mask_bounds( mask2D )

%%
field_type = 'T';  %Options are: 'T', 'L', 'S', 'S2', 'N' see wfield for details
field_params = 3; % Only relevant if field_type is 'T' or 'L'
nsubj = 50;

FWHM = 2;
nsubj_vec = [10,20,50];
nsubj_vec = 20;
resadd = 1; niters = 5000;

for do_gauss = [0,1]
    for I = 1:length(nsubj_vec)
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( [FWHM, FWHM], resadd );
        rng(mod(FWHM,5) + nsubj)
        
        if do_gauss == 0
            spfn = @(nsubj) wfield( mask2D, nsubj, field_type, field_params );
        else
            spfn = @(nsubj) Gaussianize(wfield( mask2D, nsubj, field_type, field_params ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters)
        
        save(   ,'coverage')
    end
end