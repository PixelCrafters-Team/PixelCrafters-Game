extends Node2D

var packed_jogador = preload("res://characters/scenes/dogs/character_estrela.tscn")

func _ready():
	var lista_jogadores = Networking.retornar_lista()
	for i in range(lista_jogadores.size()):
		var obj = packed_jogador.instantiate()
		$Jogadores.add_child(obj)
		obj.position = Vector2(512, 300)
		obj.name = str(lista_jogadores[i][0])
		obj.set_multiplayer_authority(lista_jogadores[i][0])
		obj.set_nickname(lista_jogadores[i][1])
	pass
