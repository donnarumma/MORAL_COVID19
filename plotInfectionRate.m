function [beta_vals, d_day]=plotInfectionRate(sim_struct,regionIdx,if_plot)
% regionIdx=1; %% Lombardia;
% regionIdx=2; %% Lazio;
% regionIdx=3; %% Campania;
% regionIdx=4; %% Sicilia;

% days=23:33;
% days=17:42;
% days=22:42;
% days=10:42;

try
    ifplot=if_plot;
catch
    ifplot=1;
end

% N_days=length([sim_struct.sim_params{regionIdx,:}]);

sr        = 2;
reference=sim_struct.sim_params{regionIdx,end}.reference_day;
% first_day = 24;            % Mar 18
% first_day = reference+10;% Mar 16

first_day = 12+10;
% first_day
last_day_simulation = 42;  % Apr  5 
last_day_range      = 29; % March 23 
% last_day  = 29;  
% last_day  = 52;% Apr 15
% last_day  = 61;% Apr 24

days=first_day:last_day_simulation;
beta_vals=nan(length(days),1);
for i=1:length(days)
%     beta_vals(i)= sim_struct.sim_params{regionIdx,days(i)}.beta
    alpha=sim_struct.sim_params{regionIdx,days(i)}.alpha;
    beta =sim_struct.sim_params{regionIdx,days(i)}.beta;
    fprintf('Iter%g: %s alpha=%g, beta=%g\n',i,datestr(sim_struct.time(i)),alpha,beta);
    beta_vals(i)= beta/alpha;
end

%% find outliers
are_outliers=isoutlier(beta_vals);
beta_vals(are_outliers)=nan;
%% find stable trend
mm=nanmean(beta_vals);
st=nanstd(beta_vals); k=2;
detect_vals=  beta_vals> (mm-k*st) & beta_vals< (mm+k*st);
detect_days=days(detect_vals);

%% select the most recent
detect_days=detect_days(detect_days<=last_day_range);
[~,ind]=min(abs(detect_days-last_day_range));
d_day=detect_days(ind);

if ifplot
    hfig=figure; hold on; box on; grid on;
    % plot(days,beta_vals,'ko');
%     plot(datetime(sim_struct.time(days)),beta_vals,'ko');
    plot(datetime(sim_struct.time(days)),smooth(beta_vals,sr),'ko');

    if 1
        hax=get(gca);
        %% plot gray rectangle for cue days
        xp=14;dy=0.01; yp=hax.YLim(1)+dy; hp=abs(diff(hax.YLim)-2*dy); wp=6; col_escape=0.9*ones(1,3);
    %     mh1=rectangle('position',[xp,yp,wp,hp],'facecolor',[col_escape, 0.7],'linestyle','none');
        mh1=fill([datetime(sim_struct.time(xp+wp)) datetime(sim_struct.time(xp+wp)) datetime(sim_struct.time(xp)) datetime(sim_struct.time(xp))],...
                [yp yp+hp yp+hp yp],col_escape,'linestyle','none','facealpha',0.6);%'color',col_escape);
        uistack(mh1,'bottom');

        xp=14+8;dy=0.01; yp=hax.YLim(1)+dy; hp=abs(diff(hax.YLim)-2*dy); wp=7; col_effect=[0.9,0.2,0.2];
        mh2=fill([datetime(sim_struct.time(xp+wp)) datetime(sim_struct.time(xp+wp)) datetime(sim_struct.time(xp)) datetime(sim_struct.time(xp))],...
                [yp yp+hp yp+hp yp],col_effect,'linestyle','none','facealpha',0.2);%'color',col_escape);
        uistack(mh2,'bottom');
    %     uistack(mh1,'bottom');
    end

    plot([datetime(sim_struct.time(reference)),datetime(sim_struct.time(reference))],[yp yp+hp],'k');

    plot([datetime(sim_struct.time(d_day)),datetime(sim_struct.time(d_day))],[yp yp+hp],'r');

    legend([mh1,mh2],{'Escape From Milan' 'Effects of the escape'})
    ylabel('Infection rate')
    title(sim_struct.Regions{regionIdx})
end