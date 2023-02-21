function G = config_model(N, dist, dist_param)
%% Inputs: 
% N: number of nodes
% dist: degree distribution
% dist_param: parameter for degree distribution (varies based on
%               distribution)

% Outputs:
% G: undirected graph object
%%
rng shuffle

% N = 100;  % Number of nodes

% Select degree distribution
% dist = 'Poisson';
% dist = 'Exponential';
% dist = 'Geometric';
% dist = 'KRegular';

% dist_param = 3;  % define parameter for degree distribution

num_stubs = 0;
G = graph(false(N));

% Generate degree sequence for this distribution
while num_stubs == 0 || mod(num_stubs, 2) == 1 % need number of stubs to be even
    if strcmp(dist, 'KRegular')  % K-regular degree distribution
        seq = dist_param*ones(N, 1);
        if mod(dist_param*N, 2) == 1
           disp('N*k must be even')
           return
        end
    elseif strcmp(dist, 'Exponential')  % Exponential degree distribution
        seq = exprnd(dist_param, N, 1);
    elseif strcmp(dist, 'Geometric')  % Geometric degree distribution
        if dist_param > 1
            disp('Distribution parameter not in (0,1)')
            return
        end
        seq = geornd(dist_param, N, 1);
    else  % Poisson is default
        seq = poissrnd(dist_param, N, 1);
    end
    
    num_stubs = sum(seq);
end

stubs = zeros(num_stubs, 1);
count = 0;

for i = 1:N
    stubs_of_i = seq(i);
    stubs(count+1:count+stubs_of_i) = i;
    count = count+stubs_of_i;
end

stubs = stubs(randperm(num_stubs));  % shuffle stubs
edges_1 = stubs(1:num_stubs/2); 
edges_2 = stubs(num_stubs/2+1:end);  % split into two columns for matching

G = addedge(G, edges_1, edges_2);

end
