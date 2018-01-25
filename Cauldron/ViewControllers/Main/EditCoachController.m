//
//  EditCoachController.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "EditCoachController.h"


@interface EditCoachController () <UITextFieldDelegate> {
    
    NSString *teams;
    
}

@end



@implementation EditCoachController
@synthesize contactNameTF, contactAddressTF, contactCityTF, contactStateTF, contactZipTF, contactPhoneTF, coachLoginNameTF, coachPasswordTF, coachEmailTF, emailCoachRankingSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    coachLoginNameTF.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self addMenuBarButtomItem];
    
    coachDictionary = [[NSMutableDictionary alloc] init];
    coach = [[Coach alloc] init];
    
    if (self.navigationCoachState == CoachState_Edit) {
        [self fetchEditCoachFromLocalDB];
    }
    
}

- (void)fetchEditCoachFromLocalDB {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM CoachesInfo where coachID= %d", coachID];
    NSArray *coaches = [SCSQLite selectRowSQL:query];
    NSDictionary *coachDic = [coaches objectAtIndex:0];
    
    contactNameTF.text = [coachDic valueForKey:@"contactName"];
    contactAddressTF.text = [coachDic valueForKey:@"contactAddress"];
    contactCityTF.text = [coachDic valueForKey:@"contactCity"];
    contactStateTF.text = [coachDic valueForKey:@"contactState"];
    contactZipTF.text = [coachDic valueForKey:@"contactZip"];
    contactPhoneTF.text = [coachDic valueForKey:@"contactPhone"];
    coachLoginNameTF.text = [coachDic valueForKey:@"coachLoginName"];
    coachPasswordTF.text = [coachDic valueForKey:@"coachPassword"];
    coachEmailTF.text = [coachDic valueForKey:@"coachEmail"];
    teams = [coachDic valueForKey:@"teams"];
    [emailCoachRankingSwitch setOn:[[coachDic valueForKey:@"emailCoachRanking"] integerValue] == 1 ? true : false];
}

- (void)didTapSave {

    if (![self checkValidation]) {
        return;
    }
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [Alert showOKCancelAlert:@"Are you sure?" message:@"" viewController:self complete:^{
        [ProgressHudHelper showLoadingHudWithText:@"Wait..."];
        [self fetchCurrentCoachData];
        [self createCoach];
    } canceled:^{
        NSLog(@"canceled");
    }];

    
}

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField == coachLoginNameTF) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return nil;
}


- (void)fetchCurrentCoachData {
    
    
    
    coach.contactName = self.contactNameTF.text;
    coach.contactAddress = self.contactAddressTF.text;
    coach.contactCity = self.contactCityTF.text;
    coach.contactState = self.contactStateTF.text;
    coach.contactZip = self.contactZipTF.text;
    coach.contactPhone = self.contactPhoneTF.text;
    coach.coachLoginName = self.coachLoginNameTF.text;
    coach.coachPassword = self.coachPasswordTF.text;
    coach.coachEmail = self.coachEmailTF.text;
    coach.emailCoachRanking = 1;
    
    
    [coachDictionary setValue:coach.contactName                        forKey:@"contactName"];
    [coachDictionary setValue:coach.contactAddress                         forKey:@"contactAddress"];
    [coachDictionary setValue:coach.contactCity                       forKey:@"contactCity"];
    [coachDictionary setValue:coach.contactState                         forKey:@"contactState"];
    [coachDictionary setValue:coach.contactZip                  forKey:@"contactZip"];
    [coachDictionary setValue:coach.contactPhone                      forKey:@"contactPhone"];
    [coachDictionary setValue:coach.coachLoginName                forKey:@"coachLoginName"];
    [coachDictionary setValue:coach.coachPassword               forKey:@"coachPassword"];
    [coachDictionary setValue:coach.coachEmail                  forKey:@"coachEmail"];
    [coachDictionary setValue:String(coach.emailCoachRanking)                 forKey:@"emailCoachRanking"];
    
    if (self.navigationCoachState == CoachState_Add) {
        teams = String(Global.currntTeam.TeamID);
    }
    
    [coachDictionary setValue:teams forKey:@"teams"];
}

-(void) createCoach {
    
    NSString *action;
    int mCoachID;
    if (self.navigationCoachState == CoachState_Add) {
        action = @"ADD_COACH";
        mCoachID = 0;
        
    } else {
        action = @"EDIT_COACH";
        mCoachID = coachID;
    }
    
    NSDictionary* params = @{@"PlayerID": Global.playerIDFinal,
                             @"coachID": String(mCoachID),
                             @"Sports": Global.currntTeam.Sport,
                             @"action": action,
                             @"TeamID": String(Global.currntTeam.TeamID),
                             @"contactName": self.contactNameTF.text,
                             @"contactAddress": self.contactAddressTF.text,
                             @"contactCity": self.contactCityTF.text,
                             @"contactState": self.contactStateTF.text,
                             @"contactZip": self.contactZipTF.text,
                             @"contactPhone": self.contactPhoneTF.text,
                             @"coachLoginName": self.coachLoginNameTF.text,
                             @"coachPassword": self.coachPasswordTF.text,
                             @"coachEmail": self.coachEmailTF.text,
                             @"emailCoachRanking": String(1),
                             @"teams": teams
                             };
    
    
    NSLog(@"PlayerId-----%@", Global.playerIDFinal);
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageCoach parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"request ---%@", Post);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    NSLog(@"responseCoach, %@", dic);
    NSString *successResult = [dic valueForKey:@"status"];
    NSString *coachId = [dic valueForKey:@"id"];
    int parentId = (int)[[dic valueForKey:@"parentID"] intValue];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    NSLog(@"teamId if recieve data from server-----%@", coachId);
    NSLog(@"parentId if recieve data from server-----%d", parentId);
    
    if ([successResult isEqualToString:@"Successs"]) {
        
        if (self.navigationCoachState == CoachState_Add) {
            
            NSMutableDictionary *createCoachDictionary = [NSMutableDictionary dictionaryWithDictionary:coachDictionary];
            
            [createCoachDictionary setValue:Global.playerIDFinal     forKey:@"PlayerID"];
            [createCoachDictionary setValue:coachId    forKey:@"coachID"];
            NSLog(@"created team dictionary---%@", createCoachDictionary);
            
            BOOL success = [SQLiteHelper insertInTable:@"CoachesInfo" params:createCoachDictionary];
            if (success) {
                
                [Alert showAlert:@"Coach added successfully!" message:nil viewController:self complete:^{
                    [self.navigationController popViewControllerAnimated:true];
                }];
                
            } else {
                [Alert showAlert:@"Error" message:@"Failed to add Coach in local" viewController:self];
            }
            
        } else {
            NSDictionary *whereDic = @{@"PlayerID": Global.playerIDFinal, @"coachID": String(coachID)};
            
            BOOL success = [SQLiteHelper updateInTable:@"CoachesInfo" params:coachDictionary where:whereDic];
            if (success) {
                
                [Alert showAlert:@"Coach successfully updated" message:nil viewController:self complete:^{
                    [self.navigationController popViewControllerAnimated:true];
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to update Coach in local" viewController:self];
            }
        }
    } else if ([successResult isEqualToString:@"AlreadyExistMail"]) {
        
        [Alert showAlert:@"Email Already Exist!" message:@"Failed to create or update Coach" viewController:self];
        
        
    } else if ([successResult isEqualToString:@"AlreadyExist"]) {
        
        [Alert showAlert:@"Login Name Already Exist!" message:@"Failed to create or update Coach" viewController:self];
        
        
    } else {
        
        if (self.navigationCoachState == CoachState_Add) {
            [Alert showAlert:@"Failed to Add Coach" message:nil viewController:self];
            return;
            
        } else if (self.navigationCoachState == CoachState_Edit) {
            [Alert showAlert:@"Failed to Edit Coach" message:nil viewController:self];
            return;
        }
    }

    
    
}



- (void)addMenuBarButtomItem {
    NSString *teamName = Global.currntTeam.Team_Name;
    
    if (self.navigationCoachState == CoachState_Add) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Add Coach"];
    } else if (self.navigationCoachState == CoachState_Edit) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Edit Coach"];
    }
    
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSave)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_PLAYER || Global.mode == USER_MODE_COACH) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}


- (BOOL) checkValidation {
    if (self.contactNameTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Contact name is required" message:@"" viewController:self];
        return false;
    }
    if (self.contactAddressTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Address is required" message:@"" viewController:self];
        return false;
    }
    if (self.contactCityTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"City is required" message:@"" viewController:self];
        return false;
    }
    if (self.contactStateTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"State is required" message:@"" viewController:self];
        return false;
    }
    if (self.contactZipTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Zip is required" message:@"" viewController:self];
        return false;
    }
    if (self.contactPhoneTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Phone is required" message:@"" viewController:self];
        return false;
    }
    if (self.coachLoginNameTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Login Name is required" message:@"" viewController:self];
        return false;
    }
    if (!self.coachEmailTF.text.isValidEmail) {
        [Alert showAlert:@"Please enter valid email address" message:@"" viewController:self];
        return false;
    }
    if (![self.coachPasswordTF.text isUpperLowerDigitalPassword:6]) {
        [Alert showAlert:@"Error" message:@"Password at least has one lower case letter, one upper case letter, one digit and 6 characters." viewController:self];
        return false;
    }
    
    
    
    return true;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

@end
