//
//  ChallengeDetailVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ChallengeDetailVC.h"

@interface ChallengeDetailVC ()

@end

@implementation ChallengeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLbl.text = self.challangeTitle;
    int chalngID = self.challangeID;
    
    NSLog(@"detailchallengeid, %d", chalngID);

    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallengeImage WHERE ChallangeID=%d",chalngID];
    
    NSArray *imageDataArr = [SCSQLite selectRowSQL:query];
    
    if (imageDataArr.count > 0) {
        NSString *base64String = [[imageDataArr objectAtIndex:0] valueForKey:@"imgData"];
        
        NSLog(@"imageTest--%@", base64String);
        

        if ([base64String isEqualToString:@"No Image"]) {
            //set default image
            self.imgView.image = nil;
        } else {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",base64String]];
            self.imgView.image = image;
        }
    }
    
    if ([self.challengeDetails isEqualToString:@""]) {
        NSString *NoDesc = @"<html><body><strong>No Description available</strong></body></html>";
        [self.webView loadHTMLString:NoDesc baseURL:nil];
    } else {
        NSString *strHtml = [NSString stringWithFormat:@"<html><body>%@</body></html>",self.challengeDetails];
        NSString *webStr = [strHtml kv_decodeHTMLCharacterEntities];
        [self.webView loadHTMLString:webStr baseURL:nil];
    }
}

#pragma mark - IBActions

- (IBAction)didTapScore:(id)sender {
    ScoreViewController *viewController = (ScoreViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
    viewController.scTeamID = self.challengeTeamID;
    viewController.scChallengeID = self.challangeID;
    viewController.scChallengeType = self.challengeType;
    viewController.scChallengeName = self.challangeTitle;
    viewController.sportsID = self.soportsID;
    viewController.isdecimal = self.isDecimal;
    
    [self.navigationController pushViewController:viewController animated:true];
}

@end
