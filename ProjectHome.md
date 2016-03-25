I access my serial ports via telnet using ser2net, so these perl scripts require Telnet.pm

usage

getheatmiserstatus.pl which you run with the unit number you want to query (I have 2 units on my chain)

perl getheatmiserstatus.pl 1


toggleheatmiser.pl which you also pass a unit number to, and a command

perl toggleheatmiser.pl unit 1 on

perl toggleheatmiser.pl unit 1 off

perl toggleheatmiser.pl frost 1 on

perl toggleheatmiser.pl frost 1 off

perl toggleheatmiser.pl settemp 1 24

perl toggleheatmiser.pl setfrost 1 7


settemp passes the temp you want to set the unit too
setfrost sets the frost temp