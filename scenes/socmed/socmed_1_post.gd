extends PanelContainer

signal topic_remembered(topic: Topic)

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

static var LYDIA_COMMENTS: Array[Topic] = [
	Topic.mk("", "this is so true :o"),
	Topic.mk("cats", "i did this to my cat once"),
	Topic.mk("grandma", "lol this happened to my grandma"),
	Topic.mk("", "THIS ^"),
]

@export var comments: Tree
@export var post_title_label: Label
@export var poster_name_label: Label


func _ready() -> void:
	var __ := comments.button_clicked.connect(_on_comment_button_clicked)


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
	comments.set_h_scroll_enabled.call(false)
	comments.set_v_scroll_enabled(true)
	comments.set_v_scroll_enabled.call(false)


func create_comments() -> void:
	for i in maxi(0, int(randfn(1.0, 2.0))):
		var __ := add_random_child(comments)
	#var childs := get_tree_children(comments.get_root())
	#comments.custom_minimum_size.y = maxf(120.0, .size() * 64.0)


func undisable_buttons() -> void:
	var it := comments.get_root()
	while it:
		it.set_button_disabled(0, 0, false)
		it = it.get_next_in_tree()


func _on_comment_button_clicked(
		it: TreeItem,
		_column: int,
		_id: int,
		mouse_button_index: int
) -> void:
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return
	var topic: Variant = it.get_metadata(0)
	var realtopic: Topic
	if not topic or topic is not Topic: realtopic = Topic.mk(it.get_text(0), "")
	else: realtopic = topic
	it.set_button_disabled(0, 0, true)
	topic_remembered.emit(realtopic)


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
	var item := add_comment_child(tree, "u/" + NAMES[randi() % NAMES.size()] + "\n" + generate_comment_string(randi_range(5, 10) + maxi(int(randfn(10, 20)), 0)))
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


class Topic:
	var comment: String
	var title: String
	var post: String
	var love: float
	
	
	static func mk(ttle: String, cmnt: String, pst: String = "", lve := 0.0) -> Topic:
		var t := Topic.new()
		t.comment = cmnt
		t.title = ttle
		t.post = pst
		t.love = lve
		return t
