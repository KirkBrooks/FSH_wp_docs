//%attributes = {}
/*  Template_edit ()
 Created by: Kirk as Designer, Created: 11/23/21, 15:47:59
 ------------------
 Purpose: allows editing or creating a template

*/

#DECLARE($template_id : Text)
var $template_e; $formData : Object

//  install_basic_err_handler

If (Count parameters:C259=0)
	CONFIRM:C162("Create a new Template?"; "Yes")
	
	If (isOK)
		$template_e:=ds:C1482.WP_TEMPLATE.create()
	End if 
	
Else 
	$template_e:=ds:C1482.WP_TEMPLATE.get($template_id)
	
	If ($template_e=Null:C1517)
		ALERT:C41("Could not find a template matching those criteria.")
	End if 
End if 



If ($template_e#Null:C1517)
	
	$window:=Open form window:C675("template_edit_dlog"; Plain form window:K39:10)
	SET WINDOW TITLE:C213("Edit Template")
	
	$formData:=cs:C1710.TemplateEditClass.new($template_e)
	
	DIALOG:C40("template_edit_dlog"; $formData)
	
End if 