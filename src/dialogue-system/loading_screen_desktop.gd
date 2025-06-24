@tool
extends CanvasLayer

@onready var loading_circle: TextureRect = $"Control/Loading Circle"
var omegalul_test : int
@onready var control: Control = $Control
@onready var xr_controls_control: Control = $"../XRViewportControls/Control"

@export var dialogue_system : Node3D

@onready var xr_camera_anchor : Node3D = dialogue_system.xr_camera_anchor
@onready var xr_anchor_to_object : Node3D = dialogue_system.xr_anchor_to_object
@onready var slots_distance_to_player : float = dialogue_system.slots_distance_to_player
@onready var local_transform_adjustment : Vector3 = dialogue_system.local_transform_adjustment
@onready var height_adjustment : float = dialogue_system.height_adjustment
@onready var switch_button: Button = $"../XRViewportControls/Control/Button"

func _ready() -> void:
	control.modulate = Color(1,1,1,0)
	
func _fade_in() -> void:
	switch_button.disabled = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(xr_controls_control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(control, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
func _fade_out() -> void:
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(xr_controls_control, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	switch_button.disabled = false
