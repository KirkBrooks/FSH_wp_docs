/*  formBasics ()
 Created by: Kirk as Designer, Created: 09/23/21, 17:33:10
 ------------------
 Purpose: basic functions for all forms

*/

Class constructor
	This:C1470.colors:=cs:C1710.colorPalette.new()
	
Function UI_message($input : Variant; $group : Text)
/*  $kind = color group: primary (default) / warn / feature / danger / hilite
*/
	var $message; $colorGroup_t : Text
	var $window : Integer
	var $formObject : Object
	
	If (Count parameters:C259>=1)
		$message:=String:C10($input)
		$colorGroup_t:="primary"
		
		If ($message#"")  //  do nothing if no message
			
			If (Count parameters:C259>1)
				$colorGroup_t:=$group
			End if 
			
			$formObject:=This:C1470._ui_message($colorGroup_t)
			
			$window:=Open form window:C675($formObject; Sheet form window:K39:12)
			
			DIALOG:C40($formObject; New object:C1471("message"; $message))
			
		End if 
	End if 
	
Function UI_confirm($input : Variant; $confirmText; $rejectText; $group : Text)->$confirmed : Boolean
	var $formObject; $btn_obj; $params : Object
	var $message; $colorGroup_t : Text
	var $window : Integer
	
	If (Count parameters:C259>=3)
		$message:=String:C10($input)
		$colorGroup_t:="primary"
		
		If (Count parameters:C259>3)
			$colorGroup_t:=$group
		End if 
		
		If ($message#"")
			
			$formObject:=This:C1470._ui_message($colorGroup_t)
			
			// set the confirmButton text
			$btn_obj:=$formObject.pages[1].objects.confirmButton
			$btn_obj.text:=$confirmText
			
			//  add the cancel button
			$params:=New object:C1471("name"; "cancelButton"; "x"; 257; "y"; 133; "width"; 110; "height"; 28)
			$params.text:=$rejectText
			$params.colorGroup_t:=$colorGroup_t
			$params.action:="cancel"
			$params.isSolid:=False:C215
			This:C1470._oval_button($formObject.pages[1].objects; $params)
			
			$window:=Open form window:C675($formObject; Sheet form window:K39:12)
			
			DIALOG:C40($formObject; New object:C1471("message"; $message))
			$confirmed:=OK=1
			
		End if 
	End if 
	
Function UI_request($input : Variant)
	
	// --------------------------------------------------------
	//  Form JSONs
	//  small, short forms used by this class
	// --------------------------------------------------------
Function _ui_message($colorGroup_t)->$formObject : Object
/*  default form dims:  500 x 150
	
*/
	var $objects; $params : Object
	
	ASSERT:C1129(Count parameters:C259=1)
	
	$formObject:=This:C1470._form()
	
	// --------------------------------------------------------
	$objects:=This:C1470.add_page($formObject)  //  Page 0
	
	$params:=New object:C1471("name"; "rect_accent"; "x"; 0; "y"; 0; "width"; 500; "height"; 14)
	$params.sizingX:="grow"
	$params.fill:=This:C1470.colors.get_color($colorGroup_t; 3)
	$params.stroke:="transparent"
	This:C1470._rectangle($objects; $params)
	
	$params.name:="rect_bg"
	$params.y:=15
	$params.height:=160
	$params.sizingY:="grow"
	$params.fill:="white"  //This.colors.get_color($colorGroup_t; 6)
	This:C1470._rectangle($objects; $params)
	
	$params.name:="rect_frame"
	$params.x:=9
	$params.y:=22
	$params.width:=478
	$params.height:=106
	$params.borderRadius:=6
	$params.stroke:=This:C1470.colors.get_color($colorGroup_t; 4)
	OB REMOVE:C1226($params; "fill")
	This:C1470._rectangle($objects; $params)
	
	// $formObject.pages.push(New object("objects"; $objects))
	
	// --------------------------------------------------------
	$objects:=This:C1470.add_page($formObject)  //  Page 1
	$params:=New object:C1471("name"; "message"; "x"; 19; "y"; 31; "width"; 445; "height"; 85)
	$params.sizingY:="grow"
	$params.sizingX:="grow"
	$params.stroke:=This:C1470.colors.get_color("gray"; 2)
	$params.scrollbarVertical:="automatic"
	$params.fontSize:=18
	$params.dataSource:="Form:C1466.message"
	This:C1470._input($objects; $params)
	
	$params:=New object:C1471("name"; "confirmButton"; "x"; 377; "y"; 133; "width"; 110; "height"; 28)
	$params.text:="Close"
	$params.colorGroup_t:=$colorGroup_t
	$params.action:="accept"
	$params.isSolid:=True:C214
	This:C1470._oval_button($objects; $params)
	
	// $formObject.pages.push(New object("objects"; $objects))
	
	// --------------------------------------------------------
	//  form elements
	//  name, x, y, width & height are required for all elements
	// --------------------------------------------------------
Function _form()->$formObject : Object
	$formObject:=New object:C1471()
	$formObject.$4d:=New object:C1471("version"; "1"; "kind"; "form")
	$formObject.windowSizingX:="variable"
	$formObject.windowSizingY:="variable"
	$formObject.windowMinWidth:=100
	$formObject.windowMinHeight:=100
	$formObject.windowMaxWidth:=900
	$formObject.windowMaxHeight:=1200
	$formObject.rightMargin:=0
	$formObject.bottomMargin:=0
	$formObject.events:=New collection:C1472("onLoad")
	$formObject.windowTitle:=""
	$formObject.destination:="detailScreen"
	$formObject.pages:=New collection:C1472()
	
Function add_page($formObject : Object)->$pageObj : Object
	$pageObj:=New object:C1471()
	$formObject.pages.push(New object:C1471("objects"; $pageObj))
	
Function get_pageObject($formObject : Object; $pageNumber : Integer)->$pageObj : Object
	$pageObj:=$formObject.pages[$pageNumber]
	
Function _rectangle($objects; $params : Object)
	var $object : Object
	
	$object:=New object:C1471("type"; "rectangle")
	This:C1470._p_position($object; $params)
	This:C1470._p_sizing($object; $params)
	This:C1470._p_strokeFill($object; $params)
	This:C1470._p_eventsAction($object; $params)
	
	$object.borderRadius:=Num:C11($params.borderRadius)
	
	$objects[String:C10($params.name)]:=$object
	
Function _button_bevel($objects; $params : Object)
	var $object : Object
	$object:=New object:C1471("type"; "button"; "style"; "bevel")
	This:C1470._p_button($object; $params)
	$object.text:=String:C10($params.text)
	$objects[String:C10($params.name)]:=$object
	
Function _button_custom($objects; $params : Object)
	var $object : Object
	$object:=New object:C1471("type"; "button"; "style"; "custom")
	This:C1470._p_button($object; $params)
	$object.text:=String:C10($params.text)
	$objects[String:C10($params.name)]:=$object
	
Function _button_picture($objects; $params : Object)
	var $object : Object
	$object:=New object:C1471("type"; "pictureButton")
	This:C1470._p_button($object; $params)
	$objects[String:C10($params.name)]:=$object
	
Function _input($objects; $params : Object)
	var $object : Object
	$object:=New object:C1471("type"; "input")
	This:C1470._p_position($object; $params)
	This:C1470._p_sizing($object; $params)
	This:C1470._p_strokeFill($object; $params)
	This:C1470._p_eventsAction($object; $params)
	
	This:C1470._p_addProperty($object; $params; "dataSource")
	$object.showSelection:=True:C214  //  just a good idea
	$object.enterable:=Bool:C1537($params.enterable)
	$object.focusable:=Bool:C1537($params.focusable)
	This:C1470._p_addProperty($object; $params; "scrollbarVertical")
	This:C1470._p_addProperty($object; $params; "scrollbarHorizontal")
	This:C1470._p_addProperty($object; $params; "fontSize")
	This:C1470._p_addProperty($object; $params; "borderStyle"; "none")
	
	$objects[String:C10($params.name)]:=$object
	
Function _button_accept($x; $y; $width; $height; $text : Text)->$object : Object
	
	ASSERT:C1129(Count parameters:C259=5)
	
	$object:=New object:C1471(\
		"type"; "button"; \
		"text"; $text; \
		"top"; $x; \
		"left"; $y; \
		"width"; $width; \
		"height"; $height; \
		"events"; New collection:C1472("onClick"); \
		"sizingX"; "move"; \
		"sizingY"; "move"; \
		"action"; "accept"; \
		"focusable"; False:C215; \
		"shortcutAccel"; False:C215; \
		"shortcutControl"; False:C215; \
		"shortcutShift"; False:C215; \
		"shortcutAlt"; False:C215; \
		"shortcutKey"; "[Enter]")
	
Function _button_cancel($x; $y; $width; $height; $text : Text)->$object : Object
	
	ASSERT:C1129(Count parameters:C259=5)
	
	$object:=New object:C1471(\
		"type"; "button"; \
		"text"; $text; \
		"left"; $x; \
		"top"; $y; \
		"width"; $width; \
		"height"; $height; \
		"events"; New collection:C1472("onClick"); \
		"sizingX"; "move"; \
		"sizingY"; "move"; \
		"action"; "cancel"; \
		"focusable"; False:C215; \
		"shortcutAccel"; False:C215; \
		"shortcutControl"; False:C215; \
		"shortcutShift"; False:C215; \
		"shortcutAlt"; False:C215; \
		"shortcutKey"; "[Esc]")
	
Function _text_message($x; $y; $width; $height; $stroke : Text)->$object : Object
	
	$object:=New object:C1471(\
		"type"; "input"; \
		"left"; $x; \
		"top"; $y; \
		"width"; $width; \
		"height"; $height; \
		"sizingX"; "grow"; \
		"sizingY"; "grow"; \
		"enterable"; False:C215; \
		"focusable"; False:C215; \
		"showSelection"; True:C214; \
		"stroke"; $stroke; \
		"borderStyle"; "none"; \
		"dataSource"; "Form.message"; \
		"fontSize"; 18; \
		"scrollbarVertical"; "automatic")
	
Function _line($x; $y; $x1; $y1; $width; $stroke : Text)->$object : Object
/*  lines are drawn from point to point: x, y, x1, y1
strokeWidth sets the line width.
*/
	ASSERT:C1129(Count parameters:C259=6)
	$object:=New object:C1471(\
		"type"; "line"; \
		"left"; $x; \
		"top"; $y; \
		"right"; $x1; \
		"bottom"; $y1; \
		"stroke"; $stroke; \
		"strokeWidth"; $width)
	
Function _oval_button($objects; $params : Object)
/*  adds an oval button to a page object
The oval button has two parts: the oval background and the overlay button
 name: name of the button object - oval will be <name>_oval
 $x; $y; $width; $height; $text  - as usual
 colorGroup_t:
 action:
 sizingY, sizingX: move/fixed/grow
 isSolid: bool:  true= solid fill, no border; false=light fill, dark border
	
$objects is the form page object
*/
	
	ASSERT:C1129(Count parameters:C259=2)
	
	var $name; $sizingX; $sizingY; $colorGroup_t : Text
	var $radius : Integer
	var $oval; $button : Object
	
	$name:=String:C10($params.name)
	$colorGroup_t:=String:C10($params.colorGroup_t)
	
	//  start with the elements common to both
	$oval:=New object:C1471("type"; "rectangle")
	This:C1470._p_position($oval; $params)
	This:C1470._p_sizing($oval; $params)
	
	$button:=OB Copy:C1225($oval)
	This:C1470._p_strokeFill($oval; $params)
	$oval.borderRadius:=($params.height\2)-1
	
	$button.type:="button"
	$button.text:=String:C10($params.text)
	$button.style:="custom"
	
	If (Bool:C1537($params.isSolid))  //  fill is primary
		$oval.fill:=This:C1470.colors.get_color($colorGroup_t; 3)
		$button.stroke:=This:C1470.colors.get_color($colorGroup_t; 6)
	Else 
		$oval.fill:=This:C1470.colors.get_color($colorGroup_t; 6)
		$oval.strokeWidth:=2
		$oval.stroke:=This:C1470.colors.get_color($colorGroup_t; 3)
		$button.stroke:=This:C1470.colors.get_color($colorGroup_t; 3)
	End if 
	
	If (String:C10($params.action)#"")
		$button.action:=String:C10($params.action)
	End if 
	
	$objects[$name+"_oval"]:=$oval
	$objects[$name]:=$button
	// --------------------------------------------------------
	//  functions for filling in $params values
	//  omit un-used properties
	
Function _p_addProperty($object; $params : Object; $property : Text; $value : Variant)
	//  if property is defined in params add to object
	//  $value is written if no $params value
	Case of 
		: ($params[$property]#Null:C1517)
			$object[$property]:=$params[$property]
			
		: (Value type:C1509($value)#Is undefined:K8:13)
			$object[$property]:=$value
	End case 
	
Function _p_position($object; $params : Object)  //  populate $object with x,y,width, height
	$object.left:=Num:C11($params.x)
	$object.top:=Num:C11($params.y)
	$object.width:=Num:C11($params.width)
	$object.height:=Num:C11($params.height)
	
Function _p_sizing($object; $params : Object)  //  add sizing properties if needed
	If (String:C10($params.sizingX)#"")
		$object.sizingX:=$params.sizingX
	End if 
	
	If (String:C10($params.sizingY)#"")
		$object.sizingY:=$params.sizingY
	End if 
	
Function _p_strokeFill($object; $params : Object)
	
	If (String:C10($params.stroke)#"")
		$object.stroke:=$params.stroke
	Else 
		$object.stroke:="transparent"  //   otherwise it defaults to plain
	End if 
	
	If (String:C10($params.strokeWidth)#Null:C1517) & (\
		($object.type="rectangle") | ($object.type="circle") | ($object.type="oval"))
		$object.strokeWidth:=Num:C11($params.strokeWidth)
	End if 
	
	If (String:C10($params.fill)#"") & ($object.type#"button")
		$object.fill:=$params.fill
	End if 
	
Function _p_eventsAction($object; $params : Object)  //  sets the action and events
	If ($params.action#Null:C1517)
		$object.action:=$params.action
	End if 
	
/*  EVENTS
In general I like to handle object events on the form method
*/
	If (Value type:C1509($params.events)=Is collection:K8:32)
		$object.events:=$params.events
	End if 
	
Function _p_button($object; $params : Object)  //  all the button stuff
	This:C1470._p_position($object; $params)
	This:C1470._p_sizing($object; $params)
	This:C1470._p_strokeFill($object; $params)
	This:C1470._p_eventsAction($object; $params)
	
	//  shortcuts
	This:C1470._p_addProperty($object; $params; "shortcutAccel")
	This:C1470._p_addProperty($object; $params; "shortcutControl")
	This:C1470._p_addProperty($object; $params; "shortcutShift")
	This:C1470._p_addProperty($object; $params; "shortcutAlt")
	This:C1470._p_addProperty($object; $params; "shortcutKey")
	
	If (String:C10($params.popupPlacement)="linked")  //  only one
		$object.popupPlacement:="linked"
	End if 
	
	If ($params.file#Null:C1517)  //   image or icon
		//  we use limited options here
		
		Case of 
			: ($object.type="pictureButton")
				$object.picture:=$params.file
				$object.rowCount:=4
				$object.useLastFrameAsDisabled:=True:C214
				$object.switchBackWhenReleased:=True:C214
				$object.switchWhenRollover:=True:C214
				$object.loopBackToFirstFrame:=True:C214
				
			Else 
				$object.icon:=$params.file
				$object.iconFrames:=4
		End case 
	End if 
	
	