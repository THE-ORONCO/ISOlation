extends Node

var slot: Item = null

func use():
	if slot != null:
		slot.use()
