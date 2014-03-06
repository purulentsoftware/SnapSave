//
//  ActivityViewController.h
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ActivityViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *friends;
    NSMutableArray *posts;
    AppDelegate *del;
}
@property (weak, nonatomic) IBOutlet UITableView *activityTextView;
- (IBAction)cameraButtonPressed:(id)sender;

@end
