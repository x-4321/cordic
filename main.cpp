#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <functional>   // std::logical_and
#include <iostream>
#include <bitset>
#include <string>
#include "bitops.h"

/* these are the constants needed */
//const double invGain2 = 1/0.8281336921;  // cordic_02   + 0.25   -0.25
const double invGain2 =1/ 1.656266;        // cordic_02   + 1      -1   ... = 0.6037 = 0.1001101..



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

void cordit2(double* x, double* y)
{
    /* here's the hyperbolic methods. its very similar to
     * the circular methods, but with some small differences.
     *
     * the `x' iteration have the opposite sign.
     * iterations 4, 7, .. 3k+1 are repeated.
     * iteration 0 is not performed.
     */


    double x_temp, y_temp;
    int i, k = 4, iter_steps = 50;

    for(i = 1; i < iter_steps; ++i)
    {
      x_temp = *x / pow(2., static_cast<double>(i));
      y_temp = *x / pow(2., static_cast<double>(i));

      if (*y < 0.)
      {
          *x = *x + y_temp;
          *y = *y + x_temp;
      }
      else
      {
        *x = *x - y_temp;
        *y = *y - x_temp;
      }

      if (i == k)
      {
        x_temp = *x / pow(2., static_cast<double>(i));
        y_temp = *x / pow(2., static_cast<double>(i));

        if (*y < 0.)
        {
          *x = *x + y_temp;
          *y = *y + x_temp;
        }
        else
        {
          *x = *x - y_temp;
          *y = *y - x_temp;
        }
        k = 3 * k + 1;
      }
    }
}


#define MULT(_a, _b)    (_a)*(_b)


void cordic_02(double* x0, double* y0, BITARRAY &bx0, BITARRAY &by0)  // accurate only between 0 to 2
{
    /*
     * the `x' iteration have the opposite sign.
     * iterations 4, 7, .. 3k+1 are repeated.
     * iteration 0 is not performed.
     */
    double x, y;
    double y_inv, y_temp, x_temp;

    BITARRAY bx, by;
    BITARRAY by_inv, bx_temp, by_temp;
    int i;

    x = *x0; y = *y0;
    bx = bx0; by = by0;

    int k = 3;

    for (i = 1; i < MAXBITS; ++i) {
        double x1;
        BITARRAY bx1;

        int j;

        for (j = 0; j < 2; ++j) {
            if(by[BITS-1]) {   // if by is < 0
            //if (y < 0) {

                y_inv = -y;         // two's complement
                y_inv = y_inv/pow(2, static_cast<double>(i));   // y_inv is > 0, -> can be divided by 2 by shifting
                y_inv = -y_inv;   // two's complement

                x1 = x + y_inv;
                x_temp = x;
                x_temp = x_temp / pow(2, static_cast<double>(i));
                y = y + x_temp;     // x is NEVER smaller than 0

                by_inv = complement_2(by);         // two's complement
                by_inv = shift_right(by_inv, i);   // y_inv is > 0, -> can be divided by 2 by shifting
                by_inv = complement_2(by_inv);   // two's complement


                bx1 = addbits(bx, by_inv);
                bx_temp = bx;
                bx_temp = shift_right(bx_temp, i);
                by = addbits(by, bx_temp);     //y = y + x/pow(2, static_cast<double>(i));     // x is NEVER smaller than 0

            }
            else {
                y_temp = y;
                y_temp = y_temp / pow(2, static_cast<double>(i));
                y_temp = -y_temp;
                x1 = x + y_temp;

                x_temp = x;
                x_temp = x_temp / pow(2, static_cast<double>(i));
                x_temp = -x_temp;
                y = y + x_temp;
                //y = y - x/pow(2, static_cast<double>(i));   // x is NEVER smaller than 0
               // std::cout << "2. else " << x1 << " " << y << std::endl;


                by_temp = by;
                by_temp = shift_right(by_temp, i);
                by_temp = complement_2(by_temp);
                bx1 = addbits(bx, by_temp);         //x1 = x - y/pow(2, static_cast<double>(i));

                bx_temp = bx;
                bx_temp = shift_right(bx_temp, i);
                bx_temp = complement_2(bx_temp);
                by = addbits(by, bx_temp);

            }
            x = x1;
            bx = bx1;

            if (k) {
                --k;
                break;
            }
            else k = 3;
        }
    }

    *x0 = x;
    *y0 = y;
    bx0 = bx;
    by0 = by;
    std::cout << "bx0: " << bit_to_double(bx0) << "   x0   " << *x0 << std::endl;
}


/** hyperbolic features ********************************************/


double sqrtCordic(double a)
{
    /* 0.03 < a < 2 */
    double x, y;
    BITARRAY bx, by, ba;
    BITARRAY one(pow(2, FPOINT)), one_inv;
    one_inv = complement_2(one);
    ba = double_to_bit(a);

    x = a + 1;
    y = a - 1;

    bx = addbits(ba, one);
    by = addbits(ba, one_inv);
    cordic_02(&x, &y, bx, by);

    bx = mult_0_6037(bx);
    std::cout << "Cordic Bit:    sqrt = "  << bit_to_double(bx) << std::endl;
    return MULT(x, invGain2);
}

int main(void)
{
    double v;
    double x;


    x = 2.;
    v = sqrtCordic(x);
    //w = sqrt_cordic(x, 25);
  //  printf("Cordic Double: sqrt(%f) =  %.18e\n", x, v);
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
