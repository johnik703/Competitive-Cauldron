//
//  PercentProgressCustomView.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "PercentProgressCustomView.h"

@implementation PercentProgressCustomView

#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        containerView.backgroundColor = [UIColor darkGrayColor];
        containerView.alpha = 0.8;
        [self addSubview:containerView];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.translatesAutoresizingMaskIntoConstraints = false;
        [progressView setProgress:0.0 animated:YES];
        [progressView setTrackTintColor:[UIColor whiteColor]];
        [progressView setProgressTintColor:[UIColor greenColor]];
        [containerView addSubview:progressView];
        
        [[progressView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor] setActive:true];
        [[progressView.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor] setActive:true];
        [[progressView.widthAnchor constraintEqualToAnchor:containerView.widthAnchor multiplier:0.9] setActive:true];
        
        percentLabel = [[UILabel alloc] init];
        percentLabel.translatesAutoresizingMaskIntoConstraints = false;
        percentLabel.textColor = [UIColor whiteColor];
        [containerView addSubview:percentLabel];
        
        [[percentLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor constant:0] setActive:true];
        [[percentLabel.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor constant:30] setActive:true];
        
        
        
    }
    
    return self;
}

- (void)showProgress {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProgressBar:) name:KEYVALUE object:nil];
}

-(void)showProgressBar:(NSNotification *)progressCount {
    
    [self setHidden:NO];
    
    NSString *countValue = [NSString stringWithFormat:@"%@",[progressCount.userInfo objectForKey:PROGRESS_VALUE]];
    NSString *totalCount = [NSString stringWithFormat:@"%@",[progressCount.userInfo objectForKey:TOTAL_VALUE]];
    
//    NSLog(@"countvalue--%@, totalcount--%@", countValue, totalCount);
    
    
    
    NSUInteger finalCountValue = [countValue intValue];
    float progressValue = (float)finalCountValue/[totalCount integerValue];
    float percentageValue = (100 * finalCountValue)/[totalCount integerValue];
    
//    NSLog(@"progressValu---%f, percentvalue--%f", progressValue, percentageValue);
    
    if ([countValue isEqualToString:@"0"]) {
        [progressView setProgressTintColor:[UIColor whiteColor]];
        [progressView setProgress:0.0 animated:NO];
        percentLabel.text = @"Data Syncing 0%";
    } else {
        [progressView setProgressTintColor:[UIColor greenColor]];
        dispatch_async(dispatch_get_main_queue(), ^{
            percentLabel.text = [NSString stringWithFormat:@"Data Syncing %@%%", [NSNumber numberWithFloat:percentageValue]];
            [progressView setProgress:progressValue animated:YES];
        });

    }
    
}

-(void)hideProgressBar {
    percentLabel.text = @"";
    [progressView setProgress:0.0 animated:NO];
    [self setHidden:YES];
}




@end
