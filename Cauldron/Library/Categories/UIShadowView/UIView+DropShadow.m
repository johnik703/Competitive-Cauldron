//
//  UIView+DropShadow.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIView+DropShadow.h"

@implementation UIView (DropShadow)

const CGSize DS_DEFAULT_OFFSET = {0, 2};
const CGFloat DS_DEFAULT_RADIUS = 1.0f;
const CGFloat DS_DEFAULT_OPACITY = 0.8f;

- (void)addDropShadow:(UIColor *)color withOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void)addDropShadow:(UIColor *)color
{
    [self addDropShadow:color
             withOffset:DS_DEFAULT_OFFSET
                 radius:DS_DEFAULT_RADIUS
                opacity:DS_DEFAULT_OPACITY];
}

- (void)addShadow
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
