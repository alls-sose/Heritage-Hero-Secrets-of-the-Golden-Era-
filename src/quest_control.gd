extends Node

signal quests_updated()

@onready var quest_tracker_ui := get_tree().get_root().get_node("Main/OISJournal/Viewport2Din3D/Viewport/JournalUI/VBoxContainer/QuestUI")
@onready var music_handler := get_tree().get_root().get_node("Main/MusicHandler")
@onready var quest_indicator := get_tree().get_root().get_node("Main/DialogueSystem/QuestIndicator/Viewport/QuestIndicator")

func add_active_quest(quest_name : String) -> void:
	for quest in get_children():
		if quest.name == quest_name:
			print("Quest Already Active")
			return
	
	var quest := Quest.new()
	quest.name = quest_name
	
	add_child(quest)
	quest.connect("quest_started", quest_tracker_ui._add_quest)
	quest.connect("quest_updated", quest_tracker_ui._update_quest_progress)
	quest.connect("quest_ended", quest_tracker_ui._remove_quest)
	quest.connect("quest_ended", update_active_quests)

	quest.initialize_quest()
	quest_indicator.show_quest_indicator(quest.quest_description["Name"], quest.quest_description["Description"])


func update_active_quests() -> void:
	print("ohno a quest has ended")
	for child in get_children():
		child.update_quest()
	print("Quests successfully updated")
	emit_signal("quests_updated")
