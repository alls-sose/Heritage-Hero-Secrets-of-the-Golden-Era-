extends CanvasLayer
#@onready var xr_viewport_display: CanvasLayer = $"../SubViewport/XRViewportDesktop"

@onready var type_of_view: RichTextLabel = $Control/TypeOfView
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_desktop: CanvasLayer = $"../DialogueDesktop"

# False means XR View is disabled.
var view_switch : bool

func _ready() -> void:
	view_switch = false
	
	if view_switch:
		type_of_view.text = "[color=#FFD700]XR View"
	else:
		type_of_view.text = "[color=#FFD700]Desktop View"

func _input(event):
	if Input.is_key_pressed(KEY_0) and not event.is_echo():
		print("[DEBUG] View Switched")
		view_switch = !view_switch
		
		if view_switch:
			type_of_view.text = "[color=#FFD700]XR View"
			animation_player.play("fade_in")
		
		else:
			type_of_view.text = "[color=#FFD700]Desktop View"
			animation_player.play("fade_out")
		
		await animation_player.animation_finished


func _on_button_pressed() -> void:
	view_switch = !view_switch
	if view_switch:
		type_of_view.text = "[color=#FFD700]XR View"
		animation_player.play("fade_in")
	else:
		type_of_view.text = "[color=#FFD700]Desktop View"
		animation_player.play("fade_out")
	await animation_player.animation_finished
