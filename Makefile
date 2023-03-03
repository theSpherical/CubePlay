#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------

.SUFFIXES
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITPPC)),)
$(error "Please set DEVKITPPC in your enviroment. export DEVKITPPC=<path to>devkitPPC")
endif
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITPPC in your enviroment. export DEVKITPPC=<path to>devkitPPC")
endif

SUBPROJECTS := multidol kernel/asm resetstub \
   fatfs/libfat-arm.a fatfs/libfat-ppc.a \
   codehandler kernel kernelboot \
   loader/source/ppc/PADReadGC loader/
source/ppc/IOSInterface loader
.PHONY: all forced clean $(SUBPROJECTS)

all: loader
forced: clean all

multidol:
   @echo " "
   @echo "Building Multi-Dol loader"
   @echo " "
   $(MAKE) -C multidol
   
kernel/asm:
	@echo " "
	@echo "Building asm files"
	@echo " "
	$(MAKE) -C kernel/asm

resetstub:
	@echo " "
	@echo "Building reset stub"
	@echo " "
	$(MAKE) -C resetstub

fatfs/libfat-arm.a:
	@echo " "
	@echo "Building FatFS library for ARM"
	@echo " "
	$(MAKE) -C fatfs -f Makefile.arm

fatfs/libfat-ppc.a:
	@echo " "
	@echo "Building FatFS library for PPC"
	@echo " "
	$(MAKE) -C fatfs -f Makefile.ppc

codehandler:
	@echo " "
	@echo "Building CubePlay code handler"
	@echo " "
	$(MAKE) -C codehandler

kernel: kernel/asm fatfs/libfat-arm.a codehandler
	@echo " "
	@echo "Building CubePlay kernel"
	@echo " "
	$(MAKE) -C kernel

loader/source/ppc/PADReadGC:
	@echo " "
	@echo "Building CubePlay PADReadGC"
	@echo " "
	$(MAKE) -C loader/source/ppc/PADReadGC

loader/source/ppc/IOSInterface:
	@echo " "
	@echo "Building CubePlay IOSInterface"
	@echo " "
	$(MAKE) -C loader/source/ppc/IOSInterface

kernelboot:
	@echo " "
	@echo "Building CubePlay kernelboot"
	@echo " "
	$(MAKE) -C kernelboot

loader: multidol resetstub fatfs/libfat-ppc.a kernel kernelboot loader/source/ppc/PADReadGC loader/source/ppc/IOSInterface
	@echo " "
	@echo "Building CubePlay loader"
	@echo " "
	$(MAKE) -C loader

clean:
	@echo " "
	@echo "Cleaning all subprojects..."
	@echo " "
	$(MAKE) -C multidol clean
	$(MAKE) -C kernel/asm clean
	$(MAKE) -C resetstub clean
	$(MAKE) -C fatfs -f Makefile.arm clean
	$(MAKE) -C fatfs -f Makefile.ppc clean
	$(MAKE) -C codehandler clean
	$(MAKE) -C kernel clean
	$(MAKE) -C kernelboot clean
	$(MAKE) -C loader/source/ppc/PADReadGC clean
	$(MAKE) -C loader/source/ppc/IOSInterface clean
	$(MAKE) -C loader clean
