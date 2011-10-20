# Simple utility to set, get and unset environment variables from a GTM program
# Originally requested to overcome the 255 character limit of the command parameter of the GTM open command

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
gcc -c -FPIC -I$gtm_dist EnvironmentVariables.c
# link as shared library
gcc -o libEnvironmentVariable.so -shared EnvironmentVariables.o

# GTM uses the following environment variable to find the External Call Table file
# The external call table file conatins a path to the compiled library libEnvironmentVariable.so
# and describes to GTM how to invoke the inderlying functions
# Note if you choose a different file path be sure to update the path in the first line of the ".xc" file
export GTMXC_EnvironmentVariables=/opt/FIS-GTM-LIB/EnvironmentVariables/EnvironmentVariables.xc
# using "gtm" command alias to invoke mumps direct mode ($gtm_dist/mumps -direct)
gtm
# From the mumps prompt
#-------------------------------------------------------------------
# Example 1. Create a new environment variable
GTM>Do &EnvironmentVariables.setEnv("TestEnvironmentVariable","TestValue")

#-------------------------------------------------------------------
# Example 2. Retrieve an environment variable
GTM>Do &EnvironmentVariables.getEnv("TestEnvironmentVariable",.out)

GTM>Write out
TestValue

#-------------------------------------------------------------------
# Example 3. Remove an environment variable
GTM>Do &EnvironmentVariables.unsetEnv("TestEnvironmentVariable")

GTM>Do &EnvironmentVariables.getEnv("TestEnvironmentVariable",.out)

GTM>Write out


#-------------------------------------------------------------------


