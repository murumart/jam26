extends Control

signal ran_out_of_time

const DateUI = preload("res://scenes/date/date_ui.gd")
const Tablet = preload("res://scenes/date/tablet.gd")
const SignalAggregator = preload("res://signal_aggregator.gd")

enum State {
	TALKING,
	WAITING_FOR_RESPONSE,
}

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
var state: State

var _time := 0.0
var _love := 0.0

var _input_gotten := SignalAggregator.new()


func _ready() -> void:
	assert(ui)
	assert(tablet)
	var __ := ui.tablet_requested.connect(_tablet_requested)
	_input_gotten.connect_to(ran_out_of_time)
	_setup_dialogue()
	_game_loop()


func _process(delta: float) -> void:
	if state == State.WAITING_FOR_RESPONSE:
		_time -= delta
		ui.display_time(true, _time, 10.0)
		if _time <= 0.0:
			ran_out_of_time.emit()
			state = State.TALKING


func _game_loop() -> void:
	var date_progress := 0
	while true:
		await _speak_dialogue(date_progress)
		date_progress += 1
		await _get_input()


func _setup_dialogue() -> void:
	var dlg := Dialogue.new()
	var __: Variant
	
	dlg.clear()
	__ = dlg.al("hello everyobyd my name is xyz and welcometo our date")
	__ = dlg.al("today we are dating")
	__ = dlg.al("we are on the date")
	__ = dlg.al("lets takl about some fun stuff. you know i like this animal..?")
	date_dials.push_back(dlg.copy())
	
	dlg.clear()
	__ = dlg.al("alllalalalalallaala")
	__ = dlg.al("lallallaalla")
	__ = dlg.al("aaaaaaaaaaaahhhhhhhh AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	date_dials.push_back(dlg.copy())
	
	dlg.clear()
	__ = dlg.al("1234")
	__ = dlg.al("1233445")
	__ = dlg.al("098760987")
	date_dials.push_back(dlg.copy())


func _speak_dialogue(progress: int) -> void:
	state = State.TALKING
	tablet.put_down()
	ui.display_time(false, 0.0, 0.0)
	var dlg := date_dials[progress]
	ui.speak_dialogue(dlg.to_speaker())
	await ui.dial_ended


func _get_input() -> void:
	_time = 10.0
	ui.display_choices(["???", "???", "???"])
	state = State.WAITING_FOR_RESPONSE
	await _input_gotten.fired
	ui.display_love(true, _love, 20.0)


func _tablet_requested() -> void:
	if not state == State.WAITING_FOR_RESPONSE:
		return
	if tablet.visible:
		tablet.put_down()
	else:
		tablet.pull_up()
