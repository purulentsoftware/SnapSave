//
//  ActivityViewController.m
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import "ActivityViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "User.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize activityTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
 del=[[UIApplication sharedApplication] delegate];
    friends=[del getFriendsArray];
    posts=[del getStatuses];
    activityTextView.delegate=self;
    activityTextView.dataSource=self;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [posts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text=[(User *)[(Post *)[posts objectAtIndex:indexPath.row] getPerson] getUSername];
    if([(Post *)[posts objectAtIndex:indexPath.row] wasSent]){
        switch ([[posts objectAtIndex:indexPath.row] getStatus]) {
            case 0:
                cell.detailTextLabel.text=@"Sent";
                break;
            case 1:
                cell.detailTextLabel.text=@"It was Delivered";
                break;
            case 2:
                cell.detailTextLabel.text=@"They Opened it";
                break;
            default:
                break;
        }
        
    }else{
        switch ([[posts objectAtIndex:indexPath.row] getStatus]) {
            case 0:
                cell.detailTextLabel.text=@"Sent";
                break;
            case 1:
                cell.detailTextLabel.text=@"You Recieved It";
                break;
            case 2:
                cell.detailTextLabel.text=@"You Opened It";
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(id)sender {
    UIImagePickerController *controler=[[UIImagePickerController alloc] init];
    controler.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controler animated:YES completion:NULL];
}
@end
