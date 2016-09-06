//
//  Generate_QR_Code.m
//  QR_Code
//
//  Created by Kenny on 16/9/1.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import "Generate_QR_Code.h"
#import <CoreImage/CoreImage.h>

@implementation Generate_QR_Code
- (CIImage *)generateString:(NSString *)str
{
//    UIImage *image;
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
//    image = [UIImage imageWithCIImage:[filter outputImage] scale:20.0 orientation:UIImageOrientationUp];
    
    return [filter outputImage];
}

- (UIImage *)generateString:(NSString *)str size:(CGSize)size interpolate:(BOOL)interpolate
{
    UIImage *image;
    CIImage *ciImage = [self generateString:str];
    
    if (interpolate) {
        image = [self createNoneInterpolateUIImageFromCIImage:ciImage imageSize:size];
    } else {
        image = [UIImage imageWithCIImage:ciImage];
    }
    
    return image;
}

- (UIImage *)createNoneInterpolateUIImageFromCIImage:(CIImage *)image imageSize:(CGSize)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
