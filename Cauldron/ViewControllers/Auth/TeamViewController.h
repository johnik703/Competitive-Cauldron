//
//  TeamViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *scheduleContainer;
@property (weak, nonatomic) IBOutlet UIView *contactContainer;
@property (weak, nonatomic) IBOutlet UIView *seasonContainer;

@end
