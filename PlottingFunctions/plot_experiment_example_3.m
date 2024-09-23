%====================================================================%
%          SPOT Plotting Functions Example #3
% 
% This script shows a basic example on using the provided plotting
% functions to plot multiple trials of experiment data compared to 
% simulation data. This data is from MPC validation (see, e.g., 
% 2025 AAS/AIAA Space Flight Mechanics Meeting).
% 
% Author: Courtney Savytska
% Date: September 2024
%====================================================================%

clear all
clc

%===================%
%   DEFINE FILES
%===================%

SAVE_DIRECTORY = 'Example Saved Data/';

% Experiment Files
EXP_DIRECTORY = ["ExperimentData_RED_2024_4_24_16_51_3_2777",...
                "ExperimentData_RED_2024_6_12_11_9_49_4377",...
                "ExperimentData_RED_2024_6_12_11_15_48_1949",...
                "ExperimentData_RED_2024_6_12_11_21_42_3117",...
                "ExperimentData_RED_2024_6_12_11_25_56_8872"];
DATA_MATNAME = [strcat(EXP_DIRECTORY(1),"_2"),...
                strcat(EXP_DIRECTORY(2),"_1"),...
                strcat(EXP_DIRECTORY(3),"_1"),...
                strcat(EXP_DIRECTORY(4),"_1"),...
                strcat(EXP_DIRECTORY(5),"_1")];
DATA_STARTTIME = [3580,...  % User can specify the index at which 
                   3662,... % the data starts. For example, start 
                   3681,... % at 44 s in each experiment data file.
                   3630,...
                   3630]; 
DATA_ENDTIME = DATA_STARTTIME +5067+...
    [0,...
    300,...
    200,...
    300,...
    0]; 

% Simulation File
SIM_FILE = strcat(SAVE_DIRECTORY,"SimulationData_2024_4_25_13_55_12_6617/dataPacket_SIM.mat");
SIM_STARTTIME = 4402;               % start at 44 s
SIM_ENDTIME = SIM_STARTTIME+8200;

%===================%
%     LOOPING
%===================%
figure()
for ind = 1:length(DATA_MATNAME)

    clearvars -except SAVE_DIRECTORY EXP_DIRECTORY DATA_MATNAME DATA_STARTTIME...
        DATA_ENDTIME SIM_FILE SIM_STARTTIME SIM_ENDTIME ind

    %===================%
    %  LOADING EXP FILE
    %===================%
    load(strcat(SAVE_DIRECTORY,EXP_DIRECTORY(ind),'/',DATA_MATNAME(ind)))

    %===================%
    %   LOADING DATA
    %===================%
    expdata_time = dataClass_rt.Time_s;
    [time,inds,~] = unique(expdata_time);
    unique_time = time(DATA_STARTTIME(ind):DATA_ENDTIME(ind)); 
    unique_inds = inds(DATA_STARTTIME(ind):DATA_ENDTIME(ind));

    expdata_RED_pos_x      = dataClass_rt.RED_Px_m(unique_inds);
    expdata_RED_pos_y      = dataClass_rt.RED_Py_m(unique_inds);
    expdata_RED_pos_th     = dataClass_rt.RED_Rz_rad(unique_inds);
    expdata_BLACK_pos_x    = dataClass_rt.BLACK_Px_m(unique_inds);
    expdata_BLACK_pos_y    = dataClass_rt.BLACK_Py_m(unique_inds);
    expdata_BLACK_pos_th   = dataClass_rt.BLACK_Rz_rad(unique_inds);
    expdata_BLUE_pos_x     = dataClass_rt.BLUE_Px_m(unique_inds);
    expdata_BLUE_pos_y     = dataClass_rt.BLUE_Py_m(unique_inds);
    expdata_BLUE_pos_th    = dataClass_rt.BLUE_Rz_rad(unique_inds);

    %===================%
    %        PLOT
    %===================%

    % User can specify indices to show snapshots of the platforms. Typically, 
    % these would be the initial and final conditions, but can also include 
    % intermediate snapshots
    plotting_indices = [1,round(length(unique_time)*0.2),round(length(unique_time)*0.4),length(unique_time)];
    alpha_values = [0.05,0.1,0.2,1]; % transparency for each snapshot; must be same length as 'plotting_indices'
    
    % Plotting spacecraft shapes
    for jj = length(plotting_indices):-1:1
        frame = plotting_indices(jj);
        alpha = alpha_values(jj);
        
        spacecraft = DrawSpacecraft([expdata_RED_pos_x(frame), expdata_RED_pos_y(frame), expdata_RED_pos_th(frame), 1]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',alpha) % Plot the chaser spacecraft
        hold on
        
        spacecraft = DrawSpacecraft([expdata_BLACK_pos_x(frame), expdata_BLACK_pos_y(frame), expdata_BLACK_pos_th(frame), 4]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'k', 'edgealpha',alpha) % Plot the target spacecraft
          
        spacecraft = DrawSpacecraft([expdata_BLUE_pos_x(frame), expdata_BLUE_pos_y(frame), expdata_BLUE_pos_th(frame), 3]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'b', 'edgealpha',alpha) % Plot the obstacle spacecraft
                            
        uistack(gca().Children(1),"bottom") % moving patches below lines
        uistack(gca().Children(1),"bottom")
        uistack(gca().Children(1),"bottom")     
    end

    % Plotting trajectory
    exphdl = plot(expdata_RED_pos_x, expdata_RED_pos_y, 'r-','LineWidth',0.5);
    plot(expdata_BLACK_pos_x, expdata_BLACK_pos_y, 'k-','LineWidth',1);
    plot(expdata_BLUE_pos_x, expdata_BLUE_pos_y,'b','LineWidth',1);
    
end

clearvars -except SAVE_DIRECTORY EXP_DIRECTORY DATA_MATNAME DATA_STARTTIME...
        DATA_ENDTIME SIM_FILE SIM_STARTTIME SIM_ENDTIME ind exphdl

%===================%
%  LOADING SIM FILE
%===================%
simdata = load(SIM_FILE);

%===================%
%   LOADING DATA
%===================%
dataClass_rt = simdata.dataClass;

expdata_time = dataClass_rt.Time_s;
[time,inds,~] = unique(expdata_time);
unique_time = time(SIM_STARTTIME:SIM_ENDTIME); % (DATA_STARTTIME:DATA_ENDTIME)
unique_inds = inds(SIM_STARTTIME:SIM_ENDTIME); % (DATA_STARTTIME:DATA_ENDTIME)

expdata_RED_pos_x      = dataClass_rt.RED_Px_m(unique_inds);
expdata_RED_pos_y      = dataClass_rt.RED_Py_m(unique_inds);

%===================%
%        PLOT
%===================%
simhdl = plot(expdata_RED_pos_x, expdata_RED_pos_y, 'k--','LineWidth',1);

xlabel('X-Position [m]')
ylabel('Y-Position [m]')
grid on
box on
ax = gca;
ax.FontSize = 10;
ax.FontName = "Times New Roman";  
xlim([0,3.5])
ylim([0,2.4])
daspect([1 1 1])
legend([simhdl,exphdl],["Simulation","Trial"],'Location','NorthWest','FontSize',10)

saveas(gcf,'SAMPLEFIG-example-3.pdf')
