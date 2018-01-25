//
//  SyncFromServerClub.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "SyncFromServerClub.h"
#import "WebServicesLinks.h"
#import "JSONHelper.h"
#import "Player.h"
#import "DataFetcherHelper.h"
#import "Reachability.h"
#import "SCSQLite.h"
#import "RKCommon.h"


#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

@implementation SyncFromServerClub
@synthesize delegate;

-(void)loadDataRecordsWithURL:(NSString*)WebServiceURL serviceType:(NSString*)callServiceFor withTeamID:(int)userTeamID
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,
                   ^{
                       // Get the JSON string from our web serivce
                       NSDictionary * dictionary = [JSONHelper loadJSONDataFromURL:WebServiceURL];
                       NSLog(@"dic %@",WebServiceURL);
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          //This code will run once the JSON-loading section above has completed.
                                          [self startSyncFromServerWithDataDict:dictionary serviceType:callServiceFor WithTeamID:userTeamID];
                                          syncCount ++;
                                      });
                   });
}

-(void)startSyncFromServerWithDataDict:(NSDictionary*)recieveDataDict serviceType:(NSString*)callServiceFor WithTeamID:(int)userTeamID
{
    NSUInteger totalServiceCount = 9.0;
    NSMutableDictionary *valuesDictionary = [[NSMutableDictionary alloc] init];
    
    //NSLog(@"Recieved Data Dictionary of WebService : %@",recieveDataDict);
    if([callServiceFor isEqualToString:@"startSync"])
    {
        //check connection
        BOOL activeConn = [RKCommon checkInternetConnection];
        
        if(activeConn)
        {
            syncCount = 0;
            [self removeAllDataFromLocalDataBaseBeforeSync];
            [self loadDataRecordsWithURL:[NSString stringWithFormat:playerServiceURL,userTeamID] serviceType:@"playerService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            [ProgressHudHelper hideLoadingHud];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"No Active Connection Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if([callServiceFor isEqualToString:@"playerService"])
    {
        NSArray *allPlayers = [DataFetcherHelper getAllPlayerDataFromDict:recieveDataDict];
        if([allPlayers count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:teamServiceURL,userTeamID] serviceType:@"teamService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"teamService"])
    {
        NSArray *allTeams = [DataFetcherHelper getAllTeamDataFromDict:recieveDataDict];
        if([allTeams count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:challengeServiceURL,userTeamID] serviceType:@"challengeService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"challengeService"])
    {
        NSArray *allChallenges = [DataFetcherHelper getAllChallengeDataFromDict:recieveDataDict];
        if([allChallenges count] == [recieveDataDict count])
        {
            NSLog(@"url2%@",[NSString stringWithFormat:chalngCategoryServiceURL,userTeamID]);
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngCategoryServiceURL,userTeamID] serviceType:@"categoryService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"categoryService"])
    {
        NSArray *allCatagories = [DataFetcherHelper getAllCategoryDataFromDict:recieveDataDict];
        //NSLog(@"Details For Category = %@ And Total : %d",allCatagories,allCatagories.count);
        if([allCatagories count] == [recieveDataDict count])
        {
            NSLog(@"url1%@",[NSString stringWithFormat:chalngStateServiceURL,userTeamID]);
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngStateServiceURL,userTeamID] serviceType:@"chalStateService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"chalStateService"])
    {
        NSArray *allStates = [DataFetcherHelper getAllScoreStatesDataFromDict:recieveDataDict];
        //NSLog(@"Details For States = %@ And Total : %d",allStates,allStates.count);
        if([allStates count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:journalEntry ,userTeamID] serviceType:@"journalEntry" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    //    else if([callServiceFor isEqualToString:@"journalEntry"])
    //    {
    //        NSArray *allJournal = [DataFetcherHelper getAllJournalDataFromDict:recieveDataDict];
    //        //NSLog(@"Details For States = %@ And Total : %d",allStates,allStates.count);
    //        if([allJournal count] == [recieveDataDict count])
    //        {
    //            [self loadDataRecordsWithURL:[NSString stringWithFormat:rankingEntry,userTeamID] serviceType:@"rankinService" withTeamID:userTeamID];
    //        }
    //    }
    
    else if([callServiceFor isEqualToString:@"journalEntry"])
    {
        NSArray *allJournal = [DataFetcherHelper getAllJournalDataFromDict:recieveDataDict];
        //NSLog(@"Details For States = %@ And Total : %d",allStates,allStates.count);
        if([allJournal count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngImageServiceURL,userTeamID] serviceType:@"chalImageService" withTeamID:userTeamID];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"chalImageService"])
    {
        NSArray *allImages = [DataFetcherHelper getAllChallangeImageDataFromDict:recieveDataDict];
        
        [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
        [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
        
        //NSLog(@"Details For CategoryImages = %@ And Total : %d",allImages,allImages.count);
        //sleep(300);
        if([allImages count] == [recieveDataDict count])
        {
            NSLog(@"Everything is Complete call Process Complete Delegate");
            if([delegate respondsToSelector:@selector(syncFromServerProcessClubCompleted)])
            {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                
                [delegate syncFromServerProcessClubCompleted];
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
}

-(void)removeAllDataFromLocalDataBaseBeforeSync
{
    [self removeAllTableDataAfterLoginWithTableName:@"PlayersInfo"];
    [self removeAllTableDataAfterLoginWithTableName:@"TeamInfo"];
    [self removeAllTableDataAfterLoginWithTableName:@"Challanges"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallengeCategory"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallengeImage"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallangeStat"];
    [self removeAllTableDataAfterLoginWithTableName:@"JournalData"];
}

-(void)removeAllTableDataAfterLoginWithTableName:(NSString*)dbTableName
{
    BOOL success;
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *emptyTableQuery = [NSString stringWithFormat:@"DELETE FROM %@",dbTableName];
    success = [SCSQLite executeSQL:emptyTableQuery];
    
    if(success)
    {
        NSLog( @"Succsefully Deleted Table : %@",dbTableName);
    }
}

@end
