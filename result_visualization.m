clear;clc;close all;
load('Data_collection_1112.mat');


intepnt_AWGN = 1/4/Nsim_AWGN;
BER_LG_OMP_PER_AWGN(find(BER_LG_OMP_PER_AWGN==0)) = intepnt_AWGN;
BER_LG_OMP_UNK_AWGN(find(BER_LG_OMP_UNK_AWGN==0)) = intepnt_AWGN;
BER_LG_SBL_AWGN(find(BER_LG_SBL_AWGN==0)) = intepnt_AWGN;
BER_CB_OMP_PER_AWGN(find(BER_CB_OMP_PER_AWGN==0)) = intepnt_AWGN;
BER_CB_OMP_UNK_AWGN(find(BER_CB_OMP_UNK_AWGN==0)) = intepnt_AWGN;
BER_CB_SBL_AWGN(find(BER_CB_SBL_AWGN==0)) = intepnt_AWGN;
intepnt_FADING = 1/4/Nsim_FADING;
BER_LG_OMP_PER_FADING(find(BER_LG_OMP_PER_FADING==0)) = intepnt_FADING;
BER_LG_OMP_UNK_FADING(find(BER_LG_OMP_UNK_FADING==0)) = intepnt_FADING;
BER_LG_SBL_FADING(find(BER_LG_SBL_FADING==0)) = intepnt_FADING;
BER_CB_OMP_PER_FADING(find(BER_CB_OMP_PER_FADING==0)) = intepnt_FADING;
BER_CB_OMP_UNK_FADING(find(BER_CB_OMP_UNK_FADING==0)) = intepnt_FADING;
BER_CB_SBL_FADING(find(BER_CB_SBL_FADING==0)) = intepnt_FADING;

figure(7);semilogy(EbONodB_list,BER_LG_SBL_AWGN,'r-o');hold on;
figure(7);semilogy(EbONodB_list,BER_LG_OMP_PER_AWGN,'b-^');hold on;
figure(7);semilogy(EbONodB_list,BER_LG_OMP_UNK_AWGN,'g-v');hold on;
figure(7);semilogy(EbONodB_list,BER_DSSS_AWGN,'k');hold on;
figure(7);semilogy(EbONodB_list,BER_DSSS_woj_AWGN,'k--');
figure(7);xlabel('Eb/N0');ylabel('BER');title('Linear Gaussian');
figure(7);legend('BSJE','SJMP with prior knowledge','SJMP without prior knowledge','uncoded','uncoded jamming-free');
figure(7);grid on;
figure(7);axis([0 12 1e-4 0.5]);

figure(8);semilogy(EbONodB_list,BER_CB_SBL_AWGN,'r-o');hold on;
figure(8);semilogy(EbONodB_list,BER_CB_OMP_PER_AWGN,'b-^');hold on;
figure(8);semilogy(EbONodB_list,BER_CB_OMP_UNK_AWGN,'g-v');hold on;
figure(8);semilogy(EbONodB_list,BER_DSSS_AWGN,'k-');hold on;
figure(8);semilogy(EbONodB_list,BER_DSSS_woj_AWGN,'k--');
figure(8);xlabel('Eb/N0');ylabel('BER');title('Codebook');
figure(8);legend('BSJE','SJMP with prior knowledge','SJMP without prior knowledge','uncoded','uncoded jamming-free');
figure(8);grid on;
figure(8);axis([0 12 1e-4 0.5]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(9);semilogy(EbONodB_list,BER_LG_SBL_FADING,'r-o');hold on;
figure(9);semilogy(EbONodB_list,BER_LG_OMP_PER_FADING,'b-^');hold on;
figure(9);semilogy(EbONodB_list,BER_LG_OMP_UNK_FADING,'g-v');hold on;
figure(9);semilogy(EbONodB_list,BER_DSSS_FADING,'k-');hold on;
figure(9);semilogy(EbONodB_list,BER_DSSS_woj_FADING,'k--');
figure(9);xlabel('Eb/N0');ylabel('BER');title('Linear Gaussian');
figure(9);legend('BSJE','SJMP with prior knowledge','SJMP without prior knowledge','uncoded','uncoded jamming-free');
figure(9);grid on;
figure(9);axis([0 16 1e-4 0.5]);

figure(10);semilogy(EbONodB_list,BER_CB_SBL_FADING,'r-o');hold on;
figure(10);semilogy(EbONodB_list,BER_CB_OMP_PER_FADING,'b-^');hold on;
figure(10);semilogy(EbONodB_list,BER_CB_OMP_UNK_FADING,'g-v');hold on;
figure(10);semilogy(EbONodB_list,BER_DSSS_FADING,'k-');hold on;
figure(10);semilogy(EbONodB_list,BER_DSSS_woj_FADING,'k--');
figure(10);xlabel('Eb/N0');ylabel('BER');title('Codebook');
figure(10);legend('BSJE','SJMP with prior knowledge','SJMP without prior knowledge','uncoded','uncoded jamming-free');
figure(10);grid on;
figure(10);axis([0 16 1e-4 0.5]);