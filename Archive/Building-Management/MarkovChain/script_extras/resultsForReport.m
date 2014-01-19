% script to plot figures for results to be present in the report
% First - Occupancy vs time plots
clc
clear all
close all
% Read all the data of each zones:
backdoor =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\backdoor_out.txt');
elevator =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\elevator_out.txt');
entlab2 =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\entlab2_out.txt');
entlab4 =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\entlab4_out.txt');
halldisk =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\halldisk_out.txt');
hallwind =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\hallwind_out.txt');
lobby =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\lobby_out.txt');
maindoor =LoadInOutData('E:\Markov Chain - Ahmed\data\OUT\maindoor_out.txt');

% Compute occupancy
zone1 = [];
lobbyOcc = [];
zone2 = [];
zone3 = [];
zone4 = [];
for i = 1:6
    zone1 = [zone1; maindoor{i}.values(:,1) + lobby{i}.values(:,2) - lobby{i}.values(:,1)];
    lobbyOcc = [lobbyOcc; lobby{i}.values(:,1) - lobby{i}.values(:,2) + halldisk{i}.values(:,2) - halldisk{i}.values(:,1)...
        + entlab2{i}.values(:,2) - entlab2{i}.values(:,1)];
    zone2 = [zone2; entlab2{i}.values(:,1) - entlab2{i}.values(:,2) + elevator{i}.values(:,1) - elevator{i}.values(:,2)];
    zone3 = [zone3; halldisk{i}.values(:,2) - halldisk{i}.values(:,1)];
    zone4 = [zone4; backdoor{i}.values(:,1) - backdoor{i}.values(:,2) + entlab2{i}.values(:,1) - entlab2{i}.values(:,2)];
end
zone1(zone1 < 0) = 0;
zone2(zone2 < 0) = 0;
zone3(zone3 < 0) = 0;
zone4(zone4 < 0) = 0;
lobbyOcc(lobbyOcc < 0) = 0;
% Plot all occupancy data
figure
subplot(5,1,1)
stairs(1:size(zone1,1), zone1)
title('Zone1')
ylabel('occupancy')
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})

subplot(5,1,2)
stairs(1:size(zone1,1), lobbyOcc)
title('lobby')
ylabel('occupancy')
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})

subplot(5,1,3)
stairs(1:size(zone1,1), zone2)
title('Zone2')
ylabel('occupancy')
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})

subplot(5,1,4)
stairs(1:size(zone1,1), zone3)
title('Zone3')
ylabel('occupancy')
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})

subplot(5,1,5)
stairs(1:size(zone1,1), zone4)
title('Zone4')
ylabel('occupancy')
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})

% Drawing states
traindata = [zone1, lobbyOcc, zone2, zone3, zone4];
thresVec = [0, 4, 7];
states = StatesFromData(traindata, thresVec);
transitionmatrix = LearnTransition(states);

presentstates = StateNumber(states(1:end-1,:));
[~, futurestates] = max(transitionmatrix(presentstates,:),[],2);
futurestatesMat = StateMatrix(futurestates);
% Plot states
figure
subplot(5,1,1)
stairs(1:size(states,1), states(:,1),'b')
hold on
stairs(1:size(states,1), [1; futurestatesMat(:,1)],'r');
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})
% set(gca, 'YTickLabel', {'E','F','A','C'})
ylim([1,4])
title('Zone1')

subplot(5,1,2)
stairs(1:size(states,1), states(:,2),'b')
hold on
stairs(1:size(states,1), [1; futurestatesMat(:,2)],'r');
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})
set(gca, 'YTickLabel', {'E','F','A','C'})
ylim([1,4])
title('lobby')

subplot(5,1,3)
stairs(1:size(states,1), states(:,3),'b')
hold on
stairs(1:size(states,1), [1; futurestatesMat(:,3)],'r');
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})
set(gca, 'YTickLabel', {'E','F','A','C'})
ylim([1,4])
title('Zone2')

subplot(5,1,4)
stairs(1:size(states,1), states(:,4),'b')
hold on
stairs(1:size(states,1), [1; futurestatesMat(:,4)],'r');
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})
set(gca, 'YTickLabel', {'E','F','A','C'})
ylim([1,4])
title('Zone3')

subplot(5,1,5)
stairs(1:size(states,1), states(:,5),'b')
hold on
stairs(1:size(states,1), [1; futurestatesMat(:,5)],'r');
set(gca, 'XTickLabel', {'sep-30', 'oct-1','oct-2','oct-3','oct-4','oct-5','oct-6'})
set(gca, 'YTickLabel', {'E','F','A','C'})
ylim([1,4])
title('Zone4')