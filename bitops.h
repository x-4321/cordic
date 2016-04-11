#ifndef BITOPS
#define BITOPS

/**
  In this file, the operations on bits are specified, for example the addition, shifts, ...


**/
#define BITS 9     // width of one number,     you can change it to any number, for example 20
#define FPOINT 4   // 4 indices after decimal point, you can change it to any number
typedef std::bitset<BITS> BITARRAY;



BITARRAY addbits(BITARRAY &a, BITARRAY &b)
{
  BITARRAY c;
  BITARRAY carry;


  c[0] = a[0] ^ b[0];
  carry[0] = a[0] && b[0];
  for(int i = 1; i < BITS; ++i)
  {
    c[i] = (a[i] ^ b[i]) ^ carry[i - 1];
    carry[i] = (a[i] && b[i] && carry[i-1]) ||
               (a[i] && b[i]) ||
               (a[i] && carry[i-1]) ||
               (b[i] && carry[i-1]);
  }
  return c;
}

BITARRAY complement_2(BITARRAY a)
{
  for(int i = 0; i < BITS; ++i)
  {
    a[i] = ! a[i];
  }
  BITARRAY b(1);
  return addbits(a, b);
}

BITARRAY double_to_bit(double a)
{
  BITARRAY result;
  if(a < 0)
  {
    a += pow(2, BITS - FPOINT - 1);
    result[BITS - 1] = 1;
  }
  for(int i = BITS - 2; i >= 0; --i)  // i is index of BITARRAY
  {
    if (a - pow(2, i - FPOINT) >= 0)
    {
      a =  a - pow(2, i - FPOINT);
      result[i] = true;
    }
  }
  //std::cout << "double to bit " << temp << "  " << result << std::endl;

  return result;
}

double bit_to_double(BITARRAY a)
{
  double result = 0.;
  if (a[a.size()-1] == 1) result = -pow(2, BITS - FPOINT - 1);
  for(int i = 0; i < static_cast<int>(a.size() - 1); ++i)
  {
    result += a[i] * pow(2, i - (FPOINT));
  }
  return result;
}


BITARRAY shift_right(BITARRAY input, int shifts)
{
  //bool sign_bit = input[0];

  if (shifts >= BITS)
  {
    input.reset();
    return input;
  }
  if(input[BITS] != 0) std::cout << "Warning: MSB is shifted! (2 complement)" << std::endl;
  for(int i = 0; i < BITS - shifts;  ++i)  // sign bit  (input[0]) stays the same
  {
    input[i] = input[i + shifts];
  }

  for(int i = BITS - shifts; i < BITS; ++i)
    input[i] = 0;

  return input;
}

#endif // BITOPS

