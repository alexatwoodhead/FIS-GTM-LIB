# Utility library intended to be called from GT.M programs
# to manipulate dates and time as an extension to $Horolog dates

# Copyright (c) 2011 Alex Woodhead
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#-------------------------------------------------------------------
# Assumes install path is /opt/FIS-GTM-LIB/
# Unfortunately the *.xc (External Call Table) file does not expand environment varibales for paths
# so this file path is used for in absolute locations
#
# Assumes the environment variable "gtm_dist" points to directory with GTM install
# which contains header file defintions gtmxc_types.h
# compile utility code
gcc -c -FPIC -I$gtm_dist DateTime.c
# link as shared library
gcc -o libDateTime.so -shared DateTime.o

# GTM uses the following environment variable to find the External Call Table file
# The external call table file conatins a path to the compiled library libEnvironmentVariable.so
# and describes to GTM how to invoke the inderlying functions
# Note if you choose a different file path be sure to update the path in the first line of the ".xc" file
export GTMXC_DateTime=/opt/FIS-GTM-LIB/DateTime/DateTime.xc
# using "gtm" command alias to invoke mumps direct mode ($gtm_dist/mumps -direct)
gtm
# From the mumps prompt
#-------------------------------------------------------------------
# Example 1. Write out horolog with millisecond. (Like $Horolog function, is adjusted to timezone and daylight saving)

GTM>Write $H
62391,3524
GTM>Do &DateTime.getH(.out)
62391,3528.757631
GTM>Write out

#-------------------------------------------------------------------
# Example 2. Write out holog with millisecond in UTC

GTM>Write $H
62391,3595
GTM>Do &DateTime.getHUTC(.out)

GTM>Write out
62390,86397.717043
#-------------------------------------------------------------------

