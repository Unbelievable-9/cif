/*
 
 File Name:      UN9DragAndDropView
 Author:         Unbelievable9
 Created Time:   2016-06-23
 Description:    自定义拖拽视图
 
 2016 Unbelievable9 All Rights Reserved.
 
 */

#import <Cocoa/Cocoa.h>

@protocol UN9DragAndDropViewDelegate <NSObject>

- (void)retrieveDropFilePathString:(NSString *)filePathString;

@end

@interface UN9DragAndDropView : NSView

@property (nonatomic, weak) id <UN9DragAndDropViewDelegate> delegate;

@end
