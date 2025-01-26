extends MarginContainer

# Declaro variables que sirven como atajos para acceder a nodos del interfaz
#@onready var etiqueta_nivel = $fishing_interface/fishing_container/Nivel
@onready var etiqueta_tiempo = $Top/fishing_interface/tiempo_container/Tiempo
@onready var etiqueta_puntuacion = $Top/fishing_interface/puntuacion_container/Puntuacion
@onready var control_orden = $Top/fishing_interface/control_orden
@onready var mostrar_nivel = $Top/fishing_interface/Mostrar_nivel
@onready var juego = $Top/letsgofishing
@onready var tiempo = $Top/letsgofishing/Tiempo
@onready var conteo_peces_azules = $Top/fishing_interface/inv_container/pez_azul/Conteo

# Coloco una variable para saber cuando y qué el nivel se está jugando e inventario
var transicion: bool = true
var nivel_actual: int = 1
var peces_azules = 0

# Señal para que la computadora sepa que el programa se cerró
signal cerrado
signal comenzar_nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control_orden.hide()
	tiempo.paused = true
	tiempo.timeout.connect(_game_over)
	Global.pausado.connect(pausado)
	Global.resumido.connect(resumido)
	$Audio/Musica/Jingle.play()
	$Transicion.stop()
	introduccion_nivel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match transicion:
		false:
			etiqueta_tiempo.text = str(snappedf(tiempo.get_time_left(), 0.1))
		true:
			etiqueta_tiempo.text = ""
			#etiqueta_nivel.text = ""
			etiqueta_puntuacion.text = ""

func introduccion_nivel() -> void:
	mostrar_controles()
	mostrar_nivel.text = "game start"
	$Transicion.start()
	await $Transicion.timeout
	mostrar_nivel.text = ""
	transicion = false
	comenzar_nivel.emit()

func mostrar_controles() -> void:
	control_orden.show()
	await get_tree().create_timer(12).timeout
	control_orden.hide()

func _on_cerrar_pressed() -> void:
	queue_free()
	cerrado.emit()

func _on_letsgofishing_cambiar_nivel() -> void:
	pass
	#etiqueta_nivel.text = "nivel\n" + str(nivel)

func _on_letsgofishing_cambiar_puntuacion(puntuacion, pez) -> void:
	etiqueta_puntuacion.text = str(puntuacion)
	
	match pez:
		"Azul": 
			peces_azules += 1
			conteo_peces_azules.text = str(peces_azules)

func pausado() -> void:
	$Transicion.paused = true

func resumido() -> void:
	$Transicion.paused = false

func _game_over() -> void:
	tiempo.paused = true
	$Audio/Musica/Jingle.stop()
	$Audio/Sonidos/Lose.play()
	mostrar_nivel.text = "game over"

func _on_letsgofishing_ganaste() -> void:
	tiempo.paused = true
	$Audio/Musica/Jingle.stop()
	$Audio/Sonidos/Win.play()
	mostrar_nivel.text = "you win!"
