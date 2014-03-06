//
//  SHWebService.h
//  SHouT
//
//  Created by Chris Mays on 9/3/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol webserviceDelegate<NSObject>
-(void)didRecieveDataWithObject:(NSString*)object withData:(NSMutableDictionary*)data withErrors:(NSArray *)errors;
-(void)websServiceNetworkErrorOccured:(NSError *)error;
/*
    called when in background so UI doesn't get updated
 */
-(void)didRecieveDataInBackgroundWithObject:(NSString *)object withData:(NSMutableDictionary*)data withErrors:(NSArray *)errors;
@end
@interface SHWebService : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSURLConnection *connection;
    NSMutableData *data;
    BOOL checking;

}
@property(nonatomic,strong)id delegate;
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)pass;
-(void)postMessageWithLatitude:(double)latitude withLongitude:(double)longitude withMessage:(NSString *)message;
-(void)start;
-(void)checkDataWithLongitude:(double)longitude withLatitude:(double)latitude;
-(void)getCommentsForPostID:(NSString *)postID;
-(void)registerForShoutWithName:(NSString *)name withEmail:(NSString *)email withUsername:(NSString *)username withPassword:(NSString *)pass;
-(void)likePostWithPostID:(NSString*)postID;
-(void)runConnectionWithDict:(NSMutableDictionary *)dict toURL:(NSURL *)url;
@end
