%====================================================================%
%                       SPOT Animation Example #1
% 
% This script shows a basic example on animating experiment data. 
% This data is from MPC validation (see, e.g., 2025 AAS/AIAA Space 
% Flight Mechanics Meeting).
% 
% Author: Courtney Savytska
% Date: September 2024
%====================================================================%

clear all
clc

%===================%
%   LOADING A FILE
%===================%
SAVE_DIRECTORY = 'Example Saved Data/';
EXP_DIRECTORY = "ExperimentData_RED_2024_4_24_16_51_3_2777";
DATA_MATNAME = strcat(EXP_DIRECTORY,"_2");

FILEPATH = strcat(SAVE_DIRECTORY,EXP_DIRECTORY,'/',DATA_MATNAME);
load(FILEPATH)

%===================%
%   LOADING DATA
%===================%
% If plotting simulation data, then data is stored in 'dataClass' variable 
% and the below line may be uncommented.
% dataClass_rt = dataClass;
expdata_time = dataClass_rt.Time_s;

[time,inds,~] = unique(expdata_time);

% User can specify the index at which the data starts. For example, start 
% at 44 s, corresponding to index 3420. Although not written in this scipt, 
% the user can also specify the index at which the data ends.
DATA_STARTTIME = 3420;          

unique_time = time(DATA_STARTTIME:end);
unique_inds = inds(DATA_STARTTIME:end);

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
stepsize = 40; % This controls how many frames of data are plotted

fig = figure();
set(gcf,'color','w')

counter = 1;
for frame = 1 : stepsize : length(unique_time)

    % Plotting trajectory
    exphdl = plot(expdata_RED_pos_x(1:frame),expdata_RED_pos_y(1:frame), 'r-','Linewidth',1,'DisplayName','Trial');
    hold on
    plot(expdata_BLACK_pos_x(1:frame),expdata_BLACK_pos_y(1:frame), 'k-','Linewidth',1)
    plot(expdata_BLUE_pos_x(1:frame),expdata_BLUE_pos_y(1:frame), 'b-','Linewidth',1)
    
    % Plotting spacecraft shapes
    spacecraft = DrawSpacecraft([expdata_RED_pos_x(frame),expdata_RED_pos_y(frame),expdata_RED_pos_th(frame),1]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1,'Linewidth',0.5)

    spacecraft = DrawSpacecraft([expdata_BLACK_pos_x(frame),expdata_BLACK_pos_y(frame),expdata_BLACK_pos_th(frame),4]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'k', 'edgealpha',1,'Linewidth',0.5)

    spacecraft = DrawSpacecraft([expdata_BLUE_pos_x(frame),expdata_BLUE_pos_y(frame),expdata_BLUE_pos_th(frame),3]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'b', 'edgealpha',1,'Linewidth',0.5)

    xlabel('X-Position [m]')
    ylabel('Y-Position [m]')
    grid on
    box on
    axis equal;
    ax = gca;
    ax.FontSize = 10;
    ax.FontName = "Times New Roman";  
    
    xlim([0 3.5])
    ylim([0 2.4])

    % Save the current figure as a "frame" for the animation
    movieVector(counter) = getframe(gcf) ;
    counter = counter + 1;

    clf
end


%===================%
%     ANIMATING
%===================%

% Compile the figures from previous into an animation and save
myWriter = VideoWriter('SAMPLEANIMATION-example-1', 'MPEG-4');
myWriter.FrameRate = 10;
open(myWriter);
for i=1:length(movieVector)
    frame = movieVector(i) ;    
    writeVideo(myWriter, frame);
end
close(myWriter);


