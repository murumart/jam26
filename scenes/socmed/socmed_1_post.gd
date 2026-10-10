extends PanelContainer

@export var comments: Tree


func _ready() -> void:
	_create_comments()


func _create_comments() -> void:
	for i in randi_range(0, 20) + maxi(int(randfn(5, 30)), 0):
		var __ := add_random_child(comments)
	comments.custom_minimum_size.y = maxf(120.0, get_tree_children(comments.get_root()).size() * 24.0)


static func add_random_child(tree: Tree) -> TreeItem:
	var children: Array[TreeItem] = get_tree_children(tree.get_root())
	var item: TreeItem
	if children:
		item = tree.create_item(children[randi() % children.size()])
	else:
		item = tree.create_item()
	item.set_text(0, generate_comment_string())
	item.set_autowrap_mode(0, TextServer.AUTOWRAP_WORD)
	item.add_button(0, preload("res://scenes/socmed/upvote.png"))
	return item


static func generate_comment_string() -> String:
	var cmt := ""
	for __ in randi_range(10, 30) + maxi(int(randfn(5, 80)), 0): cmt += "abcdefgh "[randi() % 9]
	return cmt


static func get_tree_children(tree: TreeItem) -> Array[TreeItem]:
	var sum: Array[TreeItem]
	while tree:
		if tree not in sum:
			sum.append(tree)
		tree = tree.get_next_in_tree()
	return sum
