//
//  RegisterViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    
    
    
    if (_navigationStatus == RegisterState_Update) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        [self addMenuLeftBarButtomItem];
        _rightBtn.title = @"Save";
        self.title = @"Profile";
        _teamSC.userInteractionEnabled = false;
        [_teamSC setHidden:YES];
        _nameFLTF.userInteractionEnabled = false;
        _sportDDTF.userInteractionEnabled = false;
//        [_teamSC setHidden:true];
        //_sportDDTF.userInteractionEnabled = false;
    } else if (_navigationStatus == RegisterState_Singup) {
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapGoingBack)];
        self.navigationItem.leftBarButtonItem = leftButton;
        
        _rightBtn.title = @"Register";
        self.title = @"Register";
        _teamSC.userInteractionEnabled = true;
        _nameFLTF.userInteractionEnabled = true;
        _sportDDTF.userInteractionEnabled = true;
    }
    
    // Load Sport List From Backend
    [API getSportsList:^(NSArray *responseArr) {
        _sportArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in responseArr) {
            Sport *sport = [Sport initWithDictionary:dic];
            [_sportArr addObject:sport];
            [self initSportListTextField];
        }
    } ErrorHandler:nil];
    
}

-(void)didTapGoingBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setiPhoneAndiPadUI];
    [self initializeUI];
}

- (void)setiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        [[self.menuStackView.heightAnchor constraintEqualToConstant:550] setActive:true];
        
    } else {
        
        [[self.menuStackView.heightAnchor constraintEqualToConstant:880] setActive:true];
        [[self.zipFLTF.heightAnchor constraintEqualToConstant:88] setActive:true];
    }
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - IBActions

- (IBAction)didTapNext:(id)sender {
    
    if (![self checkValidation]) {
        return;
    }
    
    if (_navigationStatus == RegisterState_Update) {
        [self updateProfile];
    } else if (_navigationStatus == RegisterState_Singup) {
        [self signup];
    }
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Private Methods

- (void)signup {
    NSString *sport = [Sport getIDFromTitle:_sportDDTF.selectedItem sports:_sportArr];
    NSDictionary* paramDic = @{
        @"signup_mode": [NSString stringWithFormat:@"%ld", (long)_teamSC.selectedSegmentIndex],
        @"Sport": sport,
        @"admin_name": _nameFLTF.text,
        @"admin_pw": _passwordFLTF.text,
        @"contact_email": _emailFLTF.text,
        @"contact_name": _contactNameFLTF.text,
        @"contact_phone": _contactPhone.text,
        @"contact_address": _addressFLTF.text,
        @"contact_city": _cityFLTF.text,
        @"contact_state": _stateFLTF.text,
        @"contact_zip": _zipFLTF.text,
        @"oldPass": @""};
        
    [ProgressHudHelper showLoadingHudWithText:@"Registering..."];
    
    [API executeHTTPRequest:Post url:signUpURL parameters: paramDic CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        if ([responseDict[@"Result"] isEqualToString:@"success"]) {
            [Alert showAlert:@"please check your email to verify account" message:@"" viewController:self complete:^{
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            }];
        } else if ([responseDict[@"Result"] isEqualToString:@"fail"]) {
            NSString *msg = responseDict[@"Msg"];
            [Alert showAlert:msg message:@"" viewController:self];
        }
    } ErrorHandler:^(NSString *errorStr) {
        [ProgressHudHelper hideLoadingHud];
    }];
}

- (void) updateProfile {
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    NSDictionary *paramDic;
    NSString *url;
    
    if (![getUserLevel isEqualToString:@"3"]) {
        NSString *sport = [Sport getIDFromTitle:_sportDDTF.selectedItem sports:_sportArr];
        paramDic = @{  @"signup_mode": [NSString stringWithFormat:@"%ld", (long)_teamSC.selectedSegmentIndex],
                       @"Sport": sport,
                       @"admin_name": _nameFLTF.text,
                       @"admin_pw": _passwordFLTF.text,
                       @"contact_email": _emailFLTF.text,
                       @"contact_name": _contactNameFLTF.text,
                       @"contact_phone": _contactPhone.text,
                       @"contact_address": _addressFLTF.text,
                       @"contact_city": _cityFLTF.text,
                       @"contact_state": _stateFLTF.text,
                       @"contact_zip": _zipFLTF.text,
                       @"oldPass": @"",
                       @"PlayerID": Global.playerIDFinal};
        url = [NSString stringWithFormat:newPlayerEdit, Global.teamSportID, Global.playerIDFinal];

    } else {
        paramDic = @{  @"PlayerID": Global.playerIDFinal,
                       @"admin_name": _nameFLTF.text,
                       @"admin_pw": _passwordFLTF.text,
                       @"contact_email": _emailFLTF.text,
                       @"contact_name": _contactNameFLTF.text,
                       @"contact_phone": _contactPhone.text,
                       @"contact_address": _addressFLTF.text,
                       @"contact_city": _cityFLTF.text,
                       @"contact_state": _stateFLTF.text,
                       @"contact_zip": _zipFLTF.text,
                       @"oldPass": @""};
        url = [NSString stringWithFormat:editUserProfile, Global.teamSportID];
    }
    
    url = [NSString stringWithFormat:editUserProfile, Global.teamSportID];
    [ProgressHudHelper showLoadingHudWithText:@"Updating..."];
    
    [API executeHTTPRequest:Post url:url parameters: paramDic CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        if ([responseDict[@"status"] isEqualToString:@"Success"]) {
            
            
            Global.objSignUp.adminPassword = _passwordFLTF.text;
            Global.objSignUp.adminEmail = _emailFLTF.text;
            Global.objSignUp.contactName = _contactNameFLTF.text;
            Global.objSignUp.contactPhone = _contactPhone.text;
            Global.objSignUp.address = _addressFLTF.text;
            Global.objSignUp.city = _cityFLTF.text;
            Global.objSignUp.state = _stateFLTF.text;
            Global.objSignUp.zip = _zipFLTF.text;
            NSLog(@"test contact name, %@", Global.objSignUp.contactName);
            
            [Alert showAlert:@"Updated profile!" message:@"" viewController:self complete:^{}];
        } else if ([responseDict[@"status"] isEqualToString:@"Fail"]) {
            NSString *msg = responseDict[@"Msg"];
            [Alert showAlert:msg message:@"" viewController:self];
        }
    } ErrorHandler:^(NSString *errorStr) {
        [ProgressHudHelper hideLoadingHud];
    }];

}

- (void)initializeUI {
    if (self.navigationStatus == RegisterState_Update) {
        self.teamSC.selectedSegmentIndex = 0;
        _sportDDTF.text = [self setSportNameWithInt:Global.objSignUp.sports];
        _nameFLTF.text = Global.objSignUp.adminLoginName;
        _passwordFLTF.text = Global.objSignUp.adminPassword;
        _emailFLTF.text = Global.objSignUp.adminEmail;
        _contactNameFLTF.text = Global.objSignUp.contactName;
        _contactPhone.text = Global.objSignUp.contactPhone;
        _addressFLTF.text = Global.objSignUp.address;
        _cityFLTF.text = Global.objSignUp.city;
        _stateFLTF.text = Global.objSignUp.state;
        _zipFLTF.text = Global.objSignUp.zip;
    }
}

- (NSString *) setSportNameWithInt: (NSString *)sport {
    
    if ([sport  isEqual: @"1"]) {
        return @"Soccer";
    } else if ([sport isEqual:@"2"]) {
        return @"Lacrosse";
    } else if ([sport isEqual:@"3"]) {
        return @"Volleyball";
    } else if ([sport isEqual:@"4"]) {
        return @"Basketball";
    } else if ([sport isEqual:@"5"]) {
        return @"Football";
    } else if ([sport isEqual:@"6"]) {
        return @"Hockey";
    } else if ([sport isEqual:@"7"]) {
        return @"Bobsled";
    } else if ([sport isEqual:@"8"]) {
        return @"Baseball";
    }
    
    return @"Sport";
}

- (BOOL)checkValidation {
    
    if (_nameFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter admin name" message:@"" viewController:self];
        return false;
    }
    
    if (_passwordFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter password" message:@"" viewController:self];
        return false;
    }
    
    if (![_passwordFLTF.text isUpperLowerDigitalPassword: 6]) {
        [Alert showAlert:@"Error" message:@"Password at least has one lower case letter, one upper case letter, one digit and 6 characters." viewController:self];
        return false;
    }
    
    if (!_emailFLTF.text.isValidEmail) {
        [Alert showAlert:@"Please enter valid email address" message:@"" viewController:self];
        return false;
    }
    
    if (_contactNameFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter contact name" message:@"" viewController:self];
        return false;
    }
    
    if (_contactPhone.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter contact phone" message:@"" viewController:self];
        return false;
    }
    
    if (_addressFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter address" message:@"" viewController:self];
        return false;
    }
    
    if (_cityFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter city" message:@"" viewController:self];
        return false;
    }
    
    if (_stateFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter state" message:@"" viewController:self];
        return false;
    }
    
    if (_zipFLTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Please enter zip" message:@"" viewController:self];
        return false;
    }
    
    return true;
}

- (void) initSportListTextField {
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    for (Sport *sport in _sportArr) {
        [arr addObject:sport.sportTitle];
    }
    
    
    [_sportDDTF setItemList:arr];
    _sportDDTF.selectedItem = [Sport getSportInSports:_sportArr sportID:Global.objSignUp.sportsID].sportTitle;
}

@end
