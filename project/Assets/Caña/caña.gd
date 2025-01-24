extends CharacterBody2D

# Declaro los nodos de la caña
@onready var Cuerda = $Cuerda
@onready var Sombra = $Sombra
@onready var Colision_anzuelo = $Anzuelo/Colision_anzuelo

# Declaro constantes y variables importantes
const velocidad = 200
var pescando: bool = false
var condicion: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Ajustar la posición del anzuelo al de la cuerda
	$Anzuelo.position = Cuerda.get_point_position(1)
	# Función de movimiento
	match pescando:
		false: 
			match Global.pausa:
				false:
					movimiento()
					if Input.is_action_just_pressed("ui_select"): 
						pescando = true
						condicion = true
		true:
			velocity = Vector2.ZERO
			match condicion:
				true: pescar()
				false: retroceder()
	
	move_and_slide()

func movimiento() -> void:
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad

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
