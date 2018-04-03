//
//  DataEntryViewController.m
//  PigChamp
//
//  Created by Venturelabour on 20/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "DataEntryViewController.h"
#import "MenuViewController.h"
#import "DataEntrySubMenuViewController.h"
#import "SettingsViewController.h"
#import "CoreDataHandler.h"

//BOOL isyes = NO;
BOOL isOpenDataEntry = NO;

NSString *strDataTitle,*strMenuTitle;

@interface DataEntryViewController ()
@end

@implementation DataEntryViewController

- (void)viewDidLoad {
    @try {
        self.navigationItem.hidesBackButton = YES;
        self.navigationController.navigationBar.translucent = NO;

        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        self.title = @"Data Entry";
        [super viewDidLoad];
        
//        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Data Entry",nil]];
//       
//        if (resultArray1.count>0) {
//            if (![[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] isKindOfClass:[NSNull class]]){
//                if ([[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] length]>0){
//                    self.title = [[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]?[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]:@"";
//                }
//            }
//        }
        
        strOK = @"OK";
        strUnauthorised = @"Your session has been expired. Please login again.";
        strServerErr  = @"Server Error.";
        
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"OK",@"Your session has been expired. Please login again.",@"Server Error.",@"Data Entry",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1.count!=0){
            for (int i=0; i<resultArray1.count; i++) {
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<4; i++) {
                if (i==0){
                    if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                        if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                            strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==1){
                    if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                            strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==2){
                    if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                            strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"Data Entry" uppercaseString]] && ![[dictMenu objectForKey:[@"Data Entry" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Data Entry" uppercaseString]] length]>0) {
                            self.title = [dictMenu objectForKey:[@"Data Entry" uppercaseString]]?[dictMenu objectForKey:[@"Data Entry" uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
        
        UIButton *button1  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        //[button1 addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    }
    @catch (NSException *exception) {
        
      NSLog(@"Exception in viewDidLoad in DataEntry =%@",exception.description);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    SlideNavigationController *sld = [SlideNavigationController sharedInstance];
    sld.delegate = self;
    isOpenDataEntry = NO;

    arrDataEntryMenu = [[NSMutableArray alloc]initWithObjects:@"Arrival Department",@"Departures",@"Mating Department",@"Farrowing Department",@"Health/Treatments",@"Miscellaneous",@"Notes/Flags",@"Data Entry",@"PigCHAMP", nil];//(Culls, Sales, Deaths & Transfers)
    strMenuTitle=@"PigCHAMP";
    strDataTitle = @"Data Entry";
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrDataEntryMenu];
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    if (resultArray1.count!=0) {
        for (int i=0; i<resultArray1.count; i++){
            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
        }
    }
    
    [arrDataEntryMenu removeAllObjects];
    
    for (int i=0; i<9; i++){
        if (i==0) {
            if ([dictMenu objectForKey:[@"Arrival Department" uppercaseString]] && ![[dictMenu objectForKey:[@"Arrival Department" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Arrival Department" uppercaseString]]?[dictMenu objectForKey:[@"Arrival Department" uppercaseString]]:@"" englishVersion:@"Arrival Department"];
            }
            else{
                [arrDataEntryMenu addObject:@"Arrival Department"];
            }
        }else  if (i==1){
            if ([dictMenu objectForKey:[@"Departures" uppercaseString]] && ![[dictMenu objectForKey:[@"Departures" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Departures" uppercaseString]]?[dictMenu objectForKey:[@"Departures" uppercaseString]]:@"" englishVersion:@"Departures"];
            }
            else{
                [arrDataEntryMenu addObject:@"Departures"];
            }
        }else  if (i==2){
            if ([dictMenu objectForKey:[@"Mating Department" uppercaseString]] && ![[dictMenu objectForKey:[@"Mating Department" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Mating Department" uppercaseString]]?[dictMenu objectForKey:[@"Mating Department" uppercaseString]]:@"" englishVersion:@"Mating Department"];
            }
            else{
                [arrDataEntryMenu addObject:@"Mating Department"];
            }
        }else  if (i==3){
            if ([dictMenu objectForKey:[@"Farrowing Department" uppercaseString]] && ![[dictMenu objectForKey:[@"Farrowing Department" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Farrowing Department" uppercaseString]]?[dictMenu objectForKey:[@"Farrowing Department" uppercaseString]]:@"" englishVersion:@"Farrowing Department"];
            }
            else{
                [arrDataEntryMenu addObject:@"Farrowing Department"];
            }
        }else  if (i==4){
            if ([dictMenu objectForKey:[@"Health/Treatments" uppercaseString]] && ![[dictMenu objectForKey:[@"Health/Treatments" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Health/Treatments" uppercaseString]]?[dictMenu objectForKey:[@"Health/Treatments" uppercaseString]]:@"" englishVersion:@"Health/Treatments" ];
            }
            else{
                [arrDataEntryMenu addObject:@"Health/Treatments"];
            }
        }else  if (i==5){
            if ([dictMenu objectForKey:[@"Miscellaneous" uppercaseString]] && ![[dictMenu objectForKey:[@"Miscellaneous" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Miscellaneous" uppercaseString]]?[dictMenu objectForKey:[@"Miscellaneous" uppercaseString]]:@"" englishVersion:@"Miscellaneous"];
            }
            else{
                [arrDataEntryMenu addObject:@"Miscellaneous"];
            }
        }else  if (i==6){
            if ([dictMenu objectForKey:[@"Notes/Flags" uppercaseString]] && ![[dictMenu objectForKey:[@"Notes/Flags" uppercaseString]] isKindOfClass:[NSNull class]]) {
                [self addObject:[dictMenu objectForKey:[@"Notes/Flags" uppercaseString]]?[dictMenu objectForKey:[@"Notes/Flags" uppercaseString]]:@"" englishVersion:@"Notes/Flags" ];
            }
            else{
                [arrDataEntryMenu addObject:@"Notes/Flags"];
            }
        }else  if (i==7){
            if ([dictMenu objectForKey:[@"Data Entry" uppercaseString]] && ![[dictMenu objectForKey:[@"Data Entry" uppercaseString]] isKindOfClass:[NSNull class]]) {
                if ([[dictMenu objectForKey:[@"Data Entry" uppercaseString]] length]>0) {
                   self.title = [dictMenu objectForKey:[@"Data Entry" uppercaseString]]?[dictMenu objectForKey:[@"Data Entry" uppercaseString]]:@"";
                    strDataTitle = [dictMenu objectForKey:[@"Data Entry" uppercaseString]]?[dictMenu objectForKey:[@"Data Entry" uppercaseString]]:@"";

                }
            }
        }else  if (i==8){
            if ([dictMenu objectForKey:[@"PigCHAMP" uppercaseString]] && ![[dictMenu objectForKey:[@"PigCHAMP" uppercaseString]] isKindOfClass:[NSNull class]]) {
                if ([[dictMenu objectForKey:[@"PigCHAMP" uppercaseString]] length]>0) {
                    strMenuTitle = [dictMenu objectForKey:[@"PigCHAMP" uppercaseString]]?[dictMenu objectForKey:[@"PigCHAMP" uppercaseString]]:@"";
                }
            }
        }
    }
    
    self.vwContaner.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenDataEntry) {
            self.vwOverlay.hidden = NO;
            [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            [currentWindow addSubview:tlc.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            }];
        }else {
            self.vwOverlay.hidden = YES;
            [tlc.view removeFromSuperview];
        }
        
        isOpenDataEntry = !isOpenDataEntry;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

-(void)removeView:(NSNotification *) notification {
    @try {
        NSDictionary *userInfo = notification.object;
        NSString *responseData =(NSString*) userInfo;
        
        if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:responseData
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)                                                              {
                                     [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else if (responseData.integerValue ==401) {
            
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strUnauthorised
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else if ([responseData isEqualToString:@""]){
            [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
        }else if (![responseData isEqualToString:@"Cancel"]) {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strServerErr
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }

        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.vwOverlay.hidden = YES;
        isOpenDataEntry = !isOpenDataEntry;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

-(void)addObject:(NSString*)object englishVersion:(NSString*)englishVersion{
    @try {
        if (object.length!=0) {
            [arrDataEntryMenu addObject:object];
        }
        else{
            [arrDataEntryMenu addObject:englishVersion];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in addObject=%@",exception.description);
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrDataEntryMenu count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        UITableViewCell * cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataDeparture"];
        
        if (cell ==nil){
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataDeparture"];
        }
        
        UILabel *lblDetails = (UILabel*)[cell viewWithTag:2];
        lblDetails.text = [arrDataEntryMenu objectAtIndex:indexPath.row];
        
        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath=%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        slectedRow = indexPath.row;
        //if (indexPath.row==0)
        {
            [self performSegueWithIdentifier:@"segueDataEntrySubMenu" sender:self];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in didSelectRowAtIndexPath =%@",exception.description);
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

#pragma mark - prepareForSegue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    @try {
        NSString *strIndex = [NSString stringWithFormat:@"%ld",(long)slectedRow];
      //  NSLog(@"%@",strIndex);
    
        DataEntrySubMenuViewController *dataEntrySubMenuViewController = segue.destinationViewController;
        
        if (slectedRow==1){
            dataEntrySubMenuViewController.strDataEntrySubMenu = [arrDataEntryMenu objectAtIndex:slectedRow];
        }
        else{
            dataEntrySubMenuViewController.strDataEntrySubMenu = [arrDataEntryMenu objectAtIndex:slectedRow];
        }

         dataEntrySubMenuViewController.countMenu = strIndex;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in prepareForSegue in FarmSelection =%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
