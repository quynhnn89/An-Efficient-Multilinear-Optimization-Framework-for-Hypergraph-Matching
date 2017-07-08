function problem = createRandomTensor()

nP1 = 20+randi(10);
nP2 = nP1 + randi(20);
n = nP1 * nP2;

% random entries
T = n*n;
indH3 = randi(n-1, T, 3);
valH3 = abs(randn(T, 1));

% added by Quynh Nguyen
%remove duplicated tuples
indH3 = sort(indH3, 2);
[indH3 id1 id2] = unique(indH3, 'rows');
valH3 = valH3(id1);
%remove duplicated indices: (i,i,i), (i,i,j), (i,j,i), (i,j,j), etc
t1 = indH3(:, 1) - indH3(:, 2);
t2 = indH3(:, 1) - indH3(:, 3);
t3 = indH3(:, 2) - indH3(:, 3);
t4 = (t1 == 0) + (t2 == 0) + (t3 == 0);
indH3 = indH3(t4 == 0, :);
valH3 = valH3(t4 == 0);
% upperbound the number of nonzeros
maxL = min(5*10^5, length(valH3));
[v id] = sort(valH3, 'descend');
% id = randperm(length(valH3));
id = id(1:maxL);
valH3 = valH3(id);
indH3 = indH3(id, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Super-symmetrize the 3rd order tensor: if (i,j,k) with i#j#k is a nonzero
% entry of the tensor, then all of its six permutations should also be the entries
% NOTE that this step is important for the current implementation of our algorithms !!!
% Thus, if a tuple (i,j,k) for i#j#k is stored in 'indH3' below, then all of its
% permutations should also be stored in 'indH3' and 'valH3'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ps = perms([1 2 3]);
Nt3 = length(valH3);
valH3 = [valH3; valH3; valH3; valH3; valH3; valH3];
old_indH3 = indH3;
indH3 = [];
for i = 1:size(ps, 1)
    indH3((i-1)*Nt3+1:i*Nt3, :) = old_indH3(:, ps(i, :));
end

% sort tuples in ascending order
dim = nP1 * nP2;
uid = indH3(:, 1)*dim*dim + indH3(:, 2)*dim + indH3(:, 3);
[v id] = sort(uid);
valH3 = valH3(id);
indH3 = indH3(id, :);

%% save the matching problem
problem.nP1 = nP1;
problem.nP2 = nP2;
problem.indH1 = [];
problem.valH1 = [];
problem.indH2 = [];
problem.valH2 = [];
problem.indH3 = int32(indH3);
problem.valH3 = double(valH3);
problem.X0 = ones(nP2, nP1);

clear indH1 valH1 indH2 valH2 indH3 valH3;


