extends Node

var slot: Item
var player: Node2D

signal item_used(item: Item)

var seen_items:Array[String] = []

func pick_up(new_item: Item) -> void:
	var old_item: Item = slot
	
	if old_item != null:
		old_item.remove_from(player)
		old_item.reparent.call_deferred(player.get_parent())
		old_item.global_position = new_item.global_position
	
	slot = new_item
	
	if player != null: 
		_attach_item_to_player(new_item)
	
	if !seen_items.has(new_item.name):
		seen_items.append(new_item.name)
		SoundManager.next()

func _attach_item_to_player(new_item: Item):
	new_item.apply(player)
	new_item.reparent.call_deferred(player)
	new_item.set_deferred("position", Vector2.ZERO)

func remember():
	if slot != null:
		self.slot.reparent(self)

func use():
	if slot != null && player != null:
		item_used.emit(slot)
		slot.use(player)
		
func register(p: Player):
	player = p
	
	if self.get_child_count() > 0:
		slot = self.get_child(0)
		_attach_item_to_player(self.get_child(0))
