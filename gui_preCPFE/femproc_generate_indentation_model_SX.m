% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function femproc_generate_indentation_model_SX
%% Generation of procedure file and material file for CPFE modelling of SX indentation (with GENMAT or DAMASK)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_SX = guidata(gcf);

%% Initialization = Set single crystal and get active Grain
[gui_SX.GB.Titlegbdata, gui_SX.GB.Titlegbdatacompl] = femproc_set_title_data(gui_SX.config_map, gui_SX.GB);

guidata(gcf, gui_SX);
femproc_indentation_setting_SX;
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

femproc_save_data(1);
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

%% Creation of the python file run in the command line window to generate procedure file for the bicrystal
scriptname_bicrystal = sprintf('%s_FEM_model_parameters.py', gui_SX.GB.Titlegbdatacompl);

% fid = fopen([scriptname_bicrystal,'_old.py'], 'w+');
% fprintf(fid, '# Generated by matlab/gui/femproc_generate_model.m --- DO NOT EDIT\n');
% fprintf(fid, 'import os,sys\n');
% fprintf(fid, 'p = ''%s'' \n', gui_SX.config_CPFEM.msc_module_path);
% fprintf(fid, 'if p not in sys.path: sys.path.insert(0,p) \n');
% fprintf(fid, 'import scipy.io\n');
% fprintf(fid, 'gb_data = scipy.io.loadmat(''%s'')\n', gui_SX.GB.Titlegbdata);
% fprintf(fid, 'print(sys.path)\n');
% fprintf(fid, 'print(os.getcwd())\n');
% fprintf(fid, 'import msc\n');
% fprintf(fid, 'print(msc.__file__)\n');
% fprintf(fid, 'import msc.single_crystal_indentation_model_from_MatlabGUI as gb_ind\n');
% if ismac || isunix
%     fprintf(fid, 'gb_ind.doit(gb_data, proc_path=r''%s/%s'')\n', gui_SX.config_CPFEM.proc_file_path, gui_SX.GB.Titlegbdata);
% else
%     fprintf(fid, 'gb_ind.doit(gb_data, proc_path=r''%s\\%s'')\n', gui_SX.config_CPFEM.proc_file_path, gui_SX.GB.Titlegbdata);
% end
% fclose(fid);

python4fem_module_path = strrep(gui_SX.config_CPFEM.python4fem_module_path, '\', '\\');
proc_path = fullfile(gui_SX.config_CPFEM.proc_file_path, gui_SX.GB.Titlegbdata, '');
proc_path = strrep(proc_path, '\\', '\\\\');

py = {''};
py{1} = sprintf('# Generated by %s (%s) %s, %s.m', ...
    gui_SX.config.toolbox_name, gui_SX.version_str, gui_SX.module_name, mfilename);
py{end+1} = 'import sys';
if strcmp(strtok(gui_SX.config_CPFEM.fem_solver_used, '_'), 'Abaqus') == 1
    py{end+1} = sprintf('p=''%s''', strcat(python4fem_module_path, '\\abaqus'));
else
    py{end+1} = sprintf('p=''%s''', strcat(python4fem_module_path, '\\msc'));
end
py{end+1} = sprintf('if p not in sys.path: sys.path.insert(0,p) \n');
py{end+1} = sprintf('import proc');
py{end+1} = sprintf('from proc.indentation import Indentation');
%py{end+1} = sprintf('Indentation.__module__');
py{end+1} = sprintf('import tools');
py{end+1} = sprintf('Titlegbdata = ''%s''', gui_SX.GB.Titlegbdata);
py{end+1} = sprintf('Indentation.CODE = ''%s''', gui_SX.config_CPFEM.simulation_code);
py{end+1} = sprintf('Indentation.FEMSOFTWAREVERSION = %.1f', gui_SX.config_CPFEM.fem_solver_version); 
py{end+1} = sprintf('Indentation.FEMSOFTWARE = ''%s''', gui_SX.config_CPFEM.fem_solver_used); 
py{end+1} = 'indent = Indentation(';
py{end+1} = sprintf('modelname = ''%s'',', gui_SX.GB.Titlegbdata);
py{end+1} = sprintf('h_indent = %.5f,', gui_SX.variables.h_indent);
py{end+1} = sprintf('tipRadius = %.5f,', gui_SX.variables.tipRadius);
py{end+1} = sprintf('coneAngle = %.5f,', gui_SX.variables.coneAngle);
py{end+1} = sprintf('D_sample = %.5f,', gui_SX.variables.D_sample);
py{end+1} = sprintf('h_sample = %.5f,', gui_SX.variables.h_sample);
py{end+1} = sprintf('sample_rep = %.5f,', gui_SX.variables.sample_rep);
py{end+1} = sprintf('r_center_frac = %i,', gui_SX.variables.r_center_frac);
py{end+1} = sprintf('box_xfrac = %i,', gui_SX.variables.box_xfrac);
py{end+1} = sprintf('box_zfrac = %i,', gui_SX.variables.box_zfrac);
py{end+1} = sprintf('box_bias_x = %.2f,', gui_SX.variables.box_bias_x);
py{end+1} = sprintf('box_bias_z = %i,', gui_SX.variables.box_bias_z);
py{end+1} = sprintf('box_bias_conv_x = %.3f,', gui_SX.variables.box_bias_conv_x);
py{end+1} = sprintf('box_elm_nx = %.3f,', gui_SX.variables.box_elm_nx);
py{end+1} = sprintf('box_elm_nz = %.3f,', gui_SX.variables.box_elm_nz);
py{end+1} = sprintf('radial_divi = %.3f,', gui_SX.variables.radial_divi);
py{end+1} = sprintf('smv = %e,', gui_SX.variables.smv);
py{end+1} = ')';
py{end+1} = sprintf('proc_path = ''%s'' ', proc_path);
py{end+1} = sprintf('tools.mkdir_p(proc_path)');
if strcmp(strtok(gui_SX.config_CPFEM.fem_solver_used, '_'), 'Abaqus') == 1
    py{end+1} = sprintf('indent.to_file(dst_path=proc_path, dst_name=Titlegbdata + ''.py'')');
else
    py{end+1} = sprintf('indent.to_file(dst_path=proc_path, dst_name=Titlegbdata + ''.proc'')');
end
%cellfun(@display, py)

fid = fopen([scriptname_bicrystal], 'w+');
for iln = 1:numel(py)
    fprintf(fid, '%s\n', py{iln});
end

fclose(fid);
%edit(scriptname_bicrystal)

%% Execute the Python code that we just generated
cmd = sprintf('%s %s', gui_SX.config_CPFEM.python_executable, fullfile(pwd, scriptname_bicrystal));
commandwindow;
% if ~ isempty(gui_SX.config_CPFEM.pythonpath)
%     setenv('PYTHONPATH', gui_SX.config_CPFEM.pythonpath);
% end
system(cmd);

%% Definition of path config file
gui_SX.path_config_file = fullfile(gui_SX.config_CPFEM.proc_file_path, gui_SX.GB.Titlegbdata, '');
guidata(gcf, gui_SX);
mkdir(gui_SX.path_config_file);

%% Move files to keep the directory cleaned and organized
% Move YAML file
gui_SX.GB.Titlegbdatacompl_YAML = strcat(gui_SX.GB.Titlegbdatacompl, '.yaml');
%try
%movefile(Titlegbdatacompl_YAML, activeSX.pathnameGF2_BC);
%catch err
%errordlg(err.message);
%end
%delete('random_inputs'); delete('manual_inputs');

% Move Python file
python_procedure_generation_file = strcat(gui_SX.GB.Titlegbdatacompl, '_FEM_model_parameters.py');

try
    movefile(python_procedure_generation_file, gui_SX.path_config_file);
catch err
    errordlg(err.message);
end

if gui_SX.GB.activeGrain == gui_SX.GB.GrainA
    gui_SX.GB.activeGrain_eul = gui_SX.GB.eulerA;
elseif gui_SX.GB.activeGrain == gui_SX.GB.GrainB
    gui_SX.GB.activeGrain_eul = gui_SX.GB.eulerB;
end
guidata(gcf, gui_SX);

femproc_generate_material_files_SX;

% Move .mat file
try
    movefile(gui_SX.GB.Titlegbdatacompl, gui_SX.path_config_file);
catch err
    errordlg(err.message);
end

guidata(gcf, gui_SX);

end