//
//  PassFailFitnessReportController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassFailFitnessReportController : UIViewController

{
    NSString *playerID;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
