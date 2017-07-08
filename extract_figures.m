fs = {'def_20inlier', 'out_003def_15scale'};

for i = 1:length(fs)
    test_synthetic(1, fs{i}, 1); % run some synthetic experiments and plot results with legends
    % test_synthetic(0, fs{i}, 1); % plot the saved results with legends
    % test_synthetic(0, fs{i}, 0); % plot the saved results without legends
end

for i = 10:10:30
    test_house(1, i, 1);
end

test_car(1, 1);
test_motor(1, 1);
