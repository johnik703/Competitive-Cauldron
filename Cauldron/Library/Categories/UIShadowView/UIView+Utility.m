//
//  UIView+Utility.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (void) circleView
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
}
@end
