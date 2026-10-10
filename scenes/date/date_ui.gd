extends Control

@export var text_label: RichTextLabel
@export var name_label: Label
@export var next_dial_button: Button

var _speaker: Dialogue.Speaker
var _speaking_line := false


func _ready() -> void:
	assert(name_label)
	assert(text_label)
	assert(next_dial_button)
	var __ := next_dial_button.pressed.connect(next_or_skip)


func _process(delta: float) -> void:
	if _speaking_line:
		_progress_speak(delta)


var _st := 0.0
# progresses speech letter by letter
func _progress_speak(delta: float) -> void:
	_st += delta
	if _st >= 0.05:
		_st = 0.0
		text_label.visible_characters += 1
	if text_label.visible_ratio >= 1.0:
		_speaking_line = false


## sets name in the character name label
func set_name_display(n: String) -> void: name_label.text = n


## starts speaking text in the speech label
func speak_text(txt: String) -> void:
	assert(not _speaking_line, "dont start speaking while already speaking")
	_speaking_line = true
	text_label.text = txt
	text_label.visible_characters = 0


## start speaking dialogue
func speak_dialogue(sp: Dialogue.Speaker) -> void:
	_speaker = sp
	speak_text(sp.next().text)


## speaks text of dialogue line [param l]
func speak_line(l: Dialogue.Line) -> void:
	speak_text(l.text)


## if speaking, skip to end of line, otherwise start speaking next line
func next_or_skip() -> void:
	if _speaking_line:
		text_label.visible_ratio = 1.0
		return
	var next := _speaker.next()
	if next:
		speak_line(next)
		return
	# ran out of lines
