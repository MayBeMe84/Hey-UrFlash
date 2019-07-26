ARCHS = arm64 arm64e
export TARGET = iphone:clang:10.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HeyUrFlash

HeyUrFlash_FILES = XXXRootListController.m
HeyUrFlash_INSTALL_PATH = /Library/PreferenceBundles
HeyUrFlash_FRAMEWORKS = UIKit
HeyUrFlash_PRIVATE_FRAMEWORKS = Preferences
HeyUrFlash_EXTRA_FRAMEWORKS += CepheiPrefs
HeyUrFlash_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HeyUrFlash.plist$(ECHO_END)
