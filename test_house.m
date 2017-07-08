
%% Test all algorithms on the CMU House Dataset
%
% Created by: Quynh Nguyen (17.10.2014)
%       @test:          1 - evaluate algorithms and save results to .mat files,
%                       0 - read and plot the results from the saved output
%                       files (.mat)
%       @N1:            number of points in the first image. The smaller value of N1 means there are more outliers in the second image.
%       @show_legend:   0-1 option for displaying the legends in all the figures
% Example of Usage:
%       test_house(1, 10, 1): evaluate all algorithms on matching tasks where there are 10 points (N1=10) in the first image,
%                             and save results to output file.
%       test_house(0, 10, 1): read the saved output file corresponding to N1 = 10 and plot the results
function test_house(test, N1, show_legend, bFullTensor)

%% RE-EVALUATION
if test
    setPath; setAlg;
    houses = loadHouses();
    
    % baselines
    baselines = 10:10:100;
    B = length(baselines);
    % the number of images
    N = 111;
    
    Accuracy = zeros(length(Alg), B, N);
    MatchScore = zeros(length(Alg), B, N);
    Time = zeros(length(Alg), B, N);
    Counter = zeros(length(Alg), B);
    
    Scores = {};
    for j = 1:length(Alg); Scores{j} = []; end
    
    for b = B:-1:1
        baseline = baselines(b);
        
        for u = 1:N-baseline
            P1 = houses{u};
            P1 = P1(:, 1:N1); % take the first N1 points only
            P2 = houses{u + baseline};
            problem = createTensor(1, P1, P2, [], [], 0, bFullTensor);
            problem_2nd = makeMatchingProblem_2nd(problem, 2500);
            
            for j = 1:length(Alg)
                Counter(j, b) = Counter(j, b) + 1;
                
                if strcmpi(Alg(j).strName, 'BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 0);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 1); 
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 0);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 1);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 0);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 1);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 0);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 1);
                    Time(j, b, u) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'IPFP') || strcmpi(Alg(j).strName, 'MPM')
                    tic;
                    [X] = wrapper_GM(Alg(j), problem_2nd);
                    X = reshape(X, problem_2nd.nP1, problem_2nd.nP2);
                    X = X';
                    Time(j, b, u) = toc;
                    disp(Alg(j).strName);
                else % previous third order methods
                    tic;
                    X = feval(Alg(j).fhandle, Alg(j), problem);
                    Time(j, b, u) = toc;
                end
                % discritize the returned solution by the Hungarian method
                X = asgHun(X);
                [val ind] = max(X);
                Xbin = zeros(size(X));
                for p = 1:size(X,2), Xbin(ind(p),p) = 1; end
                Accuracy(j, b, u) = (sum(ind == problem.trueMatch)) / problem.nP1;
                MatchScore(j, b, u) = getMatchScore(problem.indH3, problem.valH3, Xbin);
            end
            
            for j = 1:length(Alg)
                disp([Alg(j).strName, ':    ', num2str(Accuracy(j, b, u)), '    ', num2str(MatchScore(j, b, u)), '    ', num2str(Time(j, b, u))]);
            end
            fprintf('=============================\n');
        end
    end
    % save result
    save(['res_house_', num2str(N1), 'vs30_', num2str(bFullTensor), '.mat'], 'Accuracy', 'MatchScore', 'Time', 'Counter', 'Alg', 'Scores');
end

%% PLOT RESULTS
setPath;
load(['res_house_', num2str(N1), 'vs30_', num2str(bFullTensor), '.mat']);

baselines = 10:10:100;
meanAcc = squeeze(sum(Accuracy, 3));
meanAcc = meanAcc ./ Counter;

meanScore = squeeze(sum(MatchScore, 3));
meanScore = meanScore ./ Counter;

meanTime = squeeze(sum(Time, 3));
meanTime = meanTime ./ Counter;

id = [1 2 3 4 5 6 7 14 15 16];
Alg = Alg(id);
meanAcc = meanAcc(id, :);
meanScore = meanScore(id, :);
meanTime = meanTime(id, :);

plotSet.lineWidth = 3;
plotSet.markerSize = 10;
plotSet.fontSize = 20;
% plotSet.font = '\fontname{times new roman}';
plotSet.font = '\fontname{Arial}';

plotSet.xLabelText = 'Baseline';

plotSet.yLabelText = 'Accuracy'; Ymin = 0; Ymax = 1; filename = [num2str(N1), 'vs30_acc', num2str(show_legend), '_', num2str(bFullTensor)];
xData = baselines; yData = meanAcc; plotResults_House;

plotSet.yLabelText = 'Matching Score'; filename = [num2str(N1), 'vs30_score', num2str(show_legend), '_', num2str(bFullTensor)];
xData = baselines; yData = meanScore; plotResults_House;

plotSet.yLabelText = 'Running Time'; filename = [num2str(N1), 'vs30_time', num2str(show_legend), '_', num2str(bFullTensor)];
xData = baselines; yData = meanTime; plotResults_House;
