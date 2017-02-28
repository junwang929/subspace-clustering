function [ v, e ] = OLRR_solve_ve( z, D, lambda1, lambda2 )

[p, d] = size(D);
I = eye(d, d);

aux = (D' * D + 1/lambda1 * I) \ D';
thd = lambda2 / lambda1;

v = zeros(d, 1);
e = zeros(p, 1);

eps = 1e-3;
maxIter = 1e3;

converge = false;
iter = 0;

while ~converge
    iter = iter + 1;
    
    orgv = v;
    orge = e;
    
    v = aux * (z - e);
    e = wthresh(z - D * v, 's', thd);
    
    stopc = max(norm(v - orgv) / norm(v), norm(e - orge) / norm(e));
    
    if stopc < eps || iter > maxIter
        converge = true;
    end
end
end

