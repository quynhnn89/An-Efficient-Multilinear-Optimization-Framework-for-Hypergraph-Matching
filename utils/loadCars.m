function [pairs, maxBaseline] = loadCars(nTest)

maxBaseline = 1000;

for i = 1:nTest
    load(['data/car/pair_', num2str(i)]);
    pairs{i}.P1 = features1(:, 1:2)';
    pairs{i}.P2 = features2(:, 1:2)';
    pairs{i}.gTruth = gTruth;
    pairs{i}.N = length(gTruth);
    
    N1 = size(pairs{i}.P1, 2);
    N2 = size(pairs{i}.P1, 2);
    pairs{i}.nodeSimMatrix = zeros(N1, N2);
    for j = 1:N1
        for k = 1:N2
            pairs{i}.nodeSimMatrix(j, k) = (features1(j,9) - features1(k,9))^2;
        end
    end
    
    pairs{i}.nodeFeat1 = features1(:, 9)';
    pairs{i}.nodeFeat2 = features2(:, 9)';
    
    if gTruth ~= 1:length(gTruth) 
        disp('ERROR: Incorrect Gtruth in loadCars !!!!!!!!!!!!!!');
    end
    maxBaseline = min(maxBaseline, size(features1, 1)-length(gTruth));
%     maxBaseline = min(maxBaseline, size(features2, 1)-length(gTruth));
end
