extends Event

@onready var gate_key: XRToolsPickable = $"../GateKey"
@onready var nutribun_recipe: XRToolsPickable = $"../NutribunRecipe"
@onready var animation_player: AnimationPlayer = $"../StudyRoomDesk/AnimationPlayer"
@onready var malakas_maganda_tape: XRToolsPickable = $"../MalakasMagandaTape"
@onready var kitchen_area_teleporter = get_tree().get_root().get_node("Main/TeleporterManager/Near Lampshade")


func _on_desk_lock_lock_solved() -> void:
	await animation_player.animation_finished
	gate_key.process_mode = Node.PROCESS_MODE_INHERIT
	gate_key.enabled = true
	gate_key.visible = true
	nutribun_recipe.process_mode = Node.PROCESS_MODE_INHERIT
	nutribun_recipe.enabled = true
	nutribun_recipe.visible = true
	malakas_maganda_tape.process_mode = Node.PROCESS_MODE_INHERIT
	malakas_maganda_tape.enabled = true
	malakas_maganda_tape.visible = true
	
	kitchen_area_teleporter.teleporter_active = true
	kitchen_area_teleporter.get_parent()._set_teleporter_states() 
	emit_signal("event_ended")
	close_event()
	QuestControl.add_active_quest("QuestGoToKitchen")
	QuestControl.update_active_quests()
