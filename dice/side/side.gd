@tool
extends Sprite3D

#region export variables
@export_enum("SUMMON", "MOVEMENT", "ATTACK", "DEFENSE", "MAGIC", "TRAP")
var type : String = "SUMMON" :
	set(_type):
		type = _type
		texture = load("res://assets/CREST_%s.svg" % type)
		# reposition mult if summon and not summon
		if type == "SUMMON":
			$Mult.position = Vector3(0,0,0)
		else:
			$Mult.position = Vector3(1.5,-1.5,0)

@export_range(1,9) var mult : int = 1 :
	set(_mult):
		mult = _mult
		$Mult.text = str(mult)
#endregion
