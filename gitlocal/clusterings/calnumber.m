function [ K ] = calnumber( label )
%CALNUMBER Summary of this function goes here
%   Detailed explanation goes here
minlabel = min(label);
maxlabel = max(label);
K = 2;
[m, n]= size(label);
if m == 1
   nn=n;
else
   nn=m;
end
   for i = (minlabel+1):(maxlabel-1)
       for j = 1:nn
           if label(j) ==i
               K = K+1;
               break;
           end
       end
   end
        
end

