//
//  UIBarButtonItem+Utils.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIBarButtonItem+Utils.h"

@implementation UIBarButtonItem (Utils)

- (void)hide {
    self.tintColor = [UIColor clearColor];
    self.enabled = false;
}

- (void)show {
    self.tintColor = [UIColor whiteColor];
    self.enabled = true;
}

@end
