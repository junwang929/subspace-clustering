function [  ] = test_Mnist(root_dir,carryon)
%TEST_MNIST Summary of this function goes here
%   Detailed explanation goes here

 load mnistdata.mat;
 load mnistlabel.mat;
 numset = [22700 ];
 arank = [90 ];
 ini=[ 1, 89, 214];
 warning('off');
%maxNumCompThreads(1);
%for i = 0:2
 i =0;
 j = floor(i/size(ini,2))+1;
 start =ini( mod(i,size(ini,2))+1)
 data = data(:,start : (start + numset(j)-1));
 label = label(:,start : (start + numset(j)-1));
 U = 0.00001*rand(numset(j),arank(j));
 V = rand(numset(j),arank(j));
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = arank(j);
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 fprintf('MNIST with size %g, rank %g\n', numset(j),arank(j));
 %% saving results:
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
 if carryon == 1 
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
%end

end

