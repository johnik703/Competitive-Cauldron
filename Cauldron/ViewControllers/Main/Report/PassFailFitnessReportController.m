//
//  PassFailFitnessReportController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "PassFailFitnessReportController.h"

@interface PassFailFitnessReportController () <UIWebViewDelegate, UIScrollViewDelegate>

@end

@implementation PassFailFitnessReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Pass/Fail Fitness Report"];
    
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        return;
    }
    
    //    [self.webView setHidden:YES];
    
    self.webView.delegate = self;
    //    self.webView.scrollView.delegate = self;
    self.webView.scalesPageToFit=TRUE;
    self.webView.scrollView.scrollEnabled = TRUE;
    [self.webView.scrollView setContentSize:CGSizeMake(1920.0f, 1080.0f)];
    self.webView.scrollView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *url = [NSString stringWithFormat:fitnessPassFailRanking, Global.currntTeam.TeamID, Global.mode, Global.playerIDFinal];
    
    NSLog(@"fetnessReportUrl, %@---end", url);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webView.scrollView.bounces = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ProgressHudHelper showLoadingHudWithText:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [ProgressHudHelper hideLoadingHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHudHelper hideLoadingHud];
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
    } else {
        [Alert showAlert:@"Failed to load page" message:@"Try again later" viewController:self];
    }

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
