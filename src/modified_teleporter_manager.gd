@tool
extends TeleporterManager

# MODIFIED TELEPORTER MANAGER TO ALLOW FOR CUSTOM CODE
@onready var world: Node3D = $"../World"
@onready var mansion_exterior: Node3D = $"../Mansion Exterior"
@onready var credits_control: Control = $"../Credits/Viewport/Credits/Control"
@onready var mansion_exterior_anim: AnimationPlayer = $"../MansionExteriorAnim"
@onready var credits: XRToolsViewport2DIn3D = $"../Credits"
@onready var music_handler: Node = $"../MusicHandler"
@onready var fade_menu: AnimationPlayer = $"../FadeMenu"
@onready var xr_origin_3d: XROrigin3D = $"../XRPlayer/XRViewport/XROrigin3D"

signal leave_mansion


func _play_end_credits():
	# Everything for the final sequence should be here.
	leave_mansion.emit()
	_fade_out()
	music_handler.start_title_music()
	mansion_exterior_anim.play("RESET")
	mansion_exterior_anim.play("light_movement")
	
	self.visible = false
	self.enabled = false
	await get_tree().create_timer(0.5).timeout
	credits.visible = true
	world.get_child(0).queue_free()
	mansion_exterior.visible = true
	await get_tree().create_timer(1).timeout
	_fade_in()
	credits_control.play_final_sequence()
	

func _teleport_player(location : Teleporter) -> void:
	# Still unsure about this, will have to confirm later, but it works as expected.
	print("[AVRE - TeleportManager] Teleported to "+location.teleporter_name+".")
	
	if "final_teleporter" in location:
		if location.final_teleporter:
			_play_end_credits()
			pass
	else:
		if !initial_teleport:
			_fade_out()
		if is_instance_valid(audio_node):
			audio_node.playing = true
		if is_instance_valid(fade_mesh):
			await get_tree().create_timer(1).timeout
		#xr_origin.position = location.teleporter_position
		
		# Separate y position from position of x and z axes to preserve height.
		xr_origin.position.x = location.teleporter_position.x
		xr_origin.position.y = xr_origin.position.y + location.teleporter_position.y
		xr_origin.position.z = location.teleporter_position.z
		
		xr_camera.rotation.y = deg_to_rad(location.teleporter_rotation.y)
		xr_camera.rotation.z = deg_to_rad(location.teleporter_rotation.z)
		xr_camera.rotation.x = deg_to_rad(location.teleporter_rotation.x)
		audio_node.position = xr_origin.position
		
		if is_instance_valid(spectator_camera):
			_teleport_spectator_camera(location)
		
		current_location = location
		_fade_in()
		emit_signal("location_changed", location.teleporter_name)


func _on_control_credits_play_finished() -> void:
	pass
	#await get_tree().create_timer(2).timeout
	#fade_menu.play("after_credits_fade_menu_in")
