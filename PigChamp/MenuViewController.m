//
//  MenuViewController.m
//  Sidebar
//
//  Created by Venturelabour on 15/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "ServerManager.h"
#import "CustomIOS7AlertView.h"
#import "ControlSettings.h"
#import "CoreDataHandler.h"

@interface MenuViewController ()
@end

@implementation MenuViewController

- (void)viewDidLoad {
   //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuBg"]];
    [super viewDidLoad];
    
    strNoInternet = @"You must be online for the app to function.";
    strOK = @"OK";
    strCancel = @"No";
    strSignOut = @"Are you sure you want to Logout?";
    strSignOff = @"Signing off.";
    strYes = @"Yes";
    strUnauthorised =@"Your session has been expired. Please login again.";
    strServerErr= @"Server Error.";
    
    categoryList = [[NSMutableArray alloc]initWithObjects:@"Data Entry",@"Reports",@"Search",@"Help",@"About",@"Logout",@"You must be online for the app to function.",@"OK",@"NO",@"are you sure you want to Logout?",@"Signing off.",@"Yes",@"Your session has been expired. Please login again.",@"Server Error.", nil];
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:categoryList];
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    if (resultArray1.count!=0) {
        for (int i=0; i<resultArray1.count; i++) {
            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
        }
    }
    
    [categoryList removeAllObjects];
    
     for (int i=0; i<14; i++) {
         if (i==0) {
             if ([dictMenu objectForKey:[@"Data Entry" uppercaseString]] && ![[dictMenu objectForKey:[@"Data Entry" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"Data Entry" uppercaseString]] englishVersion:@"Data Entry"];
             }
             else{
                 [categoryList addObject:@"Data Entry"];
             }
         }else  if (i==1){
             if ([dictMenu objectForKey:[@"Reports" uppercaseString]] && ![[dictMenu objectForKey:[@"Reports" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"Reports" uppercaseString]] englishVersion:@"Reports"];
             }
             else{
                 [categoryList addObject:@"Reports"];
             }
         }else  if (i==2){
             if ([dictMenu objectForKey:[@"Search" uppercaseString]] && ![[dictMenu objectForKey:[@"Search" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"Search" uppercaseString]] englishVersion:@"Search"];
             }
             else{
                 [categoryList addObject:@"Search"];
             }
         }else  if (i==3){
             if ([dictMenu objectForKey:[@"Help" uppercaseString]] && ![[dictMenu objectForKey:[@"Help" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"Help" uppercaseString]] englishVersion:@"Help"];
             }
             else{
                 [categoryList addObject:@"Help"];
             }
         }else  if (i==4){
             if ([dictMenu objectForKey:[@"About" uppercaseString]] && ![[dictMenu objectForKey:[@"About" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"About" uppercaseString]] englishVersion:@"About"];
             }
             else{
                 [categoryList addObject:@"About"];
             }
         }else  if (i==5){
             if ([dictMenu objectForKey:[@"Logout" uppercaseString]] && ![[dictMenu objectForKey:[@"Logout" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 [self addObject:[dictMenu objectForKey:[@"Logout" uppercaseString]] englishVersion:@"Logout"];
             }
             else{
                 [categoryList addObject:@"Logout"];
            }
         }else  if (i==6){
             if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                     strNoInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                 }
             }
         } else  if (i==7){
             if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                 if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                     strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                 }
             }
         }else  if (i==8){
             if ([dictMenu objectForKey:[@"No" uppercaseString]] && ![[dictMenu objectForKey:[@"No" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"No" uppercaseString]] length]>0) {
                     strCancel = [dictMenu objectForKey:[@"No" uppercaseString]]?[dictMenu objectForKey:[@"No" uppercaseString]]:@"";
                 }
             }
         }else  if (i==9){
             if ([dictMenu objectForKey:[@"Are you sure you want to Logout?" uppercaseString]] && ![[dictMenu objectForKey:[@"Are you sure you want to Logout?" uppercaseString]] isKindOfClass:[NSNull class]]){
                 if ([[dictMenu objectForKey:[@"Are you sure you want to Logout?" uppercaseString]] length]>0){
                     strSignOut = [dictMenu objectForKey:[@"Are you sure you want to Logout?" uppercaseString]]?[dictMenu objectForKey:[@"Are you sure you want to Logout?" uppercaseString]]:@"";
                 }
             }
         }else  if (i==10){
             if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                     strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                 }
             }
         }else  if (i==11){
             if ([dictMenu objectForKey:[@"Yes" uppercaseString]] && ![[dictMenu objectForKey:[@"Yes" uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"Yes" uppercaseString]] length]>0) {
                     strYes = [dictMenu objectForKey:[@"Yes" uppercaseString]]?[dictMenu objectForKey:[@"Yes" uppercaseString]]:@"";
                 }
             }
         }else  if (i==12){
             if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                     strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                 }
             }
         }else  if (i==13){
             if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                 if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                     strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                 }
             }
         }
    }
}

-(void)addObject:(NSString*)object englishVersion:(NSString*)englishVersion{
    @try {
        if (object.length!=0) {
            [categoryList addObject:object];
        }
        else{
            [categoryList addObject:englishVersion];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception ion addObject=%@",exception.description);
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    @try {
        [super viewWillAppear:YES];
        self.title = @"PigCHAMP";
        self.lblFarm.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"];
        self.lblUserName.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewWillAppear =%@",exception.description);
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    @try
    {
        [super viewDidLayoutSubviews];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in willRotateToInterfaceOrientation:%@",exception.description);
    }
}


-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLayoutSubviews in ViewController=%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [categoryList count];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfRowsInSection=%@",exception.description);
    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    @try {
//        
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"Exception =%@",exception.description);
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        
        if (cell ==nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
        }
        
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:157.0/255.0 blue:152.0/255.0 alpha:.5];
        cell.selectedBackgroundView =  customColorView;

        UILabel *lblDetails = (UILabel*)[cell viewWithTag:12];
        lblDetails.text = [categoryList objectAtIndex:indexPath.row];
        
        UILabel *lblLine = (UILabel*)[cell viewWithTag:5];

        if (indexPath.row==0) {
            lblLine.hidden = NO;
        }
        else {
            lblLine.hidden = YES;
         }
        
        UIImageView *img = (UIImageView*)[cell viewWithTag:1];
      
        if (indexPath.row==5) {
            lblDetails.textColor =[UIColor colorWithRed:145.0/255.0 green:47.0/255.0 blue:43.0/255.0 alpha:1];
            img.image = [UIImage imageNamed:@"logout"];
        }
        else {
            lblDetails.textColor =[UIColor darkGrayColor];
            img.image = [UIImage imageNamed:@"arrowCircle"];
        }
        
        return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in cellForRowAtIndexPath = %@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
    //    bundle: nil];
    [self.view removeFromSuperview];
   // [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    
    UIViewController *vc;

    if (indexPath.row==0){
       vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueDataEntry"];
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }else if (indexPath.row==1){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueReport"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseOverlay" object:nil];
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }
   else if (indexPath.row==2) {
       vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueSearch"];
       [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                        andCompletion:nil];
   }
   else if (indexPath.row==3) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueHelp"];
       [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                        andCompletion:nil];
   }
   else if (indexPath.row==4) {
       vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueAbout"];
       [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                        andCompletion:nil];
   }else if (indexPath.row==5){
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                   message:strSignOut
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:strCancel
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:@"Cancel"];
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             }];
       
                             UIAlertAction *yes = [UIAlertAction
                             actionWithTitle:strYes
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 if ([[ControlSettings sharedSettings] isNetConnected ]){
                                     _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                     [_customIOS7AlertView showLoaderWithMessage:strSignOff];
                                     
                                     [ServerManager sendRequestForLogout:^(NSString *responseData) {
                                         NSLog(@"%@",responseData);
                                         [_customIOS7AlertView close];
                                         
                                         if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
                                             
                                         }else if ([responseData isEqualToString:@"\"Loged out\""] || [responseData isEqualToString:@""]){
                                            [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                         }
                                     } onFailure:^(NSString *responseData, NSError *error) {
                                         id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                         NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                                         [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                         NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                                         
                                         NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On log out=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
                                         [tracker set:kGAIScreenName value:strErr];
                                         [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

                                         
                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:responseData];
                                         [_customIOS7AlertView close];
                                     }];
                                 }
                                 else {
                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                message:strNoInternet
                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction* ok = [UIAlertAction
                                                          actionWithTitle:strOK
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
                                     
                                     [myAlertController addAction: ok];
                                     [self presentViewController:myAlertController animated:YES completion:nil];
                                 }
                                 
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [myAlertController addAction: cancel];
        [myAlertController addAction: yes];

       [[SlideNavigationController sharedInstance] presentViewController:myAlertController animated:YES completion:^{
           
       }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
