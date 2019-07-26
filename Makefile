ARCHS = arm64 arm64e
export TARGET = iphone:clang:10.3
THEOS_DEVICE_IP = 192.168.1.42
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HeyUrFlash
HeyUrFlash_FILES = Tweak.xm
HeyUrFlash_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += heyurflash
include $(THEOS_MAKE_PATH)/aggregate.mk
