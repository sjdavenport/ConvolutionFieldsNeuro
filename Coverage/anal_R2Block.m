FWHM = 6;
nsubj = 50;
do_gauss = 1;
filename = ['FWHM', num2str(FWHM), '_nsubj', num2str(nsubj), '_resadd1'];
if ~do_gauss 
    filename = [filename, '_NG'];
end

load(filename);
maxnmin.nsubj = size(subsets{1},1);

do2tail = 0;
[voxcoverage, clustercoverage] = calc_coverage( maxnmin, LKCs, do2tail);