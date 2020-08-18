//
//  SQLManager.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "SQLManager.h"
#import "SCSQLite.h"
#import "Player.h"
#import "Team.h"
#import "ChallengeCatgry.h"

@implementation SQLManager
@synthesize delegate;

-(void)insertData:(NSArray*)wsDataArray serviceType:(NSString*)calledWebservice;
{
    NSArray *recAllData = wsDataArray;
    
    //Init database
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,
                   ^{
                       
                      if([calledWebservice isEqualToString:@"playerService"])
                      {
                         for (Player *aPlayer in wsDataArray)
                         {
                           /*
                           NSLog(@"Player ID = %d",aPlayer.PlayerID);
                           NSLog(@"Team ID = %d",aPlayer.TeamID);
                           NSLog(@"LastName = %@",aPlayer.LastName);
                           NSLog(@"FirstName  = %@",aPlayer.FirstName);
                           NSLog(@"Grade = %@",aPlayer.Grade);
                           NSLog(@"Position = %@",aPlayer.Position);
                           NSLog(@"BirthDate = %@",aPlayer.BirthDate);
                           NSLog(@"PEmail = %@",aPlayer.PEmail);
                           NSLog(@"EmailPRpt = %d",aPlayer.EmailPRpt);
                           NSLog(@"MEmail = %@",aPlayer.MEmail);
                           NSLog(@"EmailMRpt = %d",aPlayer.EmailMRpt);
                           NSLog(@"DEmail = %@",aPlayer.DEmail);
                           NSLog(@"EmailDRpt = %d",aPlayer.EmailDRpt);
                           NSLog(@"Notes = %@",aPlayer.Notes);
                           NSLog(@"UserName = %@",aPlayer.UserName);
                           NSLog(@"Password = %@",aPlayer.Password);
                           NSLog(@"UserLevel = %d",aPlayer.UserLevel);
                           NSLog(@"Photo = %@",aPlayer.Photo);
                           NSLog(@"modified = %@",aPlayer.modified);
                             
                             CREATE TABLE PlayersInfo (TeamID integer,PlayerID integer,LastName varchar,FirstName varchar,Grade varchar,Position varchar,BirthDate varchar,PEmail varchar,EmailPRpt integer,MEmail varchar,EmailMRpt integer,DEmail varchar,EmailDRpt integer,Notes varchar,UserName varchar,Password varchar,UserLevel integer,Photo varchar,modified varchar,Sync integer) */
                             
                             NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO PlayersInfo (TeamID,PlayerID,LastName,FirstName,Grade,Position,BirthDate,PEmail,EmailPRpt,MEmail,EmailMRpt, DEmail,EmailDRpt,Notes,UserName,Password,UserLevel,Photo,modified,Sync) VALUES(%d,%d,'%@','%@','%@','%@','%@','%@',%d,'%@',%d,'%@',%d,'%@','%@','%@',%d,'%@','%@',%d)",aPlayer.TeamID,aPlayer.PlayerID,aPlayer.LastName,aPlayer.FirstName,aPlayer.Grade,aPlayer.Position,aPlayer.BirthDate,aPlayer.PEmail,aPlayer.EmailPRpt,aPlayer.MEmail,aPlayer.EmailMRpt,aPlayer.DEmail,aPlayer.EmailDRpt,aPlayer.Notes,aPlayer.UserName,aPlayer.Password,aPlayer.UserLevel,aPlayer.Photo,aPlayer.modified,0];
                           
                             
                             BOOL success = [SCSQLite executeSQL:inserQuery];
                             
                             if(success)
                             {
//                                 NSLog(@"SuccessFully Inserted ID = %d",aPlayer.PlayerID);
                             }
                         }
                      }
                      else if([calledWebservice isEqualToString:@"teamService"])
                      {
                          for (Team *aTeam in wsDataArray)
                          {
                              /*
                              NSLog(@"Team ID = %d",aTeam.TeamID);
                              NSLog(@"Team ID = %d",aTeam.Sport);
                              NSLog(@"Stats_Year = %@",aTeam.Stats_Year);
                              NSLog(@"Team_Name = %@",aTeam.Team_Name);
                              NSLog(@"Website_Logo = %@",aTeam.Website_Logo);
                              NSLog(@"Team_Desc1 = %@",aTeam.Team_Desc1);
                              NSLog(@"Team_Desc2 = %@",aTeam.Team_Desc2);
                              NSLog(@"Team_Desc3 = %@",aTeam.Team_Desc3);
                              NSLog(@"admin_name = %@",aTeam.admin_name);
                              NSLog(@"admin_pw = %@",aTeam.admin_pw);
                              NSLog(@"admin_email = %@",aTeam.admin_email);
                              NSLog(@"EmailAdminRpt = %@",aTeam.EmailAdminRpt);
                              NSLog(@"mgr_name = %@",aTeam.mgr_name);
                              NSLog(@"mgr_pw = %@",aTeam.mgr_pw);
                              NSLog(@"mgr_email = %@",aTeam.mgr_email);
                              NSLog(@"EmailMgrRpt = %@",aTeam.EmailMgrRpt);
                              NSLog(@"contact_name = %@",aTeam.contact_name);
                              NSLog(@"contact_address = %@",aTeam.contact_address);
                              NSLog(@"contact_city = %@",aTeam.contact_city);
                              NSLog(@"contact_state = %@",aTeam.contact_state);
                              NSLog(@"contact_zip = %@",aTeam.contact_zip);
                              NSLog(@"contact_email = %@",aTeam.contact_email);
                              NSLog(@"contact_phone = %@",aTeam.contact_phone);
                              NSLog(@"trial = %@",aTeam.trial);
                              NSLog(@"subscription_end = %@",aTeam.subscription_end);
                              NSLog(@"Activated = %d",aTeam.Activated);
                              NSLog(@"Notes = %@",aTeam.Notes);
                              NSLog(@"Desc1 = %@",aTeam.Desc1);
                              NSLog(@"Email1 = %@",aTeam.Email1);
                              NSLog(@"EmailDesc1Rpt = %@",aTeam.EmailDesc1Rpt);
                              NSLog(@"Desc2 = %@",aTeam.Desc2);
                              NSLog(@"Email2 = %@",aTeam.Email2);
                              NSLog(@"EmailDesc2Rpt = %@",aTeam.EmailDesc2Rpt);
                              NSLog(@"Desc3 = %@",aTeam.Desc3);
                              NSLog(@"Email3 = %@",aTeam.Email3);
                              NSLog(@"EmailDesc3Rpt = %@",aTeam.EmailDesc3Rpt);
                              NSLog(@"rptFitness = %d",aTeam.rptFitness);
                              NSLog(@"SeasonStart = %@",aTeam.SeasonStart);
                              NSLog(@"SeasonEnd = %@",aTeam.SeasonEnd);
                              NSLog(@"Bulk_Import = %d",aTeam.Bulk_Import);
                              NSLog(@"eam_Picture = %@",aTeam.Team_Picture);
                              NSLog(@"Display_Picture = %d",aTeam.Display_Picture);
                              NSLog(@"demoTeam = %d",aTeam.demoTeam);
                              NSLog(@"modified = %@",aTeam.modified);
                              NSLog(@"quote = %@",aTeam.quote);
                              NSLog(@"noofmonth = %d",aTeam.noofmonth);
                              NSLog(@"team_position = %@",aTeam.team_position);
                              
                              CREATE TABLE TeamInfo (TeamID integer,Sports varchar,Stats_Year varchar,Team_Name varchar,Website_Logo varchar,Team_Desc1 varchar,Team_Desc2 varchar,Team_Desc3 varchar,admin_name varchar,admin_pw varchar,admin_email varchar,EmailAdminRpt integer,mgr_name varchar,mgr_pw varchar,mgr_email varchar,EmailMgrRpt varchar,contact_name varchar,contact_address varchar,contact_city varchar,contact_state varchar,contact_zip varchar,contact_email varchar,contact_phone varchar,trial varchar,SubscriptionEnd varchar,Activated integer,Notes varchar,Desc1 varchar,Email1 varchar,EmailDesc1Rpt varchar,Desc2 varchar,Email2 varchar,EmailDesc2Rpt varchar,Desc3 varchar,Email3 varchar,EmailDesc3Rpt varchar,ReprtFitness integer,SeasonStart varchar,SeasonEnd varchar,Bulk_Import integer,Team_Picture varchar,Display_Picture integer,demoTeam integer,modified varchar,quote varchar,noofmonth integer,team_position varchar,Sync integer) */
                              
                              NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO TeamInfo (TeamID,Sports,Stats_Year,Team_Name,Website_Logo,Team_Desc1,Team_Desc2,Team_Desc3,admin_name,admin_pw,admin_email,EmailAdminRpt,mgr_name,mgr_pw,mgr_email,EmailMgrRpt,contact_name,contact_address,contact_city,contact_state,contact_zip,contact_email,contact_phone,trial,SubscriptionEnd,Activated,Notes,Desc1,Email1,EmailDesc1Rpt,Desc2,Email2,EmailDesc2Rpt,Desc3,Email3,EmailDesc3Rpt,ReprtFitness,SeasonStart,SeasonEnd,Bulk_Import,Team_Picture,Display_Picture,demoTeam,modified,quote,noofmonth,team_position,Sync) VALUES(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@',%d,'%@',%d,%d,'%@','%@',%d,'%@',%d)",aTeam.TeamID,aTeam.Sport,aTeam.Stats_Year,aTeam.Team_Name,aTeam.Website_Logo,aTeam.Team_Desc1,aTeam.Team_Desc2,aTeam.Team_Desc3,aTeam.admin_name,aTeam.admin_pw,aTeam.admin_email,aTeam.EmailAdminRpt,aTeam.mgr_name,aTeam.mgr_pw,aTeam.mgr_email,aTeam.EmailMgrRpt,aTeam.contact_name,aTeam.contact_address,aTeam.contact_city,aTeam.contact_state,aTeam.contact_zip,aTeam.contact_email,aTeam.contact_phone,aTeam.trial,aTeam.subscription_end,aTeam.Activated,aTeam.Notes,aTeam.Desc1,aTeam.Email1,aTeam.EmailDesc1Rpt,aTeam.Desc2,aTeam.Email2,aTeam.EmailDesc2Rpt,aTeam.Desc3,aTeam.Email3,aTeam.EmailDesc3Rpt,aTeam.rptFitness,aTeam.SeasonStart,aTeam.SeasonEnd,aTeam.Bulk_Import,aTeam.Team_Picture,aTeam.Display_Picture,aTeam.demoTeam,aTeam.modified,aTeam.quote,aTeam.noofmonth,aTeam.team_position,0];
                              
                              //NSLog(@"Query ==== %@",inserQuery);
                              
                              BOOL success = [SCSQLite executeSQL:inserQuery];
                              
                              if(success)
                              {
//                                  NSLog(@"SuccessFully Inserted ID = %d",aTeam.TeamID);
                              }
                              
                        }

                      }
                      else if([calledWebservice isEqualToString:@"challengeService"])
                      {
                          for (Challenge *aChlng in wsDataArray)
                          {
                              //NSLog(@"TeamID = %d",aChlng.TeamID);
                              NSLog(@"Challange ID = %d",aChlng.ID);
                              /*
                              NSLog(@"Challenge_Name = %@",aChlng.Challenge_Name);
                              NSLog(@"Challenge_Menu = %@",aChlng.Challenge_Menu);
                              NSLog(@"Challenge_Text1 = %@",aChlng.Challenge_Text1);
                              NSLog(@"Challenge_Text2 = %@",aChlng.Challenge_Text2);
                              NSLog(@"Challenge_Text3 = %@",aChlng.Challenge_Text3);
                              NSLog(@"Challenge_Multiplier = %d",aChlng.Challenge_Multiplier);
                              NSLog(@"Challenge_Type = %@",aChlng.Challenge_Type);
                              NSLog(@"Challenge_Exclude = %d",aChlng.Challenge_Exclude);
                              NSLog(@"Challenge_Category = %d",aChlng.Challenge_Category);
                              NSLog(@"Challenge_Desc = %@",aChlng.Challenge_Desc);
                              NSLog(@"Challenge_Detail = %@",aChlng.Challenge_Detail);
                              NSLog(@"WLT = %@",aChlng.WLT);
                              NSLog(@"Show_Ties = %@",aChlng.Show_Ties);
                              NSLog(@"Video_Name = %@",aChlng.Video_Name);
                              NSLog(@"Enabled = %d",aChlng.Enabled);
                              NSLog(@"isDecimal = %@",aChlng.isDecimal);
                              NSLog(@"Challenge_Pic = %@",aChlng.Challenge_Pic);
                              NSLog(@"isHome = %d",aChlng.isHome);
                              NSLog(@"playersCount = %d",aChlng.playersCount);
                              NSLog(@"modified = %@",aChlng.modified);*/
                              
                              
                              
                          }
                      }
                       else if([calledWebservice isEqualToString:@"categoryService"])
                       {
                           for (ChallengeCatgry *aChlngCat in wsDataArray)
                           {
                               NSLog(@"catID = %d",aChlngCat.catID);
                               /*
                               NSLog(@"TeamID = %d",aChlngCat.TeamID);
                               NSLog(@"categoryname = %@",aChlngCat.categoryname);
                               NSLog(@"shortname = %@",aChlngCat.shortname);
                               NSLog(@"catOrder = %d",aChlngCat.catOrder);
                                */
                           }

                       }
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          //This code will run once the JSON-loading section above has completed.
                                           //NSLog(@"All Data Showing Complete %d",recAllPlayers.count);
                                          
                                          if([delegate respondsToSelector:@selector(processCompletedForServiceType:TotalInsertedData:)])
                                          {
                                              [delegate processCompletedForServiceType:calledWebservice TotalInsertedData:(int)recAllData.count];
                                          }

                                      });
                   });

 }
@end


//Init database
//[SCSQLite initWithDatabase:@"myproject.db"];

//To create, insert, update and delete use this method
//BOOL success = [SCSQLite executeSQL:@"INSERT INTO User (name, lastname) VALUES ('Lucas', 'Correa')"];
/*
 for (Player *aPlayer in wsPlayers)
 {
 NSLog(@"Player ID = %d",aPlayer.PlayerID);
 NSLog(@"Team ID = %d",aPlayer.TeamID);
 NSLog(@"LastName = %@",aPlayer.LastName);
 NSLog(@"FirstName  = %@",aPlayer.FirstName);
 NSLog(@"Grade = %@",aPlayer.Grade);
 NSLog(@"Position = %@",aPlayer.Position);
 NSLog(@"BirthDate = %@",aPlayer.BirthDate);
 NSLog(@"PEmail = %@",aPlayer.PEmail);
 NSLog(@"EmailPRpt = %d",aPlayer.EmailPRpt);
 NSLog(@"MEmail = %@",aPlayer.MEmail);
 NSLog(@"EmailMRpt = %d",aPlayer.EmailMRpt);
 NSLog(@"DEmail = %@",aPlayer.DEmail);
 NSLog(@"EmailDRpt = %d",aPlayer.EmailDRpt);
 NSLog(@"Notes = %@",aPlayer.Notes);
 NSLog(@"UserName = %@",aPlayer.UserName);
 NSLog(@"Password = %@",aPlayer.Password);
 NSLog(@"UserLevel = %d",aPlayer.UserLevel);
 NSLog(@"Photo = %@",aPlayer.Photo);
 NSLog(@"modified = %@",aPlayer.modified);
 }
 */
//    Player *aPlayer = [wsPlayers objectAtIndex:0];
//
//    NSLog(@"Player ID = %d",aPlayer.PlayerID);
//

