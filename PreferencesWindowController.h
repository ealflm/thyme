//
//  PreferencesWindowController.h
//  Thyme
//
//  Created by João on 3/18/13.
//
//

#import <Cocoa/Cocoa.h>
#import "ShortcutRecorder/ShortcutRecorder.h"

@interface PreferencesWindowController : NSWindowController <SRRecorderControlDelegate> {
    SRRecorderControl *hideShowOverlayRecorder;
    SRRecorderControl *startPauseShortcutRecorder;
    SRRecorderControl *restartShortcutRecorder;
    SRRecorderControl *finishShortcutRecorder;
    SRRecorderControl *exportToNotionShortcutRecorder;
    NSButton *pauseOnSleepButton;
    NSButton *pauseOnScreensaverButton;
}

@property (nonatomic, retain) IBOutlet SRRecorderControl *hideShowOverlayRecorder;
@property (nonatomic, retain) IBOutlet SRRecorderControl *startPauseShortcutRecorder;
@property (nonatomic, retain) IBOutlet SRRecorderControl *restartShortcutRecorder;
@property (nonatomic, retain) IBOutlet SRRecorderControl *finishShortcutRecorder;
@property (nonatomic, retain) IBOutlet SRRecorderControl *exportToNotionShortcutRecorder;
@property (nonatomic, retain) IBOutlet NSButton *pauseOnSleepButton;
@property (nonatomic, retain) IBOutlet NSButton *pauseOnScreensaverButton;

@end
