
APP = min
SWIFT_SRCS = main.swift
C_SRCS = core.c

BRIDGING_H = bridging-Header.h
BD = build

OBJS = $(SWIFT_SRCS:%.swift=$(BD)/%.o)
OBJS += $(C_SRCS:%.c=$(BD)/%.o)

DEPFLAGS = -MT $@ -MMD -MP -MF $(BD)/$*.d
COMPILE.c = clang $(DEPFLAGS) $(CFLAGS) -c

$(BD)/$(APP).app: $(OBJS) $(BD)/Info.plist $(BD)/$(APP).icns | $(BD)
	mkdir -p $@/Contents/MacOS
	cp $(BD)/Info.plist $@/Contents/
	mkdir -p $@/Contents/Resources
	cp $(BD)/$(APP).icns $@/Contents/Resources
	swiftc $(OBJS) -o $(BD)/$(APP)
	cp $(BD)/$(APP) $@/Contents/MacOS/min

$(BD)/%.o: %.c $(BD)/%.d | $(BD)
	$(COMPILE.c) $< -o $@

$(BD)/%.o: %.swift $(BRIDGING_H) | $(BD)
	swiftc -c $< -o $@ -import-objc-header $(BRIDGING_H)

$(BD)/Info.plist: Info.plist | $(BD)
	sed 's/$$APPNAME/$(APP)/' $< > $@

$(BD)/$(APP).icns: $(BD)/$(APP).iconset | $(BD)
	iconutil -c icns $(BD)/$(APP).iconset

$(BD)/$(APP).iconset: icon1024.png | $(BD)
	mkdir $@
	sips -z 16 16 icon1024.png --out $@/icon_16x16.png > /dev/null
	sips -z 32 32 icon1024.png --out $@/icon_16x16@2x.png > /dev/null
	sips -z 32 32 icon1024.png --out $@/icon_32x32.png > /dev/null
	sips -z 64 64 icon1024.png --out $@/icon_32x32@2x.png > /dev/null
	sips -z 128 128 icon1024.png --out $@/icon_128x128.png > /dev/null
	sips -z 256 256 icon1024.png --out $@/icon_128x128@2x.png > /dev/null
	sips -z 256 256 icon1024.png --out $@/icon_256x256.png > /dev/null
	sips -z 512 512 icon1024.png --out $@/icon_256x256@2x.png > /dev/null
	sips -z 512 512 icon1024.png --out $@/icon_512x512.png > /dev/null
	cp icon1024.png $@/icon_512x512@2x.png

$(BD):
	mkdir $(BD)

clean:
	rm -rf $(BD)

DFILES = $(C_SRCS:%.c=$(BD)/%.d)

$(DFILES):

.DELETE_ON_ERROR:

#.SILENT:

-include $(DFILES)
