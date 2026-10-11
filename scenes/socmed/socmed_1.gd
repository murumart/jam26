extends Control

signal post_topic_remembered(topic: String)

const Post = preload("res://scenes/socmed/socmed_1_post.gd")

@export var post_scene: PackedScene
@export var post_container: Container


func _ready() -> void:
	assert(post_scene)
	assert(post_container)
	clear_posts()


func enable_buttons() -> void:
	for p: Post in post_container.get_children():
		p.enable_buttons()


func disable_buttons() -> void:
	for p: Post in post_container.get_children():
		p.disable_buttons()


func clear_posts() -> void:
	var __ := post_container.get_children().map(func(n: Node) -> void: n.queue_free())


func generate_posts(game: GameResources) -> void:
	var posts := []
	for i in 29:
		var p: Post = post_scene.instantiate()
		p.post_title_label.text = Post.generate_comment_string(randi_range(2, 8)).replace_chars("\t\n\r", ord(".")).capitalize() + "?"
		p.poster_name_label.text = "u/" + Post.NAMES[randi() % Post.NAMES.size()]
		p.image.texture = null
		p.create_comments()
		posts.append(p)
		var comment := game.random_lydia_responses[randi() % game.random_lydia_responses.size()].to_topic()
		var chld := Post.add_comment_child(p.comments, "u/lydia\n" + comment.comment)
		chld.set_custom_color(0, Color.GREEN)
		chld.set_metadata(0, comment)
	for c in game.date:
		var p: Post = post_scene.instantiate()
		var topic := c.topic.to_topic()
		p.image.texture = topic.image
		p.post_title_label.text = topic.post.capitalize()
		p.poster_name_label.text = "u/" + Post.NAMES[randi() % Post.NAMES.size()]
		p.create_comments()
		var it := Post.add_comment_child(p.comments, "u/lydia\n" + topic.comment)
		it.set_custom_color(0, Color.GREEN)
		it.set_metadata(0, topic)
		posts.append(p)
	for ad in game.ad_images:
		var p: Post = post_scene.instantiate()
		p.post_title_label.text = "AD: " + Post.generate_comment_string(randi_range(2, 8)).replace_chars("\t\n\r", ord(".")).capitalize()
		p.poster_name_label.text = "u/ads"
		p.image.texture = ad
		p.ad_mode()
		posts.append(p)
	posts.shuffle()
	for p: Post in posts:
		post_container.add_child(p)
		var __ := p.topic_remembered.connect(post_topic_remembered.emit)
