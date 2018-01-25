//
//  UIView+Utils.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void) setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
}

@end
