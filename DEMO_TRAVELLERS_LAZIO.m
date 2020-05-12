% script DEMO_TRAVELLERS
VARIABLES_TRAVELLERS;
addpath ('./DATA/');
addpath ('ECheynet-SEIR');
input_params.regionIdx  =INDEX_LAZIO;
input_params.ifsave     =0;
input_params.mode_plot  =THREE_PLOT;%DEATHS_PLOT;%   CHEATERS_PLOT;
input_params.error_mode =NULL_MODEL;
input_params.plot_legend=1;

sim_struct_out=Region_jumpers_fitting(si,input_params);
