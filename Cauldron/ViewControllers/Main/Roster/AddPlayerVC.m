//
//  AddPlayerVC.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AddPlayerVC.h"

@interface AddPlayerVC () <SHMultipleSelectDelegate, UITextFieldDelegate>
{
    NSMutableArray *selectedPositionArr;
    NSString *selectedPositionStr;
    BOOL isSelectedPhoto;
    NSString *base64;
}

@end

@implementation AddPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _gradeDDTF.itemList = @[@"-", @"3", @"4", @"5", @"6", @"7", @"8", @"Freshman", @"Sophomore", @"Junior", @"Senior", @"Graduated", @"Red-Shirt"];
    
    self.birthdayDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.birthdayDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    
    _graduationDateDDTF.dropDownMode = IQDropDownModeDatePicker;
    _graduationDateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    
    _userlevelTF.userInteractionEnabled = false;
    
    /* Initialize Varaibles */
    _positionArr = [[NSMutableArray alloc] init];
    selectedPositionArr = [[NSMutableArray alloc] init];
    isSelectedPhoto = false;

    
    [self setupNavigationItems];
    
    /* Init UI Component */
    
   
    
    // Get Position List From Server
    [API getPositionList:Global.currentTeamId SucceedHandler:^(NSArray *responseArr) {
        _positionArr = [NSMutableArray arrayWithArray:responseArr];
    } ErrorHandler:^(NSString *errorStr) {
        
    }];
    
    // Setting for update or new
    
    player = [[Player alloc] init];
    playerDictionary = [[NSMutableDictionary alloc] init];
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *teamName = Global.currntTeam.Team_Name;
    
    _usernameTF.delegate = self;
    
    if (self.navigationRosterStatus == RosterState_Add) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Add Player"];
    } else if (self.navigationRosterStatus == RosterState_Update) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Edit Player"];
    }
    
    

    if (self.isUpdate) {
        _rightBarButtonItem.title = @"Save";
        [self initUIWithPlayID];
    } else {
        _rightBarButtonItem.title = @"Add";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapAdd:(id)sender {
    if (![self checkValidation]) {
        return;
    }
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [self fetchPlayers];
    [self addPlayer];
}

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField == _usernameTF) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return nil;
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapPhoto:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePickerController setAllowsEditing:YES];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];

    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [imagePickerController setAllowsEditing:YES];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:cancelAction];
    
    [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = ((UIButton *)sender).bounds;
    
    [self presentViewController:actionSheet animated:true completion:nil];
}

- (IBAction)didTapPosition:(id)sender {
    
    if (_positionArr.count == 0) {
        [Alert showAlert:@"Add positions in team setting first." message:@"" viewController:self];
        return;
    }
    
    SHMultipleSelect *multipleSelect = [[SHMultipleSelect alloc] init];
    multipleSelect.delegate = self;
    multipleSelect.rowsCount = _positionArr.count;
    [multipleSelect show];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _photoImgView.image = image;
    isSelectedPhoto = true;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 200;
    }
    
    if (indexPath.section == 0 && indexPath.row == 10) {
        return 0;
    }
    
    if (indexPath.section == 0 && indexPath.row == 11) {
        return 100;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"contact";
    }
    
    return @"";
}

#pragma mark - SHMultipleSelectDelegate

- (void)multipleSelectView:(SHMultipleSelect*)multipleSelectView clickedBtnAtIndex:(NSInteger)clickedBtnIndex withSelectedIndexPaths:(NSArray *)selectedIndexPaths {
    if (clickedBtnIndex == 1) { // Done btn
        [selectedPositionArr removeAllObjects];
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            [selectedPositionArr addObject:_positionArr[indexPath.row]];
            NSLog(@"%@", _positionArr[indexPath.row]);
        }
        
        selectedPositionStr = [selectedPositionArr componentsJoinedByString:@","];
        _positionTF.text = selectedPositionStr;
    }
}

- (NSString*)multipleSelectView:(SHMultipleSelect*)multipleSelectView titleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return _positionArr[indexPath.row];
}

- (BOOL)multipleSelectView:(SHMultipleSelect*)multipleSelectView setSelectedForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString *str = _positionArr[indexPath.row];
    for (NSString *temp in selectedPositionArr) {
        if ([temp.lowercaseString isEqualToString:str.lowercaseString]) {
            return true;
        }
    }
    
    return false;
}

#pragma mark - Private Methods

- (BOOL)checkValidation {
    if (_lastNameTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"Last name is required" message:@"" viewController:self];
        return false;
    }
    if (_firstNameTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"First name is required" message:@"" viewController:self];
        return false;
    }
    
    if (_usernameTF.text.isZeroLengthWithoutTrimWhiteSpace) {
        [Alert showAlert:@"username is required" message:@"" viewController:self];
        return false;
    }

    if (selectedPositionStr == nil || [selectedPositionStr isEqualToString:@""]) {
        [Alert showAlert:@"At least have to select a position" message:nil viewController:self];
        return false;
    }
    return true;
    
    

}

- (void) fetchPlayers {
    
    player.jercyNo = self.jserseyTF.text == nil ? @"" : self.jserseyTF.text;
    player.FirstName = self.firstNameTF.text;
    player.LastName = self.lastNameTF.text;
    player.UserName = self.usernameTF.text;
    player.Password = self.passwordTF.text == nil ? [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] : self.passwordTF.text;
    player.UserLevel = 3;
    player.Notes = self.noteTV.text == nil ? @"" : self.noteTV.text;
    player.PEmail = self.emailTF.text == nil ? @"" : self.emailTF.text;
    player.DEmail = self.dadEmailTF.text == nil ? @"" : self.dadEmailTF.text;
    player.MEmail = self.momEmailTF.text == nil ? @"" : self.momEmailTF.text;
    player.Position = selectedPositionStr;
    player.Phone = self.contactNoTF.text == nil ? @"" : self.contactNoTF.text;
    player.Grade = self.gradeDDTF.selectedItem == nil? @"" : _gradeDDTF.selectedItem;
    player.BirthDate = _birthdayDDTF.isSelected ? [self.birthdayDDTF.date stringWithFormat:@"MM-dd-yyyy"] : @"";
    player.GraduationDate = self.graduationDateDDTF.isSelected ? [self.graduationDateDDTF.date stringWithFormat:@"MM-dd-yyyy"] : @"";
    
    player.EmailPRpt = self.emailSwitch.isOn ? 1: 0;
    player.EmailDRpt = self.dadEmailSwitch.isOn ? 1 : 0;
    player.EmailMRpt = self.momEmailSwitch.isOn ? 1 : 0;
    
    if (isSelectedPhoto) {
        //        NSString *base64;
        base64 = [UIImagePNGRepresentation(self.photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        player.Photo = base64;
    } else {
        
        if (self.navigationRosterStatus == RosterState_Update) {
            player.Photo = Global.currntTeam.Team_Picture;
        } else {
            UIImage *image = [UIImage imageNamed:@"avatar"];
            _photoImgView.image = image;
            base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            player.Photo = base64;
        }
    }
    
    
    [playerDictionary setValue:player.jercyNo forKey:@"Jersey"];
    [playerDictionary setValue:player.FirstName forKey:@"FirstName"];
    [playerDictionary setValue:player.LastName forKey:@"LastName"];
    [playerDictionary setValue:player.UserName forKey:@"UserName"];
    [playerDictionary setValue:player.Password forKey:@"Password"];
    [playerDictionary setValue:String(player.UserLevel) forKey:@"UserLevel"];
    [playerDictionary setValue:player.Notes forKey:@"Notes"];
    [playerDictionary setValue:player.PEmail forKey:@"PEmail"];
    [playerDictionary setValue:player.DEmail forKey:@"DEmail"];
    [playerDictionary setValue:player.MEmail forKey:@"MEmail"];
    [playerDictionary setValue:player.Position forKey:@"Position"];
    [playerDictionary setValue:player.Phone forKey:@"Phone1"];
    [playerDictionary setValue:player.Grade forKey:@"Grade"];
    [playerDictionary setValue:player.BirthDate forKey:@"BirthDate"];
    [playerDictionary setValue:player.GraduationDate forKey:@"GraduationDate"];
    [playerDictionary setValue:String(player.EmailPRpt) forKey:@"EmailPRpt"];
    [playerDictionary setValue:String(player.EmailDRpt) forKey:@"EmailDRpt"];
    [playerDictionary setValue:String(player.EmailMRpt) forKey:@"EmailMRpt"];
    [playerDictionary setValue:base64 forKey:@"Photo"];
    
}


- (void)addPlayer {
    
    if ([Global.teamName rangeOfString:@"Demo"].location != NSNotFound) {
        [Alert showAlert:@"Demo Team" message:@"Demo Team Can't Save or Edit Player" viewController:self];
        return;
    }
    
    if (self.isUpdate) {
        [ProgressHudHelper showLoadingHudWithText:@"Updating Player..."];
    } else {
        [ProgressHudHelper showLoadingHudWithText:@"Adding Player..."];
    }
    
    NSString *action;
    if (self.navigationRosterStatus == RosterState_Add) {
        action = @"ADD_ROSTER";
    } else if (self.navigationRosterStatus == RosterState_Update) {
        action = @"EDIT_ROSTER";
    }

    
    
    if (isSelectedPhoto) {
        base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    
    
    NSDictionary* params = @{@"action": action,
                             @"TeamID": [NSString stringWithFormat:@"%d", Global.currentTeamId],
                             @"PlayerID": [NSString stringWithFormat:@"%d", _playerID],
                             @"LastName": _lastNameTF.text,
                             @"FirstName": _firstNameTF.text,
                             @"Grade": _gradeDDTF.selectedItem == nil? @"" : _gradeDDTF.selectedItem,
                             @"Position": selectedPositionStr,
                             @"BirthDate": _birthdayDDTF.selectedItem == nil? @"" : _birthdayDDTF.selectedItem,
                             @"GraduationDate": _graduationDateDDTF.selectedItem == nil? @"" : _graduationDateDDTF.selectedItem,
                             @"PEmail": _emailTF.text == nil? @"" : _emailTF.text,
                             @"EmailPRpt": _emailSwitch.on == true ? @"1": @"0",
                             @"MEmail": _momEmailTF.text == nil? @"" : _momEmailTF.text,
                             @"EmailMRpt": _momEmailSwitch.on == true ? @"1": @"0",
                             @"DEmail": _dadEmailTF.text == nil? @"" : _dadEmailTF.text,
                             @"EmailDRpt": _dadEmailSwitch.on == true ? @"1": @"0",
                             @"Notes": _noteTV.text == nil? @"" : _noteTV.text,
                             @"UserName": _usernameTF.text == nil? @"" : _usernameTF.text,
                             @"Password": _passwordTF.text == nil? [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] : _passwordTF.text,
                             @"UserLevel": @"3",
                             @"Photo": base64 == nil? @"" : base64,
                             @"modified": @"xyz",
                             @"Jersey": _jserseyTF.text,
                             @"Phone1": _contactNoTF.text == nil ? @"" : _contactNoTF.text,
                             @"Sync": @"0"};
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLPlayer parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
}

- (void)parseResponse:(NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSString *successReult = [dic valueForKey:@"status"];
    NSString *playerId = [dic valueForKey:@"id"];
    if (![successReult isEqualToString:@"Successs"]) {
        if ([successReult isEqualToString:@"AlreadyExist"]) {
            [Alert showAlert:@"Username Already exist" message:@"Type another username!" viewController:self];
            self.usernameTF.text = @"";
            return;
        }
        [Alert showAlert:@"Failed to update user" message:nil viewController:self];
        return;
    }
    
    
    
    // Design Issue between server db and local db
    // Need to convert following items
    // Jersey => JourcyNo
    // phone1 => phone
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:playerDictionary];
    
    NSLog(@"player dict, %@", playerDictionary);
    NSLog(@"new dict, %@", dict);
    
//    [dict setObject: [dict objectForKey: @"Jersey"] forKey: @"JourcyNo"];
    [dict setValue:[dict valueForKey:@"Jersey"] forKey:@"JourcyNo"];
    
    [dict removeObjectForKey: @"Jersey"];
//    [dict setObject: [dict objectForKey: @"Phone1"] forKey: @"Phone"];
    [dict setValue:[dict valueForKey:@"Phone1"] forKey:@"Phone"];
    [dict removeObjectForKey: @"Phone1"];
    
    
    
    if ([successReult isEqualToString:@"Successs"]) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        
        if (!_isUpdate) {
            [dict setValue:String(Global.currntTeam.TeamID) forKey:@"TeamID"];
            [dict setValue:playerId forKey:@"PlayerID"];
            [dict setValue:String(0) forKey:@"Sync"];
            
            NSLog(@"newer dict, %@", dict);
            
            BOOL success = [SQLiteHelper insertInTable:@"PlayersInfo" params:dict];
            if (success) {
                [Alert showAlert:@"Player added successfully" message:nil viewController:self complete:^{
                    [self.navigationController popViewControllerAnimated:true];
                    [self.delegate didDisappear];
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to add the player in local" viewController:self];
            }
            
        } else {
            NSDictionary *whereDic = @{@"TeamID": String(Global.currntTeam.TeamID),
                                       @"PlayerID": String(_playerID)};
            BOOL success = [SQLiteHelper updateInTable:@"PlayersInfo" params:dict where:whereDic];
            if (success) {
                [Alert showAlert:@"Player Successfully updated" message:nil viewController:self complete:^{
                    [self.navigationController popViewControllerAnimated:true];
                    [self.delegate didDisappear];
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to update the player in local" viewController:self];
            }
        }
    }
}

- (void)initUIWithPlayID {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo where UserLevel=3 AND PlayerID= %d",_playerID];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    NSDictionary *playerDic = [teamStats objectAtIndex:0];
    
    // Set Photo
    NSData *decodedData = [[playerDic valueForKey:@"Photo"] base64Data];
    if (decodedData) {
        _photoImgView.image = [UIImage imageWithData:decodedData];
    }
    if (!_photoImgView.image) {
        _photoImgView.image = [UIImage imageNamed:@"avatar"];
    }
    
    _noteTV.text = [playerDic valueForKey:@"Notes"];
    _jserseyTF.text = [playerDic valueForKey:@"JourcyNo"];
    _firstNameTF.text= [playerDic valueForKey:@"FirstName"];
    _lastNameTF.text = [playerDic valueForKey:@"LastName"];
    _gradeDDTF.selectedItem = [playerDic valueForKey:@"Grade"];
    NSString *birthDate = [playerDic valueForKey:@"BirthDate"];
    
    NSLog(@"Birthdate, %@", birthDate);
    
    
    
    self.birthdayDDTF.date = [birthDate dateWithFormat:@"MM-dd-yyyy"];
    NSString *graduationDate = [playerDic valueForKey:@"GraduationDate"];
    self.graduationDateDDTF.date = [graduationDate dateWithFormat:@"MM-dd-yyyy"];
    
    _usernameTF.text = [playerDic valueForKey:@"UserName"];
    _passwordTF.text = [playerDic valueForKey:@"Password"];
    if (![playerDic[@"Grade"] isEqualToString:@""]) {
        _gradeDDTF.selectedItem = playerDic[@"Grade"];
    }

    // Contact Sections
    _contactNoTF.text = [playerDic valueForKey:@"Phone"];
    _emailTF.text = [playerDic valueForKey:@"PEmail"];
    _momEmailTF.text = [playerDic valueForKey:@"MEmail"];
    _dadEmailTF.text = [playerDic valueForKey:@"DEmail"];
    BOOL status = ([[playerDic valueForKey:@"EmailPRpt"] integerValue] == 1) ? true : false;
    [_emailSwitch setOn:status animated:false];
    status = ([[playerDic valueForKey:@"EmailMRpt"] integerValue] == 1) ? true : false;
    [_momEmailSwitch setOn:status animated:false];
    status = ([[playerDic valueForKey:@"EmailDRpt"] integerValue] == 1) ? true : false;
    [_dadEmailSwitch setOn:status animated:false];
    
    selectedPositionArr = (NSMutableArray *)[[playerDic valueForKey:@"Position"] componentsSeparatedByString:@","];
    selectedPositionStr = [selectedPositionArr componentsJoinedByString:@","];
    _positionTF.text = [playerDic valueForKey:@"Position"];
}

@end
