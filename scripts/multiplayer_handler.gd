extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 56983

var peer: ENetMultiplayerPeer
func create_player():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
