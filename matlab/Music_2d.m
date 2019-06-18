clear;close;
tic
sfreq = 150000;
wfreq = 45000;
theta_deg = 130;
phi_deg = 53;
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
angle_4 = 3*phase*cos(theta)*cos(phi);
svm = [exp(1i*angle_4) exp(1i*angle_3) exp(1i*angle_2) exp(1i*angle_1)];
%%%%%%%%%%%%%%%%% wave and noise generator %%%%%%%%%%%%%%%%%%%%%%
amp = 5;
duration = 10;
t = 0:1/sfreq:duration;
x = amp*exp(2i*pi*wfreq*t);
noise = (0.01)*awgn(x,amp);
Sig = [x*svm(4);x*svm(3);x*svm(2);x*svm(1)];
U = Sig + [noise; noise; noise; noise];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uh = ctranspose(U);
EoU = U*Uh./sfreq;
V = neo_eig(EoU);
X=[];
Y=[];
for azimuth =  0:180
    for altitude = -90:90
            svm_2d_a = svm_2d(azimuth,altitude,wfreq);
            svm_2d_b = ctranspose(svm_2d_a);
            num = abs(svm_2d_b*svm_2d_a);
            den = svm_2d_b*V(:,1);
            Z(azimuth+1,altitude+91) = num/abs(den)^2;
            X(azimuth+1,altitude+91) = 180 - azimuth;
            Y(azimuth+1,altitude+91) = altitude;
    end
end
pcolor(X,Y,Z)
toc