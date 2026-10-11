extends Control

@onready var play_button: Button = $VBoxContainer/Button


func _ready() -> void:
	var __ := play_button.pressed.connect(func() -> void:
		play_button.disabled = true
		UI.swipe_transition(load("res://scenes/date/date_scene.tscn") as PackedScene)
	)
