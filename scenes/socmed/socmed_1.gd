extends Control

signal post_topic_remembered(topic: String)

const Post = preload("res://scenes/socmed/socmed_1_post.gd")

@export var post_scene: PackedScene
@export var post_container: Container


func _ready() -> void:
	assert(post_scene)
	assert(post_container)
	clear_posts()


func on_open() -> void:
	for p: Post in post_container.get_children():
		p.undisable_buttons()


func clear_posts() -> void:
	var __ := post_container.get_children().map(func(n: Node) -> void: n.queue_free())


func generate_posts(dials: Array[Dialogue]) -> void:
	var posts := []
	for i in 29:
		var p: Post = post_scene.instantiate()
		p.post_title_label.text = Post.generate_comment_string(randi_range(2, 8)).replace_chars("\t\n\r", ord(".")).capitalize() + "?"
		p.poster_name_label.text = "u/" + Post.NAMES[randi() % Post.NAMES.size()]
		p.create_comments()
		posts.append(p)
		var comment := Post.LYDIA_COMMENTS[randi() % Post.LYDIA_COMMENTS.size()]
		var chld := Post.add_comment_child(p.comments, "u/lydia\n" + comment.comment)
		chld.set_custom_color(0, Color.GREEN)
		chld.set_metadata(0, comment.title)
	for dlg in dials:
		assert(dlg.meta, "need topic question")
		var p: Post = post_scene.instantiate()
		var topic := dlg.meta as Post.Topic
		p.post_title_label.text = topic.post
		p.poster_name_label.text = "u/" + Post.NAMES[randi() % Post.NAMES.size()]
		p.create_comments()
		var it := Post.add_comment_child(p.comments, "u/lydia\n" + topic.comment)
		it.set_custom_color(0, Color.GREEN)
		it.set_metadata(0, topic.title)
		posts.append(p)
	posts.shuffle()
	for p: Post in posts:
		post_container.add_child(p)
		var __ := p.topic_remembered.connect(post_topic_remembered.emit)
