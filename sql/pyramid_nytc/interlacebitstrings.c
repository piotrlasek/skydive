/*
  Piotr Lasek


*/


#include "postgres.h"
#include "utils/array.h"
#include "utils/varbit.h"
#include "fmgr.h"

#ifdef PG_MODULE_MAGIC
    PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(interlacebitstrings);

Datum interlacebitstrings(PG_FUNCTION_ARGS) {
	VarBit *zooa   = PG_GETARG_VARBIT_P(0);
	VarBit *zoob   = PG_GETARG_VARBIT_P(1);

	int    bLen  = 4*VARBITLEN(zooa);
	int    len   = 4*VARBITTOTALLEN(bLen);

	VarBit *laced;
	laced = (VarBit *)palloc0(len);
	SET_VARSIZE(laced, len);
    VARBITLEN(laced) = bLen;

	int i, ia, ib = 0;

    while (i < len) {
        laced[i++] = zooa[ia++];
        laced[i++] = zoob[ib++];
    }

	PG_RETURN_VARBIT_P(laced);
}

int main() {

    printf("Hello");
}
