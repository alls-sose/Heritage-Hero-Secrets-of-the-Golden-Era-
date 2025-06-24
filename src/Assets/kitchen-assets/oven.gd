extends Node3D

@onready var top_door: MeshInstance3D = $"oven1/Top Door"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tray_slot_collision: CollisionShape3D = $TraySlot/CollisionShape3D
@onready var snap_zone: XRToolsSnapZone = $InventorySlot/SnapZone
@onready var tray_slot: InventorySlot = $TraySlot
@onready var mesh_instance_3d: MeshInstance3D = $TraySlot/MeshInstance3D
@onready var progress_view: Node3D = $"Progress View"

@onready var oven_close: AudioStreamPlayer3D = $OvenClose
@onready var oven_tray_place: AudioStreamPlayer3D = $OvenTrayPlace
@onready var oven_open: AudioStreamPlayer3D = $OvenOpen

var tray_object_ref : Node3D
var tween : Tween
var tween_anim_bool : bool

signal emit_baking_done

func _ready() -> void:
	progress_view.visible = false

func _physics_process(delta):
	if tween_anim_bool:
		var timer_time = animation_player.get_current_animation_position() / animation_player.get_current_animation_length()
		progress_view.change_progress_value(timer_time * 100)

func _on_open_oven_action_completed(requirement: Variant, total_progress: Variant) -> void:
	oven_open.play()
	if animation_player.is_playing():
		return
	animation_player.play("open_oven")
	await animation_player.animation_finished
	tray_slot.slot_enabled = true
	mesh_instance_3d.visible = false


func _on_close_oven_action_completed(requirement: Variant, total_progress: Variant) -> void:
	oven_close.play()
	if animation_player.is_playing():
		return
	animation_player.play("close_oven")
	await animation_player.animation_finished
	tray_slot.slot_enabled = false
	mesh_instance_3d.visible = false


func _on_oven_switch_twist_action_completed(requirement: Variant, total_progress: Variant) -> void:
	if animation_player.is_playing():
		return
	animation_player.play("turn_oven_on")
	progress_view.visible = true
	progress_view.progress_idle_state()
	tween = get_tree().create_tween()
	tween_anim_bool = true
	await animation_player.animation_finished
	tween_anim_bool = false
	progress_view.progress_complete_anim()
	if is_instance_valid(tray_object_ref):
		tray_object_ref._spawn_finished_nutribuns()
	emit_baking_done.emit()


func _on_tray_slot_current_object_in_slot(object: Variant, row: Variant, col: Variant) -> void:
	oven_tray_place.play()
	if is_instance_valid(object):
		if object.name == "Tray":
			if object.i_am_ready:
				tray_object_ref = object
