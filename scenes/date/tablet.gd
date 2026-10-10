extends Node2D

const Socmed1 = preload("res://scenes/socmed/socmed_1.gd")

@export var socmed: Socmed1
@export var found_topics_label: Label


func pull_up() -> void:
	show()


func put_down() -> void:
	hide()


func update_found_topics(with: PackedStringArray) -> void:
	found_topics_label.text = "%s/3 potential topics found" % mini(3, with.size())
