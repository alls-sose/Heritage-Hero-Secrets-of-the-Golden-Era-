extends Node3D
@onready var particle: GPUParticles3D = $Particle

func _ready() -> void:
	particle.emitting = true
	self.visible = true


func _start_reemitting():
	# if we want to re-enable the grab particle effect whenever.
	particle.emitting = true


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		particle.emitting = false
		queue_free()
