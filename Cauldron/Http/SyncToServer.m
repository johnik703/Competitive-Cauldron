//
//  SyncToServer.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "SyncToServer.h"
#import "SCSQLite.h"
#import "WebServicesLinks.h"

#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

@implementation SyncToServer
@synthesize delegate;

/*
-(void)startSyncDataToServer
{
    syncCount = 0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,
                   ^{
                       // Get the JSON string from our web serivce
                       NSArray * JsonStringArray = [self createJsonStringsArray];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{

                                          for(int i = 0; i<[JsonStringArray count]; i++)
                                          {
                                              NSString *aJsonString = [JsonStringArray objectAtIndex:i];
                                              //NSLog(@"ONE JSON STRING = %@",aJsonString);
                                              
                                              NSString *url = @"http://192.168.2.11/competitive-cauldron/test/stats/web_service/getStats.php";
                                              
                                              NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:url withJsonString:aJsonString] delegate:self];
                                              
                                              if(requestConnection)
                                              {
                                                responseData = [NSMutableData data];
                                                NSString *respString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
                                                NSLog(@"responseDataStringIn Block: %@", respString);
                                              }
                                          }

                                       });
                       
                   });

}
*/


- (id)init
{
    self = [super init];
    if (self)
    {
        allStatesJsonStringArray = [[NSMutableArray alloc]init];
        allStatesJsonStringArrayAtd = [[NSMutableArray alloc]init];
        allStatesJsonStringArrayJornal=[[NSMutableArray alloc]init];
        allStatesJsonStringArrayPlayer=[[NSMutableArray alloc]init];
        allStatesJsonStringArrayForSync=[[NSMutableArray alloc]init];
        allStatesJsonStringArrayAtdForSync = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSUInteger)getTotalItemsSyncToServerCount
{
    NSArray * JsonStringArray = [self createJsonStringsArray];
    NSArray * JsonStringArrayAttandance = [self createJsonStringsArrayAttandance];
    NSArray * JsonStringArrayJournal = [self createJsonStringsArrayJournal];
    NSArray * JsonStringArrayPlayer = [self createJsonStringsArrayPlayer];
    totalItemsCount = [JsonStringArray count] + [JsonStringArrayAttandance count] + [JsonStringArrayJournal count] + [JsonStringArrayPlayer count];
    return totalItemsCount;
}

-(void)startSyncStatsDataToServer {
    NSArray * JsonStringArray = [self createJsonStringsArray];
    for(int i = 0; i<[JsonStringArray count]; i++)
    {
        NSString *aJsonString = [JsonStringArray objectAtIndex:i];
        //NSLog(@"ONE JSON STRING = %@",aJsonString);
        NSLog(@"statsJsonString, %@", aJsonString);
        
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURL withJsonString:aJsonString] delegate:self];
        
        if(requestConnection)
        {
            responseDataFromChallange = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromChallange encoding:NSASCIIStringEncoding];
            NSLog(@"responseDataStringIn Block1 stats: %@", respString);
        }
    }

}

-(void)startSyncJournalDataToServer {
    
    NSArray * JsonStringArrayJournal = [self createJsonStringsArrayJournal];
    
    for(int i = 0; i<[JsonStringArrayJournal count]; i++)
    {
        NSString *aJsonString = [JsonStringArrayJournal objectAtIndex:i];
        //NSLog(@"ONE JSON STRING = %@",aJsonString);
        
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURLJournal withJsonString:aJsonString] delegate:self];
        
        if(requestConnection)
        {
            responseDataFromJournal = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromJournal encoding:NSASCIIStringEncoding];
            NSLog(@"responseDataStringIn Block3: %@", respString);
        }
    }
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSLog(@"statssync, %@", dic);
    
}

-(void)startSyncDataToServer
{
    NSArray * JsonStringArray = [self createJsonStringsArray];
    NSArray * JsonStringArrayAttandance = [self createJsonStringsArrayAttandance];
    NSArray * JsonStringArrayJournal = [self createJsonStringsArrayJournal];
    NSArray * JsonStringArrayPlayer = [self createJsonStringsArrayPlayer];
    
    NSArray *jsonStatsArray = [self createJsonStringsArrayForStats];
    NSArray *jsonAttentenceArray = [self createJsonStringsArrayAttandanceForSync];
    
    NSLog(@"statsJsonArray, %@", JsonStringArray);
    NSLog(@"attendanceJsonArray, %@", jsonAttentenceArray);
    
    for(int i = 0; i<[JsonStringArray count]; i++)
    {
        NSString *aJsonString = [JsonStringArray objectAtIndex:i];
        //NSLog(@"ONE JSON STRING = %@",aJsonString);
        NSLog(@"statsJsonString, %@", aJsonString);
                
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURL withJsonString:aJsonString] delegate:self];
        
        if (i == [JsonStringArray count] -1) {
            
            NSString *jsonString = [jsonStatsArray componentsJoinedByString:@"?"];
            
            
            NSDictionary* params = @{@"data": jsonString,
                                     @"userid": Global.playerIDFinal
                                     };
            
            [API executeHTTPRequest:Post url:syncToServerSendStatsToCoachServiceURL parameters:params CompletionHandler:^(NSDictionary *responseDict) {
                
//                [self parseResponse:responseDict params:params ];
            } ErrorHandler:^(NSString *errorStr) {
                
//                NSLog(@"errorStr ---%@", errorStr);
            }];
        }
        
        if(requestConnection)
        {
            responseDataFromChallange = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromChallange encoding:NSASCIIStringEncoding];
//            NSLog(@"responseDataStringIn Block1 stats: %@", respString);
        }
    }
    
    for(int i = 0; i<[JsonStringArrayAttandance count]; i++)
    {
        NSString *aJsonString = [JsonStringArrayAttandance objectAtIndex:i];
        NSLog(@"ONE JSON STRING = %@",aJsonString);
        
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURLAttandace withJsonString:aJsonString] delegate:self];
        
        if (i == [jsonAttentenceArray count] -1) {
            NSString *jsonStringAttendence = [jsonAttentenceArray componentsJoinedByString:@"?"];
            
            
            NSDictionary* params = @{@"data": jsonStringAttendence,
                                     @"userid": Global.playerIDFinal
                                     };
            
            [API executeHTTPRequest:Post url:syncToServerSendAttendenceToCoachServiceURL parameters:params CompletionHandler:^(NSDictionary *responseDict) {
                
                                [self parseResponse:responseDict params:params ];
            } ErrorHandler:^(NSString *errorStr) {
                
//                                NSLog(@"errorStr ---%@", errorStr);
            }];
        }
        
        if(requestConnection)
        {
            responseDataFromAttandance = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromAttandance encoding:NSASCIIStringEncoding];
            NSLog(@"responseDataStringIn Block2: %@", respString);
        }
    }
    
    for(int i = 0; i<[JsonStringArrayJournal count]; i++)
    {
        NSString *aJsonString = [JsonStringArrayJournal objectAtIndex:i];
        //NSLog(@"ONE JSON STRING = %@",aJsonString);
        
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURLJournal withJsonString:aJsonString] delegate:self];
        
        if(requestConnection)
        {
            responseDataFromJournal = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromJournal encoding:NSASCIIStringEncoding];
            NSLog(@"responseDataStringIn Block3: %@", respString);
        }
    }

    for(int i = 0; i<[JsonStringArrayPlayer count]; i++)
    {
        NSString *aJsonString = [JsonStringArrayPlayer objectAtIndex:i];
        //NSLog(@"ONE JSON STRING = %@",aJsonString);
        
        NSURLConnection *requestConnection = [[NSURLConnection alloc]initWithRequest:[self sendRequestWithURL:syncToServerServiceURLPlayer withJsonString:aJsonString] delegate:self];
        
        if(requestConnection)
        {
            responseDataFromPlayer = [NSMutableData data];
            NSString *respString = [[NSString alloc] initWithData:responseDataFromPlayer encoding:NSASCIIStringEncoding];
            NSLog(@"responseDataStringIn Block4: %@", respString);
        }
    }
}

-(NSMutableURLRequest*)sendRequestWithURL:(NSString*)URL withJsonString:(NSString*)jsonDataStr
{
    NSString *urlString = URL;
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    NSString *postString = [[NSString alloc] initWithFormat:@"%@",jsonDataStr];
    NSData *postBody = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    NSLog(@"synctoserverUrl, %@", requestUrl);
    [postRequest setHTTPMethod:@"POST"];
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type:text/html;"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:[NSString stringWithFormat:@"%d",(int)[postBody length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:postBody];
    
    NSLog(@"synctoserverpostrequest, %@", postRequest);
    return postRequest;
}

#pragma mark - NSURLConnection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseDataFromChallange = [[NSMutableData alloc] init];
    [responseDataFromChallange setLength:0];
    
    responseDataFromAttandance = [[NSMutableData alloc] init];
    [responseDataFromAttandance setLength:0];
    
    responseDataFromJournal = [[NSMutableData alloc] init];
    [responseDataFromJournal setLength:0];

    responseDataFromPlayer = [[NSMutableData alloc] init];
    [responseDataFromPlayer setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data


{
    
    NSLog(@"connectionData, %@", data);
    
    [responseDataFromChallange description];
    [responseDataFromChallange appendData:data];
    
    NSLog(@"connectionChallengeData, %@", responseDataFromChallange);
    
    [responseDataFromAttandance description];
    [responseDataFromAttandance appendData:data];
    
    [responseDataFromJournal description];
    [responseDataFromJournal appendData:data];

    [responseDataFromPlayer description];
    [responseDataFromPlayer appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *string = [[NSString alloc] initWithData:responseDataFromAttandance encoding:NSASCIIStringEncoding];
    NSLog(@"responseDataStringInDelegate: %@", string);
    
    NSError *e;
    NSArray *responseDict = [NSJSONSerialization JSONObjectWithData: responseDataFromChallange options: NSJSONReadingMutableContainers error: &e];
    NSArray *responseDictAttandance = [NSJSONSerialization JSONObjectWithData: responseDataFromAttandance options: NSJSONReadingMutableContainers error: &e];
    NSArray *responseDictJournal = [NSJSONSerialization JSONObjectWithData: responseDataFromJournal options: NSJSONReadingMutableContainers error: &e];
    NSArray *responseDictPlayer = [NSJSONSerialization JSONObjectWithData: responseDataFromPlayer options: NSJSONReadingMutableContainers error: &e];
    totalItemsCount = totalDataToSyncChal+totalDataToSyncAtd+totalDataToSyncJournal+totalDataToSyncPlayer;
    
    NSLog(@"emailreporttest, %@", responseDict);
    NSLog(@"emailreportdatatest, %@", responseDataFromChallange);
    NSLog(@"responseDictAttandance, %@", responseDictAttandance);
    NSLog(@"responseDictJournal, %@", responseDictJournal);
    NSLog(@"responseDictPlayer, %@", responseDictPlayer);
    
    NSMutableDictionary *valuesDictionary = [[NSMutableDictionary alloc] init];
    
    if([responseDict count]>0)
    {
        int insertedID =(int) [[[responseDict objectAtIndex:0]valueForKey:@"ID"] integerValue];
        NSString *successReult = [[responseDict objectAtIndex:0]valueForKey:@"Result"];
        NSString *typeReultChal = [[responseDict objectAtIndex:0]valueForKey:@"Type"];

        if([successReult isEqualToString:@"success"] && [typeReultChal isEqualToString:@"C"])
        {
            
            // reset challenge stats as "0" after sync
            
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            BOOL success;
            NSString *updateQuery = [NSString stringWithFormat:@"UPDATE ChallangeStat SET Sync=%d WHERE ChStatID=%d",0, insertedID];
            success = [SCSQLite executeSQL:updateQuery];
            if(success)
            {
                NSLog(@"SuccessFully Updated ScoreStat ID = %d", insertedID);
                syncCount ++;
            }
            
        }
    }
    
    if([responseDictAttandance count]>0)
    {
        int atdID = (int)[[[responseDictAttandance objectAtIndex:0]valueForKey:@"ID"] integerValue];
        NSString *successReult = [[responseDictAttandance objectAtIndex:0]valueForKey:@"Result"];
        NSString *typeReult = [[responseDictAttandance objectAtIndex:0]valueForKey:@"Type"];
        
        if([successReult isEqualToString:@"success"] && [typeReult isEqualToString:@"A"])
        {
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            BOOL success;
            NSString *updateAttandaceQuery = [NSString stringWithFormat:@"UPDATE playerattendance SET sync=%d WHERE id=%d",0,atdID];
            success = [SCSQLite executeSQL:updateAttandaceQuery];
            if(success)
            {
                NSLog(@"SuccessFully Updated ScoreStat ID = %d", atdID);
                syncCount ++;
            }
        }
    }
    
    
    if([responseDictJournal count]>0)
    {
        int atdID = (int)[[[responseDictJournal objectAtIndex:0]valueForKey:@"ID"] integerValue];
        NSString *successReult = [[responseDictJournal objectAtIndex:0]valueForKey:@"Result"];
        NSString *typeReult = [[responseDictJournal objectAtIndex:0]valueForKey:@"Type"];
        
        if([successReult isEqualToString:@"success"] && [typeReult isEqualToString:@"J"])
        {
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            BOOL success;
            NSString *updateJournalQuery = [NSString stringWithFormat:@"UPDATE JournalData SET sync=%d WHERE id=%d",0,atdID];
            success = [SCSQLite executeSQL:updateJournalQuery];
            if(success)
            {
                NSLog(@"SuccessFully Updated ScoreStat ID = %d", atdID);
                syncCount ++;
            }
        }
    }
    
    if([responseDictPlayer count]>0)
    {
        int playerID = (int)[[[responseDictPlayer objectAtIndex:0]valueForKey:@"ID"] integerValue];
        NSString *successReult = [[responseDictPlayer objectAtIndex:0]valueForKey:@"Result"];
        NSString *typeReult = [[responseDictPlayer objectAtIndex:0]valueForKey:@"Type"];
        
        if([successReult isEqualToString:@"success"] && [typeReult isEqualToString:@"P"])
        {
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            BOOL success;
            NSString *updateJournalQuery = [NSString stringWithFormat:@"UPDATE PlayersInfo SET Sync=%d WHERE PlayerID=%d",0,playerID];
            success = [SCSQLite executeSQL:updateJournalQuery];
            if(success)
            {
                NSLog(@"SuccessFully Updated ScoreStat ID = %d", playerID);
                syncCount ++;
            }
        }
    }


    if(syncCount == totalDataToSyncChal+totalDataToSyncAtd+totalDataToSyncJournal+totalDataToSyncPlayer)
    {
        NSLog(@"SYNCING TO SERVER TOTAL COMPLETE");
        
        if([delegate respondsToSelector:@selector(SyncToServerProcessCompleted)])
        {
            [delegate SyncToServerProcessCompleted];
        }
    }
}
- (NSArray *)createJsonStringsArrayForStats {
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        ChallengeState *aScoreState = [[ChallengeState alloc]init];
        
        aScoreState.StatID = [[[teamStats objectAtIndex:i] valueForKey:@"ChStatID"]intValue];
        aScoreState.chStTeamID = [[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        aScoreState.chalStID = [[[teamStats objectAtIndex:i] valueForKey:@"ChallangeID"]intValue];
        aScoreState.chalStPlayerID = [[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"]intValue];
        aScoreState.chalStColName = [[teamStats objectAtIndex:i] valueForKey:@"column_name"];
        aScoreState.chalStColVal = [[teamStats objectAtIndex:i] valueForKey:@"column_val"];
        aScoreState.chalModDate = [[teamStats objectAtIndex:i] valueForKey:@"Date"];
        aScoreState.email_reportAdded = [[[teamStats objectAtIndex:i] valueForKey:@"email_reportAdded"] intValue];
        
        //        NSLog(@"Stat ID = %d",aScoreState.StatID);
        //        NSLog(@"Stat Team = %d",aScoreState.chStTeamID);
        //        NSLog(@"Stat ChallengeID = %d",aScoreState.chalStID);
        //        NSLog(@"Stat Player ID = %d",aScoreState.chalStPlayerID);
        //        NSLog(@"Stat ColName = %@",aScoreState.chalStColName);
        //        NSLog(@"Stat ColVal = %@",aScoreState.chalStColVal);
        
        
        
        NSString *aStateJsonString =  [self createJsonStringForStateSync:aScoreState];
        
        [allStatesJsonStringArrayForSync addObject:aStateJsonString];
    }
    
    return allStatesJsonStringArrayForSync;

}



-(NSArray*)createJsonStringsArray
{
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        ChallengeState *aScoreState = [[ChallengeState alloc]init];
        
        aScoreState.StatID = [[[teamStats objectAtIndex:i] valueForKey:@"ChStatID"]intValue];
        aScoreState.chStTeamID = [[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        aScoreState.chalStID = [[[teamStats objectAtIndex:i] valueForKey:@"ChallangeID"]intValue];
        aScoreState.chalStPlayerID = [[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"]intValue];
        aScoreState.chalStColName = [[teamStats objectAtIndex:i] valueForKey:@"column_name"];
        aScoreState.chalStColVal = [[teamStats objectAtIndex:i] valueForKey:@"column_val"];
        aScoreState.chalModDate = [[teamStats objectAtIndex:i] valueForKey:@"Date"];
        aScoreState.email_reportAdded = [[[teamStats objectAtIndex:i] valueForKey:@"email_reportAdded"] intValue];
        
        //        NSLog(@"Stat ID = %d",aScoreState.StatID);
        //        NSLog(@"Stat Team = %d",aScoreState.chStTeamID);
        //        NSLog(@"Stat ChallengeID = %d",aScoreState.chalStID);
        //        NSLog(@"Stat Player ID = %d",aScoreState.chalStPlayerID);
        //        NSLog(@"Stat ColName = %@",aScoreState.chalStColName);
        //        NSLog(@"Stat ColVal = %@",aScoreState.chalStColVal);
        
        NSString *aStateJsonString =  [self createJsonStringForState:aScoreState];
        
        [allStatesJsonStringArray addObject:aStateJsonString];
    }
    
    totalDataToSyncChal = (int)[allStatesJsonStringArray count];
    NSLog(@"challengestatecount, %d", totalDataToSyncChal);
    
    return allStatesJsonStringArray;
}

-(NSArray*)createJsonStringsArrayAttandanceForSync
{
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM playerattendance WHERE sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        Attandance *objAttandace = [[Attandance alloc]init];
        
        objAttandace.atdId=(int)[[[teamStats objectAtIndex:i] valueForKey:@"id"]integerValue];
        objAttandace.add_date=[[teamStats objectAtIndex:i] valueForKey:@"add_date"];
        objAttandace.attandance=[[[teamStats objectAtIndex:i] valueForKey:@"attendance"] intValue];
        objAttandace.attendanceDate=[[teamStats objectAtIndex:i] valueForKey:@"attendance_date"];
        objAttandace.playerId=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objAttandace.teamId=[[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        objAttandace.email_reportAdded = [[[teamStats objectAtIndex:i] valueForKey:@"email_reportAdded"] intValue];
        
        NSString *aStateJsonString =  [self createJsonStringForStateAttandaceForSync:objAttandace];
        NSLog(@"attendanceJsonString, %@", aStateJsonString);
        [allStatesJsonStringArrayAtdForSync addObject:aStateJsonString];
    }
    
    return allStatesJsonStringArrayAtdForSync;
}

-(NSArray*)createJsonStringsArrayAttandance
{
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM playerattendance WHERE sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        Attandance *objAttandace = [[Attandance alloc]init];
        
        objAttandace.atdId=(int)[[[teamStats objectAtIndex:i] valueForKey:@"id"]integerValue];
        objAttandace.add_date=[[teamStats objectAtIndex:i] valueForKey:@"add_date"];
        objAttandace.attandance=[[[teamStats objectAtIndex:i] valueForKey:@"attendance"] intValue];
        objAttandace.attendanceDate=[[teamStats objectAtIndex:i] valueForKey:@"attendance_date"];
        objAttandace.playerId=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objAttandace.teamId=[[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        objAttandace.email_reportAdded = [[[teamStats objectAtIndex:i] valueForKey:@"email_reportAdded"] intValue];
        
        NSString *aStateJsonString =  [self createJsonStringForStateAttandace:objAttandace];
        NSLog(@"attendanceJsonString, %@", aStateJsonString);
        [allStatesJsonStringArrayAtd addObject:aStateJsonString];
    }
    
    totalDataToSyncAtd = (int)[allStatesJsonStringArrayAtd count];
    
    NSLog(@"attendanceJson, %@", allStatesJsonStringArray);
    
    return allStatesJsonStringArrayAtd;
}

-(NSString*) createJsonStringForStateAttandace:(Attandance*)attandance;
{
    //convertAll Integer To String;
    NSString *atdId = [NSString stringWithFormat:@"%d",attandance.atdId];
    NSString *atandance = [NSString stringWithFormat:@"%d",attandance.attandance];
    NSString *teamId = [NSString stringWithFormat:@"%d",attandance.teamId];
    NSString *playerId = [NSString stringWithFormat:@"%d",attandance.playerId];
    NSString *add_date = [NSString stringWithFormat:@"%@",attandance.add_date];
    NSString *attandanceDate = [NSString stringWithFormat:@"%@",attandance.attendanceDate];
    NSString *email_reportAdded = [NSString stringWithFormat:@"%d", attandance.email_reportAdded];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:atdId,@"ID",
                                 atandance,@"attandace",teamId,@"TeamID",
                                 playerId,@"PlayerID",add_date,@"addDate",
                                 attandanceDate,@"Date",email_reportAdded,@"email_reportAdded", nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newStatInfo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    NSString *JsonFinalString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}

-(NSArray*)createJsonStringsArrayJournal
{
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM JournalData WHERE sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        Journal *objJournal = [[Journal alloc]init];
        objJournal.teamId=[[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        objJournal.playerId=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objJournal.journalId=[[[teamStats objectAtIndex:i] valueForKey:@"id"] intValue];
        objJournal.notes=[[teamStats objectAtIndex:i] valueForKey:@"notes"];
        objJournal.add_date=[[teamStats objectAtIndex:i] valueForKey:@"add_date"];
        
        NSString *aStateJsonString =  [self createJsonStringForStateJournal:objJournal];
        [allStatesJsonStringArrayJornal addObject:aStateJsonString];
    }
    
    totalDataToSyncJournal = (int)[allStatesJsonStringArrayJornal count];
    
    return allStatesJsonStringArrayJornal;
}


-(NSArray*)createJsonStringsArrayPlayer
{
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE sync=%d",1];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    //NSLog(@"New State are : %@",teamStats);
    
    
    
    for(int i=0;i<[teamStats count]; i++)
    {
        Player *objPlayer = [[Player alloc]init];
        objPlayer.TeamID=[[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        objPlayer.PlayerID=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objPlayer.BirthDate=[[teamStats objectAtIndex:i] valueForKey:@"BirthDate"] ;
        objPlayer.DEmail=[[teamStats objectAtIndex:i] valueForKey:@"DEmail"] ;
        //objPlayer.notes=[[teamStats objectAtIndex:i] valueForKey:@"Notes"];
        objPlayer.EmailDRpt=[[[teamStats objectAtIndex:i] valueForKey:@"EmailDRpt"] intValue];
        objPlayer.EmailMRpt=[[[teamStats objectAtIndex:i] valueForKey:@"EmailMRpt"] intValue];
        objPlayer.EmailPRpt=[[[teamStats objectAtIndex:i] valueForKey:@"EmailPRpt"] intValue];
        objPlayer.FirstName=[[teamStats objectAtIndex:i] valueForKey:@"FirstName"] ;
        objPlayer.Grade=[[teamStats objectAtIndex:i] valueForKey:@"Grade"];
        objPlayer.jercyNo=[[teamStats objectAtIndex:i] valueForKey:@"JourcyNo"];
        objPlayer.LastName=[[teamStats objectAtIndex:i] valueForKey:@"LastName"] ;
        objPlayer.MEmail=[[teamStats objectAtIndex:i] valueForKey:@"MEmail"];
        objPlayer.PEmail=[[teamStats objectAtIndex:i] valueForKey:@"PEmail"];
        objPlayer.Password=[[teamStats objectAtIndex:i] valueForKey:@"Password"] ;
        objPlayer.Photo=[[teamStats objectAtIndex:i] valueForKey:@"Photo"];
        objPlayer.Position=[[teamStats objectAtIndex:i] valueForKey:@"Position"];
        objPlayer.PlayerID=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objPlayer.UserName=[[teamStats objectAtIndex:i] valueForKey:@"UserName"];
        objPlayer.modified=[[teamStats objectAtIndex:i] valueForKey:@"modified"] ;
        objPlayer.UserLevel=[[[teamStats objectAtIndex:i] valueForKey:@"UserLevel"] intValue];

        NSString *aStateJsonString =  [self createJsonStringForStatePlayer:objPlayer];
        [allStatesJsonStringArrayPlayer addObject:aStateJsonString];
    }
    
    totalDataToSyncPlayer = (int)[allStatesJsonStringArrayPlayer count];
    
    return allStatesJsonStringArrayPlayer;
}


-(NSString*) createJsonStringForStateSync:(ChallengeState*)scoreStats;
{
    //convertAll Integer To String;
    NSString *newStatID = [NSString stringWithFormat:@"%d",scoreStats.StatID];
    NSString *stChallengeID = [NSString stringWithFormat:@"%d",scoreStats.chalStID];
    NSString *stTeamID = [NSString stringWithFormat:@"%d",scoreStats.chStTeamID];
    NSString *stPlayerID = [NSString stringWithFormat:@"%d",scoreStats.chalStPlayerID];
    NSString *stColumName = [NSString stringWithFormat:@"%@",scoreStats.chalStColName];
    NSString *stColumValue = [NSString stringWithFormat:@"%@",scoreStats.chalStColVal];
    NSString *stModeDate = [NSString stringWithFormat:@"%@",scoreStats.chalModDate];
    NSString *email_reportAdded = [NSString stringWithFormat:@"%d", scoreStats.email_reportAdded];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:newStatID,@"ID",
                                 stChallengeID,@"ChallengeID",stTeamID,@"TeamID",
                                 stPlayerID,@"PlayerID",stColumValue,@"column_val",
                                 stModeDate,@"Date",stColumName,@"column_name",email_reportAdded,@"email_reportAdded",
                                 nil];
    
//    NSString *JsonFinalString = [NSString stringWithFormat:@"%@", newStatInfo];
    
    NSString *JsonFinalString = [NSString stringWithFormat:@"\"TeamID\": %@; \"Date\": %@; \"PlayerID\": %@; \"ChallengeID\": %@; \"email_reportAdded\": %@; \"column_val\": %@; \"ID\": %@; \"column_name\": %@", stTeamID, stModeDate, stPlayerID, stChallengeID, email_reportAdded, stColumValue, newStatID, stColumName];
    
    NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}

-(NSString*) createJsonStringForStateAttandaceForSync:(Attandance*)attandance;
{
    //convertAll Integer To String;
    NSString *atdId = [NSString stringWithFormat:@"%d",attandance.atdId];
    NSString *atandance = [NSString stringWithFormat:@"%d",attandance.attandance];
    NSString *teamId = [NSString stringWithFormat:@"%d",attandance.teamId];
    NSString *playerId = [NSString stringWithFormat:@"%d",attandance.playerId];
    NSString *add_date = [NSString stringWithFormat:@"%@",attandance.add_date];
    NSString *attandanceDate = [NSString stringWithFormat:@"%@",attandance.attendanceDate];
    NSString *email_reportAdded = [NSString stringWithFormat:@"%d", attandance.email_reportAdded];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:atdId,@"ID",
                                 atandance,@"attandace",teamId,@"TeamID",
                                 playerId,@"PlayerID",add_date,@"addDate",
                                 attandanceDate,@"Date",email_reportAdded,@"email_reportAdded", nil];
    NSString *JsonFinalString = [NSString stringWithFormat:@"\"ID\": %@; \"attandace\": %@; \"TeamID\": %@; \"PlayerID\": %@; \"addDate\": %@; \"Date\": %@; \"email_reportAdded\": %@", atdId, atandance, teamId, playerId, add_date, attandanceDate, email_reportAdded];
    
    NSLog(@"FINAL JSON STRING Attendence = %@",JsonFinalString);
    return JsonFinalString;
}


-(NSString*) createJsonStringForState:(ChallengeState*)scoreStats;
{
    //convertAll Integer To String;
    NSString *newStatID = [NSString stringWithFormat:@"%d",scoreStats.StatID];
    NSString *stChallengeID = [NSString stringWithFormat:@"%d",scoreStats.chalStID];
    NSString *stTeamID = [NSString stringWithFormat:@"%d",scoreStats.chStTeamID];
    NSString *stPlayerID = [NSString stringWithFormat:@"%d",scoreStats.chalStPlayerID];
    NSString *stColumName = [NSString stringWithFormat:@"%@",scoreStats.chalStColName];
    NSString *stColumValue = [NSString stringWithFormat:@"%@",scoreStats.chalStColVal];
    NSString *stModeDate = [NSString stringWithFormat:@"%@",scoreStats.chalModDate];
    NSString *email_reportAdded = [NSString stringWithFormat:@"%d", scoreStats.email_reportAdded];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:newStatID,@"ID",
                                 stChallengeID,@"ChallengeID",stTeamID,@"TeamID",
                                 stPlayerID,@"PlayerID",stColumValue,@"column_val",
                                 stModeDate,@"Date",stColumName,@"column_name",email_reportAdded,@"email_reportAdded",
                                 nil];
   
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newStatInfo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
       //print out the data contents
    NSString *JsonFinalString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}


-(NSString*) acreateJsonStringForStateAttandace:(Attandance*)attandance;
{
    //convertAll Integer To String;
    NSString *atdId = [NSString stringWithFormat:@"%d",attandance.atdId];
    NSString *atandance = [NSString stringWithFormat:@"%d",attandance.attandance];
    NSString *teamId = [NSString stringWithFormat:@"%d",attandance.teamId];
    NSString *playerId = [NSString stringWithFormat:@"%d",attandance.playerId];
    NSString *add_date = [NSString stringWithFormat:@"%@",attandance.add_date];
    NSString *attandanceDate = [NSString stringWithFormat:@"%@",attandance.attendanceDate];
    NSString *email_reportAdded = [NSString stringWithFormat:@"%d", attandance.email_reportAdded];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:atdId,@"ID",
                                 atandance,@"attandace",teamId,@"TeamID",
                                 playerId,@"PlayerID",add_date,@"addDate",
                                 attandanceDate,@"Date",email_reportAdded,@"email_reportAdded", nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newStatInfo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    NSString *JsonFinalString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}

-(NSString*) createJsonStringForStateJournal:(Journal*)journal;
{
    //convertAll Integer To String;
    NSString *journalid=[NSString stringWithFormat:@"%d",journal.journalId];
    NSString *teamId=[NSString stringWithFormat:@"%d",journal.teamId];
    NSString *playerId=[NSString stringWithFormat:@"%d",journal.playerId];
    NSString *notes=[NSString stringWithFormat:@"%@",journal.notes];
    NSString *adddate=[NSString stringWithFormat:@"%@",journal.add_date];
    
    //    NSLog(@"NEW STAT ID : %d",scoreStats.StatID);
    //    NSLog(@"NEW CHALLENGE ID : %d",scoreStats.chalStID);
    //    NSLog(@"NEW TEAM ID : %d",scoreStats.chStTeamID);
    //    NSLog(@"NEW PLAYER ID : %d",scoreStats.chalStPlayerID);
    //    NSLog(@"NEW COLUM VALUE ID : %@",scoreStats.chalStColVal);
    //    NSLog(@"NEW COLUM NAME ID : %@",scoreStats.chalStColName);
    //    NSLog(@"NEW MOD DATE ID : %@",scoreStats.chalModDate);
    
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:journalid,@"id",teamId,@"TeamID",
                                 playerId,@"PlayerID",notes,@"notes",
                                 adddate,@"add_date",nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newStatInfo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    NSString *JsonFinalString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}


-(NSString*) createJsonStringForStatePlayer:(Player*)player;
{
    //convertAll Integer To String;
    NSString *teamID=[NSString stringWithFormat:@"%d",player.TeamID];
    NSString *birthDay=[NSString stringWithFormat:@"%@",player.BirthDate];
    NSString *demail=[NSString stringWithFormat:@"%@",player.DEmail];
    NSString *emailDrept=[NSString stringWithFormat:@"%d",player.EmailDRpt];
    NSString *emailMrept=[NSString stringWithFormat:@"%d",player.EmailMRpt];
    NSString *emailPrept=[NSString stringWithFormat:@"%d",player.EmailPRpt];
    NSString *firstName=[NSString stringWithFormat:@"%@",player.FirstName];
    NSString *grade=[NSString stringWithFormat:@"%@",player.Grade];
    NSString *jourcyNo=[NSString stringWithFormat:@"%@",player.jercyNo];
    NSString *lastName=[NSString stringWithFormat:@"%@",player.LastName];
    NSString *mEmail=[NSString stringWithFormat:@"%@",player.MEmail];
    NSString *notes=[NSString stringWithFormat:@"%@",player.Notes];
    NSString *pEmail=[NSString stringWithFormat:@"%@",player.PEmail];
    NSString *password=[NSString stringWithFormat:@"%@",player.Password];
    NSString *photo=[NSString stringWithFormat:@"%@",player.Photo];
    NSString *playerID=[NSString stringWithFormat:@"%d",player.PlayerID];
    NSString *position=[NSString stringWithFormat:@"%@",player.Position];
    NSString *userLevel=[NSString stringWithFormat:@"%d",player.UserLevel];
    NSString *userName=[NSString stringWithFormat:@"%@",player.UserName];
    NSString *phone=[NSString stringWithFormat:@"%@",player.Phone];
    
    //build an info object and convert to json
    NSDictionary* newStatInfo = [NSDictionary dictionaryWithObjectsAndKeys:teamID,@"TeamID",playerID,@"PlayerID",jourcyNo,@"Jersey",lastName,@"LastName",firstName,@"FirstName",grade,@"Grade",position,@"Position",birthDay,@"BirthDate",phone,@"Phone1",pEmail,@"PEmail",emailPrept,@"EmailPRpt",mEmail,@"MEmail",emailMrept,@"EmailMRpt",demail,@"DEmail",emailDrept,@"EmailDRpt",notes,@"Notes",userName,@"UserName",password,@"Password",userLevel,@"UserLevel",photo,@"Photo",nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newStatInfo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    NSString *JsonFinalString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"FINAL JSON STRING = %@",JsonFinalString);
    return JsonFinalString;
}

@end
