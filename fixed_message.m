function [num_spreads, width, longest_path, virality, generation_counts, SG_Adj] = fixed_message(c, x0, N, k, num_seeds, initialdist) 
%% Inputs:
% c: real number in (0,1/2); receptiveness parameter 
% x0: real number in [0,1]; content ideology
% N: positive integer; number of nodes in social network
% k: degree distribution parameter (value type depends on degree distribution)
% num_seeds: positive integer; number of nodes that start with the content
% initialdist: string; either "Gaussian" or "Uniform"; distribution of node opinions

% Outputs:
% num_spreads: total number of messages spread
% width: width of dissemination tree
% longest_path: longest adoption path in dissemination tree
% virality: structural virality of dissemination tree
% generation_counts: number of generations in dissemination tree
% SG_Adj: adjacency matrix of dissemination tree

%%
% Create underlying social network G
distribution = 'Poisson';  % select degree distribution; default is Poisson 
parameter = k;  % define parameter for degree distribution as necessary
G = config_model(N, distribution, parameter);
Adj = adjacency(G);  % adjacency matrix for graph G

seed_node = randi(N, num_seeds, 1);  % seed num_seeds nodes

% Currently this is set up for Gaussian or uniform initial dists; can
% change to include others
if strcmp(initialdist, "Gaussian")
    mu = 0.5;  % mean
    sigma = 0.1;  % std
    x = mu + sigma.*randn(N,1);
else
    x = rand(N,1);  % Uniform initial states
end

x(seed_node) = x0;  % assign content to seed node

% Preallocations
Tree = zeros(N);
message_is_spreading = true;
curr_spreaders = seed_node;
Adj(:, seed_node) = 0;  % content cannot spread to seed_node
longest_path = 0;
width = 1;
generation_counts = [];

%% Run simulation

while message_is_spreading
    next_spreaders = [];
    generation_counts = [generation_counts length(curr_spreaders)];
    
    for i = 1:length(curr_spreaders)       
        neighbors = find(Adj(curr_spreaders(i), :));
        neighbor_states = x(neighbors);
        receptive_neighbors = neighbors(abs(x0-neighbor_states) < c);
        Tree(curr_spreaders(i), receptive_neighbors) = 1;
        next_spreaders = [next_spreaders receptive_neighbors];
        Adj(:, receptive_neighbors) = 0;  % these nodes are no longer receptive
    end
    
    curr_spreaders = next_spreaders;
    
    if isempty(next_spreaders)
        message_is_spreading = false;
    else
        longest_path = longest_path+1;
        if length(next_spreaders) > width
            width = length(next_spreaders);
        end
    end
end


G_Tree = digraph(Tree);  % create graph from Tree data

% removes singletons but also re-labels
[bin,binsize] = conncomp(G_Tree, 'Type', 'weak');
idx = binsize(bin) == max(binsize);
SG = subgraph(G_Tree, idx);
SG_Adj = adjacency(SG);
plot(G_Tree);
%clear G_Tree

virality = structural_virality(SG_Adj, longest_path);

if longest_path == 0
    num_spreads = 0;
    SG_Adj = 0;
else
    num_spreads = size(SG_Adj, 1);
end

disp('Longest path is:')
disp(longest_path) 
disp('Width is:')
disp(width)
disp('Structural virality is:')
disp(structural_virality(SG_Adj, longest_path))
disp('Total number of spreads is:')
disp(num_spreads)
end