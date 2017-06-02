function [idxL, f_value,pre,recall,f_std,index_pre,index_recall,index_f,sumn]...
    = spectralclustering(Affinitymatrix,gnd,K)
%SPECTRALCLUSTERING 此处显示有关此函数的摘要
%   此处显示详细说明
    n=size(Affinitymatrix,2);
    nc=n/K;

     I = eye(n);
     W=Affinitymatrix;
   W = (abs(W)+abs(W'))/2;
     N = size(W,1);
     D = diag(1./sqrt(sum(W,2)));
      L =D*W*D;
     [U,S,V] = svd(L);
     V = U(:,1:K);
%      V = D*V;%降维后的结果
     V = normr(V);
%      D = diag(sum(W,2));
%      L = D-W;
%      [U,S,V] = svd(L);
%      V = U(:,N-K+1:N);
%      V = D*V;%降维后的结果
     n = size(V,1);
    M = zeros(K,K,20);
    rand('state',123456789);
%选20个初始值 for kmeans
 for i=1:size(M,3)
    inds = false(n,1);
    while sum(inds)<K
        j = ceil(rand()*n);
        inds(j) = true;
    end
    M(:,:,i) = V(inds,:);
 end

    idxL = kmeans(V,K,'replicates',20,'start',M);

    [f_value,pre,recall,f_std,index_pre,index_recall,index_f,sumn]...
        = F(idxL,gnd,K);
end

