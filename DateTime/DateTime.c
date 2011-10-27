/*
Utility library intended to be called from GT.M programs
to manipulate dates and time as an extension to $Horolog dates

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
#include <time.h>
#include <sys/time.h>
#include <gtmxc_types.h>
#include <stdio.h>

/* start time.h */
extern struct tm *gmtime (__const time_t *__timer) __THROW;
extern struct tm *localtime (__const time_t *__timer) __THROW;
extern time_t time (time_t *__timer) __THROW;
/* end time.h */

/* start sys/time.h */
extern int gettimeofday (struct timeval *__restrict __tv, __timezone_ptr_t __tz) __THROW __nonnull ((1));
/* end sys/time.h */

void getDateTimeH(int count, xc_char_t* value);

/* Quick test
void main()
{
  int i=0;
  char buffer[50];
  for (i=1;i<3;i++)
  {
    getDateTimeH(10,&buffer);
    printf(buffer);
  }
  for (i=1;i<3;i++)
  {
    getDateTimeHUTC(10,&buffer);
    printf(buffer);
  }
  printf("test\n");
} */

/// Create horolog format date string with milliseconds
void getDateTimeHUTC(int count,xc_char_t* value)
{
  struct timeval tv;

  // this gets seconds since epoch and milliseconds in UTC
  gettimeofday(&tv,NULL);

  // number of days between 1840-12-31 and 1970-01-01
  // 47117
  // Days since 1840-12-31 to present
  long days=47117+(tv.tv_sec/86400);
  // Seconds elapsed of current day
  long secs=(tv.tv_sec%86400);
  // Build Horolog format string
  sprintf(value,"%ld,%ld.%06ld\n",days,secs,(long)tv.tv_usec);
}

/// Create horolog format date string in local time adjusted for daylight saving, with milliseconds
void getDateTimeH(int count, xc_char_t* value)
{
  struct timeval tv;
  time_t now;
  struct tm *timestructure;

  // Get timer for local time
  time_t x=time(NULL);

  // this gets seconds and milliseconds of UTC and we are interested in the milliseconds part
  gettimeofday(&tv,NULL);

  // Initialise variables tzname, daylight and timezone
  tzset();
  /* printf("tzname[0]=%s, tzname[1]=%s, daylight=%i, timezone=%i\n",
      tzname[0],tzname[1],daylight,timezone); */
  
  // Get local time and adjust to daylight saving
  // Note this approach is not necessarily portable outside gnu-linux
  timestructure=localtime(&x);
  timestructure->tm_hour+=daylight;
  now=mktime(timestructure);

  // number of days between 1840-12-31 and 1970-01-01
  // 47117
  // Days since 1840-12-31 to present
  long days=47117+(now/86400);
  // Seconds elapsed of current day
  long secs=(now%86400);
  // Build Horolog format string
  sprintf(value,"%ld,%ld.%06ld\n",days,secs,(long)tv.tv_usec);
}
