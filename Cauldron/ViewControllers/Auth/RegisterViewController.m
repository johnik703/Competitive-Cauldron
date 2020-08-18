//
//  RegisterViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RegisterViewController.h"
@import SVProgressHUD;
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize emailCoachRankingView, emailCoachRankingSwich;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    teamDictionary = [[NSMutableDictionary alloc] init];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    if (_navigationStatus == RegisterState_Update) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        _rightBtn.title = @"Save";
        self.title = @"Profile";
        _teamSC.userInteractionEnabled = false;
        [_teamSC setHidden:YES];
        _nameFLTF.userInteractionEnabled = false;
        _sportDDTF.userInteractionEnabled = false;
        
    } else if (_navigationStatus == RegisterState_Singup) {
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapGoingBack)];
        self.navigationItem.leftBarButtonItem = leftButton;
        
        _rightBtn.title = @"Register";
        self.title = @"Register";
        _teamSC.userInteractionEnabled = true;
        _nameFLTF.userInteractionEnabled = true;
        _sportDDTF.userInteractionEnabled = true;
        [emailCoachRankingView setHidden:true];
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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setiPhoneAndiPadUI];
    [self initializeUI];
}

-(void)didTapGoingBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        CGFloat height = 550;
        if (_navigationStatus == RegisterState_Update) {
            height = 600;
        }
        [[self.menuStackView.heightAnchor constraintEqualToConstant:height] setActive:true];
        
    } else {
        
        CGFloat height = 880;
        if (_navigationStatus == RegisterState_Update) {
            height = 960;
        }
        [[self.menuStackView.heightAnchor constraintEqualToConstant:height] setActive:true];
        [[self.zipFLTF.heightAnchor constraintEqualToConstant:88] setActive:true];
    }
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [SVProgressHUD showWithStatus:@"Registering..."];
    
    [API executeHTTPRequest:Post url:signUpURL parameters: paramDic CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        if ([responseDict[@"Result"] isEqualToString:@"success"]) {
            [Alert showAlert:@"please check your email to verify account" message:@"" viewController:self complete:^{
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            }];
        } else if ([responseDict[@"Result"] isEqualToString:@"fail"]) {
            NSString *msg = responseDict[@"Msg"];
            [Alert showAlert:msg message:@"" viewController:self];
        }
    } ErrorHandler:^(NSString *errorStr) {
        [SVProgressHUD dismiss];
    }];
}

- (void)fetchTeamDictionary: (Team *) team {
    
    [teamDictionary setValue:team.admin_pw forKey:@"admin_pw"];
    [teamDictionary setValue:team.contact_address forKey:@"contact_address"];
    [teamDictionary setValue:team.contact_city forKey:@"contact_city"];
    [teamDictionary setValue:team.contact_email forKey:@"contact_email"];
    [teamDictionary setValue:team.contact_name forKey:@"contact_name"];
    [teamDictionary setValue:team.contact_phone forKey:@"contact_phone"];
    [teamDictionary setValue:team.contact_state forKey:@"contact_state"];
    [teamDictionary setValue:team.contact_zip forKey:@"contact_zip"];
    [teamDictionary setValue:String(team.emailCoachRanking) forKey:@"emailCoachRanking"];
}

- (Team *) getTeamInfo {
    Team *team = [[Team alloc] init];
    
    team.admin_name = _nameFLTF.text;
    team.admin_pw = _passwordFLTF.text;
    team.contact_email = _emailFLTF.text;
    team.contact_name = _contactNameFLTF.text;
    team.contact_city = _cityFLTF.text;
    team.contact_state = _stateFLTF.text;
    team.contact_zip = _zipFLTF.text;
    team.contact_address = _addressFLTF.text;
    team.contact_phone = _contactPhone.text;
    team.emailCoachRanking = emailCoachRankingSwich.isOn == YES ? 1 : 0;
    
    return team;
}

- (void) resetGlobalInfo {
    Team *team = [self getTeamInfo];
    Global.objSignUp.adminPassword = team.admin_pw;
    Global.objSignUp.adminEmail = team.contact_email;
    Global.objSignUp.contactName = team.contact_name;
    Global.objSignUp.contactPhone = team.contact_phone;
    Global.objSignUp.address = team.contact_address;
    Global.objSignUp.city = team.contact_city;
    Global.objSignUp.state = team.contact_state;
    Global.objSignUp.zip = team.contact_zip;
    Global.objSignUp.emailCoachRanking = team.emailCoachRanking;
}

- (void) updateProfile {
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    NSDictionary *paramDic;
    NSString *url;
    
    Team *team = [self getTeamInfo];
    [self fetchTeamDictionary:team];
    
    if (![getUserLevel isEqualToString:@"3"]) {
        
        // maybe need it later key "Sport"
//        NSString *sport = [Sport getIDFromTitle:_sportDDTF.selectedItem sports:_sportArr];
        paramDic = @{  @"signup_mode": [NSString stringWithFormat:@"%ld", (long)_teamSC.selectedSegmentIndex],
                       @"admin_name": team.admin_name,
                       @"admin_pw": team.admin_pw,
                       @"contact_email": team.contact_email,
                       @"contact_name": team.contact_name,
                       @"contact_phone": team.contact_phone,
                       @"contact_address": team.contact_address,
                       @"contact_city": team.contact_city,
                       @"contact_state": team.contact_state,
                       @"contact_zip": team.contact_zip,
                       @"oldPass": @"",
                       @"PlayerID": Global.playerIDFinal,
                       @"emailCoachRanking": String(team.emailCoachRanking)
                       };
        
        
        url = [NSString stringWithFormat:newPlayerEdit, Global.teamSportID, Global.playerIDFinal];

    } else {
        paramDic = @{  @"PlayerID": Global.playerIDFinal,
                       @"admin_name": team.admin_name,
                       @"admin_pw": team.admin_pw,
                       @"contact_email": team.contact_email,
                       @"contact_name": team.contact_name,
                       @"contact_phone": team.contact_phone,
                       @"contact_address": team.contact_address,
                       @"contact_city": team.contact_city,
                       @"contact_state": team.contact_state,
                       @"contact_zip": team.contact_zip,
                       @"oldPass": @"",
                       @"emailCoachRanking": String(team.emailCoachRanking)
                       };
        url = [NSString stringWithFormat:editUserProfile, Global.teamSportID];
    }
    
    url = [NSString stringWithFormat:editUserProfile, Global.teamSportID];
    
    [SVProgressHUD showWithStatus:@"Updating..."];
    
    [API executeHTTPRequest:Post url:url parameters: paramDic CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        [self parseResponse:responseDict params:paramDic];
    } ErrorHandler:^(NSString *errorStr) {
        [SVProgressHUD dismiss];
        [Alert showAlert:@"Failed" message:@"Somthing went wrong.\nTry again later." viewController:self];
    }];

}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    if ([successResult isEqualToString:@"Success"]) {
        
        BOOL result = NO;
        for (int i = 0; i < Global.arrTeamsId.count; i++) {
            NSString *teamId = [[Global.arrTeamsId objectAtIndex:i] stringValue];
            NSDictionary *whereDictionary = @{@"TeamID": teamId};
            result = [SQLiteHelper updateInTable:@"TeamInfo" params:teamDictionary where:whereDictionary];
        }
        
        if (result) {
            [self resetGlobalInfo];
            [Alert showAlert:@"Success!" message:@"" viewController:self complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [Alert showAlert:@"Failed" message:@"Somthing went wrong.\nTry again later" viewController:self];
        }
        
    } else {
        [Alert showAlert:@"Failed" message:@"Somthing went wrong.\nTry again later" viewController:self];
    }
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
        
        int emailCoachRanking = Global.objSignUp.emailCoachRanking;
        [emailCoachRankingSwich setOn:emailCoachRanking == 1 ? YES : NO];
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
