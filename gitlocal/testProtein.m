clear all;
load 'protein.mat';
warning('off');
nk = 3
rank = 95
data = data';
[m,n] = size(data);
  [U,S,V] = svds( data'*data,rank);
  U = U*sqrt(S);
  V = V*sqrt(S);
 % U = 0.001* rand(n,rank);
 % V = 0.1* rand(n,rank);
maxNumCompThreads(1);
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = rank;
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 fprintf('Protein with size %g, rank %g\n', n, rank);

 %% NLRR++
 [fvalue_N1,ACCN1,SN1,cTN1] = wholeline( data,label,'NLRR++',initialvalue,parameter);
 %% NLRR
 [fvalue_N2,ACCN2,SN2,cTN2] = wholeline( data,label,'NLRR',initialvalue,parameter);
 %% OLRSC
 [fvalue_S1,ACCS1,S1,cTS1] = wholeline( data,label,'OLRSC',0,parameter);
 %% ORPCA
 [fvalue_A1,ACCA1,SA1,cTA1] = wholeline( data,label,'ORPCA',0,parameter);
 %% SSC
 [fvalue_C1,ACCC1,SC1,cTC1] = wholeline( data,label,'SSC');
 %% LRR
 [fvalue_L1,ACCL1,SL1,cTL1] = wholeline( data,label,'LRR',0,parameter);
 