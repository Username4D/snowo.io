extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 17689

var peer: ENetMultiplayerPeer

func create_player():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
