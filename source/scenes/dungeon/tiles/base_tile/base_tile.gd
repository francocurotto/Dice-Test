@tool
extends StaticBody3D

#region constants
const COLOR = Color(0.2,0.2,0.3)
const PathTile = preload("res://scenes/dungeon/tiles/path_tile/path_tile.tscn")
const BlockTile = preload("res://scenes/dungeon/tiles/block_tile/block_tile.tscn")
#endregion

#region export variables
@export_enum("EMPTY", "PATH", "BLOCK") var type : String = "EMPTY" :
	set(_type):
		type = _type
		if $OverTile.get_child_count() >= 1:
			$OverTile.get_child(0).queue_free()
		if type == "PATH":
			var path_tile = PathTile.instantiate()
			path_tile.player = player
			$OverTile.add_child(path_tile)
		elif type == "BLOCK":
			$OverTile.add_child(BlockTile.instantiate())

@export_range(0,2) var player : int = 1 :
	set(_player):
		player = _player
		if type == "PATH":
			var path_tile = $OverTile.get_child(0)
			path_tile.player = player

@export var monster_lord : bool :
	set(_monster_lord):
		monster_lord = _monster_lord
		if type == "PATH":
			var path_tile = $OverTile.get_child(0)
			path_tile.monster_lord = monster_lord

@export var vortex : bool = false :
	set(_vortex):
		vortex = _vortex
		if type == "PATH":
			var path_tile = $OverTile.get_child(0)
			path_tile.vortex = vortex

@export var highlight : bool = false :
	set(_highlight):
		highlight = _highlight
		$Sprite3D.modulate = COLOR
		if highlight_tween:
			highlight_tween.kill()
		if highlight:
			highlight_tween = create_tween()
			highlight_tween.set_loops()
			highlight_tween.tween_property($Sprite3D, "modulate", Color.YELLOW, 1)
			highlight_tween.tween_property($Sprite3D, "modulate", COLOR, 1)
		if $OverTile.get_child_count() >= 1:
			$OverTile.get_child(0).highlight = highlight
#endregion

#region private variables
var highlight_tween
#endregion
