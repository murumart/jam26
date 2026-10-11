class_name ButtonSoundAdder extends Node

@export var exclusions: Array[Button]


func _recurse(nod: Node, buttons: Array[Button]) -> void:
	for n in nod.get_children():
		if n is Button and not n in exclusions:
			buttons.append(n)
		_recurse(n, buttons)


func _ready() -> void:
	var buttons: Array[Button]
	_recurse(get_parent(), buttons)
	#print(buttons)
	var __: Variant
	for b: Button in buttons:
		__ = b.mouse_entered.connect(func() -> void:
			if b.is_visible_in_tree() and not b.disabled:
				var ___ := SND.play_sound(preload("res://scenes/socmed/menusounds-01.ogg")).volume(0.5)
		)
		__ = b.pressed.connect((func() -> void:
			var ___ := SND.play_sound(preload("res://scenes/socmed/menusounds-02.ogg")).volume(0.5)).call_deferred)
