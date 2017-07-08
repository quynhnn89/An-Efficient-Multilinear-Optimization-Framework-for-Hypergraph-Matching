% synthetic
fs = {
    'def_20inlier',...
    'def_30inlier',...
    'def_40inlier',...
    'out_000def',...
    'out_001def',...
    'out_001def_11scale',...
    'out_001def_101scale',...
    'out_003def_15scale',...
    'out_000def_20inlier',...
    'out_001def_20inlier',...
    'out_001def_11scale_20inlier',...
    'out_001def_101scale_20inlier',...
    'out_003def_15scale_20inlier',...
    'out_01def_20inlier',...
    'out_02def_20inlier',...
    'res_car',...
    'res_car_feat123',...
    'res_motor',...
    'res_motor_feat123',...
    'res_duck_0_0_0',...
    'res_duck_0_0_1',...
    'res_duck_1_0_0',...
    'res_duck_1_0_1',...
    'res_face_0_0_0',...
    'res_face_0_0_1',...
    'res_face_1_0_0',...
    'res_face_1_0_1',...
    'res_winebottle_0_0_0',...
    'res_winebottle_0_0_1',...
    'res_winebottle_1_0_0',...
    'res_winebottle_1_0_1',...
    };
for i = 1:numel(fs)
    load(fs{i});
    for j = 1:numel(Alg)
        if strncmp(Alg(j).strName, 'Adapt1', 6)
            Alg(j).strName = strrep(Alg(j).strName, 'Adapt1', 'Adapt');
            disp(Alg(j).strName);
        end
    end
    save(fs{i}, 'Accuracy', 'MatchScore', 'Scores', 'Time', 'Alg');
end

% House
fs = {
    'res_house_10vs30',...
    'res_house_20vs30',...
    'res_house_30vs30'
    };
for i = 1:numel(fs)
    load(fs{i});
    for j = 1:numel(Alg)
        if strncmp(Alg(j).strName, 'Adapt1', 6)
            Alg(j).strName = strrep(Alg(j).strName, 'Adapt1', 'Adapt');
            disp(Alg(j).strName);
        end
    end
    save(fs{i}, 'Accuracy', 'Counter', 'MatchScore', 'Scores', 'Time', 'Alg');
end

% Random
fs = {
    'res_random'
    };
for i = 1:numel(fs)
    load(fs{i});
    for j = 1:numel(Alg)
        if strncmp(Alg(j).strName, 'Adapt1', 6)
            Alg(j).strName = strrep(Alg(j).strName, 'Adapt1', 'Adapt');
            disp(Alg(j).strName);
        end
    end
    save(fs{i}, 'MatchScore', 'Scores', 'Time', 'Alg');
end
