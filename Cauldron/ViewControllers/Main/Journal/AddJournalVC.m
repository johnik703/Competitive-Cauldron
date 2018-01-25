//
//  AddJournalVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AddJournalVC.h"
#import "UITextView+Placeholder.h"

@interface AddJournalVC ()
{
    NSMutableArray *playNameArr;
}
@end

@implementation AddJournalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    /* Fetch Data from local database and initialize variables */
    _allTeamPlayers = [[NSMutableArray alloc] init];
    playNameArr = [[NSMutableArray alloc] init];
    
    NSString *query1 = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE TeamID=%d AND UserLevel=%d ORDER BY LastName, FirstName ASC", Global.currntTeam.TeamID,3];
    NSArray *playersInfoArray = [SCSQLite selectRowSQL:query1];
    
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    
    if ([getUserLevel isEqualToString:@"3"]) {
        NSString *playerID = Global.playerIDFinal;
        for (int m = 0; m < [playersInfoArray count]; m++) {
            NSString *plrID = [NSString stringWithFormat:@"%@",[[playersInfoArray objectAtIndex:m]valueForKey:@"PlayerID"]];
            if ([plrID isEqualToString:playerID]) {
                NSString *playerLastName = [NSString stringWithFormat:@"%@",[[playersInfoArray objectAtIndex:m]valueForKey:@"LastName"]];
                NSString *playerFirstName = [NSString stringWithFormat:@"%@",[[playersInfoArray objectAtIndex:m]valueForKey:@"FirstName"]];
                NSString *playerFullName = [NSString stringWithFormat:@"%@ %@",playerLastName,playerFirstName];
                _playerNameDDTF.text = [NSString stringWithFormat:@"%@",playerFullName];
                _playerNameDDTF.dropDownMode = IQDropDownModeTextField;
                [_playerNameDDTF setUserInteractionEnabled:false];
                break;
            }
        }
    } else {
        for(int m=0; m<[playersInfoArray count]; m++) {
            NSString *playerLastName = [NSString stringWithFormat:@"%@",[[playersInfoArray objectAtIndex:m]valueForKey:@"LastName"]];
            NSString *playerFirstName = [NSString stringWithFormat:@"%@",[[playersInfoArray objectAtIndex:m]valueForKey:@"FirstName"]];
            NSString *playerFullName = [NSString stringWithFormat:@"%@ %@",playerLastName,playerFirstName];
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:playerFullName,@"name",[[playersInfoArray objectAtIndex:m]valueForKey:@"PlayerID"],@"playerID",nil];
            [_allTeamPlayers addObject:dic];
            [playNameArr addObject:playerFullName];
        }
    }
    
    // Initialize UI
    self.title = @"New Journal";
    self.journalTV.placeholderColor = HEXCOLOR(0x444444);
    self.journalTV.placeholder = @"Note";
    self.dateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.dateDDTF.date = [NSDate new];
    self.dateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.playerNameDDTF.itemList = playNameArr;
    
    if (_isUpdate) {
        _dateDDTF.date = [self.date dateWithFormat:@"MM-dd-yyyy"];
        _journalTV.text = _jornalData;
        
        // collect player name
        NSString *query1 = [NSString stringWithFormat:@"SELECT FirstName,LastName FROM PlayersInfo WHERE TeamID=%d AND PlayerID=%@ ", Global.currntTeam.TeamID, _playerName];
        NSArray *PlayersInfoArray12 = [SCSQLite selectRowSQL:query1];
        
        NSString *playerLastName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray12 objectAtIndex:0]valueForKey:@"LastName"]];
        NSString *playerFirstName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray12 objectAtIndex:0]valueForKey:@"FirstName"]];
        NSString *playerFullName = [NSString stringWithFormat:@"%@ %@",playerLastName,playerFirstName];
        _playerNameDDTF.selectedItem = playerFullName;
    }
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Add Journal"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
    [self save];
}



#pragma mark - Private Methods

- (void)save {
    
    if (![self checkValidation]) {
        return;
    }
    
    if (_isUpdate) {
        NSString *savedUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
        if ([savedUserID isEqualToString:@"3"]) {
            NSDictionary *paramsDic = @{@"notes": _journalTV.text,
                                        @"add_date": _dateDDTF.selectedItem,
                                        @"PlayerID": Global.playerIDFinal,
                                        @"sync": @"1"};
            NSDictionary *whereDic = @{@"id": String(_journalId)};
            BOOL success = [SQLiteHelper updateInTable:@"JournalData" params:paramsDic where:whereDic];
            if (success) {
                
                BOOL checkConnection = [RKCommon checkInternetConnection];
                if (!checkConnection) {
                    [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
                    return;
                    
                }
                SyncToServer  *syncToServer = [[SyncToServer alloc]init];
                syncToServer.delegate = self;
                [syncToServer startSyncJournalDataToServer];
            } else {
                [Alert showAlert:@"Something Wrong!" message:@"Try again later!" viewController:self];
            }
        } else {
            int plyrId = 0;
            for (int i = 0; i < [_allTeamPlayers count]; i++) {
                NSDictionary *temp = [_allTeamPlayers objectAtIndex:i];
                if ([_playerNameDDTF.selectedItem isEqualToString:[temp valueForKey:@"name"]]) {
                    plyrId = [[temp valueForKey:@"playerID"] intValue];
                }
            }
            NSDictionary *paramsDic = @{@"notes": _journalTV.text,
                                        @"add_date": _dateDDTF.selectedItem,
                                        @"PlayerID": Global.playerIDFinal,
                                        @"sync": @"1"};
            NSDictionary *whereDic = @{@"id": String(plyrId)};
            BOOL success = [SQLiteHelper updateInTable:@"JournalData" params:paramsDic where:whereDic];
            
            if (success) {
                if (success) {
                    BOOL checkConnection = [RKCommon checkInternetConnection];
                    if (!checkConnection) {
                        Global.syncCount++;
                        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
                        [Alert showAlert:@"Journal saved." message:@"You can sync later" viewController:self complete:^{
                            [self.navigationController popViewControllerAnimated:true];
                            
                        }];
                        
                    } else {
                        [ProgressHudHelper showLoadingHudWithText:@"Uploading Data..."];
                        SyncToServer  *syncToServer = [[SyncToServer alloc]init];
                        syncToServer.delegate = self;
                        [syncToServer startSyncJournalDataToServer];
                    }
                }

            } else {
                [Alert showAlert:@"Something Wrong!" message:@"Try again later!" viewController:self];
            }
        }
        
    } else {
        int playerIDNew;
        if (_allTeamPlayers.count > 0) {
            for (int i = 0; i < _allTeamPlayers.count; i++) {
                NSDictionary *temp = [_allTeamPlayers objectAtIndex:i];
                if ([_playerNameDDTF.selectedItem isEqualToString:[temp valueForKey:@"name"]]) {
                    playerIDNew = [[temp valueForKey:@"playerID"] intValue];
                }
            }
        } else {
            playerIDNew = [Global.playerIDFinal intValue];
        }
        
        [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
        NSDictionary *paramsDic = @{@"TeamID": String(Global.currntTeam.TeamID),
                                    @"PlayerID": String(playerIDNew),
                                    @"notes": _journalTV.text,
                                    @"add_date": _dateDDTF.selectedItem,
                                    @"sync": @"1"
                                    };
        BOOL success = [SQLiteHelper insertInTable:@"JournalData" params:paramsDic];
        if (success) {
            if (success) {
                BOOL checkConnection = [RKCommon checkInternetConnection];
                if (!checkConnection) {
                    Global.syncCount++;
                    [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
                    [Alert showAlert:@"Journal saved." message:@"You can sync later" viewController:self complete:^{
                        [self.navigationController popViewControllerAnimated:true];
                        
                    }];
                    
                } else {
                    [ProgressHudHelper showLoadingHudWithText:@"Uploading Data..."];
                    SyncToServer  *syncToServer = [[SyncToServer alloc]init];
                    syncToServer.delegate = self;
                    [syncToServer startSyncJournalDataToServer];
                }
            }

        } else {
            [Alert showAlert:@"Something Wrong!" message:@"Try again later!" viewController:self];
        }
    }
}

- (void) SyncToServerProcessCompleted {
    [ProgressHudHelper hideLoadingHud];
    [Alert showAlert:@"Success!" message:@"Journal saved." viewController:self complete:^{
        Global.syncCount -= 1;
        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
        [self.navigationController popViewControllerAnimated:true];
        [self.delegate didDisappear];
        
    }];
    
}


- (BOOL)checkValidation {

    if (Global.mode != USER_MODE_PLAYER) {
        if (_playerNameDDTF.selectedItem == nil) {
            [Alert showAlert:@"Please select player" message:nil viewController:self];
            return false;
        }
        
        if ([_playerNameDDTF.selectedItem isZeroLengthWithoutTrimWhiteSpace]) {
            [Alert showAlert:@"Please select player" message:nil viewController:self];
            return false;
        }
    }
    
    if (_dateDDTF.date == nil) {
        [Alert showAlert:@"Please select date" message:nil viewController:self];
        return false;
    }
    
    if ([self.journalTV.text isZeroLengthWithoutTrimWhiteSpace]) {
        [Alert showAlert:@"Please enter notes" message:nil viewController:self];
        return false;
    }
    
    return true;
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate didDisappear];
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
