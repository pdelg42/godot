# Questo script prevede la gestione del movimento di un 
# player, utilizzando la classe Input ed alcune delle 
# sue funzioni (+ qualche chicca)

extends KinematicBody2D

# class_name Name !coming soon

# signal signal_name !coming soon

# NB: per le variabili non è necessario identificare		#
# il tipo con i ":" ma è buona norma ed aiuta l'ide			#			
# ad identificarle preventivamente e a proporre i consigli	#

# le costanti sono abbastanza self explanatory
const particles_lifetime	: float = 200.0

# le onready var sono variabili che si vanno a definire 
# quando il nodo entra nella scena; è equivalente a definire
# una variabile nella funzione _ready()
onready var sprite		: Sprite = $Sprite                                      # metodo per referenziare
onready var particles	: Particles2D = $Particles                              # nodi figli
onready var	velocity	: Vector2 = Vector2(0, 0)

# le export var permettono all'ambiente di poter essere
# visualizzate come parametro grafico
export (float) var	speed = 100.0

# le var semplici equivalgono a variabili pubbliche di qualsiasi
# linguaggio ad oggetti e a differenza delle onready esistono 
# direttamente dalla creazione (a chiamata della funzione _init(),
# è possibile definire per queste una funzione di 
# "assegnazione/recupero" pre poter eseguire una funzione specifica
# ogni qualvolta la si chiama
var	direction	: Vector2 = Vector2.ZERO
var	face_to		: Vector2 = Vector2.UP setget set_face_to, get_face_to

# funzione set e get legata a face_to
func set_face_to(value):
	if value == Vector2.ZERO:
		return ;
	face_to = value
	look_at(face_to)

func get_face_to() -> Vector2:
	return (face_to)

func _physics_process(_delta):
	
	#la funzione usata rileva il livello di pressione sul dispositivo di input
	#se quest ultimo è predisposto altrimenti normalizza a 0 e 1
	direction.x = Input.get_action_strength("ui_right") \
				- Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") \
				- Input.get_action_strength("ui_up")
	# il risultato gestito in questo modo ritorna un valore positivo se premuti
	# right o down; negativo se left o up; == 0 se premuti insieme o nessuno
	
	# funzione di set per andare a modificare la rotazione del player
	set_face_to(global_position + direction.normalized());
	# imponiamo che il direzionamento deve essere rispetto il player e non
	# l'origine (O(0, 0) + dir_vec)
	
	#questa è una sboronata XD
	particles.lifetime = lerp(velocity.length() / 200, 0, 0.2)
	# è possibile fare riferimento alle variabili di un nodo figlio in questo
	# modo oppure chiamando un set(); lerp permette che la variazione di una
	# variabile fi tipo int o float avvenga tramite un certo step
	
	# stessa situazione ma con i vettori 
	velocity = velocity.linear_interpolate(direction.normalized() * speed, 0.06)
	
	# move_and_slide non ha bisogno di moltiplicare delta alla velocità (lo fà già di suo)
	velocity = move_and_slide(velocity);
