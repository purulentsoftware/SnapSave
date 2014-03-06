//
//  SHWebService.m
//  SHouT
//
//  Created by Chris Mays on 9/3/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import "SHWebService.h"
#import "JSONDictionaryExtensions.h"
@implementation SHWebService
@synthesize delegate;
-(void)start{
    checking=false;
}
-(void)checkDataWithLongitude:(double)longitude withLatitude:(double)latitude{
    if(!checking){
        checking=true;
        data=[[NSMutableData alloc] init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        if([UIApplication sharedApplication].applicationState==UIApplicationStateBackground){
            [self runConnectionInBackgroundWithDict:[self createDataForRequestWithInformation:dict] toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/gpsDistance.php"]];

        }else{
            [self runConnectionWithDict:[self createDataForRequestWithInformation:dict] toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/gpsDistance.php"]];
        }
    NSLog(@"Making request");
    }
    
}
-(NSMutableDictionary *)createDataForRequestWithInformation:(NSMutableDictionary *)diction{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *allData=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *login=[[NSMutableDictionary alloc] init];
    [login setObject:[defaults objectForKey:@"Username"]   forKey:@"Username"];
    [login setObject:[defaults objectForKey:@"Token"]   forKey:@"Token"];

    [allData setObject:login forKey:@"loginInformation"];
    [allData setObject:diction forKey:@"data"];

    return allData;
}
-(void)postMessageWithLatitude:(double)latitude withLongitude:(double)longitude withMessage:(NSString *)message{
    
    data=[[NSMutableData alloc] init];
   
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [dict setObject:message forKey:@"message"];
    

    [self runConnectionWithDict:[self createDataForRequestWithInformation:dict] toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/postMessage.php"]];
    NSString* st=[NSString stringWithUTF8String:[[[[self createDataForRequestWithInformation:dict] copy] JSONValue] bytes]];
    NSLog(@"Making post request %@", st);
}
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)pass{
    if(!checking){
        checking=true;
        data=[[NSMutableData alloc] init];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:username forKey:@"Username"];
        [dict setObject:pass forKey:@"Password"];
        [self runConnectionWithDict:dict toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/loginVerificationiPhone.php"]];
        NSLog(@"Making request");
    }

}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1{
    NSLog(@"reciever");
    [data appendData:data1];
}
-(void)getCommentsForPostID:(NSString *)postID{
    if(!checking){
        checking=true;
        data=[[NSMutableData alloc] init];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:postID forKey:@"postID"];
        
        [self runConnectionWithDict:[self createDataForRequestWithInformation:dict] toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/viewComments.php"]];
        NSLog(@"Making request");
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
   
    //[self handleDataWithData:data];
    data=NULL;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    checking=false;
    NSLog(@"failed");
    NSLog(@"%@", error);
    data=NULL;
    [delegate websServiceNetworkErrorOccured:error];

}
-(void)runConnectionWithDict:(NSMutableDictionary *)dict toURL:(NSURL *)url{
   
    
    
    
    NSData *jdata=[[dict copy] JSONValue];
    NSString *postLength=[NSString stringWithFormat:@"%d", [jdata length]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
  [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   [request setHTTPBody:jdata];

    connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}
-(void)handleDataWithData:(NSData*)handleData{
    if(handleData!=NULL){
        
        //NSLog(@"recieved %@", [NSString stringWithUTF8String: [handleData bytes]]);
        checking=false;
        NSMutableDictionary *dictio=[[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithJSONData:handleData]];
        if([UIApplication sharedApplication].applicationState==UIApplicationStateBackground){
            [delegate didRecieveDataInBackgroundWithObject:[dictio objectForKey:@"objectType"] withData:dictio withErrors:[dictio objectForKey:@"errors"]];

        }else{
            [delegate didRecieveDataWithObject:[dictio objectForKey:@"objectType"] withData:dictio withErrors:[dictio objectForKey:@"errors"]];
        }
        }else{
        NSLog(@"Data null");
    }
    
  
}
/***
    Inspired by http://www.mindsizzlers.com/2011/07/ios-background-location/
 
 
 */
-(void)runConnectionInBackgroundWithDict:(NSMutableDictionary *)dict toURL:(NSURL *)url{
    
    UIBackgroundTaskIdentifier identifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
        
    }];
    NSData *jdata=[[dict copy] JSONValue];
    NSString *postLength=[NSString stringWithFormat:@"%d", [jdata length]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jdata];
    NSError *error;
    NSData *datas=[NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    if(error){
        NSLog(@"%@", error);
    }
    /*
        Fixed glitch, when network connection was not available in background the app would crash
     
     */
    if(data!=NULL){
        NSLog(@"%@", [NSString stringWithUTF8String:[datas bytes]]);
        [self handleDataWithData:datas];
    }
    if(identifier!=UIBackgroundTaskInvalid){
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }
    
}
-(void)registerForShoutWithName:(NSString *)name withEmail:(NSString *)email withUsername:(NSString *)username withPassword:(NSString *)pass{
    if(!checking){
        data=[[NSMutableData alloc] init];

        checking=true;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:name forKey:@"Name"];
    [dict setObject:email forKey:@"Email"];
    [dict setObject:username forKey:@"Username"];
    [dict setObject:pass forKey:@"Password"];
    [self runConnectionWithDict:dict toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/register.php"]];
    }
    
    
}
-(void)likePostWithPostID:(NSString*)postID{
    if(!checking){
        checking=true;
        data=[[NSMutableData alloc] init];

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];

    [dict setObject:postID forKey:@"postID"];
    [self runConnectionWithDict:[self createDataForRequestWithInformation:dict] toURL:[NSURL URLWithString:@"https://php.radford.edu/~cmays2/SE/likePressed.php"]];
    }
}
@end
