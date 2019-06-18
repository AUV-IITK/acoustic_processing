clear;close;
tic
d = 3 ;%distance in pair is 3 cm
D = 33.5; %distance between pair is 30 cm;
gamma = -0.05; %signal decays at the rate of -2 for every cm 
s_freq = 150000; %sampling frequency 
w_freq = 45000; %working frequency
% %%%%%%%%%%%%%%% Audio Read
%[U,Fs] = audioread('Wave_gen_44_coherent.wav');
velocity = 1498;
%U_norm = U';
w_freq_1 = 45000;
w_freq_2 = 44999;
w_freq_3 = 45001;
w_freq_4 = 45020;
theta = 135;
phi = -125;
%%%%%%%%%%% Steering Vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
velocity = 1498; %velocity of sound in water 
wavelength = velocity / w_freq;
duration = 10; %assume :) 
t = 0:1/s_freq:duration; 
%%%%%%%%%% Signal One
wave_1 = sin(2*pi*t*w_freq); %basis of signal
amp_1 = 5;
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
noise_1 = (0.1)*awgn(signal_1,amp_1);
U_1 = signal_1 + noise_1;
%%%%%%%%%%%%%%%% Signal 2
wave_2 = sin(2*pi*(t*w_freq_1+0.47 )); %basis of coherent signal
amp_2 = 0.1;
theta_cs = 52;
phi_cs = 48;
signal_2 = amp_2*svm_3d_44_coherent(theta_cs,phi_cs,w_freq,gamma,velocity,d,D)*wave_2;
noise_2 = (.1)*awgn(signal_2,amp_2);
U_2 = signal_2 + noise_2;
%%%%%%%%%%%%%%%% Signal 3
wave_3 = sin(2*pi*(t*w_freq_2 + 0.569 )); %basis of coherent signal
amp_3 = 0.5;
theta_ncs = 18;
phi_ncs = 178;
signal_3 = amp_3*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq,gamma,velocity,d,D)*wave_3;
noise_3 = (.1)*awgn(signal_3,amp_3);
U_3 = signal_3 + noise_3;
%%%%%%%%%%%%%%%% Signal 4
wave_4 = sin(2*pi*(t*w_freq_3 + 0.789 )); %basis of coherent signal
amp_4 = 0.5;
theta_ncs = 78;
phi_ncs = 46;
signal_4 = amp_4*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq,gamma,velocity,d,D)*wave_4;
noise_4 = (.1)*awgn(signal_4,amp_4);
U_4 = signal_4 + noise_4;
%%%%%%%%%%%%%%%% Simulation 
U = U_1 + U_2 + U_3 + U_4;
%%%%%%%%%%%%%%%     MUSIC    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uh = ctranspose(U);
EoU = U*Uh./s_freq;
V = neo_eig(EoU);
X = [];
Y = [];
Z_1 = [];
for azimuth =  0:180
    for altitude = -180:0
            svm_2d_a = svm_3d_44_coherent(azimuth,altitude,w_freq,gamma,velocity,d,D);
            svm_2d_b = ctranspose(svm_2d_a);
            num = abs(svm_2d_b*svm_2d_a);
            den = (abs(svm_2d_b*V(:,1)))^2 + (abs(svm_2d_b*V(:,2)))^2;  %there are two vectors in noise subspace
            ans =  num/den;
            Z(azimuth+1,altitude+181) = ans;
            X(azimuth+1,altitude+181) = azimuth;
            Y(azimuth+1,altitude+181) = altitude;
            Z_1 = vertcat(Z_1,ans);
    end
end
figure
pcolor(X,Y,Z);
[maximum ,index] = max(Z_1);
phi_output = rem(index-1 ,181)-180
%Music_2d_4_3_fb(phi_output,V(:,1),w_freq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc