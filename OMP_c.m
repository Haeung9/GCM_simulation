function est_x=OMP_c(y,F,tol,K)
% est_x=OMP_c(y,F,tol,K) is the Othogonal Matching Pursuit algorithm for
% sparse signal recovery. 
%
% The estimation of sparse signal, est_x is calculated by known measurement
% y and measurment matrix F, such that ||y - F*est_x|| is minimized. 
%
% If users are aware of sparsity and power of spares signal a priori, the
% information can be exploited as forms of input arguments K and tol. If
% the arguments are not declared, those parameters are set to be default
% value.
%
% est_x=OMP_c(y,F) returns the spares signal est_x.
%
% est_x=OMP_c(y,F,tol,K) returns the spares signal est_x, using maximum K
% iterations. The iteration is finished where energy of residual decrease
% under the value of tol.

[M N]=size(F);
if length(y)~=M
    est_x=zeros(N,1);
    disp('OMP_tc: Dimension Mismatched. L8')
    return
end
Norm_y=norm(y);
if nargin<4
    K=N;
end
if nargin<3
    tol=1e-4;
end

% initialize
r=y;
S=[];
est_x=zeros(N,1);
for i=1:K
    c=r'*F;
    [val ind]=max(abs(c));
    if length(find(S==ind))~=0
        break;
    end
    S=union(S,ind);
    [est_x(S),flag]=lsqr(F(:,S),y);
    est_x(setdiff(1:N,S))=zeros(N-length(S),1);
    r=y-F*est_x;
    
    if norm(r)/Norm_y<tol;
        break;
    end
end
end