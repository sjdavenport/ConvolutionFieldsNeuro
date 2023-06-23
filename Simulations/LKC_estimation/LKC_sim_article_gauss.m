function [] = LKC_sim_article_gauss( fwhm_switch, field_name, mask_name, D, Msim,...
                              out, path, field_type, field_params, do_gauss)
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   fwhm_switch  logical true means that fwhm is fixed in this simulation,
%                false means that Nsubj is fixed
%   field_name   either "stationary" or "nonstationary"
%   mask_name    either "box" or "sphere"
%   D            dimension of the domain
% Optional
%   Msim         number of MC runs. Default 1e3.
%   out          string or numeric
%   field_type    either 'G', 'L', or 'T' given the distribution of the
%                 noise before smoothing
%   field_params  the parameters of the field, default is set to 3, see
%                 wfield for further details
%   do_gauss      0/1 whether to Gaussianize the noise before smoothing
%--------------------------------------------------------------------------
% OUTPUT
% obj  an object of class Fields representing white noise, which is not
%      masked. 
%
%--------------------------------------------------------------------------
%% Check input
%--------------------------------------------------------------------------
if ~exist( 'out', 'var' )
    out = "";
end

if ~exist( 'path', 'var' )
    %path = '/home/fabian/Seafile/Projects/2020_ConvolutionFieldsTheory/Code/';
    path = '~/Projects/2020_ConvolutionFieldsTheory/Code/';
end

if isnumeric( out )
    out = num2str( out );
end

% Amount of Monte Carlo simulations
if ~exist( 'Msim', 'var' )
    Msim = 1e3;
end

%--------------------------------------------------------------------------
%% Prepare workspace
%--------------------------------------------------------------------------
% Add the toolbox to the path 
%path_toolbox = '~/Seafile/Code/matlabToolboxes/RFTtoolbox';
path_toolbox = '~/MatlabToolboxes/RFTtoolbox/';
addpath(genpath(path_toolbox))

% Add path to simulation code
addpath( strcat( path, '' ) )

% Add path for results
path_results = strcat( path, 'Results/' );


%--------------------------------------------------------------------------
%% Parameters for the Simulations 
%--------------------------------------------------------------------------
switch D
    case 1
        % Length of the domain
        T = 100;

        % Dimension of domain
        dim   = [ T 1 ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 21;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = mask_box;
        mask_sphere( [2 4 8 9 11 15 20:22 40:45 60 62 64 65 98:100] ) = 0;
        mask_sphere = ~mask_sphere;
        
    case 2
        % Length of the domain
        T = 20;

        % Dimension of domain
        dim   = [ T T ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 11;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        mask_sphere = dilate_mask( mask_sphere, 1 );
        
    case 3
        % Length of the domain
        T = 20;

        % Dimension of domain
        dim   = [ T T T ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 7;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        mask_sphere = dilate_mask( mask_sphere, 1 );
end

% Amount of bootstrap replicates for bHPE
Mboot = 2e3;

% Vector for FWHM dependence
FWHM = [ 1 2 3 4 5 6 ];

% Vector for sample size dependence
Nsubj = [ 20 50 100 ];

% Vector for resadd dependence
Resadd = [ 1 3 5 ];

% Methods compared in this simulation
if D == 3
    methods = struct( 'convE', logical( [ 1 1 0 ] ), ...
                      'kiebelE', 1,...
                      'formanE', 1 );
    % Change the ResAdd Vector to resolution 1, since otherwise it takes
    % ages to compute the results.
    Resadd = 1;
else
    methods = struct( 'convE', true, ...
                      'kiebelE', 1,...
                      'formanE', 1 );
end
              
% String for output
outname = "Sim_LKC_gauss_ests";

%--------------------------------------------------------------------------
%% Simulations of LKCs of Random Fields
%--------------------------------------------------------------------------

% Name of scenario
if strcmp( field_name, "stationary" )
    case_name = "_stationary";
    % Field does not get masked before application of convolutions to prevent
    % non-stationary effects caused by the boundary.
    mask_lat = false;

else
    case_name = "_nonstationary";
    % Field does get masked before application of convolutions to prevent
    % non-stationary effects caused by the boundary.
    mask_lat = true;
end

if strcmp( mask_name, "box" )
    case_name = strcat( case_name, "_box" );
    % Get the mask
    mask = mask_box;
else
    case_name = strcat( case_name, "_sphere" );
    % Get the mask
    mask = mask_sphere;
end


for do_gauss = [0,1]
%%%%%% Dependence on sample size
if fwhm_switch
    fwhm = FWHM(3);
    [ results, theoryL, sim_time ] = LKC_sim_gauss( Msim,...
                                                    Nsubj,...
                                                    fwhm,...
                                                    Resadd,...
                                                    methods,...
                                                    mask,...
                                                    mask_lat,...
                                                    theory_res, ...
                                                    field_type, ...
                                                    field_params,...
                                                    do_gauss);

    save( strcat( path_results, outname, '_D',...
                  num2str(D), case_name, '_fixedFWHM_', out,'.mat' ),...
                  'D', 'fwhm', 'methods', 'Nsubj', 'fwhm', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );     
    clear fwhm results theoryL sim_time

    
%%%%%% Dependence on FWHM
else
    nsubj = Nsubj(3);
    [ results, theoryL, sim_time ] = LKC_sim_gauss( Msim,...
                                                    nsubj,...
                                                    FWHM,...
                                                    Resadd,...
                                                    methods,...
                                                    mask,...
                                                    mask_lat,...
                                                    theory_res, ...
                                                    field_type, ...
                                                    field_params,...
                                                    do_gauss);

    save( strcat( path_results, outname, '_D', num2str(D), case_name, ...
                '_fixednsubj_', out,'_DG_',num2str(do_gauss),'.mat' ),...
                  'D', 'nsubj', 'methods', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );
    clear nsuj results theoryL sim_time mask mask_lat
end
end

end
