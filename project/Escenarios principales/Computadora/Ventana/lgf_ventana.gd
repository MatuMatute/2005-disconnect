extends MarginContainer

# Declaro variables que sirven como atajos para acceder a nodos del interfaz
@onready var etiqueta_nivel = $fishing_interface/fishing_container/Nivel
@onready var etiqueta_tiempo = $fishing_interface/fishing_container/Tiempo
@onready var etiqueta_puntuacion = $fishing_interface/fishing_container/Puntuacion
@onready var mostrar_nivel = $fishing_interface/Mostrar_nivel
@onready var juego = $letsgofishing
@onready var tiempo = $letsgofishing/Tiempo

# Coloco una variable para saber cuando y qué el nivel se está jugando
var transicion: bool = true
var nivel_actual: int = 1

# Señal para que la computadora sepa que el programa se cerró
signal cerrado
signal comenzar_nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tiempo.paused = true
	introduccion_nivel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match transicion:
		false:
			etiqueta_tiempo.text = str(snappedf(tiempo.get_time_left(), 0.1))
		true:
			etiqueta_tiempo.text = ""
			etiqueta_nivel.text = ""
			etiqueta_puntuacion.text = ""

func introduccion_nivel() -> void:
	mostrar_nivel.text = "nivel " + str(nivel_actual)
	await get_tree().create_timer(3).timeout
	mostrar_nivel.text = ""
	transicion = false
	comenzar_nivel.emit()

func _on_cerrar_pressed() -> void:
	queue_free()
	cerrado.emit()

func _on_letsgofishing_cambiar_nivel(nivel) -> void:
	etiqueta_nivel.text = "nivel\n" + str(nivel)

func _on_letsgofishing_cambiar_puntuacion(puntuacion) -> void:
	etiqueta_puntuacion.text = "puntuación\n" + str(puntuacion)
