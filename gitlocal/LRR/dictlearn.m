function [A_hat] = dictlearn(D,lambda)
%Aug 2013
%%% This function is to find the dictionary matrix A for LRR
%%%    min_{A,Z,E}  |Z|_* + \lambda |E|_1  s.t.  D = AZ + E       
%%%

%%% input: 
 % D -- M by N data matrix, each column is a data point
 
%%% outputs: 
 % A_hat -- estimation of the dicitonary matrix A
%%% parameters:
 % lambda -- the key parameter lambda 
 %      default: 1 /sqrt(max(m,n))
 
warning off all;
addpath lrr;
[m,n]  = size(D);
eps = 1e-3;

if nargin < 2 || isempty(lambda)
    lambda = 1/sqrt(max(m,n));
end

%disp('run rpca ...');
D_hat = inexact_alm_rpca(D,lambda);
%disp('construct dictionary ...')
[U,S,V] = svd(D_hat,'econ');
S = diag(S);
r = sum(S>eps*S(1));   
V = V(:,1:r);
U = U(:,1:r);
S = S(1:r);

D_hat = U*diag(S)*V';
A_hat = normc(D_hat);

%disp('dictionary learning done.')
end
