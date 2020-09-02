function [maxnmin, LKCs, subsets, alphathresholds] = storeUKBcov( RSfolder, nsubj, params, savefileloc, do_gauss, subsets )
% storeUKBcov( RSfolder, nsubj, params, savefileloc, do_gauss, subsets )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  RSfolder
%  nsubj        the size of each sample to be sampled from the data
%  params       an object of class ConvFieldParams
%  savefileloc    a string giving the location of where to save the
%                 coverage information
% Optional
%  do_gauss     0/1 whether to Gaussianize or not. Default is 1: to
%               Gaussianize
%  subsets
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% RSfolder = 'R2Block'; nsubj = 5; FWHM = 3, resadd = 1; 
% params = ConvFieldParams([FWHM,FWHM,FWHM], resadd)
% filename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd', num2str(resadd)];
% global ncfloc; savedir = [ncfloc, 'Coverage/R2Block_coverage/'];
% savefileloc = [savedir, filename]; do_gauss = 1; niters = 1;
% storeUKBcov( RSfolder, nsubj, params, savefileloc, do_gauss, niters )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Get important constants
%--------------------------------------------------------------------------
% Set the number of dimensions
D = 3;
version = [true,true, false];

%%  Add/check optional values
%--------------------------------------------------------------------------
% If subsets is not provided generate a random set!
if iscell(subsets)
    niters = length(subsets);
else
    niters = subsets;
    subsets = cell(1, niters);
    
    global jalaloc
    load([jalaloc, 'feat_stuff/runfeat/', RSfolder, '/warped_subj_ids'], 'subj_ids');
    sids = intersect(subj_ids.cope, subj_ids.mask);
    total_nsubj = length(sids);
    
    for I = 1:niters
        subsets{I} = randsample(total_nsubj, nsubj, 0);
    end
end

if ~exist('do_gauss', 'var')
    do_gauss = 1;
end

%%  Initialize vectors
%--------------------------------------------------------------------------
% Initialize the maxnmin structure
maxnmin = struct();

% Initialize vectors to store the maxima
maxnmin.latmaxima     = zeros( 1, niters );
maxnmin.finelatmaxima = zeros( 1, niters );
maxnmin.convmaxima    = zeros( 1, niters );

% Initialize vectors to store the minima
maxnmin.latminima     = zeros( 1, niters );
maxnmin.finelatminima = zeros( 1, niters );
maxnmin.convminima    = zeros( 1, niters );

% Initialize matrices to store the alpha thresholds and the LKCs
alphathresholds = zeros( 1, niters );
LKCs = struct();
LKCs.L = zeros(D, niters);
LKCs.L0 = zeros(1, niters);

% Initialize matrices to store all of the high maxima and low minima
npeaks = 3;
maxnmin.allmaxima = zeros( npeaks, niters );
maxnmin.allminima = zeros( npeaks, niters );

%%  Main Function Loop
%--------------------------------------------------------------------------
% Obtain the sample function that draws the data
spfn = getUKBspfn( RSfolder, do_gauss, 'sample_intersect' );

tic
for I = 1:niters
    %Display I if mod(I,10) = 0
    modul(I,10)
    
    % Obtain the data
    lat_data = spfn(subsets{I});

    lat_data = Mask(lat_data);
    [ ~, threshold, maximum, L, minimum ] = vRFT(lat_data, params, npeaks, 1, version);
    LKCs.L(:,I) = L.L';
    LKCs.L0(I) = L.L0;
    if any(isnan(L.L))
        warning('NAN LKC recorded')
    end
    
    % Record the maxima 
    maxnmin.latmaxima(I) = maximum.lat;
    maxnmin.finelatmaxima(I) = maximum.finelat;
    maxnmin.convmaxima(I) = maximum.conv;
    maxnmin.allmaxima(1:npeaks,I) = maximum.allmaxima';
    maxnmin.alphathresholds(I) = threshold;
    
    % Error checking loop 
    if maximum.finelat > maximum.conv + 10^(-2)
        a = 1
    end
    
    % Record the minima
    maxnmin.latminima(I) = minimum.lat;
    maxnmin.finelatminima(I) = minimum.finelat;
    maxnmin.convminima(I) = minimum.conv;
    maxnmin.allminima(1:npeaks,I) = minimum.allminima';
    
    save(savefileloc, 'maxnmin', 'LKCs', 'subsets', 'params', 'do_gauss')
end

timing = toc;
save(savefileloc, 'maxnmin', 'LKCs', 'subsets', 'params', 'do_gauss', 'timing')

end

