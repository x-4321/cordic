#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <functional>   // std::logical_and
#include <iostream>
#include <bitset>
#include <string>
#include "bitops.h"

// number of BITS can be specified in bitops.h


/* these are the constants needed */
//const double invGain2 = 1/0.8281336921;  // cordic_02   + 0.25   -0.25
const double invGain2 =1/ 1.656266;        // cordic_02   + 1      -1   ... = 0.6037 = 0.1001101..
//const double invGain2 =1./3.704;        // + - 5
//const double invGain2 =1./50.59;     // + - 7


BITARRAY mult_0_6037(BITARRAY a)  // multiply BITARRAY with 0.6037 = 0.100110101..
{
  BITARRAY result, temp;
  result = shift_right(a, 1);

  temp   = shift_right(a, 4);
  result = addbits(result, temp);

  temp   = shift_right(a, 5);
  result = addbits(result, temp);

  temp   = shift_right(a, 7);
  result = addbits(result, temp);

  temp   = shift_right(a, 9);
  result = addbits(result, temp);

  return result;
}


// This is the original algorithm. Below (cordic_bit), the same operations are performed, only with bitsets
void cordit2(double* x0, double* y0)
{
    double x[50], y[50];
    int i;


    x[0] = *x0; y[0] = *y0;

    int k = 1;
    for (i = 1; i < 30; ++i) {

        {
            if (y[k-1] < 0 ) {
                x[k] = x[k-1] + y[k-1] / pow(2, i);
                y[k] = y[k-1] + x[k-1] / pow(2, i);
            }
            else {
                x[k] = x[k-1] - y[k-1] / pow(2, i);
                y[k] = y[k-1] - x[k-1] / pow(2, i);

            }

            k++;
        }
        if(i == 4 || i == 7 || i == 10 || i == 13 || i == 16)
          {
              if (y[k-1] < 0 ) {
                  x[k] = x[k-1] + y[k-1] / pow(2, i);
                  y[k] = y[k-1] + x[k-1] / pow(2, i);
              }
              else {
                  x[k] = x[k-1] - y[k-1] / pow(2, i);
                  y[k] = y[k-1] - x[k-1] / pow(2, i);

              }

              k++;
          }
    }
    *x0 = x[k-1];
    *y0 = y[k-1];
}


// This is the same algorithm as above, but with bits instead of double
void cordic_bit(BITARRAY &bx0, BITARRAY &by0)  // accurate only between 0 to 2
{
    /*
     * the `x' iteration have the opposite sign.
     * iterations 4, 7, .. 3k+1 are repeated.
     * iteration 0 is not performed.
     */

    BITARRAY bx, by;
    BITARRAY by_inv, bx_temp, by_temp;
    int i;


    bx = bx0; by = by0;

    int k = 3;

    for (i = 1; i < BITS; ++i) {
        //double x1;
        BITARRAY bx1;

        int j;

        for (j = 0; j < 2; ++j) {
            if(by[BITS-1]) {   // if by is < 0
            //if (y < 0) {
/*              The comment part was the part for calculations with 'double', the calculations with bitsets follow
                y_inv = -y;         // two's complement
                y_inv = y_inv/pow(2, static_cast<double>(i));   // y_inv is > 0, -> can be divided by 2 by shifting
                y_inv = -y_inv;   // two's complement

                x1 = x + y_inv;
                x_temp = x;
                x_temp = x_temp / pow(2, static_cast<double>(i));
                y = y + x_temp;     // x is NEVER smaller than 0
*/
                // Calculations with bitsets
                by_inv = complement_2(by);         // two's complement
                by_inv = shift_right(by_inv, i);   // y_inv is > 0, -> can be divided by 2 by shifting
                by_inv = complement_2(by_inv);   // two's complement


                bx1 = addbits(bx, by_inv);
                bx_temp = bx;
                bx_temp = shift_right(bx_temp, i);
                by = addbits(by, bx_temp);     //y = y + x/pow(2, static_cast<double>(i));     // x is NEVER smaller than 0

            }
            else {
                /*
                y_temp = y;
                y_temp = y_temp / pow(2, static_cast<double>(i));
                y_temp = -y_temp;
                x1 = x + y_temp;

                x_temp = x;
                x_temp = x_temp / pow(2, static_cast<double>(i));
                x_temp = -x_temp;
                y = y + x_temp;
                */
                //y = y - x/pow(2, static_cast<double>(i));   // x is NEVER smaller than 0
               // std::cout << "2. else " << x1 << " " << y << std::endl;

                // Calculations with bitsets
                by_temp = by;
                by_temp = shift_right(by_temp, i);
                by_temp = complement_2(by_temp);
                bx1 = addbits(bx, by_temp);         //x1 = x - y/pow(2, static_cast<double>(i));

                bx_temp = bx;
                bx_temp = shift_right(bx_temp, i);
                bx_temp = complement_2(bx_temp);
                by = addbits(by, bx_temp);

            }
     //      x = x1;     // for operations with double
            bx = bx1;

            if (k) {
                --k;
                break;
            }
            else k = 3;
        }
    }

    bx0 = bx;
    by0 = by;
    //std::cout << "bx0: " << bit_to_double(bx0) << "   x0   " << *x0 << std::endl;
}


/** hyperbolic features ********************************************/


double sqrtCordic(double a)
{
    double x, y;
    BITARRAY bx, by, ba;
    BITARRAY one(pow(2, FPOINT)), one_inv;
    one_inv = complement_2(one);
    ba = double_to_bit(a);

    x = a + 1;
    y = a - 1;

    bx = addbits(ba, one);
    by = addbits(ba, one_inv);
    cordic_bit(bx, by);

    bx = mult_0_6037(bx);
    std::cout << "Cordic Bit:    sqrt = "  << bit_to_double(bx) << std::endl;
    cordit2(&x, &y);
    return x * invGain2;
}

int main(void)
{
    double v;
    double x;


    x = 15;
    v = sqrtCordic(x);
    printf("V = %f\n", v);
    printf("Real:          sqrt(%f) =  %.18e\n", x, sqrt(x));
/*

    x = 9;
    v = sqrtCordic(x);
    //w = sqrt_cordic(x, 25);
    printf("cordi: sqrt(%f) =  %.18e\n", x, v);
    printf("real:  sqrt(%f) =  %.18e\n", x, sqrt(x));


    x = 15;
    v = sqrtCordic(x);
    //w = sqrt_cordic(x, 25);
    printf("cordi: sqrt(%f) =  %.18e\n", x, v);
    printf("real:  sqrt(%f) =  %.18e\n", x, sqrt(x));
*/
}
