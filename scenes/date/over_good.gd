extends Control

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	rich_text_label.modulate.a = 0.0
	var __: Variant = SND.play_music(null)
	await get_tree().create_timer(0.5).timeout
	video_stream_player.play()
	await get_tree().create_timer(1.6).timeout
	audio_stream_player.play()
	await audio_stream_player.finished
	var tw := create_tween()
	__ = tw.tween_property(rich_text_label, "modulate:a", 1.0, 10.0).from(0.0)
