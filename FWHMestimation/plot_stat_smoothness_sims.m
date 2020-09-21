%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script plots the stationary smoothness simulations
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% 1D 
%% Load the data
nsubj = 100; nvox = 100;
global ncfloc
load([ncfloc, 'FWHMestimation/Store_FWHM_estimates/oneDstatsims_nvox', num2str(nvox), '_nsubj', num2str(nsubj)]);

sim_names = {'Forman', 'Kiebel', 'Convolution'};

%FWHM bias plot
clf
startat = 1.5; start_index = find(FWHM_vec == startat);
h(1) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
hold on
h(2) = abline('h', 0);
h(3) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
h(4) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NE')
ylabel('Bias'); xlabel('FWHM used to smooth');
title('Comparing FWHM estimates')

h(5) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('blue') );
h(6) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('red') );
h(7) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('yellow') );
legend(h([1,3,4,5,6,7]),sim_names{1}, sim_names{2}, sim_names{3}, [sim_names{1}, ' unscaled'], [sim_names{2}, ' unscaled'], [sim_names{3}, ' unscaled'], 'Location', 'NE')

%% FWHM var plot
startat = 1.5; start_index = find(FWHM_vec == startat);
plot(FWHM_vec(start_index:end), std(forman.fwhm_ests(start_index:end,:),0,2))
hold on
plot(FWHM_vec(start_index:end), std(kiebel.fwhm_ests(start_index:end,:),0,2))
plot(FWHM_vec(start_index:end), std(conv.fwhm_ests(start_index:end,:),0,2))
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NW')

%% Lambda plot
startat = 1.5; start_index = find(FWHM_vec == startat);
plot(FWHM_vec(start_index:end), mean(forman.Lambda_ests(start_index:end,:),2))
hold on
plot(FWHM_vec(start_index:end), mean(kiebel.Lambda_ests(start_index:end,:),2))
plot(FWHM_vec(start_index:end), mean(conv.Lambda_ests(start_index:end,:),2))
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NW')

%% Lambda var plot
startat = 1.5; start_index = find(FWHM_vec == startat);
plot(FWHM_vec(start_index:end), std(forman.Lambda_ests(start_index:end,:),0,2))
hold on
plot(FWHM_vec(start_index:end), std(kiebel.Lambda_ests(start_index:end,:),0,2))
plot(FWHM_vec(start_index:end), std(conv.Lambda_ests(start_index:end,:),0,2))
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NW')

%% %% 2D
%% Load the data
nsubj = 50;
global ncfloc
load([ncfloc, 'FWHMestimation/Store_FWHM_estimates/twoDstatsims_Dim5050_nsubj', num2str(nsubj)]);

sim_names = {'Forman', 'Kiebel', 'Convolution'};

%FWHM bias plot
clf
startat = 1.5; start_index = find(FWHM_vec == startat);
h(1) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
hold on
h(2) = abline('h', 0);
h(3) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
h(4) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NE')
ylabel('Bias'); xlabel('FWHM used to smooth');
title('Comparing FWHM estimates')

h(5) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('blue') );
h(6) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('red') );
h(7) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('yellow') );
legend(h([1,3,4,5,6,7]),sim_names{1}, sim_names{2}, sim_names{3}, [sim_names{1}, ' unscaled'], [sim_names{2}, ' unscaled'], [sim_names{3}, ' unscaled'], 'Location', 'NE')

%% %% 3D
%% Load the data
nsubj = 50;
global ncfloc
load([ncfloc, 'FWHMestimation/Store_FWHM_estimates/threeDstatsims_Dim303030_nsubj', num2str(nsubj)]);

sim_names = {'Forman', 'Kiebel', 'Convolution'};

%FWHM bias plot
clf
startat = 1.5; start_index = find(FWHM_vec == startat);
h(1) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
hold on
h(2) = abline('h', 0);
h(3) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
h(4) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests(start_index:end,:),2) - FWHM_vec(start_index:end)');
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NE')
ylabel('Bias'); xlabel('FWHM used to smooth');
title('Comparing FWHM estimates')

h(5) = plot(FWHM_vec(start_index:end), mean(forman.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('blue') );
h(6) = plot(FWHM_vec(start_index:end), mean(kiebel.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('red') );
h(7) = plot(FWHM_vec(start_index:end), mean(conv.fwhm_ests_unscaled(start_index:end,:),2) - FWHM_vec(start_index:end)', '--', 'color', def_col('yellow') );
legend(h([1,3,4,5,6,7]),sim_names{1}, sim_names{2}, sim_names{3}, [sim_names{1}, ' unscaled'], [sim_names{2}, ' unscaled'], [sim_names{3}, ' unscaled'], 'Location', 'NE')

%% FWHM var plot
startat = 1.5; start_index = find(FWHM_vec == startat);
plot(FWHM_vec(start_index:end), std(forman.fwhm_ests(start_index:end,:),0,2))
hold on
plot(FWHM_vec(start_index:end), std(kiebel.fwhm_ests(start_index:end,:),0,2))
plot(FWHM_vec(start_index:end), std(conv.fwhm_ests(start_index:end,:),0,2))
legend(sim_names{1}, sim_names{2}, sim_names{3}, 'Location', 'NW')

