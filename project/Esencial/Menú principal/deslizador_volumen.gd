extends HSlider

@export
var nombre_bus: String

var index_bus: int

# Al iniciar el deslizador agarramos el bus de audio que representa así ya lo tenemos en cuenta
func _ready() -> void:
	index_bus = AudioServer.get_bus_index(nombre_bus)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(index_bus))

# Cuándo el jugador cambia el volumen del bus de audio
func valor_cambiado(valor: float) -> void:
	AudioServer.set_bus_volume_db(index_bus, linear_to_db(valor))
