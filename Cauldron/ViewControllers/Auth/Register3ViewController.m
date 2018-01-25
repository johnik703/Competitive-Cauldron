//
//  Register3ViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Register3ViewController.h"

@interface Register3ViewController ()

@end

@implementation Register3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Init UI
    if ([Global.objSignUp.timeInterval isEqualToString:@"Daily"]) {
        self.timeIntervalSC.selectedSegmentIndex = 0;
    } else if([Global.objSignUp.timeInterval isEqualToString:@"Weekly"]) {
        self.timeIntervalSC.selectedSegmentIndex = 1;
    } else if([Global.objSignUp.timeInterval isEqualToString:@"Monthly"]) {
        self.timeIntervalSC.selectedSegmentIndex = 2;
    }
    //@property (weak, nonatomic) IBOutlet IQDropDownTextField *timeDDTF;
    
    self.scheduleSwitch.on = Global.objSignUp.isRunSchedual;
    self.enableSwitch.on = Global.objSignUp.isEnable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapDone:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
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
