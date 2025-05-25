
extends Item

func interact():
	%Box.disabled = true
	Inventory.pick_up(self)
	
func apply(player: Player):
	player.can_walk_through_water(true)

func remove_from(player:Player):
	player.can_walk_through_water(false)
