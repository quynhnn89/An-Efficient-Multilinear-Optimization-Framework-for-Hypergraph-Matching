function showInput(I1, I2, P1, P2, filename)

addpath('export_fig-master');

fig = figure; 
set(fig, 'visible','off');
imgInput = appendimages(I1, I2);
imgInput = double(imgInput) ./ 255;
imshow(imgInput); hold on;
iptsetpref('ImshowBorder','tight');

feat1 = P1;
feat2 = P2;
feat2(:, 1) = feat2(:, 1) + size(I1, 2);
nP1 = size(P1, 1);
nP2 = size(P2, 1);

plot(feat1(:, 1), feat1(:, 2), 'yo', 'MarkerSize', 10, 'MarkerFaceColor', 'y');
plot(feat2(1:nP1, 1), feat2(1:nP1, 2), 'yo', 'MarkerSize', 10, 'MarkerFaceColor', 'y');
if nP1+1 <= nP2
    plot(feat2(nP1+1:nP2, 1), feat2(nP1+1:nP2, 2), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
end

box on;
set(gcf, 'color', 'w');
export_fig(filename, '-eps', '-painters', '-native');

hold off;
