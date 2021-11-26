//%attributes = {}
//Method:  MATH_Max
//Created by: Kirk Brooks (c) 2005
//                                 kirk@kirk-brooks.com
//Date Created: Friday, February 4, 2005 at 16:25:14
//Last Modified: Friday, February 4, 2005 at 16:25:14
//--------------------    Method Parameters    -------------------------------
// MATH_Max (real; rea{;...}) -> real
//$1 is a number value
//$2 ... $n are number values
//Purpose: return the max value of the series

C_REAL:C285(${0})
C_REAL:C285($max)
C_LONGINT:C283($i)

$max:=$1  //someplace to start

For ($i; 1; Count parameters:C259)
	If (${$i}>$max)
		$max:=${$i}
	End if 
End for 

$0:=$max