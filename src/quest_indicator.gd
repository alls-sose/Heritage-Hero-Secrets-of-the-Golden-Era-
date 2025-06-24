extends Control

@onready var quest_name: Label = $Control/VBoxContainer/QuestName
@onready var quest_description: Label = $Control/VBoxContainer/QuestDescription
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var xr_camera_anchor : Node3D = get_parent().get_parent().get_parent().xr_camera_anchor
@onready var xr_anchor_to_object : Node3D = get_parent().get_parent().get_parent().xr_anchor_to_object
@onready var slots_distance_to_player : float = get_parent().get_parent().get_parent().slots_distance_to_player
@onready var local_transform_adjustment : Vector3 = get_parent().get_parent().get_parent().local_transform_adjustment
@onready var height_adjustment : float = get_parent().get_parent().get_parent().height_adjustment


func _physics_process(delta: float) -> void:
	reposition_ui()

func show_quest_indicator(q_name : String, q_description : String) -> void:
	quest_name.text = q_name
	quest_description.text = q_description
	
	anim.play("fade_in")
	
	await anim.animation_finished
	
	await get_tree().create_timer(5).timeout
	
	anim.play("fade_out")

func reposition_ui() -> void:
	var position_offset : Vector3
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		var position_x_rotate = slots_distance_to_player * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		var position_z_rotate = slots_distance_to_player * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		self.get_parent().get_parent().rotation.y = xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y
		position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
		self.get_parent().get_parent().global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset
