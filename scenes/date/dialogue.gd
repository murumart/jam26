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
	return s


func clear() -> void:
	_lines = []


func copy() -> Dialogue:
	var dlg := Dialogue.new()
	dlg._lines = _lines
	return dlg


## line of dialogue
class Line:
	
	var text: String
	var choices: PackedStringArray
	var choice_link: String
	var callback: Callable
	
	
	## constructor
	static func mk(txt: String) -> Line:
		var l := Line.new()
		l.text = txt
		return l
	
	
	func schoices(choices_: PackedStringArray) -> Line:
		choices = choices_
		return self
	
	
	## sets the required chosen choice
	func schoice_link(link: String) -> Line:
		choice_link = link
		return self
	
	
	func scallback(c: Callable) -> Line:
		callback = c
		return self


## class to speak the dialogue line by line.
class Speaker:
	
	var _lines: Array[Line]
	var _ix: int
	
	
	## get next [Dialogue.Line] if it exists, null if doesnt.
	## if the line has a choice link it matches with stored choice and if not skips
	func next() -> Dialogue.Line:
		var l := current()
		_ix += 1
		if not l:
			return null
		return l
	
	
	## returns the current dialogue line at cursor position (or null if there's nothing)
	func current() -> Dialogue.Line:
		if _ix >= _lines.size() or _ix < 0:
			return null
		return _lines[_ix]
		
	
	## returns index of current line
	func get_cursor() -> int:
		return _ix
