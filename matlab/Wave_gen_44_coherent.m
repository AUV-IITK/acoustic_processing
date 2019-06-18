clear;close;
tic
d = 3 ;%distance in pair is 3 cm
D = 33.6; %distance between pair is 30 cm;
gamma = -0.05; %signal decays at the rate of -2 for every cm 
s_freq = 150000; %sampling frequency 
% w_freq = [45000;45000-450*rand(1);45000-450*rand(1);45000-450*rand(1);45000-450*rand(1);45000-450*rand(1)]; %working frequency
% doa = [45 -150;180*rand(1) 180*rand(1);180*rand(1) 180*rand(1);180*rand(1) 180*rand(1);180*rand(1) 180*rand(1);180*rand(1) 180*rand(1)];
% % %%%%%%%%%%% Steering Vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% velocity = 1498; %velocity of sound in water 
% duration = 10; %assume :) 
% t = 0:1/s_freq:duration; 
% %%%%%%%%%%%%%%% Signal 1
% wave_1 = sin(2*pi*(t*w_freq(1))); %basis of coherent signal
% amp_1 = 5;
% theta_ncs = 50 ;
% phi_ncs = -45; 
% signal_1 = amp_1*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(1),gamma,velocity,d,D)*wave_1;
% noise_1 = (0.1)*awgn(signal_1,amp_1);
% U_1 = signal_1 + noise_1;
% %%%%%%%%%%%%%%% Signal 2
% wave_2 = sin(2*pi*(.33+t*w_freq(2))); %basis of coherent signal
% amp_2 = 0.1;
% theta_ncs = doa(2,1) ;
% phi_ncs = doa(2,2); 
% signal_2 = amp_2*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(2),gamma,velocity,d,D)*wave_2;
% noise_2 = (0.1)*awgn(signal_2,amp_2);
% U_2 = signal_2 + noise_2;
% %%%%%%%%%%%%%%% Signal 3
% wave_3 = sin(2*pi*(.57 + t*w_freq(3))); %basis of coherent signal
% amp_3 = 0.1;
% theta_ncs = doa(3,1) ;
% phi_ncs = doa(3,2); 
% signal_3 = amp_3*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(3),gamma,velocity,d,D)*wave_3;
% noise_3 = (0.1)*awgn(signal_3,amp_3);
% U_3 = signal_3 + noise_3;
% %%%%%%%%%%%%%%% Signal 4
% wave_4 = sin(2*pi*(t*w_freq(4))+0.564); %basis of coherent signal
% amp_4 = 0.1;
% theta_ncs = doa(4,1) ;
% phi_ncs = doa(4,2); 
% signal_4 = amp_4*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(4),gamma,velocity,d,D)*wave_4;
% noise_4 = (0.1)*awgn(signal_4,amp_4);
% U_4 = signal_4 + noise_4;
% % I assume that there are 4 reflections ,apart from that others are
% % harmonics so have very small amplitude
% %%%%%%%%%%%%%%% Signal 5
% wave_5 = sin(2*pi*(t*w_freq(5)+0.6)); %basis of coherent signal
% amp_5 = 0.1;
% theta_ncs = doa(5,1) ;
% phi_ncs = doa(5,2); 
% signal_5 = amp_5*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(5),gamma,velocity,d,D)*wave_5;
% noise_5 = (0.1)*awgn(signal_5,amp_5);
% U_5 = signal_5 + noise_5;
% %%%%%%%%%%%%%%% Signal 6
% wave_6 = sin(2*pi*(t*w_freq(6)+.56)); %basis of coherent signal
% amp_6 = 0.1;
% theta_ncs = doa(6,1) ;
% phi_ncs = doa(6,2); 
% signal_6 = amp_6*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq(6),gamma,velocity,d,D)*wave_6;
% noise_6 = (0.1)*awgn(signal_6,amp_6);
% U_6 = signal_6 + noise_6;
% % %%%%%%%%%%%%%%%% Simulation 
% U = U_1 + 0*U_2 + 0*U_3 + 0*U_4 + 0*U_5 + 0*U_6;
% A_1 =max(abs( U(1,:)));
% U_norm_1 = U(1,:)./A_1;
% A_2 =max(abs( U(2,:)));
% U_norm_2 = U(2,:)./A_2;
% A_3 =max(abs( U(3,:)));
% U_norm_3 = U(3,:)./A_3;
% A_4 =max(abs( U(4,:)));
% U_norm_4 = U(4,:)./A_4;
% U_norm = [U_norm_1 ; U_norm_2 ; U_norm_3 ; U_norm_4]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_freq = 45000;
w_freq_1 = 50000;
w_freq_2 = 49000;
w_freq_3 = 48000;
w_freq_4 = 46000;
theta = 135;
phi = -45;
%%%%%%%%%%% Steering Vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
velocity = 1498; %velocity of sound in water 
wavelength = velocity / w_freq;
duration = 10; %assume :) 
t = 0:1/s_freq:duration; 
%%%%%%%%%% Signal One
wave_1 = sin(2*pi*t*w_freq); %basis of signal
amp_1 = 0.1;
dist_d1_1 =  0;
dist_d2_1 = d*cos(theta)*cos(phi);
dist_d3_1 = D*sin(theta)*cos(phi);
dist_d4_1 = D*sin(theta)*cos(phi) + d*cos(theta)*cos(phi);
phase_d1_1 = 2*pi*dist_d1_1/wavelength ;
phase_d2_1 = 2*pi*dist_d2_1/wavelength ;
phase_d3_1 = 2*pi*dist_d3_1/wavelength ;
phase_d4_1 = 2*pi*dist_d4_1/wavelength ;
svm_1 = [exp(1i*phase_d4_1);exp(1i*phase_d3_1);exp(1i*phase_d2_1);exp(1i*phase_d1_1)]; % steering vector
gamma_d1_1 = gamma * dist_d1_1;
gamma_d2_1 = gamma * dist_d2_1;
gamma_d3_1 = gamma * dist_d3_1;
gamma_d4_1 = gamma * dist_d4_1;
gamma_vector_1 = [exp(gamma_d4_1);exp(gamma_d3_1);exp(gamma_d2_1);exp(gamma_d1_1)];
signal_1 =  amp_1*svm_1.*gamma_vector_1*wave_1;
noise_1 = (0.0)*awgn(signal_1,amp_1);
U_1 = signal_1 + noise_1;
%%%%%%%%%%%%%%%% Signal 2
wave_2 = sin(2*pi*(t*w_freq+0.47 )); %basis of coherent signal
amp_2 = 0.1;
theta_cs = 52;
phi_cs = 48;
signal_2 = amp_2*svm_3d_44_coherent(theta_cs,phi_cs,w_freq,gamma,velocity,d,D)*wave_2;
noise_2 = (.1)*awgn(signal_2,amp_2);
U_2 = signal_2 + noise_2;
%%%%%%%%%%%%%%%% Signal 3
wave_3 = sin(2*pi*(t*w_freq + 0.569 )); %basis of coherent signal
amp_3 = 0.1;
theta_ncs = 18;
phi_ncs = 178;
signal_3 = amp_3*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq,gamma,velocity,d,D)*wave_3;
noise_3 = (.1)*awgn(signal_3,amp_3);
U_3 = signal_3 + noise_3;
%%%%%%%%%%%%%%%% Signal 4
wave_4 = sin(2*pi*(t*w_freq + 0.789 )); %basis of coherent signal
amp_4 = 0.1;
theta_ncs = 78;
phi_ncs = 46;
signal_4 = amp_4*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq,gamma,velocity,d,D)*wave_4;
noise_4 = (.1)*awgn(signal_4,amp_4);
U_4 = signal_4 + noise_4;
%%%%%%%%%%%%%%%% Simulation 
U = U_1 + 0*U_2 + 0*U_3 + 0*U_4;
% A_1 =max(abs( U(1,:)));
% U_norm_1 = U(1,:)./A_1;
% A_2 =max(abs( U(2,:)));
% U_norm_2 = U(2,:)./A_2;
% A_3 =max(abs( U(3,:)));
% U_norm_3 = U(3,:)./A_3;
% A_4 =max(abs( U(4,:)));
% U_norm_4 = U(4,:)./A_4;
max((noise_1)')
U_norm = U;
filename = 'Wave_gen_44_coherent.wav';
audiowrite(filename,(U_norm)',s_freq);
toc