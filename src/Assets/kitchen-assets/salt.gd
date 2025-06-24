@tool
extends XRToolsPickable

@onready var salt_particle: GPUParticles3D = $SaltParticle
@onready var ois_one_hand_tool_asm: OISOneHandToolASM = $OISActorComponent/OISOneHandToolASM

func _ready() -> void:
	super()
	salt_particle.emitting = false
	
func _process(delta) -> void:
	if pickup_bool:
		for x in range(-1,1):
			if ((360*x) + 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x) + 270):
				if ois_one_hand_tool_asm.state.name == "ActiveCollidingState":
					salt_particle.emitting = true
			elif ((360*x) - 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x)+ 90):
				salt_particle.emitting = false

var pickup_bool : bool

func _on_grabbed(pickable: Variant, by: Variant) -> void:
	pickup_bool = true

func _on_released(pickable: Variant, by: Variant) -> void:
	pickup_bool = false
	salt_particle.emitting = false
