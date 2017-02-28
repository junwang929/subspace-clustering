clear all;
load 'usps.mat';
warning('off');
nk = 10;
rank = 50
data = data';
maxNumCompThreads(1);
 %% Initiliazing:
 U = 0.00001* rand(size(data,2),rank);
 V = rand(size(data,2),rank);
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = rank;
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 fprintf('USPS with size %g, rank %g\n', numset(j),arank(j));
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