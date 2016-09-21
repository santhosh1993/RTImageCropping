//
//  RTCropImage.h
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (RTCropImage)

+ (UIImage *)cropImageWithUIImage:(UIImage *)cropImage WithCropRect:(CGRect)cropRect withCornerRadius:(float) cornerRadius withFrameRect:(CGSize)frame;
+ (UIImage *)rotateImage:(UIImage *)image;

@end
