Jkr.StartUDP(6000)
msg = Jkr.Message()
Jkr.SendUDP(msg, "127.0.0.1", 6001)
