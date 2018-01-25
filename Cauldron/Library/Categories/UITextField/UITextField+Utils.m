//
//  UITextField+Utils.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

- (void) setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
}

- (void) setLeftPadding:(CGFloat)padding {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, 10)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
