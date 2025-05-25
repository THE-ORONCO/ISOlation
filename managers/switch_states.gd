extends Node

signal switch_toggled()
var gate_state: bool = false



func toggle() -> void:
	switch_toggled.emit()
	gate_state = !gate_state
