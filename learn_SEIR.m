function [params]=learn_SEIR(sim_struct,indRegion,minNum_in,dt_in,guess_in)
% Definition of the first estimates for the parameters
params.alpha        =nan;
params.beta         =nan;
params.gamma        =nan;
params.delta        =nan;
params.lambda       =nan;
params.kappa        =nan;
params.dt           =nan;
params.reference_day=nan;
params.goods        =nan;
try
    dt=dt_in;
catch
    dt = 0.1; % time step
end

try
    minNum=minNum_in;
catch
    minNum= 50;
    % minNum= 1;
end

try
    guess=guess_in;
catch
    alpha_guess = 0.06; % protection rate
    beta_guess = 1.0; % Infection rate
    LT_guess = 5; % latent time in days
    QT_guess = 21; % quarantine time in days
    lambda_guess = [0.1,0.05]; % recovery rate
    kappa_guess = [0.1,0.05]; % death rate

    guess = [alpha_guess,...
             beta_guess,...
             1/LT_guess,...
             1/QT_guess,...
             lambda_guess,...
             kappa_guess];
end 
start      =sim_struct.start;
finish     =start+sim_struct.howmany-1;

Confirmed  =sim_struct.Confirmed(indRegion,start:finish);
Deaths     =sim_struct.Deaths(indRegion,start:finish);
Recovered  =sim_struct.Recovered(indRegion,start:finish);
time       =sim_struct.time(start:finish);
Quarantined=sim_struct.Quarantined(indRegion,start:finish);
Npop       =sim_struct.Populations(indRegion);

goods=find(Confirmed>minNum);
params.goods=goods;
if length(goods)<3
    return;
end
params.reference_day=goods(1);
Recovered  (Confirmed<=minNum)=[];
Deaths     (Confirmed<=minNum)=[];
time       (Confirmed<=minNum)=[];
Quarantined(Confirmed<=minNum)=[];
Confirmed  (Confirmed<=minNum)=[];
      
% Initial conditions
E0 = Confirmed  (1); % Initial number of exposed cases. Unknown but unlikely to be zero.
I0 = Confirmed  (1); % Initial number of infectious cases. Unknown but unlikely to be zero.
% Q0 = Quarantined(1);
% R0 = Recovered  (1);
% D0 = Deaths     (1);

%% fit
[alpha1,beta1,gamma1,delta1,Lambda1,Kappa1] = fit_SEIQRDP(Quarantined,Recovered,Deaths,Npop,E0,I0,time,guess,'Display','off');

%% output parameters
params.alpha=alpha1;
params.beta =beta1;
params.gamma=gamma1;
params.delta=delta1;
params.lambda=Lambda1;
params.kappa =Kappa1;
params.dt    =dt;