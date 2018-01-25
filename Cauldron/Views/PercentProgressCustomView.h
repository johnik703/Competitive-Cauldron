//
//  PercentProgressCustomView.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentProgressCustomView : UIView {
    @public
    UIProgressView *progressView;
    @public
    UILabel *percentLabel;
}

- (void)showProgress;

- (void)showProgressBar:(NSNotification *)progressCount;

- (void)hideProgressBar;

@end
