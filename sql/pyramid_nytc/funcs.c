/*

*/

#include "postgres.h"
#include "fmgr.h" 

#ifdef PG_MODULE_MAGIC 
    PG_MODULE_MAGIC; 
#endif 

PG_FUNCTION_INFO_V1(morton_enc);

Datum morton_enc(PG_FUNCTION_ARGS) {
    uint32_t xi = (uint32_t) PG_GETARG_UINT32(0);
    uint32_t yi = (uint32_t) PG_GETARG_UINT32(1);

    int64_t d = 0;
    uint64_t x = xi;
    uint64_t y = yi;

    x = (x | (x << 16)) & 0x0000FFFF0000FFFF;
    x = (x | (x << 8)) & 0x00FF00FF00FF00FF;
    x = (x | (x << 4)) & 0x0F0F0F0F0F0F0F0F;
    x = (x | (x << 2)) & 0x3333333333333333;
    x = (x | (x << 1)) & 0x5555555555555555;

    y = (y | (y << 16)) & 0x0000FFFF0000FFFF;
    y = (y | (y << 8)) & 0x00FF00FF00FF00FF;
    y = (y | (y << 4)) & 0x0F0F0F0F0F0F0F0F;
    y = (y | (y << 2)) & 0x3333333333333333;
    y = (y | (y << 1)) & 0x5555555555555555;

    d = x | (y << 1);
    //return d;
    PG_RETURN_INT64(d);
}


/*
uint32_t Compact1By1(uint64_t x) {
   x &= 0x55555555;                  // x = -f-e -d-c -b-a -9-8 -7-6 -5-4 -3-2 -1-0
   x = (x ^ (x >>  1)) & 0x33333333; // x = --fe --dc --ba --98 --76 --54 --32 --10
   x = (x ^ (x >>  2)) & 0x0f0f0f0f; // x = ---- fedc ---- ba98 ---- 7654 ---- 3210
   x = (x ^ (x >>  4)) & 0x00ff00ff; // x = ---- ---- fedc ba98 ---- ---- 7654 3210
   x = (x ^ (x >>  8)) & 0x0000ffff; // x = ---- ---- ---- ---- fedc ba98 7654 3210
   return x;
}

uint32_t morton_dec_x(uint64_t code) {
    return Compact1By1(code >> 0);
}

uint32_t morton_dec_y(uint64_t code) {
    return Compact1By1(code >> 1);
}
*/
