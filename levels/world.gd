extends TileMapLayer
#
#func _ready() -> void:
	#place_boundaries()
#
#const offsets: Array[Vector2i] = [
	#Vector2i(0, -1),
	#Vector2i(0, 1),
	#Vector2i(1, 0),
	#Vector2i(-1, 0),
#]
#
#
#func place_boundaries():
#
	#
	#var used: Array[Vector2i] = get_used_cells()
	## first pass -> place basic collission
	#for spot in used:
		#for offset in offsets:
			#var neighbour := spot + offset
			#if get_cell_source_id(neighbour) == -1:
				#set_cell(neighbour, 0, Vector2i.ONE)
				#continue
#
			#
