extends Control

signal ran_out_of_time

const DateUI = preload("res://scenes/date/date_ui.gd")
const Tablet = preload("res://scenes/date/tablet.gd")
const SignalAggregator = preload("res://resources/scripts/signal_aggregator.gd")
const Topic = preload("res://scenes/socmed/socmed_1_post.gd").Topic

enum State {
	TALKING,
	WAITING_FOR_RESPONSE,
}

@export var ui: DateUI
@export var tablet: Tablet
@export var game: GameResources

var date_dials: Array[Dialogue]
var state: State

const MAX_TIME := 45.0
const MAX_LOVE := 20.0

var _current_topic: Topic
var _current_convo: Conversation
var _time := 0.0
var _love := 0.0

var _input_gotten := SignalAggregator.new()


func _ready() -> void:
	assert(ui)
	assert(tablet)
	var __: Variant = ui.tablet_requested.connect(_tablet_requested)
	__ = ui.choice_chosen.connect(_choice_chosen)
	_input_gotten.connect_to(ran_out_of_time)
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
	while 2:
		var over := await _speak_dialogue(date_progress)
		if over: break
		date_progress += 1
		await _get_input()
	# game over
	if _love >= 20.0:
		UI.swipe_transition(load("res://scenes/date/over_good.tscn") as PackedScene)
	else:
		UI.swipe_transition(load("res://scenes/date/over_bad.tscn") as PackedScene)


func _speak_dialogue(progress: int) -> bool:
	state = State.TALKING
	tablet.put_down()
	ui.display_time(false, 0.0, 0.0)
	tablet.socmed.on_open()
	if progress >= game.date.size():
		return true
	var convo := game.date[progress]
	var dlg := Dialogue.from(convo.lines)
	ui.speak_dialogue(dlg.to_speaker())
	_current_convo = convo
	_current_topic = convo.topic.to_topic()
	await ui.dial_ended
	return false


func _choice_chosen(choice: String) -> void:
	if state != State.WAITING_FOR_RESPONSE:
		return
	var topic: Topic
	for r in _remembered:
		if r.title == choice:
			topic = r
	print(topic)
	var right := false
	if topic:
		if topic.love > 0:
			if topic.title == _current_topic.title:
				right = true
				_love += topic.love * 0.75
			_love += topic.love * 0.25
		else:
			_love += topic.love
	ui.display_love(true, _love, MAX_LOVE)
	state = State.TALKING
	ui.speak_dialogue(
		Dialogue.from(_current_convo.on_topic_lines if right else _current_convo.off_topic_lines)
			.to_speaker())
	await ui.dial_ended
	_input_gotten.emit()


func _get_input() -> void:
	_time = MAX_TIME
	_remembered.clear()
	tablet.update_found_topics(_remembered)
	ui.display_choices(["???", "???", "???"])
	state = State.WAITING_FOR_RESPONSE
	await _input_gotten.fired
	ui.display_love(true, _love, MAX_LOVE)


func _tablet_requested() -> void:
	if not state == State.WAITING_FOR_RESPONSE:
		return
	if tablet.visible:
		tablet.put_down()
	else:
		tablet.pull_up()


var _remembered: Array[Topic] = []

func _on_post_remembered(topic: Topic) -> void:
	_remembered.append(topic)
	var choices: PackedStringArray = []
	var __: Variant
	for i in mini(3, _remembered.size()):
		__ = choices.append(
			_remembered[i].title
				if _remembered[i].title
				else _remembered[i].comment
		)
	while choices.size() != 3:
		__ = choices.append("???")
	tablet.update_found_topics(_remembered)
	ui.display_choices(choices)
