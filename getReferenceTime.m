function [t,stime,sDays]=getReferenceTime(sim_struct,regionIdx,first_day,last_day)
% first_day='2020-02-24';
% last_day ='2020-04-05';
% function getReferenceTime(sim_struct,first_day,last_day)
pms=sim_struct.sim_params{regionIdx,sim_struct.howmany};
first_day_date=datestr(datenum(first_day));
last_day_date =datestr(datenum( last_day));
reference_number=datenum(sim_struct.time(pms.reference_day));
first_day_number=datenum(first_day_date);
last_day_number =datenum(last_day_date);
times=[reference_number,first_day_number,last_day_number];
times=min(times):max(times);
d_reference=find(times==reference_number);
d_first_day=find(times==first_day_number);
d_last_day =find(times==last_day_number);
tstart=d_first_day-d_reference;
tend  =d_last_day-d_reference;

t=tstart:pms.dt:tend;

stime=datetime(datestr(first_day_number)):1:datetime(datestr(last_day_number));

sDays=datetime(stime(1):pms.dt:stime(end));