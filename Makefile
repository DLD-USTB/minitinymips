FILESET += $(shell find vsrc/Core -name "*.v")
FILESET += $(shell find vsrc/Memory -name "*v")
FILESET += vsrc/SimTop.v vsrc/Top.v
TOP ?= SimTop
BUILD_DIR = build
SIM_OBJ = $(BUILD_DIR)/sim
TRACE-y = -PSimTop.TRACE=1 
SIM_CYCLE ?= 100
FLAGS += $(TRACE-$(TRACE))

FLAGS += -PSimTop.SIM_CYCLE=$(SIM_CYCLE)

.PHONY: run $(SIM_OBJ) clean
run:all
$(SIM_OBJ):
	mkdir -p build
	iverilog -s $(TOP) $(FILESET) $(FLAGS) -o $@ 2>/dev/null
clean:
	rm -rf $(SIM_OBJ)
all:$(SIM_OBJ)
	./$(SIM_OBJ) 2>/dev/null