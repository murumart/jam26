extends PanelContainer

@export var comments: Tree


func _ready() -> void:
	_create_comments()


func _create_comments() -> void:
	var children: Array[TreeItem]
	for i in randi_range(0, 20) + maxi(int(randfn(5, 30)), 0):
		var cmt := ""
		for __ in randi_range(10, 30) + maxi(int(randfn(5, 80)), 0): cmt += "abcdefgh "[randi() % 9]
		children.clear()
		get_tree_children(children, comments.get_root())
		var item: TreeItem
		if children:
			item = comments.create_item(children[randi() % children.size()])
		else:
			item = comments.create_item()
		item.set_text(0, cmt)
		item.set_autowrap_mode(0, TextServer.AUTOWRAP_WORD)
		item.add_button(0, preload("res://scenes/socmed/upvote.png"))
	children.clear()
	get_tree_children(children, comments.get_root())
	comments.custom_minimum_size.y = maxf(120.0, children.size() * 24.0)


static func get_tree_children(sum: Array[TreeItem], tree: TreeItem) -> void:
	while tree:
		if tree not in sum:
			sum.append(tree)
		for child in tree.get_children():
			get_tree_children(sum, child)
		tree = tree.get_next()
