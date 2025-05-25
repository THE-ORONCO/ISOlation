@tool
extends Interactible

func interact():
	SwitchStates.toggle()
	%Anim.play("press")



func _press_finished() -> void:
	%Anim.play("idle")
