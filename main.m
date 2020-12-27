%%%%%%%%%%%% Complex Gaussian code antijaming simulation.%%%%%%%%%%%%%%%
% main.m
% Dependancy: 
% - Gcode_generation_complex, parameter_setting, sim_singleiter

close all;clear all; clc;

%% Parameter setting

parameter_setting;

%% code generation

[G, P, B, BP] = Gcode_generation_complex(N, ceil(OM/2));

%% Simulation
tic;
disp('Simulation starts.')

for cnt_SNR = 1:length(SNRdB_list)
    
SNR = SNRdB_list(cnt_SNR);
EbONo = EbONo_list(cnt_SNR);
Noise_var = Noise_var_list(cnt_SNR);
Jam_var = Jam_var_list(cnt_SNR);

% JNR = J'*J / W'*W = Js'*Js /W'*W
% Js ~ CN^Njamsupp(0,I/2*Jam_var), W ~ CN^N(0,I/2*Noise_var)
% Js'*Js = Njamsupp*Jam_var/2, W'*W = N*Noise_var/2
% JNR = Njamsupp*Jam_var/ N / Noise_var
% Jam_var = JNR * Noise_var * N / Njamsupp

for i = 1 : Nsim
    for cnt_comp = 1:Ncomp
        if CompStruct(1,cnt_comp)==1
            MODE = 'linear';
            MATRIX1 = G;
            MATRIX2 = P;
        elseif CompStruct(1,cnt_comp)==2
            MODE = 'codebook';
            MATRIX1 = B;
            MATRIX2 = BP;
        elseif CompStruct(1,cnt_comp)==3
            MODE = 'uncoded';
            MATRIX1 = G;
            MATRIX2 = P;
        else
            disp('Undefined MODE.');
        end
        if CompStruct(2,cnt_comp)==1
            JEMETHOD = 'OMP';
            PRIORSUPP = Njamsupp;
        elseif CompStruct(2,cnt_comp)==2
            JEMETHOD = 'OMP';
            PRIORSUPP = ceil(N/4);
        elseif CompStruct(2,cnt_comp)==3
            JEMETHOD = 'SBL';
            PRIORSUPP = Njamsupp;
        else
            JEMETHOD = 'OMP';
            PRIORSUPP = Njamsupp;   
        end
       
        [NumErr, SqErr] = sim_singleiter(PRIORSUPP,Jam_var,Noise_var,N,M,MATRIX1,MATRIX2,MODE,JEMETHOD);
        ErrStruct(1,cnt_comp) = ErrStruct(1,cnt_comp) + NumErr/OM;
        if strcmp(MODE, 'uncoded')
            ErrStruct(2,cnt_comp) = ErrStruct(2,cnt_comp) + SqErr/OM;
        else
            ErrStruct(2,cnt_comp) = ErrStruct(2,cnt_comp) + SqErr;
        end
       
    end 
    
    if mod(i,DISP_FREQ) == 0
        dpstr = [num2str(i) '/' num2str(Nsim)];
        disp(dpstr)
    end
end

ResultStruct(cnt_SNR,:,1) = ErrStruct(1,:)/Nsim;
ResultStruct(cnt_SNR,:,2) = ErrStruct(2,:)/Nsim;
ErrStruct = zeros(2,Ncomp);

disp(['For Eb/N0 = ' num2str(EbONodB_list(cnt_SNR)) 'dB, BER = ' num2str(ResultStruct(cnt_SNR,1,1)) '.'])
toc
end

%% plot
figure(1);semilogy(EbONodB_list,ResultStruct(:,1,1),'b-o');hold on;
figure(1);semilogy(EbONodB_list,ResultStruct(:,3,1),'r-x');
figure(1);semilogy(EbONodB_list,ResultStruct(:,5,1),'k-');
figure(1);semilogy(EbONodB_list,ResultStruct(:,5,2),'k--');
figure(1);xlabel('Eb/N0');ylabel('BER');title('Linear Gaussian');
figure(1);legend('OMP','SBL','uncoded','uncoded without jamming');

figure(2);semilogy(EbONodB_list,ResultStruct(:,2,1),'b-o');hold on;
figure(2);semilogy(EbONodB_list,ResultStruct(:,4,1),'r-x');
figure(2);semilogy(EbONodB_list,ResultStruct(:,5,1),'k-');
figure(2);semilogy(EbONodB_list,ResultStruct(:,5,2),'k--');
figure(2);xlabel('Eb/N0');ylabel('BER');title('Codebook');
figure(2);legend('OMP','SBL','uncoded','uncoded without jamming');

figure(3);plot(EbONodB_list,ResultStruct(:,1,2),'b-o');hold on;
figure(3);plot(EbONodB_list,ResultStruct(:,3,1),'r-x');
figure(3);xlabel('Eb/N0');ylabel('JE error (MSE)');title('Linear Gaussian');
figure(3);legend('OMP','SBL');
