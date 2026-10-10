extends Control

signal ran_out_of_time

const DateUI = preload("res://scenes/date/date_ui.gd")
const Tablet = preload("res://scenes/date/tablet.gd")
const SignalAggregator = preload("res://signal_aggregator.gd")
const Topic = preload("res://scenes/socmed/socmed_1_post.gd").Topic

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

const MAX_TIME := 30000000.0

var _time := 0.0
var _love := 0.0

var _input_gotten := SignalAggregator.new()


func _ready() -> void:
	assert(ui)
	assert(tablet)
	var __: Variant = ui.tablet_requested.connect(_tablet_requested)
	__ = ui.choice_chosen.connect(_choice_chosen)
	_input_gotten.connect_to(ran_out_of_time)
	_setup_dialogue()
	__ = tablet.socmed.post_topic_remembered.connect(_on_post_remembered)
	tablet.socmed.generate_posts(date_dials)
	_game_loop()
	__ = SND.play_music(preload("res://scenes/date/laul_v4.ogg"))
	await get_tree().process_frame
	tablet.put_down()


func _process(delta: float) -> void:
	if state == State.WAITING_FOR_RESPONSE:
		_time -= delta
		ui.display_time(true, _time, MAX_TIME)
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
	dlg.meta = Topic.mk("cats", "i love the DOG", "what's your favourite animals?", 2.0)
	date_dials.push_back(dlg.copy())
	
	dlg.clear()
	__ = dlg.al("alllalalalalallaala")
	__ = dlg.al("lallallaalla")
	__ = dlg.al("aaaaaaaaaaaahhhhhhhh AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	dlg.meta = Topic.mk("[scream really loudly]", "AUUUUUAH UA HHHAAAAAAAAAAAAAAAAAAUUHHHHH", "AHHHHHHHHHAHHHHHHHHHHHHHHHHHHHHHHHHH", 4.0)
	date_dials.push_back(dlg.copy())
	
	dlg.clear()
	__ = dlg.al("1234")
	__ = dlg.al("1233445")
	__ = dlg.al("098760987")
	dlg.meta = Topic.mk("start speaking number station", "283o4237", "bleep blooply?", 1.0)
	date_dials.push_back(dlg.copy())


func _speak_dialogue(progress: int) -> void:
	state = State.TALKING
	tablet.put_down()
	ui.display_time(false, 0.0, 0.0)
	tablet.socmed.on_open()
	var dlg := date_dials[progress]
	ui.speak_dialogue(dlg.to_speaker())
	await ui.dial_ended


func _choice_chosen(_choice: String) -> void:
	if state != State.WAITING_FOR_RESPONSE:
		return
	_input_gotten.emit()


func _get_input() -> void:
	_time = MAX_TIME
	_remembered.clear()
	tablet.update_found_topics(_remembered)
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


var _remembered: PackedStringArray = []

func _on_post_remembered(topic: String) -> void:
	var __ := _remembered.append(topic)
	var choices: PackedStringArray = []
	for i in mini(3, _remembered.size()):
		__ = choices.append(_remembered[i])
	while choices.size() != 3:
		__ = choices.append("???")
	tablet.update_found_topics(_remembered)
	ui.display_choices(choices)
