clear all;
ID = 0;
stats_score = {};
stats_acc = {};

%%%%%%%%%%%%%%%%% HOUSE %%%%%%%%%%%%%%%%%%%%%%%
fs = {
    'res_house_10vs30.mat',...
    'res_house_20vs30.mat',...
    'res_house_30vs30.mat'
    };
load(fs{1});
nAlg = length(Alg);
T = sum(Counter(1, :));
acc = zeros(nAlg, T*3);
score = zeros(nAlg, T*3);
baselines = 10:10:100;
B = length(baselines);
N = 111;
counter = 0;
for i = 1:length(fs)
    clear Accuracy MatchScore Time; 
    load(fs{i});
    for b = B:-1:1
        baseline = baselines(b);
        for u = 1:N-baseline
            v = Accuracy(:, b, u);
            counter = counter + 1;
            acc(:, counter) = v(:);
            v = MatchScore(:, b, u);
            score(:, counter) = v(:);
        end
    end
end

pairs = [8 5; 9 6; 10 7;    14 11; 15 12; 16 13;    11 5; 12 6; 13 7;    14 8; 15 9; 16 10;    14 5; 15 6; 16 7;];
ID = ID + 1;
stats_score{ID}.dataset = fs;
stats_score{ID}.pairs = [];
stats_score{ID}.comparison = [];
stats_acc{ID}.dataset = fs;
stats_acc{ID}.pairs = [];
stats_acc{ID}.comparison = [];
disp(['house: ', num2str(sum(score(:)==0)), ' / ', num2str(numel(score))]);
for k = 1:length(pairs)
    i = pairs(k, 1);
    j = pairs(k, 2);
    stats_score{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(score(i, :) > score(j, :));
    b = sum(score(i, :) < score(j, :));
    c = sum(score(i, :) == score(j, :));
    
    id = (score(i, :) > score(j, :)) & (score(j, :) ~= 0);
    avg_a = mean((score(i, id)-score(j, id)) ./ score(j, id) * 100);
    
    id = (score(i, :) < score(j, :)) & (score(i, :) ~= 0);
    avg_b = mean((score(j, id)-score(i, id)) ./ score(i, id) * 100);
    
    id = score(i, :) == score(j, :);
    avg_c = 0;
    
    stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c avg_a avg_b avg_c];
%     for t = 1:length(Alg)
%         if min(score(t, :)) == 0
%             disp([Alg(t).strName, '   ', num2str(min(score(t, :)))]);
%             disp('==========================');
%         end
%     end
    
    stats_acc{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(acc(i, :) > acc(j, :));
    b = sum(acc(i, :) < acc(j, :));
    c = sum(acc(i, :) == acc(j, :));
    stats_acc{ID}.comparison = [stats_acc{ID}.comparison; a b c];
end

%%%%%%%%%%%%%%%%% SYNTHETIC %%%%%%%%%%%%%%%%%%%%%%%
% synthetic 10 inliers
% fs = {
%     'out_000def',...
%     'out_001def',...
%     'out_001def_11scale',...
%     'out_001def_101scale',...
%     'out_003def_15scale',...
%     };
% synthetic >= 20inliers
% fs = {
%     'def_20inlier',...
%     'def_30inlier',...
%     'def_40inlier',...
%     'out_000def_20inlier',...
%     'out_001def_20inlier',...
%     'out_001def_11scale_20inlier',...
%     'out_001def_101scale_20inlier',...
%     'out_003def_15scale_20inlier',...
%     'out_01def_20inlier',...
%     'out_02def_20inlier',...
%     };
% synthetic
fs = {
    'def_20inlier',...
    'out_001def',...
    'out_003def_15scale',...
    };
T = 0;
for k = 1:length(fs)
    clear Accuracy;
    clear MatchScore;
    clear Time;
    clear Alg;
    load (fs{k});
    nAlg = length(Alg);
    T = T + size(Accuracy, 1) * size(Accuracy, 3);
end

acc = zeros(nAlg, T);
score = zeros(nAlg, T);
t = 0;
for k = 1:length(fs)
    clear Accuracy;
    clear MatchScore;
    clear Time;
    clear Alg;
    load (fs{k});
    nAlg = length(Alg);
    for i = 1:nAlg
        a = Accuracy(:, i, :);
        acc(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
        a = MatchScore(:, i, :);
        score(i, t+1:t+size(Accuracy, 1)*size(Accuracy, 3)) = a(:);
    end
    t = t + size(Accuracy, 1) * size(Accuracy, 3);
end

pairs = [8 5; 9 6; 10 7;    14 11; 15 12; 16 13;    11 5; 12 6; 13 7;    14 8; 15 9; 16 10;    14 5; 15 6; 16 7;];
ID = ID + 1;
stats_score{ID}.dataset = fs;
stats_score{ID}.pairs = [];
stats_score{ID}.comparison = [];
stats_acc{ID}.dataset = fs;
stats_acc{ID}.pairs = [];
stats_acc{ID}.comparison = [];
disp(['synthetic: ', num2str(sum(score(:)==0)), ' / ', num2str(numel(score))]);
for k = 1:length(pairs)
    i = pairs(k, 1);
    j = pairs(k, 2);
    stats_score{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(score(i, :) > score(j, :));
    b = sum(score(i, :) < score(j, :));
    c = sum(score(i, :) == score(j, :));
    
    id = (score(i, :) > score(j, :)) & (score(j, :) ~= 0);
    avg_a = mean((score(i, id)-score(j, id)) ./ score(j, id) * 100);
    
    id = (score(i, :) < score(j, :)) & (score(i, :) ~= 0);
    avg_b = mean((score(j, id)-score(i, id)) ./ score(i, id) * 100);
    
    id = score(i, :) == score(j, :);
    avg_c = 0;
    
    stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c avg_a avg_b avg_c];
%     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c];

%     for t = 1:length(Alg)
%         if min(score(t, :)) == 0
%             disp([Alg(t).strName, '   ', num2str(min(score(t, :)))]);
%             disp('==========================');
%         end
%     end

    stats_acc{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(acc(i, :) > acc(j, :));
    b = sum(acc(i, :) < acc(j, :));
    c = sum(acc(i, :) == acc(j, :));
    stats_acc{ID}.comparison = [stats_acc{ID}.comparison; a b c];
end

%%%%%%%%%%%%%%%%% CAR AND MOTORBIKE %%%%%%%%%%%%%%%%%%%%%%%
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
% pairs = [8 5; 9 6; 10 7;    14 11; 15 12; 16 13;    11 5; 12 6; 13 7;    14 8; 15 9; 16 10; ];
% ID = ID + 1;
% stats_score{ID}.dataset = fs;
% stats_score{ID}.pairs = [];
% stats_score{ID}.comparison = [];
% stats_acc{ID}.dataset = fs;
% stats_acc{ID}.pairs = [];
% stats_acc{ID}.comparison = [];
% disp(['car-motorbike: ', num2str(sum(score(:)==0)), ' / ', num2str(numel(score))]);
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     stats_score{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
%     a = sum(score(i, :) > score(j, :));
%     b = sum(score(i, :) < score(j, :));
%     c = sum(score(i, :) == score(j, :));
%     
%     id = score(i, :) > score(j, :) & score(j, :) ~= 0;
%     avg_a = mean((score(i, id)-score(j, id)) ./ score(j, id) * 100);
%     
%     id = score(i, :) < score(j, :) & score(i, :) ~= 0;
%     avg_b = mean((score(j, id)-score(i, id)) ./ score(i, id) * 100);
%     
%     id = score(i, :) == score(j, :);
%     avg_c = 0;
%     
%     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c avg_a avg_b avg_c];
% %     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c];
%     
%     stats_acc{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
%     a = sum(acc(i, :) > acc(j, :));
%     b = sum(acc(i, :) < acc(j, :));
%     c = sum(acc(i, :) == acc(j, :));
%     stats_acc{ID}.comparison = [stats_acc{ID}.comparison; a b c];
% end

%%%%%%%%%%%%%%%%% WILLOW OBJECT CLASS %%%%%%%%%%%%%%%%%%%%%%%
% fs = {'res_winebottle_0_0_0', 'res_face_0_0_0', 'res_duck_0_0_0'};
fs = dir('./res_*_0_0_0*.mat');
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

pairs = [8 5; 9 6; 10 7;    14 11; 15 12; 16 13;    11 5; 12 6; 13 7;    14 8; 15 9; 16 10;    14 5; 15 6; 16 7;];
ID = ID + 1;
stats_score{ID}.dataset = fs;
stats_score{ID}.pairs = [];
stats_score{ID}.comparison = [];
stats_acc{ID}.dataset = fs;
stats_acc{ID}.pairs = [];
stats_acc{ID}.comparison = [];
disp(['willow: ', num2str(sum(score(:)==0)), ' / ', num2str(numel(score))]);
for k = 1:length(pairs)
    i = pairs(k, 1);
    j = pairs(k, 2);
    stats_score{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(score(i, :) > score(j, :));
    b = sum(score(i, :) < score(j, :));
    c = sum(score(i, :) == score(j, :));
    
    id = score(i, :) > score(j, :) & score(j, :) ~= 0;
    avg_a = mean((score(i, id)-score(j, id)) ./ score(j, id) * 100);
    
    id = score(i, :) < score(j, :) & score(i, :) ~= 0;
    avg_b = mean((score(j, id)-score(i, id)) ./ score(i, id) * 100);
    
    id = score(i, :) == score(j, :);
    avg_c = 0;
    
    stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c avg_a avg_b avg_c];
%     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c];
    
    stats_acc{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
    a = sum(acc(i, :) > acc(j, :));
    b = sum(acc(i, :) < acc(j, :));
    c = sum(acc(i, :) == acc(j, :));
    stats_acc{ID}.comparison = [stats_acc{ID}.comparison; a b c];
end

%%%%%%%%%%%%%%%%% RANDOM DATA %%%%%%%%%%%%%%%%%%%%%%%
% fs = {'res_random.mat'};
% load(fs{1});
% score = MatchScore;
% 
% pairs = [6 3; 7 4; 8 5;    12 9; 13 10; 14 11;    9 3; 10 4; 11 5;    12 6; 13 7; 14 8; ];
% ID = ID + 1;
% stats_score{ID}.dataset = fs;
% stats_score{ID}.pairs = [];
% stats_score{ID}.comparison = [];
% stats_acc{ID}.dataset = fs;
% stats_acc{ID}.pairs = [];
% stats_acc{ID}.comparison = [];
% disp(['random: ', num2str(sum(score(:)==0)), ' / ', num2str(numel(score))]);
% for k = 1:length(pairs)
%     i = pairs(k, 1);
%     j = pairs(k, 2);
%     stats_score{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
%     a = sum(score(i, :) > score(j, :));
%     b = sum(score(i, :) < score(j, :));
%     c = sum(score(i, :) == score(j, :));
%     
%     id = score(i, :) > score(j, :) & score(j, :) ~= 0;
%     avg_a = mean((score(i, id)-score(j, id)) ./ score(j, id) * 100);
%     
%     id = score(i, :) < score(j, :) & score(i, :) ~= 0;
%     avg_b = mean((score(j, id)-score(i, id)) ./ score(i, id) * 100);
%     
%     id = score(i, :) == score(j, :);
%     avg_c = 0;
%     
%     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c avg_a avg_b avg_c];
% %     stats_score{ID}.comparison = [stats_score{ID}.comparison; a b c];
%     
%     stats_acc{ID}.pairs{k} = [Alg(i).strName, ' vs. ', Alg(j).strName];
%     a = sum(Accuracy(i, :) > Accuracy(j, :));
%     b = sum(Accuracy(i, :) < Accuracy(j, :));
%     c = sum(Accuracy(i, :) == Accuracy(j, :));
%     stats_acc{ID}.comparison = [stats_acc{ID}.comparison; a b c];
% end
