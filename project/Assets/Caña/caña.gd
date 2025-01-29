extends CharacterBody2D

# Declaro los nodos de la caña
@onready var Cuerda = $Cuerda
@onready var Sombra = $Sombra
@onready var Colision_anzuelo = $Anzuelo/Colision_anzuelo

# Declaro constantes y variables importantes
const velocidad = 200
var pescando: bool = false
var condicion: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Ajustar la posición del anzuelo al de la cuerda
	$Anzuelo.position = Cuerda.get_point_position(1)
	
	# Función de movimiento
	if not Global.pausa:
		match pescando:
			false: 
				movimiento()
				if Input.is_action_just_pressed("ui_select"): 
					pescando = true
					condicion = true
			true:
				# No se mueve
				velocity = Vector2.ZERO
				match condicion:
					true:
						# Va a pescar
						pescar()
					false: 
						# Va a subir el anzuelo
						retroceder()
	
	move_and_slide()

# Controla el movimiento de la caña dependiendo del botón que apretes
func movimiento() -> void:
	# Va a detectar la entrada de los controles y según el botón va a establecer la dirección de movimiento
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad

"""QUIZÁS INTENTAR APLICAR UN TWEEN, ¿EN LUGAR DE SUMAR POSICIÓN?"""
func pescar() -> void:
	if Cuerda.get_point_position(1).y < 120:
		Cuerda.set_point_position(1, Vector2(Cuerda.get_point_position(1).x, Cuerda.get_point_position(1).y+2))
	elif Cuerda.get_point_position(1).y == 120:
		Sombra.hide()
		Colision_anzuelo.disabled = false
		await get_tree().create_timer(0.5).timeout
		condicion = false

func retroceder() -> void:
	Sombra.show()
	if Cuerda.get_point_position(1).y > 0:
		Colision_anzuelo.disabled = true
		Cuerda.set_point_position(1, Vector2(Cuerda.get_point_position(1).x, Cuerda.get_point_position(1).y-2))
	elif Cuerda.get_point_position(1).y == 0:
		pescando = false
