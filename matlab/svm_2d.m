function svm_2d = svm_2d(theta,phi,wfreq)
theta_rad = theta*pi/180;
phi_rad = phi*pi/180;
velocity = 1498;
wavelength = velocity/wfreq;
distance = wavelength;
phase = 2*pi*cos(theta_rad)*cos(phi_rad)*distance/wavelength;
svm_2d = [exp(1i*phase);exp(0) ];
return 