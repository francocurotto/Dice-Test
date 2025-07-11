extends AspectRatioContainer

#region signals
signal button_focused
signal button_toggled
#endregion

#region onready variables
@onready var dice = %Dice
#endregion

#region public variables
var pressed : bool = false :
	get():
		return %Button.button_pressed
var disabled : bool = false :
	set(_disabled):
		disabled = _disabled
		%Button.disabled = disabled
		%SubViewportContainer.modulate.a = 1-0.7*int(disabled)
#endregion

#region public functions
func set_dice(dice_dict):
	%Dice.set_dice(dice_dict)
#endregion

#region signals callbacks
func _on_button_mouse_entered() -> void:
	%Button.grab_focus()

func _on_button_toggled(toggled_on: bool) -> void:
	button_toggled.emit(toggled_on, self)

func _on_button_focus_entered() -> void:
	button_focused.emit(%Dice)
#endregion
