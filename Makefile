QUARTUS_SH = quartus_sh
QUARTUS_PGM = quartus_pgm
FLAGS = --flow compile
PROJECT = lab1
OUTPUT = output_files
CABLE = USB-Blaster

.PHONY: all clean flash

all: sof

sof:
	$(QUARTUS_SH) $(FLAGS) $(PROJECT)

flash:
	$(QUARTUS_PGM) -c $(CABLE) chain.cdf

clean:
	rm $(OUTPUT)/$(PROJECT).sof



