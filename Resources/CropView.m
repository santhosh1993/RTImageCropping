//
//  CropView.m
//  PicSaw
//
//  Created by Santhosh on 07/08/15.
//  Copyright (c) 2015 Santhosh. All rights reserved.
//

#import "CropView.h"

@implementation CropView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        UIView *cropView = [[UIView alloc] initWithFrame:CGRectMake(20,20,self.frame.size.width - 40,self.frame.size.height - 40)];
        cropView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        cropView.layer.borderWidth = 1;
        cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self addSubview:cropView];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognised:)];
        
        [cropView addGestureRecognizer:panRecognizer];
        
        [self leftTopGestureView];
        [self rightTopGestureView];
        [self leftBottomGestureView];
        [self rightBottomGestureView];
        
    }
    return self;
}

#pragma mark - Recognizer methods

- (void)panGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(panGestureRecognised:)])
    {
        [self.delegate panGestureRecognised:recognizer];
    }
}

-(void)leftToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(leftToppanGestureRecognised:)])
    {
        [self.delegate leftToppanGestureRecognised:recognizer];
    }
}

-(void)rightToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(rightToppanGestureRecognised:)])
    {
        [self.delegate rightToppanGestureRecognised:recognizer];
    }
}

-(void)leftBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(leftBottompanGestureRecognised:)])
    {
        [self.delegate leftBottompanGestureRecognised:recognizer];
    }
}

-(void)rightBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(rightBottompanGestureRecognised:)])
    {
        [self.delegate rightBottompanGestureRecognised:recognizer];
    }
}

#pragma mark - DEVELOPER METHODS

- (void)leftTopGestureView
{
    UIView *leftTopView = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    leftTopView.backgroundColor= [UIColor clearColor];
    leftTopView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:leftTopView];
    
    UIImageView *leftTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftTopView.frame.size.width/2 + 2,leftTopView.frame.size.height/2 + 2, 16 , 16 )];
    leftTopImageView.image = [UIImage imageNamed:@"cr1.png"];
    [leftTopView addSubview:leftTopImageView];
    
    UIPanGestureRecognizer *leftTopPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftToppanGestureRecognised:)];
    
    [leftTopView addGestureRecognizer:leftTopPanRecognizer];
    
}

- (void)rightTopGestureView
{
    UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40,0,40,40)];
    rightTopView.backgroundColor= [UIColor clearColor];
    rightTopView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:rightTopView];
    
    UIImageView *rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2,rightTopView.frame.size.height/2 + 2, 16 , 16 )];
    rightTopImageView.image = [UIImage imageNamed:@"cr2.png"];
    [rightTopView addSubview:rightTopImageView];
    
    UIPanGestureRecognizer *rightTopPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightToppanGestureRecognised:)];
    
    [rightTopView addGestureRecognizer:rightTopPanRecognizer];
    
}

- (void)leftBottomGestureView
{
    UIView *leftBottomView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height - 40,40,40)];
    leftBottomView.backgroundColor= [UIColor clearColor];
    leftBottomView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:leftBottomView];
    
    UIImageView *leftBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftBottomView.frame.size.width/2 + 2, 2, 16 , 16 )];
    leftBottomImageView.image = [UIImage imageNamed:@"cr4.png"];
    [leftBottomView addSubview:leftBottomImageView];
    
    UIPanGestureRecognizer *leftBottomPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBottompanGestureRecognised:)];
    
    [leftBottomView addGestureRecognizer:leftBottomPanRecognizer];
}


- (void)rightBottomGestureView
{
    UIView *rightBottomView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40,self.frame.size.height - 40,40,40)];
    rightBottomView.backgroundColor= [UIColor clearColor];
    rightBottomView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:rightBottomView];
    
    UIImageView *rightBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2,2, 16 , 16 )];
    rightBottomImageView.image = [UIImage imageNamed:@"cr3.png"];
    [rightBottomView addSubview:rightBottomImageView];
    
    UIPanGestureRecognizer *rightBottomPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightBottompanGestureRecognised:)];
    
    [rightBottomView addGestureRecognizer:rightBottomPanRecognizer];
}


@end
