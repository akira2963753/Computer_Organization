# 設計名稱與平台
export DESIGN_NAME = CompMultiplier
export PLATFORM    = nangate45
export SYNTH_HIERARCHICAL = 1

# 設計檔案路徑
export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/CompMultiplier.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/ALU.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/Control.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/Product.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/Multiplicand.v 
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ABC_AREA      = 1

export ADDER_MAP_FILE :=

export CORE_UTILIZATION ?= 55
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100
export REMOVE_CELLS_FOR_EQY   = TAPCELL*
