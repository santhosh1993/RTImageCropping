//
//  RTCropImage.m
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "RTCropImage.h"
#import "UIImage+fixOrientation.h"

@implementation RTCropImage

+ (UIImage *)cropImageWithUIImage:(UIImage *)cropImage WithCropRect:(CGRect)cropRect
{
    CGAffineTransform rectTransform;
    
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    switch (cropImage.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -cropImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -cropImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -cropImage.size.width, -cropImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, cropImage.scale, cropImage.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(cropRect, rectTransform);
    CGImageRef imageRef = CGImageCreateWithImageInRect([cropImage CGImage], transformedCropSquare);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:cropImage.scale orientation:cropImage.imageOrientation];
    
    CGImageRelease(imageRef);

    return image;
}

+ (UIImage *)rotateImage:(UIImage *)image {
    
    int orient = image.imageOrientation;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    UIImage *imageCopy = [[UIImage alloc] initWithCGImage:image.CGImage];
    
    
    switch (orient) {
        case UIImageOrientationLeft:
            imageView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            imageView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            imageView.transform = CGAffineTransformMakeRotation(M_PI);
        default:
            break;
    }
    
    imageView.image = imageCopy;
    return (imageView.image);
}


@end
