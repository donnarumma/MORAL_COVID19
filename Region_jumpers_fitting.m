function sim_struct= Region_jumpers_fitting(sim_struct,input_params)
%% function sim_struct= Best_Lazio_jumpers_fitting_4(sim_struct)
VARIABLES_TRAVELLERS;

ifsave     =input_params.ifsave;
mode_plot  =input_params.mode_plot;
regionIdx  =input_params.regionIdx;
error_mode =input_params.error_mode;
plot_legend=input_params.plot_legend;
if mode_plot==LEGEND_PLOT
    whichplot=[1,1,0,1];
    lw=[2,3,2,2];
    plot_legend=1;
%     j_jumpers=38;
    j_jumpers=BEST_JUMPERS.REGIONS{regionIdx};
elseif mode_plot==THREE_PLOT
    whichplot=[1,1,0,1];
    lw=[3,5,1,2];
    j_jumpers=BEST_JUMPERS.REGIONS{regionIdx};
elseif mode_plot==DEATHS_PLOT
    whichplot=[0,0,0,1];
    lw=[3,5,1,2];
    j_jumpers=BEST_JUMPERS.REGIONS{regionIdx};
elseif mode_plot==CHEATERS_PLOT
    whichplot=[0,0,0,0];
    lw=[3,5,1,2];
    j_jumpers=0:100;
end

mk=cell(0,0);
% mk='--';mk=':',mk='-'; mk='*'; mk='o';

mk{end+1}='--';
mk{end+1}=':';%mk{end+1}='-.';
mk{end+1}='-';
mk{end+1}='o';

test_jump=1;
% format_save='png';
format_save='epsc2';
if strcmp(sim_struct.Regions{regionIdx},'Italy')
    tlabel='Italy';
else
    tlabel=[sim_struct.Regions{regionIdx},' (Italy)'];
end
% hmstart=1;
% hmtick=sim_struct.dtps(regionIdx);  
% hmshift=0;
%% plot changed 
hmtick=5; hmshift=2; hmstart=12; %% reference for Campania



%% Simulation
[~, d_day]=plotInfectionRate(sim_struct,regionIdx,0);
sim_struct.howmany=d_day; %% stable
day_to_start=sim_struct.sim_params{regionIdx,end}.reference_day;
first_day=sim_struct.time{day_to_start}; %%% first day with minimum data
first_day_2_compare='2020-03-24';   %% first day of the escape lerning parameters
last_day           ='2020-04-05';   %% last day of comparison

for iter_j=1:length(j_jumpers)
    % initial value
    M0=[sim_struct.Confirmed(regionIdx,day_to_start),       ...
    sim_struct.Confirmed(regionIdx,day_to_start),       ...
    sim_struct.Quarantined(regionIdx,day_to_start),     ...
    sim_struct.Recovered(regionIdx,day_to_start),       ...
    sim_struct.Deaths(regionIdx,day_to_start),          ...
    0];

    fprintf('Reference day: %s\n',datestr(sim_struct.time(day_to_start)));

    [t,stime,sDays]=getReferenceTime(sim_struct,regionIdx,first_day,last_day);

    fprintf('Prediction from %s to %s (%g days)\n',datestr(stime(1)),datestr(stime(end)),length(datenum(stime(1)):datenum(stime(end))));
    [Y,YD,t,t_day]=prediction_SEIR(sim_struct,regionIdx,M0,t);

    test_jump=1;

    if test_jump
        jumpers=j_jumpers(iter_j);
        fprintf('%s jumpers: %g\n',sim_struct.Regions{regionIdx},jumpers);

%         sim_struct_jumpers.start=sim_struct.start; 
        sim_struct_jumpers.howmany=sim_struct.howmany; 
        finish= sim_struct.howmany;

        ff=jumpers;
        sim_struct_jumpers.Confirmed=sim_struct.Confirmed;
        sim_struct_jumpers.Confirmed(regionIdx,finish)=sim_struct.Confirmed(regionIdx,finish)+ff;

        sim_struct_jumpers.Quarantined=sim_struct.Quarantined;
        sim_struct_jumpers.Quarantined(regionIdx,finish)=sim_struct.Quarantined(regionIdx,finish)+ff;

        sim_struct_jumpers.Populations  =sim_struct.Populations+ff;

        ff=ff*12./100;
        sim_struct_jumpers.Deaths=sim_struct.Deaths;
        sim_struct_jumpers.Deaths(regionIdx,finish)=sim_struct.Deaths(regionIdx,finish)+ff;

        sim_struct_jumpers.time=sim_struct.time;

        sim_struct_jumpers.Recovered=sim_struct.Recovered;

        sim_struct_jumpers.Regions=sim_struct.Regions;

        %% learn travellers variation
        sim_struct_jumpers.start=1;
        [params]=learn_SEIR(sim_struct_jumpers,regionIdx);
    
        sim_struct_jumpers.sim_params{regionIdx,sim_struct_jumpers.howmany}=params;
    
        
        td=0;
%         day_to_start=sim_struct_jumpers.sim_params{regionIdx}.reference_day+td; %% {'2020-03-06'
        first_day=sim_struct_jumpers.time(day_to_start);

        [tJ,stimeJ,sDaysJ]=getReferenceTime(sim_struct_jumpers,regionIdx,first_day,last_day);
        [YJ,YDJ,tJ,t_dayJ]=prediction_SEIR(sim_struct_jumpers,regionIdx,M0,tJ);
        sQJ=YJ(4,:);
        sRJ=YJ(5,:);
        sDJ=YJ(6,:);
        sQDJ=YDJ(4,:);
        sRDJ=YDJ(5,:);
        sDDJ=YDJ(6,:);

        fprintf('Prediction from %s to %s (%g days)\n',datestr(stimeJ(1)),datestr(stimeJ(end)),length(datenum(stimeJ(1)):datenum(stimeJ(end))));
    %     sim_struct=sim_struct_jumpers; %% plot jumpers
    end
    indDeath=6;
    sQ=Y(4,:);
    sR=Y(5,:);
    sD=Y(6,:);
    sQD=YD(4,:);
    sRD=YD(5,:);
    sDD=YD(6,:);

    %% plot
    hfig=figure; hold on; box on; grid on;
    cmaps=linspecer(4); h=[]; leg=cell(0,0);

    % plot simulation
    if whichplot(1); leg{end+1}= ['Total Cases (' getM1String ')'];     h(end+1)=plot(sDays,   sQ+sR+sD,mk{1},'color',cmaps(1,:),'linewidth',lw(1)); end;
    if whichplot(2); leg{end+1}= ['Active Cases (' getM1String ')'];    h(end+1)=plot(sDays,         sQ,mk{1},'color',cmaps(2,:),'linewidth',lw(1)); end;
    if whichplot(3); leg{end+1}= ['Total Recovered (' getM1String ')']; h(end+1)=plot(sDays,         sR,mk{1},'color',cmaps(3,:),'linewidth',lw(1)); end;
    if whichplot(4); leg{end+1}= ['Deaths (' getM1String ')'];          h(end+1)=plot(sDays,         sD,mk{1},'color',cmaps(4,:),'linewidth',lw(1)); end;
    if j_jumpers>0
        if whichplot(1);leg{end+1}= ['Total Cases (' getM2String ')'];    h(end+1)=plot(sDaysJ,sQJ+sRJ+sDJ,mk{2},'color',cmaps(1,:),'linewidth',lw(2)); end;
        if whichplot(2);leg{end+1}= ['Active Cases (' getM2String ')'];   h(end+1)=plot(sDaysJ,        sQJ,mk{2},'color',cmaps(2,:),'linewidth',lw(2)); end;
        if whichplot(3);leg{end+1}= ['Total Recovered (' getM2String ')'];h(end+1)=plot(sDaysJ,        sRJ,mk{2},'color',cmaps(3,:),'linewidth',lw(2)); end;
        if whichplot(4);leg{end+1}= ['Deaths (' getM2String ')'];         h(end+1)=plot(sDaysJ,        sDJ,mk{2},'color',cmaps(4,:),'linewidth',lw(2)); end;
    end

    %% Ground truth simulation
    sim_struct_all                      =sim_struct;
    sim_struct_all.start                =1;
    sim_struct_all.howmany              =length(sim_struct_all.time);
%     [params]                            =learn_SEIR(sim_struct_all,regionIdx);
%     sim_struct_all.sim_params{regionIdx}=params;
%     day_to_start                        =sim_struct_all.sim_params{regionIdx}.reference_day;
    first_day                           =sim_struct_all.time{day_to_start};
    M0ALL=[sim_struct_all.Confirmed(regionIdx,day_to_start),       ...
           sim_struct_all.Confirmed(regionIdx,day_to_start),       ...
           sim_struct_all.Quarantined(regionIdx,day_to_start),     ...
           sim_struct_all.Recovered(regionIdx,day_to_start),       ...
           sim_struct_all.Deaths(regionIdx,day_to_start),          ...
           0];
    [tALL,stimeALL,sDaysALL]            =getReferenceTime(sim_struct_all,regionIdx,first_day,last_day);
    [YALL,YDALL,tALL,t_dayALL]          =prediction_SEIR( sim_struct_all,regionIdx,M0ALL    ,tALL    );

    % YALL    =sim_struct.sim_params{regionIdx}.Y_24Feb;
    % sDaysALL=sim_struct.sim_params{regionIdx}.Days_24Feb;
    sQALL=YALL(4,:);
    sRALL=YALL(5,:);
    sDALL=YALL(6,:);
    sQDALL=YDALL(4,:);
    sRDALL=YDALL(5,:);
    sDDALL=YDALL(6,:);
    %% end ground truth simulation


    if whichplot(1); leg{end+1}= ['Total Cases (' getM3String ')'];    h(end+1)=plot(sDaysALL,sQALL+sRALL+sDALL,'LineStyle',mk{3},'color',cmaps(1,:),'linewidth',lw(3)); end;
    if whichplot(2); leg{end+1}= ['Active Cases (' getM3String ')'];   h(end+1)=plot(sDaysALL,            sQALL,'LineStyle',mk{3},'color',cmaps(2,:),'linewidth',lw(3)); end;
    if whichplot(3); leg{end+1}= ['Total Recovered (' getM3String ')'];h(end+1)=plot(sDaysALL,            sRALL,'LineStyle',mk{3},'color',cmaps(3,:),'linewidth',lw(3)); end;
    if whichplot(4); leg{end+1}= ['Deaths (' getM3String ')'];         h(end+1)=plot(sDaysALL,            sDALL,'LineStyle',mk{3},'color',cmaps(4,:),'linewidth',lw(3)); end;
    % 


    
    Nend=find(strcmp(sim_struct.time,last_day));
    Nstart=find(strcmp(sim_struct.time,first_day_2_compare));

    %% plot data
    plot_data=1; set(hfig,'Visible','Off')
    leg2=cell(0,0); hd=[];
    if plot_data
        data_start=1;

        timeplot=datetime(sim_struct.time(data_start:end));

        if whichplot(1); leg2{end+1}= 'Total Cases (data)';    hd(end+1)=plot(timeplot,  sim_struct.Confirmed(regionIdx,data_start:end),'LineStyle','none','Marker',mk{4},'color',cmaps(1,:),'linewidth',lw(4)); end;
        if whichplot(2); leg2{end+1}= 'Active Cases (data)';   hd(end+1)=plot(timeplot,sim_struct.Quarantined(regionIdx,data_start:end),'LineStyle','none','Marker',mk{4},'color',cmaps(2,:),'linewidth',lw(4)); end;
        if whichplot(3); leg2{end+1}= 'Total Recovered (data)';hd(end+1)=plot(timeplot,  sim_struct.Recovered(regionIdx,data_start:end),'LineStyle','none','Marker',mk{4},'color',cmaps(3,:),'linewidth',lw(4)); end;
        if whichplot(4); leg2{end+1}= 'Deaths (data)';         hd(end+1)=plot(timeplot,     sim_struct.Deaths(regionIdx,data_start:end),'LineStyle','none','Marker',mk{4},'color',cmaps(4,:),'linewidth',lw(4)); end;
        hax=get(gca);

        hl1=plot(datetime([sim_struct.time(1),sim_struct.time(1)]),hax.YLim,'k-');
%         hl2=plot(datetime([sim_struct.time(sim_struct.howmany),sim_struct.time(sim_struct.howmany)]),hax.YLim,'k-');
        hl2=plot(datetime([sim_struct.time(Nstart-1),sim_struct.time(Nstart-1)]),hax.YLim,'k-');
        
        uistack(hl2,'bottom');
        if 0
            %% plot gray rectangle for cue days
            xp=2;dy=10; yp=hax.YLim(1)+dy; hp=diff(hax.YLim)-2*dy; wp=6;
            mh1=rectangle('position',[xp,yp,wp,hp],'facecolor',0.9*ones(3,1),'linestyle','none');
            uistack(mh1,'bottom');
        end
    end


    ylabel('COVID19 cases');
    xlabel('time (days)');
    title(tlabel);

    set(gcf,'color','w')
    axis tight
    set(gca,'Xtick',timeplot(hmstart+hmshift):hmtick:stime(end));
    set(gca,'XLim',[timeplot(hmstart),stime(end)]);
    % set(gca,'XTickLabelRotation',45);
    p=[0,0,3000,600];
    fs=16; 
    if ifsave
        fs=23;
    end
    set(gca,'fontsize',fs);
    if plot_legend %&& ~ifsave
        legend([h,hd],{leg{:},leg2{:}},'location','northwest','fontsize',fs-6)
    end
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);

    last_day_data=datestr(sim_struct.time(end))==stime;
    fprintf('Deaths at %s (simulation before jumpers): %g\n',datestr(stime(last_day_data)),round(YD(indDeath,last_day_data)));
    fprintf('Deaths at %s (simulation with modeled jumpers): %g\n',datestr(stimeJ(last_day_data)),round(YDJ(indDeath,last_day_data)));
    fprintf('Deaths at %s: (real) %g\n',datestr(sim_struct.time(end)),sim_struct.Deaths(regionIdx,end));
    fprintf('Death Difference at %s: %g\n',datestr(sim_struct.time(end)),sim_struct.Deaths(regionIdx,end)-round(YD(indDeath,last_day_data)));
    fprintf('Total Case Difference at %s: %g\n',datestr(sim_struct.time(end)),sim_struct.Confirmed(regionIdx,end)-round(sQD(last_day_data)+sRD(last_day_data)+sDD(last_day_data)));

    %% evaluate best jumpers
    days_to_compare=datetime(sim_struct.time(Nstart:Nend));
    g=0;
    for i=1:length(days_to_compare)
        g= g |  stimeJ==days_to_compare(i);    
    end

    g=find(g);

    it_start=2;
    g=g(it_start:end);

    try
        ERROR=sim_struct.ERROR{regionIdx};
    catch
        ERROR=[];
    end


    ERROR(end+1,:)=[jumpers,RMSError_measure(sQDJ(g),sim_struct.Quarantined(regionIdx,Nstart+it_start-1:Nend),error_mode)+         ...
                            RMSError_measure(sDDJ(g),sim_struct.Deaths(regionIdx,Nstart+it_start-1:Nend),error_mode) +             ...
                            RMSError_measure(sQDJ(g)+sRDJ(g)+sDDJ(g),sim_struct.Confirmed(regionIdx,Nstart+it_start-1:Nend),error_mode)];

    sim_struct.GROUND{regionIdx}=RMSError_measure(sQDALL(g),sim_struct.Quarantined(regionIdx,Nstart+it_start-1:Nend),error_mode)+         ...
                                 RMSError_measure(sDDALL(g),sim_struct.Deaths(regionIdx,Nstart+it_start-1:Nend),error_mode) +             ...
                                 RMSError_measure(sQDALL(g)+sRDALL(g)+sDDALL(g),sim_struct.Confirmed(regionIdx,Nstart+it_start-1:Nend),error_mode);




      fprintf('GROUND TRUTH RMSE: %g\n',sim_struct.GROUND{regionIdx});

    [v,k]=unique(ERROR(:,1));
    ERROR=ERROR(k,:);

    sim_struct.ERROR{regionIdx}=ERROR;

    for i=1:size(ERROR,1)
        fprintf('For %g RMSE: %g\n',ERROR(i,1),ERROR(i,2))
    end


    if mode_plot==CHEATERS_PLOT
        %%

        if iter_j==length(j_jumpers)
            ERROR_CORRECT=ERROR;
            hfig=figure; hold on; box on; grid on;
            inds=ERROR_CORRECT(:,1)>=0 & ERROR_CORRECT(:,1)<=100;
            plot(ERROR_CORRECT(inds,1),ERROR_CORRECT(inds,2),'ko','linewidth',2)
            plot(ERROR_CORRECT(inds,1),smooth(ERROR_CORRECT(inds,2)),'k-','linewidth',2)
            title(tlabel);
            xlabel('Novel Active Cases');
            ylabel('NMSE')
            optionsPlot(hfig);
            p=[0,0,1500,600];
            set(gca,'fontsize',fs);
            set(hfig,'visible','off');
            set(hfig, 'PaperPositionMode','auto');
            set(hfig,'Position',p);
        else 
            close all;
        end
        val=min(ERROR_CORRECT,2);
        
    end

    if ifsave
        if mode_plot==DEATHS_PLOT
            nf=['Cheaters_' sim_struct.Regions{regionIdx} '_Deaths_J' num2str(jumpers)];
            fprintf('Saving %s\n',nf);

            print(hfig,['-d' format_save],[SAVE_DIR,nf]);
            savefig(hfig,[SAVE_DIR,nf]);
        elseif mode_plot==THREE_PLOT
            nf=['Cheaters_' sim_struct.Regions{regionIdx} '_J' num2str(jumpers)];
            print(hfig,['-d' format_save],[SAVE_DIR,nf]);
            savefig(hfig,[SAVE_DIR,nf]);
        elseif mode_plot==LEGEND_PLOT
            %% save only the legend
        %     lw=[1,1,2,2];whichplot=[1,1,0,1];
            nf=[sim_struct.Regions{regionIdx} '_Legend']; 
            saveLegendToImage(hfig, hfig.Children(1), nf, format_save); 
            saveLegendToImage(hfig, hfig.Children(1), nf, 'fig');
        elseif mode_plot==CHEATERS_PLOT
        %% plot errors
        %% THE CORRECT PATH
            nf=['Cheaters_' sim_struct.Regions{regionIdx} '_RMSE'];
            print(hfig,['-d' format_save],[SAVE_DIR,nf]);
            savefig(hfig,[SAVE_DIR,nf]);
        end
    else
       try 
            set(hfig,'Visible','on')
       catch
       end
    end
        
    
end
return