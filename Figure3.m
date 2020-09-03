% Bang et al (2020) Sub-second dopamine and serotonin signalling in human
% striatum during perceptual decision-making
%
% Reproduces "Figure 3. Caudate nucleus: serotonin signalling tracks 
% uncertainty within trials." 
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
label_ss= {'1-ET','2-PD','3-ET','4-ET','5-PD','group'}; % subject (+ group) labels for plotting
label_nm= {'DA','5-HT'}; % neuromodulator labels for plotting
file_ss= 'P'; % file name: patient 
file_b= '_day2_task'; % file name: behaviour
file_nm= '_stimulus_'; % file name: stimulus-locked neurochemisty

% Add customn functions
addpath('Functions');

%% -----------------------------------------------------------------------
%% ANALYSIS: FIGURE 3A

% Loop through neuromodulators
for i_nm = 1:length(nm)
    
    % Prepare group variables
    tmp.sbj= [];
    tmp.nm= [];
    tmp.coh= [];
    
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
    
    % Smooth
    winS= 5;
    ts_S= ts;
    ts_S(:,1:winS-1)= zeros(size(ts_S,1),winS-1);
    ts_S(:,1:2)= zeros(size(ts_S,1),2);
    for t= winS:size(ts,2)
        ts_S(:,t)= mean(ts(:,(t+1-winS):t),2);
    end
    
    % Divide according to coherence
    for i_coh= 1:2
        idx= find(include & data.cohcat==i_coh);
        ts_S_C{i_nm,i_sbj,i_coh}= ts_S(idx,:);
    end
    
    % Statistical testing
    idx= include==1;
    ts_S_LC= ts_S_C{i_nm,i_sbj,1};
    ts_S_HC= ts_S_C{i_nm,i_sbj,2};
    t= 0;
    for j= 1:size(ts_S,2)
        t= t+1;
        [a,b,c,d]= ttest2(ts_S_LC(:,t),ts_S_HC(:,t));
        ts_S_P{i_nm}(i_sbj,t)= b;
    end
    
    % add subject to group data if patient 1-3
    if i_sbj< 4;
    tmp.sbj= [tmp.sbj; ones(sum(include),1).*i_sbj];
    tmp.nm=  [tmp.nm; ts_S(include,:)];
    end
       
    end
    
    % Group
    
    % Update subject index - now group
    i_sbj= i_sbj+ 1;
    
    % Divide according to coherence
    for i_coh= 1:2
        ts_S_C{i_nm,i_sbj,i_coh}= [ts_S_C{i_nm,1,i_coh}; ts_S_C{i_nm,2,i_coh}; ts_S_C{i_nm,3,i_coh}];
    end
        
    % Statistical testing
    idx= include==1;
    ts_S_LC= ts_S_C{i_nm,i_sbj,1};
    ts_S_HC= ts_S_C{i_nm,i_sbj,2};
    t= 0;
    for j= 1:size(ts_S,2)
        t= t+1;
        [a,b,c,d]= ttest2(ts_S_LC(:,t),ts_S_HC(:,t));
        ts_S_P{i_nm}(i_sbj,t)= b;
    end
    
end


%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 3A

% Specifications
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 22; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8 1]; % length of motion stimulus in seconds
offz= .15; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= 2; % serotonin
v_ss= [1 2 3 6]; % patients 1-3 and group
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
% Plot average time series
fillsteplotblue(ts_S_C{i_nm,i_sbj,1},lw);
fillsteplotred(ts_S_C{i_nm,i_sbj,2},lw);
% Add significance
for c= 1;
    p= ts_S_P{i_nm}(i_sbj,:)<.05;
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz,'s','color','k','MarkerFaceColor','k','MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 26]);
set(gca,'XTick',[11 16 21 26 31])
set(gca,'XTickLabel',{'0','.5','1','1.5','2'})
set(gca,'YTick',[-.1:.1:.1])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [z]'],'FontSize',labelSize);
axis square;
t=text(22,.15,label_ss{i_sbj});
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure3A_',nm{i_nm}]);
end

%% -----------------------------------------------------------------------
%% ANALYSIS: FIGURE 3C

% Loop through neuromodulators
for i_nm = 1:length(nm)
    
    % Prepare group variables
    tmp.nm= [];
    tmp.coh= [];
    tmp.bod= [];
    tmp.int= [];
    tmp.acc= [];
    tmp.sbj= [];
    tmp.rt1= [];
    
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
    
    % Smooth
    winS= 5;
    ts_S= ts;
    ts_S(:,1:winS-1)= zeros(size(ts_S,1),winS-1);
    ts_S(:,1:2)= zeros(size(ts_S,1),2);
    for t= winS:size(ts,2)
        ts_S(:,t)= mean(ts(:,(t+1-winS):t),2);
    end
    
    % Statistical testing
    idx= include==1;
    ts_S_2= ts_S(idx,:);
    A= zscore(data.acc(idx)-.5);
    RT= zscore(log(data.rt1(idx)));
    C= zscore(data.cohcat(idx));
    D= zscore(data.bodcat(idx));
    CxD= C.*D;
    t= 0;
    for j= 1:size(ts_S_2,2)
        t= t+1;
        x= [A; RT; C; D; CxD]';
        y= ts_S_2(:,j);
        [beta,~,stats]= glmfit(x,y,'normal','constant','on');
        ts_B{i_nm}.var{1}(i_sbj,t)= beta(end-2);
        ts_B{i_nm}.var{2}(i_sbj,t)= beta(end-1);
        ts_B{i_nm}.var{3}(i_sbj,t)= beta(end-0);
        ts_P{i_nm}.var{1}(i_sbj,t)= stats.p(end-2);
        ts_P{i_nm}.var{2}(i_sbj,t)= stats.p(end-1);
        ts_P{i_nm}.var{3}(i_sbj,t)= stats.p(end-0);
    end
    
    % Add subject to group data if patient 1-3
    if i_sbj< 4;
    tmp.sbj= [tmp.sbj; ones(sum(include),1).*i_sbj];
    tmp.nm=  [tmp.nm;  ts_S(include,:)];
    tmp.coh= [tmp.coh; zscore(data.cohcat(include))'];
    tmp.bod= [tmp.bod; zscore(data.bodcat(include))'];
    tmp.int= [tmp.int; (zscore(data.cohcat(include)).*zscore(data.bodcat(include)))'];
    tmp.acc= [tmp.acc; zscore(data.acc(include)-.5)'];
    tmp.rt1= [tmp.rt1; zscore(log(data.rt1(include)./1e3))'];
    end

    end
    
    % Group
    
    % Update subject index - now group
    i_sbj= i_sbj+ 1;
    
    % Create subject intercepts
    n_trials= length(tmp.sbj);
    n_subjects= length(ss);
    interceptz= zeros(n_trials,n_subjects-1);
    for s= 2:n_subjects;
        my_trials= find(tmp.sbj==s);
        interceptz(my_trials,s-1) = 1;
    end
    
    % Statistical testing
    I= interceptz;
    A= tmp.acc;
    RT= tmp.rt1;
    C= tmp.coh;
    D= tmp.bod;
    CxD= tmp.int;
    ts_S_2= tmp.nm;
    t= 0;
    for j= 1:size(ts_S_2,2)
        t= t+1;
        x= [A RT C D CxD];
        y= ts_S_2(:,j);
        [beta,~,stats]= glmfit(x,y,'normal','constant','on');
        ts_B{i_nm}.var{1}(i_sbj,t)= beta(end-2);
        ts_B{i_nm}.var{2}(i_sbj,t)= beta(end-1);
        ts_B{i_nm}.var{3}(i_sbj,t)= beta(end-0);
        ts_P{i_nm}.var{1}(i_sbj,t)= stats.p(end-2);
        ts_P{i_nm}.var{2}(i_sbj,t)= stats.p(end-1);
        ts_P{i_nm}.var{3}(i_sbj,t)= stats.p(end-0);
    end
    
end


%% -----------------------------------------------------------------------
%% VISUALISATION: FIGURE 3C

% Specifications
colors_p= [255 0 255;
       0 255 255;
       0 255 0]./255; % colours
sLIMS= .16; % y-axis limits
rate= .100; % sampling rate
winL= size(timeSeries,2); % window size
tickSize= 22; % tick size
labelSize= 30; % label size
titleSize= 16; % title size
lw= 4; % line width
ms= 8; % marker size
motionL= [1 1 1 1 .8 1]; % length of motion stimulus in seconds
offz= [.075 .15 .225]; % marker offset relative to y-axis limits
% Select data for plotting
v_nm= [1 2]; % serotonin
v_ss= [6]; % group
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
% Plot results
for c= 1:3;
    plot(ts_B{i_nm}.var{c}(i_sbj,:),'-','color',colors_p(c,:),'lineWidth',lw);
    p= ts_P{i_nm}.var{c}(i_sbj,:)<.05;
    for t= 1:length(p); if p(t)==1; plot(t,-sLIMS+sLIMS*offz(c),'s','color','w','MarkerFaceColor',colors_p(c,:),'MarkerSize',ms); end; end;
end
% Tidy up
ylim([-sLIMS  sLIMS]); 
xlim([11 51]);
set(gca,'XTick',[11 21  31 41 51])
set(gca,'XTickLabel',{'0','1','2','3','4'})
set(gca,'YTick',[-.3:.1:.3])
box('off')
set(gca,'FontSize',tickSize,'LineWidth',lw);
xlabel('time [s]','FontSize',labelSize);
ylabel([label_nm{i_nm},' [\beta]'],'FontSize',labelSize);
axis square;
if i_sbj < 4;
    t=text(41,.15,label_ss{i_sbj});
else
    t=text(41,.15,label_ss{i_sbj});
end
set(t,'FontSize',tickSize);
end
print('-djpeg','-r300',['Figures',fs,'Figure3C_',nm{i_nm}]);
end