@tool
extends XRToolsPickable

@onready var sugar_particle: GPUParticles3D = $SugarParticle
var pickup_bool : bool
@onready var ois_one_hand_tool_asm: OISOneHandToolASM = $OISActorComponent/OISOneHandToolASM

func _ready() -> void:
	super()
	sugar_particle.emitting = false

func _process(delta) -> void:
	if pickup_bool:
		for x in range(-1,1):
			if ((360*x) + 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x) + 270):
				if ois_one_hand_tool_asm.state.name == "ActiveCollidingState":
					sugar_particle.emitting = true
			elif ((360*x) - 90) <= self.rotation_degrees.z && self.rotation_degrees.z <= ((360*x)+ 90):
				sugar_particle.emitting = false

func _on_grabbed(pickable: Variant, by: Variant) -> void:
	pickup_bool = true

func _on_released(pickable: Variant, by: Variant) -> void:
	pickup_bool = false
	sugar_particle.emitting = false
