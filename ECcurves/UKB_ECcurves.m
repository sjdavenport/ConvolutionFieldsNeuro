function UKB_ECcurves( FWHM, nsubj_vec, do_gauss, RSfolder, mask, niters )
% UKB_ECCURVES( FWHM, nsubj_vec, RSfolder, do_gauss, mask, niters )
% generates EC curves of t fieldsfor the UK Biobank data
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  FWHM        the FWHM with which to smooth the datas
%  nsubj_vec   a vector giving the number of subjects you wish to use
% Optional
%  do_gauss
%  RSfolder
%  mask
%  niters      the number of EC curves to calculate. Default is 1000.
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% UKB_ECcurves( 2, 10, 0, 'R2Block' )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'niters', 'var' )
   % default option of niters
   niters = 1000;
end

if ~exist( 'do_gauss', 'var' )
   % default option of do_gauss
   do_gauss = 1;
end

if ~exist( 'mask', 'var' )
   % default option of mask
   mask = 'sample_intersect';
end

if ~exist('RSfolder', 'var')
    % default option of RSfolder
    RSfolder = 'R2Block';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% Use resadd = 0 for memory 
resadd = 0;
params = ConvFieldParams([FWHM, FWHM, FWHM], resadd);

% Describe the set of points at which to calculate the EC curves
limits = [-8,8]; increm = 0.01;
thresholds = limits(1):increm:limits(2);

% Load the total number of processed subjects
global jalaloc ncfloc
load([jalaloc, 'feat_stuff/runfeat/', RSfolder, '/warped_subj_ids'], 'subj_ids');
sids = intersect(subj_ids.cope, subj_ids.mask);
total_nsubj = length(sids);

% Load the sample function, to obtain subsets of the data
spfn = getUKBspfn( RSfolder, do_gauss, mask );

% Initialize a matrix to store the EC curves
store_curves = zeros(length(nsubj_vec),niters, length(thresholds));

% Loop to calculate the EC curves
for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I);
    subsets = cell(1,niters);
    for J = 1:niters
        subsets{J} = randsample(total_nsubj, nsubj, 0);
    end
    for J = 1:niters
        lat_data = spfn(subsets{J});
        lat_data = Mask(lat_data);
        
        tcfield = convfield_t(lat_data, params);
        curve = ECcurve( tcfield, limits, increm );
        store_curves(I,J,:) = curve;
        save([ncfloc,'ECcurves/UKB_ECcurves/UKB_ECcurves_FWHM_', num2str(FWHM), ...
            '_nsubj_', num2str(nsubj),'DG_', num2str(do_gauss)], 'store_curves', 'thresholds')
    end
end

end

