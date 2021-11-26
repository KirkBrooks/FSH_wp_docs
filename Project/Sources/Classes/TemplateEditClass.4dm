/*  TemplateEditClass ()
 Created by: Kirk as Designer, Created: 11/23/21, 17:28:15
 ------------------

*/
Class extends formBasics

Class constructor($template_e : 4D:C1709.WP_TEMPLATE)
	Super:C1705()
	var WParea : Object  //   because we need this for the dialog
	
	This:C1470.entity:=$template_e
	WParea:=$template_e.wp_body
	
	
	// --------------------------------------------------------
Function save_template->$result_o : Object
	This:C1470.update_fieldData()  //  scan first
	This:C1470.entity.wp_body:=WParea
	$result_o:=This:C1470.entity.save()
	
Function update_fieldData
/*  scan the document for tags and add them to fieldData
if there are not there already. Tags may only contain
letters and underscores in between <  > symbols. 
FieldData is a scalar collection
*/
	var $text : Text
	var $start; $pos; $len : Integer
	var $fields_c : Collection
	
	If (Asserted:C1132(This:C1470.entity#Null:C1517))
		$text:=WP Get text:C1575(WParea)
		$start:=1
		
		If (This:C1470.entity.fieldData=Null:C1517)
			$fields_c:=New collection:C1472()
		Else 
			$fields_c:=This:C1470.entity.fieldData.tags
		End if 
		
		While (Match regex:C1019("<\\w+>"; $text; $start; $pos; $len))
			$tag:=Substring:C12($text; $pos; $len)
			$start:=$pos+$len
			
			//  have we seen it?
			If ($fields_c.indexOf($tag)=-1)
				$fields_c.push($tag)
			End if 
			
		End while 
		
		This:C1470.entity.fieldData:=New object:C1471("tags"; $fields_c)
		
	End if 
	