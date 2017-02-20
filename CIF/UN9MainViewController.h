/*
 
 File Name:      UN9MainViewController
 Author:         Unbelievable9
 Created Time:   2016-06-21
 Description:    主视图控制器
 
 2016 Unbelievable9 All Rights Reserved.
 
 */

#import <Cocoa/Cocoa.h>

#import "UN9DragAndDropView.h"

@interface UN9MainViewController : NSViewController

@property (weak) IBOutlet UN9DragAndDropView *ipaDragAndDropView;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (unsafe_unretained) IBOutlet NSTextView *certInfoTextView;

@end

