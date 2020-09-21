%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script runs the stationary smoothness simulations
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% 1D 
nvox = 100; mask = true([nvox, 1]); nsubj_vec = [20,50,100]; FWHM_vec = 0.5:0.5:6;
global ncfloc
savefilename = [ncfloc, 'FWHMestimation/Store_FWHM_estimates/oneDstatsims_nvox', num2str(nvox)];
niters = 1000;
stat_smoothness_sims( mask, nsubj_vec, FWHM_vec, niters, savefilename )

%% %% 2D 
Dim = [50,50]; mask = true(Dim); nsubj_vec = [20,50,100]; FWHM_vec = 0.5:0.5:6;
savefilename = [ncfloc, 'FWHMestimation/Store_FWHM_estimates/twoDstatsims_Dim5050'];
stat_smoothness_sims( mask, nsubj_vec, FWHM_vec, 1000, savefilename )

%% %% 3D 
Dim = [30,30,30]; mask = true(Dim); nsubj_vec = [20,50,100]; FWHM_vec = 0.5:0.5:6;
savefilename = [ncfloc, 'FWHMestimation/Store_FWHM_estimates/threeDstatsims_Dim303030'];
stat_smoothness_sims( mask, nsubj_vec, FWHM_vec, 1000, savefilename )