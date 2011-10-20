/*
Utility library intended to be called from GT.M programs
to manipulate environment variables for various purposes

Copyright (c) 2011 Alex Woodhead

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#include <stdlib.h>
#include <string.h>
#include <gtmxc_types.h>


/* stdlib functions used */
extern int setenv (__const char *__name, __const char *__value, int __replace) __THROW __nonnull ((2));
extern char *getenv (__const char *__name) __THROW __nonnull ((1)) __wur;
extern int unsetenv (__const char *__name) __THROW __nonnull ((1));

/* string.h functions used */
extern char *strncpy (char *__restrict __dest, __const char *__restrict __src, size_t __n);
extern char *strcpy (char *__restrict __dest, __const char *__restrict __src) __THROW __nonnull ((1, 2));

/* 
  Set Environment variable from GTM program
*/
void setEnv(int count, xc_char_t* name, xc_char_t* value)
{
  setenv(name,value,1);
  return;
}

/*
  Return Environment variable to GTM program
  Note string truncation to 4000 bytes
  Similar to using built-in GTM function $ZTRNLNM()
*/
void getEnv(int count, xc_char_t* name, xc_char_t* value)
{
  char *nvalue=getenv(name);
  /* If the environment variable is undefined ensure that a terminated string is retured to GTM */
  if (nvalue==NULL)
  {
    value[0]='\0';
    return;
  } else {
    strncpy(value,nvalue,4000);
    value[4000]='\0';
    return;
  }
}

/*
  Remove an Environment variable from a GTM program
*/
void unsetEnv(int count, const xc_char_t* name)
{
  unsetenv(name);
  return;
}

/*
  Simple test function. Echos a string back to a GTM program
*/
void echo(int count, xc_char_t* in, xc_char_t* out)
{
  strncpy(out,in,4000);
  out[4000]='\0';
  return;
}






