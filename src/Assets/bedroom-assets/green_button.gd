extends XRToolsPickable

func _ready() -> void:
	super()
	self.visible = false


func _on_briefcase_briefcase_opened() -> void:
	self.visible = true
