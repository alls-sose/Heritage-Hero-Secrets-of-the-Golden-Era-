extends Node

@onready var light := $"../SpotLight3D"

@onready var flashlight_slot := get_tree().get_root().get_node("Main/HipSlot/HipSlot")
@onready var viewport_2_din_3d: XRToolsViewport2DIn3D = $"../Viewport2Din3D"
@onready var animation_player: AnimationPlayer = $"../Viewport2Din3D/Viewport/Indicator/AnimationPlayer"
@onready var static_effect_fade_out: AnimationPlayer = $"../StaticEffectFadeOut"
@onready var interactable_handle: XRToolsInteractableHandle = $"../Crank/InteractableHandle"



func _ready() -> void:
	viewport_2_din_3d.visible = false
	animation_player.stop()
	light.visible = true


func _on_ois_flashlight_radio_released(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		flashlight_slot._pick_up_object_init(get_parent())
		viewport_2_din_3d.visible = false
		interactable_handle.enabled = false
		animation_player.stop()
		static_effect_fade_out.play("fade_out")


func _on_interactable_handle_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		viewport_2_din_3d.visible = true
		animation_player.play("turn")


func _on_interactable_handle_released(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		viewport_2_din_3d.visible = false
		animation_player.stop()


func _on_ois_flashlight_radio_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		interactable_handle.enabled = true
		static_effect_fade_out.play("fade_out")
