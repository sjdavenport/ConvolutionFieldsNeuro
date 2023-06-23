% global ncfloc
data_loc = 'C:\Users\12SDa\davenpor\Data\RestingStateData\EklundData\';
ncfloc = 'C:/Users/12Sda/davenpor/davenpor/Toolboxes/ConvolutionFieldsNeuro/';
set(0,'defaultAxesFontSize', 15); %This sets the default font size. 

a = load([data_loc, 'store_standard_field.mat']);
h = histogram(a.standardized_field(:));
hist_values = h.Values;
bw = h.BinWidth;
hist_edges = h.BinEdges(1:end-1) + bw/2;

%%
clf
nsubj = 50;
subplot(2,1,1)
plot(hist_edges, tpdf(hist_edges, nsubj-1))
hold on
plot(hist_edges, hist_values/sum(hist_values)/bw)
legend('t_{50} pdf', 'Marginal Null pdf')
title('The marginal null distribution')
ylabel('density')
xlim([-7,7])

subplot(2,1,2)
plot(hist_edges, log(tpdf(hist_edges, nsubj-1)))
hold on
plot(hist_edges, log(hist_values/sum(hist_values)/bw))
title('The log of the marginal null distribution')
legend('log t_{50} pdf', 'log Marginal Null pdf', 'Location', 'south')
ylabel('log(density)')
xlim([-7,7])
ylim([-17.5, 0])
set(gcf, 'position', [100,100,800,700])
export_fig([ncfloc, 'Figures/fMRI_images/Histograms/hist50.pdf'], '-transparent')

%%
clf
subplot(2,1,1)
nsubj = 6970;
b = load('store_data_at_voxels.mat');
sigma2 = var(b.vox1ts(:));
h1 = histogram(b.vox1ts(:)/sqrt(sigma2));
h1_values = h1.Values;
bw = h1.BinWidth;
hist_edges1 = h1.BinEdges(1:end-1) + bw/2;
plot(hist_edges1, tpdf(hist_edges1, nsubj-1))
hold on
plot(hist_edges1, h1_values/sum(h1_values)/bw)
title('Sample voxel distribution')
legend( 'N(0,1) pdf', 'Values at one voxel')
ylabel('density')
xlim([-7,7])

subplot(2,1,2)
sigma2 = var(b.vox2ts(:));
h2 = histogram(b.vox2ts(:)/sqrt(sigma2));
h2_values = h2.Values;
bw = h2.BinWidth;
hist_edges2 = h2.BinEdges(1:end-1) + bw/2;
plot(hist_edges2, tpdf(hist_edges2, nsubj-1))
hold on
plot(hist_edges2, h2_values/sum(h1_values)/bw)
legend('N(0,1) pdf', 'Values at a second voxel')
title('Sample voxel distribution')
ylabel('density')
set(gcf, 'position', [100,100,800,700])
xlim([-7,7])
export_fig([ncfloc, 'Figures/fMRI_images/Histograms/voxhist.pdf'], '-transparent')
