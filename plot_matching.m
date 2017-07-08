function plot_matching(algName, I1, I2, P1, P2, X, seq, GT, show_input, filename)

addpath('export_fig-master');

fig = figure;
set(fig, 'visible','off'); 
title(algName);
imgInput = appendimages(I1, I2);
imgInput = double(imgInput) ./ 255;
iptsetpref('ImshowBorder','tight');

% draw false matches
feat1 = P1;
feat2 = P2;
feat2(:, 1) = feat2(:, 1) + size(I1, 2);

if show_input
    subplot(2, 1, 1);
    imshow(imgInput); hold on;
    plot(feat1(:, 1), feat1(:, 2), 'yo', 'MarkerSize', 4, 'MarkerFaceColor', 'y');
    plot(feat2(:, 1), feat2(:, 2), 'yo', 'MarkerSize', 4, 'MarkerFaceColor', 'y');
    subplot(2, 1, 2);
    imshow(imgInput); hold on;
else
    imshow(imgInput); hold on;
end

for i = 1:size(X, 2)
    if seq(i) ~= GT(i)
        col1 = 'r';
        col2 = 'r';
    else
        continue;
    end
    plot([ feat1(i,1), feat2(seq(i),1) ], [ feat1(i,2), feat2(seq(i),2) ],...
        '-','LineWidth', 2, 'MarkerSize', 10, 'color', col1);
end
% draw true matches
for i = 1:size(X, 2)
    if seq(i) == GT(i)
        col1 = 'y';
        col2 = 'y';
    else
        continue;
    end
    plot([ feat1(i,1), feat2(seq(i),1) ], [ feat1(i,2), feat2(seq(i),2) ],...
        '-','LineWidth',4,'MarkerSize', 10, 'color', 'k');
    plot([ feat1(i,1), feat2(seq(i),1) ], [ feat1(i,2), feat2(seq(i),2) ],...
        '-','LineWidth',3,'MarkerSize', 10, 'color', col1);
end

box on;
set(gcf, 'color', 'w');
export_fig(filename, '-eps', '-painters', '-native');

hold off
