//
//  EditCoachController.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface EditCoachController : UITableViewController {
    
    NSMutableDictionary *coachDictionary;
    Coach *coach;
    @public
    int coachID;
    
}

@property (assign, nonatomic) CoachState navigationCoachState;

@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;

@property (weak, nonatomic) IBOutlet UITextField *contactAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *contactCityTF;

@property (weak, nonatomic) IBOutlet UITextField *contactStateTF;

@property (weak, nonatomic) IBOutlet UITextField *contactZipTF;

@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *coachLoginNameTF;

@property (weak, nonatomic) IBOutlet UITextField *coachPasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *coachEmailTF;

@property (weak, nonatomic) IBOutlet UISwitch *emailCoachRankingSwitch;






@end
