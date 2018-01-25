//
//  BaseViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showHTTPErrorAlert:(nonnull UIViewController *)viewController {
    NSString *message = @"Something went wrong";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

- (void)addMenuLeftBarButtomItem {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
    button.image = [UIImage imageNamed:@"icon_menu"];
    if (self.revealViewController) {
        button.target = self.revealViewController;
        button.action = @selector(revealToggle:);
    }
    self.navigationItem.leftBarButtonItem = button;
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

@implementation BaseTableViewController

- (void)addMenuLeftBarButtomItem {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
    button.image = [UIImage imageNamed:@"icon_menu"];
    if (self.revealViewController) {
        button.target = self.revealViewController;
        button.action = @selector(revealToggle:);
    }
    self.navigationItem.leftBarButtonItem = button;
}

@end
