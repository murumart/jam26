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


func generate_posts() -> void:
	for i in 39:
		var p: Post = post_scene.instantiate()
		post_container.add_child(p)
