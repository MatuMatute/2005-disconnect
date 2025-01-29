extends MarginContainer

@onready var musica = $Audio/Musica/Jingle
@onready var victoria = $Audio/Sonido/Win
@onready var mensaje_grande = $Top/wh_interface/mensaje_grande

signal cerrado

# Activar la música
func _ready() -> void:
	musica.play()

# Al cerrar la ventana
func _on_cerrar_pressed() -> void:
	queue_free()
	cerrado.emit()

# Se activa cuando embocás todos los anillos, y muestra un mensaje
func _on_waterhoops_ganaste() -> void:
	musica.stop()
	mensaje_grande.show()
	victoria.play()
