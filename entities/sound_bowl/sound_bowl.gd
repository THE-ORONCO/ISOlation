extends Item

func use(player: Player):
	SwitchStates.toggle()

func interact():
	%Box.disabled = true
	Inventory.pick_up(self)

func remove_from(player:Player):
	%Box.disabled = false
