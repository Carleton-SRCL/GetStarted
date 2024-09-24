%====================================================================%
%          SPOT Plotting Functions Example #1
% 
% This script shows a basic example on using the provided plotting
% functions to plot experiment data. This data is from MPC validation
% (see, e.g., 2025 AAS/AIAA Space Flight Mechanics Meeting).
% 
% Author: Courtney Savytska
% Date: September 2024
%====================================================================%

clear all
clc

% Adding parent directory to the path, which contains the plotting functions
parentDirectory = fileparts(cd);
addpath(parentDirectory)  

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
figure()

% User can specify indices to show snapshots of the platforms. Typically, 
% these would be the initial and final conditions, but can also include 
% intermediate snapshots
plotting_indices = [1, 5800]; 
alpha_values     = [0.2 1];    % transparency for each snapshot; must be same length as 'plotting_indices'

% Plotting trajectory
exphdl = plot(expdata_RED_pos_x(1:plotting_indices(end)),expdata_RED_pos_y(1:plotting_indices(end)), 'r','Linewidth',1,'DisplayName','Trial');
hold on
plot(expdata_BLACK_pos_x(1:plotting_indices(end)),expdata_BLACK_pos_y(1:plotting_indices(end)), 'k','Linewidth',1)
plot(expdata_BLUE_pos_x(1:plotting_indices(end)),expdata_BLUE_pos_y(1:plotting_indices(end)), 'b','Linewidth',1)

% Plotting spacecraft shapes
for ii = 1:length(plotting_indices)
    frame = plotting_indices(ii);
    alpha = alpha_values(ii);

    spacecraft = DrawSpacecraft([expdata_RED_pos_x(frame),expdata_RED_pos_y(frame),expdata_RED_pos_th(frame),1]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',alpha,'Linewidth',0.5)

    spacecraft = DrawSpacecraft([expdata_BLACK_pos_x(frame),expdata_BLACK_pos_y(frame),expdata_BLACK_pos_th(frame),4]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'k', 'edgealpha',alpha,'Linewidth',0.5)

    spacecraft = DrawSpacecraft([expdata_BLUE_pos_x(frame),expdata_BLUE_pos_y(frame),expdata_BLUE_pos_th(frame),3]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'b', 'edgealpha',alpha,'Linewidth',0.5)
end

xlabel('X-Position [m]')
ylabel('Y-Position [m]')
grid on
box on
axis equal
xlim([0 3.5])
ylim([0 2.4])
ax = gca();
ax.FontSize = 10;
ax.FontName = "Times New Roman";

legend([exphdl], 'Location', 'NorthWest')
saveas(gcf,'SAMPLEFIG-example-1.pdf')


