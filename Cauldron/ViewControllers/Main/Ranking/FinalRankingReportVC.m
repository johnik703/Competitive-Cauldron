//
//  FinalRankingReportVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "FinalRankingReportVC.h"
@import SVProgressHUD;

@interface FinalRankingReportVC () <UIWebViewDelegate, UIScrollViewDelegate>

@end

@implementation FinalRankingReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Final Ranking Report"];
    
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        return;
    }
    
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    if ([getUserLevel isEqualToString:@"3"]) {
        playerID = Global.playerIDFinal;
    } else {
        playerID=@"&";
    }
    
    self.webView.delegate = self;
//    self.webView.scrollView.delegate = self;
    self.webView.scalesPageToFit=TRUE;
    self.webView.scrollView.scrollEnabled = TRUE;
    [self.webView.scrollView setContentSize:CGSizeMake(1920.0f, 1080.0f)];
    self.webView.scrollView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *url = [NSString stringWithFormat:finalRanking, Global.currntTeam.TeamID, Global.mode, Global.playerIDFinal];
    
    NSLog(@"finalRankingUrl, %@---end", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
    self.webView.scrollView.bounces = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [SVProgressHUD dismiss];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [SVProgressHUD dismiss];
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
    } else {
        [Alert showAlert:@"The request timed out." message:@"Try again later." viewController:self];
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
