function [ D, U, V, E ] = OLRR_solve_main( Z, lambda1, lambda2, lambda3, D, M, A, B )

[p, n] = size(Z);
d = size(D, 2);

U = zeros(n, d);
V = zeros(n, d);
E = zeros(p, n);

for t=1:n
    if mod(t, 100) == 0
        fprintf('OLRR access sample %d\n', t);
    end
    
    z = Z(:, t);
    
    [v, e] = OLRR_solve_ve(z, D, lambda1, lambda2);
    
    normz = norm(z);
    u = (D - M)' * z / (normz * normz + 1/lambda3);
    
    M = M + z * u';
    A = A + v * v';
    B = B + (z-e) * v';
    
    D = OLRR_solve_D(D, M, A, B, lambda1, lambda3);

    U(t, :) = u';
    V(t, :) = v';
    E(:, t) = e;
end

