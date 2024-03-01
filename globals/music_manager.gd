extends Node

@onready var track1: AudioStreamPlayer = $Track1
@onready var track2: AudioStreamPlayer = $Track2

@export var game_music: Array[AudioStream] = []

var _current_song = null

var fade_timer: Timer

var cur_track = null
var pre_track = null

var min_volume = -20.0
var max_volume = -5.0

func _ready():
	fade_timer = Timer.new()
	fade_timer.one_shot = true
	fade_timer.timeout.connect(finish_fade)
	add_child(fade_timer)
	
	cur_track = track1
	pre_track = track2

func get_next_song():
	var songs = game_music.duplicate()
	if songs.size() > 1:
		songs.erase(_current_song)
	if songs.is_empty():
		return null
	var new_song = songs.pick_random()
	return new_song

func play_music():
	_current_song = get_next_song()
	if _current_song == null:
		return
	cur_track = track1
	pre_track = track2
	cur_track.stop()
	pre_track.stop()
	fade_timer.stop()
	cur_track.stream = _current_song
	if not cur_track.finished.is_connected(play_next_song):
		cur_track.finished.connect(play_next_song)
	cur_track.play()

func transition_music(song, transition_time: float = 1.0, force: bool = false):
	if _current_song == song and not force:
		return
	
	if song == null:
		return
	
	_current_song = song
	fade_timer.wait_time = transition_time
	cur_track.finished.disconnect(play_next_song)
	var temp_track = pre_track
	pre_track = cur_track
	cur_track = temp_track
	cur_track.stream = song
	if not cur_track.finished.is_connected(play_next_song):
		cur_track.finished.connect(play_next_song)
	cur_track.play()
	fade_timer.start()

func play_next_song(transition_time: float = 1.0):
	var next_song = get_next_song()
	var force = game_music.size() <= 1
	transition_music(next_song, transition_time, force)

func _process(_delta):
	if fade_timer.is_stopped():
		return
	var percent = fade_timer.time_left / fade_timer.wait_time
	if pre_track:
		pre_track.volume_db = lerp(min_volume, max_volume, percent)
		
	if cur_track:
		cur_track.volume_db = lerp(min_volume, max_volume, 1.0-percent)

func finish_fade():
	if pre_track:
		pre_track.stop()
	if cur_track:
		cur_track.volume_db = max_volume
