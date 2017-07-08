% %%%%%%%%%%%%%%%%% HOUSE %%%%%%%%%%%%%%%%%%%%%%%
% clear all;
% fs = {
%     'res_house_10vs30.mat',...
%     'res_house_20vs30.mat',...
%     'res_house_30vs30.mat'
%     };
% load(fs{1});
% nAlg = length(Alg);
% T = sum(Counter(1, :));
% acc = zeros(nAlg, T*3);
% score = zeros(nAlg, T*3);
% baselines = 10:10:100;
% B = length(baselines);
% N = 111;
% counter = 0;
% for i = 1:length(fs)
%     clear Accuracy MatchScore Time;
%     load(fs{i});
%     for b = B:-1:1
%         baseline = baselines(b);
%         for u = 1:N-baseline
%             v = Accuracy(:, b, u);
%             counter = counter + 1;
%             acc(:, counter) = v(:);
%             v = MatchScore(:, b, u);
%             score(:, counter) = v(:);
%         end
%     end
% end
%
% pairs = [8 11; 8 12; 8 13; 9 14; 10 15];
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     figure;
%     plot(score(i, :), score(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(score(i, :)), max(score(j, :)));
%     plot([1 a], [1 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('CMU House');
%
%     if 0
%     figure;
%     plot(acc(i, :), acc(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(acc(i, :)), max(acc(j, :)));
%     plot([0 a], [0 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('CMU House');
%     end
% end
%
% %%%%%%%%%%%%%%%%% SYNTHETIC %%%%%%%%%%%%%%%%%%%%%%%
% clear all;
% fs = {
%     'def_20inlier',...
%     'def_30inlier',...
%     'def_40inlier',...
%     'out_000def',...
%     'out_001def',...
%     'out_001def_11scale',...
%     'out_001def_101scale',...
%     'out_003def_15scale',...
%     'out_000def_20inlier',...
%     'out_001def_20inlier',...
%     'out_001def_11scale_20inlier',...
%     'out_001def_101scale_20inlier',...
%     'out_003def_15scale_20inlier',...
%     'out_01def_20inlier',...
%     'out_02def_20inlier',...
%     };
% T = 0;
% for k = 1:length(fs)
%     clear Accuracy;
%     clear MatchScore;
%     clear Time;
%     clear Alg;
%     load (fs{k});
%     nAlg = length(Alg);
%     T = T + size(Accuracy, 1) * size(Accuracy, 3);
% end
%
% acc = zeros(nAlg, T);
% score = zeros(nAlg, T);
% t = 0;
% for k = 1:length(fs)
%     clear Accuracy;
%     clear MatchScore;
%     clear Time;
%     clear Alg;
%     load (fs{k});
%     nAlg = length(Alg);
%     for i = 1:nAlg
%         a = Accuracy(:, i, :);
%         acc(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
%         a = MatchScore(:, i, :);
%         score(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
%     end
%     t = t + size(Accuracy, 1) * size(Accuracy, 3);
% end
%
% pairs = [8 11; 8 12; 8 13; 9 14; 10 15];
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     figure;
%     plot(score(i, :), score(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(score(i, :)), max(score(j, :)));
%     plot([0 a], [0 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('Synthetic Data');
%
%     if 0
%     figure;
%     plot(acc(i, :), acc(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(acc(i, :)), max(acc(j, :)));
%     plot([0 a], [0 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('Synthetic Data');
%     end
% end
%
% %%%%%%%%%%%%%%%%% CAR AND MOTORBIKE %%%%%%%%%%%%%%%%%%%%%%%
% clear all;
% fs = {'res_car', 'res_motor'};
% T = 0;
% for k = 1:length(fs)
%     clear Accuracy;
%     clear MatchScore;
%     clear Time;
%     clear Alg;
%     load (fs{k});
%     nAlg = length(Alg);
%     T = T + size(Accuracy, 1) * size(Accuracy, 3);
% end
%
% acc = zeros(nAlg, T);
% score = zeros(nAlg, T);
% t = 0;
% for k = 1:length(fs)
%     clear Accuracy;
%     clear MatchScore;
%     clear Time;
%     clear Alg;
%     load (fs{k});
%     nAlg = length(Alg);
%     for i = 1:nAlg
%         a = Accuracy(:, i, :);
%         acc(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
%         a = MatchScore(:, i, :);
%         score(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
%     end
%     t = t + size(Accuracy, 1) * size(Accuracy, 3);
% end
%
% pairs = [8 11; 8 12; 8 13; 9 14; 10 15];
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     figure;
%     plot(score(i, :), score(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(score(i, :)), max(score(j, :)));
%     plot([0 a], [0 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('Car-Motorbike');
%
%     if 0
%     figure;
%     plot(acc(i, :), acc(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(acc(i, :)), max(acc(j, :)));
%     plot([0 a], [0 a], 'k');
%     xlabel(Alg(i).strName);
%     ylabel(Alg(j).strName);
%     title('Car-Motorbike');
%     end
% end

%%%%%%%%%%%%%%%%% WILLOW OBJECT CLASSES %%%%%%%%%%%%%%%%%%%%%%%
clear all;
classes = {'face', 'duck', 'winebottle'};
for cl = 1:numel(classes)
    className = classes{cl};
    fs = dir(['./res_', className, '_0_0_0.mat']);
    T = 0;
    for k = 1:length(fs)
        clear Accuracy;
        clear MatchScore;
        clear Time;
        clear Alg;
        load (fs(k).name);
        nAlg = length(Alg);
        T = T + size(Accuracy, 2) * size(Accuracy, 3);
    end
    
    acc = zeros(nAlg, T);
    score = zeros(nAlg, T);
    t = 0;
    for k = 1:length(fs)
        clear Accuracy;
        clear MatchScore;
        clear Time;
        clear Alg;
        load (fs(k).name);
        nAlg = length(Alg);
        for i = 1:nAlg
            a = Accuracy(i, :, :);
            acc(i, t+1:t+size(Accuracy, 2)*size(Accuracy, 3)) = a(:);
            a = MatchScore(i, :, :);
            score(i, t+1:t+size(Accuracy, 2)*size(Accuracy, 3)) = a(:);
        end
        t = t + size(Accuracy, 1) * size(Accuracy, 3);
    end
    
    plotSet.lineWidth = 3;
    plotSet.markerSize = 10;
    plotSet.fontSize = 22;
    plotSet.font = '\fontname{Arial}';
    
    pairs = [8 11; 9 14; 10 15];
    pairs = [11 14; 12 15; 13 16];
    for k = 1:size(pairs, 1)
        i = pairs(k, 1);
        j = pairs(k, 2);
        figure;
        
        addpath('export_fig-master');
        hold on;
        set(gca, 'fontSize', plotSet.fontSize*0.8);
        
        plot(score(i, :), score(j, :), 'ro', 'markerSize', 3);
        hold on;
        a = max(max(score(i, :)), max(score(j, :)));
        plot([0 a], [0 a], 'k');
        %     xlabel(Alg(i).strName);
        %     ylabel(Alg(j).strName);
        %     title('Willow Object Classes');
        
        axis tight;
        xlabel([plotSet.font Alg(i).strName], 'FontSize', plotSet.fontSize);
        ylabel([plotSet.font Alg(j).strName], 'FontSize', plotSet.fontSize);
        filename = [className, '_', Alg(i).strName, '_', Alg(j).strName];
        T = get(gca,'tightinset');
        set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
        hold off;
        set(gcf, 'color', 'w');
        export_fig(filename, '-eps', '-painters', '-native');
    end
end

%%%%%%%%%%%%%%%%% RANDOM DATA %%%%%%%%%%%%%%%%%%%%%%%
% clear all;
% load res_random.mat;
% 
% pairs = [11 5; 14 5; 11 14];
% 
% plotSet.lineWidth = 3;
% plotSet.markerSize = 10;
% plotSet.fontSize = 28;
% plotSet.font = '\fontname{Arial}';
% 
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     figure;
%     
%     addpath('export_fig-master');
%     hold on;
%     set(gca, 'fontSize', plotSet.fontSize*0.8);
%     
%     plot(MatchScore(i, :), MatchScore(j, :), 'ro', 'markerSize', 3);
%     hold on;
%     a = max(max(MatchScore(i, :)), max(MatchScore(j, :)));
%     plot([0 a], [0 a], 'k');
%     %     title('Random Data');
%     
%     axis tight;
%     xlabel([plotSet.font Alg(i).strName], 'FontSize', plotSet.fontSize);
%     ylabel([plotSet.font Alg(j).strName], 'FontSize', plotSet.fontSize);
%     filename = ['random_', Alg(i).strName, '_', Alg(j).strName];
%     T = get(gca,'tightinset');
%     set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
%     hold off;
%     set(gcf, 'color', 'w');
%     export_fig(filename, '-eps', '-painters', '-native');
% end
