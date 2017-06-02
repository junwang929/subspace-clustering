function [ U,data,E] = sytheticdata( dimension,n_subspace,n_base,n_sample,rho)
% Generating data 
% n_subspace: number of subspaces
% n_base: number of basis in each subspace
% n_sample: number of samples from each subspace
basis =orth(randn(dimension,dimension));
% Generating data based on 'basis'
U = [ ];
data = [ ];
 for i = 1: n_subspace
     start_idx = 1+ (i-1)*n_base;
     end_idx = i*n_base;
    if end_idx > dimension
        error('cannot produce disjoint subspaces');
    end
     U_base = basis( :,start_idx:end_idx);
     V_base = randn(n_sample,n_base);
     U = [U U_base];
     
     data_base = U_base*(V_base)';
     data = [data data_base];
 end

num_elements = dimension * n_subspace*n_sample;
temp = randperm(num_elements) ;
numCorruptedEntries = round(rho * num_elements) ;
corruptedPositions = temp(1:numCorruptedEntries) ;
E = zeros(dimension, n_subspace*n_sample);
E(corruptedPositions) = 20 *(rand(numCorruptedEntries, 1) - 0.5) ;


end

