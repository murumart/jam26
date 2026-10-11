class_name AwesomeStyle extends Label

@export var swing_distance: Vector2
@export var letter_distance: float

var ls: Array[Label] = []


func _ready() -> void:
	var i := 0
	for c in text:
		var l := Label.new()
		add_child(l)
		l.label_settings = label_settings
		l.text = c
		l.position.x += i * letter_distance
		l.offset_transform_enabled = true
		ls.append(l)
		i += 1
	self_modulate.a = 0.0


var _t: float
func _process(delta: float) -> void:
	var i := 0
	_t += delta
	for l in ls:
		l.offset_transform_position.x = sin(i + _t) * swing_distance.x
		l.offset_transform_position.y = cos(i + _t) * swing_distance.y
		i += 1
