//
//  ScanCodeViewController.h
//  JFB
//
//  Created by JY on 15/8/24.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanCodeDelegate <NSObject>

- (void)ScanCodeComplete:(NSString *)codeString;

- (void)ScanCodeError:(NSError *)error;

@end

@interface ScanCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property(assign,nonatomic)id<ScanCodeDelegate> delegate;

@property (strong,nonatomic) AVCaptureDevice *device;

@property (strong,nonatomic) AVCaptureMetadataOutput *output;

@property (strong,nonatomic) AVCaptureDeviceInput *input;
//@property (nonatomic, strong) AVCa

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@end
