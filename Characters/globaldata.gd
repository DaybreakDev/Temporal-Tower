extends Node

var hp = 100
var flags = {
	"Dash": false,
	"SilkGun": false,
	
}
@export_flags("Dash","Silkgun","AtomicHammer","Haunt","Vector","Ignite")var powers = 0
var Dash: int = 1
var Silkgun: int = 2
