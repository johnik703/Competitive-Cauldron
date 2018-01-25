//
//  RKCommon.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RKCommon.h"

@implementation RKCommon

+(BOOL)checkInternetConnection
{
    Reachability* wifiReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        return NO;
    }
    else if(netStatus == ReachableViaWWAN)
    {
        return YES;
    }
    else if(netStatus == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}

+(NSString *)displayTodayDate
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}

+(NSString *)getSyncDateInString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}

+(NSString *)stringFromTheDate:(NSDate*)date
{
    NSDate *today = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}


+(BOOL)validateDateStringFromTextFiled:(UITextField*)myDateTextField
{
    UITextField *textField = myDateTextField;
    
    if (textField == myDateTextField)
    {
        NSString *regEx = @"[0-1]{1}[0-9]{1}-[0-3]{1}[0-9]{1}-[0-9]{4}";
        NSRange r = [textField.text rangeOfString:regEx options:NSRegularExpressionSearch];
        if (r.location == NSNotFound) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Entry Error"
                                                          message:@"Enter Date in 'mm-dd-yyyy' format"
                                                         delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    return YES;
}

+(void)showPickerViewWithBounceAnimation:(UIView *)pickerView
{
    NSUInteger iOSVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if(iOSVersion >= 8)
    {
        // For iOS 8.0 and later
        [UIView animateWithDuration:0.4
                              delay:0.1
             usingSpringWithDamping:0.75
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             pickerView.hidden = NO;
                             CGRect newframe = pickerView.frame;
                             newframe.origin.y = newframe.origin.y - pickerView.frame.size.height;
                             pickerView.frame = newframe;
                         }
                         completion:nil];
    }
    else
    {
        // For iOS 7.0 and below
        [UIView animateWithDuration:0.4
                         animations:^{
                             pickerView.hidden = NO;
                             CGRect newframe = pickerView.frame;
                             newframe.origin.y = newframe.origin.y - pickerView.frame.size.height;
                             pickerView.frame = newframe;
                         } completion:nil];
    }
}

+(void)hidePickerViewWithBounceAnimation:(UIView *)pickerView
{
    NSUInteger iOSVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if(iOSVersion >= 8)
    {
        // For iOS 8.0 and later
        [UIView animateWithDuration:0.4
                              delay:0.1
             usingSpringWithDamping:0.75
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             CGRect newframe = pickerView.frame;
                             newframe.origin.y =
                             newframe.origin.y + (pickerView.frame.size.height);
                             pickerView.frame = newframe;
                         }
                         completion:^(BOOL finished) {
                             
                             pickerView.hidden = YES;
                             [pickerView removeFromSuperview];
                         }];
    }
    else
    {
        // For iOS 7.0 and below
        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect newframe = pickerView.frame;
                             newframe.origin.y =
                             newframe.origin.y + (pickerView.frame.size.height);
                             pickerView.frame = newframe;
                         } completion:^(BOOL finished) {
                             
                             pickerView.hidden = YES;
                             [pickerView removeFromSuperview];
                         }];
    }
}

+(void)dimmedViewController:(UIViewController *)onScreenViewController
{
    NSUInteger iOSVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if(iOSVersion >= 7)
    {
        // For iOS 8.0 and later
        onScreenViewController.view.userInteractionEnabled = NO;
        onScreenViewController.view.alpha = 0.5;
    }
}

+(void)removedimmedView:(UIViewController *)dimmedViewController
{
    NSUInteger iOSVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if(iOSVersion >= 7)
    {
        // For iOS 8.0 and later
        dimmedViewController.view.userInteractionEnabled = YES;
        dimmedViewController.view.alpha = 1.0;
    }
}

+(UIColor*)appBackGroundForSportType:(int)sportType
{
    UIColor *myAppBgColor;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    switch (sportType)
    {
        case 0:
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_backgroundiPad.png"]];
            }
            else
            {
                    if (screenSize.height > 480.0f)
                    {
                        myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_background4s.png"]];
                    }
                    else
                    {
                        myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_background5s.png"]];
                    }
            }
            break;
            
        case 1:
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_backgroundiPad.png"]];
            }
            else
            {
                if (screenSize.height > 480.0f)
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_background4s.png"]];
                }
                else
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_background5s.png"]];
                }
            }
            break;
            
        case 2:
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_footballiPad.png"]];
            }
            else
            {
                if (screenSize.height > 480.0f)
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_football4s.png"]];
                }
                else
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"pt_football5s.png"]];
                }
            }
            break;
            
        case 3:
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_footballiPad.png"]];
            }
            else
            {
                if (screenSize.height > 480.0f)
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_football4s.png"]];
                }
                else
                {
                    myAppBgColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"ls_football5s.png"]];
                }
            }
            break;
            
        default:
            break;
    }
    
    return myAppBgColor;
}


@end
