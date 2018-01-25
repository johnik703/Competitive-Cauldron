//
//  Register3ViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register3ViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *timeIntervalSC;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *timeDDTF;
@property (weak, nonatomic) IBOutlet UISwitch *scheduleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

- (BOOL) checkValidation;

@end
