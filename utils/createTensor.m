function problem = createTensor(bPermute, P1, P2, nodeFeat1, nodeFeat2, order2, bFullTensor)
if exist('bFullTensor', 'var') && bFullTensor
    disp('Using Full Tensor!!!');
end

nP1 = size(P1, 2);
nP2 = size(P2, 2);

% permute graph sequence (prevent accidental good solution)
if bPermute, seq = randperm(nP2); problem.whole_seq = seq; P2(:,seq) = P2; seq = seq(1:nP1); else seq = 1:nP1; end

%% 3rd Order Tensor Construction
if exist('bFullTensor', 'var') && bFullTensor
    t1=combntns(1:nP1, 3)' - 1;
else
    % This part is taken from Duchenne's code
    nT = nP1*nP2; % # of triangles in graph 1
    t1=floor(rand(3,nT)*nP1);
end
while 1
    probFound=false;
    for i=1:3
        ind=(t1(i,:)==t1(1+mod(i,3),:));
        if(nnz(ind)~=0)
            t1(i,ind)=floor(rand(1,nnz(ind))*nP1);
            probFound=true;
        end
    end
    if(~probFound)
        break;
    end
end
%generate features
t1=int32(t1);
nT = size(t1, 2);

[feat1,feat2] = mexComputeFeature(P1,P2,int32(t1),'simple');

%number of nearest neighbors used for each triangle (results can be bad if too low)
if exist('bFullTensor', 'var') && bFullTensor
    nNN = size(feat2, 2);
else
    nNN = nT;
end

%find the nearest neighbors
[inds, dists] = annquery(feat2, feat1, nNN, 'eps', 0.1);

%build the tensor
[i j k]=ind2sub([nP2,nP2,nP2],inds);
tmp=repmat(1:nT,nNN,1);
indH3 = double(t1(:,tmp(:))'*nP2) + [k(:)-1 j(:)-1 i(:)-1];
valH3 = exp(-dists(:) / mean(dists(:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add 1st order features if available
if exist('nodeFeat1', 'var') && ~isempty(nodeFeat1) && exist('nodeFeat2', 'var') && ~isempty(nodeFeat2)
    disp('Adding 1st order Features');
    diffMat = zeros(nP2, nP1);
    for i = 1:nP1
        for j = 1:nP2
            diffMat(j,i) = abs(sum((nodeFeat1(:, i)-nodeFeat2(:, j)).^2));
        end
    end
    indH3 = [indH3; repmat(0:nP1*nP2-1, 3, 1)'];
    valH3 = [valH3; exp(- diffMat(:) / mean(diffMat(:)))];
    %     imagesc(diffMat);
    %     diff = diffMat(:);
    %     K = int32(nP1/1);
    %     [id, ds] = annquery(nodeFeat2, nodeFeat1, K, 'eps', 0);
    %     mask = zeros(nP2, nP1);
    %     for i = 1:nP1
    %         mask(id(:, i), i) = 1;
    %     end
    %     figure; imagesc(mask);
    %     mask = logical(mask(:));
    %     diff = diff(mask);
    %     valH3 = [valH3; exp(- diff / mean(diff))];
    %     indH3 = [indH3; repmat(find(mask==1), 1, 3)-1];
end

% add 2nd order features if available
if exist('order2', 'var') && order2
    disp('Adding 2nd order Features');
    PP1 = P1';
    PP2 = P2';
    E12 = ones(nP1,nP2);
    n12 = nnz(E12);
    [L12(:,1) L12(:,2)] = find(E12);
    [group1 group2] = make_group12(L12);
    
    E1 = ones(nP1); E2 = ones(nP2);
    [L1(:,1) L1(:,2)] = find(E1);
    [L2(:,1) L2(:,2)] = find(E2);
    G1 = PP1(L1(:,1),:)-PP1(L1(:,2),:);
    G2 = PP2(L2(:,1),:)-PP2(L2(:,2),:);
    
    if 0
        G1_x = reshape(G1(:,1), [nP1 nP1]);
        G1_y = reshape(G1(:,2), [nP1 nP1]);
        G2_x = reshape(G2(:,1), [nP2 nP2]);
        G2_y = reshape(G2(:,2), [nP2 nP2]);
        M = (repmat(G1_x, nP2, nP2)-kron(G2_x,ones(nP1))).^2 + (repmat(G1_y, nP2, nP2)-kron(G2_y,ones(nP1))).^2;
    else
        G1 = sqrt(G1(:,1).^2+G1(:,2).^2);
        G2 = sqrt(G2(:,1).^2+G2(:,2).^2);
        G1 = reshape(G1, [nP1 nP1]);
        G2 = reshape(G2, [nP2 nP2]);
        M = (repmat(G1, nP2, nP2)-kron(G2,ones(nP1))).^2;
    end
    M = exp(-M ./ mean(M(:)));
    
    [x y] = find(M >= 0);
    indH3 = [indH3; x-1,x-1,y-1];
    valH3 = [valH3; M(:)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
maxL = min(5*10^6, length(valH3));
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort tuples in ascending order
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim = nP1 * nP2;
uid = indH3(:, 1)*dim*dim + indH3(:, 2)*dim + indH3(:, 3);
[v id] = sort(uid);
valH3 = valH3(id);
indH3 = indH3(id, :);

clear uid v id t1 t2 t3 t4 old_indH3 inds dists feat1 feat2;

%% save the matching problem
problem.nP1 = nP1;
problem.nP2 = nP2;
problem.P1 = P1;
problem.P2 = P2;
problem.indH1 = [];
problem.valH1 = [];
problem.indH2 = [];
problem.valH2 = [];
problem.indH3 = int32(indH3);
problem.valH3 = double(valH3);
problem.trueMatch = seq;
problem.gtruth = zeros(nP2, nP1);
for i = 1:nP1
    problem.gtruth(seq(i), i) = 1;
end

problem.X0 = ones(nP2, nP1);

clear indH1 valH1 indH2 valH2 indH3 valH3;


