ARCHS = armv7 arm64
THEOS_BUILD_DIR = Packages
THEOS_DEVICE_IP = 192.168.1.82
include theos/makefiles/common.mk

TWEAK_NAME = AndroLock
AndroLock_FILES = AndroLock.xm CBAutoScrollLabel/CBAutoScrollLabel.m UAObfuscatedString/UAObfuscatedString.m
AndroLock_LIBRARIES = substrate
AndroLock_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
AndroLock_PRIVATE_FRAMEWORKS = MediaRemote
AndroLock_LDFLAGS += -Wl,-segalign,4000
AndroLock_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += androlockprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
