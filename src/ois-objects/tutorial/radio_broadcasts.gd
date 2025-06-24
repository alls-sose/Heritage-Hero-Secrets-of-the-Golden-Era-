extends Node

@onready var static_effect: AudioStreamPlayer3D = $"../StaticEffect"
@onready var static_particle: GPUParticles3D = $"../StaticParticle"
@onready var static_effect_fade_out: AnimationPlayer = $"../StaticEffectFadeOut"

var prioritized_event : String
var priority_changed : bool

signal prio_changed


func _play_static():
	static_effect_fade_out.play("fade_in")

func _change_prio_event(event: Event) -> void:
	prioritized_event = event.name
	print("Changed event to: "+prioritized_event)
	static_effect_fade_out.play("fade_in")
	prio_changed.emit()

func _on_child_exiting_tree(node: Node) -> void:
	pass
