% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942
tabularasa;
installation_mtex = MTEX_check_install;

GB(1) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_1_rbv4.1.yaml');
GB(2) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_2_rbv3.1.yaml');
GB(3) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_3_rbv5.8.yaml');
GB(4) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_4_rbv7.5.yaml');
GB(5) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_5_rbv7.1.yaml');
GB(6) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_6_rbv7.0.yaml');
GB(7) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_7_rbv4.5.yaml');
GB(8) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_8_rbv3.8.yaml');
GB(9) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_9_rbv6.1.yaml');
GB(10) = load_YAML_BX_example_config_file(...
    'Kacher2014_Gr1-Gr2_10_rbv6.0.yaml'); % Not working !
GB(10).slipB_ind(2,:) = [0 0 0 -3]; % Slip doesn't exist in "slip_system" and is replaced by default by basal slip...

%% Calculations
plotKacherGBs(GB, installation_mtex);