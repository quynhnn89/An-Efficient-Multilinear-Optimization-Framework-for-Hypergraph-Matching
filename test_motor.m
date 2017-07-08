%
% % Test algorithms on Car-Motor Dataset
% % created by:   Quynh   (27.10.2014)
%
function test_motor(test, show_legend)

if test
    setPath; setAlg;
    
    [pairs, maxBaseline] = loadMotors(20);
    maxBaseline = min(15, maxBaseline);
    nOuts = 0:1:maxBaseline;
    B = length(nOuts);
    N = length(pairs);
    Accuracy = zeros(B, length(Alg), N);
    MatchScore = zeros(B, length(Alg), N);
    Time = zeros(B, length(Alg), N);
    
    Scores = {};
    for j = 1:length(Alg); Scores{j} = []; end
    
    for b = 1:1:B
        disp(['nOutlier: ', num2str(nOuts(b))]);
        
        for i = 1:N
            nPoint = pairs{i}.N;
            P1 = pairs{i}.P1(:, 1:nPoint + nOuts(b));
            P2 = pairs{i}.P2(:, 1:nPoint);
            A = P1; P1 = P2; P2 = A;
            
            problem = createTensor(1, P1, P2);
            problem_2nd = makeMatchingProblem_2nd(problem, 2500);
            
            for j = 1:length(Alg)
                if strcmpi(Alg(j).strName, 'BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM')
                    tic;
                    X0 = repmat(problem.X0(:), 4, 1);
                    [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 0);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 1); 
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 0);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 1);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3')
                    tic;
                    X0 = repmat(problem.X0(:), 3, 1);
                    [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 0);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+MP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 1);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 0);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+IPFP')
                    tic;
                    X0 = repmat(problem.X0(:), 2, 1);
                    [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 1);
                    Time(b, j, i) = toc;
                    Scores{j} = [Scores{j}; objs(1:9)];
                    
                    
                elseif strcmpi(Alg(j).strName, 'IPFP') || strcmpi(Alg(j).strName, 'MPM')
                    tic;
                    [X] = wrapper_GM(Alg(j), problem_2nd);
                    X = reshape(X, problem_2nd.nP1, problem_2nd.nP2);
                    X = X';
                    Time(b, j, i) = toc;
                else % previous third order methods
                    tic;
                    X = feval(Alg(j).fhandle, Alg(j), problem);
                    Time(b, j, i) = toc;
                end
                
                X = asgHun(X);
                [val ind] = max(X);
                Xbin = zeros(size(X));
                for p = 1:size(X,2), Xbin(ind(p),p) = 1; end
                Accuracy(b, j, i) = (sum(ind == problem.trueMatch)) / problem.nP1;
                MatchScore(b, j, i) = getMatchScore(problem.indH3, problem.valH3, Xbin);
            end
            
            for j = 1:length(Alg)
                disp([Alg(j).strName, ':    ', num2str(Accuracy(b, j, i)), '    ', num2str(MatchScore(b, j, i)), '    ', num2str(Time(b, j, i))]);
            end
            fprintf('=============================\n');
        end
    end
    
    % save result
    save('res_motor.mat', 'Accuracy', 'MatchScore', 'Time', 'Alg', 'Scores');
end

setPath;
load('res_motor.mat');

meanAcc = mean(Accuracy, 3)';
meanScore = mean(MatchScore, 3)';
meanTime = mean(Time, 3)';

id = [4 5 6 11 14];
Alg = Alg(id);
meanAcc = meanAcc(id, :);
meanScore = meanScore(id, :);
meanTime = meanTime(id, :);

[pairs, maxBaseline] = loadMotors(20);
maxBaseline = min(15, maxBaseline);
nOuts = 0:1:maxBaseline;

plotSet.lineWidth = 3;
plotSet.markerSize = 10;
plotSet.fontSize = 20;
plotSet.font = '\fontname{Arial}';

plotSet.xLabelText = '# Outliers';

xData = nOuts;
yData = meanAcc; plotSet.yLabelText = 'Accuracy'; Ymin = 0; Ymax = 1; filename = ['motor_acc', num2str(show_legend)]; plotResults_House;
yData = meanScore; plotSet.yLabelText = 'Matching Score'; filename = ['motor_score', num2str(show_legend)]; plotResults_House;
yData = meanTime; plotSet.yLabelText = 'Running Time'; filename = ['motor_time', num2str(show_legend)]; plotResults_House;
end
