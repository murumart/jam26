extends Control

## handles text display and choice making in the dating ui

signal tablet_requested

@export var text_label: RichTextLabel
@export var name_label: Label
@export var next_dial_button: Button
@export var choices_container: Container
@export var tablet_button: Button

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
		display_choices()


func _choice_chosen(c: int) -> void:
	_current_choice = _speaking_line.choices[c]
	next_or_skip()


## sets name in the character name label
func set_name_display(n: String) -> void: name_label.text = n


func reset_choices_display() -> void:
	for but: Button in choices_container.get_children():
		but.hide()


func display_choices() -> void:
	assert(_speaking_line)
	reset_choices_display()
	var i := 0
	assert(_speaking_line.choices.size() <= 5, "too many choices cant fit in choice buttons")
	for choice in _speaking_line.choices:
		var but := choices_container.get_child(i) as Button
		but.text = choice
		but.show()
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


var _tablet_open := false

func _tablet_moused() -> void:
	tablet_requested.emit()
	_tablet_open = not _tablet_open
