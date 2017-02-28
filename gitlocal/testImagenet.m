load imagenet100data.mat; 
load imagenet100label.mat;
numset = [ 12700 22700 32700 42700 52700 62700 72700];
arank = [ 90 100 250 350 450 550 600];
ini = [ 214,327,62];
maxNumCompThreads(1);
warning('off');
% To remove the mx in imagenet100.mat which is very memory consuming;
mx=x';
mx = mx(:,1:80000);
clear x;
my = y(:,1:80000);

for i= 0 : 20
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
 end

