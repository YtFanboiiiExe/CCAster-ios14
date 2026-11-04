ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:14.0
# Rootful build: no THEOS_PACKAGE_SCHEME, files install under / (not /var/jb).

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCAster

CCAster_FILES = Tweak.xm
CCAster_FRAMEWORKS = UIKit CoreFoundation CFNetwork QuartzCore CoreImage
CCAster_PRIVATE_FRAMEWORKS = ControlCenterServices SpringBoardUIServices
CCAster_CFLAGS = -fobjc-arc

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
