//%attributes = {}
/*  meta_update (pointer)
 Created by: Kirk as Designer, Created: 10/06/21, 15:40:16
 ------------------
 Purpose: utility for updating the meta info - usually from a trigger
Sequence Numbers
Convenient for looking up records using a longint using the method  Get_by_sequenceNumber
Note - uniquness is not enforced. 

*/

C_POINTER:C301($1)
C_OBJECT:C1216($o)

Case of 
	: (Test semaphore:C652("suppressTriggers"))
	: (Type:C295($1->)#Is object:K8:27)  //  only valid for object fields
		
	Else 
		
		If ($1->=Null:C1517)
			$1->:=New object:C1471
		End if 
		
		$o:=$1->
		If ($o.meta=Null:C1517)
			$o.meta:=New object:C1471
		End if 
		
		Case of 
			: (Trigger event:C369=On Saving New Record Event:K3:1)
				$o.meta.seqNum:=Sequence number:C244(Table:C252(Table:C252($1))->)  // provides a way to lookup records using the longint 
				
				$o.meta.created:=New object:C1471("name"; Current user:C182; "date"; String:C10(Current date:C33; ISO date:K1:8; Current time:C178))
				
			: (Trigger event:C369=On Saving Existing Record Event:K3:2)
				If ($o.meta.modified=Null:C1517)
					$o.meta.modified:=New object:C1471
				End if 
				
				If ($o.meta.modified.n=Null:C1517)
					$o.meta.modified.n:=0  //  count of number of changes
				End if 
				
				$o.meta.modified.name:=Current user:C182
				$o.meta.modified.date:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
				$o.meta.modified.n:=$o.meta.modified.n+1
				
		End case 
End case 
