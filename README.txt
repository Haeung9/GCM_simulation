------------------------------------------------------------------------------------------------------------------------------------------------
 Table of Contents

	Matlab code:
	1. main.m
    2. parameter_setting.m
	3. result_visualization.m
	4. Gcode_generation_complex.m
	5. sim_singleiter.m
	6. OMP_c.m
	7. SBL_joint_inputnoise.m
	8. B2I.m
	9. I2B.m

	Data:
	10. Data_collection_1112.mat
------------------------------------------------------------------------------------------------------------------------------------------------
1. main.m
% Starts simulation with this code
------------------------------------------------------------------------------------------------------------------------------------------------
2. parameter_setting.m
% Set parameters
------------------------------------------------------------------------------------------------------------------------------------------------
3. result_visualization.m
% Draws bit error rate curve with given data set of simulation result
------------------------------------------------------------------------------------------------------------------------------------------------
4. Gcode_generation_complex.m
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
------------------------------------------------------------------------------------------------------------------------------------------------
5. sim_singleiter.m
% A single simulation of Gaussian coding and decoding. It returns the
% number of bit errors and MSE of jamming estimation. If MODE = 'uncoded',
% second output is BE of unjammed DSSS. Njamsupp: number of jamming support
% set Jam_var: variance of nonzero elements of jamming Noise_var: variance
% of noise N: block length in complex expression M: message length in QPSK
% expression G: coding matrix P: parity-check matrix MODE: determin
% operating mode. 'linear', 'codebook', 'uncoded', 'clear'. default is
% 'linear'. If G, and P are not provided, MODE = 'uncoded'. JEMETHOD:
% determin jamming estimation method. 'OMP', 'SBL'. Default is OMP.
% Dependancy: - OMP_c, SBL_intrinsic_complex, B2I, I2B.
------------------------------------------------------------------------------------------------------------------------------------------------
6. OMP_c.m
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
------------------------------------------------------------------------------------------------------------------------------------------------
7. SBL_joint_inputnoise.m
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
------------------------------------------------------------------------------------------------------------------------------------------------
8. B2I.m
%B2I: binary vector to indicator vector
%   {0,1} binary vector is converted to an indicator vector correspond to 
%   the decimal number. If bin is L-by-N matrix, it returns 2^L-by-N matrix
%   consist of {0,1}^(2^L) binary vectors.
------------------------------------------------------------------------------------------------------------------------------------------------
9. I2B.m
%I2B: indicator vector to binary vector
%    an indicator vector is converted to {0,1} binary vector
------------------------------------------------------------------------------------------------------------------------------------------------
10. Data_collection_1112.mat
% A Matlab workspace contains simulation result, used to draw the figure 7-10 in paper

------------------------------------------------------------------------------------------------------------------------------------------------
Copyright 2017-2020 Haeung Choi, haeung@gist.ac.kr
Version 2020.12.19
------------------------------------------------------------------------------------------------------------------------------------------------