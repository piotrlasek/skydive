/* ===========================================================================
--- Functions in C for Postgres for working with zed-order values
--- as postgres "bit varying".
=========================================================================== */

#include "postgres.h"
#include "utils/array.h"
#include "utils/varbit.h"
#include "fmgr.h"
#ifdef PG_MODULE_MAGIC
    PG_MODULE_MAGIC;
#endif

/* ---------------------------------------------------------------------------
--- "int" firstBitSet(VarBit*)
---     position of first set bit of a bitstring?

--- returns position of first "1" in bit string (with first position as 1);
--- and returns 0, otherwise (there was no "1")
------------------------------------------------------------------------------
--- Original from following.
--- author: Allan Kamau
--- source: https://www.postgresql.org/message-id\
---         /ab1ea6540903121110l2a3021d4h6632b206e2419898@mail.gmail.com

--- uses Version 1 Calling Conventions
--------------------------------------------------------------------------- */

int first_bit_set_INNER(VarBit* bitstr) {
    unsigned char *bytes = VARBITS(bitstr);
    int pos = 0;
    int B;

    for (B = 0; B == 0 && B < VARBITBYTES(bitstr); ++B) {
        if (bytes[B] & 128) {
            pos = 1;
            break;
        }
        if (bytes[B] & 64) {
            pos = 2;
            break;
        }
        if (bytes[B] & 32) {
            pos = 3;
            break;
        }
        if (bytes[B] & 16) {
            pos = 4;
            break;
        }
        if (bytes[B] & 8) {
            pos = 5;
            break;
        }
        if (bytes[B] & 4) {
            pos = 6;
            break;
        }
        if (bytes[B] & 2) {
            pos = 7;
            break;
        }
        if (bytes[B] & 1) {
            pos = 8;
            break;
        }
    }

    if (pos > 0)
        return (8*B) + pos;
    else
        return 0;
}

PG_FUNCTION_INFO_V1(firstBitSet);
Datum firstBitSet(PG_FUNCTION_ARGS) {
    PG_RETURN_INT32(first_bit_set_INNER(PG_GETARG_VARBIT_P(0)));
}

/* ---------------------------------------------------------------------------
--- adjAtLevel
---     dim     : the dimensionality of our zoo's
---     zooA    : one zoo as a bigint
---     zooB    : second zoo as a bigint (might be NULL)
--- returns the stratum / level in which the two zoo's are adjacent
--------------------------------------------------------------------------- */

PG_FUNCTION_INFO_V1(adjAtLevel);
Datum adjAtLevel(PG_FUNCTION_ARGS) {
    if (PG_ARGISNULL(1) || PG_ARGISNULL(2))
        PG_RETURN_INT32(0);
    else {
        int     dim     = PG_GETARG_INT32(0);
        VarBit *bitstrA = PG_GETARG_VARBIT_P(1);
        VarBit *bitstrB = PG_GETARG_VARBIT_P(2);

        unsigned char *bytesA = VARBITS(bitstrA);
        unsigned char *bytesB = VARBITS(bitstrB);
        unsigned char xByte;
        int B;
        int pos = 0;
        int byteLen;

        if (VARBITBYTES(bitstrA) < VARBITBYTES(bitstrB))
            byteLen = VARBITBYTES(bitstrA);
        else
            byteLen = VARBITBYTES(bitstrB);

        for (B = 0; pos == 0 && B < byteLen; ++B) {
            xByte = bytesA[B] ^ bytesB[B];

            if (xByte & 128) {
                pos = 1;
                break;
            }
            if (xByte & 64) {
                pos = 2;
                break;
            }
            if (xByte & 32) {
                pos = 3;
                break;
            }
            if (xByte & 16) {
                pos = 4;
                break;
            }
            if (xByte & 8) {
                pos = 5;
                break;
            }
            if (xByte & 4) {
                pos = 6;
                break;
            }
            if (xByte & 2) {
                pos = 7;
                break;
            }
            if (xByte & 1) {
                pos = 8;
                break;
            }
        }

        if (pos > 0)
            PG_RETURN_INT32(((8*B + pos - 1) / dim) + 1);
        else
            PG_RETURN_INT32(((8*B          ) / dim) + 1);
    }
}

/* ---------------------------------------------------------------------------
--- zooAtLevel
---     dim     : the dimensionality of our zoo's
---     level   : level we want the zoo "cut" to
---     zoo     : the zoo to "convert"
--- returns the zoo "converted" to represent tiles at level
--------------------------------------------------------------------------- */

PG_FUNCTION_INFO_V1(zooAtLevel);
Datum zooAtLevel(PG_FUNCTION_ARGS) {
	int     dim   = PG_GETARG_INT32(0);
	int     level = PG_GETARG_INT32(1);
	VarBit *zoo   = PG_GETARG_VARBIT_P(2);

	int     zLen  = VARBITLEN(zoo);
	int     rSize = VARBITTOTALLEN(zLen);
	VarBit *up;
	up = (VarBit *)palloc0(rSize);
	SET_VARSIZE(up, rSize);
	VARBITLEN(up) = zLen;

	int            preserve = dim * level;
	int            byteLen  = VARBITBYTES(zoo);
	unsigned char *zooP     = VARBITS(zoo);

	int i = 0;
	while ((preserve >= 8) && (byteLen > 0)) {
		VARBITS(up)[i] = zooP[i];
		preserve -= 8;
		--byteLen;
		++i;
	}
	if ((preserve  > 0) && (preserve < 8)) {
		switch(preserve) {
			case 1 :
				VARBITS(up)[i] = zooP[i] & 0x80;
				break;
			case 2 :
				VARBITS(up)[i] = zooP[i] & 0xC0;
				break;
			case 3 :
				VARBITS(up)[i] = zooP[i] & 0xE0;
				break;
			case 4 :
				VARBITS(up)[i] = zooP[i] & 0xF0;
				break;
			case 5 :
				VARBITS(up)[i] = zooP[i] & 0xF8;
				break;
			case 6 :
				VARBITS(up)[i] = zooP[i] & 0xFC;
				break;
			case 7 :
				VARBITS(up)[i] = zooP[i] & 0xFE;
				break;
			default :
				VARBITS(up)[i] = zooP[i] & 0xFF;
		}
		--byteLen;
		++i;
	}
	/* Not needed because of the palloc0!
	while (byteLen > 0) {
		VARBITS(up)[i] = 0x00;
		--byteLen;
		++i;
	}
	*/

	PG_RETURN_VARBIT_P(up);
}

