extends Control

## handles text display and choice making in the dating ui

const Tablet = preload("res://scenes/date/tablet.gd")

signal tablet_requested
signal dial_ended
signal choice_chosen(choice: String)

@export var text_label: RichTextLabel
@export var name_label: Label
@export var next_dial_button: Button
@export var choices_container: Container
@export var tablet_button: Button

@export var time_display: Container
@export var time_progress_bar: ProgressBar
@export var love_display: Container
@export var love_progress_bar: Range
@export var love_particles: CPUParticles2D

@export var tablet: Tablet

var _speaking_text: bool
var _speaker: Dialogue.Speaker
var _speaking_line: Dialogue.Line
var _current_choice: String


func _ready() -> void:
	assert(name_label)
	assert(text_label)
	assert(next_dial_button)
	assert(choices_container)
	assert(tablet_button)
	assert(time_progress_bar)
	assert(time_display)
	assert(love_progress_bar)
	assert(love_display)
	time_display.hide()
	var __ := next_dial_button.pressed.connect(next_or_skip)
	var i := 0
	for but: Button in choices_container.get_children():
		__ = but.pressed.connect(_choice_chosen.bind(i))
		i += 1
	__ = tablet_button.pressed.connect(_tablet_moused)


func _process(delta: float) -> void:
	if _speaking_line and _speaking_text:
		_progress_speak(delta)


var _st := 0.0
# progresses speech letter by letter
func _progress_speak(delta: float) -> void:
	_st += delta
	if _st >= 0.025:
		_st = 0.0
		text_label.visible_characters += 1
	if text_label.visible_ratio >= 1.0:
		_line_finished()


func _line_finished() -> void:
	_speaking_text = false
	if _speaking_line.choices:
		display_choices(_speaking_line.choices)


func _choice_chosen(c: int) -> void:
	if tablet.visible: return
	_current_choice = choices_container.get_child(c).get_meta("choice")
	choice_chosen.emit(_current_choice)
	next_or_skip()


func get_current_choice() -> String:
	return _current_choice


## sets name in the character name label
func set_name_display(n: String) -> void: name_label.text = n


func reset_choices_display() -> void:
	for but: Button in choices_container.get_children():
		but.hide()
		but.disabled = true


func display_choices(choices: PackedStringArray) -> void:
	reset_choices_display()
	var i := 0
	assert(choices.size() <= 5, "too many choices cant fit in choice buttons")
	for choice in choices:
		var but := choices_container.get_child(i) as Button
		if choice.length() > 32:
			var pc := choice
			if "\n" in pc:
				pc = pc.get_slice("\n", 2)
			but.text = pc.substr(0, 24) + "..."
		else:
			but.text = choice
		but.set_meta("choice", choice)
		but.show()
		but.disabled = choice == "???"
		i += 1


## starts speaking text in the speech label
func speak_text(txt: String) -> void:
	assert(not _speaking_text, "dont start speaking while already speaking")
	assert(_speaking_line)
	text_label.text = txt
	text_label.visible_characters = 0
	_speaking_text = true


## start speaking dialogue
func speak_dialogue(sp: Dialogue.Speaker) -> void:
	_speaker = sp
	speak_line(sp.next())


## speaks text of dialogue line [param l]
func speak_line(l: Dialogue.Line) -> void:
	assert(l != _speaking_line)
	_speaking_line = l
	reset_choices_display()
	speak_text(l.text)


## if speaking, skip to end of line, otherwise start speaking next line
## dont skip to next if we have choices
func next_or_skip() -> void:
	if _speaking_text:
		text_label.visible_ratio = 1.0
		return
	if _speaking_line.choices and not _current_choice:
		return
	var next: Dialogue.Line
	while true:
		next = _speaker.next()
		if not next: break
		if not next.choice_link: break
		if next.choice_link == _current_choice: break
	if next:
		speak_line(next)
		return
	# ran out of lines
	dial_ended.emit()


func _tablet_moused() -> void:
	tablet_requested.emit()
	if tablet.visible:
		choices_container.hide()
	else:
		choices_container.show()


func display_time(show_: bool, time: float, max_: float) -> void:
	if not show_:
		time_display.hide()
		return
	time_display.show()
	time_progress_bar.value = time
	time_progress_bar.max_value = max_


func display_love(show_: bool, love: float, max_: float) -> void:
	if not show_:
		love_display.hide()
		return
	love_display.show()
	var last := love_progress_bar.value
	love_progress_bar.value = love
	love_progress_bar.max_value = max_
	if love > last:
		var __ := SND.play_sound(preload("res://scenes/date/heartsnd.ogg"))
		love_particles.amount = roundi(love - last) * 8
		love_particles.emitting = true
