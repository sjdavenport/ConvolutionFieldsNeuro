MNImask = imgload('MNImask');
% [ bounds, bounded_mask ] = mask_bounds( MNImask );
MNImask_boundary = bndry_voxels(logical(MNImask), "full");

%%
f = Field();
f.mask = logical(MNImask_boundary);
f.xvals = {1:91,1:109,1:91};
plot_voxmf( f )

%%
mask = imgload('MNImask');

%%
% Create a 3D grid of coordinates for the mask
[x,y,z] = meshgrid(1:size(mask,2), 1:size(mask,1), 1:size(mask,3));

% Plot the mask as a 3D isosurface
isosurface(x, y, z, mask, 0);

% Change the color scheme to a built-in colormap
colormap(hot);

% Set plot properties
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
view(3);
% camlight;
lighting flat;
light('Position', [0 0 1], 'Style', 'inf');
axis off
% material('dull');

%%
frame = getframe;

% Save the displayed image values
imwrite(frame.cdata, 'displayed_image.png');

%% Equivalent plot using the voxel_image code (less nice really)
MNImask = imgload('MNImask') > 0;
MNImask_boundary = bndry_voxels(logical(MNImask), "full");
[a, b, c] = ind2sub( size( MNImask_boundary ), find( MNImask_boundary == 1 ) );
mask_pts = [a, b, c];
mask_voxsize = [1, 1, 1];
voxel_image( mask_pts, mask_voxsize, "red", 0.5 );
view( [ 42 20 ] )

