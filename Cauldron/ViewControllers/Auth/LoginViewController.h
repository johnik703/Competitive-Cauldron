//
//  LoginViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SQLManager.h"
#import "SCSQLite.h"
#import "SyncFromServer.h"
#import "WebServicesLinks.h"
#import "JSONHelper.h"
#import "Player.h"
#import "DataFetcherHelper.h"
#import "LoginUser.h"
#import "SCSQLite.h"
#import "RKCommon.h"
#import "SSCheckBoxView.h"

@class AppDelegate;

@interface LoginViewController: UIViewController <UITextFieldDelegate, SyncFromServerDelegate>
{
    NSArray *allPlayers;
    NSArray *allTeams;
    NSArray *allChallenges;
    NSArray *allCatagories;
    NSArray *allImages;
    NSArray *allStates;
    
    BOOL isRememberLogin;
}

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;

- (void) checkAuthenticationOnlineWithUserID:(NSString*)userID andPassword:(NSString*)UserPass;

@end
