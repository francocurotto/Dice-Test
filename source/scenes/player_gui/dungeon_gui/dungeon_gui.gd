extends Control

#region constants
const CAMERA_SPEED = 0.02
const DRAG_LENGTH = 10
const DIMDICE_HEIGHT = 2
#endregion

#region public functions
var player_gui
#endregion

#region private variables
var dimdice_dragging = false
var dimdice_position = Vector3(0, 2, -3)
#endregion

#region onready variables
@onready var controls = $TouchControls
#endregion

#region builtin functions
func _ready() -> void:
	controls.set_raycast(get_viewport())
	controls.touch_released.connect(on_touch_released)
	controls.dragging.connect(on_dragging)
	controls.drag_released.connect(on_drag_released)
	controls.threshold_exceeded.connect(on_threshold_exceeded)
	Globals.dungeon.dimension_started.connect(func(): controls.disabled = true)
#endregion

#region signals callbacks
func on_dimdice_selected(original_dimdice):
	var dimdice = original_dimdice.clone()
	dimdice.highlight = false
	dimdice.position = dimdice_position
	dimdice.rotation = Vector3.ZERO
	dimdice.basis_to = dimdice.basis
	dimdice.dice_rotation_finished.connect(func(): controls.disabled = false)
	dimdice.body_entered.connect(on_dimdice_collided)
	# add dimdice and net
	Globals.dungeon.dimdice = dimdice
	Globals.dungeon.set_dimnet(player_gui.net)

func on_touch_released():
	var tile = controls.get_touched_object(Globals.LAYERS.TILES)
	if tile:
		dimdice_position = tile.global_position + Vector3(0,DIMDICE_HEIGHT,0)
		Globals.dungeon.on_tile_touched(tile, dimdice_position, player_gui.net)

func on_dragging():
	if dimdice_dragging:
		move_dimdice()
	elif not controls.get_touched_object(Globals.LAYERS.DICE):
		move_camera()

func on_drag_released():
	if dimdice_dragging:
		dimdice_dragging = false
		Globals.dungeon.return_dimdice(dimdice_position)

func on_threshold_exceeded(angle):
	if controls.get_touched_object(Globals.LAYERS.DICE):
		drag_dice(angle)

func on_dimdice_collided(_node):
	var player = player_gui.player
	var net = player_gui.net
	Globals.dungeon.on_dimdice_collided(player, net, dimdice_position)
#endregion

#region private functions
func drag_dice(angle):
	if -135 < angle and angle < -45:
		dimdice_dragging = true
	else:
		controls.disabled = true
		if angle <= -135 or 135 < angle:
			rotate_dimdice_clockwise()
		elif -45 <= angle and angle < 45:
			rotate_dimdice_counter_clockwise()
		elif 45 <= angle and angle < 135:
			flip_dimdice()

func rotate_dimdice_clockwise():
	Globals.dungeon.rotate_dimdice_clockwise()
	player_gui.net.rotate_clockwise()
	Globals.dungeon.set_dimnet(player_gui.net)

func rotate_dimdice_counter_clockwise():
	Globals.dungeon.rotate_dimdice_counter_clockwise()
	player_gui.net.rotate_counter_clockwise()
	Globals.dungeon.set_dimnet(player_gui.net)

func flip_dimdice():
	Globals.dungeon.flip_dimdice()
	player_gui.net.flip()
	Globals.dungeon.set_dimnet(player_gui.net)

func move_dimdice():
	Globals.dungeon.move_dimdice(controls.velocity)

func move_camera():
	var movement = Vector3(controls.velocity.x, 0, controls.velocity.y)
	var delta_position = -1 * CAMERA_SPEED * movement * get_process_delta_time()
	Globals.duel_camera.position += delta_position
#endregion
