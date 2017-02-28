clear all;
warning('off'); 
addpath('NLRRSS/');
addpath('clusterings/');
maxNumCompThreads(1);
 dimension = 1000;
 i=4;
 K=i;
 n_base = 40;
 rho = 0.01;
 lambda = 1/sqrt(dimension)*30;
 for n_sample = 2400:400:4000 
 [U,data,E] = sytheticdata( dimension,i,n_base,n_sample,rho);
 data = data + E;
 disp(['rank(dataE)= ' num2str(rank(data))]);
 label =zeros(1,i*n_sample);
 %% label
 for ii=1:i*n_sample
     label(ii) = ceil(ii/n_sample);
 end
 %% NLRRS4
 n =i*n_sample;
U0 = 0.0001*rand(n,i*n_base);
V0 = rand(n,i*n_base);
L = orth(data*U0);
initialvalue.U = U0;
initialvalue.V = V0;
parameter.rank = n_base*i;
parameter.epsilon = 0.005;
parameter.inner = 3;
fprintf('Simulation data with size %g, rank %g\n', n, parameter.rank);
%% NLRR++
tic;
[US1,VS1] = NLRRplusE(data,data,U0,V0,0.8,parameter.rank,parameter.epsilon,parameter.inner,lambda);
%[fvalue_S1,ACCS1,S1,cTS1] = wholeline( data,label,'NLRR++',initialvalue,parameter,'spectralclustering');
TS = toc;
tic;
 [idx, fvalue_S]= spectralclustering(US1*VS1',label,K);
 cT = toc;
 grps = bestMap(label,idx);
 ACCS = 1-sum(label(:) ~= grps(:)) / length(label); 
 fprintf('NLRR++: Time %g,F_value %g, ACC %g, clusteringT %g \n', ...
    TS,fvalue_S,ACCS,cT);
%% NLRR
tic;
[US,VS] = NLRRE(data,data,U0,V0,0.8,parameter.rank,parameter.epsilon,lambda);
TSn =toc;
 tic;
 [idxn, fvalue_Sn]= spectralclustering(US*VS',label,K);
 cTn = toc;
 grps = bestMap(label,idxn);
 ACCSn = 1-sum(label(:) ~= grps(:)) / length(label); 
 fprintf('NLRR: Time %g,F_value %g, ACC %g, clusteringT %g \n', ...
    TSn,fvalue_Sn,ACCSn,cTn);
%% OLRSC
 [fvalue_S1,ACCS1,S1,cTS1] = wholeline( data,label,'OLRSC',0,parameter,'spectralclustering');
 %% ORPCA
 [fvalue_A1,ACCA1,SA1,cTA1] = wholeline( data,label,'ORPCA',0,parameter,'spectralclustering');
 %% LRR
 [fvalue_L1,ACCL1,SL1,cTL1] = wholeline( data,label,'LRR',0,parameter,'spectralclustering');
 %% SSC
 [fvalue_C1,ACCC1,SC1,cTC1] = wholeline( data,label,'SSC',0,parameter,'spectralclustering');
end   


