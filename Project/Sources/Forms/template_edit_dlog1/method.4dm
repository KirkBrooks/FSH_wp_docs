/*  template_edit_dlog ()
 Created by: Kirk as Designer, Created: 11/23/21, 16:05:40
 ------------------
 Purpose: 

*/


var $ui_msg; $objectName_t; $formAction_t : Text
var $result_o : Object

If (Form:C1466#Null:C1517)
	$objectName_t:=String:C10(FORM Event:C1606.objectName)
	
	Case of 
		: (Form event code:C388=On Load:K2:1)  //  catches all objects
			$viewProps:=New object:C1471
			$viewProps[wk zoom:K81:283]:=175  //  so I can read the stupid thing
			WP SET VIEW PROPERTIES:C1648(WPArea; $viewProps)
			
			SET WINDOW TITLE:C213("Template: "+Form:C1466.entity.title)
			
		: (Form event code:C388=On Clicked:K2:4)
			
			Case of 
				: ($objectName_t="btn_scan")
					Form:C1466.update_fieldData()
					//  Form.entity.fieldData.tags:=Form.entity.fieldData.tags
					
				: ($objectName_t="btn_save")
					
					$result_o:=Form:C1466.save_template()
					If ($result_o.success=False:C215)
						$ui_msg:="Could not save the template. \r\r"+$result_o.error
					End if 
					
				: ($objectName_t="btn_close")
					$result_o:=Form:C1466.save_template()
					
					If ($result_o.success=True:C214)
						ACCEPT:C269
					Else 
						CONFIRM:C162("Could not save the template.\r\r"+$result_o.error+"\r\rDo you want to close anyway? ")
						If (isOK)
							CANCEL:C270
						End if 
					End if 
					
			End case 
			
		: (Form event code:C388=On Data Change:K2:15)
			
			SET WINDOW TITLE:C213("Template: "+Form:C1466.entity.title)
			
		: (Form event code:C388=On Selection Change:K2:29)
	End case 
	
	// Form.UI_message($ui_msg)
	
Else 
	ALERT:C41("This form must can only be used when called by 'Template_edit'.")
	CANCEL:C270
End if 

