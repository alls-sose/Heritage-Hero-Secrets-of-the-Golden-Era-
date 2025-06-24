@tool
extends XRToolsPickable

@onready var yeast_particle: GPUParticles3D = $YeastParticle
var pickup_bool : bool
@onready var ois_one_hand_tool_asm: OISOneHandToolASM = $OISActorComponent/OISOneHandToolASM

func _ready() -> void:
	super()
	yeast_particle.emitting = false

func _process(delta) -> void:
	if pickup_bool: 
		for x in range(-1,1):
			if ((360*x) + 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x) + 270):
				if ois_one_hand_tool_asm.state.name == "ActiveCollidingState":
					yeast_particle.emitting = true
			elif ((360*x) - 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x)+ 90):
				yeast_particle.emitting = false

func _on_grabbed(pickable: Variant, by: Variant) -> void:
	pickup_bool = true

func _on_released(pickable: Variant, by: Variant) -> void:
	pickup_bool = false
	yeast_particle.emitting = false
