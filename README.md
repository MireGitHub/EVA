# EVA

Player Infobeamer con RFID

HARDWARE UTILIZZATO

2 Arduino Uno 
Raspberry PI B
Kit RFID 
Kit Groove Touch Sensor


INSTALLAZIONE INFOBEAMER : link guida

INSTALLAZIONE NODE CON I SEGUENTI PACCHETTI:
	-SerialPort
	-node-osc

INSTALLAZIONE PROCESSING: link 
	-oscP5	


START APPLICAZIONE
-) Caricamento  su Arduino Uno dello sketch LibeliumRFID1356.ino  /EVA/code/arduino/LibeliumRFID1356/LibeliumRFID1356.ino 
-) Avvio processing dalla folder ./processing  e caricamento sketch rfid.pde /EVA/code/processing/libraries/rfid/rfid.pde
-) Avvio webserver OSC con node /EVA/code/node/webserver/osc-server.js
-) Avvio infobeamer dalla folder ./infobemaer /EVA/code/infobeamer/photos


		- 