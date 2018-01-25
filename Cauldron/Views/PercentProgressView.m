//
//  PercentProgressView.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "PercentProgressView.h"

@implementation PercentProgressView

@synthesize progressBar, percentLabel, blackView;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"PercentProgressView" owner:self options:nil];
    
    [self addSubview: blackView];
    self.blackView.frame = self.bounds;
    
}


//-(id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"PercentProgressView" owner:self options:nil] objectAtIndex:0]];
//    }
//    return self;
//}



@end
