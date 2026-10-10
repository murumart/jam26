extends Control

const DateUI = preload("res://scenes/date/date_ui.gd")
const Tablet = preload("res://scenes/date/tablet.gd")


@export var ui: DateUI
@export var tablet: Tablet

"""
the date screen loop.. what is itõ

- read dialogue
- get asked input
- open tablet and start scrolling
- time limit starts ticking down
- click on "use" button to get input for choices
- choose choice, get a response (+ hearts)
- move to next topic
"""

var date_dials: Array[Dialogue]


func _ready() -> void:
	assert(ui)
	assert(tablet)
	var __ := ui.tablet_requested.connect(_tablet_requested)
	_test_dialogue()


func _test_dialogue() -> void:
	var dlg := Dialogue.new()
	var __ := dlg.al("hello everyobyd my name is xyz and welcometo our date")
	__ = dlg.al("today we are dating")
	__ = dlg.al("we are on the date")
	__ = dlg.al("lets takl about some fun stuff. you know i like this animal..?")
	date_dials.push_back(dlg)
	
	dlg.clear()
	__ = dlg.al("")
	ui.set_name_display("character")
	ui.speak_dialogue(dlg.to_speaker())


func _tablet_requested() -> void:
	if tablet.visible:
		tablet.put_down()
	else:
		tablet.pull_up()
