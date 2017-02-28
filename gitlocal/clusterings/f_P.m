function [ f ,pre,recall,index_f ,index_pre,index_recall,sum] = f_P(sort, inx ,gnd,nk )
%F_P Summary of this function goes here
% 计算 Pj（某个人工标注集） 的最大F值
 pre =[];
 recall = [];
 ff = [];
 num = [];
 sum = [];
  k =1;
  sumn =0;
 temp = sort(1);
  if (size(sort,1)==1)
      sort=sort';
  end
  if (size(inx,1)==1)
      inx=inx';
  end
  if (size(gnd,1)==1)
      gnd=gnd';
  end
 k=1;
 i=1;j=1;sumn=0;numn=0;
 while i<= size(inx,1)
      if( sort(i)==temp)
          temp=sort(i);
          sumn = sumn+1;
          j=1;
          while(j<=nk)
            if (inx(i) == gnd (j))
              numn =numn +1;
              
              break;
            else
              j=j+1;
            end
          end
         i=i+1;
      else 
          
          sum(k) = sumn;
          num(k) = numn;
          sumn=0; numn=0;
          k= k+1;
          temp = sort(i);
        
      end
 end
 sum(k) = sumn;
 num(k) = numn;

   for i=1:size(num,2)
       pre(i) = num(i)/sum(i);
       recall(i) = num(i)/nk;
       ff(i) = 2* pre(i)*recall(i)/(pre(i)+recall(i));
    %  disp([ ' pre= ' num2str( pre(i)) ' recall=' num2str(recall(i)) ' ff=' num2str(ff(i))]);
   end
   [f,index_f]= max(ff);
   [pre,index_pre] = max(pre);
   [recall,index_recall] = max(recall);
  
       
end

