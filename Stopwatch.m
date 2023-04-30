//
//  Timer.m
//  Thyme
//
//  Created by João on 3/16/13.
//
//

#import "Stopwatch.h"

@interface Stopwatch ()
@property (nonatomic, retain) NSDate* reference;
@property (nonatomic) NSTimeInterval accum;
- (void) tick;
@end

@implementation Stopwatch

@synthesize delegate;
@synthesize timer;
@synthesize reference;
@synthesize accum;

- (id)init {
    if (self = [super init]) {
        self.timer = nil;
        self.reference = [NSDate date];
        self.accum = 0;
    }
    
    return self;
}

- (id)initWithDelegate:(id<StopwatchDelegate>)aDelegate {
    if (self = [self init]) {
        self.delegate = aDelegate;
    }
    
    return self;
}

- (NSString*) description {
    long seconds = (long) floor([self value]);
    long hours = seconds / 3600;
    long minutes = (seconds / 60) % 60;
    seconds = seconds % 60;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
}

- (NSTimeInterval) value {
    if (!self.timer) {
        return self.accum;
    }
    
    return [[NSDate date] timeIntervalSinceDate:reference] + self.accum;
}

- (BOOL) isActive {
    return self.timer != nil;
}

- (BOOL) isPaused {
    return self.timer == nil && self.accum > 0;
}

- (BOOL) isStopped {
    return self.timer == nil && self.accum == 0;
}

- (void) start {
    if ([self isActive]) {
        return;
    }
    
    self.reference = [NSDate date];
    
    // Create a GCD timer
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.timer) {
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            [self performSelectorOnMainThread:@selector(tick) withObject:nil waitUntilDone:NO];
        });
        dispatch_resume(self.timer);
    }
    
    if (self.delegate) {
        [self.delegate didStart:self];
        [self.delegate didChange:self];
    }
}

- (void) pause {
    if ([self isPaused]) {
        return;
    }
    
    self.accum = [self value];
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    if (self.delegate) {
        [self.delegate didPause:self];
    }
}

- (void) reset:(NSTimeInterval) value {
    self.accum = value;
    self.reference = [NSDate date];

    if (self.delegate) {
        [self.delegate didChange:self];
    }
}

- (void) stop {
    if ([self isStopped]) {
        return;
    }
    
    NSTimeInterval value = [self value];
    
    self.accum = 0;
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    if (self.delegate) {
        [self.delegate didStop:self withValue:value];
    }
}

#pragma mark Private

- (void) tick {
    if (self.delegate) {
        [self.delegate didChange:self];
    }
}

@end
