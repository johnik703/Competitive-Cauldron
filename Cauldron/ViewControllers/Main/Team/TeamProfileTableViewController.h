//
//  TeamProfileTableViewController.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "WebServicesLinks.h"
#import "CreateTeamViewController.h"


@protocol TeamProfileDelegate <NSObject>
@optional
- (void)didDisappear;
@end

@interface TeamProfileTableViewController : BaseTableViewController{
    @private
    NSMutableDictionary *teamDictionary;
    IBOutlet UISegmentedControl *timeIntervalSC;
    
    @public
    CreateTeamViewController *createTeamViewController;
    Team *team;
    
//    @public
//    NSInteger createTeamTableViewIndex;
}

@property (nonatomic, strong) NSMutableArray *positionArr;

@property (assign, nonatomic) TeamState navigationTeamStatus;

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UITextField *yearTF;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *seasonStartsDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *seasonEndsDDTF;
@property (strong, nonatomic) IBOutlet UITextField *subscriptionDateDDTF;

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

@property (strong, nonatomic) IBOutlet UISegmentedControl *timeIntervalSC;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *timeDDTF;
@property (weak, nonatomic) IBOutlet UISwitch *scheduleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) id<TeamProfileDelegate> delegate;

@end
