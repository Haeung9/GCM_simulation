function [Gc, Pc, Bc, BPc] = Gcode_generation_complex(N, M)
% Gaussian code generation. matrix = [Gc, Pc, Bc, BPc] =
% Gcode_generation_complex(N, M) returns matrices, which are
% generator/parity-check matrix for Gaussian-LBC method, and
% codebook/parity-check matrix for Gaussian codebook method.
%
% The positive integer N and M define the length of the codeword and
% message bits, respectively.
%
% Gc is N-by-M, Pc is N-by-(N-M), Bc is N-by-2^M, and BPc is n-by-(N-2^M) for codebook EV method.
%
% N must satisfy N > M and N > 2^M.

    % Nr = 2*N;
    OM = 2*M;
    Gc = (randn(N, M)+sqrt(-1)*randn(N, M))/sqrt(2)/sqrt(M);
    Pc = null(Gc.').';
    % Let m = CSCG(M,1)/sqrt(2) ~ CN^M(0,I/sqrt(2)) (thus E[m'm] = M).
    % x = Gc*m;
    % E[x'x] = N 
    Bc = (randn(N, 2^OM)+sqrt(-1)*randn(N, 2^OM))/sqrt(2);
    BPc = null(Bc.').';
    % E[Bc(:,x)'*Bc(:,x)] = N
    % BPc(x,:)*BPc(x,:)' = 1
end