function [spare_solution, noise, G] = SBL_joint_inputnoise(A, b, var, tol, Max_cnt)
% [spare_solution, noise, G] = SBL_joint_inputnoise(A, b, var, tol,
% Max_cnt) is the Sparse Bayesian Learning algorithm for sparse signal
% recovery. The estimation of sparse signal vector, sparse_solution, and
% input white noise vector, noise, are jointly calculated by using
% measurement matrix A, measurement b, and input white noise variance, var.
%
% A is the measurement matrix, which is product of parity-check matrix and
% inverse of channel matrix.
% 
% var is the noise variance of receiver, which can be pre-estimated by receiver hardware.
%
% tol and Max_cnt are tolerance and maximum number of iteration,
% respectively. The values are used to determine the termination condition
% of SBL iteration. The default value is set to tol = 0.01 and Max_cnt =
% 20, by heuristic way.
% 
% sparse is the sparse Gaussian vector, which is assumed to follow a
% Gaussian distribution with zero mean and covariance matrix G.
%
% noise is the input white noise vector, which is assumed to follow a
% Gaussian distribution with zero mean and covariance matrix var*eye. 
%
% G is an optional output, which is a hyperparameter in Bayesian method.
%
if nargin < 5
    Max_cnt = 20;
end
if nargin < 4
    tol = 0.01;
end

[m, n]=size(A);
spare_solution = zeros(n,1);
noise = zeros(n,1);
G = eye(n);
if m~=length(b)
    disp('Wrong measurement size');
    return
end

for cnt = 1:Max_cnt
    temp = G;
    T = inv(A*G*A'+var*(A*A'));
    C = G - G*A'*T*A*G;
    spare_solution = G*A'*T*b;
    noise = var*A'*T*b;
    G = diag(diag(C))+diag(abs(spare_solution).^2);
    delta = norm(diag(G-temp))/norm(b);

    if delta <= tol
        % disp(['SBL terminated at iter =' num2str(cnt) ' since converge, delta =' num2str(delta)]);
        return
    end
    
end
% disp(['SBL terminated at iter =' num2str(cnt) ' since maximum iteration reached, delta =' num2str(delta)]);
