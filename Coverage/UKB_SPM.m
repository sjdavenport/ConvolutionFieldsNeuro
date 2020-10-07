function UKB_SPM( FWHM, nsubj, do_gauss, RS_folder, mask, subsets )
% UKB_SPM( FWHM, nsubj, do_gauss, RS_folder, mask, subsets ) calculates the 
% LKCs using SPM.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% UKB_SPM( 2, 10, 0, 'RS_2Block', 'intersection_mask', 1 )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------

% Calculate the random subsets of subjects to use!
if iscell(subsets)
    niters = length(subsets);
else
    niters = subsets;
    subsets = cell(1, niters);
    
    global jalaloc
    load([jalaloc, 'feat_stuff/runfeat/', RS_folder, '/warped_subj_ids'], 'subj_ids');
    sids = intersect(subj_ids.cope, subj_ids.mask);
    total_nsubj = length(sids);
    
    for I = 1:niters
        subsets{I} = randsample(total_nsubj, nsubj, 0);
    end
end

if ischar(mask)
    mask = imgload([jalaloc, 'feat_stuff/runfeat/R2Block/Images/R2Block_intersection_mask.nii']);
end

%%  Main Function Loop
%--------------------------------------------------------------------------
global ncfloc
spfn = getUKBspfn( RS_folder, do_gauss, mask );

resadd = 0; params = ConvFieldParams([FWHM,FWHM,FWHM], resadd);

fwhm_est_forman = cell(1, niters);
fwhm_est_kiebel = cell(1, niters);
L_forman = cell(1, niters);
L0_forman = zeros(1, niters);
L_kiebel = cell(1, niters);
L0_kiebel = zeros(1, niters);
for I = 1:niters
    lat_data = spfn(subsets{I});
    smooth_fields = convfield(lat_data, params);
    [ fwhm_est_forman{I}, fwhm_est_kiebel{I} ] = est_smooth(smooth_fields.field, smooth_fields.mask);
    [ L_forman{I}, L0_forman(I) ] = LKC_SPM_est( fwhm_est_forman{I}, mask );
    [ L_forman{I}, L0_forman(I) ] = LKC_SPM_est( fwhm_est_kiebel{I}, mask );
    save([ncfloc, 'Coverage/Stationary_LKCs/FWHM_', num2str(FWHM),'_nsubj_', num2str(nsubj),'DG_', num2str(do_gauss)],...
         'L_forman', 'L0_forman', 'L_kiebel', 'L0_kiebel', 'fwhm_est_forman', 'fwhm_est_kiebel');
end

end

