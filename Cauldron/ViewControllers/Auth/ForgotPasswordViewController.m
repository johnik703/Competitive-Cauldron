//
//  ForgotPasswordViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//s

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSendEmail:(id)sender {
    if (!_emailTF.text.isValidEmail) {
        [Alert showAlert:@"Invalid Email" message:@"" viewController:self];
        _emailTF.text = @"";
        return;
    }
    
    NSString *url = [NSString stringWithFormat:forgotPasswordURL, _emailTF.text];
    
    [API executeHTTPRequest:Get url:url parameters:nil CompletionHandler:^(NSDictionary *responseDict) {
        NSString *result = responseDict[@"Result"];
        if ([result isEqualToString:@"success"]) {
            [Alert showAlert:@"Have sent email. Please check your email to reset password" message:@"" viewController:self complete:^{
                [self dismissViewControllerAnimated:true completion:nil];
            }];
        } else {
            [Alert showAlert:responseDict[@"Msg"] message:@"" viewController:self];
        }
    } ErrorHandler:^(NSString *errorStr) {
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
