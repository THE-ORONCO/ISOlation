extends Node

var slot: Item = null
var player: Node2D = null

func pick_up(item: Item) -> void:
	if slot != null:
		slot.remove_from(player)
	
	slot = item
	
	if player != null:
		item.apply(player)
		item.reparent.call_deferred(player)
		item.set_deferred("position", Vector2.ZERO)

func use():
	if slot != null && player != null:
		slot.use(player)
