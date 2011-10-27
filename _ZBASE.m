%ZBASE(VALUE,FROM,TO,WIDTH)	;CONVERT BASE OF NUMBER
	;Copyright 2011 Sires Consulting, Inc.
	;Distributed under terms of the GNU General Public License version 3 dated 19 November 2007
	;See License Terms at the end of this file
	;
	;VALUE=VALUE TO CONVERT
	;FROM = BASE TO CONVERT FROM (2-36)
	;TO = BASE TO CONVERT TO (2-36)
	N NEW,I,J,K,DEC,CHAR,VAL,STRING
	S STRING="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	S DEC=0,EXP=0
	F I=$L(VALUE):-1:1 D
	. S CHAR=$E(VALUE,I)
	. S VAL=$F(STRING,CHAR)-2*(FROM**EXP)
	. S DEC=DEC+VAL
	. S EXP=EXP+1
	I TO=10 S NEW=DEC G FORMAT
	S NEW="",BIG=0
	F EXP=1:1 S BIG=TO**EXP  Q:BIG'<DEC
	I BIG'=DEC S EXP=EXP-1
	F I=EXP:-1:0 D
	. I I=0 S NEW=NEW_$E(STRING,DEC+1) Q
	. S BIG=TO**I
	. S NEW=NEW_$E(STRING,DEC\BIG+1) S DEC=DEC#BIG
FORMAT	;
	I $G(WIDTH)="" Q NEW
	S FILL=10**WIDTH*10
	S FILL=$E(FILL,2,$L(FILL))
	S NEW=$E(FILL,1,WIDTH-$L(NEW))_NEW
	Q NEW
LicenseInformation	;
	;This program is free software: you can redistribute it and/or modify
	;it under the terms of the GNU General Public License as published by
	;the Free Software Foundation, either version 3 of the License, or
	;(at your option) any later version.
	;
	;This	program is distributed in the hope that it will be useful,
	;but	WITHOUT ANY WARRANTY; without even the implied warranty of
	;MERCHANTABILITY	or FITNESS FOR A PARTICULAR PURPOSE.  See the
	;GNU	General Public License for more details.
	;
	;You	should have received a copy of the GNU General Public License
	;along	with this program.  If not, see <http://www.gnu.org/licenses/>.
