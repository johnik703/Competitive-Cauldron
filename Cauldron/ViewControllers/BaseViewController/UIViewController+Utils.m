//
//  UIViewController+Utils.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (utils)

- (void)showHTTPErrorAlert:(nonnull UIViewController *)viewController {
    NSString *message = @"Something went wrong";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

- (void)addMenuRightBarButtomItem {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
    button.image = [UIImage imageNamed:@"icon_menu"];
    if (self.revealViewController) {
        button.target = self.revealViewController;
        button.action = @selector(revealToggle:);
    }
    self.navigationItem.rightBarButtonItem = button;
}

@end
