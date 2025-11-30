extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 17689

var peer = NodeTunnelPeer.new()
var joint_id = ""

func _ready() -> void:
	print("read")
	multiplayer.multiplayer_peer = peer
	peer.connect_to_relay("relay.nodetunnel.io", 9998)
	
	await peer.relay_connected
	
	print("connected")
func create_player(ip):
	peer.join(ip)
	joint_id = ip
	multiplayer.multiplayer_peer = peer

func create_server():
	peer.host()
	await peer.hosting
	multiplayer.multiplayer_peer = peer
