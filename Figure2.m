% Bang et al (2020) Sub-second dopamine and serotonin signalling in human
% striatum during perceptual decision-making
%
% Reproduces "Figure 2. Behavioural performance."
%
% Notes: 
% - See end of script for mixed-effects regression
%
% Dan Bang danbang.db@gmail.com 2020

%% -----------------------------------------------------------------------
%% PREPARATION

% fresh memory
clear; close all;

% Paths [change 'repoBase' according to local setup]
fs= filesep;
repoBase= [getDropbox(1),fs,'Ego',fs,'Matlab',fs,'ucl',fs,'voltammetry',fs,'Repository',fs,'GitHub'];
dataDir= ['Data',fs,'Behaviour'];

% Add customn functions
addpath('Functions');

%% -----------------------------------------------------------------------
%% ANALYSIS: HEALTHY CONTROLS (C) DAY 1

% Subjects
n_subjects= 51;

% File names
sidx= 'C';
file= '_day1_task';

% Loop through subjects
for s= 1:n_subjects
        
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file,'.mat'];
    load(fname);
    
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;
    
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    
    % Save behavioural performance
    controls.day1.mean.acc(s)= mean(data.acc);
    controls.day1.mean.rt1(s)= mean(data.rt1);
    controls.day1.mean.con(s)= mean(data.con(data.concat==1));
      
end

%% -----------------------------------------------------------------------
%% ANALYSIS: PATIENTS (P) DAY 1

% Subjects
n_subjects= 5;

% File names
sidx= 'P';
file= '_day1_task';

% Loop through subjects
for s= 1:n_subjects
        
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file,'.mat'];
    load(fname);
    
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;
    
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    
    % Compute behavioural performance
    
    % Average across all conditions
    patients.day1.mean.acc(s)= mean(data.acc);
    patients.day1.mean.rt1(s)= mean(data.rt1);
    patients.day1.mean.con(s)= mean(data.con(data.concat==1));
    
    % Main effect of each factor
    for i= 1:2; patients.day1.main.accCoh(s,i)= mean(data.acc(data.cohcat==i &include)); end;
    for i= 1:2; patients.day1.main.accBod(s,i)= mean(data.acc(data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.main.rt1Coh(s,i)= mean(data.rt1(data.cohcat==i &include)); end;
    for i= 1:2; patients.day1.main.rt1Bod(s,i)= mean(data.rt1(data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.main.conCoh(s,i)= nanmean(data.con(data.cohcat==i &include)); end;
    for i= 1:2; patients.day1.main.conBod(s,i)= nanmean(data.con(data.bodcat==i &include)); end;
    
    % Average within each condition
    for i= 1:2; patients.day1.cond.accCoh1(s,i)= mean(data.acc(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.cond.accCoh2(s,i)= mean(data.acc(data.cohcat==2 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.cond.rt1Coh1(s,i)= mean(data.rt1(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.cond.rt1Coh2(s,i)= mean(data.rt1(data.cohcat==2 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.cond.conCoh1(s,i)= nanmean(data.con(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day1.cond.conCoh2(s,i)= nanmean(data.con(data.cohcat==2 &data.bodcat==i &include)); end;
      
end

%% -----------------------------------------------------------------------
%% ANALYSIS: PATIENTS (P) DAY 2

% Subjects
n_subjects= 5;

% File names
sidx= 'P';
file= '_day2_task';

% Loop through subjects
for s= 1:n_subjects
        
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file,'.mat'];
    load(fname);
    
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;
    
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    
    % Compute behavioural performance
    
    % Average across all conditions
    patients.day2.mean.acc(s)= mean(data.acc);
    patients.day2.mean.rt1(s)= mean(data.rt1);
    patients.day2.mean.con(s)= mean(data.con(data.concat==1));
    
    % Main effect of each factor
    for i= 1:2; patients.day2.main.accCoh(s,i)= mean(data.acc(data.cohcat==i &include)); end;
    for i= 1:2; patients.day2.main.accBod(s,i)= mean(data.acc(data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.main.rt1Coh(s,i)= mean(data.rt1(data.cohcat==i &include)); end;
    for i= 1:2; patients.day2.main.rt1Bod(s,i)= mean(data.rt1(data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.main.conCoh(s,i)= nanmean(data.con(data.cohcat==i &include)); end;
    for i= 1:2; patients.day2.main.conBod(s,i)= nanmean(data.con(data.bodcat==i &include)); end;
    
    % Average within each condition
    for i= 1:2; patients.day2.cond.accCoh1(s,i)= mean(data.acc(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.cond.accCoh2(s,i)= mean(data.acc(data.cohcat==2 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.cond.rt1Coh1(s,i)= mean(data.rt1(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.cond.rt1Coh2(s,i)= mean(data.rt1(data.cohcat==2 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.cond.conCoh1(s,i)= nanmean(data.con(data.cohcat==1 &data.bodcat==i &include)); end;
    for i= 1:2; patients.day2.cond.conCoh2(s,i)= nanmean(data.con(data.cohcat==2 &data.bodcat==i &include)); end;
      
end

%% -----------------------------------------------------------------------
%% VISUALISATION

% Specifications
bcol= [200 200 255]./255; % blue colour
rcol= [255 200 200]./255; % red colur
greenz= [0 250 154]./255; % green colour    
pinkz= 'm'; % pink colour
msI= [14 16 14 14 14 18]; % marker size 1
msI2= [14 16 14 14 14 18]+12; % marker size 2
meanX= 3.5; % x-axis coordinate for average data
jitter= 2; % marker jitter for similar data values
symbz= {'o','s','d','^','v'}; % participant symbols
offz= [.05 .1 .15 .20 .25 .30].*1.25; % marker offsets
add_mainEffect= 1; % overlay main effects with cross hairs

%% FIGURE 2A: DAY 1
% create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day1.cond.accCoh1; 
y2= patients.day1.cond.accCoh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day1.main.accCoh);
dMean= mean(patients.day1.main.accBod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.4 1],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.acc;
patient= patients.day1.mean.acc;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',greenz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.4 1]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.4:.1:1]);
ylabel('accuracy');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2A_day1']);

%% FIGURE 2A: DAY 2
% Create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day2.cond.accCoh1; 
y2= patients.day2.cond.accCoh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day2.main.accCoh);
dMean= mean(patients.day2.main.accBod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.4 1],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.acc;
patient= patients.day2.mean.acc;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',pinkz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.4 1]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.4:.1:1]);
ylabel('accuracy');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2A_day2']);

%% FIGURE 2B: DAY 1
% Create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day1.cond.rt1Coh1; 
y2= patients.day1.cond.rt1Coh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day1.main.rt1Coh);
dMean= mean(patients.day1.main.rt1Bod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.5 3.5],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.rt1;
patient= patients.day1.mean.rt1;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',greenz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.5 3.5]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.5:1:3.5]);
ylabel('reaction time');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2B_day1']);

%% FIGURE 2B: DAY 2
% Create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day2.cond.rt1Coh1; 
y2= patients.day2.cond.rt1Coh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day2.main.rt1Coh);
dMean= mean(patients.day2.main.rt1Bod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.5 3.5],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.rt1;
patient= patients.day2.mean.rt1;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',pinkz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.5 3.5]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.5:1:3.5]);
ylabel('reaction time');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2B_day2']);

%% FIGURE 2C: DAY 1
% Create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day1.cond.conCoh1; 
y2= patients.day1.cond.conCoh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day1.main.conCoh);
dMean= mean(patients.day1.main.conBod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.6 1],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.con;
patient= patients.day1.mean.con;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',greenz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.6 1]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.4:.1:1]);
ylabel('confidence');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2C_day1']);

%% FIGURE 2C: DAY 2
% Create figure
figz=figure('color',[1 1 1]);
% Load patient data for low and high coherence
y1= patients.day2.cond.conCoh1; 
y2= patients.day2.cond.conCoh2;
% Plot individual data points
for k= 1:n_subjects
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),'-','color',bcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y1(k,:),symbz{k},'color','k','MarkerFaceColor',bcol,'MarkerSize',msI(k)); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),'-','color',rcol,'LineWidth',4); hold on;
plot([1-offz(k) 2+(.35-offz(k))],y2(k,:),symbz{k},'color','k','MarkerFaceColor',rcol,'MarkerSize',msI(k)); hold on;
end
% Plot average data
fillsteplotblue(y1,10);
fillsteplotred(y2,10);
% Plot main effects
if add_mainEffect
cMean= mean(patients.day2.main.conCoh);
dMean= mean(patients.day2.main.conBod);
plot([1.5 1.5],[cMean(1) cMean(2)],'k-','LineWidth',2);
plot([1.5],[cMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1.5],[cMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([1 2],[dMean(1) dMean(2)],'k-','LineWidth',2);
plot([1],[dMean(1)],'ko','MarkerFaceColor','k','LineWidth',2);
plot([2],[dMean(2)],'ko','MarkerFaceColor','k','LineWidth',2);
end
% Plot population data
plot([2+((meanX-2)/2) 2+((meanX-2)/2)],[.4 1],'--','Color','k','LineWidth',4);
healthy= controls.day1.mean.con;
patient= patients.day2.mean.con;
q000= min(healthy);
q125= quantile(healthy,.125);
q875= quantile(healthy,.875);
q100= max(healthy);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q000 q125 q125 q000],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q125 q875 q875 q125],'k');
set(rec,'EdgeColor','none','FaceAlpha',.5);
myX= [meanX-.3 3.5];
rec=fill([meanX-.3 meanX-.3 meanX+.3 meanX+.3],[q875 q100 q100 q875],'k');
set(rec,'EdgeColor','none','FaceAlpha',.2);
% Plot patient data
x= violaPoints(meanX,patient,jitter);
for k= 1:n_subjects
    plot(x(k),patient(k),symbz{k},'color','k','MarkerFaceColor',pinkz,'MarkerSize',msI2(k)); hold on;
end
% Tidy up
xlim([.3 meanX+.7]); ylim([.6 1]);
set(gca,'XTick',[1 2 meanX],'XTickLabel',{'low','high','all trials'});
set(gca,'YTick',[.4:.1:1]);
ylabel('confidence');
xlabel('distance');
set(gca,'FontSize',40,'LineWidth',4);
box off;
print('-djpeg','-r300',['Figures',filesep,'Figure2C_day2']);

%% -----------------------------------------------------------------------
%% MIXED-EFFECTS ANALYSIS: ACCURACY

% Subjects
n_subjects= 5;

% File names
sidx= 'P';
file1= '_day1_task';
file2= '_day2_task';

% Temporary storage
tmp.ses = [];
tmp.sbj = [];
tmp.acc = [];
tmp.rt1 = [];
tmp.con = [];
tmp.coh = [];
tmp.dis = [];
tmp.int = [];

% Loop through subjects
for s= 1:n_subjects
    
    %% Day 1
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file1,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*1];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];
    
    %% Day 2
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file2,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*2];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];

end

% Extract data
session     = tmp.ses';
subject     = tmp.sbj';
accuracy    = tmp.acc';
rt          = tmp.rt1';
confidence  = tmp.con';
coherence   = tmp.coh';
distance    = tmp.dis';
interaction = tmp.int';

% Transform to table
datanames   = {'session','subject', ...
               'accuracy','rt','confidence', ...
               'coherence','distance','interaction'};
datatab     = table(session,categorical(subject), ...
              accuracy,rt,confidence, ...
              coherence,distance,interaction, ...
              'VariableNames',datanames);

% Specify formula
formulaz    = ['accuracy ~ 1 +' ...
              'coherence + distance + interaction + ' ...
              '(1 + coherence + distance + interaction | subject)'];
          
% Fit mixed-effects model
lmehat_acc = fitglme(datatab,formulaz,'distribution','binomial','Link','logit','FitMethod','REMPL');

%% -----------------------------------------------------------------------
%% MIXED-EFFECTS ANALYSIS: REACTION TIME

% Subjects
n_subjects= 5;

% File names
sidx= 'P';
file1= '_day1_task';
file2= '_day2_task';

% Temporary storage
tmp.ses = [];
tmp.sbj = [];
tmp.acc = [];
tmp.rt1 = [];
tmp.con = [];
tmp.coh = [];
tmp.dis = [];
tmp.int = [];

% Loop through subjects
for s= 1:n_subjects
    
    %% Day 1
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file1,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*1];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];
    
    %% Day 2
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file2,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*2];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];

end

% Extract data
session     = tmp.ses';
subject     = tmp.sbj';
accuracy    = tmp.acc';
rt          = tmp.rt1';
confidence  = tmp.con';
coherence   = tmp.coh';
distance    = tmp.dis';
interaction = tmp.int';

% Transform to table
datanames   = {'session','subject', ...
               'accuracy','rt','confidence', ...
               'coherence','distance','interaction'};
datatab     = table(session,categorical(subject), ...
              accuracy,rt,confidence, ...
              coherence,distance,interaction, ...
              'VariableNames',datanames);

% Specify formula
formulaz    = ['rt ~ 1 +' ...
              'coherence + distance + interaction + ' ...
              '(1 + coherence + distance + interaction | subject)'];
          
% Fit mixed-effects model
lmehat_rt1 = fitglme(datatab,formulaz,'distribution','normal','Link','identity','FitMethod','REMPL');
 
%% -----------------------------------------------------------------------
%% MIXED-EFFECTS ANALYSIS: CONFIDENCE

% Subjects
n_subjects= 5;

% File names
sidx= 'P';
file1= '_day1_task';
file2= '_day2_task';

% Temporary storage
tmp.ses = [];
tmp.sbj = [];
tmp.acc = [];
tmp.rt1 = [];
tmp.con = [];
tmp.coh = [];
tmp.dis = [];
tmp.int = [];

% Loop through subjects
for s= 1:n_subjects
    
    %% Day 1
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file1,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Exclude non-confidence trials
    include= include & data.concat==1;
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*1];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];
    
    %% Day 2
    % Load data
    fname= [repoBase,fs,dataDir,fs,sidx,num2str(s),file2,'.mat'];
    load(fname);   
    % Change RT from miliseconds to seconds
    data.rt1= data.rt1./1000;  
    % Exclusion
    % Exclude trials based on deviation from grand mean
    rt1= log(data.rt1);
    centre= mean(rt1);
    stdval= std(rt1)*3;
    include= (rt1>(centre-stdval))&(rt1<(centre+stdval));
    % Exclude first and last trial
    include= include & data.trial>data.trial(1) & data.trial<data.trial(end);
    % Exclude non-confidence trials
    include= include & data.concat==1;
    % Store data
    idx= include;
    n_trials= sum(idx);
    tmp.ses = [tmp.ses ones(1,n_trials)*2];
    tmp.sbj = [tmp.sbj ones(1,n_trials)*s];
    tmp.acc = [tmp.acc data.acc(idx)];
    tmp.rt1 = [tmp.rt1 zscore(log(data.rt1(idx)))];
    tmp.con = [tmp.con zscore(data.con(idx))];
    tmp.coh = [tmp.coh zscore(data.cohcat(idx))];
    tmp.dis = [tmp.dis zscore(data.bodcat(idx))];
    tmp.int = [tmp.int zscore(data.cohcat(idx)).*zscore(data.bodcat(idx))];

end

% Extract data
session     = tmp.ses';
subject     = tmp.sbj';
accuracy    = tmp.acc';
rt          = tmp.rt1';
confidence  = tmp.con';
coherence   = tmp.coh';
distance    = tmp.dis';
interaction = tmp.int';

% Transform to table
datanames   = {'session','subject', ...
               'accuracy','rt','confidence', ...
               'coherence','distance','interaction'};
datatab     = table(session,categorical(subject), ...
              accuracy,rt,confidence, ...
              coherence,distance,interaction, ...
              'VariableNames',datanames);

% Specify formula
formulaz    = ['confidence ~ 1 +' ...
              'coherence + distance + interaction + ' ...
              '(1 + coherence + distance + interaction | subject)'];
          
% Fit mixed-effects model
lmehat_con = fitglme(datatab,formulaz,'distribution','normal','Link','identity','FitMethod','REMPL');