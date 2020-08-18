//
//  ScoreViewController.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTableViewCell.h"

@interface ScoreViewController : UIViewController
{
    NSString *allColumnName;
    int isDecimal;
    NSString *challengeType;
    
    NSArray *arrComumnName;
    NSArray *PlayersInfoArray;
    NSArray *teamPlayersStats;
    
    NSMutableArray *oldScoreArr;
    NSMutableArray *tempScoreArr;

    int arrScoreOrientationCount;
    
    NSMutableArray *arrTeamPlayerID;
    NSMutableArray *arrScoreOrientation;
    
    NSMutableArray *selectedRowsArray;
    UILabel *nameContainerView;
}

@property (nonatomic, assign) int sportsID;
@property (nonatomic, assign) int scTeamID;
@property (nonatomic, assign) int scChallengeID;
@property (nonatomic, copy) NSString *scChallengeType;
@property (nonatomic, copy) NSString *scChallengeName;
@property (nonatomic, retain) NSString *isdecimal;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *dateDDTF;
@property (strong, nonatomic) IBOutlet UISwitch *emailReportSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
