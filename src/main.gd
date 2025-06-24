extends Node3D

signal game_started

var xr_interface : XRInterface
var anim_bool_disable : bool
var skip_tutorial : bool


@onready var world := $World


@onready var teleporter_manager: TeleporterManager = $TeleporterManager
@onready var kitchen_area_entrance: Teleporter = $"TeleporterManager/Kitchen Area Entrance"
@onready var kitchen_stove: Teleporter = $"TeleporterManager/Kitchen Stove"
@onready var dialogue_system: Node3D = $DialogueSystem


@onready var bedroom_area : Teleporter = $"TeleporterManager/Bedroom Center"

@onready var xr_camera_3d: XRCamera3D = $XRPlayer/XRViewport/XROrigin3D/XRCamera3D

@onready var fade_mesh: MeshInstance3D = $FadeMesh

@onready var main_viewport: XRToolsViewport2DIn3D = $"DialogueSystem/Main Viewport"
@onready var main_menu: XRToolsViewport2DIn3D = $MainMenu
@onready var dialogue_desktop: CanvasLayer = $DesktopScreen/SubViewport/DialogueDesktop

@onready var loading_screen: XRToolsViewport2DIn3D = $"DialogueSystem/Loading Screen"
@onready var loading_screen_desktop: CanvasLayer = $DesktopScreen/SubViewport/LoadingScreenDesktop
@onready var sub_viewport: SubViewport = $DesktopScreen/SubViewport
@onready var xr_viewport: SubViewport = $XRPlayer/XRViewport
@onready var mansion_exterior_anim: AnimationPlayer = $MansionExteriorAnim
@onready var mansion_exterior: Node3D = $"Mansion Exterior"

@onready var music_handler: Node = $MusicHandler
@onready var ois_journal: XRToolsPickable = $OISJournal
@onready var ois_flashlight_radio: XRToolsPickable = $OISFlashlightRadio
@onready var credits: XRToolsViewport2DIn3D = $Credits

var level
var level_string
var loading_screen_node


func _ready() -> void:
	get_tree().paused = true
	teleporter_manager.visible = false
	main_viewport.visible = false
	xr_interface = XRServer.find_interface("OpenXR")
	loading_screen_node = loading_screen.get_node("Viewport").get_child(0)
	main_menu.get_node("Viewport").get_child(0)
	
	dialogue_desktop.visible = false
	credits.visible = false
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR Initialized Successfully")
		
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		Engine.physics_ticks_per_second = 60
	
	if not Engine.is_editor_hint():
		fade_mesh.visible = true

var frame_counter = 0
var xr_frame_counter = 0 

#func _process(delta):
	#frame_counter += 1
	#xr_frame_counter += 1
	#if frame_counter % 3 == 0:
		#sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	#if frame_counter % 1.5 == 0:
		#xr_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

func _on_study_test_pressed() -> void:
	level_string = "res://src/study-level.tscn"
	
	_load_level(level_string)


func _on_kitchen_test_pressed() -> void:
	level_string = "res://src/kitchen-level.tscn"
	
	_load_level(level_string)
	
	teleporter_manager._teleport_player(kitchen_area_entrance)


func _on_level_stable_pressed() -> void:
	level_string = "res://src/level.tscn"
	
	_load_level(level_string)


func _on_tutorial_teleport_event_ended() -> void:
	if EventManager.completed_events.has("TeleportSofasActivate"):
		$TeleporterManager.enabled = true


func _on_bedroom_test_pressed() -> void:
	level_string = "res://src/bedroom-level.tscn"
	
	_load_level(level_string)
	
	teleporter_manager.enabled = true
	
	teleporter_manager._teleport_player(bedroom_area)

func _load_level(level_string_name) -> void:
	level_string = level_string_name
	
	if not anim_bool_disable:
		mansion_exterior_anim.play("enter_mansion")
		await get_tree().create_timer(2.5).timeout
	
	if skip_tutorial:
		_skip_tutorial()
	
	ResourceLoader.load_threaded_request(level_string)
	var res : ResourceLoader.ThreadLoadStatus
	
	
	_load_fade_screen_out()
	
	
	while true:
		var progress := []
		res = ResourceLoader.load_threaded_get_status(level_string, progress)
		if res != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			break;
		await get_tree().create_timer(0.2).timeout
	
	await get_tree().create_timer(0.1).timeout
	
	mansion_exterior.visible = false
	mansion_exterior_anim.play("RESET")
	
	var level : PackedScene = ResourceLoader.load_threaded_get(level_string)
	var new_level = level.instantiate()
	world.add_child(new_level)
	get_tree().paused = false
	
	main_menu.visible = false
	main_viewport.visible = true
	dialogue_desktop.visible = true
	teleporter_manager.visible = true
	ois_flashlight_radio.visible = true
	ois_journal.visible = true
	music_handler.start_in_game_music()
	
	_load_fade_screen_in()
	
	emit_signal("game_started")

func _load_fade_screen_out() -> void:
	teleporter_manager._fade_out()
	loading_screen_node._fade_in()
	loading_screen_desktop._fade_in()

func _load_fade_screen_in() -> void:
	teleporter_manager._fade_in()
	loading_screen_node._fade_out()
	loading_screen_desktop._fade_out()


func _on_tutorial_key_items_event_ended() -> void:
	QuestControl.add_active_quest("QuestPrintArticle")
	QuestControl.update_active_quests()


func _on_main_menu_anim_check_box_toggled(toggled_on: bool) -> void:
	anim_bool_disable = toggled_on
	
@onready var tutorial_inventory: TutorialEvent = $TutorialEvents/TutorialInventory
@onready var tutorial_journal_quest_log: TutorialEvent = $TutorialEvents/TutorialJournalQuestLog
@onready var tutorial_flashlight_radio: TutorialEvent = $TutorialEvents/TutorialFlashlightRadio
@onready var tutorial_teleport: TutorialEvent = $TutorialEvents/TutorialTeleport
@onready var tutorial_key_items: TutorialEvent = $TutorialEvents/TutorialKeyItems
@onready var tutorial_attach_action: TutorialEvent = $TutorialEvents/TutorialAttachAction

func _on_skip_tutorial_toggled(toggled_on: bool) -> void:
	skip_tutorial = toggled_on
	
func _skip_tutorial() -> void:
	tutorial_inventory.close_event()
	tutorial_flashlight_radio.close_event()
	tutorial_journal_quest_log.close_event()
	tutorial_teleport.close_event()
	tutorial_key_items.close_event()
	tutorial_attach_action.close_event()
	dialogue_system._print_dialogue("", "", 0, null, false, false)
	QuestControl.update_active_quests()
	
