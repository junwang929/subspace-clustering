function [ output_args ] = test_Imagenet(root_dir,carryon)

load imagenet100data.mat; 
load imagenet100label.mat;
%numset = [ 12700 22700 32700 42700 52700 62700 72700];
%arank = [ 90 100 250 350 450 550 600];
numset = [32700 62700];
arank = [250 550];
% ini = [ 214,327,62];
ini =[214];
%maxNumCompThreads(1);
warning('off');
% To remove the mx in imagenet100.mat which is very memory consuming;
mx=x';
mx = mx(:,1:80000);
clear x;
my = y(:,1:80000);
if nargin <2
 carryon = 1;
end
for i= 0 : 1
j = floor(i/size(ini,2))+1;
start = ini( mod(i,size(ini,2))+1)
data = mx(:,start : (start + numset(j)-1));
label = my(:,start : (start + numset(j)-1));
fprintf('Imagenet with size %g, rank %g\n', numset(j),arank(j));
 %% Initiliazing:
 U = 0.00001* rand(numset(j),arank(j));
 if numset(j) >52700
     U = 0.1*U;
 end
 V = rand(numset(j),arank(j));
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = arank(j);
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 if ~exist(root_dir, 'dir')
    mkdir(root_dir)
 end
 if carryon ==1
 %% NLRR++
 [results_nlrrp] = wholeline( data,label,'NLRR++',initialvalue,parameter);
 data_file = [root_dir 'nlrrp' num2str(j) '_' num2str(start) '.mat'];
 save(data_file, 'results_nlrrp');
 fprintf('save to %s\n', data_file);
 %% NLRR
 [results_nlrr] = wholeline( data,label,'NLRR',initialvalue,parameter);
 data_file = [root_dir 'nlrr' num2str(j) '_' num2str(start) '.mat'];
 save(data_file, 'results_nlrr');
 fprintf('save to %s\n', data_file);
 %% OLRSC
 [results_olrsc] = wholeline( data,label,'OLRSC',0,parameter);
 data_file = [root_dir 'olrsc' num2str(j) '_' num2str(start) '.mat'];
 save(data_file, 'results_olrsc');
 fprintf('save to %s\n', data_file);
 %% ORPCA
 [results_orpca] = wholeline( data,label,'ORPCA',0,parameter);
 data_file = [root_dir 'orpca' num2str(j) '_' num2str(start) '.mat'];
 save(data_file, 'results_orpca');
 fprintf('save to %s\n', data_file);
 %% LRR
 [results_lrr] = wholeline( data,label,'LRR',0,parameter);
 data_file = [root_dir 'lrr' num2str(j) '_' num2str(start) '.mat'];
 save(data_file, 'results_lrr');
 fprintf('save to %s\n', data_file);
%  %% SSC
%  [results_ssc] = wholeline( data,label,'SSC');
%  data_file = [root_dir 'ssc' num2str(j) '_' num2str(start) '.mat' ];
%  save(data_file, 'results_ssc');
%  fprintf('save to %s\n', data_file);
 end
 end


end
