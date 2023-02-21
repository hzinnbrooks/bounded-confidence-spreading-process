%% BC spreading processes driver
clear; close all
tic
%% Set Parameters

% Comment out parameter that you would like to loop over
%N = 2000;  % number of nodes
c = 0.2;  % receptiveness parameter
x0 = 0.5;  % message state

p = 0.2;  % rewiring probability
% k = floor(0.05*N);  % expected degree, k=5 (expected degree 10) or k=floor(0.05*N) for 100
%k = 5; 

trials = 1000;  % number of trials
%graph = "WS";
graph = "Configuration";

% Set up your loop parameters: here are the ones I've used
%loop_param = 0.1:0.1:0.9;  % what I've been using for message state
% loop_param = 0.02:0.02:0.48;  % what I've been using for c
 loop_param = 100:100:5000;  % what I've been using for N
% loop_param = 1:40;  % what I've been using for k
% loop_param = 0.02:0.02:0.98;  % what I've been using for x0

num_seeds = 1; % number of seed nodes
initialdist = "Uniform";

% file names and labels for storing data
filename = 'Poisson_c2_x5'; 
varied_label = 'Network size';

%% Initialize and simulate
tic
% Initialize storage matrices
SHARES_MAT = zeros(trials, length(loop_param));
WIDTH_MAT = zeros(trials, length(loop_param));
PATH_MAT = zeros(trials, length(loop_param));
VIRAL_MAT= zeros(trials, length(loop_param));
TREES = cell(trials, length(loop_param));
Parameters = table('Size', [length(loop_param) 7], 'VariableTypes', ...
    {'double', 'double', 'double', 'double', 'double', 'double', 'string'}, ...
    'VariableNames', {'c','x0','N','k','p','trials','graph'});

% Run simulation
for j = 1:length(loop_param)
    N = loop_param(j);  % Change this when change loop parameter
    k = ceil(N*0.0025);
    Parameters(j, :) = {c, x0, N, k, p, trials, graph};
    for i = 1:trials
        [SHARES_MAT(i, j), WIDTH_MAT(i, j), PATH_MAT(i, j), VIRAL_MAT(i, j), ~, ...
            TREES{i, j}] = fixed_message(c, x0, N, k, p, num_seeds, graph, initialdist);
    end
    % put in a little section just to track progress; can be commented out
    if mod(j, 10)==0
        disp(j)
    end
end

% edit these to save output data to your preferred file location
filepath=strcat('../Bounded-confidence-spreading-process/SimulationData/', filename);
save(filepath,'Parameters', 'SHARES_MAT', 'WIDTH_MAT', 'PATH_MAT', 'VIRAL_MAT', 'TREES')

toc
%% Stats and plots

% loop_param = loop_param*2;  % for converting WS k parameter into mean degree

% Colors
sky = [170 226 255]/256;  % #AEE2FF
teal = [50 140 140]/256;  % #328C8C
orange = [255 133 82]/256;  % #FF8552
red = [156 13 56]/256;  % #9C0D38
purple = [49 24 71]/256;  % #311847

% Compute means and standard deviations
mean_shares = mean(SHARES_MAT);
std_shares = std(SHARES_MAT);

mean_width = mean(WIDTH_MAT);
std_width = std(WIDTH_MAT);

mean_path = mean(PATH_MAT);
std_path = std(PATH_MAT);

mean_v = mean(VIRAL_MAT);
std_v = std(VIRAL_MAT);

% Make figure
figure(1)
%title = strcat('Watts--Strogatz graph with N=', num2str(N), ', k=', num2str(k));
%sgtitle(title, 'FontSize', 24, 'FontName', 'Times New Roman')
set(gcf, 'Position', [273 124 927 638])
x = [loop_param, fliplr(loop_param)];

subplot(2, 2, 1)
curve1 = mean_shares + std_shares;
curve2 = mean_shares - std_shares;
inBetween = [curve1, fliplr(curve2)];
h = fill(x, inBetween, teal);
set(h,'facealpha',.15)
hold on;
plot(loop_param, mean_shares, 'Color', teal, 'LineWidth', 3);
xlabel(varied_label)
ylabel('Total number of shares')
set(gca, 'FontSize', 20, 'FontName', 'Times New Roman')

subplot(2, 2, 2)
curve1 = mean_width + std_width;
curve2 = mean_width - std_width;
inBetween = [curve1, fliplr(curve2)];
h = fill(x, inBetween, orange);
set(h,'facealpha',.15)
hold on;
plot(loop_param, mean_width, 'Color', orange, 'LineWidth', 3);
xlabel(varied_label)
ylabel('Width')
set(gca, 'FontSize', 20, 'FontName', 'Times New Roman')

subplot(2, 2, 3)
curve1 = mean_path + std_path;
curve2 = mean_path - std_path;
inBetween = [curve1, fliplr(curve2)];
h = fill(x, inBetween, red);
set(h,'facealpha',.15)
hold on;
plot(loop_param, mean_path, 'Color', red, 'LineWidth', 3);
xlabel(varied_label)
ylabel('Longest path')
set(gca, 'FontSize', 20, 'FontName', 'Times New Roman')

subplot(2, 2, 4)
curve1 = mean_v + std_v;
curve2 = mean_v - std_v;
inBetween = [curve1, fliplr(curve2)];
h = fill(x, inBetween, purple);
set(h,'facealpha',.15)
hold on;
plot(loop_param, mean_v, 'Color', purple, 'LineWidth', 3);
xlabel(varied_label)
ylabel('Structural virality')
set(gca, 'FontSize', 20, 'FontName', 'Times New Roman')

savefig(strcat(filepath,'_fig.fig'))

toc