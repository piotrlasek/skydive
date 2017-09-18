#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int64_t morton_enc(uint32_t xi, uint32_t yi) {
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
    return d;
}

void main(void) {

    printf("morton code test\n");
    uint32_t x = 2146941188;
    uint32_t y = 2147097832;

    uint64_t z = morton_enc(x,y);

    printf("%" PRIu64 "\n", z);


}
