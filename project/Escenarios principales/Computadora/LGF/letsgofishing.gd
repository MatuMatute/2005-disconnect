extends Node2D

@onready var pop1 = $Sonidos/Pop1
@onready var pop2 = $Sonidos/Pop2
@onready var pop3 = $Sonidos/Pop3
@onready var tiempo = $Tiempo
@onready var circulo_grande = $Circulo_lago/Sprite_circulogrande
@onready var circulo_chico = $Circulo_lago/Sprite_circulochico

# Declaro nodos importantes de la interfaz
# signal cambiar_nivel
signal cambiar_puntuacion
signal ganaste

# Variables que controlan el gameplay
var nivel: int = 0
var puntuacion: int = 0
var deberia_rodar: bool = false
var peces_grandes: Array = [PackedScene, PackedScene, PackedScene, PackedScene, PackedScene, PackedScene]
var peces_chicos: Array = [PackedScene, PackedScene, PackedScene]

# Variables reguladoras de la dificultad ()
var vel_rueda_grande = 0.04
var vel_rueda_chica = 0.08

# Carga de los peces del minijuego
var tipo_pez: Array = [
	ResourceLoader.load("res://Assets/Pez/pez_azul.tscn"),
	ResourceLoader.load("res://Assets/Pez/pez_verde.tscn"),
	ResourceLoader.load("res://Assets/Pez/pez_rojo.tscn"),
	ResourceLoader.load("res://Assets/Pez/pez_purpura.tscn")
]

# Obtenemos una semilla única y conectamos las señales del juego pausado
func _ready() -> void:
	randomize()
	Global.pausado.connect(pausado)
	Global.resumido.connect(resumido)

func _process(_delta: float) -> void:
	if not Global.pausa and deberia_rodar:
		rodar()

# Esta función lo que hace es cambiar la puntuación y sumar un tipo de pez al inventario
func actualizar_puntuacion(cantidad: int, pez) -> void:
	puntuacion += cantidad
	cambiar_puntuacion.emit(puntuacion, pez)

# Función que organiza el comienzo del nivel
func _on_comenzar_nivel() -> void:
	actualizar_puntuacion(0, null)
	var posiciones_grande: Array = [Vector2(-170, 0), Vector2(170, 0), Vector2(0, 170), Vector2(0, -170), Vector2(-120, 140), Vector2(140, -120)]
	var posiciones_chico: Array = [Vector2(-45, -45), Vector2(45, -45), Vector2(0, 45)]
	
	# Estos loops se encargan de hacer spawnear a los peces
	for i in 6:
		peces_grandes[i] = obtener_pez()
		peces_grandes[i] = peces_grandes[i].instantiate()
		$Circulo_lago/Sprite_circulogrande.add_child(peces_grandes[i])
		peces_grandes[i].position = posiciones_grande[i]
		peces_grandes[i].pescado.connect(_pez_pescado)
	
	for i in 3:
		peces_chicos[i] = obtener_pez()
		peces_chicos[i] = peces_chicos[i].instantiate()
		$Circulo_lago/Sprite_circulochico.add_child(peces_chicos[i])
		peces_chicos[i].position = posiciones_chico[i]
		peces_chicos[i].pescado.connect(_pez_pescado)
	
	# Hacemos que la rueda deba girar y empezamos el juego
	deberia_rodar = true
	tiempo.paused = false
	tiempo.start()

# Obtiene un porcentaje que determina cual va a ser el tipo de pez
func obtener_pez():
	randomize()
	var porcentaje = randi_range(1, 100)
	
	if porcentaje <= 10:
		return tipo_pez[3]
	elif porcentaje > 10 and porcentaje <= 25:
		return tipo_pez[2]
	elif porcentaje > 25 and porcentaje <= 50:
		return tipo_pez[1]
	else:
		return tipo_pez[0]

# Para girar se suman o restan los grados de rotación
func rodar() -> void:
	circulo_grande.rotation_degrees += vel_rueda_grande
	circulo_chico.rotation_degrees -= vel_rueda_chica

# Cuándo un pez es pescado
func _pez_pescado(puntos, pez, nodo) -> void:
	randomize()
	
	# Hace que suene un sonido de burbuja entre tres opciones
	var sonido = randi_range(0, 2)
	match sonido:
		0: pop1.play()
		1: pop2.play()
		2: pop3.play()
	
	# Eliminamos el pez de los contenedores de peces
	peces_grandes.erase(nodo)
	peces_chicos.erase(nodo)
	
	# Verificamos sí quedan peces en el estanque o no
	if (peces_chicos.size() + peces_grandes.size()) == 0: 
		await get_tree().create_timer(1).timeout
		$Circulo_lago.hide()
		$"Caña".hide()
		ganaste.emit()
	
	# Y actualizamos la puntuación, añadiendo los puntos nuevos
	actualizar_puntuacion(puntos, pez)

# Pausar el timer
func pausado() -> void:
	tiempo.paused = true

# Reanudar el timer
func resumido() -> void:
	tiempo.paused = false

# Sí se acaba el tiempo
func _on_tiempo_timeout() -> void:
	$Circulo_lago.hide()
	$"Caña".hide()
