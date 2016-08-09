//
//  ImageCroppingViewController.h
//  RTImageCroping
//
//  Created by Santhosh on 06/08/15.
//  Copyright (c) 2015 Santhosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCroppingViewControllerDataSource <NSObject>

- (CGSize)imageCroppingSize;

@end

@protocol ImageCroppingViewControllerDelegate <NSObject>

- (void)croppedImage:(UIImage *)image;

@end

@interface ImageCroppingViewController : UIViewController

@property (nonatomic , weak) id<ImageCroppingViewControllerDataSource> dataSource;
@property (nonatomic , weak) id<ImageCroppingViewControllerDelegate> delegate;
@property (nonatomic , strong) UIImage *cropImage;

@end
