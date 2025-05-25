
extends Item

func interact():
	Inventory.slot = self
	self.reparent(%Player)
	
func use():
	match %Anim.animation:
		"open": %Anim.play("closed")
		"closed": %Anim.play("open")
