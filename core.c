//
//  core.c
//  nextui
//
//  Created by Scott Devine on 1/15/21.
//

#include <stdio.h>
#include "CoreGraphics/CoreGraphics.h"
#include "CoreText/CoreText.h"


int mouseIsDown = 0;
int mouseX = 40.0;
int mouseY = 50.0;

CTLineRef line;

void Setup(void) {
    printf("hello world!\n");
    CFStringRef string = CFStringCreateWithCString(NULL, "hello world🙂",
            kCFStringEncodingUTF8);
    CFStringRef name = CFStringCreateWithCString(NULL, "SFMono-Light",
            kCFStringEncodingUTF8);
    CTFontRef font = CTFontCreateWithName(name, 11.0, NULL);
    CFRelease(name);
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName };
    CFTypeRef values[] = { font, CGColorCreateSRGB(1.0, 1.0, 1.0, 1.0) };
    CFDictionaryRef attributes =
        CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                &kCFTypeDictionaryKeyCallBacks,
                &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString =
        CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CFRelease(string);
    CFRelease(attributes);
    line = CTLineCreateWithAttributedString(attrString);
}

void Draw(CGContextRef ctx, CGFloat width, CGFloat height) {
    CGRect bounds = {0.0, 0.0, width, height};
    //CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.1, 1.0);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetShouldAntialias(ctx, true);
    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(ctx, bounds);
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 1.0);
    CGContextSetLineWidth(ctx, 0.4);
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextMoveToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    if (mouseIsDown) {
        // Set text position and draw the line into the graphics context
        CGContextSetTextPosition(ctx, mouseX, mouseY);
        CTLineDraw(line, ctx);
        //CFRelease(line);
        CGContextMoveToPoint(ctx, 0.0, mouseY);
        CGContextAddLineToPoint(ctx, width, mouseY);
        CGContextMoveToPoint(ctx, mouseX, 0.0);
        CGContextAddLineToPoint(ctx, mouseX, height);
    }
    CGContextStrokePath(ctx);
}

int MouseEvent(CGEventType type, CGFloat x, CGFloat y) {
    switch (type) {
        case kCGEventLeftMouseDown:
            mouseIsDown = 1;
            mouseX = x;
            mouseY = y;
            return 1;
        case kCGEventLeftMouseDragged:
            mouseX = x;
            mouseY = y;
            return 1;
        case kCGEventLeftMouseUp:
            mouseIsDown = 0;
            return 1;
        default:
            return 0;
    }
}

int KeyDown(const char *str) {
    assert(str);
    if (str[0] < 0x20) {
        assert((str[0] == 0) || (str[1] == 0));
        printf("control %d\n", str[0]);
    } else {
        printf(">>%s<<\n", str);
    }
    return 0;
}

