function [forman, kiebel, conv] = stat_smoothness_sims( mask, nsubj_vec, FWHM_vec, niters, savefilename )
% STAT_SMOOTHNESS_SIMS runs stationary smoothness estimation simulations
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  mask       the mask on which to generate the data
%  nsubj      the number of fields to run in each simulation in order to
%             estimate the smoothness
%  FWHM_vec   a vector giving the set of FWHM with which to run the
%             simulations
% Optional
%  niters     the number of iterations to run the algorithm for. Default is
%             500.
%  savefilename   the filename (including the contains directory) in which
%                 to save the simulation results 
%--------------------------------------------------------------------------
% OUTPUT
%  three structural arrays: forman, kiebel and conv each with two options:
%   fwhm_ests  a length(FWHM_vec) by niters matrix giving the fwhm
%              estimate in each setting and iteration
%   Lambda_ests   a length(FWHM_vec) by niters matrix giving the Lambda
%              estimate in each setting and iteration
%--------------------------------------------------------------------------
% EXAMPLES
% nvox = 10; mask = true([nvox, 1]); nsubj = 10; FWHM_vec = [2,3];
% stat_smoothness_sims( mask, nsubj, FWHM_vec )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'niters', 'var' )
   % default option of opt1
   niters = 500;
end

%%  Main Function Loop
%--------------------------------------------------------------------------

% Initialize the storage matrices for the FWHM and Lambda estimates
forman.fwhm_ests = zeros(length(FWHM_vec), niters);
forman.Lambda_ests = zeros(length(FWHM_vec), niters);
kiebel.fwhm_ests = zeros(length(FWHM_vec), niters);
kiebel.Lambda_ests = zeros(length(FWHM_vec), niters);
conv.fwhm_ests = zeros(length(FWHM_vec), niters);
conv.Lambda_ests = zeros(length(FWHM_vec), niters);

% Initialize the storage matrices for the FWHM and Lambda estimates
forman.fwhm_ests_unscaled = zeros(length(FWHM_vec), niters);
forman.Lambda_ests_unscaled = zeros(length(FWHM_vec), niters);
kiebel.fwhm_ests_unscaled = zeros(length(FWHM_vec), niters);
kiebel.Lambda_ests_unscaled = zeros(length(FWHM_vec), niters);
conv.fwhm_ests_unscaled = zeros(length(FWHM_vec), niters);
conv.Lambda_ests_unscaled = zeros(length(FWHM_vec), niters);

% Main loop
for L = 1:length(nsubj_vec)
    L
    nsubj = nsubj_vec(L);
    savefilename2use = [savefilename, '_nsubj', num2str(nsubj)];
    for I = 1:length(FWHM_vec)
        I
        FWHM = FWHM_vec(I);
        for J = 1:niters
            [forman_sim, kiebel_sim, conv_sim] = compare_smoothness_ests( mask, nsubj, FWHM );
            forman.fwhm_ests(I, J) = mean(forman_sim.fwhm);
            forman.Lambda_ests(I, J) = mean(forman_sim.Lambda);
            kiebel.fwhm_ests(I, J) = mean(kiebel_sim.fwhm);
            kiebel.Lambda_ests(I, J) = mean(kiebel_sim.Lambda);
            conv.fwhm_ests(I, J) = mean(conv_sim.fwhm);
            conv.Lambda_ests(I, J) = conv_sim.Lambda;
            
            forman.fwhm_ests_unscaled(I, J) = mean(forman_sim.fwhm_unscaled);
            forman.Lambda_ests_unscaled(I, J) = mean(forman_sim.Lambda_unscaled);
            kiebel.fwhm_ests_unscaled(I, J) = mean(kiebel_sim.fwhm_unscaled);
            kiebel.Lambda_ests_unscaled(I, J) = mean(kiebel_sim.Lambda_unscaled);
            conv.fwhm_ests_unscaled(I, J) = mean(conv_sim.fwhm_unscaled);
            conv.Lambda_ests_unscaled(I, J) = mean(conv_sim.Lambda_unscaled);
        end
        
        % Save the FWHM calculations in a .mat file
        if exist('savefilename', 'var')
            save(savefilename2use, 'forman', 'kiebel', 'conv', 'FWHM_vec', 'niters', 'mask');
        end
    end
end

end

