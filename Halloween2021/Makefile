GAME=

all:
	mkdir -p build
	ca65 -t nes Halloween2021.s -o build/Halloween2021.o
	ld65 -t nes "build/Halloween2021.o" -o "Halloween2021.nes"
