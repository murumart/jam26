extends CanvasLayer

#@export var options: OptionsMenu
@export var swipe_animation: AnimationPlayer

var _transitioning: bool
var transitioning: bool:
	get:
		return _transitioning
	set(to):
		assert(false)


func _ready() -> void:
	#assert(options != null)
	assert(swipe_animation != null)
	#options.load_from_file()
	#options.close()


func _unhandled_key_input(event: InputEvent) -> void:
	var k := event as InputEventKey
	assert(k != null)
	#if k.keycode == KEY_ESCAPE and k.pressed:
		#if options.is_open:
			#options.close()
		#elif false:
			#options.display()


func swipe_transition_n(n: Node) -> void:
	assert(not _transitioning, "don't start transitioning while already transitioning")
	_transitioning = true
	var current := get_tree().root.get_child(-1)

	swipe_animation.play("swipe_in")
	var __ := swipe_animation.animation_finished.connect(
		_swipe_anim_finished_1.bind(current, n).unbind(1), CONNECT_ONE_SHOT)
	
	_transitioning = false


func _swipe_anim_finished_1(current: Node, n: Node) -> void:
	get_tree().root.remove_child(current)
	current.queue_free()

	get_tree().root.add_child(n)
	get_tree().current_scene = n
	swipe_animation.play("swipe_out")
	
	var __ := swipe_animation.animation_finished.connect(
		_swipe_anim_finished_2.unbind(1), CONNECT_ONE_SHOT)


func _swipe_anim_finished_2() -> void:
	_transitioning = false


func swipe_transition(to: PackedScene) -> void:
	swipe_transition_n(to.instantiate())
