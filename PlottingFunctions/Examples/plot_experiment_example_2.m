%====================================================================%
%          SPOT Plotting Functions Example #2
% 
% This script shows a basic example on using the provided plotting
% functions to plot experiment data using the arm. This data is from
% the combined experiment (see, e.g., 2025 AAS/AIAA Space Flight 
% Mechanics Meeting).
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
load('Example Saved Data/SuccessfulExperimentResults_Jan14_2024.mat')

%===================%
%   LOADING DATA
%===================%
start = 600;
fin = length(dataClass_rt.Time_s);

t = dataClass_rt.Time_s(start:fin);

% PhaseSpace data of BLACK
PSx = dataClass_rt.BLACK_Px_m(start:fin);
PSy = dataClass_rt.BLACK_Py_m(start:fin);
PSyaw = dataClass_rt.BLACK_Rz_rad(start:fin);

% PhaseSpace data of RED
rPSx = dataClass_rt.RED_Px_m(start:fin);
rPSy = dataClass_rt.RED_Py_m(start:fin);
rPSyaw = dataClass_rt.RED_Rz_rad(start:fin);

% ARM data
ARMq1 = dataClass_rt.ARM_Shoulder_Rz_rad(start:fin);
ARMq2 = dataClass_rt.ARM_Elbow_Rz_rad(start:fin);
ARMq3 = dataClass_rt.ARM_Wrist_Rz_rad(start:fin);

%===================%
%        PLOT
%===================%
fig = figure();

% User can specify indices to show snapshots of the platforms. Typically, 
% these would be the initial and final conditions, but can also include 
% intermediate snapshots as is shown here to display the deployment of the
% manipulator.
indices = [1,1800,3200,3700,4200];
alphas = [0.2, 0.5, 0.7, 1,1]; % transparency for each snapshot; must be same length as 'indices'

% Plotting trajectory
plot(PSx,PSy,'k:','LineWidth',1)
hold on
plot(rPSx,rPSy,'r:','LineWidth',1)

% Plotting spacecraft shapes
for ij = 1:length(indices)
    ind = indices(ij);
    alp = alphas(ij);
    
    spacecraft = DrawSpacecraft([rPSx(ind),rPSy(ind),rPSyaw(ind),5]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', alp/2, 'edgecolor', 'r', 'edgealpha',alp)
    
    [shoulder,elbow,wrist] = DrawARM([rPSx(ind),rPSy(ind),rPSyaw(ind),ARMq1(ind),ARMq2(ind),ARMq3(ind)]);
    patch(shoulder(:,1), shoulder(:,2), 'w', 'facealpha', alp, 'edgecolor', 'r', 'edgealpha',alp)
    patch(elbow(:,1), elbow(:,2), 'w', 'facealpha', alp, 'edgecolor', 'r', 'edgealpha',alp)
    patch(wrist(:,1), wrist(:,2), 'w', 'facealpha', alp, 'edgecolor', 'r', 'edgealpha',alp)

    spacecraft = DrawSpacecraft([PSx(ind),PSy(ind),PSyaw(ind),2]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', alp/2, 'edgecolor', 'k', 'edgealpha',alp)

end

% Create textbox
annotation(fig,'textbox',...
    [0.705166666666666 0.180952380952381 0.195428571428571 0.0825396825396831],...
    'String',{'Phase 0:','Initial Position'},...
    'HorizontalAlignment','center',...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor','none', ...
    'FontSize',9);

% Create textbox
annotation(fig,'textbox',...
    [0.10397619047619 0.542857142857147 0.195428571428571 0.0825396825396832],...
    'String',{'Phase 2:','Optimal','Manipulator','Deployment'},...
    'HorizontalAlignment','center',...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor','none', ...
    'FontSize',9);

% Create textbox
annotation(fig,'textbox',...
    [0.17088095238095 0.180952380952381 0.32757142857143 0.0825396825396838],...
    'String',{'Phase 3:','Capture and Retraction'},...
    'HorizontalAlignment','center',...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor','none', ...
    'FontSize',9);

% Create textbox
annotation(fig,'textbox',...
    [0.677785714285713 0.776190476190479 0.244238095238096 0.0825396825396831],...
    'String',{'Phase 1:','Deep Learning','Pose Determination','and Pose Tracking'},...
    'HorizontalAlignment','center',...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor','none', ...
    'FontSize',9);

xlabel('X-Position [m]')
ylabel('Y-Position [m]')
fontname(fig,"Times New Roman");
grid on
axis equal;

xlim([0 3.5])
ylim([0 2.4])

saveas(gcf,'SAMPLEFIG-example-2.pdf')


