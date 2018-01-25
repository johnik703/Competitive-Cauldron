//
//  Register1ViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Register1ViewController.h"

@interface Register1ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL isSelectedPhoto;
}
@end

@implementation Register1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMenuLeftBarButtomItem];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize UI
    self.yearTF.text = Global.objSignUp.statsYear;
    self.teamNameTF.text = Global.objSignUp.teamName;
    self.subscriptionDateDDTF.text = Global.objSignUp.subscriptionEnds;
    self.seasonStartsDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.seasonStartsDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.seasonStartsDDTF.date = [Global.objSignUp.sessionStarts dateWithFormat:@"MM-dd-yyyy"];
    self.seasonEndsDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.seasonEndsDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.seasonEndsDDTF.date = [Global.objSignUp.sessionEnds dateWithFormat:@"MM-dd-yyyy"];
    self.photoImgView.image = [UIImage imageWithData:[Global.objSignUp.base64Pic base64Data]];
    if (self.photoImgView.image == nil) {
        self.photoImgView.image = [UIImage imageNamed:@"avatar"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapNext:(id)sender {
    Register2ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register2ViewController"];
    [self.navigationController pushViewController:viewController animated:true];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
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
        return @"season";
    }
    return @"";
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

#pragma mark - Public Methods

- (BOOL) checkValidation {
    if ([self.teamNameTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Team name is required" message:@"" viewController:self];
        return false;
    }
    return true;
}

@end
