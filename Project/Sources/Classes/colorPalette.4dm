/*  colorPalette ()
 Created by: Kirk as Designer, Created: 09/24/21, 08:18:20
 ------------------
 Purpose:

*/
Class constructor
	Super:C1705()
	
	This:C1470._palette_to_Storage(This:C1470._getPalette())
	// This.colorPalette:=Storage.colors
	This:C1470._colors_ready:=Storage:C1525.colors#Null:C1517
	
	// --------------------------------------------------------
Function get_color($kind : Text; $select : Variant)->$hex : Text
/*  returns a color hex
$select can be a number (0-6) or a text (used form)
	
*/
	
	Case of 
		: (Not:C34(This:C1470._colors_ready))
		: (Value type:C1509($select)=Is real:K8:4) | (Value type:C1509($select)=Is longint:K8:6)
			$hex:=Storage:C1525.colors[$kind][$select]
			
	End case 
	
Function _useToIndex($use : Text)->$index : Integer
/*  maps the various uses to an index
	
*/
	Case of 
		: ($use="text")
			
		: ($use="main")  //  the main color is the bright instance
			$index:=3
			
	End case 
	
	// --------------------------------------------------------
Function _defaultPalette->$palette : Object
	$palette:=New object:C1471(\
		"primary"; New collection:C1472("#203D54"; "#1A4971"; "#2368A2"; "#3183C8"; "#63A2D8"; "#AAD4F5"; "#EFF8FF"); \
		"gray"; New collection:C1472("#212934"; "#5F6B7A"; "#8895A7"; "#8895A7"; "#CFD6DE"; "#E1E7EC"; "#F8F9FA"); \
		"feature"; New collection:C1472("#124544"; "#1B655E"; "#2A9187"; "#3CAEA3"; "#6ED7D3"; "#A8EEEB"; "#E7FFFE"); \
		"danger"; New collection:C1472("#611818"; "#891B1B"; "#B82020"; "#DC3030"; "#E46464"; "#F5AAAA"; "#FCE8E8"); \
		"warn"; New collection:C1472("#5C4813"; "#8C6D1F"; "#CAA53D"; "#F4CA64"; "#FAE29F"; "#FDF3D7"; "#FFFCF4"); \
		"hilite"; New collection:C1472("#145239"; "#197741"; "#259D58"; "#38C172"; "#74D99F"; "#A8EEC1"; "#E3FCEC"))
	
Function _pathToPalette->$file : 4D:C1709.file
	$file:=Folder:C1567(fk resources folder:K87:11; *).file("form elements/palette.json")
	
Function _savePalette($palette)  //   Update the current palette
/*  may be called from different levels which is why we pass in $palette
Write palette to the user palette json: RESOURCES/form elements/palette.json
	
Update Storage with this new palette too
	
*/
	var $file : 4D:C1709.File
	
	If ($palette#Null:C1517)
		$file:=This:C1470._pathToPalette()
		$file.setText(JSON Stringify:C1217($palette; *))
		
		This:C1470._palette_to_Storage($palette; True:C214)  //  save the palette and force an update
		
	End if 
	
Function _getPalette->$palette : Object  //  returns user palette if defined, default otherwise
	
	If (This:C1470._pathToPalette().exists)
		$palette:=JSON Parse:C1218(This:C1470._pathToPalette().getText())
	Else 
		$palette:=This:C1470._defaultPalette()
	End if 
	
Function _palette_to_Storage($palette : Object; $forceUpdate : Boolean)
	var $update : Boolean
	
	Case of 
		: (Storage:C1525.colors=Null:C1517)
			$update:=True:C214
		: (Count parameters:C259>1)
			$update:=Bool:C1537($forceUpdate)
	End case 
	// --------------------------------------------------------
	If ($update)
		Use (Storage:C1525)
			Storage:C1525.colors:=OB Copy:C1225($palette; ck shared:K85:29)
		End use 
	End if 
	
	// --------------------------------------------------------
	//  conversions
	// --------------------------------------------------------
Function RGBtoHSL($r_; $g_; $b_ : Integer)->$hslObj : Object
/* https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB
Note: rounding to less than 3 decimals can result in rounding errors
between RGBtoHSL and HSLtoRGB
	
*/
	
	var $r; $g; $b; $H; $S; $L; $V; $C; $k; $min : Real
	
	$r:=$r_/255
	$g:=$g_/255
	$b:=$b_/255
	
	$V:=Math_max($r; $g; $b)
	$min:=Math_min($r; $g; $b)  // = V - C
	$C:=$V-$min
	
	//  lightness
	$L:=($V+$min)/2  //  = V - (C/2)
	
	//  hue
	$k:=60
	
	Case of 
		: ($C=0)
			
		: ($V=$r)
			$H:=(($g-$b)/$C)*$k
			
		: ($V=$g)
			$H:=(2+(($b-$r)/$C))*$k
			
		: ($V=$b)
			$H:=(4+(($r-$g)/$C))*$k
			
	End case 
	
	//  saturation
	If ($L=0) | ($L=1)
		$S:=0
	Else 
		$S:=($V-$L)/Math_min($L; 1-$L)
	End if 
	
	$hslObj:=New object:C1471("h"; Round:C94($H; 3); "s"; Round:C94($S; 3); "l"; Round:C94($L; 3))
	
Function HSLtoRGB($h_; $s; $l)->$rgbObj : Object
/*  h = degrees
s & l are percentages: 0 -> 1
*/
	var $r; $g; $b; $h : Real
	
	$h:=$h_/360
	
	If ($s=0)  //  achromatic
		$r:=$l
		$g:=$l
		$b:=$l
		
	Else 
		var $p; $q; $t : Real
		
		If ($l<0.5)
			$q:=$l*(1+$s)
		Else 
			$q:=($l+$s)-($l*$s)
		End if 
		
		$p:=(2*$l)-$q
		
		$r:=This:C1470._hue2rgb($p; $q; $h+(1/3))
		$g:=This:C1470._hue2rgb($p; $q; $h)
		$b:=This:C1470._hue2rgb($p; $q; $h-(1/3))
		
	End if 
	
	$rgbObj:=New object:C1471("r"; Round:C94($r*255; 0); "g"; Round:C94($g*255; 0); "b"; Round:C94($b*255; 0))
	
Function _hue2rgb($p_; $q_; $t_ : Real)->$hue : Real
	var $p; $q; $t : Real
	
	$p:=$p_
	$q:=$q_
	$t:=$t_
	
	If ($t<0)
		$t:=$t+1
	End if 
	
	If ($t>1)
		$t:=$t-1
	End if 
	
	Case of 
		: ($t<(1/6))
			$hue:=$p+(($q-$p)*6*$t)
			
		: ($t<(1/2))
			$hue:=$q
			
		: ($t<(2/3))
			$hue:=$p+(($q-$p)*(0.666666667-$t)*6)
			
		Else 
			$hue:=$p
			
	End case 