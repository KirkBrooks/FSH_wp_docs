/*  WP_TEMPLATE ()
 Created by: Kirk as Designer, Created: 11/23/21, 15:50:39
*/

Class extends DataClass

Function create->$template_e : Object
	//  creates a new template entity
	$template_e:=ds:C1482.WP_TEMPLATE.new()
	$template_e.wp_body:=WP New:C1317()
	$template_e.d:=New object:C1471
	$template_e.fieldData:=New object:C1471("tags"; New collection:C1472())
	$template_e.save()