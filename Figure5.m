% Bang et al (2020) Sub-second dopamine and serotonin signalling in human
% striatum during perceptual decision-making
%
% Reproduces "Figure 5. Putamen: dopamine and serotonin signalling 
% tracks choice submission." 
%
% Notes: the variables "v_nm" and "v_ss" specify which neuromodulators and
% patients are plotted
% 
% Dan Bang danbang.db@gmail.com 2020

%% -----------------------------------------------------------------------
%% PREPARATION

% fresh memory
clear; %close all;

% Paths [change 'repoBase' according to local setup]
fs= filesep;
repoBase= [getDropbox(1),fs,'Ego',fs,'Matlab',fs,'ucl',fs,'voltammetry',fs,'Repository',fs,'GitHub'];
dataDirB= ['Data',fs,'Behaviour'];
dataDirNM= ['Data',fs,'Neurochemistry'];

% Details
ss= [1 2 3 4 5]; % subjects
nm= {'DA','5HT'}; % neuromodulators
label_ss= {'1-ET','2-PD','3-ET','4-ET','5-PD','1-3'}; % subject (+ group) labels for plotting
label_nm= {'DA','5-HT'}; % neuromodulator labels for plotting
file_ss= 'P'; % file name: patient 
file_b= '_day2_task'; % file name: behaviour

% Add customn functions
addpath('Functions');

%% -----------------------------------------------------------------------
%% ANALYSIS: STIMULUS-LOCKED DATA

% Select stimulus-locked data
file_nm= '_stimulus_'; % file name: stimulus-locked neurochemisty

% Loop through neuromodulators
for i_nm = 1:length(nm)
        
    % Loop through subjects
    for i_sbj = 1:length(ss)

    % Load behaviour
    load([repoBase,fs,dataDirB,fs,file_ss,num2str(ss(i_sbj)),file_b,'.mat']);

    % Load neurochemistry
    load([repoBase,fs,dataDirNM,fs,file_ss,num2str(ss(i_sbj)),file_nm,nm{i_nm},'.mat']);
    ts= timeSeries;

    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    
    % Smooth
    winS= 5;
    ts_S= ts;
    ts_S(:,1:winS-1)= zeros(size(ts_S,1),winS-1);
    ts_S(:,1:2)= zeros(size(ts_S,1),2);
    for t= winS:size(ts,2)
        ts_S(:,t)= mean(ts(:,(t+1-winS):t),2);
    end
    
    % Save neuromodulator time series and result of statistical test
    % All trials
    ts_S_R{i_nm,i_sbj}= ts_S(include,:);
    ts_S_P{i_nm,i_sbj}= ttest(ts_S(include,:),0);
    % Correct trials
    ts_S_R_C{i_nm,i_sbj}= ts_S(include &data.acc==1,:);
    ts_S_P_C{i_nm,i_sbj}= ttest(ts_S(include &data.acc==1,:),0);
    % Error trials
    ts_S_R_W{i_nm,i_sbj}= ts_S(include &data.acc==0,:);
    ts_S_P_W{i_nm,i_sbj}= ttest(ts_S(include &data.acc==0,:),0);
	% Divide by RT bin (slow, medium, fast)
    rt= log(data.rt1./1e3);
    rt_quantile= quantile(rt(include),2);
    catz= [];
    for t= 1:length(data.rt1); catz(t)= sum(rt(t)>rt_quantile)+1; end;
    for c= 1:length(unique(catz));
        idx= find(include & catz==c);
        ts_S_B_R{i_nm,i_sbj}(c,:)= mean(ts_S(idx,:));
        ts_S_B_P{i_nm,i_sbj}(c,:)= ttest(ts_S(idx,:),0);
    end
       
    % Compute RT distribution
    step= 250;
    bins= 0:step:5000;
    cat= [];
    tmp= [];
    rtz= data.rt1(include==1);
    for t= 1:length(rtz); 
        cat(t)= sum(rtz(t) > bins); 
    end
    for i= 1:length(bins);
        tmp(i)= sum(cat==i);
    end
    rtdist(i_sbj,:)= tmp./sum(tmp);
    
    % Compute RT distribution: correct trials
    step= 250;
    bins= 0:step:5000;
    cat= [];
    tmp= [];
    rtz= data.rt1(include==1&data.acc==1);
    for t= 1:length(rtz); 
        cat(t)= sum(rtz(t) > bins); 
    end
    for i= 1:length(bins);
        tmp(i)= sum(cat==i);
    end
    rtdist_C(i_sbj,:)= tmp./sum(tmp);
    
     % Compute RT distribution: error trials
    step= 250;
    bins= 0:step:5000;
    cat= [];
    tmp= [];
    rtz= data.rt1(include==1&data.acc==0);
    for t= 1:length(rtz); 
        cat(t)= sum(rtz(t) > bins); 
    end
    for i= 1:length(bins);
        tmp(i)= sum(cat==i);
    end
    rtdist_W(i_sbj,:)= tmp./sum(tmp);
    
    end
    
end


%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5A

% Specifications
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= .15; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([1.1 1.1]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
plot([1.1+motionL(i_sbj) 1.1+motionL(i_sbj)]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT distribution
bar(linspace((1.1+motionL(i_sbj)+step/1e3/2)/rate,(1.1+motionL(i_sbj)+step/1e3/2+5)/rate,length(bins)),rtdist(i_sbj,:).*.60,'linewidth',.5,'Facecolor','m','Edgecolor','w','FaceAlpha',.6); hold on;
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
% Plot average time series
fillsteplotk(ts_S_R{i_nm,i_sbj},lw);
% Add significance
for c= 1;
    p= ts_S_P{i_nm,i_sbj};
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz,'s','color','k','MarkerFaceColor','k','MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 winL-4]);
set(gca,'XTick',11:10:winL)
set(gca,'XTickLabel',{'0','1','2','3','4','5'})
set(gca,'YTick',[-.1:.1:.1])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
axis square;
t=text(44,.15,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5A_',nm{i_nm}]);
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5B - LEFT PANEL

% Specifications
colz= flipud(cool(3));
sLIMS= .36; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= [.10 .20 .30]; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([1.1 1.1]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
plot([1.1+motionL(i_sbj) 1.1+motionL(i_sbj)]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT bins and add significance
for c= 1:3;
    plot(ts_S_B_R{i_nm,i_sbj}(c,:),'-','color',colz(c,:),'lineWidth',lw);
    p= ts_S_B_P{i_nm,i_sbj}(c,:);
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz(c),'s','color',colz(c,:),'MarkerFaceColor',colz(c,:),'MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 winL-4]);
set(gca,'XTick',11:10:winL)
set(gca,'XTickLabel',{'0','1','2','3','4','5'})
set(gca,'YTick',[-.3:.1:.3])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
axis square;
t=text(44,.35,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5B_',nm{i_nm},'_left']);
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5C: WRONG

% Specifications
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= .15; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([1.1 1.1]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
plot([1.1+motionL(i_sbj) 1.1+motionL(i_sbj)]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT distribution
bar(linspace((1.1+motionL(i_sbj)+step/1e3/2)/rate,(1.1+motionL(i_sbj)+step/1e3/2+5)/rate,length(bins)),rtdist_W(i_sbj,:).*.60,'linewidth',.5,'Facecolor','m','Edgecolor','w','FaceAlpha',.6); hold on;
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
% Plot average time series
fillsteplotk(ts_S_R_W{i_nm,i_sbj},lw);
% Add significance
for c= 1;
    p= ts_S_P_W{i_nm,i_sbj};
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz,'s','color','k','MarkerFaceColor','k','MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 winL-4]);
set(gca,'XTick',11:10:winL)
set(gca,'XTickLabel',{'0','1','2','3','4','5'})
set(gca,'YTick',[-.1:.1:.1])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
title('error','FontSize',titleSize,'FontWeight','normal');
axis square;
t=text(44,.15,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5C_',nm{i_nm},'_error']);
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5C: CORRECT

% Specifications
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= .15; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([1.1 1.1]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
plot([1.1+motionL(i_sbj) 1.1+motionL(i_sbj)]./rate,[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT distribution
bar(linspace((1.1+motionL(i_sbj)+step/1e3/2)/rate,(1.1+motionL(i_sbj)+step/1e3/2+5)/rate,length(bins)),rtdist_C(i_sbj,:).*.60,'linewidth',.5,'Facecolor','m','Edgecolor','w','FaceAlpha',.6); hold on;
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
% Plot average time series
fillsteplotk(ts_S_R_C{i_nm,i_sbj},lw);
% Add significance
for c= 1;
    p= ts_S_P_C{i_nm,i_sbj};
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz,'s','color','k','MarkerFaceColor','k','MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 winL-4]);
set(gca,'XTick',11:10:winL)
set(gca,'XTickLabel',{'0','1','2','3','4','5'})
set(gca,'YTick',[-.1:.1:.1])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
title('correct','FontSize',titleSize,'FontWeight','normal');
axis square;
t=text(44,.15,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5C_',nm{i_nm},'_correct']);
end

%% -----------------------------------------------------------------------
%% ANALYSIS: DECISION-LOCKED DATA

% Select decision-locked data
file_nm= '_decision_'; % file name: decision-locked neurochemisty

% Loop through neuromodulators
for i_nm = 1:length(nm)
        
    % Loop through subjects
    for i_sbj = 1:length(ss)

    % Load behaviour
    load([repoBase,fs,dataDirB,fs,file_ss,num2str(ss(i_sbj)),file_b,'.mat']);

    % Load neurochemistry
    load([repoBase,fs,dataDirNM,fs,file_ss,num2str(ss(i_sbj)),file_nm,nm{i_nm},'.mat']);
    ts= timeSeries;

    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    
    % Smooth
    winS= 5;
    ts_S= ts;
    ts_S(:,1:winS-1)= zeros(size(ts_S,1),winS-1);
    ts_S(:,1:2)= zeros(size(ts_S,1),2);
    for t= winS:size(ts,2)
        ts_S(:,t)= mean(ts(:,(t+1-winS):t),2);
    end
    
    % Save neuromodulator time series and result of statistical test
	% Divide by RT bin (slow, medium, fast)
    % All trials
    include2= include;
    rt= log(data.rt1./1e3);
    rt_quantile= quantile(rt(include2),2);
    catz= [];
    for t= 1:length(data.rt1); catz(t)= sum(rt(t)>rt_quantile)+1; end;
    for c= 1:length(unique(catz));
        idx= find(include2 & catz==c);
        ts_D_S_B_R{i_nm,i_sbj}(c,:)= mean(ts_S(idx,:));
        ts_D_S_B_P{i_nm,i_sbj}(c,:)= ttest(ts_S(idx,:),0);
    end
    
    % Save neuromodulator time series and result of statistical test
	% Divide by RT bin (slow, medium, fast)
    % Correct trials
    include2= include & data.acc==1;
    rt= log(data.rt1./1e3);
    rt_quantile= quantile(rt(include2),2);
    catz= [];
    for t= 1:length(data.rt1); catz(t)= sum(rt(t)>rt_quantile)+1; end;
    for c= 1:length(unique(catz));
        idx= find(include2 & catz==c);
        ts_D_S_B_R_C{i_nm,i_sbj}(c,:)= mean(ts_S(idx,:));
        ts_D_S_B_P_C{i_nm,i_sbj}(c,:)= ttest(ts_S(idx,:),0);
    end
    
    % Save neuromodulator time series and result of statistical test
	% Divide by RT bin (slow, medium, fast)
    % Error trials
    include2= include & data.acc==0;
    rt= log(data.rt1./1e3);
    rt_quantile= quantile(rt(include2),2);
    catz= [];
    for t= 1:length(data.rt1); catz(t)= sum(rt(t)>rt_quantile)+1; end;
    for c= 1:length(unique(catz));
        idx= find(include2 & catz==c);
        ts_D_S_B_R_W{i_nm,i_sbj}(c,:)= mean(ts_S(idx,:));
        ts_D_S_B_P_W{i_nm,i_sbj}(c,:)= ttest(ts_S(idx,:),0);
    end
    
    end
    
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5B - RIGHT

% Specifications
colz= flipud(cool(3));
sLIMS= .36; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= [.10 .20 .30]; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([4.1/rate 4.1/rate],[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT bins and add significance
for c= 1:3;
    plot(ts_D_S_B_R{i_nm,i_sbj}(c,:),'-','color',colz(c,:),'lineWidth',lw);
    p= ts_D_S_B_P{i_nm,i_sbj}(c,:);
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz(c),'s','color',colz(c,:),'MarkerFaceColor',colz(c,:),'MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([21 61]);
set(gca,'XTick',[31 41 51])
set(gca,'XTickLabel',{'-1','0','1'})
set(gca,'YTick',[-.3:.1:.3])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
axis square;
t=text(50,.32,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5B_',nm{i_nm},'_right']);
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5D - ERROR

% Specifications
colz= flipud(cool(3));
sLIMS= .36; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= [.10 .20 .30]; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([4.1/rate 4.1/rate],[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT bins and add significance
for c= 1:3;
    plot(ts_D_S_B_R_W{i_nm,i_sbj}(c,:),'-','color',colz(c,:),'lineWidth',lw);
    p= ts_D_S_B_P_W{i_nm,i_sbj}(c,:);
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz(c),'s','color',colz(c,:),'MarkerFaceColor',colz(c,:),'MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([21 61]);
set(gca,'XTick',[31 41 51])
set(gca,'XTickLabel',{'-1','0','1'})
set(gca,'YTick',[-.3:.1:.3])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
title('error','FontSize',titleSize,'FontWeight','normal');
axis square;
t=text(50,.32,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5D_',nm{i_nm},'_error']);
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 5D - CORRECT

% Specifications
colz= flipud(cool(3));
sLIMS= .36; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8]; % length of motion stimulus in seconds
offz= [.10 .20 .30]; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [5]; % patients 1-3 and group
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 300*n_plots 300]);
fig.PaperPositionMode = 'auto';
j= 0;
% Loop through subjects
for i_sbj= v_ss;
j= j+1;
% Curent subplot
subplot(1,n_plots,j); 
% Add reference lines
plot([0 winL],[0 0],'k-','LineWidth',lw); hold on
plot([4.1/rate 4.1/rate],[-1 +1],'k-','LineWidth',lw/2); hold on
% Plot RT bins and add significance
for c= 1:3;
    plot(ts_D_S_B_R_C{i_nm,i_sbj}(c,:),'-','color',colz(c,:),'lineWidth',lw);
    p= ts_D_S_B_P_C{i_nm,i_sbj}(c,:);
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz(c),'s','color',colz(c,:),'MarkerFaceColor',colz(c,:),'MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([21 61]);
set(gca,'XTick',[31 41 51])
set(gca,'XTickLabel',{'-1','0','1'})
set(gca,'YTick',[-.3:.1:.3])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
title('correct','FontSize',titleSize,'FontWeight','normal');
axis square;
t=text(50,.32,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure5D_',nm{i_nm},'_correct']);
end