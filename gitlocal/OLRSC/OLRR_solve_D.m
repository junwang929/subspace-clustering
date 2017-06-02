function [ D ] = OLRR_solve_D( D, M, A, B, lambda1, lambda3 )

d = size(D, 2);

I = eye(d, d);

A_hat = lambda1 * A + lambda3 * I;
B_hat = lambda1 * B + lambda3 * M;

for j=1:d
    dj = D(:, j);
    aj = A_hat(:, j);
    bj = B_hat(:, j);
    
    tmp = dj - (D * aj - bj) / A_hat(j, j);
    
    D(:, j) = tmp;
end

end

