function [U,V,obj,Time] = NLRRplus(Z,A,U,V,beta,k,epsilon, max_inner,nk,label)
  
  [m n] = size(Z);
  maxiter = 15;
  epsilon = 0.005;
  miniter = 7;
  iter = 1;
  R = Z - A*U*V';
  nowobj = 0.5*norm(R,'fro')^2 + 0.5*beta*norm(U,'fro')^2 + 0.5*beta*norm(V,'fro')^2;
  fprintf('Initialiazing obj %g :\n', nowobj);
  obj = [];
  obj = [obj nowobj];
  Time =[];
  Time = [Time 0];
  sumTime = 0;
  T_sec = 0;
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
     tic;
	 for tt=1:k% k is the estimated rank
         tempU = U;
         tempV = V;
         t = ceil(rand()*k);
		 ut = U(:,t);
		 vt = V(:,t);
         
         R = R + (A*ut)*vt';
        for inneriter = 1:max_inner%inner iteration
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
     T_sec = toc;
     sumTime = sumTime +T_sec;
     Time = [Time sumTime];
     tempobj = nowobj;
	 nowobj = 0.5*norm(R, 'fro')^2+0.5*beta*norm(U,'fro')^2+0.5*beta*norm(V, 'fro')^2;
     obj = [obj nowobj];
	 totaltime = totaltime + (cputime - timebegin);
     if iter==1
         Decrease = tempobj - nowobj;
         fprintf('Iter %g  Decrease %g\n', iter, Decrease);
     end
     if iter == maxiter ||tempobj - nowobj >0 && tempobj - nowobj < epsilon*Decrease...
             || tempobj-nowobj<0&& iter>=4
    % if iter >=miniter && tempobj - nowobj < epsilon*Decrease
         converged = false;
     end
     if tempobj - nowobj<0
         U = tempU;
         V = tempV;
     end
     fprintf('Iter %g  Obj %g Diff %g Time %g\n', iter, nowobj,tempobj - nowobj, totaltime);
     iter = iter + 1;
  end
end
     

