function [NumErr_message,SqErr_jamming] = sim_singleiter(Njamsupp,Jam_var,Noise_var,N,M,G,P,MODE,JEMETHOD)
% A single simulation of Gaussian coding and decoding. It returns the
% number of bit errors and MSE of jamming estimation. If MODE = 'uncoded',
% second output is BE of unjammed DSSS. Njamsupp: number of jamming support
% set Jam_var: variance of nonzero elements of jamming Noise_var: variance
% of noise N: block length in complex expression M: message length in QPSK
% expression G: coding matrix P: parity-check matrix MODE: determin
% operating mode. 'linear', 'codebook', 'uncoded', 'clear'. default is
% 'linear'. If G, and P are not provided, MODE = 'uncoded'. JEMETHOD:
% determin jamming estimation method. 'OMP', 'SBL'. Default is OMP.
% Dependancy: - OMP_c, SBL_joint_inputnoise, B2I, I2B.

%% default
if nargin<6
    MODE = 'uncoded';
    JEMETHOD = 'NO';
elseif nargin<8
    MODE = 'linear';
    JEMETHOD = 'OMP';
elseif nargin<9
    JEMETHOD = 'OMP';
end

%% parameter setting
Nr = 2*N;
OM = 2*M;
chip_length = 2*round(Nr/OM/2);
if (chip_length*OM == Nr)
    Ns = Nr;
else
    Ns = chip_length*OM;
    if strcmp(MODE,'uncoded')
        Nr = Ns;
        N = Ns/2;
    end
end

%% message generation
m_bin = randi(2,OM,1)-1; 

%% channel and jamming
H = diag(randn(N,1)+sqrt(-1)*randn(N,1))/sqrt(2); % fading channel
% H = eye(N); % AWGN channel
W = (randn(N,1)+sqrt(-1)*randn(N,1))*sqrt(Noise_var)/sqrt(2); % CSCG, E[W'W] = N*noisevar/2. i.e., W~CN(0,I*noisevar/2/sqrt(2))
J = zeros(N,1);
J(randperm(N,Njamsupp)) = sqrt(Jam_var)*(randn(Njamsupp,1)+sqrt(-1)*randn(Njamsupp,1))/sqrt(2); % E[J'*J] = Njamsupp*jamvar/2

%% codeword
if strcmp(MODE,'linear')
    message = (2*m_bin(1:M)-1)+sqrt(-1)*(2*m_bin(M+1:OM)-1); % message for Linear gaussian: {-1,1} binary
    message = message / sqrt(2);
    codeword = G*message;
elseif strcmp(MODE,'codebook')
    message_BG = find(B2I(m_bin)); % message for Block gaussian: indicator vector form
    codeword = G(:,message_BG);
elseif strcmp(MODE,'uncoded')
    chip = 2*randi(2,chip_length,1) - 3;
    codeword_real = kron(2*m_bin-1, chip);
    codeword = codeword_real(1:N) + sqrt(-1)*codeword_real(N+1:Nr);
	codeword = sqrt(N)*codeword/norm(codeword);
    JEMETHOD = 'NO';
else
    disp('Undefined MODE.');
    codeword = zeros(N,1);
end

%% received vector
received = H*codeword + J + W;

%% jamming estimation
if strcmp(JEMETHOD, 'OMP')
    y = P*inv(H)*received;
    Jhat = OMP_c(y, P*inv(H), 1e-3, Njamsupp);
    noisehat = zeros(N,1);
elseif strcmp(JEMETHOD, 'SBL')
    y = P*inv(H)*received;
    [Jhat, noisehat, ~] = SBL_joint_inputnoise(P*inv(H), y, Noise_var);   
else
    Jhat = zeros(N,1);
    noisehat = zeros(N,1);
end

codeword_hat = inv(H)*(received - Jhat - noisehat);

%% decoding
if strcmp(MODE,'linear')
    % Least Square decoding for Linear Gaussian Block coding
    [message_hat,~]=lsqr(G, codeword_hat);
    if ~isempty(find(message_hat==0,1))   
        disp('0 appeared at LS decoding'); 
    end
    message_hat = sign(real(message_hat))+sqrt(-1)*sign(imag(message_hat));
    m_bin_hat = round([(sign(real(message_hat))+1)/2; (sign(imag(message_hat))+1)/2]);
elseif strcmp(MODE,'codebook')
    % Maximum likelihood decoding for codebook coding
    miSE = inf;
    miInd = 0;
    for i = 1 : 2^OM
        SE = norm(G(:,i)-codeword_hat);
        if SE < miSE
            miSE = SE;
            miInd = i;
        end
    end
    m_CB = zeros(2^OM,1);
    m_CB(miInd) = 1;
    m_bin_hat = I2B(m_CB);
elseif strcmp(MODE,'uncoded')
    % Matched Filtering for DSSS signal
    message_hat = zeros(OM,1);
    message_hat_clear = zeros(OM,1);
    v_DSSS = codeword_hat;
    v_DSSS_clear = codeword + inv(H)*W;
    for i=1:OM
        r_DSSS = [real(v_DSSS); imag(v_DSSS)];
        r_DSSSc = [real(v_DSSS_clear); imag(v_DSSS_clear)];
        message_hat(i) = sign(  chip'*r_DSSS( 1+(chip_length*(i-1)):chip_length*i   )   );
        message_hat_clear(i) = sign(  chip'*r_DSSSc( 1+(chip_length*(i-1)):chip_length*i   )   );
    end
    m_bin_hat = round((message_hat+1)/2);
    m_bin_hat_clear = round((message_hat_clear+1)/2);

else
    disp('Undefined MODE.');
    m_bin_hat = zeros(OM,1);
end

%% error counting
NumErr_message = length(find(round(abs(m_bin_hat-m_bin))));
SqErr_jamming = (norm(Jhat+noisehat-J-W)^2)/norm(J+W)^2;    % modified for measureing jamming-plus-noise estimation err, 2019/10/23
if strcmp(MODE,'uncoded')
    SqErr_jamming = length(find(round(abs(m_bin_hat_clear-m_bin))));
end





