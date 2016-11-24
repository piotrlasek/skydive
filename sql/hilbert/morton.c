#include <assert.h>
#include "morton.h"

#define UNROLL_MORTON_2
#define UNROLL_MORTON_3

/*****************************************************************
 * Function: morton_c2i
 *
 * Description: 
 *   Convert coordinates of an n-dimensional point to its index 
 *   along a Morton space-filling curve.  
 *
 * Inputs:
 *  n_coords:         Number of coordinates.
 *  hi_bit_per_coord: Highest bit to be considered in each coordinate
 *  res_per_coord:    Number of bits resolution in result per coordinate 
 *  coord:            Array of n_coords coordinates.
 *
 * Outputs:
 *  index:      Output index value.  n_coords*res_per_coord bits.
 *
 * Assumptions:
 *      n_coords*bits_per_coord <= 
 *            (sizeof unsigned long long) * (bits_per_byte)
 *
 * NOTES:
 * (1) the interface includes hi_bit_per_coord rather than bits_per_coord.
 *     in certain circumstances, it is useful to compute the morton-style
 *     bit interleavings for ranges of the bits rather than all bits
 *     at once. this interface enables the translation to be performed 
 *     for non-leading ranges of bits. 
 * (2) in addition to the number of operations in the routine prologue,
 *     the unrolled sequences for 2 and 3 coordinates uses only 3 
 *     operations per result bit. the sequence for 4 coordinates uses
 *     3 operations per result bit, plus loop overhead. the default 
 *     sequence uses 4 operations per result bit plus loop overhead.
 *
 * History:
 *  3 December 1999 - created - John Mellor-Crummey
 *  Modified by Aleksandar Donev to fit the same interface as hilbert_c2i on 2/25/01
 *  Also added a Fortran calling point for the function (with extra calling overhead
 *  which can easily be eliminated...
 */
unsigned long long fmorton_c2i(int *nDims, int *nBits, int *coord)
{
return morton_c2i(*nDims, *nBits, coord) ;
}

unsigned long long morton_c2i(int n_coords, 
			      int bits_per_coord, unsigned int coords[])
{
  /* Interface changed to eliminate hi_bit_per_coord by A.Donev */
  int hi_bit_per_coord = bits_per_coord; 
  int res_per_coord = (8*sizeof(unsigned long long)-1)/n_coords; 
  
  unsigned int mask = 1 << (hi_bit_per_coord - 1);
  unsigned long long result = 0;
  
  switch(n_coords) {
  case 2: 
    {
      int coord0 = coords[0];
      int coord1 = coords[1];
#ifdef UNROLL_MORTON_2
      switch(res_per_coord) {
      case 32:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 31:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 30:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 29:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 28:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 27:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 26:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 25:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 24:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 23:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 22:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 21:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 20:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 19:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 18:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 17:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 16:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 15:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 14:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 13:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 12:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 11:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 10:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 9:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 8:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 7:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 6:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 5:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 4:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 3:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 2:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;

      case 1:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;
      }
#else
      int b;
      for (b = res_per_coord; b--; ) {
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; mask >>= 1;
      }
#endif
      break;
    }
  case 3:
   {
      int coord0 = coords[0];
      int coord1 = coords[1];
      int coord2 = coords[2];
#ifdef UNROLL_MORTON_3
      switch(res_per_coord)
      {
      case 32: case 31: case 30: case 29: case 28:
      case 27: case 26: case 25: case 24: case 23:
      case 22:
	assert (0 && "result more than 64 bits");

      case 21:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 20:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 19:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 18:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 17:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 16:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 15:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 14:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 13:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 12:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 11:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 10:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 9:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 8:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 7:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 6:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 5:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 4:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 3:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 2:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;

      case 1:
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;
      }
#else
      int b;
      for (b = hi_bit_per_coord; b--; ) {
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; mask >>= 1;
      }
#endif
      break;
    } 
  case 4:
    {
      int b;
      int coord0 = coords[0];
      int coord1 = coords[1];
      int coord2 = coords[2];
      int coord3 = coords[3];
      for (b = res_per_coord; b--; ) {
	result |= coord0 & mask; result <<= 1;
	result |= coord1 & mask; result <<= 1;
	result |= coord2 & mask; result <<= 1;
	result |= coord3 & mask; mask >>= 1;
      }
      break;
    }
  default:
    {
      int d;
      unsigned int shift = n_coords - 1;
      for (d = 0; d < n_coords; d++ ) {
	unsigned int tmask = mask;
	int coord = coords[d];
	unsigned long long cresult = 0;
	switch(res_per_coord) {
	case 32: case 31: case 30: case 29: case 28: case 27: case 26: 
	case 25: case 24: case 23: case 22: case 21: case 20: case 19: 
	case 18: case 17: case 16: case 15: case 14: case 13: 
	  assert(n_coords == 1 && "result more than 64 bits");

	case 12: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case 11: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case 10: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  9: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  8: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  7: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  6: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  5: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  4: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  3: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  2: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	case  1: cresult |= coord & tmask; cresult <<= shift; tmask >>= 1;
	} 
	result |= (cresult >> d);
      }
      break;
    }
  }

  result >>= hi_bit_per_coord - res_per_coord; 
  return result;
}

