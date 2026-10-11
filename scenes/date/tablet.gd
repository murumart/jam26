extends Node2D

const Socmed1 = preload("res://scenes/socmed/socmed_1.gd")

@export var socmed: Socmed1
@export var found_topics_label: Label


func pull_up() -> void:
	if not visible:
		show()
		var tw := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var ___ : Variant = tw.tween_property(self, "scale:y", 1.0, 0.33).from(0.0)
	show()


func put_down() -> void:
	if visible:
		var tw := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var ___ : Variant = tw.tween_property(self, "scale:y", 0.0, 0.33)
		___ = tw.tween_callback(hide)
	else:
		hide()


func update_found_topics(with: PackedStringArray) -> void:
	found_topics_label.text = "%s/3 potential topics found" % mini(3, with.size())
