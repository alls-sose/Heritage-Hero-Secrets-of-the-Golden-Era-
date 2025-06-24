extends Node3D

@export_category("Player Options")
@export var xr_anchor_to_object: XROrigin3D
@export var xr_camera_anchor: XRCamera3D
@export var inventory_toggler_hand : XRController3D
@export var inventory_toggler_button : String
@export var audio_node : AudioStreamPlayer3D

@export var local_transform_adjustment : Vector3
@export var slots_distance_to_player : float = 0.75
@export var height_adjustment : float = 1.4


func _process(delta: float) -> void:
	reposition_inventory()


func reposition_inventory() -> void:
	var position_offset : Vector3
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		var position_x_rotate = slots_distance_to_player * cos(xr_camera_anchor.global_rotation.y - self.get_parent().global_rotation.y)
		var position_z_rotate = slots_distance_to_player * sin(xr_camera_anchor.global_rotation.y - self.get_parent().global_rotation.y)
		self.rotation.y = xr_camera_anchor.global_rotation.y - self.get_parent().global_rotation.y
		position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
		self.global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset
