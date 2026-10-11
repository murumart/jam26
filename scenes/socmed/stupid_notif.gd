extends PanelContainer

@onready var notif_title: Label = %NotifTitle
@onready var notif_text: Label = %NotifText
@onready var close_button: Button = %CloseButton
@onready var icon: TextureRect = %Icon

const ICON = preload("res://scenes/socmed/icon.png")


func _ready() -> void:
	position.y = -500.0
	var __ := close_button.pressed.connect(close)


func open(title: String, text: String, image: Texture2D = null) -> void:
	var __ :Variant= SND.play_sound(preload("res://scenes/socmed/notif.ogg"))
	icon.texture = ICON if not image else image
	notif_title.text = title
	notif_text.text = text
	var tw := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	__ = tw.tween_property(self, "position:y", -180.0, 0.5).from(-500.0)
	close_button.disabled = false	
	close_button.text = ["NO", "CLOSE", "STOP", "PLEASE", "CLOSE", "NO"].pick_random()


func close() -> void:
	close_button.disabled = true
	var tw := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var __: Variant = tw.tween_property(self, "position:y", -500.0, 0.5)
