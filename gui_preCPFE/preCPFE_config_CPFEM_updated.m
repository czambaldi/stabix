% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function preCPFE_config_CPFEM_updated
%% Set GUI in function of user configuration

% author: c.zambaldi@mpie.de

gui = guidata(gcf);

% if gui.config.CPFEM.user_setting == 0
%     set(gui.handles.pb_CPFEM_model, 'BackgroundColor', [229/256 20/256 0],...
%         'String', 'No user config. file found !', ...
%         'Callback', '');
% end

if gui.config.CPFEM.python.works
    set(gui.handles.other_setting.pb_CPFEM_model, 'BackgroundColor', [0.2 0.8 0],...
        'Callback', 'preCPFE_generate_CPFE_model');
else
    commandwindow
    warning('No Python found or numpy not installed !')
    set(gui.handles.other_setting.pb_CPFEM_model, 'BackgroundColor', [229/256 20/256 0],...
        'Callback', 'preCPFE_select_config_CPFEM');
end

guidata(gcf, gui);

end