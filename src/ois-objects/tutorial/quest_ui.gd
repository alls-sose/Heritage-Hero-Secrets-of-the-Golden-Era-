extends HBoxContainer

@onready var quest_ui_page1 := $MarginContainer/Page1
@onready var quest_ui_page2 := $MarginContainer2/Page2

var quest_list : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _add_quest(quest_name : String) -> void:
	quest_list[quest_name] = EventManager.quest_library[quest_name]["QuestCompletionTracker"]
	refresh_ui()

func _remove_quest(quest_name : String) -> void:
	quest_list.erase(quest_name)
	refresh_ui()


func _update_quest_progress(quest_name : String) -> void:
	print("YOOOOO UPDATED QUEST")
	refresh_ui()


func refresh_ui() -> void:
	quest_ui_page1.clear()
	quest_ui_page2.clear()
	for quest in quest_list:
		if quest_ui_page1.get_line_count() <= 16:
			quest_ui_page1.append_text(EventManager.quest_library[quest]["QuestDescription"]["Name"] + "\n")
		else:
			quest_ui_page2.append_text(EventManager.quest_library[quest]["QuestDescription"]["Name"] + "\n")
		
		for quest_req in quest_list[quest]:
			if quest_ui_page1.get_line_count() <= 16:
				if quest_list[quest][quest_req].size() > 1:
					var iterator : int = 0
					for event in quest_req:
						if event in EventManager.completed_events:
							iterator += 1
					if iterator == quest_req.size():
						quest_ui_page1.append_text("[bgcolor=#FF0000]" + "    - " + quest_req + " : " + str(iterator) +"/" + str(quest_req.size()) + "[color=#FF0000]     -[/color]" + "[/bgcolor]" + "\n")
					else:
						quest_ui_page1.append_text("    - " + quest_req + " : " + str(iterator) +"/" + str(quest_req.size()) + "\n")
				else:
					print(quest_list[quest][quest_req][0] in EventManager.completed_events)
					if quest_list[quest][quest_req][0] in EventManager.completed_events:
						quest_ui_page1.append_text("[bgcolor=#FF0000]" + "    - " + quest_req + "[color=#FF0000]     -[/color]" + "[/bgcolor]" + "\n")
					else:
						quest_ui_page1.append_text("    - " + quest_req + "\n")
			else:
				if quest_list[quest][quest_req].size() > 1:
					var iterator : int = 0
					for event in quest_req:
						if event in EventManager.completed_events:
							iterator += 1
					if iterator == quest_req.size():
						quest_ui_page2.append_text("[bgcolor=#FF0000]" + "    - " + quest_req + " : " + str(iterator) +"/" + str(quest_req.size()) + "[color=#FF0000]     -[/color]" + "[/bgcolor]" + "\n")
					else:
						quest_ui_page2.append_text("    - " + quest_req + " : " + str(iterator) +"/" + str(quest_req.size()) + "\n")
				else:
					if quest_list[quest][quest_req][0] in EventManager.completed_events:
						quest_ui_page2.append_text("[bgcolor=#FF0000]" + "    - " + quest_req + "[color=#FF0000]     -[/color]" + "[/bgcolor]" + "\n")
					else:
						quest_ui_page2.append_text("    - " + quest_req + "\n")
