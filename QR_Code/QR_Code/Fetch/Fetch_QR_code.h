//
//  Fetch_QR_code.h
//  QR_Code
//
//  Created by Kenny on 16/9/1.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Fetch_QR_code : NSString <AVCapturePhotoCaptureDelegate>

+ (Fetch_QR_code *)shareInstance;
- (void)initCaptureInView:(UIView *)view;
- (void)startCaptureSession;
- (void)stopCaptureSession;
- (void)removePreviewLayerFromSuperview;
- (void)resetPreviewLayerFrame:(CGRect)frame;

@end
