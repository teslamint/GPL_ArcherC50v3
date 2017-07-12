export CC = $(TOOLPREFIX)gcc
export LD = $(TOOLPREFIX)ld
export AR = $(TOOLPREFIX)ar
export STRIP = $(TOOLPREFIX)strip

export APP_CMM_DIR = $(PRIVATE_APPS_PATH)/user
export APP_PJSIP_DIR = $(PUBLIC_APPS_PATH)/pjsip_1.10
export APP_VOIP_DIR = $(PRIVATE_APPS_PATH)/voip

VENDOR_CFLAGS :=

ifeq ($(strip $(INCLUDE_CPU_TC3182)),y)
sinclude $(KERNELPATH)/.config    
sinclude $(TOP_PATH)/$(SUPPLIER)/Project/profile/RT/$(CPU_TYPE)/$(CPU_TYPE).profile

MODULES_TDI_DIR := $(TOP_PATH)/$(SUPPLIER)/modules/private/voip/telephony_drv
SUPPLIER_VOIP_DIR := $(TOP_PATH)/$(SUPPLIER)/apps/private/TC_VOIP_API
DSP_DYNAMIC_LIB :=

DSP_CFLAGS := -O2 -Wall -mips32r2 -msoft-float -muclibc -DOSAL_PTHREADS
DSP_OBJ := $(SUPPLIER_VOIP_DIR)/voip_api_server/DSP_API/D2/tcDSPAPI.o

DSP_INCLUDE := -I$(SUPPLIER_VOIP_DIR)/include
DSP_INCLUDE += -I$(MODULES_TDI_DIR)

ifneq ($(strip $(INCLUDE_VOIP_WITH_DSP_D2_2S1O)),)
DSP_API_DIR := $(SUPPLIER_VOIP_DIR)/voip_api_server/DSP_API/D2/EDDY1_R_1_5_99_TDI
DSP_STATIC_LIB := $(DSP_API_DIR)/lib.m34k3/ve_vtsp.lib $(DSP_API_DIR)/lib.m34k3/osal_user.lib 
export TCSUPPORT_VOIP=y
export TCSUPPORT_VOIP_WITH_DSP_D2_2S1O=y
export TEL=2S1O
export SLIC=ZARLINK
VENDOR_CFLAGS += -DRALINK

DSP_INCLUDE += -I$(DSP_API_DIR)/include.m34k3
endif # INCLUDE_VOIP_WITH_DSP_D2_2S1O

#DSP_CFLAGS += -DVTSP_DEBUG_NETLOG

#add by huangzegeng
ifeq ($(strip $(TCSUPPORT_SDRAM_32M)),y)
VENDOR_CFLAGS += -DSUPPORT_SDRAM_32M=1
endif
#end by huangzegeng

endif  # INCLUDE_CPU_TC3182

ifeq ($(strip $(INCLUDE_CPU_AR9344)),y)
DSP_API_DIR		:= $(MODULES_PATH)/../public/phone_pjsip/pjsip
SUPPLIER_VOIP_DIR	:= $(DSP_API_DIR)/intall
DSP_STATIC_LIB		:= $(DSP_API_DIR)/pjengine/media_engine_api.o -L$(DSP_API_DIR)/install/lib -lpjatheros
DSP_OBJ			:= 
VENDOR_CFLAGS		+= -DVOIP_ATHEROS=1 -I$(MODULES_PATH)/../public/phone_pjsip/media_api
DSP_INCLUDE		+= -I$(DSP_API_DIR)/pjengine
export BOARD_TYPE=db12x
###### just for build #####
export VOIP_API_RUN=y
export PCM_DI_GPIO=2
export PCM_DO_GPIO=1
export PCM_CLK_GPIO=0
export PCM_FS_GPIO=3

export SPI_DI_GPIO=8
export SPI_DO_GPIO=7
export SPI_CLK_GPIO=6
export SLIC_SPI_CS1_GPIO=17
#export SLIC_SPI_CS2_GPIO=18

export SLIC_RESET_GPIO=13
##############################

endif # INCLUDE_CPU_AR9344

#yuchuwei
ifeq ($(strip $(INCLUDE_CPU_RT63368)),y)
sinclude $(KERNELPATH)/.config    
sinclude $(TOP_PATH)/$(SUPPLIER)/Project/profile/RT/rt63368_demo/rt63368_demo.profile

SUPPLIER_VOIP_DIR := $(TOP_PATH)/$(SUPPLIER)/apps/private/voip
DSP_DYNAMIC_TARGET := $(SUPPLIER_VOIP_DIR)/eva
DSP_STATIC_LIB := -L$(SUPPLIER_VOIP_DIR)/MTK_SIP/install/lib -lslic_user -lvdsp_user -lsyss -lbase
DSP_DYNAMIC_LIB := -L$(SUPPLIER_VOIP_DIR)/eva/bin -ladam -lgdi_mtk

DSP_CFLAGS := -O2 -Wall -mips32r2 -msoft-float -muclibc -DOSAL_PTHREADS
DSP_INCLUDE += -I$(KERNELPATH)/arch/mips/include/
DSP_INCLUDE += -I$(KERNELPATH)/include/
DSP_OBJ := $(SUPPLIER_VOIP_DIR)/mtkDSPAPI.o

DSP_INCLUDE += -I$(SUPPLIER_VOIP_DIR)/eva/common
DSP_INCLUDE += -I$(SUPPLIER_VOIP_DIR)/eva/adam
DSP_INCLUDE += -I$(SUPPLIER_VOIP_DIR)/eva/gdi_mtk
DSP_INCLUDE += -I$(MODULES_MTK_FXS3_DIR)/include -I$(MODULES_MTK_OVDSP_DIR)/include

VENDOR_CFLAGS += -DRALINK -DMTK

DSP_CFLAGS += -DVTSP_DEBUG_NETLOG -DDSPID_MTK

export PLATFORM:=tc3182 
export DSP:=mtk
export TCSUPPORT_VOIP=y
export VOIP_DSP=MTK

#add by huangzegeng
ifeq ($(strip $(TCSUPPORT_SDRAM_32M)),y)
VENDOR_CFLAGS += -DSUPPORT_SDRAM_32M=1
endif
#end by huangzegeng

ifeq ($(KERNELVERSION), 2.6.36)
MODULES_MTK_FXS3_DIR:= $(MODULES_PATH)/voip_2.6.36/DSP/MTK/mod-fxs3
MODULES_MTK_OVDSP_DIR:= $(MODULES_PATH)/voip_2.6.36/DSP/MTK/mod-ovdsp
#APP_MTKSIP_DIR:=$(MODULES_PATH)/voip_2.6.36/MTK_SIP
else
MODULES_MTK_FXS3_DIR:= $(MODULES_PATH)/voip/DSP/MTK/mod-fxs3
MODULES_MTK_OVDSP_DIR:= $(MODULES_PATH)/voip/DSP/MTK/mod-ovdsp
#APP_MTKSIP_DIR:=$(MODULES_PATH)/voip/MTK_SIP
endif
DSP_MTK_API_DIR := $(TOP_PATH)/$(SUPPLIER)/apps/private/voip
DSP_MTK_INCLUDE = -I$(MODULES_MTK_FXS3_DIR)/include -I$(MODULES_MTK_OVDSP_DIR)/include
DSP_MTK_API_LIB := -L $(MODULES_MTK_FXS3_DIR)/ -lslic_user -L $(MODULES_MTK_OVDSP_DIR)/ -lvdsp_user -L$(DSP_MTK_API_DIR)/MTK_SIP/install/lib/ -lsyss -lbase
export MODULES_MTK_FXS3_DIR MODULES_MTK_OVDSP_DIR DSP_MTK_API_DIR DSP_MTK_INCLUDE DSP_MTK_API_LIB
endif  # INCLUDE_CPU_RT63368

ifneq ($(strip $(CONFIG_NR_CPUS)), )
VENDOR_CFLAGS += -DCONFIG_NR_CPUS=$(CONFIG_NR_CPUS)
endif # CONFIG_NR_CPUS

export DSP_DYNAMIC_TARGET
export DSP_DYNAMIC_LIB
export DSP_STATIC_LIB
export DSP_OBJ
export DSP_CFLAGS
export DSP_INCLUDE

ifneq ($(strip $(INCLUDE_VOIP)),)
export INCLUDE_VOIP
export SUPPLIER

# now configuring voip locale settings

VOIP_LOCALE := -I$(APP_VOIP_DIR)/inc
ifneq ($(strip $(VOIP_LOCALE_ALL)),)
VOIP_LOCALE += -DVOIP_CFG_ALL
else
VOIP_LOCALE += $(shell cat config/$(MODEL).config | sed -n 's/=y$$//p' | sed -n 's/^VOIP_CFG/-D&/p')
endif # VOIP_LOCALE_ALL
export VOIP_LOCALE

VOIP_DFLAGS := -DINCLUDE_VOIP
VOIP_CFLAGS := $(VOIP_LOCALE)
VOIP_CFLAGS += -I$(APP_VOIP_DIR)/inc/client -I$(SUPPLIER_VOIP_DIR)/include
VOIP_CFLAGS += -I$(APP_PJSIP_DIR)/pjlib/include
VOIP_CFLAGS += -I$(OS_LIB_PATH)/include -I$(TP_MODULES_PATH)/voip

ifeq ($(strip $(CONFIG_IP_MULTIPLE_TABLES)), y)
VOIP_CFLAGS += -DCONFIG_IP_MULTIPLE_TABLES
endif

ifeq ($(strip $(INCLUDE_DSP_SOCKET_OPEN)), y)
VOIP_CFLAGS += -DINCLUDE_DSP_SOCKET_OPEN
export INCLUDE_DSP_SOCKET_OPEN
endif

export NUM_FXS_CHANNELS := $(NUM_FXS_CHANNELS)
VOIP_DFLAGS += -DINCLUDE_FXS_NUM=$(NUM_FXS_CHANNELS)
VOIP_CFLAGS += -DNUM_FXS_CHANNELS=$(NUM_FXS_CHANNELS)
ifeq ($(strip $(INCLUDE_CPU_AR9344)),y)
export CHANNEL = $(NUM_FXS_CHANNELS)
endif

ifneq ($(strip $(INCLUDE_DMZ)),)
VOIP_CFLAGS += -DINCLUDE_DMZ
endif

ifneq ($(strip $(INCLUDE_DIGITMAP)),)
export INCLUDE_DIGITMAP=y
VOIP_DFLAGS += -DINCLUDE_DIGITMAP
endif

ifneq ($(strip $(INCLUDE_USB_VOICEMAIL)),)
export INCLUDE_USB_VOICEMAIL=y
VOIP_DFLAGS += -DINCLUDE_USB_VOICEMAIL

ifneq ($(strip $(INCLUDE_USBVM_MODULE)),)
ifeq ($(strip $(CONFIG_HZ)), $(shell echo $$[$(CONFIG_HZ) / 100 * 100]))
export INCLUDE_USBVM_MODULE=y
VOIP_CFLAGS += -DINCLUDE_USBVM_MODULE
endif
endif
endif

ifneq ($(strip $(INCLUDE_CALLLOG)),)
export INCLUDE_CALLLOG=y
VOIP_DFLAGS += -DINCLUDE_CALLLOG
endif

ifneq ($(strip $(INCLUDE_PSTN)),)

export INCLUDE_PSTN = y
VOIP_DFLAGS += -DINCLUDE_PSTN
ifneq ($(strip $(INCLUDE_PSTN_LIFELINE)),)
export INCLUDE_PSTN_LIFELINE=y
VOIP_DFLAGS += -DINCLUDE_PSTN_LIFELINE
endif
ifneq ($(strip $(INCLUDE_PSTN_POLREV)),)
export INCLUDE_PSTN_POLREV=y
VOIP_DFLAGS += -DINCLUDE_PSTN_POLREV
endif
ifneq ($(strip $(INCLUDE_PSTN_GATEWAY)),)
export INCLUDE_PSTN_GATEWAY=y
VOIP_DFLAGS += -DINCLUDE_PSTN_GATEWAY
endif

endif  # INCLUDE_PSTN

export VOIP_CFLAGS += $(VENDOR_CFLAGS)
export VOIP_DFLAGS

endif  # INCLUDE_VOIP

