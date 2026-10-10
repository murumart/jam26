class_name TopicTemplate extends Resource

const Topic = preload("res://scenes/socmed/socmed_1_post.gd").Topic

## the "ID" of the topic
@export var title: String
## title of the post on g/askglepy on which you see her response
@export_multiline var post_title: String
## comment lydia leaves on the above post
@export_multiline var her_comment: String
## lydia likes you so much for this (max love is 20 atm).
## if the topic doesnt match the current topic shes talking about,
## you get 25% of the score only.
## if the love value is negative, it subtracts full amount from gained love.
@export_range(-10.0, 10.0) var love: float
## optional: image for the post
@export var post_image: Texture


func to_topic() -> Topic:
	return Topic.mk(title, her_comment, post_title, love, post_image)
