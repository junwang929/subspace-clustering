function [ Vk ] = principlecoms( U,V,k )
%PRINCIPLECOMS Summary of this function goes here
%   Detailed explanation goes here
  [m,n]= size(U);
   normuvec=[];
    for i=1:n
     normuvec = [normuvec norm(U(:,i))];
    end
  [normsvec, index]=sort(normuvec,'descend');
  Vk = V(:,index(1:k));
end

