/*
 
 File Name:      UN9AppDelegate
 Author:         Unbelievable9
 Created Time:   2016-06-21
 Description:    CIF的AppDelegate
 
 2016 Unbelievable9 All Rights Reserved.
 
 */

#import "UN9AppDelegate.h"

@interface UN9AppDelegate ()

@end

@implementation UN9AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Desktop/CIF-Temp",
                                                      [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"]]
                                               error:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return true;
}

@end
