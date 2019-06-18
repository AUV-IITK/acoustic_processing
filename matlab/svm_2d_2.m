function svm_2d_2 = svm_2d_2(theta,phi,wfreq,M)
theta_rad = theta*pi/180;
phi_rad = phi*pi/180;
velocity = 1498;
wavelength = velocity/wfreq;
distance = wavelength;
phase = 2*pi*cos(theta_rad)*cos(phi_rad)*distance/wavelength;
if M==0
	svm_2d_2 = [exp(1i*phase);exp(0) ];
else 
    svm_2d_2 = [exp(3i*phase);exp(2i*phase) ];
end
return 