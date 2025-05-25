@tool
extends Interactible

func interact():
	%Anim.play("press")



func _press_finished() -> void:
	%Anim.play("idle")
	SwitchStates.toggle()
