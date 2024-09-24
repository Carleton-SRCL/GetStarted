%====================================================================%
%                       SPOT Animation Example #2
% 
% This script shows a basic example on animating experiment data with
% the manipulator. This data is from the combined experiment (see, e.g., 
% 2025 AAS/AIAA Space Flight Mechanics Meeting).
% 
% Author: Courtney Savytska
% Date: September 2024
%====================================================================%

clear all
clc

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
stepsize = 20; % This controls how many frames of data are plotted

fig = figure();
set(gcf,'color','w')

counter = 1;
for frame = 1 : stepsize : length(t)

    % Plotting trajectory
    plot(PSx(1:frame),PSy(1:frame),'k:','LineWidth',1)
    hold on
    plot(rPSx(1:frame),rPSy(1:frame),'r:','LineWidth',1)
    
    % Plotting spacecraft shapes
    spacecraft = DrawSpacecraft([rPSx(frame),rPSy(frame),rPSyaw(frame),5]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1)
    
    [shoulder,elbow,wrist] = DrawARM([rPSx(frame),rPSy(frame),rPSyaw(frame),ARMq1(frame),ARMq2(frame),ARMq3(frame)]);
    patch(shoulder(:,1), shoulder(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1)
    patch(elbow(:,1), elbow(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1)
    patch(wrist(:,1), wrist(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'r', 'edgealpha',1)

    spacecraft = DrawSpacecraft([PSx(frame),PSy(frame),PSyaw(frame),2]);
    patch(spacecraft(:,1), spacecraft(:,2), 'w', 'facealpha', 0.5, 'edgecolor', 'k', 'edgealpha',1)

    xlabel('X-Position [m]')
    ylabel('Y-Position [m]')
    grid on
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

%%
%===================%
%     ANIMATING
%===================%

% Compile the figures from previous into an animation and save
myWriter = VideoWriter('SAMPLEANIMATION-example-2', 'MPEG-4');
myWriter.FrameRate = 10;
open(myWriter);
for i=1:length(movieVector)
    frame = movieVector(i) ;    
    writeVideo(myWriter, frame);
end
close(myWriter);


