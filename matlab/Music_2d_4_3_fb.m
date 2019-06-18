function Music_2d_4_3_fb = Music_2d_4_3_fb(phi,V,wfreq)
altitude = phi;
Z=[];
X=[];
for azimuth =  0:180
            svm_2d_a = svm_2d_4_3(azimuth,altitude,wfreq);
            svm_2d_b = ctranspose(svm_2d_a);
            num = abs(svm_2d_b*svm_2d_a);
            den = svm_2d_b*V(:,1);
            Z = vertcat(Z,num/abs(den)^2);
            X = vertcat(X,180-azimuth);
end
figure
plot(X,Z);
[maximum ,index] = max(Z);
theta = index-1
end