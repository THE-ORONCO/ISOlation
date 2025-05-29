extends Node2D

var sound_to_play: int = 0
var current: AudioStreamPlayer

func next():

	var sounds:Array = %Tracks.get_children().filter(func (c): return c is AudioStreamPlayer)
	var t := get_tree().create_tween()
	var i: int = 0
	for sound in sounds:
		var s: AudioStreamPlayer = sound
		if sound_to_play == i:	
			s.play()
		else: 
			s.stop()
		i +=1
	
	sound_to_play = clamp(sound_to_play + 1 , 0, 3)
