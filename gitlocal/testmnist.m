 load mnistdata.mat;
 load mnistlabel.mat;
 numset = [22700 ];
 arank = [90 ];
 ini=[ 1, 89, 214];
 warning('off');
 maxNumCompThreads(1);
for i = 0:2
 j = floor(i/size(ini,2))+1;
 start =ini( mod(i,size(ini,2))+1)
 data1 = data(:,start : (start + numset(j)-1));
 label1 = label(:,start : (start + numset(j)-1));
 U = 0.00001*rand(numset(j),arank(j));
 V = rand(numset(j),arank(j));
 initialvalue.U = U;
 initialvalue.V = V;
 parameter.rank = arank(j);
 parameter.epsilon = 0.005;
 parameter.inner = 3;
 fprintf('MNIST with size %g, rank %g\n', numset(j),arank(j));
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