extends Node2D

const Socmed1 = preload("res://scenes/socmed/socmed_1.gd")

@export var socmed: Socmed1


func pull_up() -> void:
	show()
	socmed.generate_posts()


func put_down() -> void:
	hide()
	socmed.clear_posts()
