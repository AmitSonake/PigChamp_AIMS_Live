//
//  DataEntrySubMenuViewController.m
//  PigChamp
//
//  Created by Venturelabour on 27/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "DataEntrySubMenuViewController.h"
#import "DynamicFormViewController.h"
#import "SettingsViewController.h"
#import "CoreDataHandler.h"

BOOL isOpen = NO;

@interface DataEntrySubMenuViewController ()
@end

@implementation DataEntrySubMenuViewController
@synthesize strDataEntrySubMenu;
@synthesize countMenu;

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];

        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Data entry sub menu"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem=barButton;
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        
        //[button1 addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        arrMenu = [[NSMutableArray alloc]init];
        arrEventCode = [[NSMutableArray alloc]init];
        
        strOK = @"OK";
        strUnauthorised = @"Your session has been expired. Please login again.";
        strServerErr  = @"Server Error.";
        
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"OK",@"Your session has been expired. Please login again.",@"Server Error.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1.count!=0){
            for (int i=0; i<resultArray1.count; i++) {
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<3; i++) {
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
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad =%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
  @try {
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

       if (!isOpen) {
            UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
            self.vwOverlay.hidden = NO;
            [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            [currentWindow addSubview:tlc.view];
           
            [UIView animateWithDuration:0.3 animations:^{
                [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            }];
        }
        else{
            self.vwOverlay.hidden = YES;
            [tlc.view removeFromSuperview];
        }
        
        isOpen = !isOpen;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

-(void)removeView:(NSNotification *) notification{
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
        }
//        else{
//            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                       message:strServerErr
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:strOK
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action) {
//                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                 }];
//            
//            [myAlertController addAction: ok];
//            [self presentViewController:myAlertController animated:YES completion:nil];
//        }

        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.vwOverlay.hidden = YES;
        isOpen = !isOpen;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
//
//    return YES;
//}
//

//-(void)toggleButton{
//    @try {
//        
//        
//       
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"Exception in toggleButton=%@",exception.description);
//    }
//}

//- (IBAction)btnMenu_tapped:(id)sender {
//    
//    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
//       // self.vwOverlay.hidden = YES;
//        [self.slidingViewController resetTopViewAnimated:YES];
//        self.slidingViewController.title = @"About";
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(-20, 0, 22, 22);
//        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//        [barButton setCustomView:button];
//        self.slidingViewController.navigationItem.leftBarButtonItem=barButton;
//        self.slidingViewController.navigationItem.rightBarButtonItem=nil;
//        self.slidingViewController.navigationItem.hidesBackButton=YES;
//        
//    }
//    else {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(-20, 0, 22, 22);
//        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//        [barButton setCustomView:button];
//        self.slidingViewController.navigationItem.rightBarButtonItem=barButton;
//        self.slidingViewController.navigationItem.leftBarButtonItem=nil;
//        self.slidingViewController.navigationItem.hidesBackButton=YES;
//        
//        self.slidingViewController.title = @"PigCHAMP";
//        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"PigCHAMP",nil]];
//        if (resultArray1.count>0) {
//            if (![[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] isKindOfClass:[NSNull class]]){
//                if ([[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] length]>0){
//                    self.slidingViewController.title = [[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]?[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]:@"";
//                }
//            }
//        }
//        
//       // self.vwOverlay.hidden = NO;
//        [self.slidingViewController anchorTopViewToRightAnimated:YES];
//    }
//    
//    [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
//}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        [super viewWillAppear:YES];
        isOpen = NO;
        self.title = strDataEntrySubMenu;
       // NSLog(@"strDataEntrySubMenu=%@ , Lenth=%lu",strDataEntrySubMenu,strDataEntrySubMenu.length);

        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FromSetting"];
        NSMutableArray *arrMenuAforeTrnslation = [[NSMutableArray alloc]init];
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];

       // NSLog(@"_countMenu=%@",countMenu);
        [arrMenu removeAllObjects];
        
        if ([countMenu isEqualToString:@"0"]) {
            [arrMenu addObject:@"Semen Purchase"];
            [arrMenu addObject:@"Boar Arrival"];
            [arrMenu addObject:@"Gilt Arrival"];
            [arrMenu addObject:@"Gilt Retained"];
            [arrMenu addObject:@"Sow Arrival"];
            [arrMenu addObject:@"Batch Gilt Arrival"];

            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            
            if (resultArray1.count!=0) {
                [arrMenuAforeTrnslation removeAllObjects];
                
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [arrMenu removeAllObjects];

            for (int i=0; i<6; i++) {
                if (i==0) {
                    if ([dictMenu objectForKey:[@"Semen Purchase" uppercaseString]] && ![[dictMenu objectForKey:[@"Semen Purchase" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Semen Purchase" uppercaseString]]?[dictMenu objectForKey:[@"Semen Purchase" uppercaseString]]:@"" englishVersion:@"Semen Purchase"];
                    }
                    else{
                        [arrMenu addObject:@"Semen Purchase"];
                    }
                }else  if (i==1){
                    if ([dictMenu objectForKey:[@"Boar Arrival" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Arrival" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Boar Arrival" uppercaseString]]?[dictMenu objectForKey:[@"Boar Arrival" uppercaseString]]:@"" englishVersion:@"Boar Arrival"];
                    }
                    else{
                        [arrMenu addObject:@"Boar Arrival"];
                    }
                }else  if (i==2){
                    if ([dictMenu objectForKey:[@"Gilt Arrival" uppercaseString]] && ![[dictMenu objectForKey:[@"Gilt Arrival" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Gilt Arrival" uppercaseString]]?[dictMenu objectForKey:[@"Gilt Arrival" uppercaseString]]:@"" englishVersion:@"Gilt Arrival"];
                    }
                    else{
                        [arrMenu addObject:@"Gilt Arrival"];
                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"Gilt Retained" uppercaseString]] && ![[dictMenu objectForKey:[@"Gilt Retained" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Gilt Retained" uppercaseString]]?[dictMenu objectForKey:[@"Gilt Retained" uppercaseString]]:@"" englishVersion:@"Gilt Retained"];
                    }
                    else{
                        [arrMenu addObject:@"Gilt Retained"];
                    }
                }else  if (i==4){
                    if ([dictMenu objectForKey:[@"Sow Arrival" uppercaseString]] && ![[dictMenu objectForKey:[@"Sow Arrival" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Sow Arrival" uppercaseString]]?[dictMenu objectForKey:[@"Sow Arrival" uppercaseString]]:@"" englishVersion:@"Sow Arrival"];
                    }
                    else{
                        [arrMenu addObject:@"Sow Arrival"];
                    }
                }else  if (i==5){
                    if ([dictMenu objectForKey:[@"Batch Gilt Arrival" uppercaseString]] && ![[dictMenu objectForKey:[@"Batch Gilt Arrival" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        [self addObject:[dictMenu objectForKey:[@"Batch Gilt Arrival" uppercaseString]]?[dictMenu objectForKey:[@"Batch Gilt Arrival" uppercaseString]]:@"" englishVersion:@"Batch Gilt Arrival"];
                    }
                    else{
                        [arrMenu addObject:@"Batch Gilt Arrival"];
                    }
                }
            }
         }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"1"];
            [arrEventCode addObject:@"2"];
            [arrEventCode addObject:@"4"];
            [arrEventCode addObject:@"5"];
            [arrEventCode addObject:@"6"];
            [arrEventCode addObject:@"8"];
        }else if ([countMenu isEqualToString:@"1"]) {
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Female Death"];
            [arrMenu addObject:@"Boar Death"];
            [arrMenu addObject:@"Female Sale"];
            [arrMenu addObject:@"Boar Sale"];
            [arrMenu addObject:@"Female Transfer"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            if (resultArray1.count!=0) {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<6; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Female Death" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Death" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Death" uppercaseString]]?[dictMenu objectForKey:[@"Female Death" uppercaseString]]:@"" englishVersion:@"Female Death"];
                        }
                        else{
                            [arrMenu addObject:@"Female Death"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Boar Death" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Death" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Death" uppercaseString]]?[dictMenu objectForKey:[@"Boar Death" uppercaseString]]:@"" englishVersion:@"Boar Death"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Death"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Female Sale" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Sale" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Sale" uppercaseString]]?[dictMenu objectForKey:[@"Female Sale" uppercaseString]]:@"" englishVersion:@"Female Sale"];
                        }
                        else{
                            [arrMenu addObject:@"Female Sale"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Boar Sale" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Sale" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Sale" uppercaseString]] englishVersion:@"Boar Sale"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Sale"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Female Transfer" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Transfer" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Transfer" uppercaseString]]?[dictMenu objectForKey:[@"Female Transfer" uppercaseString]]:@"" englishVersion:@"Female Transfer"];
                        }
                        else{
                            [arrMenu addObject:@"Female Transfer"];
                        }
                    }
                }
            }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"11"];
            [arrEventCode addObject:@"10"];
            [arrEventCode addObject:@"13"];
            [arrEventCode addObject:@"12"];
            [arrEventCode addObject:@"44"];
        }else if ([countMenu isEqualToString:@"2"])
        {
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Abortion"];
            [arrMenu addObject:@"Boar Group Creation"];
            [arrMenu addObject:@"Boar Joining Boar Group"];
            [arrMenu addObject:@"Boar Leaving Boar Group"];
            [arrMenu addObject:@"Gilt Made Available"];
            [arrMenu addObject:@"Mating"];
            [arrMenu addObject:@"Observed Heat"];
            [arrMenu addObject:@"Pregnancy Check Result"];
            [arrMenu addObject:@"Semen Collection"];
            //
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            
            if (resultArray1.count!=0)
            {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<9; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Abortion" uppercaseString]] && ![[dictMenu objectForKey:[@"Abortion" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Abortion" uppercaseString]]?[dictMenu objectForKey:[@"Abortion" uppercaseString]]:@"" englishVersion:@"Abortion"];
                        }
                        else{
                            [arrMenu addObject:@"Abortion"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Boar Group Creation" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Group Creation" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Group Creation" uppercaseString]]?[dictMenu objectForKey:[@"Boar Group Creation" uppercaseString]]:@"" englishVersion:@"Boar Group Creation"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Group Creation"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Boar Joining Boar Group" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Joining Boar Group" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Joining Boar Group" uppercaseString]]?[dictMenu objectForKey:[@"Boar Joining Boar Group" uppercaseString]]:@"" englishVersion:@"Boar Joining Boar Group"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Joining Boar Group"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Boar Leaving Boar Group" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Leaving Boar Group" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Leaving Boar Group" uppercaseString]]?[dictMenu objectForKey:[@"Boar Leaving Boar Group" uppercaseString]]:@"" englishVersion:@"Boar Leaving Boar Group"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Leaving Boar Group"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Gilt Made Available" uppercaseString]] && ![[dictMenu objectForKey:[@"Gilt Made Available" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Gilt Made Available" uppercaseString]]?[dictMenu objectForKey:[@"Gilt Made Available" uppercaseString]]:@"" englishVersion:@"Gilt Made Available"];
                        }
                        else{
                            [arrMenu addObject:@"Gilt Made Available"];
                        }
                    }else  if (i==5){
                        if ([dictMenu objectForKey:[@"Mating" uppercaseString]] && ![[dictMenu objectForKey:[@"Mating" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Mating" uppercaseString]]?[dictMenu objectForKey:[@"Mating" uppercaseString]]:@"" englishVersion:@"Mating"];
                        }
                        else{
                            [arrMenu addObject:@"Mating"];
                        }
                    }else  if (i==6){
                        if ([dictMenu objectForKey:[@"Observed Heat" uppercaseString]] && ![[dictMenu objectForKey:[@"Observed Heat" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Observed Heat" uppercaseString]]?[dictMenu objectForKey:[@"Observed Heat" uppercaseString]]:@"" englishVersion:@"Observed Heat"];
                        }
                        else{
                            [arrMenu addObject:@"Observed Heat"];
                        }
                    }else  if (i==7){
                        if ([dictMenu objectForKey:[@"Pregnancy Check Result" uppercaseString]] && ![[dictMenu objectForKey:[@"Pregnancy Check Result" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Pregnancy Check Result" uppercaseString]]?[dictMenu objectForKey:[@"Pregnancy Check Result" uppercaseString]]:@"" englishVersion:@"Pregnancy Check Result"];
                        }
                        else{
                            [arrMenu addObject:@"Pregnancy Check Result"];
                        }
                    }else  if (i==8){
                        if ([dictMenu objectForKey:[@"Semen Collection" uppercaseString]] && ![[dictMenu objectForKey:[@"Semen Collection" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Semen Collection" uppercaseString]]?[dictMenu objectForKey:[@"Semen Collection" uppercaseString]]:@"" englishVersion:@"Semen Collection"];
                        }
                        else{
                            [arrMenu addObject:@"Semen Collection"];
                        }
                    }
                }
            }
            //
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"21"];
            [arrEventCode addObject:@"22"];
            [arrEventCode addObject:@"23"];
            [arrEventCode addObject:@"24"];
            [arrEventCode addObject:@"17"];
            [arrEventCode addObject:@"19"];
            [arrEventCode addObject:@"18"];
            [arrEventCode addObject:@"20"];
            [arrEventCode addObject:@"25"];
        }else if ([countMenu isEqualToString:@"3"])
        {
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Farrowing"];
            [arrMenu addObject:@"Fostering"];
            [arrMenu addObject:@"Part Weaning"];
            [arrMenu addObject:@"Complete Weaning"];
            [arrMenu addObject:@"Batch Weaning"];
            [arrMenu addObject:@"Nurse Sow Weaning"];
            [arrMenu addObject:@"Piglet Death"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            if (resultArray1.count!=0)
            {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<7; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Farrowing" uppercaseString]] && ![[dictMenu objectForKey:[@"Farrowing" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Farrowing" uppercaseString]]?[dictMenu objectForKey:[@"Farrowing" uppercaseString]]:@"" englishVersion:@"Farrowing"];
                        }
                        else{
                            [arrMenu addObject:@"Farrowing"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Fostering" uppercaseString]] && ![[dictMenu objectForKey:[@"Fostering" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:@"Fostering"]?[dictMenu objectForKey:@"Fostering"]:@"" englishVersion:@"Fostering"];
                        }
                        else{
                            [arrMenu addObject:@"Fostering"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Part Weaning" uppercaseString]] && ![[dictMenu objectForKey:[@"Part Weaning" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Part Weaning" uppercaseString]]?[dictMenu objectForKey:[@"Part Weaning" uppercaseString]]:@"" englishVersion:@"Part Weaning"];
                        }
                        else{
                            [arrMenu addObject:@"Part Weaning"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Complete Weaning" uppercaseString]] && ![[dictMenu objectForKey:[@"Complete Weaning" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Complete Weaning" uppercaseString]]?[dictMenu objectForKey:[@"Complete Weaning" uppercaseString]]:@"" englishVersion:@"Complete Weaning"];
                        }
                        else{
                            [arrMenu addObject:@"Complete Weaning"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Batch Weaning" uppercaseString]] && ![[dictMenu objectForKey:[@"Batch Weaning" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Batch Weaning" uppercaseString]]?[dictMenu objectForKey:[@"Batch Weaning" uppercaseString]]:@"" englishVersion:@"Batch Weaning"];
                        }
                        else{
                            [arrMenu addObject:@"Batch Weaning"];
                        }
                    }else  if (i==5){
                        if ([dictMenu objectForKey:[@"Nurse Sow Weaning" uppercaseString]] && ![[dictMenu objectForKey:[@"Nurse Sow Weaning" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Nurse Sow Weaning" uppercaseString]]?[dictMenu objectForKey:[@"Nurse Sow Weaning" uppercaseString]]:@"" englishVersion:@"Nurse Sow Weaning"];
                        }
                        else{
                            [arrMenu addObject:@"Nurse Sow Weaning"];
                        }
                    }else  if (i==6){
                        if ([dictMenu objectForKey:[@"Piglet Death" uppercaseString]] && ![[dictMenu objectForKey:[@"Piglet Death" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Piglet Death" uppercaseString]]?[dictMenu objectForKey:[@"Piglet Death" uppercaseString]]:@"" englishVersion:@"Piglet Death"];
                        }
                        else{
                            [arrMenu addObject:@"Piglet Death"];
                        }
                    }
                }
            }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"26"];
            [arrEventCode addObject:@"27"];
            [arrEventCode addObject:@"28"];
            [arrEventCode addObject:@"29"];
            [arrEventCode addObject:@"30"];
            [arrEventCode addObject:@"31"];
            [arrEventCode addObject:@"32"];
        }else if ([countMenu isEqualToString:@"4"])
        {
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Boar Treatment"];
            [arrMenu addObject:@"Female Treatment"];
            [arrMenu addObject:@"Piglet Treatment"];
            [arrMenu addObject:@"Boar Batch Treatment"];
            [arrMenu addObject:@"Female Batch Treatment"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            if (resultArray1.count!=0)
            {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<6; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Boar Treatment" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Treatment" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Treatment" uppercaseString]]?[dictMenu objectForKey:[@"Boar Treatment" uppercaseString]]:@"" englishVersion:@"Boar Treatment"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Treatment"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Female Treatment" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Treatment" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Treatment" uppercaseString]]?[dictMenu objectForKey:[@"Female Treatment" uppercaseString]]:@"" englishVersion:@"Female Treatment"];
                        }
                        else{
                            [arrMenu addObject:@"Female Treatment"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Piglet Treatment" uppercaseString]] && ![[dictMenu objectForKey:[@"Piglet Treatment" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Piglet Treatment" uppercaseString]]?[dictMenu objectForKey:[@"Piglet Treatment" uppercaseString]]:@"" englishVersion:@"Piglet Treatment"];
                        }
                        else {
                            [arrMenu addObject:@"Piglet Treatment"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Boar Batch Treatment" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Batch Treatment" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Batch Treatment" uppercaseString]]?[dictMenu objectForKey:[@"Boar Batch Treatment" uppercaseString]]:@"" englishVersion:@"Boar Batch Treatment"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Batch Treatment"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Female Batch Treatment" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Batch Treatment" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Batch Treatment" uppercaseString]]?[dictMenu objectForKey:[@"Female Batch Treatment" uppercaseString]]:@"" englishVersion:@"Female Batch Treatment"];
                        }
                        else{
                            [arrMenu addObject:@"Female Batch Treatment"];
                        }
                    }
                }
            }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"33"];
            [arrEventCode addObject:@"34"];
            [arrEventCode addObject:@"35"];
            [arrEventCode addObject:@"48"];
            [arrEventCode addObject:@"49"];
        }else if ([countMenu isEqualToString:@"5"]){
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Boar ReTag"];
            [arrMenu addObject:@"Female ReTag"];
            [arrMenu addObject:@"Boar Movement"];
            [arrMenu addObject:@"Female Movement"];
            [arrMenu addObject:@"Transponder"];

            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            if (resultArray1.count!=0)
            {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<6; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Boar ReTag" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar ReTag" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar ReTag" uppercaseString]]?[dictMenu objectForKey:[@"Boar ReTag" uppercaseString]]:@"" englishVersion:@"Boar ReTag"];
                        }
                        else{
                            [arrMenu addObject:@"Boar ReTag"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Female ReTag" uppercaseString]] && ![[dictMenu objectForKey:[@"Female ReTag" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female ReTag" uppercaseString]]?[dictMenu objectForKey:[@"Female ReTag" uppercaseString]]:@"" englishVersion:@"Female ReTag"];
                        }
                        else{
                            [arrMenu addObject:@"Female ReTag"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Boar Movement" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Movement" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Movement" uppercaseString]]?[dictMenu objectForKey:[@"Boar Movement" uppercaseString]]:@"" englishVersion:@"Boar Movement"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Movement"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Female Movement" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Movement" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Movement" uppercaseString]]?[dictMenu objectForKey:[@"Female Movement" uppercaseString]]:@"" englishVersion:@"Female Movement"];
                        }
                        else{
                            [arrMenu addObject:@"Female Movement"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Transponder" uppercaseString]] && ![[dictMenu objectForKey:[@"Transponder" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Transponder" uppercaseString]]?[dictMenu objectForKey:[@"Transponder" uppercaseString]]:@"" englishVersion:@"Transponder"];
                        }
                        else{
                            [arrMenu addObject:@"Transponder"];
                        }
                    }
                }
            }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"36"];
            [arrEventCode addObject:@"37"];
            [arrEventCode addObject:@"38"];
            [arrEventCode addObject:@"39"];
            [arrEventCode addObject:@"52"];
        }else if ([countMenu isEqualToString:@"6"]){
            [arrMenu removeAllObjects];
            [arrMenu addObject:@"Boar Note"];
            [arrMenu addObject:@"Female Note"];
            [arrMenu addObject:@"Litter Note"];
            [arrMenu addObject:@"Boar Flag"];
            [arrMenu addObject:@"Female Flag"];
            [arrMenu addObject:@"Boar Body Condition"];
            [arrMenu addObject:@"Female Body Condition"];
            [arrMenu addObject:@"Boar Marked for Culling"];
            [arrMenu addObject:@"Female Marked for Culling"];

            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrMenu];
            if (resultArray1.count!=0)
            {
                [arrMenuAforeTrnslation removeAllObjects];
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [arrMenu removeAllObjects];
                
                for (int i=0; i<10; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Boar Note" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Note" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Note" uppercaseString]]?[dictMenu objectForKey:[@"Boar Note" uppercaseString]]:@"" englishVersion:@"Farrowing"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Note"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Female Note" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Note" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Note" uppercaseString]]?[dictMenu objectForKey:[@"Female Note" uppercaseString]]:@"" englishVersion:@"Female Note"];
                        }
                        else{
                            [arrMenu addObject:@"Female Note"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Litter Note" uppercaseString]] && ![[dictMenu objectForKey:[@"Litter Note" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Litter Note" uppercaseString]]?[dictMenu objectForKey:[@"Litter Note" uppercaseString]]:@"" englishVersion:@"Litter Note"];
                        }
                        else{
                            [arrMenu addObject:@"Litter Note"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"Boar Flag" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Flag" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Flag" uppercaseString]]?[dictMenu objectForKey:[@"Boar Flag" uppercaseString]]:@"" englishVersion:@"Boar Flag"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Flag"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Female Flag" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Flag" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Flag" uppercaseString]]?[dictMenu objectForKey:[@"Female Flag" uppercaseString]]:@"" englishVersion:@"Female Flag"];
                        }
                        else{
                            [arrMenu addObject:@"Female Flag"];
                        }
                    }else  if (i==5){
                        if ([dictMenu objectForKey:[@"Boar Body Condition" uppercaseString]] && ![[dictMenu objectForKey:[@"Boar Body Condition" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Body Condition" uppercaseString]]?[dictMenu objectForKey:[@"Boar Body Condition" uppercaseString]]:@"" englishVersion:@"Boar Body Condition"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Body Condition"];
                        }
                    }else  if (i==6){
                        if ([dictMenu objectForKey:[@"Female Body Condition" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Body Condition" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Body Condition" uppercaseString]]?[dictMenu objectForKey:[@"Female Body Condition" uppercaseString]]:@"" englishVersion:@"Female Body Condition"];
                        }
                        else{
                            [arrMenu addObject:@"Female Body Condition"];
                        }
                    }else  if (i==7){
                        if ([dictMenu objectForKey:[@"Boar Marked for Culling" uppercaseString]] && ![[dictMenu objectForKey:@"Boar Marked for Culling"] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Boar Marked for Culling" uppercaseString]]?[dictMenu objectForKey:[@"Boar Marked for Culling" uppercaseString]]:@"" englishVersion:@"Boar Marked for Culling"];
                        }
                        else{
                            [arrMenu addObject:@"Boar Marked for Culling"];
                        }
                    }else  if (i==8){
                        if ([dictMenu objectForKey:[@"Female Marked for Culling" uppercaseString]] && ![[dictMenu objectForKey:[@"Female Marked for Culling" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Female Marked for Culling" uppercaseString]]?[dictMenu objectForKey:[@"Female Marked for Culling" uppercaseString]]:@"" englishVersion:[@"Female Marked for Culling" uppercaseString]];
                        }
                        else{
                            [arrMenu addObject:@"Female Marked for Culling"];
                        }
                    }
                }
            }
            
            [arrEventCode removeAllObjects];
            [arrEventCode addObject:@"40"];
            [arrEventCode addObject:@"41"];
            [arrEventCode addObject:@"43"];
            [arrEventCode addObject:@"45"];
            [arrEventCode addObject:@"46"];
            [arrEventCode addObject:@"50"];
            [arrEventCode addObject:@"51"];
            [arrEventCode addObject:@"15"];
            [arrEventCode addObject:@"16"];
        }
    }
    @catch (NSException *exception){
        NSLog(@"Exception in viewWillAppear in sub data menu data entry  = %@",exception.description);
    }
}

-(void)addObject:(NSString*)object englishVersion:(NSString*)englishVersion{
    @try {
        if (object.length!=0){
            [arrMenu addObject:object];
        }
        else{
            [arrMenu addObject:englishVersion];
        }
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception ion addObject=%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataEntry"];
        
        if (cell ==nil)
        {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataEntry"];
        }
        
        UILabel *lblDetails = (UILabel*)[cell viewWithTag:2];
        lblDetails.text =[arrMenu objectAtIndex:indexPath.row];
        
        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath =%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FromDataEntry"];
        /***Added code by amit ****/
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PrevSelectedDate"];
        //        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        	//        [pref setObject:strSelectedDate forKey:@"PrevSelectedDate"];
       	//        [pref synchronize];
        /*****************************/
        DynamicFormViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DynamicForm"];
        newView.strEventCode = [arrEventCode objectAtIndex:indexPath.row];
        newView.strTitle = self.title;
        newView.strTitleInt = countMenu;
        newView.lblTitle = [arrMenu objectAtIndex:indexPath.row];
        NSLog(@"eventCode=%@",[arrEventCode objectAtIndex:indexPath.row]);
        [self.navigationController pushViewController:newView animated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in didSelectRowAtIndexPath =%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

-(void)btnBack_tapped {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

-(void)btnSettings_tapped{
    @try {
        //        SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        //        //[self presentViewController:settingsViewController animated:YES completion:nil];
        //        [self.view addSubview:settingsViewController.view];
        
        //        SettingsViewController *alertDialogView = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        //        [alertDialogView willMoveToParentViewController:self];
        //        [self.view addSubview:alertDialogView.view];
        //        [self addChildViewController:alertDialogView];
        //        [alertDialogView didMoveToParentViewController:self];
        
        SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        //settingsViewController.view.backgroundColor = [UIColor clearColor];
        //        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        //#ifdef __IPHONE_8_0
        //      //  if(IS_OS_8_OR_LATER)
        //        {
        //            self.providesPresentationContextTransitionStyle = YES;
        //            self.definesPresentationContext = YES;
        //            [settingsViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        //        }
        //#endif
        
        [self presentViewController:settingsViewController animated:NO completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSettings_tapped =%@",exception.description);
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
