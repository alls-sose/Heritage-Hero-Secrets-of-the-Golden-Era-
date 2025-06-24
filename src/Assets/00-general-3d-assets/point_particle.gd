extends Node3D
@onready var particle: GPUParticles3D = $Particle
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var added_quest : bool

func _ready() -> void:
	particle.emitting = true
	self.visible = true
	added_quest = false


func _start_reemitting():
	# if we want to re-enable the grab particle effect whenever.
	particle.emitting = true


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		particle.emitting = false
		if !added_quest:
			QuestControl.add_active_quest("QuestEnterBedroom")
			QuestControl.update_active_quests()
			added_quest = true
		animation_player.play("try_door")
		await animation_player.animation_finished
