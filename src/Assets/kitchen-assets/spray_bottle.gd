@tool
extends XRToolsPickable
@onready var spray_particle: GPUParticles3D = $SprayParticle
@onready var spray_audio: AudioStreamPlayer3D = $SprayAudio

var pickup_bool : bool

func _ready() -> void:
	super()


func _on_action_pressed(pickable: Variant) -> void:
	spray_particle.emitting = true
	spray_audio.play()
	await spray_audio.finished
