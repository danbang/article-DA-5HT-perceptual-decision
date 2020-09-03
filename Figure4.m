% Bang et al (2020) Sub-second dopamine and serotonin signalling in human
% striatum during perceptual decision-making
%
% Reproduces "Figure 4. Caudate nucleus: dopamine and serotonin signalling 
% tracks experienced trial type transitions. " 
%
% Notes: the variables "v_nm" and "v_ss" specify which neuromodulators and
% patients are plotted
% 
% Dan Bang danbang.db@gmail.com 2020

%% -----------------------------------------------------------------------
%% PREPARATION

% fresh memory
clear; close all;

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
file_nm= '_stimulus_'; % file name: stimulus-locked neurochemisty

% Add customn functions
addpath('Functions');

%% -----------------------------------------------------------------------
%% ANALYSIS: FIGURE 4B

% Loop through neuromodulators
for i_nm = 1:length(nm)
        
    % Loop through subjects
    for i_sbj = 1:length(ss)

    % Load behaviour
    load([repoBase,fs,dataDirB,fs,file_ss,num2str(ss(i_sbj)),file_b,'.mat']);

    % Load neurochemistry
    load([repoBase,fs,dataDirNM,fs,file_ss,num2str(ss(i_sbj)),file_nm,nm{i_nm},'.mat']);
    ts= timeSeries;

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
    
    % Compute average response within time window given by winL and winH
    ts= ts(include,:);
    for j= 1:size(ts,1)
       winL= 11; % stimulus onset
       winH= winL+15; % 1.5 s after stimulus onset
       ts_S(j)= mean(ts(j,winL:winH));
    end
    
    % New variables (C: current; P: previous)
    nTrials= sum(include);
    acc= data.acc(include);
    trialCohzC= data.cohcat(include);
    trialCohzP= [0 trialCohzC(1:end-1)];
    trialBodzC= data.bodcat(include);
    trialBodzP= [0 trialBodzC(1:end-1)];
    data.cohcat2= data.cohcat;
    data.cohcat2(data.cohcat2==1)= 0;
    trialTypeC= data.cohcat2(include)+data.bodcat(include);
    trialTypeP= [0 trialTypeC(1:end-1)];
    
    % Task statistics
    % Conditional transition performance
    for p= 1:4
        for c= 1:4
            myTrials= trialTypeP==p & trialTypeC==c;
            stat_conditional_acc(c,p,i_sbj)= mean(acc(myTrials));
        end
    end
    % Marginal probabilities
    for p= 1:4
        for c= 1:4
            myTrials= trialTypeC==c;
            stat_marginal_prob(c,p,i_sbj)= sum(myTrials)/length(myTrials);
        end
    end
    % Conditional transition probabilities
    for p= 1:4
        for c= 1:4
            myTrials= trialTypeP==p & trialTypeC==c;
            stat_conditional_prob(c,p,i_sbj)= sum(myTrials)/sum(trialTypeP==p);
        end
    end
    % Conditional transition neuromodulator responses
    for p= 1:4
        for c= 1:4
            myTrials= trialTypeP==p & trialTypeC==c;
            stat_conditional_nm{i_nm}(c,p,i_sbj)= mean(ts_S(myTrials));
        end
    end
      
    end
    
end

%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 4B

% Specifications
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
legendSize= 18; % legend size
lw= 4; % line width
ms= 10; % marker size
offz= .15; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % dopamine and serotonin
v_ss= [4]; % patient 4
n_plots= length(v_ss);
% Loop through neuromodulators
for i_nm= v_nm;
% Loop through subjects
for i_sbj= v_ss;
% Prepare figure
fig=figure('color',[1 1 1],'pos',[400 400 300 300]);
fig.PaperPositionMode = 'auto';   
% Add reference lines
plot([-4 4],[0 0],'k--','LineWidth',lw/2); hold on
plot([0 0],[-4 4],'k--','LineWidth',lw/2); hold on
% Extract data
x= stat_conditional_prob(:,:,i_sbj);
x= x(:);
x= zscore(x);
y= stat_conditional_nm{i_nm}(:,:,i_sbj);
y= y(:);
y= zscore(y);
x_plot= x; 
y_plot= y;
% Rank transition probabilities for colouring dots
colDots= parula(16);
x_rank= x_plot+rand(16,1)*.0001;
x_rank= tiedrank(x_rank);
% Plot dots
for i_dot= 1:length(x_rank);
    plot(x_plot(i_dot),y_plot(i_dot),'ko','MarkerFaceColor',colDots(x_rank(i_dot),:),'MarkerSize',ms);
end
% Fit line
[beta,~,stats]= glmfit([x_plot],y_plot);
% Plot fitted line
x_plot= -3:.1:3;
plot(x_plot,beta(1)+beta(end)*x_plot,'k-','LineWidth',lw);
% Tidy up
ylim([-3.5 3.5]); 
xlim([-3.5 3.5]);
set(gca,'XTick',-3:1:3)
set(gca,'YTick',-3:1:3)
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('P(type_t|type_t_-_1)','FontSize',labelSize);
ylabel([label_nm{i_nm},'_t'],'FontSize',labelSize);
axis square;
t=text(1.9,2.9,label_ss{i_sbj});
set(t,'FontSize',legendSize);
t=text(-3.2,-3,['p = ',num2str(round(stats.p(2)*1e3)/1e3)]);
set(t,'FontSize',legendSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure4B_',nm{i_nm},'_P',num2str(i_sbj)]);
end