//
//  PercentProgressView.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentProgressView : UIView

@property (strong, nonatomic) IBOutlet UIView *blackView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@property (strong, nonatomic) IBOutlet UILabel *percentLabel;

@end
