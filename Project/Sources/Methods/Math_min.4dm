//%attributes = {}
//Method:  MATH_Min
//Created by: Kirk Brooks (c) 2002, 2003
//Date Created: Wednesday, November 30, 2005 at 14:39:52
//Last Modified: Wednesday, November 30, 2005 at 14:39:52
//   MATH_Min (real; real{;...}) -> real
//$1 is a number value
//$2 ... $n are number values
//Purpose: return the min value of the series
C_REAL:C285(${1}; $0)
C_REAL:C285($min)
C_LONGINT:C283($i)

$min:=$1  //someplace to start
For ($i; 1; Count parameters:C259)  // loop through the numbers
	If ((${$i})<$min)  // is this value lower
		$min:=${$i}
	End if 
End for 

$0:=$min
