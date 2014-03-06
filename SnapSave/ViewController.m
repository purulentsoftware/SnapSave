//
//  ViewController.m
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "JSONDictionaryExtensions.h"
#import "AppDelegate.h"
#import "Post.h"
#import "SHWebService.h"
#import "Base64.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{   usernameField =[[UITextField alloc] initWithFrame:CGRectMake(0, 100, 320, 25)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(0, 150, 320, 25)];
    [passwordField
    setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordField setSecureTextEntry:true];
    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:CGRectMake(0, 200, 320, 55)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:usernameField];
    [self.view addSubview:passwordField];
    [self.view addSubview:loginButton];
    
    [super viewDidLoad];
   

	// Do any additional setup after loading the view, typically from a nib.
}
-(void)login{
    SHWebService *webs=[[SHWebService alloc] init];
    [webs start];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSData *imageData=[NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"untitled.png"])];
    
    
    NSString *imageString = [imageData base64EncodedString];
    
    
    
    [dict setObject:imageString forKey:@"data"];
    [webs runConnectionWithDict:dict toURL:[NSURL URLWithString:@"http://purulentsoftware.com/snaps/uploading.php"]];
    
    NSString *u=[NSString stringWithFormat:@"http://purulentsoftware.com/snaps/login.php?username=%@&pass=%@", [self URLEncodedString:usernameField.text ],[self URLEncodedString:passwordField.text ]];
    NSLog(@"%@",u);
    data=[[NSMutableData alloc] init];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:u]] delegate:self startImmediately:false];
    
    
    [conn start];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)datas{
    [data appendData:datas];
    NSLog(@"recieved");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"found");
    
    NSMutableDictionary *dictio=[[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithJSONData:data]];
    NSMutableDictionary *friendsDictionary=[[NSMutableDictionary alloc] init];
    NSMutableArray *friendsArray=[[NSMutableArray alloc] init];
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[dictio objectForKey:@"added_friends"]];
    NSMutableArray *posts=[[NSMutableArray alloc] initWithArray:[dictio objectForKey:@"snaps"]];
    //NSMutableArray *postsContainer=[[NSMutableArray a]];;
    NSLog(@"%d", [array count]);
    for (int i=0; i<[array count]; i++) {
        NSString *username=[[array objectAtIndex:i] objectForKey:@"name"];
        User *user=[[User alloc] initWithUSername:username];
        NSLog(@"user name: %@", [user getUSername]);
        [friendsArray addObject:user];
        [friendsDictionary setObject:user forKey:username];
    }
    for (int i=0; i<[posts count]; i++) {
        BOOL sent=false;
         NSString *username=@"";
        if([[posts objectAtIndex:i] objectForKey:@"rp"]!=nil){ //I sent it
            username=[[posts objectAtIndex:i] objectForKey:@"rp"];
            sent=true;
        }else{ //I recieved it
            
           username=[[posts objectAtIndex:i] objectForKey:@"sn"];
        }
    
        int status=[[[posts objectAtIndex:i] objectForKey:@"st"] intValue];
        NSString *timestamp=[[posts objectAtIndex:i] objectForKey:@"ts"];
        User *user=[friendsDictionary objectForKey:username]; //Could crash if not on friends list
        Post *post=[[Post alloc] initWithPerson:user isSent:sent withStatus:status withTimeStamp:timestamp];
        NSLog(@"key: %@ username: %@", username, [user getUSername]);
        
        [posts replaceObjectAtIndex:i withObject:post];
        
    }
    NSLog(@"Posts %d", [posts count]);
    
    AppDelegate *del=[[UIApplication sharedApplication] delegate];
    [del logedInWithUsername:usernameField.text withPassword:passwordField.text withFriends:friendsArray];
    [del setStatuses:posts];
    //[self removeFromSuperview];
    data=NULL;
    [self performSegueWithIdentifier:@"loginToActivity" sender:self];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"failed");
    data=NULL;
}
- (NSString *) URLEncodedString:(NSString *)string {
    NSMutableString * output = [NSMutableString string];
    const char * source = [string UTF8String];
    int sourceLen = strlen(source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = (const unsigned char)source[i];
        if (false && thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
