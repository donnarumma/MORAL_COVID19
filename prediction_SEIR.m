function [Y,YD,t,t_day]=prediction_SEIR(sim_struct,regionIdx,M0,prediction_time)
%% function [Y,YD,t,t_day]=prediction_SEIR(sim_struct,regionIdx,P0)
pms=sim_struct.sim_params{regionIdx,sim_struct.howmany};

dt=pms.dt; 
try
    t=prediction_time;
catch
    N = length(sim_struct.start:sim_struct.start+sim_struct.howmany-1);
    t = [0:N-1].*dt;
end

if length(M0)<6
    M0=[M0,0];
end
[S,E,I,Q,R,D,P] = SEIQRDP_Y(pms.alpha,pms.beta,pms.gamma,pms.delta,pms.lambda,pms.kappa,sim_struct.Populations(regionIdx),M0,t);

Y=[S;   ...
   E;   ...
   I;   ...
   Q;   ...
   R;   ...
   D;   ...
   P];

YD=   Y(:,1:1/dt:end);
t_day=t(1:1/dt:end);