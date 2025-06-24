extends Event

@onready var abscbn_contract_pickable: XRToolsPickable = $"../ABSCBNContractPickable"
@onready var cdcp_contract_pickable: XRToolsPickable = $"../CDCPContractPickable"
@onready var tadeco_contract_pickable: XRToolsPickable = $"../TADECOContractPickable"




func _on_safe_keypad_lock_solved() -> void:
	abscbn_contract_pickable.enabled = true
	cdcp_contract_pickable.enabled = true
	tadeco_contract_pickable.enabled = true
	emit_signal("event_ended")
	close_event()
	QuestControl.update_active_quests()
