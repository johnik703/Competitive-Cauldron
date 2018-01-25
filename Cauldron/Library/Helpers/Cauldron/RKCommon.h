//
//  RKCommon.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface RKCommon : NSObject

+(BOOL)checkInternetConnection;
+(NSString *)displayTodayDate;
+(NSString *)getSyncDateInString;
+(NSString *)stringFromTheDate:(NSDate*)date;
+(UIColor*)appBackGroundForSportType:(int)sportType;
+(BOOL)validateDateStringFromTextFiled:(UITextField*)myDateTextField;
+(void)showPickerViewWithBounceAnimation:(UIView *)pickerView;
+(void)hidePickerViewWithBounceAnimation:(UIView *)pickerView;
+(void)dimmedViewController:(UIViewController *)onScreenViewController;
+(void)removedimmedView:(UIViewController *)dimmedViewController;

@end
