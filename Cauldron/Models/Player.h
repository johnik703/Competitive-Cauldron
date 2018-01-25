//
//  Player.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
{
 
}

@property (nonatomic, assign)int PlayerID;
@property (nonatomic, assign)int TeamID;
@property (nonatomic, copy)NSString *LastName;
@property (nonatomic, copy)NSString *FirstName;
@property (nonatomic, copy)NSString *Grade;
@property (nonatomic, copy)NSString *Position;
@property (nonatomic, copy)NSString *BirthDate;
@property (nonatomic, copy)NSString *GraduationDate;

@property (nonatomic, copy)NSString *PEmail;
@property (nonatomic, assign)int EmailPRpt;
@property (nonatomic, copy)NSString *MEmail;
@property (nonatomic, assign)int EmailMRpt;
@property (nonatomic, copy)NSString *DEmail;
@property (nonatomic, assign)int EmailDRpt;
@property (nonatomic, copy)NSString *Notes;
@property (nonatomic, copy)NSString *UserName;
@property (nonatomic, copy)NSString *Password;
@property (nonatomic, assign)int UserLevel;
@property (nonatomic, copy)NSString *Photo;
@property (nonatomic, copy)NSString *modified;
@property (nonatomic, copy)NSString *jercyNo;
@property (nonatomic, copy)NSString *Phone;


//-(id)initWithPlayerID:(int)xPlayerID playerTeamID:(int)xTeamID playerLastName:(NSString*)xLastName playerFirstName:(NSString*)xFirstName playerGrade:(NSString*)xGrade playerPosition:(NSString*)xPosition playerBirthDate:(NSString*)xBithDate palyerEmail:(NSString*)xEmail palyerEmailRprt:(int)xEmailPRpt playerMEmail:(NSString*)xMEmail palyerMEmailRprt:(int)xEmailMRprt playerDEmail:(NSString*)xDEmail palyerDEmailRprt:(int)xEmailDRprt playerNotes:(NSString*)xNotes playerUserName:(NSString*)xUserName playerPassword:(NSString*)xPassword playerUserLevel:(NSString*)xUserLevel playerPhoto:(NSString*)xPhoto platerModDate:(NSString*)xModeDate;

@end
