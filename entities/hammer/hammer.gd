class_name Hammer extends Item

func use(player: Player):
	pass

func interact():
	%Box.disabled = true
	Inventory.pick_up(self)

func remove_from(player:Player):
	%Box.disabled = false
	
