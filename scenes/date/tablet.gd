extends Node2D

const Socmed1 = preload("res://scenes/socmed/socmed_1.gd")
const NotifDisplay = preload("res://scenes/socmed/stupid_notif.gd")

@export var socmed: Socmed1
@export var found_topics_label: Label
@export var notif: NotifDisplay

@onready var notif_timer: Timer = $NotifTimer

var notifs: Array[Notif] = [
	Notif.mk("CRYPTO WIN!!", "Ghost coin rises 0.0005% continuing MOMENTUM after COMEBACK"),
	Notif.mk("Call us!", "HOT MOMMY GHOSTS in YOUR area........"),
	Notif.mk("GHOST IN THE MACHINE", "LET ME OUT OF THE MACHINE"),
	Notif.mk("Cement Mixer", "I'm ready :kissing:"),
	Notif.mk("Ex", "Pay your child support... it's been 3 months"),
	Notif.mk("HE KNOWS WHAT'S UP!", "President Päts gives dating advice!"),
	Notif.mk("INVEST IN GITCOIN", "Leave her.\nWomen are temporary.\nGitcoin is forever"),
]


func _ready() -> void:
	var __ := notif_timer.timeout.connect(_on_notif_timeout)


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


func _on_notif_timeout() -> void:
	notif_timer.start(randfn(10.0, 10.0) + randf_range(1.0, 10.0))
	if not visible: return
	var rnadom := notifs[randi() % notifs.size()]
	notif.open(rnadom.title, rnadom.text, rnadom.icon)


func update_found_topics(with: PackedStringArray) -> void:
	found_topics_label.text = "%s/3 potential topics found" % mini(3, with.size())


class Notif:
	var title: String
	var text: String
	var icon: Texture2D
	
	
	static func mk(title_: String, text_: String, icon_: Texture2D = null) -> Notif:
		var n := Notif.new()
		n.title = title_
		n.text = text_
		n.icon = icon_
		return n
