clear all;
load 'SVHN.mat';
warning('off');
addpath('clusterings/');
maxNumCompThreads(1);
data = data'./255;
[label,indlabel] = sort(label,'ascend');
data = data(:,indlabel);
data = data(1:2:size(data,1),:);
sizedata = size(data,1)
data = data(:,3000:12000);
size(data,2)
label = label(:,3000:12000);
nk = calnumber(label);
rank = nk*70

 %% Initiliazing:
  [U,S,V] = svds( data'*data,rank);
  U = 0.9*U*sqrt(S) ;
  V = 0.9*V*sqrt(S) ;
%  U = 0.00001*rand(size(data,2),rank);
%  V = 0.01*rand(size(data,2),rank); 
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = rank;
 parameter.epsilon = 0.005;
 parameter.inner = 4;
 fprintf('SVHN with size %g, rank %g\n', 9001,rank);
 %% NLRR++
 [fvalue_N1,ACCN1,SN1,cTN1] = wholeline( data,label,'NLRR++',initialvalue,parameter);
 %% NLRR
 [fvalue_N2,ACCN2,SN2,cTN2] = wholeline( data,label,'NLRR',initialvalue,parameter);
 %% OLRSC
 [fvalue_S1,ACCS1,S1,cTS1] = wholeline( data,label,'OLRSC',0,parameter);
 %% ORPCA
 [fvalue_A1,ACCA1,SA1,cTA1] = wholeline( data,label,'ORPCA',0,parameter);
 %% LRR
 [fvalue_L1,ACCL1,SL1,cTL1] = wholeline( data,label,'LRR',0,parameter);
 %% SSC
 [fvalue_C1,ACCC1,SC1,cTC1] = wholeline( data,label,'SSC');