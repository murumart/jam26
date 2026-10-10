class_name Dialogue

## stores dialogue lines and ways to access them

var _lines: Array[Line]


## adds a line and returns it (to adjust it further)
func al(text: String) -> Line:
	var line := Line.mk(text)
	_lines.push_back(line)
	return line


## gets a [Dialogue.Speaker] to speak this dialogue
func to_speaker() -> Speaker:
	var s := Speaker.new()
	s._lines.assign(_lines)
	_lines.clear()
	return s


## line of dialogue
class Line:
	
	var text: String
	
	
	## constructor
	static func mk(txt: String) -> Line:
		var l := Line.new()
		l.text = txt
		return l


## class to speak the dialogue line by line.
class Speaker:
	
	var _lines: Array[Line]
	var _ix: int
	
	
	## get current [Dialogue.Line] if it exists, null if doesnt, then move to next position.
	func next() -> Dialogue.Line:
		var l := current()
		if not l:
			return null
		_ix += 1
		return l
	
	
	## returns the current dialogue line at cursor position (or null if there's nothing)
	func current() -> Dialogue.Line:
		if _ix >= _lines.size():
			return null
		return _lines[_ix]
		
	
	## returns index of current line
	func get_cursor() -> int:
		return _ix
	
