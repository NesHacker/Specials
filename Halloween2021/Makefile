GAME=Halloween2021
NES_DIR=./
BUILD_DIR=./build

objects=$(BUILD_DIR)/$(GAME).o

all: $(objects)
	ld65 -t nes "$(BUILD_DIR)/$(GAME).o" -o "$(NES_DIR)/$(GAME).nes"

$(BUILD_DIR)/%.o: %.s $(BUILD_DIR)
	ca65 -t nes $< -o $@

$(BUILD_DIR):
	mkdir -p "$(BUILD_DIR)"

clean:
	rm "$(BUILD_DIR)/*.o" "$(NES_DIR)/$(GAME).nes"
