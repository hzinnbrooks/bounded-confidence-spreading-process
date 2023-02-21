function v = structural_virality(T, l)
%% Inputs:
% T: adjacency matrix of tree G'
% l: number of generations in tree

% Outputs: 
% v: structural virality of tree G'
%%
    n = size(T, 1);
    d = T>0;
    for i = 2:l        
       A = not(d).*d^i;
       d = d+i*(A>0);
    end   
    
    v = 1/(n*(n-1))*sum(sum(full(d)));  
end