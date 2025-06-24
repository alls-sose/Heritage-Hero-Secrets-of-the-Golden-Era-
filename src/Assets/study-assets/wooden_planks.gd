extends Node3D

signal planks_cleared()
@onready var break_particle: GPUParticles3D = $BreakParticle
@onready var node_3d: Node3D = $Node3D
@onready var break_sound: AudioStreamPlayer3D = $BreakSound


func _ready() -> void:
	if EventManager.completed_events.has("ActionRemovePlanks_Done"):
		queue_free()


func _on_ois_strike_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	emit_signal("planks_cleared")
	node_3d.visible = false
	break_sound.play()
	break_particle.emitting = true

func _on_ois_strike_receiver_action_started(requirement: Variant, total_progress: Variant) -> void:
	$AudioStreamPlayer3D.play()


func _on_break_particle_finished() -> void:
	queue_free()
