extends Node2D

var can_switch_world: bool = true

@onready var player: CharacterBody2D = %Player
@onready var worlds: Array[TileMapLayer]:
	get:
		var ws: Array[TileMapLayer] = []
		for w in self.get_children(true).filter(func(c): return c is TileMapLayer):
			ws.append(w)	
		return ws
var relevant_cells: Array[Vector2i] = []

func _ready() -> void:
	SwitchStates.switch_toggled.connect(toggle_tiles)
	for world in worlds:
		for cell_cords in world.get_used_cells():
			var cell :TileData = world.get_cell_tile_data(cell_cords)
			if cell != null:
				var is_world = cell.get_custom_data("gate")
				if is_world != null && is_world == true:
					relevant_cells.append(cell_cords)
				
	if SwitchStates.gate_state == true:
		toggle_tiles(0)
		
	Inventory.item_used.connect(_destroy_tiles)

func toggle_tiles(anim_time: float = .3) -> void:
	if !can_switch_world:
		return
		
	can_switch_world = false
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	
	for world in worlds:
		for cell_cord in relevant_cells:
			var cell_data: TileData = world.get_cell_tile_data(cell_cord)
			if cell_data == null:
				continue
			var progress = cell_data.get_custom_data("progress")
			var atlas_cords: Vector2i = world.get_cell_atlas_coords(cell_cord)
			# extend retracted tiles
			if progress == 0:
				tween.tween_method(\
					func(p): world.set_cell(cell_cord, 0, atlas_cords, p + 1), \
					0, 8, anim_time)
				
			# retract extended tiles
			if progress == 8:
				tween.parallel().tween_method(\
					func(p): world.set_cell(cell_cord, 0, atlas_cords, p + 1), \
					8, 0, anim_time)
						
	tween.chain().tween_property(self, "can_switch_world", true, 0)
		

func _destroy_tiles(item: Item):
	if !(item is Hammer):
		return
	var pos:= item.global_position
	for world in worlds:
		var world_pos = world.local_to_map(pos)
		for neighbour_pos in world.get_surrounding_cells(world_pos):
			var tile := world.get_cell_tile_data(neighbour_pos)
			if tile != null:
				var is_destructible = tile.get_custom_data("destructible")
				var is_destroyed = tile.get_custom_data("destroyed")
				if is_destructible && !is_destroyed:
					# TODO remove hard coded stuff
					world.set_cell(neighbour_pos,  0, Vector2i(2,15))
			
			
