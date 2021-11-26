//%attributes = {}
/*



*/

C_POINTER:C301($ptr)
C_OBJECT:C1216($selection)
C_TEXT:C284($characters; $newMenu; $vt_result)
C_LONGINT:C283($i)
$characters:="•⦁∙●⋅◦￮○‣￭◼︎⁃⋆➧➜➔➨➡︎✦★☻♥︎☺︎☀︎♦︎"
$ptr:=OBJECT Get pointer:C1124(Object subform container:K67:4)

If (Not:C34(Is nil pointer:C315($ptr)))
	If (OB Is defined:C1231($ptr->; "areaPointer"))
		$ptr:=OB Get:C1224($ptr->; "areaPointer")
		$selection:=WP Selection range:C1340($ptr->)
		
		//
		$WParea:=OB Get:C1224($ptr->; "areaName")
		$selection:=WP Selection range:C1340(*; $WParea)
		//
		
		
		
		$newMenu:=Create menu:C408
		
		For ($i; 1; Length:C16($characters))
			If (Character code:C91($characters[[$i]])#65038)
				APPEND MENU ITEM:C411($newMenu; $characters[[$i]])  //+" "+string(character code($characters[[$i]]))
				SET MENU ITEM PARAMETER:C1004($newMenu; -1; $characters[[$i]])
			End if 
		End for 
		
		$vt_result:=Dynamic pop up menu:C1006($newMenu)
		RELEASE MENU:C978($newMenu)
		If ($vt_result#"")
			WP SET ATTRIBUTES:C1342($selection; wk list style type:K81:55; wk custom:K81:159; wk list string format LTR:K81:58; $vt_result)
		End if 
	End if 
End if 

