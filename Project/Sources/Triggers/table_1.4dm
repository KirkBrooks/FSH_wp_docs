/*  Trigger on [WP_TEMPLATE] ()
 Created by: Kirk as Designer, Created: 11/23/21, 15:53:12
 ------------------
 Purpose: 

*/

C_LONGINT:C283($0)
$0:=0  // Assume the database request will be granted
meta_update(->[WP_TEMPLATE:1]d:5)

Case of 
	: (Test semaphore:C652("suppressTriggers"))
		//  semaphore to set when doing bulk updates or other
		//  operations where we don't want triggers to fire
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		
	: (Trigger event:C369=On Deleting Record Event:K3:3)
		
End case 
