#ifndef key_vec_h
#define key_vec_h

#include <stdarg.h>

#include "FortranInterface.h"


/*****************************************************************************
 * type declarations
 *****************************************************************************/
typedef void (*getcoords_fn)(int *itemnum, double coords[], va_list args);
typedef void (*geticoords_fn)(int *itemnum, int coords[], va_list args);
typedef unsigned long long (*coords_2_key_fn)(int n_coord_dims, int bits_per_coord, 
				     int *intcoords);


/*****************************************************************************
 * interface operations
 *****************************************************************************/

/*----------------------------------------------------------------------------
 * Functions: c_compute_key_vector
 *            f_compute_key_vector
 *
 * Purpose: 
 *    Compute the key coordinates associated with "n_items" objects,
 *    each of which is known by "n_coord_dims"-dimensional coordinates
 *
 *    A callback function "getcoords" is invoked to extract a vector of
 *    coordinates for each item. getcoords is passed an uninterpreted
 *    va_list formed from the optional trailing arguments passed to 
 *    compute_key_vector. 
 * 
 *    The function returns a vector "keys" of length "n_items"
 *    that contains the key coordinates of each item.
 *
 * History:
 *    May 1999 - created - John Mellor-Crummey 
 *
 * NOTE: the function  f_compute_key_vector specifies a fortran
 *   interface for the function. the macro FORTRAN_ENTRY_POINT is used to
 *   adjust the name by appending an underscore if necessary to the function
 *   name so it can be called from fortran.
 *----------------------------------------------------------------------------
 */
void c_compute_key_vector(int n_items, int n_coord_dims, 
			      int bits_key_resolution, 
			      getcoords_fn getcoords, 
			      coords_2_key_fn key_c2i, 
			      unsigned long long keys[], int offset, 
			      ...);

void FORTRAN_ENTRY_POINT(f_compute_key_vector)
  (int *n_items, int *n_coord_dims, int *bits_key_resolution, 
   getcoords_fn getcoords, coords_2_key_fn key_c2i, 
   unsigned long long keys[], int *offset, ...);

void c_compute_key_vectori(int n_items, int n_coord_dims, 
			       int bits_key_resolution, 
			       geticoords_fn geticoords, 
			       coords_2_key_fn key_c2i, 
			       unsigned long long keys[], int offset, 
			       ...);

void FORTRAN_ENTRY_POINT(f_compute_key_vectori)
  (int *n_items, int *n_coord_dims, int *bits_key_resolution, 
   geticoords_fn geticoords, coords_2_key_fn key_c2i, 
   unsigned long long keys[], int *offset, ...);

/*----------------------------------------------------------------------------
 * Function: c_sort_key_yield_permute
 *           f_sort_key_yield_permute
 *
 * Purpose: 
 *    Given a vector if key coordinates, compute 2 permutations:
 *     - newpos: a mapping from the original position of an item in the
 *               vector of key coordinates to its position
 *               in sorted order, and 
 *     - origpos: a mapping from an item's position in the sorted order 
 *               to its original position.
 * Inputs:
 *    key: a vector of keys that need to be sorted
 *    n_items: how many keys to sort
 *    offset: sort keys from key[offset .. offset + n_items]
 *    lower_bound: adjust the zero-based permutation indices with this value
 *         (lower_bound can be useful for adjusting the permutation to use 
 *          1-based indexing for Fortran)
 *
 * Outputs:
 *    origpos: a vector that maps from new position to original position
 *    newpos: a vector that maps from original position to new position
 *
 *    the following identity holds: newpos[origpos[i]] = i
 *    
 *    NOTE: the value "offset" is used to return positions in these vectors
 *          that range from "offset" to "offset + n_items". this is useful
 *          for separately permuting independent subvectors embedded in
 *          a longer vector. 
 *
 * History:
 *    May 1999 - adapted from version by David Whalley - John Mellor-Crummey 
 *
 * NOTE: the function  f_sort_key_yield_permute
 *   specifies a fortran interface for the function. the macro 
 *   FORTRAN_ENTRY_POINT is used to adjust the name by appending an 
 *   underscore if necessary to the function name so it can be called 
 *   from fortran.
 *---------------------------------------------------------------------------
 */
void c_sort_key_yield_permute(unsigned long long key[], 
			      int n_items, 
			      int origpos[], 
			      int newpos[],
			      int lower_bound,
			      int offset);

void FORTRAN_ENTRY_POINT(f_sort_key_yield_permute)(unsigned long long key[],
						   int *n_items,
						   int origpos[],
						   int newpos[],
						   int *lower_bound,
						   int *offset);

#endif




