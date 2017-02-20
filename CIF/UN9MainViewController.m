/*
 
 File Name:      UN9MainViewController
 Author:         Unbelievable9
 Created Time:   2016-06-21
 Description:    主视图控制器
 
 2016 Unbelievable9 All Rights Reserved.
 
 */

#import "UN9MainViewController.h"

@interface UN9MainViewController () <UN9DragAndDropViewDelegate>

@property (nonatomic, copy) NSString *ipaFilePathString;
@property (nonatomic, copy) NSDictionary *certInfoDict;

@end

@implementation UN9MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ipaDragAndDropView.delegate = self;
}

#pragma mark - IPA Info Update
- (void)updateCertInfo {
    NSString *plistInfoString = @"";
    
    for (int i = 0; i < self.certInfoDict.allKeys.count; i++) {
        NSString *key = self.certInfoDict.allKeys[i];
        
        if ([key isEqualToString:@"Entitlements"] ||
            [key isEqualToString:@"ProvisionsAllDevices"] ||
            [key isEqualToString:@"DeveloperCertificates"]) {
            continue;
        }
        
        id value = [self.certInfoDict valueForKey:key];
        
        plistInfoString = [plistInfoString stringByAppendingString:[NSString stringWithFormat:@"<%@>\n", key]];
        
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = value;
            
            for (id object in valueArray) {
                if ([object isKindOfClass:[NSString class]]) {
                    plistInfoString = [plistInfoString stringByAppendingString:[NSString stringWithFormat:@"%@\n", object]];
                }
            }
        } else {
            plistInfoString = [plistInfoString stringByAppendingString:[NSString stringWithFormat:@"%@\n", value]];
        }
        
        
        plistInfoString = [plistInfoString stringByAppendingString:@"\n"];
    }
    
    [self.certInfoTextView setString:plistInfoString];
}

#pragma mark - RLDragAndDropViewDelegate
- (void)retrieveDropFilePathString:(NSString *)filePathString {
    NSString *destinationPathString = [NSString stringWithFormat:@"%@/Desktop/CIF-Temp",
                                       [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPathString]) {
        [[NSFileManager defaultManager] removeItemAtPath:destinationPathString
                                                   error:nil];
    }
    
    NSString *fileName = [filePathString lastPathComponent];
    
    NSArray *fileNameComponentArray = [fileName componentsSeparatedByString:@"."];
    
    NSString *fileTypeString = [fileNameComponentArray lastObject];
    
    if (![fileTypeString isEqualToString:@"ipa"]) {
        NSAlert *wrongContactTxtFileAlert = [[NSAlert alloc] init];
        
        [wrongContactTxtFileAlert setMessageText:@"Error"];
        [wrongContactTxtFileAlert setInformativeText:@"Please Choose The Right .ipa File!"];
        [wrongContactTxtFileAlert addButtonWithTitle:@"OK"];
        [wrongContactTxtFileAlert runModal];
        
        return;
    }
    
    self.ipaFilePathString = filePathString;
    
    [self.progressIndicator startAnimation:nil];
    self.progressIndicator.hidden = false;
    
    __block typeof (self) weakSelf = self;
    
    //解压任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *destinationPathString = [NSString stringWithFormat:@"%@/Desktop/CIF-Temp",
                                           [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"]];
        
        
        NSTask *unzipTask = [[NSTask alloc] init];
        
        [unzipTask setLaunchPath:@"/usr/bin/unzip"];
        [unzipTask setArguments:@[weakSelf.ipaFilePathString, @"-d", destinationPathString]];
        [unzipTask launch];
        [unzipTask waitUntilExit];
        
        //获取证书信息任务
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString *tmpFileString = [NSString stringWithFormat:@"%@/Desktop/CIF-Temp",
                                       [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"]];
            
            NSString *certFilePathString = [NSString stringWithFormat:@"%@/Payload/rlterm3.app/embedded.mobileprovision",
                                            tmpFileString];
            
            
            
            NSArray *commandArgumentsArray = @[
                                               @"smime",
                                               @"-inform",
                                               @"der",
                                               @"-verify",
                                               @"-noverify",
                                               @"-in",
                                               certFilePathString
                                               ];
            
            NSPipe *plistPipe = [NSPipe pipe];
            
            NSTask *convertToPlistTask = [[NSTask alloc] init];
            
            [convertToPlistTask setLaunchPath:@"/usr/bin/openssl"];
            [convertToPlistTask setArguments:commandArgumentsArray];
            [convertToPlistTask setStandardOutput:plistPipe];
            
            [convertToPlistTask launch];
            [convertToPlistTask waitUntilExit];
            
            NSData *outputData = [[plistPipe fileHandleForReading] readDataToEndOfFile];
            
            NSPropertyListFormat format;
            
            NSDictionary *plistDict = [NSPropertyListSerialization propertyListWithData:outputData
                                                                                options:NSPropertyListReadCorruptError
                                                                                 format:&format
                                                                                  error:nil];
            
            
            weakSelf.certInfoDict = [NSDictionary dictionaryWithDictionary:plistDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.progressIndicator stopAnimation:nil];
                weakSelf.progressIndicator.hidden = true;
                
                [weakSelf updateCertInfo];
            });
        });
    });
}

@end
