#ifndef bignumshim_h
#define bignumshim_h

#include <stdlib.h>
#include "tommath.h"

#ifdef TOMMATH_PREFIX
#define TOMMATH_ADD_PREFIX(a, b) TOMMATH_ADD_PREFIX_INNER(a, b)
#define TOMMATH_ADD_PREFIX_INNER(a, b) a ## _ ## b

#define BN_new TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_new)
#define BN_init TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_init)
#define BN_is_zero TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_is_zero)
#define BN_bn2bin TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_bn2bin)
#define BN_bin2bn TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_bin2bn)
#define BN_rand_range TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_rand_range)
#define BN_num_bytes TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_num_bytes)
#define BN_num_bits TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_num_bits)
#define BN_free TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_free)
#define BN_mod_exp TOMMATH_ADD_PREFIX(TOMMATH_PREFIX, BN_mod_exp)
#endif

typedef mp_int BIGNUM;

BIGNUM* BN_new(void);
void BN_init(BIGNUM *a);
int BN_is_zero(const BIGNUM *a);
int BN_bn2bin(const BIGNUM *a, unsigned char *b);
BIGNUM* BN_bin2bn(const uint8_t *data, int len, BIGNUM *ret);
int BN_rand_range(BIGNUM *rnd, BIGNUM *range);
int BN_num_bytes(const BIGNUM *a);
int BN_num_bits(const BIGNUM *a);
void BN_free(BIGNUM *a);
int BN_mod_exp(BIGNUM *Y, BIGNUM *G, BIGNUM *X, BIGNUM *P);

#endif /* bignumshim_h */
