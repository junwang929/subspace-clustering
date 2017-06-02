function [ results] = wholeline(data,label,method,initialvalue,parameter,clustermethod,iscluster)
%WHOLELINE Summary of this function goes here
%   Detailed explanation goes here
addpath('NLRRSS/');
addpath('clusterings/');
addpath('OLRSC/');
addpath('ORPCA/');
addpath('SSC/');
addpath('LRR/');
K = calnumber(label);
fvalue_S =0;
ACCS =0;
nmis =0;
S3 =0;
cT =0;
if nargin < 6
    clustermethod = 'clustering';
    iscluster = 1;
end
fprintf ('Method: %s ----\n', method);
 switch(method)
     case 'NLRR++'
     %%
     U = initialvalue.U;
     V = initialvalue.V;
     rank = parameter.rank;
     epsilon = parameter.epsilon;
     inner = parameter.inner;
     tic;
    [US1,VS1,obj,time] = NLRRplus(data,data,U,V,0.8,rank,epsilon,inner);
    %[US1,VS1] = NLRRplusE(data,data,U,V,0.8,rank,epsilon,inner,40);
     S3=toc;
    
     if iscluster == 1
     [fvalue_S,ACCS,cT, nmis] = clusterout(US1,VS1,label,K,clustermethod);
     fprintf('NLRR++: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT,nmis ); 
     end
          results.obj = obj;
          results.time = time;
     case 'NLRR'
  %%
     U = initialvalue.U;
     V = initialvalue.V;
     rank = parameter.rank;
     epsilon = parameter.epsilon;
     inner = parameter.inner;
     tic;
     [US1,VS1,obj,time] = NLRR(data,data,U,V,0.8,rank,epsilon);
     
   % [US1,VS1] = NLRRE(data,data,U,V,0.8,rank,epsilon,40);
     S3=toc;
     if iscluster ==1
     [fvalue_S,ACCS,cT, nmis] = clusterout(US1,VS1,label,K,clustermethod);
     fprintf('NLRR: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT,nmis ); 
     end
          results.obj = obj;
          results.time = time;
   case 'OLRSC'
  %%
    epochs =2;
    Z = data;
    [p, n] = size(Z);
    lambda1 = 1;
    lambda2 = 1/sqrt(p);
    lambda3_base = 1/sqrt(p);
    d = parameter.rank;
    M = zeros(p, d);
    A = zeros(d, d);
    B = zeros(p, d);
    U = zeros(n, d);
    V = zeros(n, d);
    D = randn(p, d);
   tic;
   for ep=1:epochs
    for t=1:n
       if mod(t, 1000) == 0
            fprintf('OLRSC: access sample %d\n', t);
        end
        z = Z(:, t);
        lambda3 = sqrt(t) * lambda3_base;
        [v, e] = OLRR_solve_ve(z, D, lambda1, lambda2);
        normz = norm(z);
        u = (D - M)' * z / (normz * normz + 1/lambda3);
        M = M + z * u';
        A = A + v * v';
        B = B + (z-e) * v';
        D = OLRR_solve_D(D, M, A, B, lambda1, lambda3);
        U(t, :) = u';
        V(t, :) = v';
    end
    M = zeros(p, d);
   end
   S3=toc;
  [fvalue_S,ACCS,cT, nmis] = clusterout(U,V,label,K,clustermethod);
  fprintf('OLRSC: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT, nmis); 
    case 'ORPCA'
   %%
    epochs = 2;
    Z = data;
    [p, n] = size(Z);
    lambda1 = 1/sqrt(p);
    lambda2 = 1/sqrt(p);
    d = parameter.rank;
    L = randn(p, d);
    R = zeros(n, d);
    A = zeros(d, d);
    B = zeros(p, d);
  tic;
  for ep=1:epochs
    for t=1:n
        if mod(t, 1000) == 0
            fprintf('OR-PCA: access sample %d\n', t);
        end
        z = Z(:, t);
        [r, e] = solve_proj2(z, L, lambda1, lambda2);
        A = A + r * r';
        B = B + (z-e) * r';
        L = update_col_orpca(L, A, B, lambda1);
        R(t, :) = r';
    end
  end
  S3 = toc;
  X = L * R';
  [~, SX, VX] = svds(X, d);
 [fvalue_S,ACCS,cT, nmis] = clusterout(VX,VX,label,K,clustermethod);
 fprintf('ORPCA++: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT, nmis); 
     case 'SSC'
 %%
      Z = data;
     [p, n] = size(Z);
   % The following is exactly what SSC does but we test the running time of SSC and spectral clutering separably.
     tic;
     Z = DataProjection(Z, 0);
     CMat = admmOutlier_mat_func(Z, false, 20);
     N = size(Z, 2);
     X = CMat(1:N, :);
     S3 = toc
    tic;
    [idx, fvalue_S]= spectralclustering(X,label,K);
    grps = bestMap(label,idx);
    ACCS = 1-sum(label(:) ~= grps(:)) / length(label);
    nmis = NMI(idx,label);
    cT = toc;
    fprintf('SSC: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT, nmis); 
   case 'LRR'
%%
   d= parameter.rank;
   Z = data;
   [p, n] = size(Z);
   tic;
   [X, ~] = solve_lrr(Z, Z, 1/sqrt(n), 1, 1,1);
   S3 = toc;
   [~, ~, VX] = svds(X, d);
   [fvalue_S,ACCS,cT, nmis] = clusterout(VX,VX,label,K,clustermethod);
    
   fprintf('LRR: Time %g, F_value %g, ACC %g, clusterTime %g,nmis %g \n', S3, fvalue_S, ACCS,cT, nmis); 
 end
    results.fvalue=fvalue_S;
    results.ACC=ACCS;
    results.NMI = nmis;
    results.Time =S3;
    results.cT = cT;
end
  function [fvalue_S,ACCS,cT, nmis] = clusterout(U,V,label,K,clustermethod)
   switch(clustermethod)
     case 'clustering'
    tic;
    [idx,fvalue_S] = clustering(U,V,label,K);
    cT = toc;
     case 'spectralclustering'
    tic;
    X = U*V';
    [idx, fvalue_S]= spectralclustering(X,label,K);
    cT = toc;
   end
   grps = bestMap(label,idx);
   ACCS = 1-sum(label(:) ~= grps(:)) / length(label); 
   nmis = NMI(idx,label);
   nmis2 = NMI(label,idx);
%    nmis3p = nmipp(idx,label);
%    nmis4p = nmipp(label,idx);
%    fprintf('nmis is %g, nmis2: is %g, nmis3p: is %g, nmis4p: is %g,\n',...
%       nmis, nmis2,nmis3p,nmis4p);
fprintf('nmis is %g, nmis2: is %g \n',...
     nmis, nmis2);
  end

