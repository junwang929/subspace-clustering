function [ L,R,E ] = ORPCA_new( Z,L,R,k, lambda,beta,epsilon,update,inneriter)
% min 0.5*|| Z - LR^T ||F + 0.5*lambda||L||F+ 0.5*lambda||R||F 
%     + beta*||E||_1
%% Initializing:
[m,n] = size(Z);
% L = randn(m,k);
% R = randn(n,k);
E = zeros(m,n);
S = Z - L*R' -E;
maxiter = 8;
iter = 1;
converged = true;
stopnorm = 0.5* norm(S,'fro')^2 + 0.5*lambda*norm(L,'fro')^2+ 0.5*lambda*norm(R,'fro')^2 ...
+ beta*sum(sum(abs(E)));
fprintf( 'Initializing: obj_value = %g\n', stopnorm);

%%
switch(update)
    case 'column'
       while converged
         for i = 1: k
           S = S + L(:,i)*R(:,i)';
           for inner = 1:inneriter
               L(:,i) =S*R(:,i)./ (lambda+ norm(R(:,i))^2);
%                L(:,i) =S*R(:,i)./ (lambda+ 1);
               R(:,i) =S'*L(:,i)./ (lambda+ norm(L(:,i))^2);
%                R(:,i) = R(:,i)./ norm(R(:,i));
           end
           S = S - L(:,i)*R(:,i)';
         end
         E = max(Z-S-beta,0);
         tempstop = stopnorm;
         stopnorm = 0.5* norm(S,'fro')^2 + 0.5*lambda*norm(L,'fro')^2+ 0.5*lambda*norm(R,'fro')^2 ...
         +beta*sum(sum(abs(E)));
         if iter==1
          Decrease = tempstop - stopnorm;
         end
         if iter == maxiter||tempstop-stopnorm >0 && tempstop-stopnorm< epsilon*Decrease 
          converged = false;
         end
         fprintf('iter = %g, obj_value = %g \n',iter, stopnorm);
         iter = iter+1;
       end
    case 'matrix'
        inneriter =1;
        while converged
         for i = 1: k
           S = S + L(:,i)*R(:,i)';
           for inner = 1:inneriter
               L(:,i) =S*R(:,i)./ (lambda+ norm(R(:,i))^2);
%                R(:,i) =S'*L(:,i)./ (lambda+ norm(L(:,i))^2);
           end
           S = S - L(:,i)*R(:,i)';
         end
          for i = 1: k
           S = S + L(:,i)*R(:,i)';
           for inner = 1:inneriter
%                L(:,i) =S*R(:,i)./ (lambda+ norm(R(:,i))^2);
               R(:,i) =S'*L(:,i)./ (lambda+ norm(L(:,i))^2);
           end
           S = S - L(:,i)*R(:,i)';
         end
         E = max(Z-S-beta,0);
         tempstop = stopnorm;
         stopnorm = 0.5* norm(S,'fro')^2 + 0.5*lambda*norm(L,'fro')^2+ 0.5*lambda*norm(R,'fro')^2 ...
         +beta*sum(sum(abs(E)));
         if iter==1
          Decrease = tempstop - stopnorm;
         end
         if iter == maxiter||tempstop-stopnorm >0 && tempstop-stopnorm< epsilon*Decrease 
          converged = false;
         end
         fprintf('iter = %g, obj_value = %g \n',iter, stopnorm);
         iter = iter+1;
       end

 
end

end

