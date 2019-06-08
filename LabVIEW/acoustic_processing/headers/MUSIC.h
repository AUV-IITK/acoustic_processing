#include <Eigen/Dense>
using namespace Eigen;
#ifndef MUSIC_H
#define MUSIC_H
void neoEigen(Matrix2cf* , MatrixXcf*, VectorXcf*, int , int);
void giveSteeringVector(float, Vector2cf*);
void powerSp(Vector2cf, Matrix2cf*, int, int*, float);
void MUSICclassifier(Matrix2cf *,  float *, float *);
#endif
