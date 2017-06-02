function [ ] = test_Protein(root_dir,carryon)

load 'protein.mat';
warning('off');
nk = 3
rank = 90
data = data';
[m,n] = size(data);
%   [U,S,V] = svds( data'*data,rank);
%   U = U*sqrt(S);
%   V = V*sqrt(S);
 U = 0.0001* rand(n,rank);
 V = 0.1* rand(n,rank);

%maxNumCompThreads(1);
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = rank;
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 fprintf('Protein with size %g, rank %g\n', n, rank);
 if ~exist(root_dir, 'dir')
    mkdir(root_dir)
 end
 if nargin <2
     carryon = 1;
 end
 %% NLRR++
 [results_nlrrp] = wholeline( data,label,'NLRR++',initialvalue,parameter);
 data_file = [root_dir 'nlrrp.mat'];
 save(data_file, 'results_nlrrp');
 fprintf('save to %s\n', data_file);
 %% NLRR
 [results_nlrr] = wholeline( data,label,'NLRR',initialvalue,parameter);
 data_file = [root_dir 'nlrr.mat'];
 save(data_file, 'results_nlrr');
 fprintf('save to %s\n', data_file);
 if carryon ==1
 %% OLRSC
 [results_olrsc] = wholeline( data,label,'OLRSC',0,parameter);
 data_file = [root_dir 'olrsc.mat'];
 save(data_file, 'results_olrsc');
 fprintf('save to %s\n', data_file);
 %% ORPCA
 [results_orpca] = wholeline( data,label,'ORPCA',0,parameter);
 data_file = [root_dir 'orpca.mat'];
 save(data_file, 'results_orpca');
 fprintf('save to %s\n', data_file);
 %% LRR
 [results_lrr] = wholeline( data,label,'LRR',0,parameter);
 data_file = [root_dir 'lrr.mat'];
 save(data_file, 'results_lrr');
 fprintf('save to %s\n', data_file);
 %% SSC
 [results_ssc] = wholeline( data,label,'SSC');
 data_file = [root_dir 'ssc.mat'];
 save(data_file, 'results_ssc');
 fprintf('save to %s\n', data_file);
 end
end

