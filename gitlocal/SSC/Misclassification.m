%--------------------------------------------------------------------------
% This function takes the groups resulted from spectral clutsering and the
% ground truth to compute the misclassification rate.
% groups: [grp1,grp2,grp3] for three different forms of Spectral Clustering
% s: ground truth vector
% Missrate: 3x1 vector with misclassification rates of three forms of
% spectral clustering
%--------------------------------------------------------------------------
% Copyright @ Ehsan Elhamifar, 2012
%--------------------------------------------------------------------------


function Missrate = Misclassification(groups, gt)

% n = max(s);
% for i = 1:size(groups,2)
%     Missrate(i,1) = missclassGroups( groups(:,i),s,n ) ./ length(s); 
% end

K = max(gt);
M = zeros(K, K);
for i=1:K
    idx = (groups == i);
    
    for j=1:K
        M(i, j) = sum(gt(idx) ~= j);
    end
end

[~, cost] = Hungarian(M);

Missrate = cost / length(gt);