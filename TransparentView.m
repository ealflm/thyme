#import "TransparentView.h"

@implementation TransparentView {
    NSPoint initialLocation;
}

- (void)mouseDown:(NSEvent *)event {
    initialLocation = [event locationInWindow];
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint currentLocation = [event locationInWindow];
    NSPoint delta = NSMakePoint(currentLocation.x - initialLocation.x, currentLocation.y - initialLocation.y);
    NSPoint newOrigin = NSMakePoint(self.window.frame.origin.x + delta.x, self.window.frame.origin.y + delta.y);
    
    [self.window setFrameOrigin:newOrigin];
}

@end
