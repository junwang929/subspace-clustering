function [U,V,E] = NLRRplusE(Z,A,U,V,beta,k,epsilon,max_inner,lambda)
% min_{U,V,E} 0.5*||Z -AUV'-E||_F^2 + 0.5*beta||U||_F^2 + 0.5*beta||V||_F^2
%             + lambda * ||E||_1
  [m n] = size(Z);
  maxiter = 7;
  iter = 1;
 E = zeros(m,n);
 R = Z - A*U*V'-E;
nowobj = 0.5*norm(R,'fro')^2 + 0.5*beta*norm(U,'fro')^2 + 0.5*beta*norm(V,'fro')^2;
 fprintf('Initialiazing obj %g :\n', nowobj);
 I = eye(m);
 Q = A*A';
 tic;
 [QU, QD] = svd(Q);
 toc;
 qd = diag(QD);
 ee = 1e-5;
 QUsub = QU(:, qd>=max(qd)*ee);
 qdsub = qd(qd>=max(qd)*ee);
 AT = A';
 totaltime = 0;
 converged = true;
while converged
   timebegin = cputime;
   for tt=1:k
         t = ceil(rand()*k);
		 ut = U(:,t);
		 vt = V(:,t);
          R = R + (A*ut)*vt';
	 for inneriter = 1:max_inner
             %% Update u_t
             Rvt = R*vt;
			 QRvt = Q*Rvt;
			 ARvt = AT*Rvt;
 			 ibeta = norm(vt)^2/beta;
             QsubQRvt =QUsub'*QRvt;
             SQsubQRvt=(1./(1+ibeta*qdsub)).*QsubQRvt;
             SSQsubQRvt =QUsub*SQsubQRvt;
             SSSQsubQRvt = AT*SSQsubQRvt;
             ut = (ibeta*ARvt - ibeta^2*SSSQsubQRvt)/(norm(vt)^2);
			 %% Update v_t
			 dt = norm(A*ut)^2;
			 vt = ((ut'*AT)*R)'/(dt+beta);
     end
 	     R = R - (A*ut)*vt';
		 U(:,t) = ut;
		 V(:,t) = vt;
   end
        %% Update E and R:
         tempE = E;
         R = R + tempE;
	     E = max(R-lambda,0);
         R = R - E;
         
         tempobj = nowobj;
	     nowobj = 0.5*norm(R, 'fro')^2+0.5*beta*norm(U,'fro')^2+0.5*beta*norm(V, 'fro')^2+ lambda*sum(sum(abs(E)));
	     totaltime = totaltime + (cputime - timebegin);
     if iter==1
         Decrease = tempobj - nowobj;
     end
     if tempobj - nowobj>0 && tempobj - nowobj < epsilon*Decrease || iter == maxiter
         converged = false;
     end
	 fprintf('Iter %g Rank %g Obj %g Time %g\n', iter, t, nowobj, totaltime);
     iter = iter +1;
  end
end




