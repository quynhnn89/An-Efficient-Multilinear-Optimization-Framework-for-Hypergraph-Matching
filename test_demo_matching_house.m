function test_demo_matching_house(nInlier, b, u, bFullTensor)

addpath('export_fig-master');

setPath;
setAlg;
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

baseline = baselines(b);

% create tensor
I1 = imread(['data/cmum/house/images/house.seq', num2str(u), '.png']);
I2 = imread(['data/cmum/house/images/house.seq', num2str(u+baseline), '.png']);

P1 = houses{u}; P1 = P1(:, 1:nInlier); 
P2 = houses{u + baseline};

showInput(I1, I2, P1', P2', ['b', num2str(b), '_', 'u', num2str(u), '_', 'input']); 

problem = createTensor(1, P1, P2, [], [], 0, bFullTensor);
problem_2nd = makeMatchingProblem_2nd(problem, 1500);

P1 = problem.P1;
P2 = problem.P2;

for j = 1:length(Alg)
    Counter(j, b) = Counter(j, b) + 1;
    
    if strcmpi(Alg(j).strName, 'BCAGM')
        tic;
        X0 = repmat(problem.X0(:), 4, 1);
        [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM')
        tic;
        X0 = repmat(problem.X0(:), 4, 1);
        [X, objs, nIter] = bcagm(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
        Time(j, b, u) = toc;
        
    elseif strcmpi(Alg(j).strName, 'BCAGM+MP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 0);
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+MP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 1, 1);
        Time(j, b, u) = toc;
        
    elseif strcmpi(Alg(j).strName, 'BCAGM+IPFP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 0);
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM+IPFP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm_quad(Alg(j), problem, X0, 2, 1);
        Time(j, b, u) = toc;
        
        
    elseif strcmpi(Alg(j).strName, 'BCAGM3')
        tic;
        X0 = repmat(problem.X0(:), 3, 1);
        [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 0); % 0-Standard, 123-Adapt
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3')
        tic;
        X0 = repmat(problem.X0(:), 3, 1);
        [X, objs, nIter] = bcagm3(Alg(j), problem, X0, 50, 1); % 0-Standard, 123-Adapt
        Time(j, b, u) = toc;
        
        
    elseif strcmpi(Alg(j).strName, 'BCAGM3+MP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 0);
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+MP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 1, 1);
        Time(j, b, u) = toc;
        
        
    elseif strcmpi(Alg(j).strName, 'BCAGM3+IPFP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 0);
        Time(j, b, u) = toc;
    elseif strcmpi(Alg(j).strName, 'Adapt-BCAGM3+IPFP')
        tic;
        X0 = repmat(problem.X0(:), 2, 1);
        [X, objs, nIter] = bcagm3_quad(Alg(j), problem, X0, 2, 1);
        Time(j, b, u) = toc;
        
        
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
    
    filename = ['b', num2str(b), '_', 'u', num2str(u), '_', Alg(j).strName, '_acc', num2str(Accuracy(j, b, u)), '_score', num2str(MatchScore(j, b, u))];
    plot_matching(Alg(j).strName, I1, I2, P1', P2', Xbin, ind, problem.trueMatch, 0, filename);
end

for j = 1:length(Alg)
    disp([Alg(j).strName, ':    ', num2str(Accuracy(j, b, u)), '    ', num2str(MatchScore(j, b, u)), '    ', num2str(Time(j, b, u))]);
end
fprintf('=============================\n');

