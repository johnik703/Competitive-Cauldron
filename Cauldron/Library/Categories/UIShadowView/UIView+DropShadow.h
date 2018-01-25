//
//  UIView+DropShadow.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DropShadow)

- (void)addDropShadow:(UIColor *)color withOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;
- (void)addShadow;
- (void)addDropShadow:(UIColor *)color;

@end
