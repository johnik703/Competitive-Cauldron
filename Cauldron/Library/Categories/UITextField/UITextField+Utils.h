//
//  UITextField+Utils.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utils)

- (void) setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;
- (void) setLeftPadding:(CGFloat)padding;

@end
