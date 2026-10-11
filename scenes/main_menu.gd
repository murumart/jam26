extends Control

@onready var play_button: Button = $VBoxContainer/Button
@onready var main_volume: HSlider = $VBoxContainer/MainVolume


func _ready() -> void:
	var __ :Variant= play_button.pressed.connect(func() -> void:
		play_button.disabled = true
		UI.swipe_transition(load("res://scenes/date/date_scene.tscn") as PackedScene)
	)
	__ = SND.play_music(preload("res://scenes/date/laul_v4.ogg")).skip_same_sound(false)
	__ = main_volume.value_changed.connect(func(v: float) -> void:
		AudioServer.set_bus_volume_linear(0, v)
	)
	__ = main_volume.drag_ended.connect(func(_b: bool) -> void:
		var ___ := SND.play_sound(preload("res://scenes/socmed/notif.ogg"))
	)
	main_volume.value = 0.75
