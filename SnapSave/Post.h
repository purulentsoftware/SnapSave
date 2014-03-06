//
//  Post.h
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Post : NSObject{
    BOOL sent;
    User *person;
    int status; //0=sent 1=delivered, 2=opened, 3=screenshot
    NSString *timeStamp;
    
}
-(id)initWithPerson:(User *)pers isSent:(BOOL)sen withStatus:(int)stat withTimeStamp:(NSString *)timeStam;
-(User *)getPerson;
-(BOOL)wasSent;
-(int)getStatus;
-(NSString *)getTimeStamp;
@end
