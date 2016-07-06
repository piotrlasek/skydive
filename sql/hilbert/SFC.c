/* make it possible to at least NAME the SFC functions from Fortran */

#define FORTRAN_ENTRY_POINT(name) name##_

#define fhilbert_c2i       FORTRAN_ENTRY_POINT(fhilbert_c2i) // Added by A. Donev
#define fmorton_c2i        FORTRAN_ENTRY_POINT(fmorton_c2i)

#include "hilbert.c"
#include "morton.c"
