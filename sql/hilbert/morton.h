#ifndef morton_h
#define morton_h

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
 */


unsigned long long morton_c2i(int n_coords,
			      int res_per_coord, unsigned int coords[]);

#endif
