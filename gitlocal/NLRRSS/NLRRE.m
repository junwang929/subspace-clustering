
function [U,V,E,obj,Time] = NLRRE( Z,A,U,V,beta,k,epsilon,lambda)
%NLRR Summary of this function goes here
%   min_U,V || Z - AUV^T ||_F^2 + \beta (|| U ||_F^2 + || V ||_F^2)
%   s.t. D = AU
%   stopping condition: epsilon
%--------------Initializing----------
 [m n] = size(Z);
 D = A*U;
 E = zeros(m,n);
 W = zeros(m,k);
 mu = 1e-4;
 maxiter = 7;
 obj = [];
 Time = [];
 Time = [Time 0];
%---------------Updating----------------
 
 R = Z - A*U*V';
 nowobj = 0.5*norm(R,'fro')^2 + 0.5*beta*norm(U,'fro')^2 + 0.5*beta*norm(V,'fro')^2;
 fprintf('Initialiazing obj %g :\n', nowobj);
 obj = [obj nowobj];
 iter = 1;
 tic;
 totaltime = 0;
 converged = true;
while converged

 timebegin = cputime;
  U = inv(mu* A'*A + eye(n))* A'*(W + mu*D);
  V = (Z-E)'*D*inv(D'*D+ eye(k)/beta); 
  D = (mu*A*U + beta*Z*V -W)* inv(beta*V'*V + mu* eye(k));
  E = max(Z - D*V'-lambda,0);
  leq1 = D - A*U;
  W = W + mu*leq1;
  mu = 1.1* mu;
  tempobj = nowobj;
  nowobj = 0.5*norm(Z-A*U*V', 'fro')^2+0.5*beta*norm(U,'fro')^2+0.5*beta*norm(V, 'fro')^2+ ...
      lambda* sum(sum(abs(E)));
  obj = [obj nowobj];
  totaltime = totaltime + (cputime - timebegin);
  fprintf('Iter %g Obj %g Time %g\n', iter, nowobj, totaltime);
  if iter==1 
       Decrease = tempobj - nowobj;
   end
   
   if tempobj - nowobj >0 && tempobj - nowobj < epsilon*Decrease || iter == maxiter
      converged = false;
   end
   iter = iter +1;
 
end
toc;
end

