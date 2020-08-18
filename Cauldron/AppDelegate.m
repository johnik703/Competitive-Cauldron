//
//  AppDelegate.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIApplication+AppVersion.h"
#import "SARate.h"

@import SVProgressHUD;
//@import IQKeyboardManager;
@import IQKeyboardManagerSwift;




@implementation AppDelegate

BOOL shouldRotate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupSVProgressHud];
    [self setupIQKeyboardManager];
    [self setNavigationAppearance];
    [self setupATUpdater];
    
    [self setupFileManagerForImages];
    [self setupSRate];
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.shouldRotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void) setupSRate {
    [SARate sharedInstance].daysUntilPrompt = 100;
    [SARate sharedInstance].usesUntilPrompt = 100;
    [SARate sharedInstance].remindPeriod = 100;
    [SARate sharedInstance].promptForNewVersionIfUserRated = YES;
    //enable preview mode
    [SARate sharedInstance].previewMode = NO;
    
    [SARate sharedInstance].email = @"jsis@competitive-cauldron.com";
    // 4 and 5 stars
    [SARate sharedInstance].minAppStoreRaiting = 4;
    [SARate sharedInstance].emailSubject = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [SARate sharedInstance].emailText = @"Disadvantages: ";
    [SARate sharedInstance].headerLabelText = @"Like app?";
    [SARate sharedInstance].descriptionLabelText = @"Touch the star to rate.";
    [SARate sharedInstance].rateButtonLabelText = @"Rate";
    [SARate sharedInstance].cancelButtonLabelText = @"Not Now";
    [SARate sharedInstance].setRaitingAlertTitle = @"Rate";
    [SARate sharedInstance].setRaitingAlertMessage = @"Touch the star to rate.";
    [SARate sharedInstance].appstoreRaitingAlertTitle = @"Write a review on the AppStore";
    [SARate sharedInstance].appstoreRaitingAlertMessage = @"Would you mind taking a moment to rate it on the AppStore? It won’t take more than a minute. Thanks for your support!";
    [SARate sharedInstance].appstoreRaitingCancel = @"Cancel";
    [SARate sharedInstance].appstoreRaitingButton = @"Rate It Now";
    [SARate sharedInstance].disadvantagesAlertTitle = @"Disadvantages";
    [SARate sharedInstance].disadvantagesAlertMessage = @"Please specify the deficiencies in the application. We will try to fix it!";
}

- (void) setupATUpdater {
    
    NSString *appVersion = [UIApplication versionBuild];
    NSLog(@"appversion: %@, %@", appVersion, FINAL_APP_VERSION);
    
    ATAppUpdater *updater = [ATAppUpdater sharedUpdater];
    [updater setAlertTitle:@"Great News!"];
    [updater setAlertMessage:@"Competitive Cauldron v6.4 is available on the AppStore."];
    [updater setAlertUpdateButtonTitle:@"Update"];
    [updater setAlertCancelButtonTitle:@"Not Now"];
    [updater setDelegate:self]; // Optional
    [updater showUpdateWithConfirmation];
}

- (void) setupFileManagerForImages {
    // Create folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    NSLog(@"image path %@", dataPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:Nil];
    }
}

- (void) setupSVProgressHud {
    //set SVProgressHud
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}

- (void) setupIQKeyboardManager {
    [[IQKeyboardManager shared] setEnable:YES];
    [[IQKeyboardManager shared] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager shared] setEnableAutoToolbar:YES];
    [IQKeyboardManager shared].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysShow;
}

- (void) setNavigationAppearance {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:THEME_COLOR];
    [[UINavigationBar appearance] setTintColor:TINT_COLOR];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    // set navagation title
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSShadow* shadow1 = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: HelveticaNeueFont(20.0F),
                                                            NSShadowAttributeName: shadow1
                                                            }];
}

#pragma mark - ATAppUpdater Delegate
- (void)appUpdaterDidShowUpdateDialog
{
    NSLog(@"appUpdaterDidShowUpdateDialog");
}

- (void)appUpdaterUserDidLaunchAppStore
{
    NSLog(@"appUpdaterUserDidLaunchAppStore");
    NSString *iTunesLink = @"itms://itunes.apple.com/us/app/competitive-cauldron/id853669889?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (void)appUpdaterUserDidCancel
{
    NSLog(@"appUpdaterUserDidCancel");
}


@end
