nAlg = 0; 
%% IPFP
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).fhandle = @ipfp_gm;
    Alg(nAlg).variable = {'affinityMatrix', 'L12'};
    Alg(nAlg).param = {};
    Alg(nAlg).strName = 'IPFP';
    % Display option
    Alg(nAlg).color = [0.5 0.6 0.7]; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% MPM
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).fhandle = @MPM;
    Alg(nAlg).variable = {'affinityMatrix', 'group1', 'group2'};
    Alg(nAlg).param = {};
    Alg(nAlg).strName = 'MPM';
    % Display option
    Alg(nAlg).color = 'y'; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = '*'; % linestyle
end

%%%%%%%%%%%% PREVIOUS ORDER-3 METHODS %%%%%%%%%%%%%%%%%%
%% Tensor Matching
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).fhandle = @tensorMatching;
    Alg(nAlg).strName = 'TM';
    Alg(nAlg).bOrder = [0 0 1];
    Alg(nAlg).stoc = 'doubly'; % single
    % Display option
    Alg(nAlg).color = 'g'; % color
    Alg(nAlg).lineStyle = ':'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% RRWHM
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).fhandle = @RRWHM;
    Alg(nAlg).strName = 'RRWHM';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = 'b'; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 's'; % linestyle
end

%%%%%%%%%%%% ORDER-4 METHODS %%%%%%%%%%%%%%%%%%
%% BCAGM
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = 'r'; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% BCAGM+MP
if 1   
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM+MP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = 'm'; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% BCAGM+IPFP
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM+IPFP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.5 0 1]; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% Adapt-BCAGM
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.3 0.2 0.7]; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% Adapt-BCAGM+MP
if 1   
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM+MP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.9 0.7 0.5]; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% Adapt-BCAGM+IPFP
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM+IPFP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.9 0.1 0.4]; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end

%%%%%%%%%%%% ORDER-3 METHODS %%%%%%%%%%%%%%%%%%
%% BCAGM3
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM3';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = 'c'; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% BCAGM3+MP
if 1   
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM3+MP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [1 0.5 0.5]; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% BCAGM3+IPFP
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'BCAGM3+IPFP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0 0.5 0.9]; % color
    Alg(nAlg).lineStyle = '-'; % linestyle
    Alg(nAlg).marker = 'o'; % linestyle
end
%% Adapt-BCAGM3
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM3';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = 'k'; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% Adapt-BCAGM3+MP
if 1   
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM3+MP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.3 0.1 0.5]; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
%% Adapt-BCAGM3+IPFP
if 1
    nAlg = nAlg + 1;
    Alg(nAlg).strName = 'Adapt-BCAGM3+IPFP';
    Alg(nAlg).bOrder = [0 0 1];
    % Display option
    Alg(nAlg).color = [0.2 0.9 0.8]; % color
    Alg(nAlg).lineStyle = '--'; % linestyle
    Alg(nAlg).marker = 'x'; % linestyle
end
clear nAlg
