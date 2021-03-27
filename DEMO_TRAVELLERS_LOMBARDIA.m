% script DEMO_TRAVELLERS
VARIABLES_TRAVELLERS;
addpath ('./DATA/');
addpath ('ECheynet-SEIR');
load ('si_42');

input_params=defauls_plot_params;

input_params.regionIdx  =INDEX_LOMBARDIA;

input_params.ifsave     =1;
input_params.mode_plot  =TOTALS_PLOT;
input_params.mode_plot  =DEATHS_PLOT;
input_params.mode_plot  =ACTIVES_PLOT;
% input_params.mode_plot  =THREE_PLOT;
% input_params.mode_plot  =CHEATERS_PLOT;

sim_struct_out=Region_jumpers_fitting(si,input_params);
