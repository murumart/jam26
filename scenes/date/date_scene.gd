extends Control

const DateUI = preload("res://scenes/date/date_ui.gd")

@export var ui: DateUI


func _ready() -> void:
	var dlg := Dialogue.new()
	var __ := dlg.al("hello everyobyd my name is xyz and welcometo fnaf koidula nights game")
	__ = dlg.al("text 2 text text tex  text text text")
	__ = dlg.al("hoose those are your t2 choices which is it gonna be huh huh?").schoices(["saint", "grunch"])
	__ = dlg.al("sainte").schoice_link("saint")
	__ = dlg.al("yu will die die die").schoice_link("saint")
	__ = dlg.al("grunhc").schoice_link("grunch")
	__ = dlg.al("you will live live live").schoice_link("grunch")
	__ = dlg.al("plarbus")
	ui.set_name_display("character")
	ui.speak_dialogue(dlg.to_speaker())
