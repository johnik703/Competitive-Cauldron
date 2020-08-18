//
//  ChallengeDetailVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeDetailVC : UIViewController

@property (nonatomic, assign) int soportsID;
@property (nonatomic, assign) int challangeID;
@property (nonatomic, assign) int challengeTeamID;
@property (nonatomic, retain) NSString *isDecimal;
@property (nonatomic, strong) NSString *challangeTitle;
@property (nonatomic, strong) NSString *challengeDetails;
@property (nonatomic, strong) NSString *challengeType;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
