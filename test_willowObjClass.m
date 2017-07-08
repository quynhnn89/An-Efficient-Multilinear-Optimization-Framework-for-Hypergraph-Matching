%% Test all algorithms on Willow Object Classes
%
% Created by: Quynh Nguyen (10.08.2015)
%       @test:                  1 - evaluate algorithms and save results to .mat files,
%                               0 - read and plot the results from the saved files
%       @className:             either 'winebottle', 'duck' or 'face'
%       @bOutBothSides:         0-1 for having outliers in both sides
%       @keypointDetector:      0-SIFT, 1-MSER
%       @bOrder2:               0-1 for using 2nd order features
%       @show_legend:           0-1 for displaying the legends in figures
function test_willowObjClass(test, className, bOutBothSides, keypointDetector, bOrder2, show_legend)

cd vlfeat-0.9.14/toolbox
vl_setup;
cd ..
cd ..

nOuts = 0:1:20;
B = length(nOuts);
N = 1000;

if test
    setPath; setAlg;
    
    disp(fullfile('./data', className, '*.png'));
    imgs = dir(fullfile('./data', className, '*.png'));
    pairs = randi(numel(imgs), N, 2);
        
    Accuracy = zeros(length(Alg), B, N);
    MatchScore = zeros(length(Alg), B, N);
    Time = zeros(length(Alg), B, N);
%     Match = {};
    
    Scores = {};
    for j = 1:length(Alg); Scores{j} = []; end
    
    for b = B:-1:1
        disp(['nOutlier: ', num2str(nOuts(b))]);
        nOut = nOuts(b);
        
        for k = 1:N
            i1 = pairs(k, 1);
            i2 = pairs(k, 2);
            imgFile1 = fullfile('./data', className, imgs(i1).name);
            imgFile2 = fullfile('./data', className, imgs(i2).name);
            annoFile1 = fullfile('./data', className, [imgs(i1).name(1:end-4) '.mat']);
            annoFile2 = fullfile('./data', className, [imgs(i2).name(1:end-4) '.mat']);
            img1 = imread(imgFile1);
            img2 = imread(imgFile2);
            load(annoFile1); P1 = pts_coord;
            load(annoFile2); P2 = pts_coord;
            nIn = min(size(P1, 2), size(P2, 2))
            P1 = P1(1:2, 1:nIn);
            P2 = P2(1:2, 1:nIn);
            
            id = 1:nOut;
            
            if keypointDetector == 0
                % SIFT detector
                if size(img1, 3) > 1; I1 = rgb2gray(img1); end;
                if size(img2, 3) > 1; I2 = rgb2gray(img2); end;
                I1 = single(I1);
                I2 = single(I2);
                [keypoints_1 nodeFeat1] = vl_sift(I1, 'PeakThresh', 0.01);
                [keypoints_2 nodeFeat2] = vl_sift(I2, 'PeakThresh', 0.01);
                perm = randperm(size(keypoints_1, 2));
                keypoints_1 = double(keypoints_1(1:2, perm(id)));
                nodeFeat1 = double(nodeFeat1(:, perm(id)));
                
                perm = randperm(size(keypoints_1, 2));
                keypoints_2 = double(keypoints_2(1:2, perm(id)));
                nodeFeat2 = double(nodeFeat2(:, perm(id)));

                %         t = sqrt(diag(sift1' * sift1));
                %         sift1 = sift1 ./ repmat(t', size(sift1, 1), 1);
                %         t = sqrt(diag(sift2' * sift2));
                %         sift2 = sift2 ./ repmat(t', size(sift2, 1), 1);
                %         pureMatches = matchFeatures(sift1', sift2', 'MatchThreshold', 80);
                %         showMatchedFeatures(img1, img2, P1(:, pureMatches(:, 1))', P2(:, pureMatches(:, 2))', 'montage');
                %         title('SIFT Matching');
                
            else
                % MSER detector
                I1 = uint8(img1);
                I2 = uint8(img2);
                [R1, keypoints_1] = vl_mser(I1,'MinDiversity', 0.4, 'MaxVariation', 0.3, 'Delta',10) ;
                [R2, keypoints_2] = vl_mser(I2,'MinDiversity', 0.4, 'MaxVariation', 0.3, 'Delta',10) ;
                perm = randperm(size(keypoints_1, 2));
                keypoints_1 = keypoints_1([2 1], perm(id));
                
                perm = randperm(size(keypoints_2, 2));
                keypoints_2 = keypoints_2([2 1], perm(id));
            end
            
            if bOutBothSides
                P1 = [P1 keypoints_1];
            end
            P2 = [P2 keypoints_2];
            
            if size(P1, 2) ~= size(P2, 2); disp('WARNING: Inequal number of points'); end
            
            % display key points in both images
%             figure; imshow(img1); hold on; plot(P1(1, :), P1(2, :), '*');
%             figure; imshow(img2); hold on; plot(P2(1, :), P2(2, :), '*');
            
            problem = createTensor(1, P1, P2, [], [], bOrder2);
            problem_2nd = makeMatchingProblem_2nd(problem, 2500);
            
            for j = 1:length(Alg)
                if strcmpi(Alg(j).strName, 'BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 0);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 1); 
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 0);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 1);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 0);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 1);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 0);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 1);
                    Time(j, b, k) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'IPFP') || strcmpi(Alg(j).strName, 'MPM')
                    tic;
                    [X] = wrapper_GM(Alg(j), problem_2nd);
                    X = reshape(X, problem_2nd.nP1, problem_2nd.nP2);
                    X = X';
                    Time(j, b, k) = toc;
                    disp(Alg(j).strName);
                else % previous third order methods
                    tic;
                    X = feval(Alg(j).fhandle, Alg(j), problem);
                    Time(j, b, k) = toc;
                end
                
%                 Match{j, b, k}.raw = X;
                
                % discritize the returned solution by the Hungarian method
                X = asgHun(X);
                [val ind] = max(X);
                Xbin = zeros(size(X));
                for p = 1:size(X,2), Xbin(ind(p),p) = 1; end
                Accuracy(j, b, k) = (sum(ind(1:nIn) == problem.trueMatch(1:nIn))) / nIn;
                MatchScore(j, b, k) = getMatchScore(problem.indH3, problem.valH3, Xbin);
%                 Match{j, b, k}.X = Xbin;
                
%                 figure;
%                 showMatchedFeatures(img1, img2, problem.P1(:, 1:nIn)', problem.P2(:, ind(1:nIn))', 'montage');
%                 title(Alg(j).strName);
            end
            
            for j = 1:length(Alg)
                disp([Alg(j).strName, ':    ', num2str(Accuracy(j, b, k)), '    ', num2str(MatchScore(j, b, k)), '    ', num2str(Time(j, b, k))]);
            end
            fprintf('=============================\n');
        end
    end
    % save result
    save(['res_', className, '_', num2str(bOutBothSides), '_', num2str(keypointDetector), '_', num2str(bOrder2)], 'Accuracy', 'MatchScore', 'Time', 'Alg', 'Scores');
%     save(['res_', className, '_', num2str(bOutBothSides), '_', num2str(keypointDetector), '_', num2str(bOrder2)], 'Accuracy', 'MatchScore', 'Time', 'Alg', 'Scores', 'Match');
end

%% PLOT RESULTS
setPath;
load(['res_', className, '_', num2str(bOutBothSides), '_', num2str(keypointDetector), '_', num2str(bOrder2), '.mat']);

meanAcc = mean(Accuracy, 3);
meanScore = mean(MatchScore, 3);
meanTime = mean(Time, 3);

id = [3 4 5 6 11 12 14 15];
Alg = Alg(id);
meanAcc = meanAcc(id, :);
meanScore = meanScore(id, :);
meanTime = meanTime(id, :);

plotSet.lineWidth = 3;
plotSet.markerSize = 10;
plotSet.fontSize = 18;
plotSet.font = '\fontname{Arial}';

plotSet.xLabelText = '# Outliers';
suffix = [className, '_', num2str(bOutBothSides), '_', num2str(keypointDetector), '_', num2str(bOrder2)];
xData = nOuts;
yData = meanAcc; plotSet.yLabelText = 'Accuracy'; Ymin = 0; Ymax = 1; filename = [suffix, '_acc', num2str(show_legend)]; plotResults_House;
yData = meanScore; plotSet.yLabelText = 'Matching Score'; filename = [suffix, '_score', num2str(show_legend)]; plotResults_House;
yData = meanTime; plotSet.yLabelText = 'Running Time'; filename = [suffix, '_time', num2str(show_legend)]; plotResults_House;
