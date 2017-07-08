clear all;
clc;
% algoId = [5 6 7 8 9 10 11 14 15]; % ours
algos = [3 4 5 6 11 12 14 15]; % ours_others
bLogScale = 1;
show_legend = 1;

for dataset = 2:2
    if dataset == 1
        fs = {
%             'def_20inlier',...
            'out_001def',...
            'out_003def_15scale',...
            };
        id = [1 3 5 7 9 11 13 15 17 19 21];
        xData = (id-1)*10;
        res = zeros(numel(algos), numel(xData));
        for i = 1:length(fs)
            load(fs{i});
            meanTime = mean(Time, 3)';
            res = res + meanTime(algos, id);
        end
        
        plotSet.xLabelText = '# Outliers';
        filename = ['runtime_synthetic_', num2str(bLogScale), '_', num2str(show_legend)];
    elseif dataset == 2 % house
        fs = {
            'res_house_10vs30',...
            'res_house_20vs30',...
            'res_house_30vs30'
            };
        xData = 10:10:100;
        res = zeros(numel(algos), numel(xData));
        for i = 1:length(fs)
            load(fs{i});
            meanTime = mean(Time, 3);
            meanTime = meanTime ./ Counter;
            res = res + meanTime(algos, 1:numel(xData));
        end
        
        plotSet.xLabelText = 'Baseline';
        filename = ['runtime_house_', num2str(bLogScale), '_', num2str(show_legend)];
    elseif dataset == 3 % willow
        id = [1 6 11 16];
        xData = id-1;
        res = zeros(numel(algos), numel(xData));
        fs = {
            'res_winebottle_0_0_0',...
            'res_duck_0_0_0',...
            'res_face_0_0_0'
            };
        for i = 1:length(fs)
            load(fs{i});
            meanTime = mean(Time, 3);
            res = res + meanTime(algos, id);
        end
%         fs = {
%             'res_car', 'res_motor'
%             };
%         for i = 1:length(fs)
%             load(fs{i});
%             meanTime = mean(Time, 3)';
%             res = res + meanTime(algos, id);
%         end
        
        plotSet.xLabelText = '# Outliers';
        filename = ['runtime_willow_', num2str(bLogScale), '_', num2str(show_legend)];
    end
    
    %=============================================
    Alg = Alg(algos);
    
    plotSet.lineWidth = 3;
    plotSet.markerSize = 10;
    plotSet.fontSize = 28;
    plotSet.font = '\fontname{Arial}';
    
    if bLogScale
        yData = log10(res);
        plotSet.yLabelText = 'Seconds (log10)';
    else
        yData = res;
        plotSet.yLabelText = 'Seconds';
    end
    
    addpath('export_fig-master');
    
    hFig = figure;
    hold on;
    
    set(gca, 'fontSize', plotSet.fontSize*0.8);
    
    for k = 1:length(Alg)
        plot(xData, yData(k, :), ...
            'LineWidth', plotSet.lineWidth, ...
            'Color', Alg(k).color, ...
            'LineStyle', Alg(k).lineStyle, ...
            'Marker', Alg(k).marker, ...
            'MarkerSize', plotSet.markerSize);
    end
    if ~exist('Xmin', 'var') || ~exist('Xmax', 'var')
        Xmin = min(xData(:));
        Xmax = max(xData(:));
    end
    if ~exist('Ymin', 'var') || ~exist('Ymax', 'var')
        Ymin = min(yData(:));
        Ymax = max(yData(:));
    end
    axis tight;
    axis([Xmin Xmax Ymin-0.02*(Ymax-Ymin) Ymax+0.02*(Ymax-Ymin)]);
    xlabel([plotSet.font plotSet.xLabelText], 'FontSize', plotSet.fontSize);
    ylabel([plotSet.font plotSet.yLabelText], 'FontSize', plotSet.fontSize);
    
    T = get(gca,'tightinset');
    set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
    
    if show_legend
        hLegend = legend(Alg(:).strName);
%         if dataset == 1
%             set(hLegend, 'Location', 'southwest', 'fontSize', 16);
%         else
            set(hLegend, 'Location', 'best', 'fontSize', 16);
            legend('boxoff');
%         end
    end
    
    hold off;
    
    % legend('boxoff');
    set(gcf, 'color', 'w');
    export_fig(filename, '-eps', '-painters', '-native');
    
%     clear Xmin Xmax Ymin Ymax k yData yLabelText hLegend
end
