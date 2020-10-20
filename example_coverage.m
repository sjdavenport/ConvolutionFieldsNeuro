nsubj = 50;
FWHM = 6;
RSfolder = 'R2Block';

global ncfloc
storefilename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];                
load([ncfloc, 'Coverage/', RSfolder, '_coverage5000/', storefilename]);

do_2tail = 0;
alpha = 0.05;

maxnmin.nsubj = nsubj;

[voxcoverage, clustercoverage] = calc_coverage( maxnmin, LKCs, do_2tail, alpha, 'poisson')

%% Example threshold difference
I = 7;
df = nsubj - 1;
bounded_threshold = EECthreshold( alpha, LKCs.L(:,I)', LKCs.L0(I), "T", df )
poisson_threshold = EECthreshold( alpha, LKCs.L(:,I)', LKCs.L0(I), "T", df, 'poisson' )
