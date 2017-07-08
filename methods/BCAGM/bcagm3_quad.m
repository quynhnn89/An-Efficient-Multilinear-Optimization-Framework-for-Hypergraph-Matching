function [X, objs, nIter] = bcagm3_quad(alg, problem, X0, subroutine, adapt)
%
% Multilinear Solver
%
if alg.bOrder(1)
    indH1 = problem.indH1;
    valH1 = problem.valH1;
else
    indH1 = [];
    valH1 = [];
end

if alg.bOrder(2)
    indH2 = problem.indH2;
    valH2 = problem.valH2;
else
    indH2 = [];
    valH2 = [];
end

if alg.bOrder(3)
    indH3 = problem.indH3;
    valH3 = problem.valH3;
else
    indH3 = [];
    valH3 = [];
end

if isempty(indH1) && isempty(valH1)
    indH1=int32(zeros(0,1));
    valH1=zeros(0,1);
end
if isempty(indH2) && isempty(valH2)
    indH2=int32(zeros(0,2));
    valH2=zeros(0,1);
end
if isempty(indH3) && isempty(valH3)
    indH3=int32(zeros(0,3));
    valH3=zeros(0,1);
end

[N2, N1] = size(problem.X0);
[X, objs, nIter] = mexBCAGM3_QUADMatching(int32(indH1'), double(valH1),...
    int32(indH2'), double(valH2),...
    int32(indH3'), double(valH3),...
    int32(N1), int32(N2), double(X0), int32(subroutine), int32(adapt));


