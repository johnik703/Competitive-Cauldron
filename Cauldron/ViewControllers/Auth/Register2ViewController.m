//
//  Register2ViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Register2ViewController.h"

@interface Register2ViewController ()

@end

@implementation Register2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Set UI
    self.positionTF.text = Global.objSignUp.position;
    self.birthdayReportBeforeTF.text = Global.objSignUp.bdayBefor;
    [self.activateSC setOn:Global.objSignUp.isActivate animated:false];
    [self.emailCoachForJournalSC setOn:Global.objSignUp.isEmailJournal animated:false];
    [self.emailCoachForPlayerLoginSC setOn:Global.objSignUp.isEmailPlayer animated:false];
    self.finalRankingReportSC.on = Global.objSignUp.isDisplayLegend;
    self.highlightDropSC.on = Global.objSignUp.isHighlightDrop;
    self.hightlightBestRankingSC.on = Global.objSignUp.isHighlightBest;
    self.bulkDataEntrySC.on = Global.objSignUp.isBulckReport;
    self.fitnessPassFailReportSC.on = Global.objSignUp.isIncludeFitness;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapNext:(id)sender {
    Register3ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register3ViewController"];
    [self.navigationController pushViewController:viewController animated:true];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Public Methods

- (BOOL) checkValidation {
//    if ([self.teamNameTF.text isEqualToString:@""]) {
//        [Alert showAlert:@"Team name is required" message:@"" viewController:self];
//        return false;
//    }
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
