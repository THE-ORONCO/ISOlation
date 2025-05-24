extends Node

signal switch_toggled()

func toggle() -> void:
	switch_toggled.emit()
