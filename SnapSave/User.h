//
//  User.h
//  SnapchatDesktop
//
//  Created by Chris Mays on 11/24/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *username;
    
}
-(id)initWithUSername:(NSString *)usern;
-(NSString *)getUSername;

@end
