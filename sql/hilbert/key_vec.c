/* See LICENSE below for information on rights to use, modify and distribute
   this code. */

/***************************************************************************** 
 * File : key_vec.c 
 *
 * Purpose:  
 *   Functions for computing and manipulating a vector of 
 *   keys for a set of items in a multidimensional coordinate space.
 * 
 * Authors:     John Mellor-Crummey
 *              Dept. of Computer Science
 *              Rice University
 *  
 *              David Whalley
 *              Dept. of Computer Science
 *              Florida State University
 *
 * Date:        09 October 2000
 *
 * Copyright (c) 2000, Rice University
 *
 ****************************************************************************/ 

#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>


#include "key_vec.h"

#include "sortkeys.h"

#if 1
#define DEBUG 1
#endif


/*****************************************************************************
 * forward declarations
 *****************************************************************************/

static void compute_key_vector_va(int n_items, int n_coord_dims, 
				  int bits_key_resolution,
				  getcoords_fn getcoords, 
				  coords_2_key_fn key_c2i,
				  unsigned long long key[],
				  int offset, 
				  va_list extra_args);

void compute_key_vectori_va(int n_items, int n_coord_dims, 
			    int bits_key_resolution,
			    geticoords_fn geticoords,
			    coords_2_key_fn key_c2i,
			    unsigned long long key[], int offset,
			    va_list extra_args);


/*****************************************************************************
 * interface operations
 *****************************************************************************/

/*----------------------------------------------------------------------------
 * Functions: 
 *    c_compute_key_vector  
 *    f_compute_key_vector
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
 *    The function returns a vector "key" of length "n_items"
 *    that contains the key coordinates of each item.
 *
 * History:
 *    May 1999 - created - John Mellor-Crummey 
 *
 *----------------------------------------------------------------------------
 */

void c_compute_key_vectori(int n_items, int n_coord_dims, 
			   int bits_key_resolution, 
			   geticoords_fn geticoords, 
			   coords_2_key_fn key_c2i,
			   unsigned long long key[], int offset, 
			   ...)
{
  
  va_list extra_args;
  
  va_start(extra_args, offset);
  
  compute_key_vectori_va(n_items, n_coord_dims, bits_key_resolution, 
			 geticoords, key_c2i, key, offset, extra_args);
  
  va_end(extra_args);
}

void FORTRAN_ENTRY_POINT(f_compute_key_vectori)
     (int *n_items, int *n_coord_dims, int *bits_key_resolution, 
      geticoords_fn geticoords, coords_2_key_fn key_c2i, 
      unsigned long long key[], int *offset, ...)
{
  
  va_list extra_args;
  
  va_start(extra_args, offset);
  
  compute_key_vectori_va(*n_items, *n_coord_dims, 
			 *bits_key_resolution, 
			 geticoords, key_c2i, key, 
			 *offset, 
			 extra_args);
  
  va_end(extra_args);
}


void c_compute_key_vector(int n_items, int n_coord_dims, 
			  int bits_key_resolution, 
			  getcoords_fn getcoords, 
			  coords_2_key_fn key_c2i,
			  unsigned long long key[], int offset, 
			  ...)
{
  
  va_list extra_args;
  
  va_start(extra_args, offset);
  
  compute_key_vector_va(n_items, n_coord_dims, 
			bits_key_resolution, 
			getcoords, key_c2i, key, offset, 
			extra_args);
  
  va_end(extra_args);
}

void FORTRAN_ENTRY_POINT(f_compute_key_vector)
     (int *n_items, int *n_coord_dims, int *bits_key_resolution, 
      getcoords_fn getcoords, coords_2_key_fn key_c2i, 
      unsigned long long key[], int *offset, ...)
{
 
  va_list extra_args;
		       
  va_start(extra_args, offset);

  compute_key_vector_va(*n_items, *n_coord_dims, 
			*bits_key_resolution, 
			getcoords, key_c2i, key, *offset, 
			extra_args);
 
  va_end(extra_args);
}

/*----------------------------------------------------------------------------
 * Functions:  
 *    c_sort_key_yield_permute
 *    f_sort_key_yield_permute
 *
 * Purpose: 
 *    Given a vector if key coordinates, compute 2 permutations:
 *     - newpos: a mapping from the original position of an item in the
 *               vector of key coordinates to its position
 *               in sorted order, and 
 *     - origpos: a mapping from an item's position in the sorted order 
 *               to its original position.
 *    NOTE: the value "offset" is used to return positions in these vectors
 *          that range from "offset" to "offset + n_items". this is useful
 *          for separately permuting independent subvectors embedded in
 *          a longer vector. 
 *
 * History:
 *    May 1999 - adapted from version by David Whalley - John Mellor-Crummey 
 *
 *----------------------------------------------------------------------------
 */
void c_sort_key_yield_permute(unsigned long long key[],
			      int n_items,
			      int origpos[],
			      int newpos[],
			      int lower_bound,
			      int offset)
{
  int i;

  /* initialize the original positions of the items */
  for (i = offset; i < n_items + offset; i++) {
    origpos[i] = i + lower_bound;
  }

  /* sort the key coordinates and the original positions */
  qsort_key_vector(key, origpos, offset,
		   n_items - 1 + offset);


#if DEBUG 
  {
    unsigned long long current = key[offset];
    for (i = offset + 1; i < n_items + offset; i++) {
      assert(current <= key[i]);
      current = key[i];
    }
  }
#endif
   
  /* now map the original positions to their new positions yielding a new
   * permutation 
   */
  for (i = offset; i < n_items + offset; i++) {
    newpos[origpos[i] - lower_bound] = i + lower_bound;
  }
}

void FORTRAN_ENTRY_POINT(f_sort_key_yield_permute)(unsigned long long key[],
						   int *n_items,
						   int origpos[],
						   int newpos[],
						   int *lower_bound,
						   int *offset)
{
  c_sort_key_yield_permute
    (key, *n_items, origpos, newpos, *lower_bound, *offset);
}



/*****************************************************************************
 * private operations
 *****************************************************************************/

/*----------------------------------------------------------------------------
 * Function: compute_key_vector_va
 *
 * Purpose: 
 *    Compute the key coordinates associated with "n_items" objects,
 *    each of which is known by "n_coord_dims"-dimensional coordinates
 *
 *    A callback function "getcoords" is invoked to extract a vector of
 *    coordinates for each item. getcoords is passed the va_list that is
 *    the trailing parameter of this function.
 * 
 *    The function returns a vector "key" of length "n_items"
 *    that contains the key coordinates of each item.
 *
 * History:
 *    May 1999 - adapted from version by David Whalley - John Mellor-Crummey 
 *
 *----------------------------------------------------------------------------
 */
void compute_key_vector_va(int n_items, int n_coord_dims, 
			   int bits_key_resolution,
			   getcoords_fn getcoords,
			   coords_2_key_fn key_c2i,
			   unsigned long long key[], int offset,
			   va_list extra_args)
{
  /* unsigned bits; */
  unsigned long long maxintval;
  /* int numbits; */
  int i, j; 
  double factor, maxdist;
  int bits_per_coord;
   
   /* pointers for vector temporaries */
  int *intcoords;
  double *min, *max, *coords; 

   /* allocate space for the coordinates that will be used */
  min = malloc(sizeof(double) * n_coord_dims);
  max = malloc(sizeof(double) * n_coord_dims);

  coords = malloc(sizeof(double) * n_coord_dims);
  intcoords = malloc(sizeof(int) * n_coord_dims);

   /* find the minimum and maximum for each coordinate */

   /* initialize min and maximum values using first item's coordinates */
  getcoords(&offset, coords, extra_args);
  for (j = 0; j < n_coord_dims; j++) {
    min[j] = max[j] = coords[j];
  }

  /* scan the coordinates of all of the remaining items */
  for (i = 1+offset; i < n_items+offset; i++) {
    getcoords(&i, coords, extra_args);
     
    for (j = 0; j < n_coord_dims; j++) {
      if (coords[j] < min[j])
	min[j] = coords[j];
      else if (coords[j] > max[j])
	max[j] = coords[j];
    }
  }

  /* determine the number of bits associated with each key
      coordinate */
  bits_per_coord = bits_key_resolution/n_coord_dims;

  maxintval = (((unsigned long long) 1)<< bits_per_coord) - 1;
  /*
   * Determine the factor we will use in the normalization.
    */
  maxdist = (max[0] - min[0]);
  for (j = 1; j < n_coord_dims; j++)
    if (max[j] - min[j] > maxdist)
      maxdist = max[j] - min[j];
  factor = maxintval/maxdist;

   
  /*
    * For each coordinate.
    */
  for (i = offset; i < n_items+offset; i++) {
    getcoords(&i, coords, extra_args);
     
    /*
     * Now normalize to maxintval bits.
     */
    for (j = 0; j < n_coord_dims; j++) {
      intcoords[j] = (coords[j] - min[j]) * factor;

#if DEBUG
      assert( intcoords[j] <= maxintval);
#endif
    }
     
    key[i] = key_c2i(n_coord_dims, bits_per_coord, intcoords);
  }

  /* free temporaries */
  free(min);
  free(max);
  free(coords);
  free(intcoords);
}


/*----------------------------------------------------------------------------
 * Function: compute_key_vectori_va
 *
 * Purpose: 
 *    Compute the key coordinates associated with "n_items" objects,
 *    each of which is known by "n_coord_dims"-dimensional coordinates
 *
 *    A callback function "geticoords" is invoked to extract a vector of
 *    coordinates for each item. getcoords is passed the va_list that is
 *    the trailing parameter of this function.
 * 
 *    The function returns a vector "key" of length "n_items"
 *    that contains the key coordinates of each item.
 *
 * History:
 *    May 1999 - adapted from version by David Whalley - John Mellor-Crummey 
 *
 *----------------------------------------------------------------------------
 */
void compute_key_vectori_va(int n_items, int n_coord_dims, 
			    int bits_key_resolution,
			    geticoords_fn geticoords,
			    coords_2_key_fn key_c2i,
			    unsigned long long key[], int offset,
			    va_list extra_args)
{
#if DEBUG 
  /* unsigned bits; */
  unsigned int maxintval;
#endif

  /* int numbits; */
  int i; 
  int bits_per_coord;
  int maxbitspercoord = (sizeof(unsigned long long) << 3) / n_coord_dims;
   
  /* pointers for vector temporaries */
  int *intcoords;

  intcoords = malloc(sizeof(int) * n_coord_dims);


   /* determine the number of bits associated with each key
      coordinate */
  bits_per_coord = bits_key_resolution/n_coord_dims;

  assert(bits_per_coord <= maxbitspercoord);

#if DEBUG
  maxintval = 
    (~((unsigned long long) 0)) >> (maxbitspercoord - bits_per_coord);
#endif

  /*
    * For each coordinate.
    */
  for (i = offset; i < n_items+offset; i++) {
    geticoords(&i, intcoords, extra_args);
     
#if DEBUG
	{
		int j;
    	for (j = 0; j < n_coord_dims; j++) {
      		assert( intcoords[j] <= maxintval);
    	}
	}
#endif
     
    key[i] = key_c2i(n_coord_dims, bits_per_coord, intcoords);
  }

  /* free temporaries */
  free(intcoords);
}


/* LICENSE
 *
 * This software is copyrighted by Rice University.  It may be freely copied,
 * modified, and redistributed, provided that the copyright notice is 
 * preserved on all copies.
 * 
 * There is no warranty or other guarantee of fitness for this software,
 * it is provided solely "as is".  Bug reports or fixes may be sent
 * to the author, who may or may not act on them as he desires.
 *
 * You may include this software in a program or other software product.
 * 
 * If you modify this software, you should include a notice giving the
 * name of the person performing the modification, the date of modification,
 * and the reason for such modification.
 */
