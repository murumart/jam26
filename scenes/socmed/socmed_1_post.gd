extends PanelContainer

const NAMES: PackedStringArray = [
	"fgjshogs", "glamps", "pixle",
	"greenman", "glorrorbehb", "bplangnn",
	"p5i9rg5", "jurhur", "jrudujrayldis",
	"adamM", "jengleballs", "guh",
	"uhhuuuuuu", "miimioru_lood", "jama",
	"svoisdois", "tdHhfhfhf", "garpplarplg",
	"glöök", "gammamamma", "nanna-floating",
	"fjfjjf", "ofcourse", "spyamongus",
	"spangongus", 
]

@export var comments: Tree
@export var post_title_label: Label
@export var poster_name_label: Label


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e := event as InputEventMouseButton
		if e.button_index == MOUSE_BUTTON_WHEEL_DOWN or e.button_index == MOUSE_BUTTON_WHEEL_UP:
			# WHAT THE FUCK!!
			comments.mouse_filter = Control.MOUSE_FILTER_IGNORE
			comments.set_mouse_filter.call_deferred(Control.MOUSE_FILTER_STOP)


func _process(_d: float) -> void:
	# THIS SHIT SUCKS!!!! FUCK!!!!!!!!!!
	comments.set_h_scroll_enabled(true)
	comments.set_h_scroll_enabled.call_deferred(false)
	comments.set_v_scroll_enabled(true)
	comments.set_v_scroll_enabled.call_deferred(false)
	


func create_comments() -> void:
	for i in randi_range(1, 3):
		var __ := add_random_child(comments)
	#var childs := get_tree_children(comments.get_root())
	#comments.custom_minimum_size.y = maxf(120.0, .size() * 64.0)


static func add_comment_child(tree: Tree, text: String) -> TreeItem:
	var children: Array[TreeItem] = get_tree_children(tree.get_root())
	var item: TreeItem
	if children:
		item = tree.create_item(children[randi() % children.size()])
	else:
		item = tree.create_item()
	item.set_autowrap_mode(0, TextServer.AUTOWRAP_WORD)
	item.set_text(0, text)
	item.add_button(0, preload("res://scenes/socmed/upvote.png"))
	return item


static func add_random_child(tree: Tree) -> TreeItem:
	var item := add_comment_child(tree, "u/" + NAMES[randi() % NAMES.size()] + "\n" + generate_comment_string(randi_range(5, 10) + maxi(int(randfn(20, 40)), 0)))
	return item


const DICT := preload("res://scenes/socmed/socmed_dict.gd").DICT

static func generate_comment_string(leng: int) -> String:
	var cmt := ""
	var last_word: String = DICT.keys()[randi() % DICT.keys().size()]
	cmt += last_word
	for __ in leng:
		var new_word: String = random_string(DICT.get(last_word, {}) as Dictionary)
		cmt += " "
		cmt += new_word
		last_word = new_word
	return cmt


static func get_tree_children(tree: TreeItem) -> Array[TreeItem]:
	var sum: Array[TreeItem]
	while tree:
		if tree not in sum:
			sum.append(tree)
		tree = tree.get_next_in_tree()
	return sum


static func random_string(from_dict: Dictionary) -> String:
	if from_dict.is_empty():
		return DICT.keys().pick_random()
	if from_dict.size() == 1:
		return from_dict.keys()[0]
	var weightsum: float = from_dict.values().reduce(func(n: float, a: float) -> float: return n + a, 0.0)
	var ix: int = 0
	var words := from_dict.keys()
	var r := randf() * weightsum
	while ix < len(from_dict) - 1:
		var word: String = words[ix]
		r -= from_dict[word]
		if r <= 0: break
		ix += 1
	return words[ix]
