//
//  AppDelegate.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "SWRevealViewController.h"
#import "Signup.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *sideMenuController;
@property (strong, nonatomic) LoginViewController *loginView;
@property (strong, nonatomic) UINavigationController *navController;

@property (assign, nonatomic) BOOL shouldRotate;

@end
