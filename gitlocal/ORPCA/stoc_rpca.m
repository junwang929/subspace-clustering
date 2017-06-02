% Stochastic optimization for the robust PCA
% Input:
%       D: [m x n] data matrix, m - ambient dimension, n - samples number
%       lambda1, lambda2: trade-off parameters
%       nrank: the groundtruth rank of the data
% Output:
%       L: [m x r] the basis of the subspace
%       R: [r x n] the coefficient of the samples on the basis L
%       E: sparse error
%
% copyright (c) Jiashi Feng (jshfeng@gmail.com)
%

function [L,R,E] = stoc_rpca(D, nrank, lambda1, lambda2 )


%% initialization
[ndim, nsample] = size(D);
L = cell(nsample+1,1);
L{1} = rand(ndim,nrank); 
A = zeros(nrank,nrank);
B = zeros(ndim,nrank);
R = zeros(nrank,nsample);
E = zeros(ndim,nsample);

%% online optimization
for t = 1:nsample
    
    if mod(t, 100) == 0
        fprintf('OR-PCA: access sample %d\n', t);
    end
%     tic;
    z = D(:,t);
%     tic;
    [r,e] = solve_proj2(z,L{t},lambda1,lambda2);
%     tused = toc;
%     fprintf('elapsed time for projection %f secs\n',tused);
    R(:,t) = r;
    E(:,t) = e;
    
    A = A + r*r';
    B = B + (z-e)*r';
%     L{t+1} = update_col_orpca(L{t},A,B,lambda1/nsample); 
    L{t+1} = update_col_orpca(L{t},A,B,lambda1); 
end

R = R';

end

