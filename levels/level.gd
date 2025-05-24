extends Node2D

@export_range(0, 1) var gate_animation_time: float = .3
var can_switch_gate: bool = true

@onready var player: CharacterBody2D = %Player
@onready var world: TileMapLayer = %World
var relevant_cells: Array[Vector2i] = []

func _ready() -> void:
	SwitchStates.switch_toggled.connect(toggle_tiles)
	for cell_cords in world.get_used_cells():
		var cell :TileData = %World.get_cell_tile_data(cell_cords)
		if cell != null:
			var is_gate = cell.get_custom_data("gate")
			if is_gate != null && is_gate == true:
				relevant_cells.append(cell_cords)

func toggle_tiles() -> void:
	if !can_switch_gate:
		return
		
	can_switch_gate = false
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	
	for cell_cord in relevant_cells:
		var cell_data: TileData = world.get_cell_tile_data(cell_cord)
		var progress = cell_data.get_custom_data("progress")
		var atlas_cords: Vector2i = world.get_cell_atlas_coords(cell_cord)
		# extend retracted tiles
		if progress == 0:
			tween.tween_method(\
				func(progress): world.set_cell(cell_cord, 0, atlas_cords, progress + 1), \
				0, 8, gate_animation_time)
			
		# retract extended tiles
		if progress == 8:
			tween.parallel().tween_method(\
				func(progress): world.set_cell(cell_cord, 0, atlas_cords, progress + 1), \
				8, 0, gate_animation_time)
						
	tween.chain().tween_property(self, "can_switch_gate", true, 0)
		
	
