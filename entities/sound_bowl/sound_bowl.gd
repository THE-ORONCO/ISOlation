class_name SoundBowl extends Item

func use(player: Player):
	if !%Audio.playing:
		SwitchStates.toggle()
		%Audio.play()

func interact():
	%Box.disabled = true
	Inventory.pick_up(self)

func remove_from(player:Player):
	%Box.disabled = false
	
