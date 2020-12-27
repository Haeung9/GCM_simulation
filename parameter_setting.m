%%%%%%% Parameter setting for adaptive anti-jamming simulation %%%%%%%%%%
% Parameter_setting.m
% 

disp('parameter setting...')

%% Code parameters
% variables
Nr = 128;              % block length (bits)
OM = 4;                 % length of original message in bits
% values
N = ceil(Nr/2);         % complex block length
if OM > ceil(log2(Nr)-1)
    disp('code length error')       % Nr > 2^OM
end
M = ceil(OM/2);         % complex message length
Rr = OM/Nr;             % code rate of real code

%% Channel parameters
% variables
Njamsupp = round(N/16);      % number of jammed symbol within a codeword
JNRdB = 20;                  % jamming-to-noise ratio in decibel
EbONodB_list = (0:4:16).';  % ROI in Eb/N0
SNRdB_list = EbONodB_list + (10*log10(Rr/2));   % ROI in signal-to-noise ratio

% values
SNR_list = 10.^(SNRdB_list/10);
EbONo_list = 10.^(EbONodB_list/10);
Noise_var_list = (1/Rr/2)./(EbONo_list);
JNR_list = 10.^(JNRdB/10);
Jam_var_list = JNR_list.*Noise_var_list*N/Njamsupp;

% SNR and Eb/N0 calculation:
% let c'c = N
% SNR = c'c / w'w = N / N / noisevar = 1 / noisevar
% Eb*OM = (c'c) = N, Eb = N/OM = 2/Rr
% SNR = Eb*OM / N / noisevar = Eb*Rr/2/noisevar
% Eb/N0 = Eb / noisevar = 2*SNR / Rr;
% noisevar = Eb/(Eb/N0) = (N/OM)/(Eb/N0) = (1/2Rr)/(Eb/N0)
%
% JNR calculation:
% JNR = J'*J / W'*W = Js'*Js /W'*W
% Js ~ CN^Njamsupp(0,I/2*Jam_var), W ~ CN^N(0,I/2*Noise_var)
% Js'*Js = Njamsupp*Jam_var/2, W'*W = N*Noise_var/2
% JNR = Njamsupp*Jam_var/ N / Noise_var
% Jam_var = JNR * Noise_var * N / Njamsupp

%% Simulation parameters
Nsim = 100;         % number of simulations per point
CompStruct = [[1 1];[2 1];[1 3];[2 3];[3 1]].';
Ncomp = size(CompStruct,2);
ErrStruct = zeros(2,Ncomp);
ResultStruct = zeros(length(SNRdB_list),Ncomp,2);

% INDEX for CompStruct
% size(CompStruct) = [Num_compare, 2]
% Each column of CompStruct defines the coding and jamming estimation methods.
% i.e., CompStruct(:,1) = [MODE; JEMETHOD]
%
% MODE: defines the encoding/decoding method
%   1: 'linear'
%   2: 'codebook'
%   3: 'uncoded'
% JEMETHOD: defines the jamming estimation method
%   1: 'OMP', with perfect knowledge of sparsity 
%   2: 'OMP', with unknown sparsity
%   3: 'SBL'
%
% Example: if you want to compare 'linear'/'OMP' with 'linear'/'SBL' method,
%      CompStruct = [[1,1];[1,3]].';

DISP_FREQ = 20; % parameter defines how frequently display current progress

