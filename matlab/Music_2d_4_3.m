clear;close;
tic
sfreq = 150000;
wfreq = 45000;
theta_deg =76;
phi_deg = 89;
%%%%%%%%%%%%%%%%%% deg to radian %%%%%%%%%%%%%%%%%%%%
theta = theta_deg*pi/180;
phi = phi_deg*pi/180;
%%%%%%%%%%%%%%%%% generating svm %%%%%%%%%%%%%%%%%%%%
velocity = 1498;
wavelength = velocity / wfreq;
distance = wavelength; %modulate
phase = 2*pi*distance/wavelength;
angle_1 = 0;
angle_2 = phase*cos(theta)*cos(phi);
angle_3 = 2*phase*cos(theta)*cos(phi);
svm = [exp(1i*angle_3) exp(1i*angle_2) exp(1i*angle_1)];%given problem is far field 
%%%%%%%%%%%%%%%%% wave and noise generator %%%%%%%%%%%%%%%%%%%%%%
amp = 5;
duration = 10;
t = 0:1/sfreq:duration;
x = amp*exp(2i*pi*wfreq*t);
noise = (0.5)*awgn(x,amp);
Sig = [x*svm(3);x*svm(2);x*svm(1)];
U = Sig + [noise; noise; noise];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uh = ctranspose(U);
EoU = U*Uh./sfreq;
V = neo_eig(EoU);
X = [];
Y = [];
Z_1 = [];
for azimuth =  0:180
    for altitude = 0:180
            svm_2d_a = svm_2d_4_3(azimuth,altitude,wfreq);
            svm_2d_b = ctranspose(svm_2d_a);
            num = abs(svm_2d_b*svm_2d_a);
            den = svm_2d_b*V(:,1);
            ans =  num/abs(den)^2;
            Z(azimuth+1,altitude+1) = ans;
            X(azimuth+1,altitude+1) = 180-azimuth;
            Y(azimuth+1,altitude+1) = altitude;
            Z_1 = vertcat(Z_1,ans);
    end
end
figure
pcolor(X,Y,Z);
[maximum ,index] = max(Z_1);
phi_output = rem(index-1 ,181);
%%%%%%%%%%%%% Sub-array Averaging %%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%% Near field problem %%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase = cos(theta)*cos(phi)- (1/200) 
%%%%%%%%%%%% Feed back %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%take previous output to get wieghted average
Music_2d_4_3_fb(phi_output,V(:,1),wfreq);
phi_output = 180- rem(index-1 ,181)
%%%%%%%%%%% Weighted Average %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc