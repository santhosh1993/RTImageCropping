//
//  RTCropImage.m
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "UIImage+RTCropImage.h"
#import "UIImage+fixOrientation.h"

@implementation UIImage (RTCropImage)

+ (UIImage *)cropImageWithUIImage:(UIImage *)cropImage WithCropRect:(CGRect)cropRect withCornerRadius:(float) cornerRadius withFrameRect:(CGSize)frameSize
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

    if (cornerRadius != 0)
    {
        image = [self circularScaleAndCropImage:image frame:frameSize withCornerRadius:cornerRadius];
    }
    
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

+ (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGSize)frame withCornerRadius:(float)cornerRadius{

    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    //Calculate the centre of the circle
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGContextBeginPath (context);
    CGContextAddPath(context,[self buildThePathWithCornerRadius:cornerRadius withRectFrame:frame ImageRect:image.size]);
    CGContextClosePath (context);
    CGContextClip (context);

    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CGPathRef)buildThePathWithCornerRadius:(float)cornerRadius withRectFrame:(CGSize)frameRect ImageRect:(CGSize)imgRect
{
    
    float mul = imgRect.width/frameRect.width;
    
    UIBezierPath* path = [[UIBezierPath alloc]init];
    
    [path addArcWithCenter:CGPointMake(mul*cornerRadius,mul*cornerRadius) radius:mul*cornerRadius startAngle:-M_PI endAngle:-M_PI/2 clockwise:YES];
   
    [path addLineToPoint:CGPointMake(imgRect.width - mul * cornerRadius,0)];

    [path addArcWithCenter:CGPointMake(imgRect.width - mul * cornerRadius,mul*cornerRadius) radius:mul*cornerRadius startAngle:-M_PI/2 endAngle:0 clockwise:YES];
   
    [path addLineToPoint:CGPointMake(imgRect.width,imgRect.height - mul * cornerRadius)];
    
    [path addArcWithCenter:CGPointMake(imgRect.width - mul * cornerRadius,imgRect.height - mul * cornerRadius) radius:mul*cornerRadius startAngle:0 endAngle:-3*M_PI/2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(mul * cornerRadius,imgRect.height)];
   
    [path addArcWithCenter:CGPointMake(mul * cornerRadius,imgRect.height - mul * cornerRadius) radius:mul*cornerRadius startAngle:-3*M_PI/2 endAngle:-M_PI clockwise:YES];
   
    [path addLineToPoint:CGPointMake(0, mul * cornerRadius)];
    
    return [path CGPath];

}

@end
