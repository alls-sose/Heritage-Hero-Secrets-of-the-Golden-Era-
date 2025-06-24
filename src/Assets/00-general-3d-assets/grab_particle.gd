extends Node3D
@onready var particle: GPUParticles3D = $Particle

func _ready() -> void:
	particle.emitting = true
	self.visible = true

# only if grabbed by FunctionPickup
func _on_first_grab(pickable: Variant, by: Variant):
	if by is XRToolsFunctionPickup:
		particle.emitting = false
		
	# uncomment this line of code if we want to remove grabparticle after first grab
	# await get_tree().create_timer(2).timeout
	# self.queue_free()

func _start_reemitting():
	# if we want to re-enable the grab particle effect whenever.
	particle.emitting = true
