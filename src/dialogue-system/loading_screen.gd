@tool
extends CanvasLayer

@onready var loading_circle: TextureRect = $"Control/Loading Circle"
var omegalul_test : int
@onready var control: Control = $Control

@onready var xr_camera_anchor : Node3D = get_parent().get_parent().get_parent().xr_camera_anchor
@onready var xr_anchor_to_object : Node3D = get_parent().get_parent().get_parent().xr_anchor_to_object
@onready var slots_distance_to_player : float = get_parent().get_parent().get_parent().slots_distance_to_player
@onready var local_transform_adjustment : Vector3 = get_parent().get_parent().get_parent().local_transform_adjustment
@onready var height_adjustment : float = get_parent().get_parent().get_parent().height_adjustment

func _ready() -> void:
	control.modulate = Color(1,1,1,0)

func _process(delta: float) -> void:
	reposition_ui()
	
func _fade_in() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(control, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
func _fade_out() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished

func reposition_ui() -> void:
	var position_offset : Vector3
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		var position_x_rotate = slots_distance_to_player * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		var position_z_rotate = slots_distance_to_player * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		self.get_parent().get_parent().rotation.y = xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y
		position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
		self.get_parent().get_parent().global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset
