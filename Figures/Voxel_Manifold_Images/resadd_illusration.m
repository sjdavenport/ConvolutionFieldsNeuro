stor_dir = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\ConvolutionFieldsNeuro\Figures\Voxel_Manifold_Images\';

%% 2x2 grid 2D
clf
visualize_bndry( true([2,2]), 0, "all", 50, 4, 0.3 )

%%
clf
visualize_bndry( true([2,2]), 1, "all", 100, 4, 0.3 )

%% 2D MNImask slice
MNImask = imgload('MNImask');
mask2D = squeeze(MNImask(:,15,:));
[ bounds, bounded_mask ] = mask_bounds( mask2D, 2 );
for resadd = [0,1]
    clf
    visualize_bndry( bounded_mask > 0, resadd, "all", 5, 1, 0.3, 0.3 )
    export_fig([stor_dir, 'MNImask2D\resadd_', num2str(resadd), '.png'], '-transparent') 
end
%%
visualize_bndry( bounded_mask > 0, resadd, "all", 2, 1, 0.3, 0.5 )
export_fig([stor_dir, 'MNImask2D\resadd_', num2str(resadd), '.png'], '-transparent')

%% Single Voxel 3D
for resadd = [0,1,3]
    clf
    visualize_bndry( true([1,1,1]), resadd, "all", 200, 7, 0.35 )
    view([15,9])
    set(gcf, 'position', [0,0,1000,1000])
    export_fig([stor_dir, 'Single_voxel\resadd_', num2str(resadd), '.png'], '-transparent')
end

%% 2x2x2 grid 3D 
for resadd = [0,1,3]
    clf
    visualize_bndry( true([2,2,2]), resadd, "all", 100, 7, 0.3 )
    view([36,13])
    set(gcf, 'position', [0,0,1000,1000])
    export_fig([stor_dir, '2by2grid\resadd_', num2str(resadd), '.png'], '-transparent')
end

%% plus 3D 
mask = zeros([3,3,3]);
mask(:,2,:) = [0,1,0;1,1,1;0,1,0];
for resadd = [0,1,3]
    clf
    visualize_bndry( mask > 0, resadd, "all", 75, 4, 0.3 )
    view([159,10])
    set(gcf, 'position', [0,0,1000,1000])
    export_fig([stor_dir, 'plus3D\resadd_', num2str(resadd), '.png'], '-transparent')
end

%%
mask = ones([3,3,3]);
mask(1,1,1) = 0; mask(1,1,3) = 0; mask(1,3,1) = 0; mask(1,3,3) = 0;
mask(3,1,1) = 0; mask(1,3,3) = 0; mask(3,1,3) = 0; mask(3,3,3) = 0;
mask(3,3,1) = 0; 
clf
visualize_bndry( mask > 0, 0, "all", 50, 4, 0.3 )

%%