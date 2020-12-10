#include <janet.h>
#include <sys/time.h>

static Janet cfun_binary_search_closest(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 2);
  JanetArray *arr = janet_getarray(argv, 0);
  JanetFunction *c = janet_getfunction(argv, 1);
  int res = -1;
  int bottom = 0;
  int top = arr->count;
  while (res == -1) {
    if (bottom >= top) {
      res = top;
    } else {
      int i = (top - bottom) / 2;
      Janet v = arr->data[bottom + i];
      Janet c_res = janet_call(c, 1, &v);
      int r = janet_unwrap_integer(c_res);
      switch (r) {
      case (-1):
	top = bottom + i;
	break;
      case (0):
	res = bottom + i;
      case (1):
	bottom = bottom + i + 1;
	break;
      }
    }
  }
  return janet_wrap_number(res);
}

static Janet cfun_binary_search_closest_int(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 2);
  JanetArray *arr = janet_getarray(argv, 0);
  int32_t to_find = janet_getinteger(argv, 1);
  int res = -1;
  int bottom = 0;
  int top = arr->count;
  while (res == -1) {
    if (bottom >= top) {
      res = top;
    } else {
      int i = (top - bottom) / 2;
      int32_t v = janet_unwrap_integer(arr->data[bottom + i]);
      if (v > to_find) {
	top = bottom + i;
      } else if (v == to_find) {
	res = bottom + i;
      } else {
	bottom = bottom + i + 1;
      }
    }
  }
  return janet_wrap_number(res);
}

static const JanetReg cfuns[] = {
				 {"binary-search-closest-c", cfun_binary_search_closest, "(binary-search/wat)."},
				 {"binary-search-closest-c-int", cfun_binary_search_closest_int, "(binary-search/wat)."},
				 {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
  janet_cfuns (env, "binary-search", cfuns);
}
