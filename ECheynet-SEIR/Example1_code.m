% Time definition
dt = 0.1; % time step
time1 = datetime(2010,01,01,0,0,0):dt:datetime(2010,09,01,0,0,0);
N = numel(time1);
t = [0:N-1].*dt;

Npop= 60e6; % population (60 millions)
Q0 = 200; % Initial number of infectious that have bee quanrantined
I0 = Q0; % Initial number of infectious cases non-quarantined
E0 = 0; % Initial number of exposed
R0 = 0; % Initial number of recovereds
D0 = 1; % Initial number of deads
alpha = 0.08; %  protection rate
beta = 0.9; %  infection rate
gamma= 1/2; % inverse of average latent time
delta= 1/8; % inverse of average quarantine time
Lambda01 = [0.03 0.05]; % cure rate (time dependant)
Kappa01 =  [0.03 0.05]; % mortality rate (time dependant)

[S,E,I,Q,R,D,P] = SEIQRDP(alpha,beta,gamma,delta,Lambda01,Kappa01,Npop,E0,I0,Q0,R0,D0,t);



guess = [0.05,0.9,1/4,1/10,0.03,0.03,0.02,0.06]; % initial guess
[alpha1,beta1,gamma1,delta1,Lambda1,Kappa1] = fit_SEIQRDP(Q,R,D,Npop,E0,I0,time1,guess);

[S1,E1,I1,Q1,R1,D1,P1] = SEIQRDP(alpha1,beta1,gamma1,delta1,Lambda1,Kappa1,Npop,E0,I0,Q0,R0,D0,t);

figure
clf;close all;
plot(time1,Q,'r',time1,R,'c',time1,D,'g','linewidth',2);
hold on
plot(time1,Q1,'k-.',time1,R1,'k:',time1,D1,'k--','linewidth',2);
% ylim([0,1.1*Npop])
ylabel('Number of cases')
xlabel('Time (days)')
leg = {'Quarantined','Recovered','Dead','Fitted quarantined','Fitted recovered','Fitted Dead'};
legend(leg{:},'location','eastoutside')
set(gcf,'color','w')
axis tight