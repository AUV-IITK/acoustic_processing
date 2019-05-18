//MUSIC DOA for localization of remote pinger using hydrohone arry in AUV.
//Author : Varun Pawar
//Git : github.com/VarunPwr

#include <Eigen/Dense>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <complex>
#include <fftw3.h>
#include <iostream>
#include"headers/MUSIC.h"

using namespace Eigen;
using namespace std;
#define pi 3.1415926535897932384626433

class COMPLEX{
	public:
		fftw_complex *in_arr;
		fftw_complex *anal_arr;
		fftw_complex *anal_arrc;
};

void hilbert(fftw_complex* in_arr, fftw_complex* anal_arr, fftw_complex* anal_arrc, int size)
{	
	fftw_plan fft, ifft;
	fftw_complex *fft_arr;
	fft_arr = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	fft = fftw_plan_dft_1d(size, in_arr, fft_arr, FFTW_FORWARD, FFTW_ESTIMATE);
	ifft = fftw_plan_dft_1d(size, fft_arr, anal_arr, FFTW_BACKWARD, FFTW_ESTIMATE);

	fftw_execute(fft);
	for(int i=0; i<size; i++)
	{
		if(i>0 && i<size/2)
		{
			fft_arr[i][0] = fft_arr[i][0]*2;
			fft_arr[i][1] = fft_arr[i][1]*2;
		}
		else if(i > size/2)
		{
			fft_arr[i][0] = 0;
			fft_arr[i][1] = 0;
		}
	}

	fftw_execute(ifft);

	for(int i =0; i<size; i++)
	{
		anal_arr[i][0] = anal_arr[i][0]/size;
		anal_arr[i][1] = anal_arr[i][1]/size;
		anal_arrc[i][1] = anal_arr[i][1]*-1;
	}
}

int main(void)
{
	int size;
	cout << "Tell size\n";
	cin>>size;
	COMPLEX Signal1, Signal2;

	Signal1.in_arr = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);//assigning memory block
	Signal1.anal_arr = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	Signal1.anal_arrc = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	Signal2.in_arr = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	Signal2.anal_arr = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	Signal2.anal_arrc = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);

	float alt1, alt2;
	cout << "\n Enter Primary pinger angel \n";
	cin >> alt1;
	cout << "\n Enter secondary pinger angel \n";
	cin >> alt2;

	float sfreq = 30000;

	float wfreq1 = 30000;
	float vel = 1498;
	float wavelength1 = vel/wfreq1;
	float distance1 = wavelength1;
	float phase1 = 2*pi*sin(alt1*pi/180)*distance1/wavelength1;

	float wfreq2 = 4000;
	float wavelength2 = vel/wfreq2;
	float distance2 = wavelength1;
	float phase2 = 2*pi*sin(alt2*pi/180)*distance2/wavelength2;
	//////////////////////////////////////////////////////////////////////////////////////////
	printf("INPUT Signal1: \n");
	printf("REAL \t Imaginary \n");
	for(int i=0; i<size; i++){
		Signal1.in_arr[i][0] = sin(2*pi*wfreq1*((float)i)/(sfreq*(float)size) + phase1) + sin(2*pi*wfreq2*i/(sfreq*(float)size) + phase2);
		printf("%f \t %f \n",Signal1.in_arr[i][0], Signal1.in_arr[i][1]);
	}

	printf("INPUT Signal2 =: \n");
	printf("REAL \t IMAGINARY \n");
	for(int i=0; i<size; i++){
		Signal2.in_arr[i][0] =  sin(2*pi*wfreq1*((float)i)/(sfreq*(float)size)) + sin(2*pi*wfreq2*i/(sfreq*(float)size));
		printf("%f \t %f \n",Signal2.in_arr[i][0], Signal2.in_arr[i][1]);
	}

	///////////////////////////// Signal1 /////////////////////////////////////////////////////
	hilbert(Signal1.in_arr, Signal1.anal_arr, Signal1.anal_arrc, size);
	printf("Hilbert transform and its conjugate \n");
	printf("REAL \t Imaginary\t REALc \t ImaginaryC \n");
	for(int i=0; i<size;i++)
		printf("%f \t %f \t %f \t %f \n",Signal1.anal_arr[i][0], Signal1.anal_arr[i][1],Signal1.anal_arrc[i][0],Signal1.anal_arrc[i][1]);
	////////////////////////////// Signal 2 ///////////////////////////////////////////////////////

	hilbert(Signal2.in_arr, Signal2.anal_arr, Signal2.anal_arrc, size);
	printf("Hilbert Transform and its conjugate \n");
	printf("REAL \t Imaginary \t REALc \t ImaginaryC \n");
	for(int i=0; i<size; i++)
		printf("%f \t %f \t %f \t %f \n",Signal2.anal_arr[i][0], Signal2.anal_arr[i][1], Signal2.anal_arrc[i][0],Signal2.anal_arrc[i][1]);

	///////////////////////////// Correlational Matrix ////////////////////////////////////////////

	fftw_complex **EoU;
	EoU = (fftw_complex**) fftw_malloc(sizeof(fftw_complex*)*size);

	//previously a bad implementation of malloc was used here, making the program random
	EoU[0] = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);
	EoU[1] = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*size);

	for(int i =0; i<size; i++){

		EoU[0][0][0] += (Signal1.anal_arr[i][0]*Signal1.anal_arrc[i][0] - Signal1.anal_arr[i][1]*Signal1.anal_arrc[i][1])/size;
		EoU[0][0][1] += (Signal1.anal_arr[i][0]*Signal1.anal_arrc[i][1] + Signal1.anal_arr[i][1]*Signal1.anal_arrc[i][0])/size; 
		EoU[0][1][0] += (Signal1.anal_arr[i][0]*Signal2.anal_arrc[i][0] - Signal1.anal_arr[i][1]*Signal2.anal_arrc[i][1])/size;
		EoU[0][1][1] += (Signal1.anal_arr[i][0]*Signal2.anal_arrc[i][1] + Signal1.anal_arr[i][1]*Signal2.anal_arrc[i][0])/size;
		EoU[1][0][0] += (Signal2.anal_arr[i][0]*Signal1.anal_arrc[i][0] - Signal2.anal_arr[i][1]*Signal1.anal_arrc[i][1])/size;
		EoU[1][0][1] += (Signal2.anal_arr[i][0]*Signal1.anal_arrc[i][1] + Signal2.anal_arr[i][1]*Signal1.anal_arrc[i][0])/size;
		EoU[1][1][0] += (Signal2.anal_arr[i][0]*Signal2.anal_arrc[i][0] - Signal2.anal_arr[i][1]*Signal2.anal_arrc[i][1])/size;
		EoU[1][1][1] += (Signal2.anal_arr[i][0]*Signal2.anal_arrc[i][1] + Signal2.anal_arr[i][1]*Signal2.anal_arrc[i][0])/size;
	}
	printf("EoU is \n %f  + i%f \t %f + i%f \n %f + i%f \t %f + i%f \n",EoU[0][0][0],EoU[0][0][1],EoU[0][1][0],EoU[0][1][1],EoU[1][0][0], EoU[1][0][1],EoU[1][1][0],EoU[1][1][1]);
	free(Signal1.in_arr);
	free(Signal1.anal_arr);
	free(Signal1.anal_arrc);
	free(Signal2.in_arr);
	free(Signal2.anal_arr);
	free(Signal2.anal_arrc);

	Matrix2cf EoU1;
	EoU1(0,0).real() = EoU[0][0][0];
	EoU1(0,1).real() = EoU[0][1][0];
	EoU1(1,0).real() = EoU[1][0][0];
	EoU1(1,1).real() = EoU[1][1][0];

	EoU1(0,0).imag() = EoU[0][0][1];
	EoU1(0,1).imag() = EoU[0][1][1];
	EoU1(1,0).imag() = EoU[1][0][1];
	EoU1(1,1).imag() = EoU[1][1][1];

	cout << EoU1;
	ComplexEigenSolver<MatrixXcf> eigensolver(EoU1);
	cout << "The eigenvalues of A are:" << endl << eigensolver.eigenvalues() << endl;
	cout << "The eigenvectors of A are:" << endl << eigensolver.eigenvectors() << endl;
	MatrixXcf *eigenvectors = const_cast<MatrixXcf*> (&(eigensolver.eigenvectors()));
	VectorXcf *eigenvalues = const_cast<VectorXcf*>(&(eigensolver.eigenvalues()));
	int Signal = 2;
	int order = 1;
	Matrix2cf V;
	neoEigen(&V,eigenvectors, eigenvalues, Signal, order);
	cout << V << "\n";
	float altitude, azimuth;
	MUSICclassifier(&V, &altitude, &azimuth);
	return 0;
}
