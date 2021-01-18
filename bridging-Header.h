#import <CoreGraphics/CoreGraphics.h>

void Setup(void);
void Draw(CGContextRef ctx, CGFloat width, CGFloat height);
int MouseEvent(CGEventType type, CGFloat x, CGFloat y);
int KeyDown(const char *str);
