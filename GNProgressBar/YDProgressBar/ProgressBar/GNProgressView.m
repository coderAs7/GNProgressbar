//
//  GNProgressView.m
//  GNProgressBar
//
//  Created by seayu on 2017/5/23.
//  Copyright © 2017年 seayu. All rights reserved.
//

#import "GNProgressView.h"

@interface GNProgressView ()

@property (weak, nonatomic) UIImageView *triangleIndicatorImageView;

@end


@implementation GNProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [self createTriangleIndicatorImageView];
        [self addSubview:imageView];
        _triangleIndicatorImageView = imageView;
    }
    return self;
}



- (UIImageView *)createTriangleIndicatorImageView{
    UIImage *image = [UIImage imageNamed:@"SV_Triangleindicator"];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    CGRect imageViewFrame = CGRectMake(0, 0,image.size.width,image.size.height);
    imageView.frame = imageViewFrame;
    return imageView;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect imageViewframe = _triangleIndicatorImageView.frame;
    imageViewframe.origin.y = frame.size.height;
    _triangleIndicatorImageView.frame = imageViewframe;
    CGPoint center = _triangleIndicatorImageView.center;
    center.x = 0 - 1 / 2.0 ;
    _triangleIndicatorImageView.center = center;
}

- (void)setHiddenTriangleIndicatorImageView:(BOOL)hiddenTriangleIndicatorImageView{
    _triangleIndicatorImageView.hidden = hiddenTriangleIndicatorImageView;
    _hiddenTriangleIndicatorImageView = hiddenTriangleIndicatorImageView;
}

@end
