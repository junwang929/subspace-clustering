function acc=NMI(inx,gnd)
if size(inx,2)==1
  inx = inx';
end
if size(gnd,2)==1
  gnd = gnd';
 end
 assert(size(inx,2)==size(gnd,2),'Different Size!!');
 assert(min(inx)>=0,'InxMin is unexpected');
 assert(min(gnd)>=0,'GndMin is unexpected');
 if min(inx)==0
   inx = inx+1;
 end
 if min(gnd)==0
   gnd = gnd+1;
 end
 k = max(max(inx),max(gnd));
 N = size(inx,2);
 tempmatrix = zeros(k);
 for i=1:size(inx,2)
    tempmatrix(inx(i),gnd(i))= tempmatrix(inx(i),gnd(i))+1;
 end
 %% count the numbers in each inx-cluster or  gnd-cluster
 numinx = zeros(1,max(inx));
 numgnd = zeros(1,max(gnd));
 for i=1:size(inx,2)
   numinx(inx(i))=numinx(inx(i))+1;
   numgnd(gnd(i))=numgnd(gnd(i))+1;
 end
 numinx
 numgnd
 %% compute NMI
 acc =0;
 for j = 1:size(numinx,2)
    for k =1:size(numgnd,2)
     if tempmatrix(j,k)~=0 && numinx(j)~=0 && numgnd(k)~=0
     acc = acc+tempmatrix(j,k)*(1/N)*log(N*tempmatrix(j,k)/(numinx(j)*numgnd(k)));
     end
    end
 end  
 acc = acc*2/(H(numinx,N)+H(numgnd,N));
end 
function Hacc = H(numarray,N)
  Hacc = 0;
  for i =1:size(numarray,2)
      if numarray(i)~=0
          Hacc = Hacc- numarray(i)*(1/N)*log(numarray(i)*(1/N));
      end
  end
end

   
  
