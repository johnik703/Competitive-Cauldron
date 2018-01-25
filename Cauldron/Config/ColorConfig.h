//
//  ColorConfig.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#ifndef ColorConfig_h
#define ColorConfig_h

//-------------------------------------------------------------------------------------------------------------------------------------------------
//      Color Define
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define     WHITE_COLOR         [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]
#define     THEME_COLOR         [UIColor colorWithRed:83.0 / 255.0 green:163.0 / 255.0 blue:24.0 / 255.0 alpha:1.0]	
#define     DEFAULT_BLUE        [UIColor colorWithRed:0.0 / 255.0 green:159.0 / 255.0 blue:232.0 / 255.0 alpha:1.0]
#define     TINT_COLOR          [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]
#define     BORDOR_COLOR        [UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1.0]
#define     BORDOR_COLOR1       [UIColor colorWithRed:233.0 / 255.0 green:233.0 / 255.0 blue:233.0 / 255.0 alpha:1.0]
#define     FONT_COLOR          [UIColor colorWithRed:76.0 / 255.0 green:76.0 / 255.0 blue:76.0 / 255.0 alpha:1.0]
#define     BACKGROUND_COLOR    [UIColor colorWithRed:249.0 / 255.0 green:249.0 / 255.0 blue:249.0 / 255.0 alpha:1.0]
#define     PLACEHOLER_COLOR    [UIColor colorWithRed:199.0 / 255.0 green:199.0 / 255.0 blue:205.0 / 255.0 alpha:1.0]
#define     HIGHLIGHT_COLOR     [UIColor colorWithRed:240.0 / 255.0 green:240.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]
#define     DEFAULT_ARMYCOLOR   [UIColor colorWithRed:232.0 / 255.0 green:109.0 / 255.0 blue:0.0 / 255.0 alpha:1.0]

//-------------------------------------------------------------------------------------------------------------------------------------------------
//      Font Define
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define     HelveticaNeueFont_Light(f)  [UIFont fontWithName:@"HelveticaNeue-Light" size:f]
#define     HelveticaNeueFont(f)        [UIFont fontWithName:@"HelveticaNeue" size:f]
#define     HelveticaNeueMedium(f)      [UIFont fontWithName:@"HelveticaNeue-Medium" size:f]
#define     UbuntuFont(f)               [UIFont fontWithName:@"Ubuntu" size:f]
#define     UbuntuFont_Light(f)         [UIFont fontWithName:@"Ubuntu-Light" size:f]
#define     UbuntuFont_Medium(f)        [UIFont fontWithName:@"Ubuntu-Medium" size:f]
#define     UbuntuFont_Arributes(x)     @{NSForegroundColorAttributeName : FONT_COLOR, NSFontAttributeName: [UIFont fontWithName:@"Ubuntu" size:18.0f]}

#endif /* ColorConfig_h */

