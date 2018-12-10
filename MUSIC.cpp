#include <Eigen/Dense>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <complex>
#include <fftw3.h>
#include <iostream>
#include "headers/MUSIC.h"

using namespace Eigen;
using namespace std;
#define pi 3.1415926535897932384626433


void neoEigen(Matrix2cf* V, MatrixXcf* eigenvectors, VectorXcf* eigenvalues, int signal, int order){
//Matrix2cf V;//follow my Matlab code on Github for variables.//Dont initialize Xcf matrix or vector . \
//It gives a run time error
for(int i = 0; i <order; i++){
	float min = 10000000000;
	int min_index = 0;
	for(int j=0; j<signal; j++){
		cout << real(eigenvalues[j][0])<<"\n";
		if(min < real(eigenvalues[j][0]))
			min_index = j;
	}
	eigenvalues[min_index][0].real() = 10000000000;
	(*V).col(i) = (*eigenvectors).col(min_index);
}
}

void giveSteeringVector(float altitude, Vector2cf* SteeringVector){
altitude = altitude*pi/180;
float wfreq = 30000;
float velocity = 1498;
float wavelength = velocity/wfreq;
float distance = wavelength;
float phase = 2*pi*sin(altitude)*distance/wavelength;
for(int i = 0; i< 2;i++){
	((*SteeringVector)(i)).real() = cos(i*phase);
	((*SteeringVector)(i)).imag() = sin(i*phase);
}
}
void powerSp(Vector2cf SteeringVector, Matrix2cf* V, int altitude, int* solution, float *minPhase){
float phaseNum =  real(SteeringVector(1)*(*V)(1) +  SteeringVector(0)*(*V)(0))*real(SteeringVector(1)*(*V)(1) +  SteeringVector(0)*(*V)(0)) + imag(SteeringVector(1)*(*V)(1) +  SteeringVector(0)*(*V)(0))*imag(SteeringVector(1)*(*V)(1) +  SteeringVector(0)*(*V)(0)) ;//<< "\n";
float phaseDen =  real(SteeringVector(1)*SteeringVector(1) +  SteeringVector(0)*SteeringVector(0))*real(SteeringVector(1)*SteeringVector(1) +  SteeringVector(0)*SteeringVector(0)) + imag(SteeringVector(1)*SteeringVector(1) +  SteeringVector(0)*SteeringVector(0))*imag(SteeringVector(1)*SteeringVector(1) +  SteeringVector(0)*SteeringVector(0)) ;//<< "\n";
if(*minPhase > phaseNum/phaseDen){
	*solution = altitude;
	*minPhase = phaseNum/phaseDen;
}
cout <<"Num is \n " << *solution << "\n";

}
void MUSICclassifier(Matrix2cf *V,  float *altitude, float *azimuth){
Vector2cf SteeringVector;
int solution = 0;
float minPhase = 100000000;
cout << "HI";
for(float altitude = 0; altitude < 180; altitude++){
giveSteeringVector(altitude, &SteeringVector);
powerSp(SteeringVector, V, altitude, &solution, &minPhase);
}
}

