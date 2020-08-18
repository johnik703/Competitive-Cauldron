//
//  EditChaListTabViewController.m
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "EditChaListTabViewController.h"
#import "ChallengeListViewController.h"
#import "CustomTypeController.h"
@import SVProgressHUD;

@interface EditChaListTabViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, IQDropDownTextFieldDelegate>
{
    BOOL isSelectedPhoto;
    
    
    
    NSString *base64;
    
    int isAvgFetch;
    NSString *rOrderFetch;
    NSString *fieldsFetch;
    NSString *rankFormulaFetch;
    
    
    NSString *str_challengMenu;
    NSString *str_challengeText1;
    NSString *str_challengeText2;
    NSString *str_challengeText3;
    NSString *str_description;
}
@end

@implementation EditChaListTabViewController

@synthesize addPictureButton, photoImgView, displayHomepageSwitch, rankCountTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addMenuLeftBarButtomItem];
    
//    [self.descriptionText setEditable:false];
    
    ChallengeSubcategoryDictionary = [[NSMutableDictionary alloc] init];
    challengeSubcategory = [[Challenge alloc] init];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setupAllUIs];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)goingBackChallengeList {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}



-(void)setupAllUIs{
    
    isAvgFetch = 0;
    rOrderFetch = @"";
    fieldsFetch = @"";
    rankFormulaFetch = @"";

    
    self.list_challengeCategory.delegate = self;
    self.list_challengeType.delegate = self;
    self.list_challengeMultiplier.delegate = self;
    self.list_FitnessStandard.delegate = self;
    rankCountTextField.isOptionalDropDown = NO;
    rankCountTextField.delegate = self;
    
    _list_challengeMultiplier.itemList = @[@"1",@"2",@"3",@"4",@"5"];
    rankCountTextField.itemList = @[@"3", @"4", @"5"];
    
    self.descriptionText.text = @"";
    
    
    NSMutableArray *categoryItemList = [[NSMutableArray alloc] init];
    for (int i = 0; i < Global.currendCategoryArr.count; i++) {
        
        [categoryItemList addObject:Global.currendCategoryArr[i][@"CategoryName"]];
        
    }
    
    _list_challengeCategory.itemList   = categoryItemList;
    
    
    _list_challengeType.itemList       = @[@"%", @"WLT", @"# - Lower Better", @"# - Higher Better", @"Exception"];
    
    if (self.navigationChallengeStatus == ChallengeListState_Add) {
        
        fitnessHeight = 0;
        addFieldHeight = 0;
        rankCountCellHeight = 0;
        [displayHomepageSwitch setOn:NO];
        [self.tableView reloadData];
        self.addCustomTypeLabel.text = @"Create Structure";
        [addPictureButton setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
        
    } else {
        
        self.addCustomTypeLabel.text = @"Edit Structure";
        
        [self fetchChallengeList];
        
        if (self.navigationFitnessStatus == ChallengeFitnessState_NOT) {
            fitnessHeight = 0;
            [self.tableView reloadData];
        } else {
            fitnessHeight = 50;
            [self.tableView reloadData];

        }
    }
    
}

- (NSString *)returnChallengeTypeWithLocalData:(NSString *) challenge {
    NSString *challengeType = challenge;
    if ([challengeType isEqualToString:@"pcnt"]) {
        challengeType = @"%";
    }
    return challengeType;
}

- (void)fetchChallengeList {
    
    NSLog(@"test global change, %@", Global.currentChallenge);
    
    self.txt_challengeMenu.text = [Global.currentChallenge objectForKey:@"Challenge_Menu"];
    
    
    self.txt_challengeText1.text = [Global.currentChallenge objectForKey:@"Challenge_Text1"];
    self.txt_challengeText2.text = [Global.currentChallenge objectForKey:@"Challenge_Text2"];
    self.txt_challengeText3.text = [Global.currentChallenge objectForKey:@"Challenge_Text3"];
    
    self.list_challengeMultiplier.selectedItem = [[Global.currentChallenge objectForKey:@"Challenge_Multiplier"] stringValue];
    
    self.list_challengeType.selectedItem = [self returnChallengeTypeWithLocalData: [Global.currentChallenge objectForKey:@"Challenge_Type"]];
    self.list_challengeCategory.selectedItem = self.selectedCategory;
    
    
    
    self.list_FitnessStandard.text= [Global.currentChallenge objectForKey:@"standard0"];
    
    
    [self.switch_includeFitnessRpt setOn:(int)[[Global.currentChallenge objectForKey:@"Fitness_Rpt"] intValue] == 1 ? true : false];
    [self.switch_enabledChallenge setOn:(int)[[Global.currentChallenge objectForKey:@"Enable"] intValue] == 1 ? true : false];
    [self.switch_excludeFromFinalRpt setOn:(int)[[Global.currentChallenge objectForKey:@"Challenge_Exclude"] intValue] == 1 ? true : false];
    [self.switch_includeTopPerformerReport setOn:(int)[[Global.currentChallenge objectForKey:@"topPerformer"] intValue] == 1 ? true : false];
    
    int displayHomePage = (int)[[Global.currentChallenge objectForKey:@"isHome"] intValue];
    [self.displayHomepageSwitch setOn:displayHomePage == 1 ? true : false];
    
    if (displayHomePage == 1) {
        rankCountCellHeight = 50;
        
        int rankCount = (int)[[Global.currentChallenge objectForKey:@"playerCount"] integerValue];
        rankCountTextField.selectedItem = String(rankCount);
        
    } else {
        rankCountCellHeight = 0;
    }
    
    if ([self.list_challengeType.selectedItem isEqualToString:@"%"]) {
        showTiesHeight = 0;
        addFieldHeight = 0;
    } else if ([self.list_challengeType.selectedItem isEqualToString:@"WLT"]) {
        showTiesHeight = 50;
        addFieldHeight = 0;
        self.showTiesLabel.text = @"Show Ties";
        [self.showTiesSwitch setOn:(int)[[Global.currentChallenge objectForKey:@"Show_Ties"] intValue] == 1 ? true : false];

    } else if ([self.list_challengeType.selectedItem isEqualToString:@"Exception"]){
        showTiesHeight = 50;
        addFieldHeight = 50;
        self.showTiesLabel.text = @"Display decimal";
        
        [self.showTiesSwitch setOn:(int)[[Global.currentChallenge objectForKey:@"isDecimal"] intValue] == 1 ? true : false];

    } else if ([self.list_challengeType.selectedItem isEqualToString:@"# - Lower Better"] || [self.list_challengeType.selectedItem isEqualToString:@"# - Higher Better"]) {
        showTiesHeight = 50;
        addFieldHeight = 0;
        self.showTiesLabel.text = @"Display decimal";
        
        [self.showTiesSwitch setOn:(int)[[Global.currentChallenge objectForKey:@"isDecimal"] intValue] == 1 ? true : false];
    }
    
    NSString *description = [Global.currentChallenge objectForKey:@"Challenge_Desc"];
    
    NSString *desc1 = [description kv_decodeHTMLCharacterEntities];
    self.descriptionText.text = [self convertHTML:desc1];
    
    NSString *chanllengeImageString = [Global.currentChallenge objectForKey:@"ChallagePic"];
    if ([chanllengeImageString length] > 0) {
        
        [addPictureButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        
        if ([chanllengeImageString containsString:@".png"] || [chanllengeImageString containsString:@".jpeg"] || [chanllengeImageString containsString:@".jpg"]) {
            int chalngID = (int)[[Global.currentChallenge objectForKey:@"ID"] integerValue];
            
            NSLog(@"listchallengeid, %d", chalngID);
            
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallengeImage WHERE ChallangeID=%d",chalngID];
            
            NSArray *imageDataArr = [SCSQLite selectRowSQL:query];
            
            if (imageDataArr.count > 0) {
                NSString *base64String = [[imageDataArr objectAtIndex:0] valueForKey:@"imgData"];
                
                NSLog(@"imageTest--%@", base64String);
                
                
                if ([base64String isEqualToString:@"No Image"]) {
                    //set default image
                    
                    self.photoImgView.image = nil;
                } else {
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",base64String]];
                    self.photoImgView.image = image;
                }
            }
        } else {
            self.photoImgView.image = [UIImage imageWithData:[chanllengeImageString base64Data]];
        }
        
    } else {
        
        [addPictureButton setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
        
        //fetch challenge original image
         
    }
    
    [self.tableView reloadData];
}

-(NSAttributedString *)convertToAttributedStringFrom: (NSString *)html {
    
    html = [html stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                              @"",
                                              17.0]];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                        documentAttributes:nil
                                                                                     error:nil];
    return attributedString;
}

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(int)returnMultiplierWithGlobal:(NSString *) multiplier {
    
    NSLog(@"multi, %@", multiplier);
    
    if ([multiplier isEqualToString:@"1"]) {
        return 1;
    } else if ([multiplier isEqualToString:@"2"]) {
        return 2;
    } else if ([multiplier isEqualToString:@"3"]) {
        return 3;
    } else if ([multiplier isEqualToString:@"4"]) {
        return 4;
    } else if ([multiplier isEqualToString:@"5"]) {
        return 5;
    }
    
    return 0;
}

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    
    if ([self.list_challengeCategory.selectedItem  isEqual: @"Fitness"]) {
        fitnessHeight = 50;
    } else {
        fitnessHeight = 0;
    }
    
    if ([self.list_challengeType.selectedItem isEqualToString:@"%"]) {
        addFieldHeight = 0;
        showTiesHeight = 0;
    } else if ([self.list_challengeType.selectedItem isEqualToString:@"WLT"]) {
        addFieldHeight = 0;
        showTiesHeight = 50;
        self.showTiesLabel.text = @"Show Ties";
    } else if ([self.list_challengeType.selectedItem isEqualToString:@"Exception"]){
        showTiesHeight = 50;
        addFieldHeight = 50;
        self.showTiesLabel.text = @"Display decimal";
    } else if ([self.list_challengeType.selectedItem isEqualToString:@"# - Lower Better"] || [self.list_challengeType.selectedItem isEqualToString:@"# - Higher Better"]) {
        showTiesHeight = 50;
        addFieldHeight = 0;
        self.showTiesLabel.text = @"Display decimal";
    }
    
    for (int i = 0; i < Global.currendCategoryArr.count; i++) {
        
        if ([self.list_challengeCategory.selectedItem isEqualToString:Global.currendCategoryArr[i][@"CategoryName"]]) {
            
            challengeSubcategory.Challenge_Category = (int)[Global.currendCategoryArr[i][@"CatID"] integerValue];
            NSLog(@"selectedCatId, %d", challengeSubcategory.Challenge_Category);
            
        }
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)addCustomTypeField:(UIButton *)sender {
    
    CustomTypeController *addCustomTypeContrller = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTypeController"];
    
    if (self.navigationChallengeStatus == ChallengeListState_Add) {
        addCustomTypeContrller.navigationCustomStatus = CustomChallengeState_Add;
    } else if (self.navigationChallengeStatus == ChallengeListState_Edit){
        addCustomTypeContrller.navigationCustomStatus = CustomChallengeState_Edit;
    }
    
    addCustomTypeContrller->editChaListController = self;
    
    [self.navigationController pushViewController:addCustomTypeContrller animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapSave:(id)sender {
    
    NSLog(@"master teamId, %d", Global.masterTeamId);
    
    [self.view endEditing:YES];
    
    if (Global.currntTeam.TeamID == Global.masterTeamId) {
        if (![self checkValidation]) {
            return;
        }
        
        BOOL checkConnection = [RKCommon checkInternetConnection];
        if (!checkConnection) {
            [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"Wait Please..."];
        
        [self fetchChallengeSubcategories];
        [self createChallengeSubcategories];
        
    } else {
        [Alert showAlert:@"" message:@"You do not have permission.\nCan only be edited from Master Team account." viewController:self];
    }
}

- (void)recieveCustomDataFromCustomTypeController:(int)isAvg castOrder:(NSString *)rOrder fieldsName:(NSString *)fields rankFormula:(NSString *)rankFormula {
    
    isAvgFetch = isAvg;
    rOrderFetch = rOrder;
    fieldsFetch = fields;
    rankFormulaFetch = rankFormula;
    
    NSLog(@"driveMad, %d  (%@)  %@   %@ ", isAvgFetch, rOrderFetch, fieldsFetch, rankFormulaFetch);
    
}

- (NSString *)returnChallengeTypeWithSelectedField:(NSString *) challenge {
    NSString *challengeType = challenge;
    if ([challengeType isEqualToString:@"%"]) {
        challengeType = @"pcnt";
    }
    return challengeType;
}


- (void) fetchChallengeSubcategories {
    
    challengeSubcategory.Challenge_Name = @"";
    
    challengeSubcategory.Challenge_Menu = self.txt_challengeMenu.text;
    challengeSubcategory.Challenge_Text1 = self.txt_challengeText1.text;
    challengeSubcategory.Challenge_Text2 = self.txt_challengeText2.text;
    challengeSubcategory.Challenge_Text3 = self.txt_challengeText3.text;
    
    if (self.photoImgView.image == nil) {
        challengeSubcategory.Challenge_Pic = @"";
    } else {
        base64 = [UIImagePNGRepresentation(self.photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        challengeSubcategory.Challenge_Pic = base64;
    }
    
    
    challengeSubcategory.Challenge_Multiplier = (int)[self.list_challengeMultiplier.selectedItem intValue];
    challengeSubcategory.Challenge_Type = [self returnChallengeTypeWithSelectedField: self.list_challengeType.selectedItem];
    
    if ([self.list_challengeType.selectedItem isEqualToString:@"%"]) {
        challengeSubcategory.isDecimal = 0;
        challengeSubcategory.Show_Ties = 0;
    } else if ([self.list_challengeType.selectedItem isEqualToString:@"WLT"]) {
        challengeSubcategory.isDecimal = 0;
        challengeSubcategory.Show_Ties = self.showTiesSwitch.isOn == true ? 1 : 0;
    } else {
        challengeSubcategory.isDecimal = self.showTiesSwitch.isOn == true ? 1 : 0 ;
        challengeSubcategory.Show_Ties = 0;
    }
    
    for (int i = 0; i < Global.currendCategoryArr.count; i++) {
        
        if ([self.list_challengeCategory.selectedItem isEqualToString:Global.currendCategoryArr[i][@"CategoryName"]]) {
            
            challengeSubcategory.Challenge_Category = (int)[Global.currendCategoryArr[i][@"CatID"] integerValue];
            NSLog(@"selectedCatId, %d", challengeSubcategory.Challenge_Category);
        }
    }
    
    if ([self.list_challengeCategory.selectedItem  isEqual: @"Fitness"]) {
        challengeSubcategory.standard0 = self.list_FitnessStandard.text == nil ? @"" : self.list_FitnessStandard.text;
        challengeSubcategory.Challenge_Fitness_Include = self.switch_includeFitnessRpt.isOn == true ? 1 : 0;
    } else {
        challengeSubcategory.standard0 = @"";
        challengeSubcategory.Challenge_Fitness_Include = 0;
    }
    
    NSLog(@"driveMad1, %d  (%@)  %@   %@ ", isAvgFetch, rOrderFetch, fieldsFetch, rankFormulaFetch);
    
    challengeSubcategory.isAvg = isAvgFetch;
    challengeSubcategory.Rorder = rOrderFetch;
    challengeSubcategory.fields = fieldsFetch;
    challengeSubcategory.RankFormula = rankFormulaFetch;
    
    NSLog(@"driveMad2, %d  (%@)  %@   %@ ", challengeSubcategory.isAvg, challengeSubcategory.Rorder, challengeSubcategory.fields, challengeSubcategory.RankFormula);
    
    challengeSubcategory.Challenge_Fitness_Include = self.switch_includeFitnessRpt.isOn == true ? 1 : 0;
    
    challengeSubcategory.Challenge_Exclude = self.switch_excludeFromFinalRpt.isOn == true ? 1 : 0;
    challengeSubcategory.playersCount = (int)self.list_RankCount.selectedItem;
    challengeSubcategory.Enabled = self.switch_enabledChallenge.isOn == true ? 1 : 0;
    challengeSubcategory.isHome = self.switch_continueAdding.isOn == true ? 1 : 0;
    challengeSubcategory.Challenge_Desc = self.descriptionText.text;
    ;
    challengeSubcategory.topPerformer = self.switch_includeTopPerformerReport.isOn == true ? 1 : 0;
    
    challengeSubcategory.isHome = displayHomepageSwitch.isOn == true ? 1 : 0;
    
    NSString *rankCount = @"0";
    if (challengeSubcategory.isHome == 1) {
        rankCount = rankCountTextField.selectedItem;
    }
    challengeSubcategory.playersCount = (int)[rankCount integerValue];
    
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Menu forKey:@"Challenge_Menu"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Text1 forKey:@"Challenge_Text1"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Text2 forKey:@"Challenge_Text2"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Text3 forKey:@"Challenge_Text3"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Pic forKey:@"ChallagePic"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.standard0 forKey:@"standard0"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Challenge_Multiplier) forKey:@"Challenge_Multiplier"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Type forKey:@"Challenge_Type"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Challenge_Category) forKey:@"Challenge_Category"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Challenge_Exclude) forKey:@"Challenge_Exclude"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Challenge_Fitness_Include) forKey:@"Fitness_Rpt"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.isDecimal) forKey:@"isDecimal"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.topPerformer) forKey:@"topPerformer"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Enabled) forKey:@"Enable"];
//    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.isAdding) forKey:@"isHome"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.Show_Ties) forKey:@"Show_Ties"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Challenge_Desc forKey:@"Challenge_Desc"];
    
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.isAvg) forKey:@"isAvg"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.Rorder forKey:@"Rorder"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.fields forKey:@"fields"];
    [ChallengeSubcategoryDictionary setValue:challengeSubcategory.RankFormula forKey:@"RankFormula"];
    [ChallengeSubcategoryDictionary setValue:String(challengeSubcategory.isHome) forKey:@"isHome"];
    [ChallengeSubcategoryDictionary setValue:rankCount forKey:@"playerCount"];
    
    
    
    
    
}

- (void) createChallengeSubcategories {
    
//    if (isSelectedPhoto) {
//        //        NSString *base64;
//        base64 = [UIImagePNGRepresentation(self.photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    } else {
//        
//        if (self.navigationChallengeStatus == ChallengeListState_Edit) {
//            base64 = Global.currntTeam.Team_Picture;
//        } else {
//            UIImage *image = [UIImage imageNamed:@"default_team_image.jpeg"];
//            _photoImgView.image = image;
//            base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        }
//    }
    
    base64 = challengeSubcategory.Challenge_Pic;
    

    NSString *action;
    int wlt;
    NSString *show_Ties;
    NSString *isDecimal;
    int Id;
    NSString *standard0;
    NSString *challengeName;
    if (self.navigationChallengeStatus == ChallengeListState_Add) {
        action = @"ADD_CHALLENGE";
        Id = 0;
        wlt = 0;
        isDecimal = @"0";
        standard0 = @"";
        show_Ties = @"0";
        challengeName = @"";
    } else {
        action = @"EDIT_CHALLENGE";
        Id = (int)[[Global.currentChallenge objectForKey:@"ID"] integerValue];
        wlt = (int)[Global.currentChallenge objectForKey:@"WLT"];
        isDecimal = @"1";
        standard0 = @"234";
        show_Ties = @"1";
        challengeName = [Global.currentChallenge objectForKey:@"Challenge_Name"];
    }
    
    NSDictionary* params = @{@"action": action,
                             @"TeamID": String(Global.currntTeam.TeamID),
                             @"ID": String(Id),
                             @"Challenge_Name": challengeName,
                             @"Challenge_Menu": self.txt_challengeMenu.text,
                             @"Challenge_Text1": self.txt_challengeText1.text,
                             @"Challenge_Text2": self.txt_challengeText2.text == nil ? @"" : self.txt_challengeText2.text,
                             @"Challenge_Text3": self.txt_challengeText3.text == nil ? @"" : self.txt_challengeText3.text,
                             @"Challenge_Multiplier": String(challengeSubcategory.Challenge_Multiplier),
                             @"Challenge_Type": challengeSubcategory.Challenge_Type,
                             @"Challenge_Exclude": String(self.switch_excludeFromFinalRpt.isOn == true ? 1 : 0),
                             @"Challenge_Category": String(challengeSubcategory.Challenge_Category),
                             @"Challenge_Desc": challengeSubcategory.Challenge_Desc,
                             @"WLT": String(wlt),
                             @"Show_Ties": String(challengeSubcategory.Show_Ties),
                             @"Enabled": String(self.switch_enabledChallenge.isOn == true ? 1 : 0),
                             @"isDecimal": String(challengeSubcategory.isDecimal),
                             @"Challenge_Pic": base64,
                             @"isHome": String(challengeSubcategory.isHome),
                             @"playerCount": String(challengeSubcategory.playersCount),
                             @"topPerformer": String(challengeSubcategory.topPerformer),
                             @"standard0": challengeSubcategory.standard0,
                             @"isAvg": String(challengeSubcategory.isAvg),
                             @"fields": challengeSubcategory.fields,
                             @"stats_exist": String(0),
                             @"Rorder": challengeSubcategory.Rorder,
                             @"RankFormula": challengeSubcategory.RankFormula,
                             @"Fitness_Rpt": String(challengeSubcategory.Challenge_Fitness_Include)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageChallenge parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [SVProgressHUD dismiss];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSString *successResult = [dic valueForKey:@"status"];
    NSString *challengeId = [dic valueForKey:@"id"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    NSLog(@"categoryId if recieve data from server-----%@", challengeId);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        if (self.navigationChallengeStatus == ChallengeListState_Add) {
            
            NSMutableDictionary *createChallengeSubcategoryDictionary = [NSMutableDictionary dictionaryWithDictionary:ChallengeSubcategoryDictionary];
            
            [createChallengeSubcategoryDictionary setValue:String(Global.currntTeam.TeamID)     forKey:@"TeamID"];
            [createChallengeSubcategoryDictionary setValue:String(0)    forKey:@"Sync"];
            [createChallengeSubcategoryDictionary setValue:challengeId    forKey:@"ID"];
            NSLog(@"created team dictionary---%@", createChallengeSubcategoryDictionary);
            
            BOOL success = [SQLiteHelper insertInTable:@"Challanges" params:createChallengeSubcategoryDictionary];
            if (success) {
                
                [Alert showAlert:@"Challenge added successfully!" message:nil viewController:self complete:^{
                    [self dismissViewController];
                }];
                
            } else {
                [Alert showAlert:@"Error" message:@"Failed to add Challenge in local" viewController:self];
            }
            
        } else {
            NSDictionary *whereDic = @{@"TeamID": String(Global.currntTeam.TeamID), @"ID": [Global.currentChallenge objectForKey:@"ID"]};
            
            NSLog(@"updated team dictionary---%@", challengeSubcategory);
            
            BOOL success = [SQLiteHelper updateInTable:@"Challanges" params:ChallengeSubcategoryDictionary where:whereDic];
            if (success) {
                
                [Alert showAlert:@"Challenge successfully updated" message:nil viewController:self complete:^{
                    [self dismissViewController];
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to update Challenge in local" viewController:self];
            }
        }
    } else {
        
        if (self.navigationChallengeStatus == CategoryState_Add) {
            [Alert showAlert:@"Failed to Add Challenge" message:nil viewController:self];
            return;
            
        } else if (self.navigationChallengeStatus == CategoryState_Edit) {
            [Alert showAlert:@"Failed to Edit Challenge" message:nil viewController:self];
            return;
        }
    }
}

- (IBAction)didTapPhoto:(id)sender {
    
    
    UIImage *addPictureImage = [UIImage imageNamed:@"ic_camera"];
    if ([[addPictureButton currentImage] isEqual:addPictureImage]) {
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
    } else {
        [Alert showOKCancelAlert:nil message:@"Are you sure you want to remove challenge picture?" viewController:self complete:^{
            
            photoImgView.image = nil;
            challengeSubcategory.Challenge_Pic = @"";
            isSelectedPhoto = false;
            [addPictureButton setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
        } canceled:nil];
    }
}
- (IBAction)handleDisplayHomepage:(id)sender {
    
    
    int displayHomePage = [sender isOn] == YES ? 1 : 0;
    
    if (displayHomePage == 1) {
        rankCountCellHeight = 50;
        
        rankCountTextField.selectedItem = @"3";
    } else {
        rankCountCellHeight = 0;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
    }
    if (indexPath.section == 3) {
        return 300;
    }
    
    if (indexPath.section == 2 && indexPath.row == 5) {
        return showTiesHeight;
    }
    
    if (indexPath.section == 2 && indexPath.row == 7) {
        return rankCountCellHeight;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        return fitnessHeight;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        return fitnessHeight;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        return addFieldHeight;
    }

    if (self.navigationChallengeStatus != ChallengeListState_Add  ) {
        
        if (indexPath.section == 2 && indexPath.row == 4) {
            return 0;
        }
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
        return @"select the Info";
    }
    if (section == 2) {
        return @"check the Info";
    }
    if (section == 3) {
        return @"Description of the challenge";
    }
    return @"";
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    photoImgView.image = image;
    isSelectedPhoto = true;
    [addPictureButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public Methods

- (BOOL) checkValidation {
    if ([_txt_challengeMenu.text isEqualToString:@""]) {
        [Alert showAlert:@"ChallengeMenu is required" message:@"" viewController:self];
        return false;
    }
    if ([_txt_challengeText1.text isEqualToString:@""]) {
        [Alert showAlert:@"ChallengeText1 is required" message:@"" viewController:self];
        return false;
    }
    
    return true;
}

- (void)dismissViewController {
    //    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
    [self.delegate didDisappear];
}

@end
