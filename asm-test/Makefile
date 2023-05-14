CROSS_COMPILE=mips-linux-gnu-

CC=$(CROSS_COMPILE)gcc
AS=$(CROSS_COMPILE)gcc
OBJDUMP=$(CROSS_COMPILE)objdump
OBJCOPY=$(CROSS_COMPILE)objcopy
LD=$(CROSS_COMPILE)ld
BUILD_DIR = build
AS_FLAGS=-march=mips32 -fno-pic -fno-delayed-branch -mno-abicalls -mno-check-zero-division -EL
.PHONY: $(BUILD_DIR) memdata clean

obj:memdata $(BUILD_DIR)/$(NAME).s $(BUILD_DIR)/$(NAME).bin

memdata:$(BUILD_DIR)/mem.data
$(BUILD_DIR)/mem.data:$(BUILD_DIR)/$(NAME).bin
	python3 ../script/dumphex.py $? $@ 

$(BUILD_DIR):
	mkdir -p $@
$(BUILD_DIR)/$(NAME).o:$(BUILD_DIR)
	@echo "AS test/$(NAME).S -> " $@  
	@$(AS) $(AS_FLAGS) tests/$(NAME).S -c -o $@ 
$(BUILD_DIR)/$(NAME).elf:$(BUILD_DIR)/$(NAME).o
	@echo "LD "
	$(LD) -EL -o $@ --start-group $? --end-group \
		-T ../abstract-machine/scripts/linker.ld   \
		--defsym=_pmem_start=0x80000000 \
		--defsym=_entry_offset=0x0 --gc-sections -e _start
$(BUILD_DIR)/$(NAME).s:$(BUILD_DIR)/$(NAME).elf
	@$(OBJDUMP) -d $? > $@

$(BUILD_DIR)/$(NAME).bin:$(BUILD_DIR)/$(NAME).elf
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $? $@

clean:
	rm -rf build