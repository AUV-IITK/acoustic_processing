function svm_3d_44_coherent = svm_3d_44_coherent(theta,phi,w_freq,gamma,velocity,d,D)  
wavelength = velocity / w_freq;
dist_d1 =  0;
dist_d2 = d*cos(theta)*cos(phi);
dist_d3 = D*sin(theta)*cos(phi);
dist_d4 = D*sin(theta)*cos(phi) + d*cos(theta)*cos(phi);
phase_d1 = 2*pi*dist_d1/wavelength ;
phase_d2 = 2*pi*dist_d2/wavelength ;
phase_d3 = 2*pi*dist_d3/wavelength ;
phase_d4 = 2*pi*dist_d4/wavelength ;
svm = [exp(1i*phase_d4);exp(1i*phase_d3);exp(1i*phase_d2);exp(1i*phase_d1)]; % steering vector
gamma_d1 = gamma * dist_d1;
gamma_d2 = gamma * dist_d2;
gamma_d3 = gamma * dist_d3;
gamma_d4 = gamma * dist_d4;
gamma_vector = [exp(gamma_d4);exp(gamma_d3);exp(gamma_d2);exp(gamma_d1)];
svm_3d_44_coherent = gamma_vector .* svm;
end