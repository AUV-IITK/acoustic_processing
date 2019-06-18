%%%%%% MATLAB oode to devise the orietation of a source pinger using MUSIC algorithm %%
%This algorithm is indented to work in the case when the Pinger is located
% very far away from the hydrophone array as well as when it is near
clear;close;
tic
%%%%%%%%%%%%%%%% intitil parameters
% It is expected to know this parameters before computation begins 
d = 3 ;%distance in pair is 3 cm
D = 33.5; %distance between pair is 30 cm;
gamma = -0.05; %signal decays at the rate of -2 for every cm 
s_freq = 150000; %sampling frequency 
w_freq = 45000; %working frequency
velocity = 1498;
R = 200;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Simulation
% It is assumed that these 5 frequencies are tracked by this array
w_freq_1 = 44999;
w_freq_2 = 44999;
w_freq_3 = 45001;
w_freq_4 = 45020;
w_freq_5 = 45420;
wavelength = velocity / w_freq;
duration = 10; 
t = 0:1/s_freq:duration; 
%%%%%%%%%%%%%%%% Signal 1
%This is the wave sent by the pinger 
wave_1 = sin(2*pi*(t*w_freq_1 )); %basis of signal
amp_1 = 5;
%The values below are totally subjective
% Phi should be negative 
theta_cs = 45;
phi_cs = -89;
%signal_1 = amp_1*svm_3d_44_coherent(theta_cs,phi_cs,w_freq_1,gamma,velocity,d,D)*wave_1;
signal_1 = amp_1*svm_3d_44_coherent_nf(theta_cs,phi_cs,w_freq_1,gamma,velocity,d,D,R)*wave_1;
%noises is a serious issue in near field range 
noise_1 = (.001)*awgn(signal_1,amp_1);
U_1 = signal_1 + noise_1 ;
%%%%%%%%%%%%%%%% Signal 2
% Given is a coherent signal 
wave_2 = sin(2*pi*(t*w_freq_2 + rand(1))); %basis of signal
amp_2 = 0.5*rand(1);
theta_cs = 2*pi*rand(1);
phi_cs = -2*pi*rand(1);
%signal_2 = amp_2*svm_3d_44_coherent(theta_cs,phi_cs,w_freq_2,gamma,velocity,d,D)*wave_2;
signal_2 = amp_2*svm_3d_44_coherent_nf(theta_cs,phi_cs,w_freq_2,gamma,velocity,d,D,R)*wave_2;
noise_2 = (.001)*awgn(signal_2,amp_2);
U_2 = signal_2 + noise_2;
%%%%%%%%%%%%%%%% Signal 3
wave_3 = sin(2*pi*(t*w_freq_3 + rand(1) )); %basis of coherent signal
amp_3 = 0.5*rand(1);
theta_ncs = 2*pi*rand(1);
phi_ncs = -2*pi*rand(1);
%signal_3 = amp_3*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq_3,gamma,velocity,d,D)*wave_3;
signal_3 = amp_3*svm_3d_44_coherent_nf(theta_ncs,phi_ncs,w_freq_3,gamma,velocity,d,D,R)*wave_3;
noise_3 = (.001)*awgn(signal_3,amp_3);
U_3 = signal_3 + noise_3;
%%%%%%%%%%%%%%%% Signal 4
wave_4 = sin(2*pi*(t*w_freq_4 + rand(1) )); %basis of coherent signal
amp_4 = 0.5*rand(1);
theta_ncs = 2*pi*rand(1);
phi_ncs = -2*pi*rand(1);
%signal_4 = amp_4*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq_4,gamma,velocity,d,D)*wave_4;
signal_4 = amp_4*svm_3d_44_coherent_nf(theta_ncs,phi_ncs,w_freq_4,gamma,velocity,d,D,R)*wave_4;
noise_4 = (.001)*awgn(signal_4,amp_4);
U_4 = signal_4 + noise_4;
%%%%%%%%%%%%%%%% Signal 5
wave_5 = sin(2*pi*(t*w_freq_5 + rand(1) )); %basis of coherent signal
amp_5 = 0.5*rand(1);
theta_ncs = 2*pi*rand(1);
phi_ncs = -2*pi*rand(1);
signal_5 = amp_5*svm_3d_44_coherent(theta_ncs,phi_ncs,w_freq_5,gamma,velocity,d,D)*wave_5;
%signal_5 = amp_5*svm_3d_44_coherent_nf(theta_ncs,phi_ncs,w_freq_5,gamma,velocity,d,D,R)*wave_5;
noise_5 = (.001)*awgn(signal_5,amp_5);
U_5 = signal_5 + noise_5;
% Input wave 
U = U_1 + U_2 + U_3 + U_4 +U_5;
%%%%%%%%%%%%%%%     MUSIC    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uh = ctranspose(U);
EoU = U*Uh./s_freq;
V = neo_eig(EoU);
X = [];
Y = [];
Z_1 = [];
for azimuth =  0:180
    for altitude = -180:0
            if R > 300
            	svm_2d_a = svm_3d_44_coherent(azimuth,altitude,w_freq,gamma,velocity,d,D);
            else
                svm_2d_a = svm_3d_44_coherent_nf(azimuth,altitude,w_freq,gamma,velocity,d,D,R);
            end
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
pcolor(X,Y,Z)
xlabel('theta(\theta)')
ylabel('phi(\phi)');
[maximum ,index] = max(Z_1);
phi_output = rem(index-1 ,181)-180
%Music_2d_4_3_fb(phi_output,V(:,1),w_freq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc