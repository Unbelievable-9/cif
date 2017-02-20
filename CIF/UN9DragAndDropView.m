/*
 
 File Name:      UN9DragAndDropView
 Author:         Unbelievable9
 Created Time:   2016-06-23
 Description:    自定义拖拽视图
 
 2016 Unbelievable9 All Rights Reserved.
 
 */

#import "UN9DragAndDropView.h"

@interface UN9DragAndDropView ()

//@property (nonatomic, assign) BOOL needHighLight;

@end


@implementation UN9DragAndDropView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor lightGrayColor] setFill];
    NSRectFill(dirtyRect);
    
    [super drawRect:dirtyRect];
}


- (void)awakeFromNib {
    [self registerForDraggedTypes:@[
                                    NSFilenamesPboardType
                                    ]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    [pasteBoard clearContents];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    
    NSArray *fileNames = [pasteBoard propertyListForType:NSFilenamesPboardType];
    
    if (fileNames.count == 1) {
        if ([self.delegate respondsToSelector:@selector(retrieveDropFilePathString:)]) {
            [self.delegate retrieveDropFilePathString:fileNames[0]];
        }
    }
    
    return YES;
}

@end
