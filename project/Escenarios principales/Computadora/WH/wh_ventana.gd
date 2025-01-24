extends MarginContainer

@onready var musica = $Audio/Jingle

signal cerrado

func _ready() -> void:
	musica.play()

func _process(_delta: float) -> void:
	pass

func _on_cerrar_pressed() -> void:
	queue_free()
	cerrado.emit()
