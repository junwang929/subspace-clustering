clear all;
warning('off'); 
addpath('NLRRSS/');
addpath('clusterings/');
dimension = 1000;
 i=4;
 K=i;
 n_base = 40;
 rho = 0.02;
 lambda = 1/sqrt(dimension)*30;
 n_sample =3000;
%  for n_sample = 2400:400:4000
 task ='simulation_sin';
 root_dir = ['Result/' task '/'];
 if ~exist(root_dir, 'dir')
    mkdir(root_dir)
 end

 for n_base = 40:5:90
 partpath = n_base;
 fprintf('rho = %g \n',rho);
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
 results_nlrrp.fvalue = fvalue_S;
 results_nlrrp.ACC=ACCS;
 results_nlrrp.Time = TS;
 fprintf('NLRR++: Time %g,F_value %g, ACC %g,clusteringT %g\n',TS,fvalue_S,ACCS,cT);
 data_file = [root_dir num2str(partpath) 'nlrrp.mat'];
 save(data_file, 'results_nlrrp');
 fprintf('save to %s\n', data_file);
%% NLRR
 tic;
 [US,VS] = NLRRE(data,data,U0,V0,0.8,parameter.rank,parameter.epsilon,lambda);
 TSn =toc;
 tic;
 [idxn, fvalue_Sn]= spectralclustering(US*VS',label,K);
 cTn = toc;
 grps = bestMap(label,idxn);
 ACCSn = 1-sum(label(:) ~= grps(:)) / length(label); 
 fprintf('NLRR: Time %g,F_value %g, ACC %g, clusteringT %g\n',TSn,fvalue_Sn,ACCSn,cTn);
 results_nlrr.fvalue = fvalue_Sn;
 results_nlrr.ACC=ACCSn;
 results_nlrr.Time = TSn;
 data_file = [root_dir num2str(partpath) 'nlrr.mat'];
 save(data_file, 'results_nlrr');
 fprintf('save to %s\n', data_file);
%% OLRSC
 [results_olrsc] = wholeline( data,label,'OLRSC',0,parameter,'spectralclustering');
  data_file = [root_dir num2str(partpath) 'olrsc.mat'];
 save(data_file, 'results_olrsc');
 fprintf('save to %s\n', data_file);
 %% ORPCA
 [results_orpca] = wholeline( data,label,'ORPCA',0,parameter,'spectralclustering');
 data_file = [root_dir num2str(partpath) 'orpca.mat'];
 save(data_file, 'results_orpca');
 fprintf('save to %s\n', data_file);
 %% LRR
 [results_lrr] = wholeline( data,label,'LRR',0,parameter,'spectralclustering');
 data_file = [root_dir num2str(partpath) 'lrr.mat'];
 save(data_file, 'results_lrr');
 fprintf('save to %s\n', data_file);
%  %% SSC
%  [results_ssc] = wholeline( data,label,'SSC',0,parameter,'spectralclustering');
%  data_file = [root_dir num2str(partpath) 'ssc.mat'];
%  save(data_file, 'results_ssc');
%  fprintf('save to %s\n', data_file);
 end   


