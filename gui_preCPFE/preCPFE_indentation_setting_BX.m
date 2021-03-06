% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function preCPFE_indentation_setting_BX
%% Function to set BX indentation inputs (tip radius, indentation depth...) and plot of meshing
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gdata = guidata(gcf);
scratchTest = gdata.defaults.variables.scratchTest;

%% Store old view settings
% Rotation of the bicrystal based on the GB trace angle
rotation_angle = gdata.GB.GB_Trace_Angle;
direction = [0 0 1]; % along z-axis
origin = [0,0,0];

%% Set positive values in case of missing parameters
% Indenter parameters
set_default_values_txtbox(gdata.handles.indenter.coneAngle_val, num2str(gdata.defaults.variables.coneAngle));
set_default_values_txtbox(gdata.handles.indenter.tipRadius_val, num2str(gdata.defaults.variables.tipRadius));
set_default_values_txtbox(gdata.handles.indenter.h_indent_val, num2str(gdata.defaults.variables.h_indent));
if scratchTest
    set_default_values_txtbox(gdata.handles.indenter.scratchLength_val, num2str(gdata.defaults.variables.scratchLength));
    set_default_values_txtbox(gdata.handles.indenter.scratchDirection_val, num2str(gdata.defaults.variables.scratchDirection));
end
% Mesh parameters
set_default_values_txtbox(gdata.handles.mesh.w_sample_val, num2str(gdata.defaults.variables.w_sample));
set_default_values_txtbox(gdata.handles.mesh.h_sample_val, num2str(gdata.defaults.variables.h_sample));
set_default_values_txtbox(gdata.handles.mesh.len_sample_val, num2str(gdata.defaults.variables.len_sample));
set_default_values_txtbox(gdata.handles.mesh.inclination_val, num2str(gdata.defaults.variables.inclination));
set_default_values_txtbox(gdata.handles.mesh.ind_dist_val, num2str(gdata.defaults.variables.ind_dist));
set_default_values_txtbox(gdata.handles.mesh.box_elm_nx_val, num2str(gdata.defaults.variables.box_elm_nx));
set_default_values_txtbox(gdata.handles.mesh.box_elm_nz_val, num2str(gdata.defaults.variables.box_elm_nz));
set_default_values_txtbox(gdata.handles.mesh.box_elm_ny1_val, num2str(gdata.defaults.variables.box_elm_ny1));
set_default_values_txtbox(gdata.handles.mesh.box_elm_ny2_val, num2str(gdata.defaults.variables.box_elm_ny2));
set_default_values_txtbox(gdata.handles.mesh.box_elm_ny3_val, num2str(gdata.defaults.variables.box_elm_ny3));
% Bias parameters
if strfind(gdata.config.CPFEM.fem_solver_used, 'Abaqus')
    set_default_values_txtbox(gdata.handles.mesh.box_bias_x_val, num2str(gdata.defaults.variables.box_bias_x_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_z_val, num2str(gdata.defaults.variables.box_bias_z_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y1_val, num2str(gdata.defaults.variables.box_bias_y1_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y2_val, num2str(gdata.defaults.variables.box_bias_y2_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y3_val, num2str(gdata.defaults.variables.box_bias_y3_abaqus));
elseif strfind(gdata.config.CPFEM.fem_solver_used, 'Mentat')
    set_default_values_txtbox(gdata.handles.mesh.box_bias_x_val, num2str(gdata.defaults.variables.box_bias_x_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_z_val, num2str(gdata.defaults.variables.box_bias_z_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y1_val, num2str(gdata.defaults.variables.box_bias_y1_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y2_val, num2str(gdata.defaults.variables.box_bias_y2_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_y3_val, num2str(gdata.defaults.variables.box_bias_y3_mentat));
end

%% Get mesh level
gdata.variables.box_elm_nx = ...
    str2num(get(gdata.handles.mesh.box_elm_nx_val, 'String'));
gdata.variables.box_elm_nz = ...
    str2num(get(gdata.handles.mesh.box_elm_nz_val, 'String'));
gdata.variables.box_elm_ny1 = ...
    str2num(get(gdata.handles.mesh.box_elm_ny1_val, 'String'));
gdata.variables.box_elm_ny2 = ...
    str2num(get(gdata.handles.mesh.box_elm_ny2_val, 'String'));
gdata.variables.box_elm_ny3 = ...
    str2num(get(gdata.handles.mesh.box_elm_ny3_val, 'String'));

if abs(str2num(get(gdata.handles.mesh.ind_dist_val, 'String'))) ~= 0
    gdata.variables.box_elm_ny2_fac = round(gdata.variables.box_elm_ny2 / ...
        (gdata.variables.mesh_quality_lvl * ...
        round(abs(str2num(get(...
        gdata.handles.mesh.ind_dist_val, 'String'))))));
else
    gdata.variables.box_elm_ny2_fac = 1;
end

guidata(gcf, gdata);

%% Definition of mesh/geometry variables
preCPFE_set_indenter;
gdata = guidata(gcf);
% Sample variables
gdata.variables.w_sample    = str2num(get(gdata.handles.mesh.w_sample_val, 'String'));
gdata.variables.h_sample    = str2num(get(gdata.handles.mesh.h_sample_val, 'String'));
gdata.variables.len_sample  = str2num(get(gdata.handles.mesh.len_sample_val, 'String'));
gdata.variables.inclination = str2num(get(gdata.handles.mesh.inclination_val, 'String'));
gdata.variables.ind_dist    = str2num(get(gdata.handles.mesh.ind_dist_val, 'String'));
gdata.variables.box_bias_x  = str2num(get(gdata.handles.mesh.box_bias_x_val, 'String'));
gdata.variables.box_bias_z  = str2num(get(gdata.handles.mesh.box_bias_z_val, 'String'));
gdata.variables.box_bias_y1 = str2num(get(gdata.handles.mesh.box_bias_y1_val, 'String'));
gdata.variables.box_bias_y2 = str2num(get(gdata.handles.mesh.box_bias_y2_val, 'String'));
gdata.variables.box_bias_y3 = str2num(get(gdata.handles.mesh.box_bias_y3_val, 'String'));

gdata.GB.GB_Inclination = gdata.variables.inclination;

% smv to do !!!
gdata.variables.smv = 0.01;

%% Set valid inputs in case of wrong inputs
guidata(gcf, gdata);
preCPFE_set_valid_inputs_BX;
gdata = guidata(gcf);

% Just for the plot in Matlab !
if strfind(gdata.config.CPFEM.fem_solver_used, 'Abaqus')
    if gdata.variables.ind_dist < 0 % in grain B, on the right of the GB
        gdata.variables.box_bias_y2 = -gdata.variables.box_bias_y2;
    end
end

%% Definition of geometry points coordinates
%    1------------2---3-------------4
%   /            /   /             /|
%  5            6   7 <--Ind      8 |
% /            /   /             /  |
%9-----------10---11------------12  |
%|            |   |             |   18
%|     A      | B |     C       |  /       ^
%|            |   |             | 17      z|
%|            |   |             |/         |/ x
%13----------14---15------------16     <---/
%                                      y

% Coordinates of points of the sample
gdata.variables.length_box = ...
    (gdata.variables.len_sample + gdata.variables.ind_dist)/2; % Length of the boxes A or C
if gdata.variables.inclination <= 90
    gdata.variables.length_inc = gdata.variables.h_sample * tand(90-gdata.variables.inclination);
else
    gdata.variables.length_inc = -(gdata.variables.h_sample * tand(gdata.variables.inclination-90));
end

gdata.variables.sample_coordx_backface   = gdata.variables.w_sample/2;
gdata.variables.sample_coordx_frontface  = -gdata.variables.w_sample/2;
gdata.variables.sample_coordz_bottomface = -gdata.variables.h_sample;
gdata.variables.sample_coordz_topface    = 0;
gdata.variables.sample_coordy_leftface   = -gdata.variables.ind_dist + gdata.variables.length_box;
gdata.variables.sample_coordy_rightface  = - gdata.variables.length_box;

if gdata.variables.ind_dist < 0 % in grain B, on the right of the GB
    gdata.variables.sample_coordy_midleftface_top  = -gdata.variables.ind_dist;
    gdata.variables.sample_coordy_midrightface_top = 0;
    gdata.variables.sample_coordy_midleftface_bot  = -gdata.variables.ind_dist + gdata.variables.length_inc;
    gdata.variables.sample_coordy_midrightface_bot = +gdata.variables.length_inc;
elseif gdata.variables.ind_dist > 0 % in grain A, on the left of the GB
    gdata.variables.sample_coordy_midleftface_top  = 0;
    gdata.variables.sample_coordy_midrightface_top = -gdata.variables.ind_dist;
    gdata.variables.sample_coordy_midleftface_bot  = gdata.variables.length_inc;
    gdata.variables.sample_coordy_midrightface_bot = -gdata.variables.ind_dist + gdata.variables.length_inc;
elseif gdata.variables.ind_dist == 0
    gdata.variables.sample_coordy_midleftface_top  = 0;
    gdata.variables.sample_coordy_midleftface_bot  = gdata.variables.length_inc;
    gdata.variables.sample_coordy_midrightface_top = 0;
    gdata.variables.sample_coordy_midrightface_bot = gdata.variables.length_inc;
end

gdata.variables_geom.BX_sample_allpts = [gdata.variables.sample_coordx_backface gdata.variables.sample_coordy_leftface gdata.variables.sample_coordz_topface; %1
    gdata.variables.sample_coordx_backface gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordz_topface; %2
    gdata.variables.sample_coordx_backface gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordz_topface; %3
    gdata.variables.sample_coordx_backface gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_topface;  %4
    0 gdata.variables.sample_coordy_leftface gdata.variables.sample_coordz_topface; %5
    0 gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordz_topface; %6
    0 gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordz_topface; %7
    0 gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_topface; %8
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_leftface gdata.variables.sample_coordz_topface;  %9
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordz_topface;  %10
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordz_topface;  %11
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_topface;  %12
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_leftface gdata.variables.sample_coordz_bottomface;  %13
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_midleftface_bot gdata.variables.sample_coordz_bottomface;  %14
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_midrightface_bot gdata.variables.sample_coordz_bottomface; %15
    gdata.variables.sample_coordx_frontface gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_bottomface; %16
    0 gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_bottomface
    gdata.variables.sample_coordx_backface gdata.variables.sample_coordy_rightface gdata.variables.sample_coordz_bottomface]; %18

% Set GB coordinates
if gdata.variables.ind_dist >= 0 % in grain B, on the right of the GB
    GB_coords_X = [gdata.variables.sample_coordx_backface 0 gdata.variables.sample_coordx_frontface gdata.variables.sample_coordx_frontface];
    GB_coords_Y = [gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordy_midrightface_top gdata.variables.sample_coordy_midrightface_bot];
    GB_coords_Z = [gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_bottomface];
elseif gdata.variables.ind_dist < 0 % in grain A, on the left of the GB
    GB_coords_X = [gdata.variables.sample_coordx_backface 0 gdata.variables.sample_coordx_frontface gdata.variables.sample_coordx_frontface];
    GB_coords_Y = [gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordy_midleftface_top gdata.variables.sample_coordy_midleftface_bot];
    GB_coords_Z = [gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_topface gdata.variables.sample_coordz_bottomface];
end

% Set faces for the mesh of sample
gdata.variables_geom.faces_sample = [1 2 10 9 ; 2 3 11 10  ; 3 4 12 11  ;...
    9 10 14 13; 10 11 15 14; 11 12 16 15;...
    4 12 16 18];

%% Meshing (Cross section view of the sample + indenter)
% Meshgrid for the surface 1-2-5-6
gdata.variables_geom.top1256_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top1256_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_leftface, gdata.variables.sample_coordy_midleftface_top, gdata.variables.box_elm_ny1, gdata.variables.box_bias_y1);
[gdata.variables_geom.top1256_x, gdata.variables_geom.top1256_y] = meshgrid(gdata.variables_geom.top1256_x_pts, gdata.variables_geom.top1256_y_pts);
gdata.variables_geom.top1256_z = gdata.variables_geom.top1256_x*0;

% Meshgrid for the surface 5-6-9-10
gdata.variables_geom.top56910_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, -gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top56910_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_leftface, gdata.variables.sample_coordy_midleftface_top, gdata.variables.box_elm_ny1, gdata.variables.box_bias_y1);
[gdata.variables_geom.top56910_x, gdata.variables_geom.top56910_y] = meshgrid(gdata.variables_geom.top56910_x_pts, gdata.variables_geom.top56910_y_pts);
gdata.variables_geom.top56910_z = gdata.variables_geom.top56910_x*0;

% Meshgrid for the surface 2-3-7-6
gdata.variables_geom.top2376_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top2376_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midleftface_top, gdata.variables.sample_coordy_midrightface_top, gdata.variables.box_elm_ny2, gdata.variables.box_bias_y2);
[gdata.variables_geom.top2376_x, gdata.variables_geom.top2376_y] = meshgrid(gdata.variables_geom.top2376_x_pts, gdata.variables_geom.top2376_y_pts);
gdata.variables_geom.top2376_z = gdata.variables_geom.top2376_x*0;

% Meshgrid for the surface 6-7-10-11
gdata.variables_geom.top671011_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, -gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top671011_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midleftface_top, gdata.variables.sample_coordy_midrightface_top, gdata.variables.box_elm_ny2, gdata.variables.box_bias_y2);
[gdata.variables_geom.top671011_x, gdata.variables_geom.top671011_y] = meshgrid(gdata.variables_geom.top671011_x_pts, gdata.variables_geom.top671011_y_pts);
gdata.variables_geom.top671011_z = gdata.variables_geom.top671011_x*0;

% Meshgrid for the surface 3-4-8-7
gdata.variables_geom.top3487_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top3487_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midrightface_top, gdata.variables.sample_coordy_rightface, gdata.variables.box_elm_ny3, -gdata.variables.box_bias_y3);
[gdata.variables_geom.top3487_x, gdata.variables_geom.top3487_y] = meshgrid(gdata.variables_geom.top3487_x_pts, gdata.variables_geom.top3487_y_pts);
gdata.variables_geom.top3487_z = gdata.variables_geom.top3487_x*0;

% Meshgrid for the surface 7-8-12-11
gdata.variables_geom.top781211_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, -gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top781211_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midrightface_top, gdata.variables.sample_coordy_rightface, gdata.variables.box_elm_ny3, -gdata.variables.box_bias_y3);
[gdata.variables_geom.top781211_x, gdata.variables_geom.top781211_y] = meshgrid(gdata.variables_geom.top781211_x_pts, gdata.variables_geom.top781211_y_pts);
gdata.variables_geom.top781211_z = gdata.variables_geom.top781211_x*0;

% Meshgrid for the surface 9-10-13-14
gdata.variables_geom.top9101314_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midleftface_top, gdata.variables.sample_coordy_leftface, gdata.variables.box_elm_ny1, -gdata.variables.box_bias_y1);
gdata.variables_geom.top9101314_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordz_bottomface, 0, gdata.variables.box_elm_nz, gdata.variables.box_bias_z);
[gdata.variables_geom.top9101314_y, gdata.variables_geom.top9101314_z] = meshgrid(gdata.variables_geom.top9101314_y_pts, gdata.variables_geom.top9101314_z_pts);
gdata.variables_geom.top9101314_x = gdata.variables_geom.top9101314_y*0;
gdata.variables_geom.top9101314_x(:) = gdata.variables.sample_coordx_frontface;
for iz = 1:size(gdata.variables_geom.top9101314_y,1)
    for iy = 1:size(gdata.variables_geom.top9101314_y,2)
        gdata.variables_geom.top9101314_y(iz, iy) = gdata.variables_geom.top9101314_y(iz, iy) + (gdata.variables_geom.top9101314_y_pts(iy)- gdata.variables.sample_coordy_leftface)/(gdata.variables.sample_coordy_midleftface_top - gdata.variables.sample_coordy_leftface) * ...
            gdata.variables_geom.top9101314_z_pts(iz) / (gdata.variables.sample_coordz_bottomface) *...
            (gdata.variables.sample_coordy_midleftface_bot - gdata.variables.sample_coordy_midleftface_top);
    end
end

% Meshgrid for the surface 10-11-15-14
gdata.variables_geom.top10111514_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_midleftface_top, gdata.variables.sample_coordy_midrightface_top, gdata.variables.box_elm_ny2, gdata.variables.box_bias_y2);
gdata.variables_geom.top10111514_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordz_bottomface, 0, gdata.variables.box_elm_nz, gdata.variables.box_bias_z);
[gdata.variables_geom.top10111514_y, gdata.variables_geom.top10111514_z] = meshgrid(gdata.variables_geom.top10111514_y_pts, gdata.variables_geom.top10111514_z_pts);
gdata.variables_geom.top10111514_x = gdata.variables_geom.top10111514_y*0;
gdata.variables_geom.top10111514_x(:) = gdata.variables.sample_coordx_frontface;
for iy = 1:size(gdata.variables_geom.top10111514_y,2)
    for iz = 1:size(gdata.variables_geom.top10111514_y,1)
        gdata.variables_geom.top10111514_y(iz, iy) = gdata.variables_geom.top10111514_y(iz, iy) - ...
            gdata.variables.h_sample*((gdata.variables.length_inc / gdata.variables.sample_coordz_bottomface) *...
            ((gdata.variables_geom.top10111514_z_pts(iz)) / (gdata.variables.sample_coordz_bottomface)));
    end
end

% Meshgrid for the surface 11-12-16-15
gdata.variables_geom.top11121615_y_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordy_rightface, gdata.variables.sample_coordy_midrightface_top, gdata.variables.box_elm_ny3, gdata.variables.box_bias_y3);
gdata.variables_geom.top11121615_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordz_bottomface, 0, gdata.variables.box_elm_nz, gdata.variables.box_bias_z);
[gdata.variables_geom.top11121615_y, gdata.variables_geom.top11121615_z] = meshgrid(gdata.variables_geom.top11121615_y_pts, gdata.variables_geom.top11121615_z_pts);
gdata.variables_geom.top11121615_x = gdata.variables_geom.top11121615_y*0;
gdata.variables_geom.top11121615_x(:) = gdata.variables.sample_coordx_frontface;
for iz = 1:size(gdata.variables_geom.top11121615_y,1)
    for iy = 1:size(gdata.variables_geom.top11121615_y,2)
        gdata.variables_geom.top11121615_y(iz, iy) = gdata.variables_geom.top11121615_y(iz, iy) + (gdata.variables_geom.top11121615_y_pts(iy)- gdata.variables.sample_coordy_rightface)/(gdata.variables.sample_coordy_midrightface_top - gdata.variables.sample_coordy_rightface) * ...
            gdata.variables_geom.top11121615_z_pts(iz) / (gdata.variables.sample_coordz_bottomface) *...
            (gdata.variables.sample_coordy_midrightface_bot - gdata.variables.sample_coordy_midrightface_top);
    end
end

% Meshgrid for the surface 8-4-18-17
gdata.variables_geom.top841817_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordx_backface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top841817_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordz_bottomface, 0, gdata.variables.box_elm_nz, gdata.variables.box_bias_z);
[gdata.variables_geom.top841817_x, gdata.variables_geom.top841817_z] = meshgrid(gdata.variables_geom.top841817_x_pts, gdata.variables_geom.top841817_z_pts);
gdata.variables_geom.top841817_y = gdata.variables_geom.top841817_x*0;
gdata.variables_geom.top841817_y(:) = gdata.variables.sample_coordy_rightface;

% Meshgrid for the surface 8-12-16-17
gdata.variables_geom.top8121617_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordx_frontface, 0, gdata.variables.box_elm_nx, gdata.variables.box_bias_x);
gdata.variables_geom.top8121617_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.sample_coordz_bottomface, 0, gdata.variables.box_elm_nz, gdata.variables.box_bias_z);
[gdata.variables_geom.top8121617_x, gdata.variables_geom.top8121617_z] = meshgrid(gdata.variables_geom.top8121617_x_pts, gdata.variables_geom.top8121617_z_pts);
gdata.variables_geom.top8121617_y = gdata.variables_geom.top8121617_x*0;
gdata.variables_geom.top8121617_y(:) = gdata.variables.sample_coordy_rightface;

%% Clear axes
cla;
shg;

%% Plot the sample mesh
if get(gdata.handles.other_setting.pm_mesh_color, 'Value') == 1
    %color_grA = [49 140 231]/255;
    color_grA = 'b';
    %color_grB = [255 215 0]/255;
    color_grB = [0 128 0]/255;
    color_inter_gr_gb = [0 128 255]/255;
    color_gb = 'r';
elseif get(gdata.handles.other_setting.pm_mesh_color, 'Value') == 2
    color_grA = [105 105 105]/255;
    color_grB = 'w';
    color_inter_gr_gb = [173 173 173]/255;
    color_gb = 'k';
end

if strcmp(gdata.GB.active_data, 'SX')
    color_grB = color_grA;
    color_inter_gr_gb = color_grA;
    color_gb = color_grA;
end

% Plot of the mesh (part 1/2)
gdata.handles.mesh.meshBX(1) = surf(gdata.variables_geom.top1256_x, gdata.variables_geom.top1256_y, gdata.variables_geom.top1256_z, 'FaceColor', color_grA); hold on;
gdata.handles.mesh.meshBX(2) = surf(gdata.variables_geom.top3487_x, gdata.variables_geom.top3487_y, gdata.variables_geom.top3487_z, 'FaceColor', color_grB); hold on;

% Plot of GB
gdata.handles.mesh.meshBX_GB1 = plot3(GB_coords_X, GB_coords_Y, GB_coords_Z, '-', 'Color', color_gb, 'LineWidth', 4);

if gdata.variables.ind_dist ~= 0
    gdata.handles.mesh.meshBX_GB2 = surf(gdata.variables_geom.top2376_x, gdata.variables_geom.top2376_y, gdata.variables_geom.top2376_z, 'FaceColor', color_inter_gr_gb); hold on;
    gdata.handles.mesh.meshBX_GB3 = surf(gdata.variables_geom.top671011_x, gdata.variables_geom.top671011_y, gdata.variables_geom.top671011_z, 'FaceColor', color_inter_gr_gb); hold on;
    gdata.handles.mesh.meshBX_GB4 = surf(gdata.variables_geom.top10111514_x, gdata.variables_geom.top10111514_y, gdata.variables_geom.top10111514_z, 'FaceColor', color_inter_gr_gb); hold on;
    rotate([gdata.handles.mesh.meshBX_GB2, ...
        gdata.handles.mesh.meshBX_GB3, ...
        gdata.handles.mesh.meshBX_GB4], ...
        direction, rotation_angle, origin);
end

%% FIXME: Don't change the order of the plot of bicrystal model or the
% legend will be wrong... (mesh.meshBX_1 to mesh.meshBX_8)
% Plot of the mesh (part 2/2)
hold on;
gdata.handles.mesh.meshBX(3) = surf(gdata.variables_geom.top56910_x, gdata.variables_geom.top56910_y, gdata.variables_geom.top56910_z, 'FaceColor', color_grA);
gdata.handles.mesh.meshBX(4) = surf(gdata.variables_geom.top781211_x, gdata.variables_geom.top781211_y, gdata.variables_geom.top781211_z, 'FaceColor', color_grB);
gdata.handles.mesh.meshBX(5) = surf(gdata.variables_geom.top9101314_x, gdata.variables_geom.top9101314_y, gdata.variables_geom.top9101314_z, 'FaceColor', color_grA);
gdata.handles.mesh.meshBX(6) = surf(gdata.variables_geom.top11121615_x, gdata.variables_geom.top11121615_y, gdata.variables_geom.top11121615_z, 'FaceColor', color_grB);
gdata.handles.mesh.meshBX(7) = surf(gdata.variables_geom.top841817_x, gdata.variables_geom.top841817_y, gdata.variables_geom.top841817_z, 'FaceColor', color_grB);
gdata.handles.mesh.meshBX(8) = surf(gdata.variables_geom.top8121617_x, gdata.variables_geom.top8121617_y, gdata.variables_geom.top8121617_z, 'FaceColor', color_grB);

% Rotation of the bicrystal
rotate([gdata.handles.mesh.meshBX, ...
    gdata.handles.mesh.meshBX_GB1], ...
    direction, rotation_angle, origin);

guidata(gcf, gdata);

%%
if isfield(gdata, 'handle_indenter')
    [old_az, old_el] = view;
else
    old_az = -65 + rotation_angle; % old azimuth value
    old_el = 20; % old elevation value
end

%% Plot the indenter
gdata.handle_indenter = preCPFE_indenter_plot;

%% Plot the sample
gdata.handles.mesh.sample_patch = ...
    patch('Vertices', gdata.variables_geom.BX_sample_allpts, ...
    'Faces', gdata.variables_geom.faces_sample,'FaceAlpha',0.05);

rotate(gdata.handles.mesh.sample_patch, ...
    direction, rotation_angle, origin);

% Legend
if strcmp(gdata.GB.active_data, 'SX')
    legend(strcat('Grain n�', num2str(gdata.GB.activeGrain)), ...
        'Location', 'southeast');
else
    legend(strcat('GrainA n�', num2str(gdata.GB.GrainA)), ...
        strcat('GrainB n�', num2str(gdata.GB.GrainB)), ...
        strcat('GB n�', num2str(gdata.GB.GB_Number)), ...
        'Distance GB-indenter', 'Location', 'southeast');
end

% Axis setting
view(old_az, old_el);

preCPFE_mesh_plot_finalize;

% FIXME: Inversion of x-axis ans y-axis with CPFE model !!!

% FIXME: xyz label with units... see xyzlabel function
% if isfield(gdata, 'config_map')
%     if isfield(gdata.config_map, 'unit_string')
%         xlabel_str = strcat('x axis_', gdata.config_map.unit_string);
%         ylabel_str = strcat('y axis_', gdata.config_map.unit_string);
%         zlabel_str = strcat('z axis_', gdata.config_map.unit_string);
%     end
%     xlabel_str = 'x axis';
%     ylabel_str = 'y axis';
%     zlabel_str = 'z axis';
% else
%     xlabel_str = 'x axis';
%     ylabel_str = 'y axis';
%     zlabel_str = 'z axis';
% end
%
% xlabel(xlabel_str);
% ylabel(ylabel_str);
% zlabel(zlabel_str);

% Just for the plot in Matlab and because Abaqus bias is always positive !
if strfind(gdata.config.CPFEM.fem_solver_used, 'Abaqus')
    if gdata.variables.ind_dist < 0 % in grain B, on the right of the GB
        gdata.variables.box_bias_y2 = -gdata.variables.box_bias_y2;
    end
end

%% Plot scratch direction/length using the function arrow
if scratchTest
    gdata.variables.scratchLength = ...
        str2num(get(gdata.handles.indenter.scratchLength_val, 'String'));
    gdata.variables.scratchDirection = ...
        str2num(get(gdata.handles.indenter.scratchDirection_val, 'String'));
    gdata.variables.scratchDirection = rem(gdata.variables.scratchDirection, 360);
    set(gdata.handles.indenter.scratchDirection_val, ...
        'String', num2str(gdata.variables.scratchDirection));
    gdata.variables.xLengthScratch = gdata.variables.scratchLength * cosd(gdata.variables.scratchDirection);
    gdata.variables.yLengthScratch = gdata.variables.scratchLength * sind(gdata.variables.scratchDirection);
    try
        arrow(...
            [0, 0, 0.2], [gdata.variables.xLengthScratch, gdata.variables.yLengthScratch, 0.2], ...
            'Length', 20, 'FaceColor', 'w', 'TipAngle', 25, 'Width', 4);
    catch err
        warning_commwin(err.message);
    end
end

%% Calculation of the number of elements
guidata(gcf, gdata);
gui_BX.variables.BX_num_elements = preCPFE_indentation_number_elements_BX;

%% Update of the CPFEM configuration
preCPFE_config_CPFEM_updated;

%% Save data in encapsulated variable
guidata(gcf, gdata);
end
