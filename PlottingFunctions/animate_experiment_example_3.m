%====================================================================%
%                       SPOT Animation Example #3
% 
% This script shows a basic example on animating multiple trials of
% experiment data and comparing it to simulation data. This data is 
% from MPC validation (see, e.g., 2025 AAS/AIAA Space Flight Mechanics 
% Meeting).
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
%        PLOT
%===================%
stepsize = 40; % This controls how many frames of data are plotted

fig = figure();
set(gcf,'color','w')

counter = 1;
for frame = 1 : stepsize : min(DATA_ENDTIME - DATA_STARTTIME)

    %===================%
    %     LOOPING
    %===================%
    for ind = 1:length(DATA_MATNAME)

        clearvars -except SAVE_DIRECTORY EXP_DIRECTORY DATA_MATNAME DATA_STARTTIME...
            DATA_ENDTIME SIM_FILE SIM_STARTTIME SIM_ENDTIME ind frame stepsize...
            counter movieVector
    
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
        
        % Plotting spacecraft shapes        
        spacecraft = DrawSpacecraft([expdata_RED_pos_x(frame), expdata_RED_pos_y(frame), expdata_RED_pos_th(frame), 1]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1) % Plot the chaser spacecraft
        hold on
        
        spacecraft = DrawSpacecraft([expdata_BLACK_pos_x(frame), expdata_BLACK_pos_y(frame), expdata_BLACK_pos_th(frame), 4]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'k', 'edgealpha',1) % Plot the target spacecraft
          
        spacecraft = DrawSpacecraft([expdata_BLUE_pos_x(frame), expdata_BLUE_pos_y(frame), expdata_BLUE_pos_th(frame), 3]);
        patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'b', 'edgealpha',1) % Plot the obstacle spacecraft
                            
        uistack(gca().Children(1),"bottom") % moving patches below lines
        uistack(gca().Children(1),"bottom")
        uistack(gca().Children(1),"bottom")     

        % Plotting trajectory
        exphdl = plot(expdata_RED_pos_x(1:frame), expdata_RED_pos_y(1:frame), 'r-','LineWidth',0.5);
        plot(expdata_BLACK_pos_x(1:frame), expdata_BLACK_pos_y(1:frame), 'k-','LineWidth',1);
        plot(expdata_BLUE_pos_x(1:frame), expdata_BLUE_pos_y(1:frame),'b','LineWidth',1);
    end

    clearvars -except SAVE_DIRECTORY EXP_DIRECTORY DATA_MATNAME DATA_STARTTIME...
            DATA_ENDTIME SIM_FILE SIM_STARTTIME SIM_ENDTIME ind exphdl frame...
            stepsize counter movieVector
    
    %===================%
    %  LOADING SIM FILE
    %===================%
    frame = round(frame * 5 / 4); % time factor conversion between experiment and simulation time vectors
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
    expdata_RED_pos_th     = dataClass_rt.RED_Rz_rad(unique_inds);
    
    %===================%
    %        PLOT
    %===================%
    simhdl = plot(expdata_RED_pos_x(1:frame), expdata_RED_pos_y(1:frame), 'k--','LineWidth',1);
    spacecraft = DrawSpacecraft([expdata_RED_pos_x(frame), expdata_RED_pos_y(frame), expdata_RED_pos_th(frame), 1]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0., 'edgecolor', 'k', 'edgealpha',1,'linestyle','--') % Plot the chaser spacecraft
    
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

    % Save the current figure as a "frame" for the animation
    movieVector(counter) = getframe(gcf) ;
    counter = counter + 1;

    clf
end


%===================%
%     ANIMATING
%===================%

% Compile the figures from previous into an animation and save
myWriter = VideoWriter('SAMPLEANIMATION-example-3', 'MPEG-4');
myWriter.FrameRate = 10;
open(myWriter);
for i=1:length(movieVector)
    frame = movieVector(i) ;    
    writeVideo(myWriter, frame);
end
close(myWriter);
