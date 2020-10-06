%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script calculates the EC curves of the Eklund resting state
%%%    data
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load in resting state data (Beijing)
RSDmask = imgload(['RSDmask_', 'Beijing']);
[ ~, RSDmask ] = mask_bounds( RSDmask );
RS_data = loadRSD(1:198, 'Beijing');

%% Obtain sample data
nsubj = 198;
which_subs = randsample(198, nsubj, 0);
lat_data = Field(RSDmask); lat_data.field = RS_data(:,:,:,which_subs);

%% Calcualte LKCs
FWHM = 2; resadd = 1;

% Convolution L_1 (voxmndest)
[tcfield, cfields] = convfield_t_Field( lat_data, FWHM, resadd );
dcfield = convfield_Field( lat_data, FWHM, 1, resadd );
[L_conv,L0_conv] = LKC_voxmfd_est( cfields, dcfield )

% HPE (Worryingly L_3 can be negative here sometimes)
HPE  = LKC_HP_est( cfields, 1, 1);
L_hpe = HPE.hatL'

% SPM (Off of course due to the edge correction)
FWHM_est = est_smooth(cfields.field);
[ L_spm, L0 ] = LKC_SPM_est( FWHM_est, RSDmask )

global RFTboxloc
save([RFTboxloc, 'EEC/ECcurves/Beijing_LKCs'], 'L_conv', 'L_hpe', 'L_spm', 'L0' ,'L0_conv', 'FWHM_est', 'FWHM')

%% Calculate EC curves
nsubj_vec = 25:25:100;
lower_thresh = [-6,3,4.5];
plot_names = {'all', 'tail', 'upper_tail'};

global RFTboxloc
load([RFTboxloc, 'EEC/ECcurves/Beijing_ECcurves'])
load([RFTboxloc, 'EEC/ECcurves/Beijing_LKCs'])

all_thresholds = -6:0.05:6;
for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I);
    
    EEC_spm = EEC( all_thresholds, L_spm, L0, 'T', nsubj -1 )
    EEC_hpe = EEC( all_thresholds, L_hpe, L0, 'T', nsubj-1 )
    EEC_conv = EEC( all_thresholds, L_conv, L0, 'T', nsubj-1 )
    EEC_mix = EEC( all_thresholds, [L_hpe(1), L_conv(2), L_conv(3)], L0, 'T', nsubj -1 )
    
    pos = find(nsubj == nsubj_vec);
    EEC_average = squeeze(mean(store_curves(:,pos,:),1));
    
    for J = 1:length(lower_thresh)
        J
        thresh_idx = find(all_thresholds == lower_thresh(J));
        thresholds = lower_thresh(J):0.05:6;
        clf
        plot(thresholds, EEC_average(thresh_idx:end))
        hold on
        plot(thresholds, EEC_spm(thresh_idx:end))
        hold on
        plot(thresholds, EEC_hpe(thresh_idx:end))
        plot(thresholds, EEC_conv(thresh_idx:end))
        plot(thresholds, EEC_mix(thresh_idx:end))
        legend('Average', 'SPM', 'HPE', 'Conv', 'Mix')
        title(['EEC curves for nsubj = ', num2str(nsubj)])
        xlabel('u')
        ylabel('EEC')
        export_fig([RFTboxloc, 'EEC/ECcurves/ECcurve_plots/', plot_names{J}, '_nsubj_', num2str(nsubj), '.pdf'], '-transparent')
    end
end

%% Observed EEC curves
[ curve, thresholds ] = ECcurve( tcfield, [-6,6], 0.05);

%% Generate average RS EC curves
niters = 500;
RSDmask = imgload(['RSDmask_', 'Beijing']);
[ ~, RSDmask ] = mask_bounds( RSDmask );
RS_data = loadRSD(1:198, 'Beijing');

resadd = 1; FWHM = 2; params = ConvFieldParams( FWHM, resadd );
nsubj_vec = 25:25:100;
thresholds = -6:0.05:6;
store_curves = zeros(length(nsubj_vec), niters, length(thresholds));
global RFTboxloc
for I = 1:length(nsubj_vec)
    nsubj = nsubj_vec(I)
    for J = 1:niters
        J
        which_subs = randsample(198, nsubj, 0);
        lat_data = Field(RSDmask); lat_data.field = RS_data(:,:,:,which_subs);
        tcfield = convfield_t_Field(lat_data, FWHM, resadd)
        %         tcfield = convfield_t( lat_data, params );
        curve = ECcurve( tcfield, [-6,6], 0.05);
        store_curves(I,J,:) = curve;
        save([RFTboxloc,'EEC/ECcurves/Beijing_ECcurves.mat'], 'store_curves')
    end
end

%%
[tcfield, cfields] = convfield_t_Field( lat_data, FWHM, resadd );
[tcfield0, cfields] = convfield_t_Field( lat_data, FWHM, 0 );
[ curve, thresholds ] = ECcurve( tcfield, [-6,6], 0.05);
[ curve0, thresholds ] = ECcurve( tcfield0, [-6,6], 0.05);

plot(thresholds, curve)
hold on
plot(thresholds, curve0)
legend('resadd = 1', 'resadd = 0')

%% Calculate resadd = 1 coverage
nsubj = 75;
threshold_conv = EECthreshold( 0.05, L_conv, L0, 'T', nsubj -1);
threshold_spm = EECthreshold( 0.05, L_spm, L0, 'T', nsubj -1);

load('./Beijing_ECcurves')
pos = find(nsubj == 25:25:100);
ECcurves = store_curves(:,pos,:);

thresholds = -6:0.05:6;
nearest_threshold_conv = find(thresholds < threshold_conv, 1, 'last');
nearest_threshold_spm = find(thresholds < threshold_spm, 1, 'last');

if threshold_conv > 6
    disp('threshold was too high')
else
    ratio = mod(threshold_conv, 0.05)/0.05;
    coverage_estimate_conv = (1-ratio)*mean(ECcurves(:, nearest_threshold_conv)) + ratio*mean(ECcurves(:, nearest_threshold_conv+1))
    coverage_estimate_spm = (1-ratio)*mean(ECcurves(:, nearest_threshold_spm)) + ratio*mean(ECcurves(:, nearest_threshold_spm+1))
end

% SPM is probably so bad because it doesn't use the enlarged mask