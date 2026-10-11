extends Node

## player of sounds and music
##
## sound plays and music plays are queued and executed on next tree process frame.
## so this node should be in the tree to work.
## it can be used as an autoload easily -- no class name is defined.

var _current_music_player: AudioStreamPlayer
var _music_ops: Array[SoundOptions]
var _sound_ops: Array[SoundOptions]


func _ready() -> void:
	_current_music_player = AudioStreamPlayer.new()
	add_child(_current_music_player)


func _process(_delta: float) -> void:
	if not _music_ops.is_empty():
		var top: SoundOptions = _music_ops.pop_front()
		if not is_instance_valid(top): return
		var maked := top.make_player(self, _current_music_player)
		_op_music(maked)
	while not _sound_ops.is_empty():
		var top: SoundOptions = _sound_ops.pop_front()
		if not is_instance_valid(top): return
		_op_sound(top.make_player(self))


## plays the [param music] as "music" on next process frame.
## returns a [SoundOptions] instance that can be used to set music parameters.
func play_music(music: AudioStream) -> SoundOptions:
	var op := SoundOptions.new().stream(music).fade_time(1.0)
	_music_ops.push_back(op)
	return op


## plays [param sound] as a sound on the next process frame.
## returns a [SoundOptions] instance that can be used to set sound parameters.
func play_sound(sound: AudioStream) -> SoundOptions:
	var op := SoundOptions.new().stream(sound)
	_sound_ops.push_back(op)
	return op


func _op_music(streamp: AudioStreamPlayer) -> void:
	if not streamp:
		_current_music_player.stop()
		_current_music_player = null
		return
	assert(is_instance_valid(streamp))
	_current_music_player = streamp
	add_child(_current_music_player)
	_current_music_player.play()


func _op_sound(streamp: AudioStreamPlayer) -> void:
	add_child(streamp)
	streamp.play()


## options for played music or sound.
##
## its methods return itself for easy chaining.
class SoundOptions:

	var _stream: AudioStream
	var _pitch: float = 1.0
	var _volume: float = 1.0
	var _bus: int

	var _fade_time: float = 0.0
	var _start_volume: float = 0.0
	var _skip_same_sound: bool = true


	## set the stream to [param stream_].
	func stream(stream_: AudioStream) -> SoundOptions:
		_stream = stream_
		return self


	## set the fade time of music to [param time].
	func fade_time(time: float) -> SoundOptions:
		_fade_time = time
		return self


	## set the volume of the sound to [param vol]. linear scale (0.0..1.0).
	func volume(vol: float) -> SoundOptions:
		_volume = vol
		return self


	## set the start volume of the music to [param vol].
	func start_volume(vol: float) -> SoundOptions:
		_start_volume = vol
		return self


	## set the pitch of the sound to [param p].
	func pitch(p: float) -> SoundOptions:
		_pitch = p
		return self
	
	
	func bus(b: int) -> SoundOptions:
		_bus = b
		return self


	## if [param s] is [code]true[/code], and a sound with the same stream is
	## already playing, don't play this.
	## only applied by default to music streams.
	func skip_same_sound(s: bool) -> SoundOptions:
		_skip_same_sound = s
		return self


	## create an [AudioStreamPlayer] instance with all the options stored in self applied.
	func make_player(sound: Node, previous_player: Variant = null) -> AudioStreamPlayer:
		if is_instance_valid(previous_player):
			assert(previous_player is AudioStreamPlayer)
			if _stream == previous_player.stream and _skip_same_sound:
				return null
			var tw := sound.create_tween()
			tw.tween_property(previous_player, ^"volume_linear", 0.0, _fade_time)
			tw.tween_callback(previous_player.queue_free)
		var player := AudioStreamPlayer.new()
		player = AudioStreamPlayer.new()
		player.stream = _stream
		player.volume_linear = 0.0
		player.pitch_scale = _pitch
		player.finished.connect(player.queue_free)
		player.bus = AudioServer.get_bus_name(_bus)
		if _fade_time > 0:
			var tw2 := sound.create_tween()
			tw2.tween_property(player, ^"volume_linear", _volume, _fade_time).from(_start_volume)
		else:
			player.volume_linear = _volume
		return player
