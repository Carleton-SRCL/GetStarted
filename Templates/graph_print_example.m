%% ===================================================================== %%
%                       PRINTING GRAPHS EXAMPLE
%  =====================================================================  %
%
% Description:
% This script gives an example of how to print graphs as a pdf for use in 
% LaTeX. The example provided uses arbitrary data; it is up to the user to 
% combine this method with their own data/figures. For details on how to 
% format your figures as desired, visit: 
%
%         https://www.mathworks.com/help/matlab/ref/subplot.html
%
%  =====================================================================  %
%% Initialization

close all
clear
clc

%% Print Settings
% The user must specify the appropriate settings for their pdf print


% print figure to pdf? 1 = yes, 0 = no
print_figs = 1;

% file name (it will be saved to the folder you are working in)
filename = 'my_plot';

% font change
set(0,'DefaultAxesFontName', 'Times New Roman') 
set(0,'DefaultAxesFontSize', 12)

% size of the figure (in inches)
width = 7;  
height = 4;

%% Generate Arbitrary Data

x1 = 0:1:100;
y1 = sin(x1*0.2);

x2 = 0:1:100;
y2 = x2;

x3 = 0:1:100;
y3 = sqrt(x3);

x4 = 0:1:100;
y4 = 1./x4;

%% Format Graphs
% This section is where the user must generate their own plots within
% MATLAB using their own data. Since the formatting for these plots is
% extensively covered in the online documentation, details on how to do
% this will not be covered here. This example generates a quad plot.


figure(1)

% top left
subplot(2,2,1)
plot(x1,y1,'r-','linewidth',1)
xlabel('Time [s]')
ylabel('Output [m]')
grid on
ylim([min(y1)*1.1 max(y1)*1.1])

% top right
subplot(2,2,2)
plot(x2,y2,'r-','linewidth',1)
xlabel('Time [s]')
ylabel('Output [m]')
grid on
ylim([min(y2)*0.9 max(y2)*1.1])

% botom left
subplot(2,2,3)
plot(x3,y3,'r-','linewidth',1)
xlabel('Time [s]')
ylabel('Output [m]')
grid on
ylim([min(y3)*0.9 max(y3)*1.1])

% bottom right
subplot(2,2,4)
plot(x4,y4,'r-','linewidth',1)
xlabel('Time [s]')
ylabel('Output [m]')
grid on
ylim([min(y4)*0.9 max(y4)*1.1])


%% Saving figure to pdf
% This is where the magic happens!

% This block of code positions and crops the "paper" that MATLAB prints the
% pdf onto to the height and width specified earlier. It would be wise not
% to alter this if you don't know what you are doing!
pos = get(gcf, 'Position');		
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); 
movegui('center');
set(gcf, 'Paperposition', [0 0 width height])	
set(gcf,'papersize',[width height])		
set(gcf,'renderer','Painters')

% This section prints the plot to a pdf to a resolution of 700 DPi.
% This can be adjusted as required
if print_figs == 1
    print(filename,'-dpdf','-r700');
end