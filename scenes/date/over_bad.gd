extends Control

@onready var label: Label = $Label
@onready var return_button: Button = $Button


func _ready() -> void:
	var __: Variant = SND.play_music(preload("res://scenes/date/laul_v4.ogg")).skip_same_sound(false).pitch(0.3)
	__ = return_button.pressed.connect(func() -> void:
		return_button.disabled = true
		UI.swipe_transition(load("res://scenes/main_menu.tscn") as PackedScene)
	)
