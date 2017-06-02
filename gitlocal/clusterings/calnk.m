function [nk] = calnk(my)
%CALNK Summary of this function goes here
%   Detailed explanation goes here
  [m,n]= size(my);
  if m==1
      nn = n;
  else 
      nn = m;
  end
  nk= 1;
  for i = 1:nn-1
   if my(i+1)~= my(i)
      nk = nk+1;
   end
  end
  

end

