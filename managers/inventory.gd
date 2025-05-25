extends Node

var slot: Item = null
var player: Node2D = null

func pick_up(new_item: Item) -> void:
	var old_item: Item = slot
	
	if old_item != null:
		old_item.remove_from(player)
		old_item.reparent.call_deferred(player.get_parent())
		old_item.global_position = new_item.global_position
	
	slot = new_item
	
	if player != null:
		new_item.apply(player)
		new_item.reparent.call_deferred(player)
		new_item.set_deferred("position", Vector2.ZERO)

func use():
	if slot != null && player != null:
		slot.use(player)
