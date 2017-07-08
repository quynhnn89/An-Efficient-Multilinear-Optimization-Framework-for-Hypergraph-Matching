%% Test all algorithms on random point sets

function test_random(test, show_legend)

%% RE-EVALUATION
if test
    setPath;
    setAlg;
    Alg = Alg(3:end); % do not test 2nd order methods
    houses = loadHouses();
    
    T = 10000;
    
    MatchScore = zeros(length(Alg), T);
    Time = zeros(length(Alg), T);
    
    Scores = {};
    for j = 1:length(Alg); Scores{j} = []; end
    
    for t = 1:T
        problem = createRandomTensor();
        [N2, N1] = size(problem.X0);
        
        for j = 1:length(Alg)
            if strcmpi(Alg(j).strName, 'BCAGM')
                tic;
                X0 = repmat(problem.X0(:), 4, 1);
                [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM')
                tic;
                X0 = repmat(problem.X0(:), 4, 1);
                [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
            elseif strcmpi(Alg(j).strName, 'BCAGM+MP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 0);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+MP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 1);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
            elseif strcmpi(Alg(j).strName, 'BCAGM+IPFP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 0);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+IPFP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 1);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
                
            elseif strcmpi(Alg(j).strName, 'BCAGM3')
                tic;
                X0 = repmat(problem.X0(:), 3, 1);
                [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3')
                tic;
                X0 = repmat(problem.X0(:), 3, 1);
                [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
                
            elseif strcmpi(Alg(j).strName, 'BCAGM3+MP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 0);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+MP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 1);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
                
            elseif strcmpi(Alg(j).strName, 'BCAGM3+IPFP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 0);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
            elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+IPFP')
                tic;
                X0 = repmat(problem.X0(:), 2, 1);
                [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 1);
                Time(j, t) = toc;
                Scores{j} = [Scores{j}; objs(1:9)];
                
                
            else % previous third order methods
                tic;
                X = feval(Alg(j).fhandle, Alg(j), problem);
                Time(j, t) = toc;
            end
            % discritize the returned solution by the Hungarian method
            X = asgHun(X);
            [val ind] = max(X);
            Xbin = zeros(size(X));
            for p = 1:size(X,2), Xbin(ind(p), p) = 1; end
            MatchScore(j, t) = getMatchScore(problem.indH3, problem.valH3, Xbin);
        end
        
        for j = 1:length(Alg)
            disp([Alg(j).strName, ':    ', num2str(MatchScore(j, t)), '    ', num2str(Time(j, t))]);
        end
        fprintf('=============================\n');
    end
    % save result
    save(['res_random'], 'MatchScore', 'Time', 'Alg', 'Scores');
end

%% PLOT RESULTS
load('res_random');

plotSet.lineWidth = 3;
plotSet.markerSize = 10;
plotSet.fontSize = 20;
% plotSet.font = '\fontname{times new roman}';
plotSet.font = '\fontname{Arial}';

plotSet.xLabelText = 'Baseline';

plotSet.yLabelText = 'Matching Score'; filename = ['res_random_', num2str(show_legend)];
xData = baselines; yData = meanScore; plotResults_House;

plotSet.yLabelText = 'Running Time'; filename = ['res_random_', num2str(show_legend)];
xData = baselines; yData = meanTime; plotResults_House;
