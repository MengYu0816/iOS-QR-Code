//
//  Fetch_QR_code.m
//  QR_Code
//
//  Created by Kenny on 16/9/1.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import "Fetch_QR_code.h"
#import "GlobalDefine.h"

@interface Fetch_QR_code()

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end
@implementation Fetch_QR_code

+ (Fetch_QR_code *)shareInstance
{
    static Fetch_QR_code *fetchCodeInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        fetchCodeInstance = [[self alloc] init];
    });
    return fetchCodeInstance;
}

- (void)initCaptureInView:(UIView *)view
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:(id)self
                                 queue:dispatch_get_main_queue()];
    AVCaptureSession *capSession = [[AVCaptureSession alloc] init];
    [capSession addInput:input];
    [capSession addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    self.session = capSession;

    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = view.bounds;

    [view.layer insertSublayer:preview
                       atIndex:100];
    self.previewLayer = preview;
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FETCH_STRING
                                                            object:[obj stringValue]];
//        [self stopCaptureSession];
//        [self.previewLayer removeFromSuperlayer];
    }
}

- (void)startCaptureSession
{
    [self.session startRunning];
}

- (void)stopCaptureSession
{
    [self.session stopRunning];
}

- (void)removePreviewLayerFromSuperview
{
    [self.previewLayer removeFromSuperlayer];
}

- (void)resetPreviewLayerFrame:(CGRect)frame
{
    [self.previewLayer setFrame:frame];
}

@end
