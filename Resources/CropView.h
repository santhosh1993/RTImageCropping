//
//  CropView.h
//  PicSaw
//
//  Created by Santhosh on 07/08/15.
//  Copyright (c) 2015 Santhosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropViewDelegate <NSObject>

- (void)panGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)leftToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)rightToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)leftBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)rightBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer;

@end

@interface CropView : UIView

@property (nonatomic , weak) id <CropViewDelegate> delegate;

@end
