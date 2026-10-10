extends Control

const Post = preload("res://scenes/socmed/socmed_1_post.gd")

@export var post_scene: PackedScene
@export var post_container: Container


func _ready() -> void:
	assert(post_scene)
	assert(post_container)
	clear_posts()


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
	for dlg in dials:
		assert(dlg.topic_question, "need topic question")
		var p: Post = post_scene.instantiate()
		p.post_title_label.text = dlg.topic_question
		p.poster_name_label.text = "u/" + Post.NAMES[randi() % Post.NAMES.size()]
		p.create_comments()
		var it := Post.add_comment_child(p.comments, "u/lydia\n" + dlg.topic_response_comment)
		it.set_custom_color(0, Color.GREEN)
		posts.append(p)
	posts.shuffle()
	for p: Post in posts:
		post_container.add_child(p)
