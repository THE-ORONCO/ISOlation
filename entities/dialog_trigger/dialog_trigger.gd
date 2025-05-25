extends Node2D

var should_play: bool = true

@export var content: String = ""
@export var audio: AudioStream = null
@export_range(1,10) var show_for: float = 3
@export_range(.01, 1) var time_per_character: float = .1
@onready var text: RichTextLabel = %Text

func _ready() -> void:
	text.visible_characters = 0
	text.text = content

func _player_entered(body: Node2D) -> void:
	if should_play:
		should_play = false
		
		if content != null && !content.is_empty():
			var tween := get_tree().create_tween()
			tween.tween_property(text, "modulate:a", 1, .4).from(0)
			text.visible_characters
			tween.tween_property(text, "visible_characters", content.length(), time_per_character * text.get_total_character_count()).from(0)
			tween.tween_interval(show_for)
			tween.tween_property(text, "modulate:a", 0, .4).from(1)
		
		if audio != null:
			%Audio.stream = audio
			%Audio.pitch_scale = randf_range(.95, 1.05)
			%Audio.play()
 
