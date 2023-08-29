function comp_gauss_coverage( field_type, field_params, mask2D, nsubj_vec, ...
                        FWHM_vec, do_gauss, saveloc, niters, resadd )
% comp_gauss_coverage computes and saves the coverage on a given mask for
% the original and Gaussianized datasets.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  field_type:  Options are: 'T' (tfield), 'L' (Laplacian) and
%               'S', 'S2', 'N' see wfield for details
%  field_params: % Only relevant if field_type is 'T' or 'L', default is 3,
%               see wfield for details
%  do_gauss: if 0 no transformation, 1 Gaussianization transformation, 2:
%  the inverse hyperbloic sinh transformation.
%--------------------------------------------------------------------------
% OUTPUT
% Saves two coverage files, one for the original data and one for the
% Gaussianized datasets.
%--------------------------------------------------------------------------
% EXAMPLES
%
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'resadd', 'var' )
    % Default value
    resadd = 1;
end

if ~exist( 'niters', 'var' )
    % Default value
    niters = 5000;
end

D = length(size(mask2D));

%%  Main Function Loop
%--------------------------------------------------------------------------
for I = 1:length(nsubj_vec)
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        nsubj = nsubj_vec(I);
        params = ConvFieldParams( repmat(FWHM, D), resadd );
        
        % Set the random seed for comparability reasons
        rng(FWHM + nsubj,'twister')
        
        if do_gauss == 0
            spfn = @(nsubj) wfield( mask2D, nsubj, field_type, field_params );
        elseif do_gauss == 1
            spfn = @(nsubj) Gaussianize(wfield( mask2D, nsubj, field_type, field_params ));
        else
            spfn = @(nsubj) asinh_trans(wfield( mask2D, nsubj, field_type, field_params ));
        end
        coverage = record_coverage( spfn, nsubj, params, niters);
        
        save([saveloc, '/FWHM_',...
            num2str(FWHM), '_nsubj', num2str(nsubj), '_DG_', num2str(do_gauss)],'coverage')
    end
end

end

