//
//  AppDelegate.h
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL loggedin;
    NSMutableArray *friendsArray;
    NSString *username;
    NSString *password;
    NSMutableArray *statusesArray;
}
-(void)logedInWithUsername:(NSString *)usern withPassword:(NSString *)pass withFriends:(NSMutableArray *)friends;
-(NSMutableArray *)getFriendsArray;
-(NSString *)getUsername;
-(NSString *)getPassword;
-(void)setStatuses:(NSMutableArray *)stat;
-(NSMutableArray *)getStatuses;
@property (strong, nonatomic) UIWindow *window;

@end
