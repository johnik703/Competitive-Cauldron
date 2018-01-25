//
//  TeamViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()
{
    Register1ViewController *reg1VC;
    Register2ViewController *reg2VC;
    Register3ViewController *reg3VC;
}
@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMenuLeftBarButtomItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
}

- (IBAction)valueChangedInSegmentControl:(id)sender {
    switch (_segmentControl.selectedSegmentIndex) {
        case 0: //Season
            self.seasonContainer.hidden = false;
            self.contactContainer.hidden = true;
            self.scheduleContainer.hidden = true;
            [self.seasonContainer bringSubviewToFront:self.view];
            break;
        case 1: // Contact
            self.seasonContainer.hidden = true;
            self.contactContainer.hidden = false;
            self.scheduleContainer.hidden = true;
            [self.contactContainer bringSubviewToFront:self.view];
            break;
        case 2: // Schedule
            self.seasonContainer.hidden = true;
            self.contactContainer.hidden = true;
            self.scheduleContainer.hidden = false;
            [self.scheduleContainer bringSubviewToFront:self.view];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSeason"]) {
        reg1VC = (Register1ViewController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"showContact"]) {
        reg2VC = (Register2ViewController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"showSchedule"]) {
        reg3VC = (Register3ViewController *)segue.destinationViewController;
    }
}

@end
