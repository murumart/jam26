extends Control

const DateUI = preload("res://scenes/date/date_ui.gd")

@export var ui: DateUI


func _ready() -> void:
	var dlg := Dialogue.new()
	var __ := dlg.al("hello everyobyd my name is xyz and welcometo fnaf koidula nights game")
	__ = dlg.al("text 2 text text tex  text text text")
	__ = dlg.al("3333333333333333 ayayaayayyayyayaa")
	ui.set_name_display("character")
	ui.speak_dialogue(dlg.to_speaker())
