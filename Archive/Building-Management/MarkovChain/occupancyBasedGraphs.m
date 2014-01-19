% This script is used to 1) parse log files, find occupancy 2) interpret
% occupancy into graphs

clc
close all
filenames = {[pwd '\data\k-files\k1.txt'],...
             [pwd '\data\k-files\k2.txt'],...
             [pwd '\data\k-files\k3_new.txt'],...
             [pwd '\data\k-files\k4_new.txt'],...
             [pwd '\data\k-files\k5_new.txt'],...
             [pwd '\data\k-files\k6_new.txt'],...
             [pwd '\data\k-files\k7_new.txt'],...
             [pwd '\data\k-files\k8_new.txt']};
         
numSensors = size(filenames, 2);

outputfolder = [pwd '\outputPNGs']; % Define an output folder to export graphs
mkdir(outputfolder)

zones = {'zone1', 'lobby', 'zone2', 'zone3', 'zone4'};
%% While the latest graphs are shown in the figures, graphs for all days are stored in the output folder

%% 1 - A day's IN, OUT graph: Occupancy vs time slot
h = figure('Visible', 'off');
scrsz = get(0,'ScreenSize');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\in_out_graphs';
mkdir(outputfolder, folder)
for i = 1:size(filenames,2)
    dataStruct{i} = ParseLogFiles(filenames{i});
    for j = 1:size(dataStruct{i},2)
        iDay = dataStruct{i}{j};
        if i == size(filenames,2) & j == size(dataStruct{i},2) % chking if last plot?
            set(h, 'Visible', 'on')
        end
        plot(1:48, iDay.infinal, 'r', 1:48, iDay.outfinal, 'b')
        title(['People crossing sensor No.' num2str(i) ' at different time slots'])
        xlabel('time slots (half hr)')
        ylabel('Number of people')
        legend('IN', 'OUT')
%         saveas(h,[outputfolder folder '\in_out_' strrep(cell2mat(iDay.date), '/', '-'),'.jpg'])
        orig_mode = get(h, 'PaperPositionMode');
        set(h, 'PaperPositionMode', 'auto');
        cdata = hardcopy(h, '-DOpenGL', '-r0');
        imwrite(cdata, [outputfolder folder '\in_out_' strrep(cell2mat(iDay.date), '/', '-'),'.png'])
    end
end

%% 2 - Compute the INs and OUTs of occupancy of each zone over time and plot
% them
h = figure('Visible', 'off');
scrsz = get(0,'ScreenSize');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\zones_graphs';
mkdir(outputfolder, folder)

% Find common dates among all logs and create array of in, out from these
% common dates part of the dataStruct.

common = containers.Map; % Key value pairs like python's dictionary
for i = 1:numSensors
    for j = 1:size(dataStruct{i},2)
        idate = cell2mat(dataStruct{i}{j}.date);
        if common.isKey(idate)
            common(idate) = common(idate) + 1;
        else
            common(idate) = 1;
        end
    end
end
% find the dates that all sensor has logged
dateIdx = cell2mat(common.values) == numSensors;
dates = common.keys;
commondates = dates(dateIdx);

% Calculate occupancy from in, out data
occupancy = containers.Map;
for d = 1:size(commondates, 2)
    sensor = {};
    for i = 1:numSensors
        for j = 1:size(dataStruct{i},2)
            if strcmp(dataStruct{i}{j}.date{1}, commondates{d})
                sensor{i} = dataStruct{i}{j};
                break;
            end
        end
    end
    % Occupancy formulas used
    %   zone1 = k1_in + k2_out - k2_in
    %   lobby = k2_in - k2_out + k3_out - k3_in + k6_out - k6_in
    %   zone2 = k3_in - k3_out + k4_in - k4_out
    %   zone3 = k6_in - k6_out + k5_in - k5_out
    %   zone4 = k8_in - k8_out + k7_out - k7_in
    
    occ = [sensor{1}.infinal' + sensor{2}.outfinal' - sensor{2}.infinal',...
                sensor{2}.infinal' - sensor{2}.outfinal' + sensor{3}.outfinal' - sensor{3}.infinal' + sensor{6}.outfinal' - sensor{6}.infinal',...
                sensor{3}.infinal' - sensor{3}.outfinal' + sensor{4}.infinal' - sensor{4}.outfinal',...
                sensor{6}.infinal' - sensor{6}.outfinal' + sensor{5}.infinal' - sensor{5}.outfinal',...
                sensor{8}.infinal' - sensor{8}.outfinal' + sensor{7}.outfinal' - sensor{7}.infinal'];
    occ_in = [sensor{1}.infinal' - sensor{2}.infinal',...
                sensor{2}.infinal'- sensor{3}.infinal' - sensor{6}.infinal',...
                sensor{3}.infinal' + sensor{4}.infinal',...
                sensor{6}.infinal' + sensor{5}.infinal',...
                sensor{8}.infinal' - sensor{7}.infinal'];
    occ_out = [sensor{2}.outfinal',...
               sensor{2}.outfinal' + sensor{3}.outfinal' + sensor{6}.outfinal',...
               sensor{3}.outfinal' - sensor{4}.outfinal',...
               sensor{6}.outfinal' - sensor{5}.outfinal',...
               sensor{8}.outfinal' + sensor{7}.outfinal'];
    occ(occ < 0) = 0; occ_in(occ_in < 0) = 0; occ_out(occ_out < 0) = 0;
    occupancy(cell2mat(commondates(d))) = occ;
    occupancy([cell2mat(commondates(d)) '_in']) = occ_in;
    occupancy([cell2mat(commondates(d)) '_out']) = occ_out;
end

% plots
for d = 1:size(commondates, 2)
    if d == size(commondates, 2)% chking if last plot?
        set(h, 'Visible', 'on')
    end
    occ_in = occupancy([cell2mat(commondates(d)) '_in']);
    occ_out = occupancy([cell2mat(commondates(d)) '_out']);
    subplot(2,3,1)    
    plot(1:48, occ_in(:,1), 'r',...
         1:48, occ_out(:,1), 'b')
    title(['Students in/out of ' zones{1} ' on ' commondates{d}])
    xlabel('time slots')
    ylabel('Number of people')
    legend('In', 'Out')
    
    subplot(2,3,2)    
    plot(1:48, occ_in(:,2), 'r',...
         1:48, occ_out(:,2), 'b')
    title(['Students in/out of ' zones{2} ' on ' commondates{d}])
    xlabel('time slots')
    ylabel('Number of people')
    legend('In', 'Out')
    
    subplot(2,3,3)    
    plot(1:48, occ_in(:,3), 'r',...
         1:48, occ_out(:,3), 'b')
    title(['Students in/out of ' zones{3} ' on ' commondates{d}])
    xlabel('time slots')
    ylabel('Number of people')
    legend('In', 'Out')
    
    subplot(2,3,4)    
    plot(1:48, occ_in(:,4), 'r',...
         1:48, occ_out(:,4), 'b')
    title(['Students in/out of ' zones{4} ' on ' commondates{d}])
    xlabel('time slots')
    ylabel('Number of people')
    legend('In', 'Out')
    
    subplot(2,3,5)    
    plot(1:48, occ_in(:,5), 'r',...
         1:48, occ_out(:,5), 'b')
    title(['Students in/out of ' zones{5} ' on ' commondates{d}])
    xlabel('time slots')
    ylabel('Number of people')
    
    legend('In', 'Out')
%     saveas(h,[outputfolder folder '\zones_in_out_' strrep(commondates{d}, '/', '-'),'.png'])
    orig_mode = get(h, 'PaperPositionMode');
    set(h, 'PaperPositionMode', 'auto');
    cdata = hardcopy(h, '-DOpenGL', '-r0');
    imwrite(cdata, [outputfolder folder '\zones_in_out_' strrep(commondates{d}, '/', '-'),'.png'])
end

h = figure('Visible', 'off');
scrsz = get(0,'ScreenSize');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\in_out_stems';
mkdir(outputfolder, folder)

% plots
for d = 1:size(commondates, 2)
    cnt = 1;
    occ_in = occupancy([cell2mat(commondates(d)) '_in']);
    occ_out = occupancy([cell2mat(commondates(d)) '_out']);
    for i = 1:5
        if d == size(commondates, 2)% chking if last plot?
            set(h, 'Visible', 'on')
        end
        subplot(2,3,i)
        y = [occ_in(:,i), occ_out(:,i)];
        s = stem(1:48, y);
        set(s(1), 'Marker','^','MarkerEdgeColor','red')
        set(s(2), 'Marker','v','MarkerEdgeColor','blue')
        title(['Students in/out of ' zones{i} ' on ' commondates{d}])
        xlabel('time slots (half hr)')
        ylabel('Number of people')
        legend('IN', 'OUT')
        cnt = cnt+1;
        if (i > 1 | j > 1) & mod(cnt,6) == 0
            cnt = 1;
%             saveas(h,[outputfolder folder '\in_out_stem_' strrep(commondates{d}, '/', '-'),'.png'])
            orig_mode = get(h, 'PaperPositionMode');
            set(h, 'PaperPositionMode', 'auto');
            cdata = hardcopy(h, '-DOpenGL', '-r0');
            imwrite(cdata, [outputfolder folder '\in_out_stem_' strrep(commondates{d}, '/', '-'),'.png'])
        end
    end
end
        
%% 3 - Auto Correlation of occupancy data
h = figure('Visible', 'off');
scrsz = get(0,'ScreenSize');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\zones_corr';
mkdir(outputfolder, folder)

for d = 1:size(commondates, 2)
    if d == size(commondates, 2)% chking if last plot?
        set(h, 'Visible', 'on')
    end
    subplot(2,3,1)
    plot(-size(occ(:,1),1)+1:size(occ(:,1),1)-1,xcorr(occ(:,1),'coeff'));
    xlabel('phase difference (in samples)')
    ylabel('Correlation coefficient')
    ylim([0 1])
%     xlim([-size(occ(:,1),1)-1, size(occ(:,1),1)-1])
    title(['Auto correlation of occupancy of ' zones{1} ' on ' commondates{d}])
    
    subplot(2,3,2)
    plot(-size(occ(:,2),1)+1:size(occ(:,2),1)-1,xcorr(occ(:,2),'coeff'));
    xlabel('phase difference (in samples)')
    ylabel('Correlation coefficient')
    ylim([0 1])
%     xlim([-size(occ(:,2),1)-1, size(occ(:,2),1)-1])
    title(['Auto correlation of occupancy of ' zones{2} ' on ' commondates{d}])
    
    subplot(2,3,3)
    plot(-size(occ(:,3),1)+1:size(occ(:,3),1)-1,xcorr(occ(:,3),'coeff'));
    xlabel('phase difference (in samples)')
    ylabel('Correlation coefficient')
    ylim([0 1])
%     xlim([-size(occ(:,3),1)-1, size(occ(:,3),1)-1])
    title(['Auto correlation of occupancy of ' zones{3} ' on ' commondates{d}])
    
    subplot(2,3,4)
    plot(-size(occ(:,4),1)+1:size(occ(:,4),1)-1,xcorr(occ(:,4),'coeff'));
    xlabel('phase difference (in samples)')
    ylabel('Correlation coefficient')
    ylim([0 1])
%     xlim([-size(occ(:,4),1)-1, size(occ(:,4),1)-1])
    title(['Auto correlation of occupancy of ' zones{4} ' on ' commondates{d}])
    
    subplot(2,3,5)
    plot(-size(occ(:,5),1)+1:size(occ(:,5),1)-1, xcorr(occ(:,5),'coeff'));
    xlabel('phase difference (in samples)')
    ylabel('Correlation coefficient')
    ylim([0 1])
%     xlim([-size(occ(:,5),1)-1, size(occ(:,5),1)-1])
    title(['Auto correlation of occupancy of ' zones{5} ' on ' commondates{d}])
    
%     saveas(h,[outputfolder folder '\zones_auto_corr_' strrep(commondates{d}, '/', '-'),'.png'])
    orig_mode = get(h, 'PaperPositionMode');
    set(h, 'PaperPositionMode', 'auto');
    cdata = hardcopy(h, '-DOpenGL', '-r0');
    imwrite(cdata, [outputfolder folder '\zones_auto_corr_' strrep(commondates{d}, '/', '-'),'.png'])
end

%% 4 - Cross Correlation of occupancy data of different zones
h = figure('Visible', 'off');
scrsz = get(0,'ScreenSize');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\zones_cross_corr';
mkdir(outputfolder, folder)

for d = 1:size(commondates, 2)
    cnt = 1;
    figcnt = 1;
    for i = 1:5
        for j = 1:5
            if i ~= j
                if d == size(commondates, 2)% chking if last plot?
                    set(h, 'Visible', 'on') % plotting only the last plot
                end
                subplot(2,2,figcnt)
                y = xcorr(occ(:,i), occ(:,j),'coeff');
                plot(-size(occ(:,i))+1 : size(occ(:,i))-1, y);
                xlabel('phase difference (in samples)')
                ylabel('Correlation coefficient1')
                ylim([0 1])
    %             xlim([-size(occ(:,i))-1, size(occ(:,i))-1])
                title(['Cross correlation of occupancy of ' zones{i} ' with ' zones{j} ' on ' commondates{d}])
                figcnt = figcnt+1;
                if (i > 1 | j > 1) & mod(cnt,6) == 0
                    cnt = 1;
    %                 saveas(h,[outputfolder folder '\zones_cross_corr_' zones{i} '_with_others_' strrep(commondates{d}, '/', '-'),'.png'])
                    orig_mode = get(h, 'PaperPositionMode');
                    set(h, 'PaperPositionMode', 'auto');
                    cdata = hardcopy(h, '-DOpenGL', '-r0');
                    imwrite(cdata, [outputfolder folder '\zones_cross_corr_' zones{i} '_with_others_' strrep(commondates{d}, '/', '-'),'.png'])
                end
            end
            cnt = cnt+1;
        end
        figcnt = 1;
    end
end

%% 5 - Occupancy graphs (one week) (not IN/OUT), Histograms
h = figure('Visible', 'on');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\occupancy_daily_histograms';
mkdir(outputfolder, folder)
startdate =  '13/10/2013'; % Format: dd/mm/yyyy
enddate = '19/10/2013';
startidx = find(strcmp(commondates, startdate));
endidx = find(strcmp(commondates, enddate));

if isempty(startidx) | isempty(endidx)
    error('Start date or end date not present');
end

Y = [];
for d = startidx:endidx
    Y = [Y; sum(occupancy(cell2mat(commondates(d))))]; % finding the net occupancy of a zone on a particular day
end
X = commondates(startidx:endidx);

bar(Y)
colormap summer % Change the color scheme
set(gca(),'XTickLabel',X)
legend(zones)
ylabel('Net occupancy of the zone')
xlabel('Date')
title('Comparison of occupancies of different zones')
orig_mode = get(h, 'PaperPositionMode');
set(h, 'PaperPositionMode', 'auto');
cdata = hardcopy(h, '-DOpenGL', '-r0');
imwrite(cdata, [outputfolder folder '\daily_histogram', '.png'])

%% 6 - Occupancy graphs (three week), Histograms
h = figure('Visible', 'on');
set(h,'Position', [scrsz(1) scrsz(2) scrsz(3) scrsz(4)]);cla;
folder = '\occupancy_weekly_histograms';
mkdir(outputfolder, folder)
startdate =  '10/10/2013'; % Format: dd/mm/yyyy
enddate = '28/10/2013';
startidx = find(strcmp(commondates, startdate));
endidx = find(strcmp(commondates, enddate));

if isempty(startidx) | isempty(endidx) % checks for the error of wrong date input
    error('Start date or end date not present');
end

Y = [];
for d = startidx:endidx
    Y = [Y; sum(occupancy(cell2mat(commondates(d))))]; % finding the net occupancy of a zone on a particular day
end
Z = [];
X = {};
if size(Y,1) > 7 % computing weeks occupancy of diff zones
    for i = 1:ceil(size(Y,1)/7)
        if i < ceil(size(Y,1)/7)
            Z = [Z; sum(Y((i-1)*7 + 1:i*7,:))];
        else
            Z = [Z; sum(Y((i-1)*7 + 1:end,:))];
        end
        X{end+1} = ['week-', num2str(i)];
    end
else
    Z = sum(Y);
end

bar(Z)
colormap summer % Change the color scheme
set(gca(),'XTickLabel',X)
legend(zones)
ylabel('Net occupancy of the zone')
xlabel('Date')
title('Comparison of occupancies of different zones')
orig_mode = get(h, 'PaperPositionMode');
set(h, 'PaperPositionMode', 'auto');
cdata = hardcopy(h, '-DOpenGL', '-r0');
imwrite(cdata, [outputfolder folder '\weekly_histogram', '.png']);


%% Comment
% For the occupancy calculation, I really doubt some
% equations... Anyway, we have to (or will try our best to work
% this paper out.)