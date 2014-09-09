% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function femproc_indentation_setting_BX
%% Function to set BX indentation inputs (tip radius, indentation depth...) and plot of meshing
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_BX = guidata(gcf);

%% Set positive values in case of missing parameters
set_positive_values_txtbox(gui_BX.handles.coneAngle_val, num2str(gui_BX.variables.coneAngle_init));
set_positive_values_txtbox(gui_BX.handles.tipRadius_val, num2str(gui_BX.variables.tipRadius_init));
set_positive_values_txtbox(gui_BX.handles.h_indent_val, num2str(gui_BX.variables.h_indent_init));
set_positive_values_txtbox(gui_BX.handles.w_sample_val, num2str(gui_BX.variables.w_sample_init));
set_positive_values_txtbox(gui_BX.handles.h_sample_val, num2str(gui_BX.variables.h_sample_init));
set_positive_values_txtbox(gui_BX.handles.len_sample_val, num2str(gui_BX.variables.len_sample_init));
set_positive_values_txtbox(gui_BX.handles.inclination_val, num2str(gui_BX.variables.inclination_init));
set_default_values_txtbox(gui_BX.handles.ind_dist_val, num2str(gui_BX.variables.ind_dist_init));
set_positive_values_txtbox(gui_BX.handles.box_elm_nx_val, num2str(gui_BX.variables.box_elm_nx_init));
set_positive_values_txtbox(gui_BX.handles.box_elm_nz_val, num2str(gui_BX.variables.box_elm_nz_init));
set_positive_values_txtbox(gui_BX.handles.box_elm_ny1_val, num2str(gui_BX.variables.box_elm_ny1_init));
set_positive_values_txtbox(gui_BX.handles.box_elm_ny2_fac_val, num2str(gui_BX.variables.box_elm_ny2_fac_init));
set_positive_values_txtbox(gui_BX.handles.box_elm_ny3_val, num2str(gui_BX.variables.box_elm_ny3_init));
set_positive_values_txtbox(gui_BX.handles.mesh_quality_lvl_val, num2str(gui_BX.variables.mesh_quality_lvl_init));
set_default_values_txtbox(gui_BX.handles.box_bias_x_val, num2str(gui_BX.variables.box_bias_x_init));
set_default_values_txtbox(gui_BX.handles.box_bias_z_val, num2str(gui_BX.variables.box_bias_z_init));
set_default_values_txtbox(gui_BX.handles.box_bias_y1_val, num2str(gui_BX.variables.box_bias_y1_init));
set_default_values_txtbox(gui_BX.handles.box_bias_y2_val, num2str(gui_BX.variables.box_bias_y2_init));
set_default_values_txtbox(gui_BX.handles.box_bias_y3_val, num2str(gui_BX.variables.box_bias_y3_init));

%% Initialization
cla;

%% Set fine / coarse mesh
gui_BX.variables.meshquality = get(gui_BX.handles.pm_mesh_quality, 'Value');

if gui_BX.variables.meshquality ~= 1
    set(gui_BX.handles.box_elm_nx_val, 'String', num2str(gui_BX.variables.box_elm_nx_init));
    set(gui_BX.handles.box_elm_nz_val, 'String', num2str(gui_BX.variables.box_elm_nz_init));
    set(gui_BX.handles.box_elm_ny1_val, 'String', num2str(gui_BX.variables.box_elm_ny1_init));
    set(gui_BX.handles.box_elm_ny2_fac_val, 'String', num2str(gui_BX.variables.box_elm_ny2_fac_init));
    set(gui_BX.handles.box_elm_ny3_val, 'String', num2str(gui_BX.variables.box_elm_ny3_init));
    
    if gui_BX.variables.meshquality == 2
        gui_BX.variables.mesh_quality_lvl = 1;
    elseif gui_BX.variables.meshquality == 3
        gui_BX.variables.mesh_quality_lvl = 2;
    elseif gui_BX.variables.meshquality == 4
        gui_BX.variables.mesh_quality_lvl = 3;
    elseif gui_BX.variables.meshquality == 5
        gui_BX.variables.mesh_quality_lvl = 4;
    end
    
    gui_BX.variables.box_elm_nx      = round(str2num(get(gui_BX.handles.box_elm_nx_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_nz      = round(str2num(get(gui_BX.handles.box_elm_nz_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_ny1     = round(str2num(get(gui_BX.handles.box_elm_ny1_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_ny2_fac = str2num(get(gui_BX.handles.box_elm_ny2_fac_val, 'String'));
    gui_BX.variables.box_elm_ny2     = round(round(abs(str2num(get(gui_BX.handles.ind_dist_val, 'String')) * gui_BX.variables.box_elm_ny2_fac * gui_BX.variables.mesh_quality_lvl)));
    gui_BX.variables.box_elm_ny3     = round(str2num(get(gui_BX.handles.box_elm_ny3_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    set(gui_BX.handles.box_elm_nx_val, 'String', num2str(gui_BX.variables.box_elm_nx));
    set(gui_BX.handles.box_elm_nz_val, 'String', num2str(gui_BX.variables.box_elm_nz));
    set(gui_BX.handles.box_elm_ny1_val, 'String', num2str(gui_BX.variables.box_elm_ny1));
    set(gui_BX.handles.box_elm_ny2_fac_val, 'String', num2str(gui_BX.variables.box_elm_ny2_fac_init));
    set(gui_BX.handles.box_elm_ny3_val, 'String', num2str(gui_BX.variables.box_elm_ny3));
    set(gui_BX.handles.mesh_quality_lvl_val, 'String', num2str(gui_BX.variables.mesh_quality_lvl));
    
else
    gui_BX.variables.mesh_quality_lvl = str2num(get(gui_BX.handles.mesh_quality_lvl_val, 'String'));
    gui_BX.variables.box_elm_nx       = round(str2num(get(gui_BX.handles.box_elm_nx_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_nz       = round(str2num(get(gui_BX.handles.box_elm_nz_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_ny1      = round(str2num(get(gui_BX.handles.box_elm_ny1_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
    gui_BX.variables.box_elm_ny2_fac  = str2num(get(gui_BX.handles.box_elm_ny2_fac_val, 'String'));
    gui_BX.variables.box_elm_ny2      = round(round(abs(str2num(get(gui_BX.handles.ind_dist_val, 'String')) * gui_BX.variables.box_elm_ny2_fac * gui_BX.variables.mesh_quality_lvl)));
    gui_BX.variables.box_elm_ny3      = round(str2num(get(gui_BX.handles.box_elm_ny3_val, 'String')) * gui_BX.variables.mesh_quality_lvl);
end

%% Definition of mesh/geometry variables
% Indenter variables
gui_BX.variables.tipRadius = str2num(get(gui_BX.handles.tipRadius_val, 'String')); % Radius of cono-spherical indenter (in �m)
gui_BX.variables.coneAngle = str2num(get(gui_BX.handles.coneAngle_val, 'String')); % Full Angle of cono-spherical indenter (in �)
gui_BX.variables.h_indent  = str2num(get(gui_BX.handles.h_indent_val, 'String')); % Depth of indentation (in �m)
% Samples variables
gui_BX.variables.w_sample    = str2num(get(gui_BX.handles.w_sample_val, 'String'));
gui_BX.variables.h_sample    = str2num(get(gui_BX.handles.h_sample_val, 'String'));
gui_BX.variables.len_sample  = str2num(get(gui_BX.handles.len_sample_val, 'String'));
gui_BX.variables.inclination = str2num(get(gui_BX.handles.inclination_val, 'String'));
gui_BX.variables.ind_dist    = str2num(get(gui_BX.handles.ind_dist_val, 'String'));
gui_BX.variables.box_bias_x  = (str2num(get(gui_BX.handles.box_bias_x_val, 'String')));
gui_BX.variables.box_bias_z  = str2num(get(gui_BX.handles.box_bias_z_val, 'String'));
gui_BX.variables.box_bias_y1 = str2num(get(gui_BX.handles.box_bias_y1_val, 'String'));
gui_BX.variables.box_bias_y2 = str2num(get(gui_BX.handles.box_bias_y2_val, 'String'));
gui_BX.variables.box_bias_y3 = (str2num(get(gui_BX.handles.box_bias_y3_val, 'String')));

gui_BX.GB.GB_Inclination = gui_BX.variables.inclination;

% smv to do !!!
gui_BX.variables.smv = 0.01;

%% Set valid inputs in case of wrong inputs
guidata(gcf, gui_BX);
femproc_set_valid_inputs_BX;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

%% Setting of the FEM interface
gui_BX.config_CPFEM.fem_interface_val = get(gui_BX.handles.pm_FEM_interface, 'Value');
if gui_BX.config_CPFEM.fem_interface_val == 1
    gui_BX.config_CPFEM.fem_interface = 2008;
elseif gui_BX.config_CPFEM.fem_interface_val == 2
    gui_BX.config_CPFEM.fem_interface = 2010;
elseif gui_BX.config_CPFEM.fem_interface_val == 3
    gui_BX.config_CPFEM.fem_interface = 2012;
elseif gui_BX.config_CPFEM.fem_interface_val == 4
    gui_BX.config_CPFEM.fem_interface = 2013;
elseif gui_BX.config_CPFEM.fem_interface_val == 5
    gui_BX.config_CPFEM.fem_interface = 2013.1;
end

%% Calculation of the transition depth between spherical and conical parts of the indenter
gui_BX.variables.h_trans = femproc_indentation_transition_depth(gui_BX.variables.tipRadius, gui_BX.variables.coneAngle/2);
gui_BX.variables.h_trans = round(gui_BX.variables.h_trans*100)/100;
set(gui_BX.handles.trans_depth , 'String',strcat('Transition depth (�m) : ', num2str(gui_BX.variables.h_trans)));

%% Calculation of the radius of the spherical cap in the cono-spherical indenter
gui_BX.variables.calRadius = (gui_BX.variables.tipRadius^2 - (gui_BX.variables.tipRadius - gui_BX.variables.h_trans)^2)^0.5;

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
gui_BX.variables.length_box = (gui_BX.variables.len_sample+gui_BX.variables.ind_dist)/2; % Length of the boxes A or C
if gui_BX.variables.inclination <= 90
    gui_BX.variables.length_inc = gui_BX.variables.h_sample * tand(90-gui_BX.variables.inclination);
else
    gui_BX.variables.length_inc = -(gui_BX.variables.h_sample * tand(gui_BX.variables.inclination-90));
end

gui_BX.variables.sample_coordx_backface   = gui_BX.variables.w_sample/2;
gui_BX.variables.sample_coordx_frontface  = -gui_BX.variables.w_sample/2;
gui_BX.variables.sample_coordz_bottomface = -gui_BX.variables.h_sample;
gui_BX.variables.sample_coordz_topface    = 0;
gui_BX.variables.sample_coordy_leftface   = -gui_BX.variables.ind_dist + gui_BX.variables.length_box;
gui_BX.variables.sample_coordy_rightface  = - gui_BX.variables.length_box;

if gui_BX.variables.ind_dist < 0 % in grain B, on the right of the GB
    gui_BX.variables.sample_coordy_midleftface_top  = -gui_BX.variables.ind_dist;
    gui_BX.variables.sample_coordy_midrightface_top = 0;
    gui_BX.variables.sample_coordy_midleftface_bot  = -gui_BX.variables.ind_dist + gui_BX.variables.length_inc;
    gui_BX.variables.sample_coordy_midrightface_bot = +gui_BX.variables.length_inc;
elseif gui_BX.variables.ind_dist > 0 % in grain A, on the left of the GB
    gui_BX.variables.sample_coordy_midleftface_top  = 0;
    gui_BX.variables.sample_coordy_midrightface_top = -gui_BX.variables.ind_dist;
    gui_BX.variables.sample_coordy_midleftface_bot  = gui_BX.variables.length_inc;
    gui_BX.variables.sample_coordy_midrightface_bot = -gui_BX.variables.ind_dist + gui_BX.variables.length_inc;
elseif gui_BX.variables.ind_dist == 0
    gui_BX.variables.sample_coordy_midleftface_top  = 0;
    gui_BX.variables.sample_coordy_midleftface_bot  = gui_BX.variables.length_inc;
    gui_BX.variables.sample_coordy_midrightface_top = 0;
    gui_BX.variables.sample_coordy_midrightface_bot = gui_BX.variables.length_inc;
end

gui_BX.variables_geom.BX_sample_allpts = [gui_BX.variables.sample_coordx_backface gui_BX.variables.sample_coordy_leftface gui_BX.variables.sample_coordz_topface; %1
    gui_BX.variables.sample_coordx_backface gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordz_topface; %2
    gui_BX.variables.sample_coordx_backface gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordz_topface; %3
    gui_BX.variables.sample_coordx_backface gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_topface;  %4
    0 gui_BX.variables.sample_coordy_leftface gui_BX.variables.sample_coordz_topface; %5
    0 gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordz_topface; %6
    0 gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordz_topface; %7
    0 gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_topface; %8
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_leftface gui_BX.variables.sample_coordz_topface;  %9
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordz_topface;  %10
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordz_topface;  %11
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_topface;  %12
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_leftface gui_BX.variables.sample_coordz_bottomface;  %13
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_midleftface_bot gui_BX.variables.sample_coordz_bottomface;  %14
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_midrightface_bot gui_BX.variables.sample_coordz_bottomface; %15
    gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_bottomface; %16
    0 gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_bottomface
    gui_BX.variables.sample_coordx_backface gui_BX.variables.sample_coordy_rightface gui_BX.variables.sample_coordz_bottomface]; %18

% Set GB coordinates
if gui_BX.variables.ind_dist >= 0 % in grain B, on the right of the GB
    GB_coords_X = [gui_BX.variables.sample_coordx_backface 0 gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordx_frontface];
    GB_coords_Y = [gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordy_midrightface_top gui_BX.variables.sample_coordy_midrightface_bot];
    GB_coords_Z = [gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_bottomface];
elseif gui_BX.variables.ind_dist < 0 % in grain A, on the left of the GB
    GB_coords_X = [gui_BX.variables.sample_coordx_backface 0 gui_BX.variables.sample_coordx_frontface gui_BX.variables.sample_coordx_frontface];
    GB_coords_Y = [gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordy_midleftface_top gui_BX.variables.sample_coordy_midleftface_bot];
    GB_coords_Z = [gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_topface gui_BX.variables.sample_coordz_bottomface];
end

% Set faces for the mesh of sample
gui_BX.variables_geom.faces_sample = [1 2 10 9 ; 2 3 11 10  ; 3 4 12 11  ;...
    9 10 14 13; 10 11 15 14; 11 12 16 15;...
    4 12 16 18];

%% Meshing (Cross section view of the sample + indenter)
% Meshgrid for the surface 1-2-5-6
gui_BX.variables_geom.top1256_x_pts = mentat_bias(gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top1256_y_pts = mentat_bias(gui_BX.variables.sample_coordy_leftface, gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.box_elm_ny1, gui_BX.variables.box_bias_y1);
[gui_BX.variables_geom.top1256_x, gui_BX.variables_geom.top1256_y] = meshgrid(gui_BX.variables_geom.top1256_x_pts, gui_BX.variables_geom.top1256_y_pts);
gui_BX.variables_geom.top1256_z = gui_BX.variables_geom.top1256_x*0;

% Meshgrid for the surface 5-6-9-10
gui_BX.variables_geom.top56910_x_pts = mentat_bias(-gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top56910_y_pts = mentat_bias(gui_BX.variables.sample_coordy_leftface, gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.box_elm_ny1, gui_BX.variables.box_bias_y1);
[gui_BX.variables_geom.top56910_x, gui_BX.variables_geom.top56910_y] = meshgrid(gui_BX.variables_geom.top56910_x_pts, gui_BX.variables_geom.top56910_y_pts);
gui_BX.variables_geom.top56910_z = gui_BX.variables_geom.top56910_x*0;

% Meshgrid for the surface 2-3-7-6
gui_BX.variables_geom.top2376_x_pts = mentat_bias(gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top2376_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.box_elm_ny2, gui_BX.variables.box_bias_y2);
[gui_BX.variables_geom.top2376_x, gui_BX.variables_geom.top2376_y] = meshgrid(gui_BX.variables_geom.top2376_x_pts, gui_BX.variables_geom.top2376_y_pts);
gui_BX.variables_geom.top2376_z = gui_BX.variables_geom.top2376_x*0;

% Meshgrid for the surface 6-7-10-11
gui_BX.variables_geom.top671011_x_pts = mentat_bias(-gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top671011_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.box_elm_ny2, gui_BX.variables.box_bias_y2);
[gui_BX.variables_geom.top671011_x, gui_BX.variables_geom.top671011_y] = meshgrid(gui_BX.variables_geom.top671011_x_pts, gui_BX.variables_geom.top671011_y_pts);
gui_BX.variables_geom.top671011_z = gui_BX.variables_geom.top671011_x*0;

% Meshgrid for the surface 3-4-8-7
gui_BX.variables_geom.top3487_x_pts = mentat_bias(gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top3487_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.sample_coordy_rightface, gui_BX.variables.box_elm_ny3, -gui_BX.variables.box_bias_y3);
[gui_BX.variables_geom.top3487_x, gui_BX.variables_geom.top3487_y] = meshgrid(gui_BX.variables_geom.top3487_x_pts, gui_BX.variables_geom.top3487_y_pts);
gui_BX.variables_geom.top3487_z = gui_BX.variables_geom.top3487_x*0;

% Meshgrid for the surface 7-8-12-11
gui_BX.variables_geom.top781211_x_pts = mentat_bias(-gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top781211_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.sample_coordy_rightface, gui_BX.variables.box_elm_ny3, -gui_BX.variables.box_bias_y3);
[gui_BX.variables_geom.top781211_x, gui_BX.variables_geom.top781211_y] = meshgrid(gui_BX.variables_geom.top781211_x_pts, gui_BX.variables_geom.top781211_y_pts);
gui_BX.variables_geom.top781211_z = gui_BX.variables_geom.top781211_x*0;

% Meshgrid for the surface 9-10-13-14
gui_BX.variables_geom.top9101314_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.sample_coordy_leftface, gui_BX.variables.box_elm_ny1, -gui_BX.variables.box_bias_y1);
gui_BX.variables_geom.top9101314_z_pts = mentat_bias(gui_BX.variables.sample_coordz_bottomface, 0, gui_BX.variables.box_elm_nz, gui_BX.variables.box_bias_z);
[gui_BX.variables_geom.top9101314_y, gui_BX.variables_geom.top9101314_z] = meshgrid(gui_BX.variables_geom.top9101314_y_pts, gui_BX.variables_geom.top9101314_z_pts);
gui_BX.variables_geom.top9101314_x = gui_BX.variables_geom.top9101314_y*0;
gui_BX.variables_geom.top9101314_x(:) = gui_BX.variables.sample_coordx_frontface;
for iz = 1:size(gui_BX.variables_geom.top9101314_y,1)
    for iy = 1:size(gui_BX.variables_geom.top9101314_y,2)
        gui_BX.variables_geom.top9101314_y(iz, iy) = gui_BX.variables_geom.top9101314_y(iz, iy) + (gui_BX.variables_geom.top9101314_y_pts(iy)- gui_BX.variables.sample_coordy_leftface)/(gui_BX.variables.sample_coordy_midleftface_top - gui_BX.variables.sample_coordy_leftface) * ...
            gui_BX.variables_geom.top9101314_z_pts(iz) / (gui_BX.variables.sample_coordz_bottomface) *...
            (gui_BX.variables.sample_coordy_midleftface_bot - gui_BX.variables.sample_coordy_midleftface_top);
    end
end

% Meshgrid for the surface 10-11-15-14
gui_BX.variables_geom.top10111514_y_pts = mentat_bias(gui_BX.variables.sample_coordy_midleftface_top, gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.box_elm_ny2, gui_BX.variables.box_bias_y2);
gui_BX.variables_geom.top10111514_z_pts = mentat_bias(gui_BX.variables.sample_coordz_bottomface, 0, gui_BX.variables.box_elm_nz, gui_BX.variables.box_bias_z);
[gui_BX.variables_geom.top10111514_y, gui_BX.variables_geom.top10111514_z] = meshgrid(gui_BX.variables_geom.top10111514_y_pts, gui_BX.variables_geom.top10111514_z_pts);
gui_BX.variables_geom.top10111514_x = gui_BX.variables_geom.top10111514_y*0;
gui_BX.variables_geom.top10111514_x(:) = gui_BX.variables.sample_coordx_frontface;
for iy = 1:size(gui_BX.variables_geom.top10111514_y,2)
    for iz = 1:size(gui_BX.variables_geom.top10111514_y,1)
        gui_BX.variables_geom.top10111514_y(iz, iy) = gui_BX.variables_geom.top10111514_y(iz, iy) - ...
            gui_BX.variables.h_sample*((gui_BX.variables.length_inc / gui_BX.variables.sample_coordz_bottomface) *...
            ((gui_BX.variables_geom.top10111514_z_pts(iz)) / (gui_BX.variables.sample_coordz_bottomface)));
    end
end

% Meshgrid for the surface 11-12-16-15
gui_BX.variables_geom.top11121615_y_pts = mentat_bias(gui_BX.variables.sample_coordy_rightface, gui_BX.variables.sample_coordy_midrightface_top, gui_BX.variables.box_elm_ny3, gui_BX.variables.box_bias_y3);
gui_BX.variables_geom.top11121615_z_pts = mentat_bias(gui_BX.variables.sample_coordz_bottomface, 0, gui_BX.variables.box_elm_nz, gui_BX.variables.box_bias_z);
[gui_BX.variables_geom.top11121615_y, gui_BX.variables_geom.top11121615_z] = meshgrid(gui_BX.variables_geom.top11121615_y_pts, gui_BX.variables_geom.top11121615_z_pts);
gui_BX.variables_geom.top11121615_x = gui_BX.variables_geom.top11121615_y*0;
gui_BX.variables_geom.top11121615_x(:) = gui_BX.variables.sample_coordx_frontface;
for iz = 1:size(gui_BX.variables_geom.top11121615_y,1)
    for iy = 1:size(gui_BX.variables_geom.top11121615_y,2)
        gui_BX.variables_geom.top11121615_y(iz, iy) = gui_BX.variables_geom.top11121615_y(iz, iy) + (gui_BX.variables_geom.top11121615_y_pts(iy)- gui_BX.variables.sample_coordy_rightface)/(gui_BX.variables.sample_coordy_midrightface_top - gui_BX.variables.sample_coordy_rightface) * ...
            gui_BX.variables_geom.top11121615_z_pts(iz) / (gui_BX.variables.sample_coordz_bottomface) *...
            (gui_BX.variables.sample_coordy_midrightface_bot - gui_BX.variables.sample_coordy_midrightface_top);
    end
end

% Meshgrid for the surface 8-4-18-17
gui_BX.variables_geom.top841817_x_pts = mentat_bias(gui_BX.variables.sample_coordx_backface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top841817_z_pts = mentat_bias(gui_BX.variables.sample_coordz_bottomface, 0, gui_BX.variables.box_elm_nz, gui_BX.variables.box_bias_z);
[gui_BX.variables_geom.top841817_x, gui_BX.variables_geom.top841817_z] = meshgrid(gui_BX.variables_geom.top841817_x_pts, gui_BX.variables_geom.top841817_z_pts);
gui_BX.variables_geom.top841817_y = gui_BX.variables_geom.top841817_x*0;
gui_BX.variables_geom.top841817_y(:) = gui_BX.variables.sample_coordy_rightface;

% Meshgrid for the surface 8-12-16-17
gui_BX.variables_geom.top8121617_x_pts = mentat_bias(gui_BX.variables.sample_coordx_frontface, 0, gui_BX.variables.box_elm_nx, gui_BX.variables.box_bias_x);
gui_BX.variables_geom.top8121617_z_pts = mentat_bias(gui_BX.variables.sample_coordz_bottomface, 0, gui_BX.variables.box_elm_nz, gui_BX.variables.box_bias_z);
[gui_BX.variables_geom.top8121617_x, gui_BX.variables_geom.top8121617_z] = meshgrid(gui_BX.variables_geom.top8121617_x_pts, gui_BX.variables_geom.top8121617_z_pts);
gui_BX.variables_geom.top8121617_y = gui_BX.variables_geom.top8121617_x*0;
gui_BX.variables_geom.top8121617_y(:) = gui_BX.variables.sample_coordy_rightface;

%% Plot
if get(gui_BX.handles.pm_mesh_color, 'Value') == 1
    %color_grA = [49 140 231]/255;
    color_grA = 'b';
    %color_grB = [255 215 0]/255;
    color_grB = [0 128 0]/255;
    color_inter_gr_gb = [0 128 255]/255;
    color_gb = 'r';
elseif get(gui_BX.handles.pm_mesh_color, 'Value') == 2
    color_grA = [105 105 105]/255;
    color_grB = 'w';
    color_inter_gr_gb = [173 173 173]/255;
    color_gb = 'k';
end

% Plot of the mesh
gui_BX.handles.meshBX_1 = surf(gui_BX.variables_geom.top1256_x, gui_BX.variables_geom.top1256_y, gui_BX.variables_geom.top1256_z, 'FaceColor', color_grA); hold on;
gui_BX.handles.meshBX_2 = surf(gui_BX.variables_geom.top3487_x, gui_BX.variables_geom.top3487_y, gui_BX.variables_geom.top3487_z, 'FaceColor', color_grB); hold on;

% Plot of GB
gui_BX.handles.plot_meshBX_GB1 = plot3(GB_coords_X, GB_coords_Y, GB_coords_Z, '-', 'Color', color_gb, 'LineWidth', 4);

if gui_BX.variables.ind_dist ~= 0
    gui_BX.handles.meshBX_GB2 = surf(gui_BX.variables_geom.top2376_x, gui_BX.variables_geom.top2376_y, gui_BX.variables_geom.top2376_z, 'FaceColor', color_inter_gr_gb); hold on;
    gui_BX.handles.meshBX_GB3 = surf(gui_BX.variables_geom.top671011_x, gui_BX.variables_geom.top671011_y, gui_BX.variables_geom.top671011_z, 'FaceColor', color_inter_gr_gb); hold on;
end

if gui_BX.variables.ind_dist ~= 0
    gui_BX.handles.meshBX_GB4 = surf(gui_BX.variables_geom.top10111514_x, gui_BX.variables_geom.top10111514_y, gui_BX.variables_geom.top10111514_z, 'FaceColor', color_inter_gr_gb); hold on;
end

% Plot of the mesh
gui_BX.handles.meshBX_3 = surf(gui_BX.variables_geom.top56910_x, gui_BX.variables_geom.top56910_y, gui_BX.variables_geom.top56910_z, 'FaceColor', color_grA); hold on;
gui_BX.handles.meshBX_4 = surf(gui_BX.variables_geom.top781211_x, gui_BX.variables_geom.top781211_y, gui_BX.variables_geom.top781211_z, 'FaceColor', color_grB); hold on;
gui_BX.handles.meshBX_5 = surf(gui_BX.variables_geom.top9101314_x, gui_BX.variables_geom.top9101314_y, gui_BX.variables_geom.top9101314_z, 'FaceColor', color_grA); hold on;
gui_BX.handles.meshBX_6 = surf(gui_BX.variables_geom.top11121615_x, gui_BX.variables_geom.top11121615_y, gui_BX.variables_geom.top11121615_z, 'FaceColor', color_grB); hold on;
gui_BX.handles.meshBX_7 = surf(gui_BX.variables_geom.top841817_x, gui_BX.variables_geom.top841817_y, gui_BX.variables_geom.top841817_z, 'FaceColor', color_grB); hold on;
gui_BX.handles.meshBX_8 = surf(gui_BX.variables_geom.top8121617_x, gui_BX.variables_geom.top8121617_y, gui_BX.variables_geom.top8121617_z, 'FaceColor', color_grB); hold on;

% Plot of the cono-spherical indenter before and after indentation
if (get(gui_BX.handles.cb_indenter_post_indentation,'Value')) == 1
    femproc_3d_conospherical_indenter (gui_BX.variables.tipRadius, gui_BX.variables.coneAngle, 50, 0, 0, gui_BX.variables.tipRadius-gui_BX.variables.h_indent);
else
    femproc_3d_conospherical_indenter (gui_BX.variables.tipRadius, gui_BX.variables.coneAngle, 50, 0, 0, gui_BX.variables.tipRadius);
end

% Plot of the sample
gui_BX.handles.sample_patch = patch('Vertices', gui_BX.variables_geom.BX_sample_allpts,'Faces', gui_BX.variables_geom.faces_sample,'FaceAlpha',0.05);

% Legend
legend(strcat('GrainA n�', num2str(gui_BX.GB.GrainA)), strcat('GrainB n�', num2str(gui_BX.GB.GrainB)), strcat('GB n�', num2str(gui_BX.GB.GB_Number)), 'Distance GB-indenter', 'Location', 'SouthOutside');

% Axis setting
%triad(1, [gui_BX.variables.sample_coordx_frontface, ...
%   gui_BX.variables.sample_coordy_rightface, gui_BX.variables.sample_coordz_bottomface],...
%   2);
axis tight; % Axis tight to the sample
axis equal; % Axis aspect ratio
view(-65,20);

% if isfield(gui_BX, 'config_map')
%     if isfield(gui_BX.config_map, 'unit_string')
%         xlabel_str = strcat('x axis_', gui_BX.config_map.unit_string);
%         ylabel_str = strcat('y axis_', gui_BX.config_map.unit_string);
%         zlabel_str = strcat('z axis_', gui_BX.config_map.unit_string);
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

%% Calculation of the number of elements
guidata(gcf, gui_BX);
femproc_indentation_number_elements_BX;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

%%
femproc_config_CPFEM_updated
end