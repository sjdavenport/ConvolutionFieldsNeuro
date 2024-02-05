ncfloc = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\';
fail_strings = {};
nfails = 0;
fieldtypes = {'Gaussian', 'Laplacian', 'tfield'};
for K = 1:3
    for FWHM = 1:6
        clf
        nsubj_vec = 10:10:100;
        conv_FWER = zeros(3, length(nsubj_vec));
        % fine_FWER = zeros(3, length(nsubj_vec));
        lat_FWER = zeros(3, length(nsubj_vec));

        for I = 1:length(nsubj_vec)
            nsubj = nsubj_vec(I);
            for do_gauss = [0,1,2]
                for version = 1:5
                    load_str = [ncfloc, 'Simulations\Gaussianization_Sims\Coverage_2024_all\', fieldtypes{K}, '\FWHM_', num2str(FWHM)...
                        '_nsubj', num2str(nsubj),'_DG_', num2str(do_gauss),'_niters_1000_version_',num2str(version),'.mat'];
                    try
                        load(load_str)
                    catch
                        disp('fail\n')
                        nfails = nfails + 1;
                        fail_strings{nfails} = load_str;
                    end
                end
            end
        end
    end
end