ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = AndroLockPrefs
AndroLockPrefs_FILES = AndroLockPrefs.m UIView+Shimmer/UIView+Shimmer.m
AndroLockPrefs_INSTALL_PATH = /Library/PreferenceBundles
AndroLockPrefs_LIBRARIES = MobileGestalt substrate
AndroLockPrefs_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore MessageUI
AndroLockPrefs_PRIVATE_FRAMEWORKS = Preferences Twitter

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AndroLockPrefs.plist$(ECHO_END)
