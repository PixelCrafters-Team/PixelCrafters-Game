extends Node2D


func _ready():
	$CentroDePesquisa/Teleport/AnimationTeleport.play("teleport_animation")
	$CentroDePesquisa/Teleport2/AnimationTeleport.play("teleport_animation")
	$CentroDePesquisa/Teleport3/AnimationTeleport.play("teleport_animation")
	$CentroDePesquisa/Teleport4/AnimationTeleport.play("teleport_animation")
