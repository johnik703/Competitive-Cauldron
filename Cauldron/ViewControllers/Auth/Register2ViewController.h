//
//  Register2ViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register2ViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayReportBeforeTF;
@property (weak, nonatomic) IBOutlet UISwitch *activateSC;
@property (weak, nonatomic) IBOutlet UISwitch *emailCoachForJournalSC;
@property (weak, nonatomic) IBOutlet UISwitch *emailCoachForPlayerLoginSC;
@property (weak, nonatomic) IBOutlet UISwitch *finalRankingReportSC;
@property (weak, nonatomic) IBOutlet UISwitch *highlightDropSC;
@property (weak, nonatomic) IBOutlet UISwitch *hightlightBestRankingSC;
@property (weak, nonatomic) IBOutlet UISwitch *bulkDataEntrySC;
@property (weak, nonatomic) IBOutlet UISwitch *fitnessPassFailReportSC;

- (BOOL) checkValidation;

@end
