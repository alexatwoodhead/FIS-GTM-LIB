Encryption	; New routine created in Serenji at 3/3/2011 6:09:17 PM
	;Copyright 2011 Sires Consulting, Inc.
	;Distributed under terms of the GNU General Public License version 3 dated 19 November 2007
	;See License Terms at the end of this file
	;
	;various encryption utilities
	q
AESCBCEncrypt(text,key,IV,debug)	;
	n cmd,oldio,etext,x,$ztrap,i,cipher,pad,exactkey,keyarg,ivhex
	s oldio=$i
	s exactkey=1
	if $l(key)<16 s exactkey=0 f  q:$l(key)=16  s key=key_$c(0) 
	if $l(key)>16,$l(key)<24 s exactkey=0 f  q:$l(key)=24  s key=key_$c(0)
	if $l(key)>24,$l(key)<32 s exactkey=0  q:$l(key)=32  s key=key_$c(0)
	s cipher=$s($l(key)=16:"-aes-128-cbc",$l(key)=24:"-aes-192-cbc",1:"-aes-256-cbc")
	if exactkey d  ;using the -K option, needs hex input to openssl
	. s keyarg=""
	. f i=1:1:$l(key) s keyarg=keyarg_$$^%ZBASE($a(key,i),10,16,2)
	. s key=keyarg
	s keyarg=$s(exactkey:"-K "_key,1:"-k "_key)
	;s pad=16-($l(text)#16)
	;if pad<16 s text=text_$e($c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),1,pad)
	if $l($g(IV))'=16 s IV=$c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)  ;null initialize
	s ivhex="" f i=1:1:$l(IV) s ivhex=ivhex_$$^%ZBASE($a(IV,i),10,16,2)
	s cmd="cmd"
	s $zstatus=""
	if $g(debug) w !,"cipher "_cipher_" key length "_$l(key)_" data length "_$l(text)_" exactkey "_exactkey_" iv "_ivhex_" key "_key,!
	s $ztrap="zgoto "_$zlevel_":AESCBCEncodeTrap"
	o cmd:(command="openssl enc "_cipher_" -e -nosalt "_keyarg_" -iv "_ivhex:fixed:record=1)::"PIPE"
	u cmd f i=1:1:$l(text) w $e(text,i)
	u cmd w /EOF
	s etext=""
AESCBCEncodeTrap	;
	;
	s $ztrap="zgoto "_$zlevel_":AESCBCEncodeErr"
	if $zstatus'="",$zstatus'["%SYSTEM" B  
	f  u cmd q:$zeof  r x:1 s etext=etext_x
	c cmd
	u oldio
	q etext
AESCBCEncodeErr	;
	q $zstatus
AESCBCDecrypt(text,key,IV)	
	;
	q text
AESEncode(text,key,debug)	;
	;
	n cmd,oldio,etext,x,$ztrap,i,cipher,pad,ivhex,keyhex
	s oldio=$i
	if $l(key)<16 f  q:$l(key)=16  s key=key_$c(0) 
	if $l(key)>16,$l(key)<24 f  q:$l(key)=24  s key=key_$c(0)
	if $l(key)>24,$l(key)<32 f  q:$l(key)=32  s key=key_$c(0)
	s cipher=$s($l(key)<17:"-aes-128-ecb",$l(key)<25:"-aes-192-ecb",1:"-aes-256-ecb")
	;s cipher="-aes-256-ecb"
	s pad=16-($l(text)#16)
	if pad<16 s text=text_$e($c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),1,pad)
	s keyhex=$$hexit(key)
	s ivhex=$tr($j("",32)," ",0)
	s cmd="cmd"
	s $zstatus=""
	if $g(debug) w !,"cipher "_cipher_" key length "_$l(key)_" data length "_$l(text),!
	s $ztrap="zgoto "_$zlevel_":AESEncodeTrap"
	o cmd:(command="openssl enc "_cipher_" -nosalt -nopad -a -e -K "_keyhex_" -iv "_ivhex:fixed:record=1)::"PIPE"
	;u cmd f i=1:1:$l(key) w $e(key,i)
	;u cmd w $c(10)
	u cmd f i=1:1:$l(text) w $e(text,i)
	u cmd w /EOF
	s etext=""
AESEncodeTrap	;
	;
	s $ztrap="zgoto "_$zlevel_":AESEncodeErr"
	if $zstatus'="",$zstatus'["%SYSTEM" B  
	f  u cmd q:$zeof  r x:1 s etext=etext_x
	c cmd
	u oldio
	q etext
AESEncodeErr	;
	q $zstatus
AESDecode(text,key,debug)	;
	;
	n file,cmd,oldio,etext,x,$ztrap,i,cipher,ivhex,keyhex
	if text'="",$e(text,$l(text))'=$c(10) s text=text_$c(10)
	s oldio=$i
	if $l(key)<16 f  q:$l(key)=16  s key=key_$c(0)
	if $l(key)>16,$l(key)<24 f  q:$l(key)=24  s key=key_$c(0)
	if $l(key)>24,$l(key)<32 f  q:$l(key)=32  s key=key_$c(0)
	s cipher=$s($l(key)=16:"-aes-128-ecb",$l(key)=24:"-aes-192-ecb",1:"-aes-256-ecb")
	s keyhex=$$hexit(key)
	s ivhex=$tr($j("",32)," ",0)
	s cmd="cmd"
	s $zstatus=""
	if $g(debug) w !,"cipher "_cipher," key length "_$l(key),!
	o cmd:(command="openssl enc "_cipher_" -d -nosalt -a -nopad -K "_keyhex_" -iv "_ivhex:fixed:recordsize=1)::"PIPE"
	s $Ztrap="ZGOTO "_$Zlevel_":AESDecodeTrap"
	u cmd f i=1:1:$l(text) w $e(text,i)
	u cmd w /EOF
	s etext=""
AESDecodeTrap	;
	f  u cmd q:$zeof  r x s etext=etext_x
	s $Ztrap="zgoto "_$zlevel_":AESDecodeErr"
	c cmd
	u oldio
	q etext
AESDecodeErr	;
	q $zstatus
Base64Enc(text)	;
	;
	n i,cmd,etext,oldio
	s oldio=$i
	s cmd="cmd"
	o cmd:(command="openssl enc -base64":fixed:recordsize=1)::"PIPE"
	u cmd f i=1:1:$l(text) w $e(text,i)
	u cmd w /EOF
	s etext=""
Base64EncTrap	;
	f  u cmd q:$zeof  r x s etext=etext_x
	s $Ztrap="zgoto "_$zlevel_":Base64EncErr"
	c cmd
	u oldio
	q etext
Base64EncErr	;
	q $zstatus
Base64Dec(text)	;
	n i,cmd,etext,oldio
	s oldio=$i
	s cmd="cmd"
	o cmd:(command="openssl enc -base64 -d":fixed:recordsize=1)::"PIPE"
	u cmd f i=1:1:$l(text) w $e(text,i)
	u cmd w /EOF
	s etext=""
Base64DecTrap	;
	f  u cmd q:$zeof  r x s etext=etext_x
	s $Ztrap="zgoto "_$zlevel_":Base64DecErr"
	c cmd
	u oldio
	q etext
Base64DecErr	;
	q $zstatus
hexit(data)	;
	n return,i
	s return=""	
	f i=1:1:$l(data) s return=return_$$^%ZBASE($a(data,i),10,16,2)
	q return
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

