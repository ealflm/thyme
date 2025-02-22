//
//  PreferencesWindowController.m
//  Thyme
//
//  Created by João on 3/18/13.
//
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()
- (void)onWindowResignKey;
@end

@implementation PreferencesWindowController

@synthesize hideShowOverlayRecorder;
@synthesize startPauseShortcutRecorder;
@synthesize restartShortcutRecorder;
@synthesize finishShortcutRecorder;
@synthesize exportToNotionShortcutRecorder;
@synthesize pauseOnSleepButton;
@synthesize pauseOnScreensaverButton;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;

}
- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    [self.hideShowOverlayRecorder bind:NSValueBinding toObject:defaults withKeyPath:@"values.hideShowOverlay" options:nil];
    [self.startPauseShortcutRecorder bind:NSValueBinding toObject:defaults withKeyPath:@"values.startPause" options:nil];
    [self.restartShortcutRecorder bind:NSValueBinding toObject:defaults withKeyPath:@"values.restart" options:nil];
    [self.finishShortcutRecorder bind:NSValueBinding toObject:defaults withKeyPath:@"values.finish" options:nil];
    [self.exportToNotionShortcutRecorder bind:NSValueBinding toObject:defaults withKeyPath:@"values.exportToNotion" options:nil];
    
    [self.pauseOnSleepButton bind:NSValueBinding toObject:defaults withKeyPath:@"values.pauseOnSleep" options:nil];
    [self.pauseOnScreensaverButton bind:NSValueBinding toObject:defaults withKeyPath:@"values.pauseOnScreensaver" options:nil];
    
    [self.hideShowOverlayRecorder clearButtonRect];
    [self.startPauseShortcutRecorder clearButtonRect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowResignKey) name:NSWindowDidResignKeyNotification object:nil];
}

- (void)onWindowResignKey {
    [self.window close];
}

#pragma mark SRRecorderControlDelegate

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder canRecordShortcut:(NSDictionary *)aShortcut {
    return !SRShortcutEqualToShortcut([self.hideShowOverlayRecorder objectValue], aShortcut) &&
           !SRShortcutEqualToShortcut([self.startPauseShortcutRecorder objectValue], aShortcut) &&
           !SRShortcutEqualToShortcut([self.restartShortcutRecorder objectValue], aShortcut) &&
           !SRShortcutEqualToShortcut([self.finishShortcutRecorder objectValue], aShortcut) &&
           !SRShortcutEqualToShortcut([self.exportToNotionShortcutRecorder objectValue], aShortcut);
}

@end
