//
//  DynamicFormViewController.m
//  PigChamp
//
//  Created by Venturelabour on 26/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "DynamicFormViewController.h"
#import "CoreDataHandler.h"
#import "ControlSettings.h"
#import "ServerManager.h"
#import "SettingsViewController.h"
#import "BarcodeScannerViewController.h"
#import "DropDown.h"
#import "dateCustomCell.h"
#import "textCustomCell.h"
#import "iRCustomCell.h"
#import "twoTextCustomCell.h"
#import "threeTextCustomCell.h"
#import "Note.h"

BOOL isFromKeybord = NO;
BOOL isRFIDCalled = NO;
BOOL isOpenDynamic = NO;
BOOL isThousandFormat = NO;
@interface DynamicFormViewController ()
@end

@implementation DynamicFormViewController
@synthesize strEventCode;
@synthesize dictJson;

#pragma mark - View life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;
        
        self.navigationController.navigationBar.translucent = NO;
        
        _btnSave.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnSave.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _btnSave.layer.shadowOpacity = 1.0f;
        _btnSave.layer.shadowRadius = 3.0f;
        
        _btnClear.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnClear.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _btnClear.layer.shadowOpacity = 1.0f;
        _btnClear.layer.shadowRadius = 3.0f;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Dynamic form"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        _arrDynamic = [[NSMutableArray alloc]init];
        _arrDropDown = [[NSMutableArray alloc]init];
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
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        [self registerForKeyboardNotifications];
        
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"CLEAr",@"SaVE",@"Yes",@"No",@"Ok",@"Cancel",@"Please Wait...",@"Clear",@"Your session has been expired. Please login again.",@"Server Error.",@"Signing off.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        strYes = @"Yes";
        strNo = @"No";
        strOk = @"OK";
        strCancel = @"CANCEL";//Cancel
        strWait = @"Please Wait...";
        strNoInternet = @"You must be online for the app to function.";
        strClear = @"CLEAR";
        strUnauthorised =@"Your session has been expired. Please login again.";
        strServerErr= @"Server Error.";
        strSignOff = @"Signing off.";
        
        if (resultArray1.count!=0){
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] uppercaseString] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                //NSLog(@"dictMenu=%@",dictMenu);
            }
            
            for (int i=0; i<12; i++) {
                if (i==0){
                    NSString *strSearchTitle;
                    if ([dictMenu objectForKey:@"CLEAR"] && ![[dictMenu objectForKey:@"CLEAR"] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:@"CLEAR"] length]>0) {
                            strSearchTitle = [dictMenu objectForKey:@"CLEAR"]?[dictMenu objectForKey:@"CLEAR"]:@"";
                        }
                        //                        else{
                        //                            strSearchTitle = @"CLEAR";
                        //                        }
                    }
                    //                    else{
                    //                            strSearchTitle = @"CLEAR";
                    //                    }
                    
                    [self.btnClear setTitle:strSearchTitle forState:UIControlStateNormal];
                }else  if (i==1){
                    NSString *strSearchTitle;
                    if ([dictMenu objectForKey:@"SAVE"] && ![[dictMenu objectForKey:@"SAVE"] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:@"SAVE"] length]>0) {
                            strSearchTitle = [dictMenu objectForKey:@"SAVE"]?[dictMenu objectForKey:@"SAVE"]:@"";
                        }
                        //                        else{
                        //                            strSearchTitle = @"SAVE";
                        //                        }
                    }
                    //                    else{
                    //                        strSearchTitle = @"SAVE";
                    //                    }
                    
                    [self.btnSave setTitle:strSearchTitle forState:UIControlStateNormal];
                }else  if (i==2){
                    if ([dictMenu objectForKey:[@"Yes" uppercaseString]] && ![[dictMenu objectForKey:[@"Yes" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Yes" uppercaseString]] length]>0) {
                            strYes = [dictMenu objectForKey:[@"Yes" uppercaseString]]?[dictMenu objectForKey:[@"Yes" uppercaseString]]:@"";
                        }
                        //                        else{
                        //                            strYes = @"Yes";
                        //                        }
                    }
                    //                    else{
                    //                        strYes = @"Yes";
                    //                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"No" uppercaseString]] && ![[dictMenu objectForKey:[@"No" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"No" uppercaseString]] length]>0) {
                            strNo = [dictMenu objectForKey:[@"No" uppercaseString]]?[dictMenu objectForKey:[@"No" uppercaseString]]:@"";
                        }
                        //                        else{
                        //                            strNo = @"No";
                        //                        }
                    }
                    //                    else{
                    //                        strNo = @"No";
                    //                    }
                }else  if (i==4){
                    if ([dictMenu objectForKey:[@"Ok" uppercaseString]] && ![[dictMenu objectForKey:[@"Ok" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Ok" uppercaseString]] length]>0) {
                            strOk = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"Ok" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==5){
                    if ([dictMenu objectForKey:[@"Cancel" uppercaseString]] && ![[dictMenu objectForKey:[@"Cancel" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Cancel" uppercaseString]] length]>0) {
                            strCancel = [dictMenu objectForKey:[@"Cancel" uppercaseString]]?[dictMenu objectForKey:[@"Cancel" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==6){
                    if ([dictMenu objectForKey:[@"Please Wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] length]>0) {
                            strWait = [dictMenu objectForKey:[@"Please Wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please Wait..." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==7){
                    if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                            strNoInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==8){
                    if ([dictMenu objectForKey:[@"CLEAR" uppercaseString]] && ![[dictMenu objectForKey:[@"CLEAR" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"CLEAR" uppercaseString]] length]>0) {
                            strClear = [dictMenu objectForKey:[@"CLEAR" uppercaseString]]?[dictMenu objectForKey:[@"CLEAR" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==9){
                    if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                            strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==10){
                    if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                            strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==11) {
                    if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                            strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad=%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        isOpenDynamic = NO;
        
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        NSString *strFromSetting = [pref valueForKey:@"FromSetting"];
        
        strSplitSex = [pref valueForKey:@"SSL"];
        strSplitWex = [pref valueForKey:@"SSW"];
        
        NSLog(@"strSplitSex=%@",strSplitSex);
        NSLog(@"strSplitWex=%@",strSplitWex);
        
        if ([strFromSetting isEqualToString:@"0"]) {
            NSArray *arrUserParameter = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"User_Parameters" andPredicate:nil andSortDescriptors:nil];
            
            for (int count=0; count<arrUserParameter.count; count++) {
                if ([[[arrUserParameter objectAtIndex:count] valueForKey:@"nm"]  isEqualToString:@"DateUsageFormat"]) {
                    _strDateFormat = [[arrUserParameter objectAtIndex:count] valueForKey:@"val"];
                }
            }
            
            if ([self.strDateFormat isEqualToString:@"1"]) {
                isThousandFormat = YES;
            }else {
                isThousandFormat = NO;
            }
            
            NSLog(@"_strDateFormat=%@",_strDateFormat);
            
            self.title = self.strTitle;
            self.lblSelectedValue.text = self.lblTitle;
            [_arrDynamic removeAllObjects];
            
            NSArray *resultArray = [[CoreDataHandler sharedHandler]getValuesToListWithEntityName:@"Data_Entry_Items" andPredicate:[NSPredicate predicateWithFormat:@"cd == %@", strEventCode] andSortDescriptors:nil];
            
            for (int count=0; count<resultArray.count; count++){
                _dictDynamic = [[NSMutableDictionary alloc]init];
                
                // NSString *strData = [[resultArray objectAtIndex:count] valueForKey:@""];
                //if (![strData isEqualToString:@"7"])//Yogs commnetes bcz of bug NUMBER 24 IN DEFECT SHEET
                {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"co"]?[[resultArray objectAtIndex:count] valueForKey:@"co"]:@"" forKey:@"co"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"dk"]?[[resultArray objectAtIndex:count] valueForKey:@"dk"]:@"" forKey:@"dk"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"dt"]?[[resultArray objectAtIndex:count] valueForKey:@"dt"]:@"" forKey:@"dt"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"dfT"]?[[resultArray objectAtIndex:count] valueForKey:@"dfT"]:@"" forKey:@"dfT"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"dfv"]?[[resultArray objectAtIndex:count] valueForKey:@"dfv"]:@"" forKey:@"dfv"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"lC"]?[[resultArray objectAtIndex:count] valueForKey:@"lC"]:@"" forKey:@"lC"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"mxV"]?[[resultArray objectAtIndex:count] valueForKey:@"mxV"]:@"" forKey:@"mxV"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"mnV"]?[[resultArray objectAtIndex:count] valueForKey:@"mnV"]:@"" forKey:@"mnV"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"Lb"]?[[resultArray objectAtIndex:count] valueForKey:@"Lb"]:@"" forKey:@"Lb"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"nC"]?[[resultArray objectAtIndex:count] valueForKey:@"nC"]:@"" forKey:@"nC"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"op"]?[[resultArray objectAtIndex:count] valueForKey:@"op"]:@"" forKey:@"op"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"nC"]?[[resultArray objectAtIndex:count] valueForKey:@"nD"]:@"" forKey:@"nD"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"ps"]?[[resultArray objectAtIndex:count] valueForKey:@"ps"]:@"" forKey:@"ps"];
                    [_dictDynamic setValue:[[resultArray objectAtIndex:count] valueForKey:@"ac"]?[[resultArray objectAtIndex:count] valueForKey:@"ac"]:@"" forKey:@"ac"];
                    
                    [_arrDynamic addObject:_dictDynamic];
                }
            }
            
            NSArray *arrsorted = [_arrDynamic sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                
                NSInteger position1 = [[obj1 valueForKey:@"ps"] integerValue];
                NSInteger position2 = [[obj2 valueForKey:@"ps"] integerValue];
                
                if (position1 <position2)
                {
                    return  NSOrderedAscending;
                }
                else if (position1 >position2)
                {
                    return NSOrderedDescending;
                }
                else {
                    return NSOrderedSame;
                }
            }];
            
            [_arrDynamic removeAllObjects];
            _arrDynamic = [NSMutableArray arrayWithArray:arrsorted];
            
            _dictDynamic = [[NSMutableDictionary alloc]init];
            dictJson = [[NSMutableDictionary alloc]init];
            
            for (NSMutableDictionary *dict  in _arrDynamic) {
                
                if ([[dict valueForKey:@"dk"] integerValue] != 7){
                    if ([[dict valueForKey:@"dk"] integerValue] == 92){
                        NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
                        [dictText setValue:@"" forKey:@"first"];
                        [dictText setValue:@"" forKey:@"second"];
                        [dictText setValue:@"" forKey:@"third"];
                        
                        [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])){
                        NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
                        [dictText setValue:@"" forKey:@"first"];
                        [dictText setValue:@"" forKey:@"second"];
                        
                        [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    }
                    else if([[dict valueForKey:@"dk"] integerValue] == 6){
                        
                        NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
                        [dictData setValue:@"" forKey:@"br"];
                        [dictData setValue:@"" forKey:@"rm"];
                        [dictData setValue:@"" forKey:@"pn"];
                        
                        [dictJson setObject:dictData forKey:[dict valueForKey:@"dk"]];
                    }
                    else if([[dict valueForKey:@"dk"] integerValue] != 6){
                        [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"" forKey:[dict valueForKey:@"dk"]];
                    }
                }
            }
            
            [self fillDefaultValuesForMandatoryFields];
            
            if ([strFromDataEntry isEqualToString:@"1"]) {
                [self callEdit];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblDynamic reloadData];
            });
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewWillAppear=%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        
        [self.activeTextField resignFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenDynamic) {
            self.vwOverlay.hidden = NO;
            [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            [currentWindow addSubview:tlc.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            }];
        }else{
            self.vwOverlay.hidden = YES;
            [tlc.view removeFromSuperview];
        }
        
        isOpenDynamic = !isOpenDynamic;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    @try {
        [self.tblDynamic reloadData];
    }
    @catch (NSException *exception){
        NSLog(@"Exception in willRotateToInterfaceOrientation:%@",exception.description);
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
                                 actionWithTitle:strOk
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
                                 actionWithTitle:strOk
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
        //                                 actionWithTitle:strOk
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
        isOpenDynamic = !isOpenDynamic;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
//    return YES;
//}

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDynamic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSMutableDictionary *dict = [_arrDynamic objectAtIndex:indexPath.row];
        if ([[dict valueForKey:@"dk"] integerValue] == 92){
            return 110;
        }
        else if ([[dict valueForKey:@"dk"] integerValue] != 6){
            return 60;
        }
        else
            return  180;
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception in heightForRowAtIndexPath = %@",exception.description);
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    @try {
//        return 60;
//    }
//    @catch (NSException *exception) {
//
//        NSLog(@"Exception in heightForFooterInSection=%@",exception.description);
//    }
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    @try {
//        return _vwFooter;
//    }
//    @catch (NSException *exception) {
//
//        NSLog(@"Exception in viewForFooterInSection = %@",exception.description);
//    }
//}

//
//#pragma UIScrollView Method:
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    BOOL loading = '\0';
//    if (!loading) {
//        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
//        if (endScrolling >= scrollView.contentSize.height)
//        [self.tblDynamic reloadData];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        UITableViewCell *cell;
        NSMutableDictionary *dict = [_arrDynamic objectAtIndex:indexPath.row];
        NSString *strDataType  = [self getViewType:[dict valueForKey:@"dt"]?[dict valueForKey:@"dt"]:@""];
        
        if ([[dict valueForKey:@"dk"] integerValue]==1){
            iRCustomCell *cell;
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"TextWihScanner" forIndexPath:indexPath];
            //
            //            if (cell ==nil){
            //                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextWihScanner"];
            //            }
            
            cell = (iRCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"TextWihScanner" forIndexPath:indexPath];
            
            cell.backgroundColor = [UIColor clearColor];
            // UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"]?[dict valueForKey:@"Lb"]:@"";
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else {
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }
            else {
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else {
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //UITextField *txtDynamic = (UITextField*)[cell viewWithTag:2];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, cell.txtDetail.frame.size.height)];
            leftView.backgroundColor = [UIColor clearColor];
            cell.txtDetail.rightViewMode = UITextFieldViewModeAlways;
            cell.txtDetail.rightView = leftView;
            
            cell.txtDetail.text = [_dictDynamic valueForKey:[dict valueForKey:@"Lb"]];
            strScan = [dict valueForKey:@"Lb"];
            NSString *strMinVal =[dict valueForKey:@"mnV"]?[dict valueForKey:@"mnV"]:@"";
            NSString *strMaxVal = [dict valueForKey:@"mxV"]?[dict valueForKey:@"mxV"]:@"";
            if((strMinVal.length >0 && strMaxVal.length>0)||[[dict valueForKey:@"dk"]integerValue]==24 || [self getTextType:[dict valueForKey:@"dt"]]){
                [cell.txtDetail setKeyboardType:UIKeyboardTypeNumberPad];
            }
            else{
                [cell.txtDetail setKeyboardType:UIKeyboardTypeDefault];
            }
            
            cell.txtDetail.tag = indexPath.row;
            
            [cell.btnDetail bringSubviewToFront:cell.txtDetail];
            
            
            NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
            NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
            
            if ([strFromDataEntry isEqualToString:@"1"] && ([[dict valueForKey:@"dk"] integerValue]==1 || [[dict valueForKey:@"dk"] integerValue]==27 || [[dict valueForKey:@"dk"] integerValue]==63)){
                cell.userInteractionEnabled = NO;
            }
            else{
                cell.userInteractionEnabled = YES;
            }
            
            return cell;
            
        }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])) {
            
            twoTextCustomCell *cell = (twoTextCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"TwoText" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            //UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"]?[dict valueForKey:@"Lb"]:@"";
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else {
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }
            else{
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //
            __block NSDictionary *dictText;//= [_dictDynamic valueForKey:@"Lb"];
            
            [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                if ([key integerValue]==51 || [key integerValue]==15){
                    dictText = obj;
                }
            }];
            
            // UITextField *txt = (UITextField*)[cell viewWithTag:100];
            cell.txtFirst.text = [dictText valueForKey:@"first"];
            cell.txtFirst.tag =indexPath.row;
            
            //UITextField *txtSecond = (UITextField*)[cell viewWithTag:101];
            cell.txtSecond.text = [dictText valueForKey:@"second"];
            cell.txtSecond.tag =indexPath.row;
            
            [cell.txtFirst setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.txtSecond setKeyboardType:UIKeyboardTypeNumberPad];
            
            return cell;
        }else if ([[dict valueForKey:@"dk"] integerValue] == 48) {
            
            
            Note *cell = (Note*)[tableView dequeueReusableCellWithIdentifier:@"Note" forIndexPath:indexPath];
            
            cell.backgroundColor = [UIColor clearColor];
            //UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"]?[dict valueForKey:@"Lb"]:@"";
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }
            else{
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //UITextView *txtDynamic = (UITextView*)[cell viewWithTag:2];
            cell.txtDetail.text = [_dictDynamic valueForKey:[dict valueForKey:@"Lb"]];
            cell.txtDetail.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
            [cell.txtDetail setKeyboardType:UIKeyboardTypeDefault];
            cell.txtDetail.tag = indexPath.row;
            
            return cell;
            
        }
        else if ([strDataType isEqualToString:@"Date"]) {
            dateCustomCell *cell= (dateCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"dateCustomCell" forIndexPath:indexPath];
            // cell = [[dateCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dateCustomCell"];
            
            if (cell ==nil){
                cell  = (dateCustomCell*)[[dateCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dateCustomCell"];
            }
            
            // YourTableViewCellClass *cell = (YourTableViewCellClass*)[tableView dequeueReusableCellWithIdentifier:@"YourCellIdentifierStringDefinedInStoryBoard"];
            //UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }else{
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else {
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //UIButton *btn = (UIButton*)[cell viewWithTag:2];
            cell.btnDetail.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap
            cell.btnDetail.titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter
            cell.btnDetail.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
            [cell.btnDetail setTitle:[_dictDynamic valueForKey:[dict valueForKey:@"Lb"]] forState:UIControlStateNormal];
            
            //
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init];
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];//
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init] ;
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'00:00:00"];
            NSString *currentDate;
            
            if(currentDate == nil) {
                currentDate = [dateFormatter stringFromDate:[NSDate date]];
            }
            
            NSDate *todayDate;
            todayDate =[dateFormatter dateFromString:currentDate];
            
            NSDateFormatter *dateFormatterr1 = [[NSDateFormatter alloc]init] ;
            [dateFormatterr1 setDateFormat:@"yyyyMMdd"];//
            NSDate *dtCheckIn = [dateFormatterr1 dateFromString:[dictJson valueForKey:[dict valueForKey:@"dk"]]];
            
            int days = [dtCheckIn timeIntervalSinceDate:todayDate]/24/60/60;
            
            if (days==0){
                [cell.btnDetail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else if (days==1) {
                [cell.btnDetail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else {
                [cell.btnDetail setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
            return cell;
        }else if ([strDataType isEqualToString:@"DropDown"]) {
            if ([[dict valueForKey:@"dk"] integerValue] == 6){
                cell = [tableView dequeueReusableCellWithIdentifier:@"BarnPen" forIndexPath:indexPath];
                
                if (cell ==nil) {
                    cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BarnPen"];
                }
                
                __block NSDictionary *dictBarn;
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key integerValue]==6){
                        dictBarn = obj;
                    }
                }];
                
                //[dict setValue:@"1" forKey:@"co"];
                UILabel *lblBarn = (UILabel*)[cell viewWithTag:11];
                UILabel *lblRoom = (UILabel*)[cell viewWithTag:12];
                UILabel *lblPen = (UILabel*)[cell viewWithTag:13];
                
                //
                lblBarn.text = @"Barn";
                lblRoom.text = @"Room";
                lblPen.text = @"Pen";
                
                NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Barn",@"Room",@"Pen",nil]];
                NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                
                if (resultArray1.count!=0){
                    for (int i=0; i<resultArray1.count; i++){
                        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                    }
                    
                    for (int i=0; i<1; i++) {
                        if (i==0) {
                            if ([dictMenu objectForKey:[@"Barn" uppercaseString]] && ![[dictMenu objectForKey:[@"Barn" uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[@"Barn" uppercaseString]] length]>0) {
                                    lblBarn.text = [dictMenu objectForKey:[@"Barn" uppercaseString]]?[dictMenu objectForKey:[@"Barn" uppercaseString]]:@"";
                                }
                            }else if ([dictMenu objectForKey:[@"Room" uppercaseString]] && ![[dictMenu objectForKey:[@"Room" uppercaseString]] isKindOfClass:[NSNull class]]){
                                if ([[dictMenu objectForKey:[@"Room" uppercaseString]] length]>0) {
                                    lblRoom.text = [dictMenu objectForKey:[@"Room" uppercaseString]]?[dictMenu objectForKey:[@"Room" uppercaseString]]:@"";
                                }
                            }else if ([dictMenu objectForKey:[@"Pen" uppercaseString]] && ![[dictMenu objectForKey:[@"Pen" uppercaseString]] isKindOfClass:[NSNull class]]){
                                if ([[dictMenu objectForKey:[@"Pen" uppercaseString]] length]>0) {
                                    lblPen.text = [dictMenu objectForKey:[@"Pen" uppercaseString]]?[dictMenu objectForKey:[@"Pen" uppercaseString]]:@"";
                                }
                            }
                        }
                    }
                }
                //
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                        lblBarn.font = [UIFont boldSystemFontOfSize:17];
                        lblRoom.font = [UIFont boldSystemFontOfSize:17];
                        lblPen.font = [UIFont boldSystemFontOfSize:17];
                    }
                    else{
                        lblBarn.font = [UIFont systemFontOfSize:17];
                        lblRoom.font = [UIFont systemFontOfSize:17];
                        lblPen.font = [UIFont systemFontOfSize:17];
                    }
                    
                }else{
                    if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                        lblBarn.font = [UIFont boldSystemFontOfSize:13];
                        lblRoom.font = [UIFont boldSystemFontOfSize:13];
                        lblPen.font = [UIFont boldSystemFontOfSize:13];
                    }
                    else{
                        lblBarn.font = [UIFont systemFontOfSize:13];
                        lblRoom.font = [UIFont systemFontOfSize:13];
                        lblPen.font = [UIFont systemFontOfSize:13];
                    }
                }
                
                UIButton *btn = (UIButton*)[cell viewWithTag:2];
                // btn.tag=indexPath.row;
                btn.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
                [btn setTitle:[dictBarn valueForKey:@"br"] forState:UIControlStateNormal];
                
                UIButton *btnRoom = (UIButton*)[cell viewWithTag:3];
                // btnRoom.tag=indexPath.row;
                btnRoom.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
                [btnRoom setTitle:[dictBarn valueForKey:@"rm"] forState:UIControlStateNormal];
                
                UIButton *btnPen = (UIButton*)[cell viewWithTag:4];
                //btnPen.tag=indexPath.row;
                btnPen.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
                [btnPen setTitle:[dictBarn valueForKey:@"pn"] forState:UIControlStateNormal];
            }
            else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"DropDown" forIndexPath:indexPath];
                
                if (cell ==nil){
                    cell  = (DropDown*)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DropDown"];
                }
                
                UILabel *lbldetail = (UILabel*)[cell viewWithTag:201];
                lbldetail.text = [dict valueForKey:@"Lb"];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                        lbldetail.font = [UIFont boldSystemFontOfSize:17];
                    }
                    else{
                        lbldetail.font = [UIFont systemFontOfSize:17];
                    }
                }else{
                    if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                        lbldetail.font = [UIFont boldSystemFontOfSize:13];
                    }
                    else {
                        lbldetail.font = [UIFont systemFontOfSize:13];
                    }
                }
                
                UIButton *btnDeatail = (UIButton*)[cell viewWithTag:2];
                //btnDeatail.tag=indexPath.row;
                //[btnDeatail addTarget:self action:@selector(btnDropdown_tapped:) forControlEvents:UIControlEventTouchUpInside];
                btnDeatail.layer.borderColor = [[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
                [btnDeatail setTitle:[_dictDynamic valueForKey:[dict valueForKey:@"Lb"]] forState:UIControlStateNormal];
            }
        }
        else if ([strDataType isEqualToString:@"TextField"]) {
            textCustomCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"Text" forIndexPath:indexPath];
            
            //                if (cell ==nil){
            //                }
            
            //cell  = [[textCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Text"];
            cell = (textCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"Text" forIndexPath:indexPath];
            
            //UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }else{
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //               if (indexPath.row%2==0){
            //                   lblDetails.font = [UIFont boldSystemFontOfSize:13];
            //               }
            //               else {
            //                   lblDetails.font = [UIFont systemFontOfSize:13];
            //               }
            
            //UITextField *txtDynamic = (UITextField*)[cell viewWithTag:2];
            cell.txtDetail.text = [_dictDynamic valueForKey:[dict valueForKey:@"Lb"]];
            cell.txtDetail.tag = indexPath.row;
            
            NSString *strMinVal =[dict valueForKey:@"mnV"]?[dict valueForKey:@"mnV"]:@"";
            NSString *strMaxVal = [dict valueForKey:@"mxV"]?[dict valueForKey:@"mxV"]:@"";
            if((strMinVal.length >0 && strMaxVal.length>0)||[[dict valueForKey:@"dk"]integerValue]==24 || [self getTextType:[dict valueForKey:@"dt"]] || [[dict valueForKey:@"dk"]integerValue]==32){
                [cell.txtDetail setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            }
            else{
                [cell.txtDetail setKeyboardType:UIKeyboardTypeDefault];
            }
            
            return cell;
        }
        else if ([strDataType isEqualToString:@"IR"]) {
            //                cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeText" forIndexPath:indexPath];
            //
            //                if (cell == nil){
            //                    cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThreeText"];
            //                }
            
            threeTextCustomCell *cell = (threeTextCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"ThreeText" forIndexPath:indexPath];
            
            // UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            cell.lblDetail.text = [dict valueForKey:@"Lb"];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:17];
                }
                else{
                    cell.lblDetail.font = [UIFont systemFontOfSize:17];
                }
            }else{
                if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                    cell.lblDetail.font = [UIFont boldSystemFontOfSize:13];
                }
                else {
                    cell.lblDetail.font = [UIFont systemFontOfSize:13];
                }
            }
            
            //               if (indexPath.row%2==0){
            //                   lblDetails.font = [UIFont boldSystemFontOfSize:13];
            //               }
            //               else {
            //
            //                   lblDetails.font = [UIFont systemFontOfSize:13];
            //               }
            
            __block NSDictionary *dictText;//= [_dictDynamic valueForKey:@"Lb"];
            
            [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                if ([key integerValue]==92) {
                    dictText = obj;
                }
            }];
            
            //UITextField *txt = (UITextField*)[cell viewWithTag:12];
            cell.txtFirst.text = [dictText valueForKey:@"first"];
            cell.txtFirst.tag = indexPath.row;
            //UITextField *txtSecond = (UITextField*)[cell viewWithTag:13];
            cell.txtSecond.text = [dictText valueForKey:@"second"];
            cell.txtSecond.tag = indexPath.row;
            
            //UITextField *txtThrid = (UITextField*)[cell viewWithTag:14];
            cell.txtThird.text = [dictText valueForKey:@"third"];
            cell.txtThird.tag = indexPath.row;
            
            return cell;
        }
        
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        
        if ([strFromDataEntry isEqualToString:@"1"] && ([[dict valueForKey:@"dk"] integerValue]==1 || [[dict valueForKey:@"dk"] integerValue]==27 || [[dict valueForKey:@"dk"] integerValue]==63)){
            cell.userInteractionEnabled = NO;
        }
        else{
            cell.userInteractionEnabled = YES;
        }
        
        //cell.tag = indexPath.row;
        
        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath =%@",exception.description);
    }
}

-(BOOL)isTwoText {
    @try {
        if ([strSplitWex isEqualToString:@"-1"] && [strSplitWex isEqualToString:@"-1"]){
            return YES;
        }else if ([strSplitSex isEqualToString:@"-1"]) {
            return YES;
        }else if ([strSplitWex isEqualToString:@"-1"]){
            return YES;
        }
        
        return NO;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

-(NSString*)getViewType:(NSString*)datatype{
    @try {
        NSArray *arrDate =[[NSArray alloc]initWithObjects:@"DT",@"DD",@"DF",nil];
        NSArray *arrDropDown =[[NSArray alloc]initWithObjects:@"CO",@"LC",@"TP",@"BL",@"SO",@"FR",nil];
        NSArray *arrTextField =[[NSArray alloc]initWithObjects:@"BI",@"SI", @"IN",@"AI",@"BL",@"EN",@"WT",@"C$",@"PG",@"TX",@"SI",@"ID",@"MM",@"IP",@"GI",@"MI",@"TT",@"US",nil];
        
        if ([arrDate containsObject:datatype]){
            return @"Date";
        }
        else if ([arrDropDown containsObject:datatype])
        {
            return @"DropDown";
        }
        else if ([arrTextField containsObject:datatype]){
            return @"TextField";
        }
        else if ([datatype isEqualToString:@"IR"])
        {
            return @"IR";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in getViewType = %@",exception.description);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

#pragma mark - picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    @try {
        return  1;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfRowsInComponent=%@",exception.description);
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    @try
    {
        if (pickerView==self.pickerDropDown) {
            return [_arrDropDown count];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in numberOfRowsInComponent- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    @try
    {
        [[self.pickerDropDown.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerDropDown.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        
        if (pickerView==self.pickerDropDown) {
            return [[_arrDropDown objectAtIndex:row] valueForKey:@"visible"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in titleForRow- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    @try {
        [[self.pickerDropDown.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerDropDown.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        
        UILabel *lblSortText = (id)view;
        
        if (!lblSortText) {
            lblSortText= [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView rowSizeForComponent:component].width-15, [pickerView rowSizeForComponent:component].height)];
        }
        
        lblSortText.font = [UIFont systemFontOfSize:13];
        lblSortText.textColor = [UIColor blackColor];
        lblSortText.textAlignment = NSTextAlignmentCenter;
        lblSortText.tintColor = [UIColor clearColor];
        
        if (pickerView==self.pickerDropDown) {
            lblSortText.text = [[_arrDropDown objectAtIndex:row] valueForKey:@"visible"];
            return lblSortText;
        }
    }
    @catch (NSException *exception)  {
        NSLog(@"Exception in viewForRow- %@",[exception description]);
    }
}

#pragma mark -Textfield related  methods
- (void)registerForKeyboardNotifications{
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in registerForKeyboardNotifications = %@",exception.description);
    }
}

-(BOOL)getTextType:(NSString*)dataType {
    @try {
        NSArray *arrTextField =[[NSArray alloc]initWithObjects:@"IN",@"EN",@"WT",@"C$",@"PG",nil];
        return [arrTextField containsObject:dataType]?YES:NO;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in getTextType=%@",exception.description);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    @try {
        self.activeTextField = textView;
        
        if (!isFromKeybord && text.length>0) {
            return  NO;
        }
        
        NSLog(@"textView.text.length=%lu",(unsigned long)textView.text.length);
        
        if (textView.text.length>240) {
            return  NO;
        }
        
        NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        UITableViewCell *cell = (UITableViewCell*)[[textView superview] superview];
        NSIndexPath* indexPath = [self.tblDynamic indexPathForCell:cell];
        
        if([text isEqualToString:@"\n"]){
            NSLog(@"text=%@",text);
        }
        
        NSLog(@"indexPath.row=%ld",(long)indexPath.row);
        // NSDictionary *dict = [self.arrDynamic objectAtIndex:indexPath.row];
        NSDictionary *dict = [self.arrDynamic objectAtIndex:textView.tag];
        
        NSCharacterSet *characterSet = nil;
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\","];
        NSRange location = [text rangeOfCharacterFromSet:[characterSet invertedSet]];
        if ((location.location != NSNotFound) || [text isEqualToString:@""]) {
            [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
            [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
            return (location.location != NSNotFound || [text isEqualToString:@""]);
        }
        else {
            return NO;
        }
        
        if([text isEqualToString:@""])
            return YES;
        
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception =%@",exception.description);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try {
        NSDictionary *dict = [self.arrDynamic objectAtIndex:textField.tag];
        string = [string uppercaseString];
        
        if(!isFromKeybord && string.length>0 && [[textField.text stringByAppendingString:string] length]==15 && strEventCode.integerValue == 37 && [[dict valueForKey:@"dk"] integerValue]==68) {
            
            if (!isRFIDCalled) {
                isRFIDCalled = YES;
                [self getRFID:[textField.text stringByAppendingString:string] index:textField.tag];
            }
            
            return NO;
        }else if(!isFromKeybord && string.length>0 && [[textField.text stringByAppendingString:string] length]==15 && strEventCode.integerValue == 36 && [[dict valueForKey:@"dk"] integerValue]==68){
            
            if (!isRFIDCalled){
                isRFIDCalled = YES;
                [self getRFID:[textField.text stringByAppendingString:string] index:textField.tag];
            }
            
            return NO;
        }
        else if((strEventCode.integerValue == 2 || strEventCode.integerValue == 4 || strEventCode.integerValue == 5 || strEventCode.integerValue == 6) && ([[dict valueForKey:@"dk"] integerValue]!=32) && !isFromKeybord){
            return NO;
        }else if((strEventCode.integerValue != 2 || strEventCode.integerValue != 4 || strEventCode.integerValue != 5 || strEventCode.integerValue != 6|| strEventCode.integerValue != 36 || strEventCode.integerValue != 37) && ([[dict valueForKey:@"dk"] integerValue]==1) && !isFromKeybord && string.length>0 && [[textField.text stringByAppendingString:string] length]==15){
            
            if (!isRFIDCalled){
                isRFIDCalled = YES;
                [self getRFID:[textField.text stringByAppendingString:string] index:textField.tag];
            }
            
            return NO;
        }else if((strEventCode.integerValue != 2 || strEventCode.integerValue != 4 || strEventCode.integerValue != 5 || strEventCode.integerValue != 6|| strEventCode.integerValue != 36 || strEventCode.integerValue != 37)  && !isFromKeybord && ([[dict valueForKey:@"dk"] integerValue]!=1) && ([[dict valueForKey:@"dk"] integerValue]!=68)){
            
            if((strEventCode.integerValue == 2 || strEventCode.integerValue == 4 || strEventCode.integerValue == 5 || strEventCode.integerValue == 6) && ([[dict valueForKey:@"dk"] integerValue]==32) && !isFromKeybord){
            }else{
                NSString *newString = [[textField.text stringByReplacingCharactersInRange:range withString:string] uppercaseString];
                NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                if([[dict valueForKey:@"dk"] integerValue]==18){
                    if ((location.location != NSNotFound) && ([newString length]<=2)) {
                        [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                        
                        return YES;
                    }else{
                        return NO;
                    }
                }
                
                return NO;
            }
        }
        
        NSUInteger decimalPlacesLimit = [[dict valueForKey:@"nD"] integerValue] ? [[dict valueForKey:@"nD"] integerValue]:0;
        NSRange rangeDot = [textField.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
        
        if (rangeDot.length > 0 && decimalPlacesLimit>0){
            
            if([string isEqualToString:@"."]) {
                return NO;
            } else {
                NSArray *explodedString = [textField.text componentsSeparatedByString:@"."];
                NSString *decimalPart = explodedString[1];
                
                if (decimalPart.length >= decimalPlacesLimit && ![string isEqualToString:@""]) {
                    return NO;
                }
            }
        }
        
        NSString *newString = [[textField.text stringByReplacingCharactersInRange:range withString:string] uppercaseString];
        NSString *stnumberofchars = [dict valueForKey:@"nC"]?[dict valueForKey:@"nC"]:@"";
        
        if ([[dict valueForKey:@"dk"]integerValue]==1){
            NSString *stnumberofchars = [dict valueForKey:@"nC"]?[dict valueForKey:@"nC"]:@"";
            if([string isEqualToString:@""]) {
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }else if([string isEqualToString:@" "]){
                return NO;
            }
            else if ([stnumberofchars length]>0) {
                if (newString.length <=[[dict valueForKey:@"nC"] integerValue]) {
                    [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                    return (newString.length <=[[dict valueForKey:@"nC"] integerValue]);
                }else {
                    return NO;
                }
            }
        } else if ([[dict valueForKey:@"dk"]integerValue]==24) {
            if([string isEqualToString:@""]) {
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }
            
            NSCharacterSet *characterSet = nil;
            characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890-"];
            NSRange location = [string rangeOfCharacterFromSet:characterSet];
            
            if ((location.location != NSNotFound) && (newString.length < 4)){
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return ((location.location != NSNotFound) && (newString.length < 4));
            }
            else {
                return NO;
            }
        }else if ([[dict valueForKey:@"dk"]integerValue]==29) {
            
            if([string isEqualToString:@""]) {
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }
            
            NSCharacterSet *characterSet = nil;
            characterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
            NSRange location = [string rangeOfCharacterFromSet:characterSet];
            if ((location.location != NSNotFound) && (newString.length <= [stnumberofchars integerValue])) {
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return (location.location != NSNotFound);
            }
            else{
                return NO;
            }
        }else if (([[dict valueForKey:@"dk"]integerValue]==10)) {//as per android bug : 17759
            if([string isEqualToString:@""]){
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }
            
            if (([newString integerValue]>=0)&&([newString length]<8)) {
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890."];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                if ((location.location != NSNotFound) && (([newString integerValue]>=0)&&([newString length]<8))) {
                    [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                    
                    return ((location.location != NSNotFound) && (([newString integerValue]>=0)&&([newString length]<8)));
                }
                else {
                    return NO;
                }
            }
            else
                return NO;
        }
        else if ([[dict valueForKey:@"dk"]integerValue]==151) {
            if([string isEqualToString:@""]) {
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }
            
            NSString *strMinVal =[dict valueForKey:@"mnV"]?[dict valueForKey:@"mnV"]:@"";
            NSString *strMaxVal = [dict valueForKey:@"mxV"]?[dict valueForKey:@"mxV"]:@"";
            
            if (([strMinVal integerValue]>=0) && ([strMaxVal integerValue]>0)&&([newString length]<11)) {
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890."];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                if ((location.location != NSNotFound) && ([newString integerValue] >= [strMinVal integerValue] && [newString integerValue] <= [strMaxVal integerValue])) {
                    [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                    return ((location.location != NSNotFound) && ([newString integerValue] >= [strMinVal integerValue] && [newString integerValue] <= [strMaxVal integerValue]));
                }
                else
                    return NO;
            }
            else
                return NO;
        }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])){
            
            NSLog(@"data item key=%@",[dict valueForKey:@"dk"]);
            
            __block NSMutableDictionary *dictText;
            [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key integerValue]==15 || [key integerValue]==51) {
                    dictText = obj;
                }
            }];
            
            if ([textField.placeholder isEqualToString:@"first"]) {
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                if (((location.location != NSNotFound) && (newString.length <3)) || [string isEqualToString:@""]) {
                    [dictText setValue:newString forKey:@"first"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    return (((location.location != NSNotFound) && (newString.length <3)) || [string isEqualToString:@""]);
                }
                else{
                    return NO;
                }
            }else if ([textField.placeholder isEqualToString:@"second"]){
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                
                if (((location.location != NSNotFound) && ([newString length] < 3)) || [string isEqualToString:@""]) {
                    [dictText setValue:newString forKey:@"second"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    
                    return (((location.location != NSNotFound) && ([newString length] < 3)) || [string isEqualToString:@""]);
                }
                else
                    return NO;
            }
            else if ([[dict valueForKey:@"dk"] integerValue]==51) {
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                
                if (((location.location != NSNotFound) && ([newString length] < 3)) || [string isEqualToString:@""]) {
                    [dictText setValue:newString forKey:@"second"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    
                    return (((location.location != NSNotFound) && ([newString length] < 3)) || [string isEqualToString:@""]);
                }
                else
                    return NO;
            }
        }
        else if ([self getTextType:[dict valueForKey:@"dt"]]){
            
            if([string isEqualToString:@""]){
                [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                return YES;
            }
            
            NSString *strMinVal =[dict valueForKey:@"mnV"]?[dict valueForKey:@"mnV"]:@"";
            NSString *strMaxVal = [dict valueForKey:@"mxV"]?[dict valueForKey:@"mxV"]:@"";
            
            NSCharacterSet *characterSet = nil;
            
            if ([[dict valueForKey:@"dk"]integerValue]==42 || [[dict valueForKey:@"dk"] integerValue]==51  || [[dict valueForKey:@"dk"] integerValue]==15 || [[dict valueForKey:@"dk"]integerValue]==3 || [[dict valueForKey:@"dk"]integerValue]==19|| [[dict valueForKey:@"dk"]integerValue]==18 || [[dict valueForKey:@"dt"] isEqualToString:@"IN"]) {
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
            }else if(([[dict valueForKey:@"dk"]integerValue]!=5 || [[dict valueForKey:@"dk"]integerValue]!=151)&&[[dict valueForKey:@"dt"] isEqualToString:@"WT"]){
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890*"];
            }
            else{
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890."];
            }
            
            NSRange location = [string rangeOfCharacterFromSet:characterSet];
            if(location.location != NSNotFound){
                if (([newString integerValue] >= [strMinVal integerValue]) && ([newString integerValue] <= [strMaxVal integerValue])) {
                    
                    if([[dict valueForKey:@"dk"] integerValue]==51  || [[dict valueForKey:@"dk"] integerValue]==15 || [[dict valueForKey:@"dk"] integerValue]==19 || [[dict valueForKey:@"dk"] integerValue]==42|| [[dict valueForKey:@"dk"]integerValue]==18 || [[dict valueForKey:@"dt"] isEqualToString:@"IN"]) {
                        if ((location.location != NSNotFound) && ([newString length]<=[strMaxVal length])) {
                            [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                            [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                            
                            return YES;
                        }else {
                            return NO;
                        }
                    }else if(([[dict valueForKey:@"dk"]integerValue]!=5 || [[dict valueForKey:@"dk"]integerValue]!=151)&&[[dict valueForKey:@"dt"] isEqualToString:@"WT"]){
                        if ((location.location != NSNotFound) && ([newString length]<=[strMaxVal length])) {
                            [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                            [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                            
                            return YES;
                        }else {
                            return NO;
                        }
                    }
                    else {
                        if ((location.location != NSNotFound) && ([newString integerValue] >= [strMinVal integerValue]) && ([newString integerValue] <= [strMaxVal integerValue])) {
                            [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                            [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                            return ((location.location != NSNotFound) && ([newString integerValue] >= [strMinVal integerValue]) && ([newString integerValue] <= [strMaxVal integerValue]));
                        }
                        else{
                            return NO;
                        }
                    }
                }
                else {
                    //[self notinRangeMessage:dict];
                    return NO;
                }
            }else{
                return NO;
            }
        }
        else if ([stnumberofchars integerValue]>0) {
            //if([string isEqualToString:@""]) return YES;
            if ([[dict valueForKey:@"dk"] integerValue]==32) {
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                
                if (((location.location != NSNotFound) && (newString.length <=[[dict valueForKey:@"nC"] integerValue])) || [string isEqualToString:@""]) {
                    [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                    
                    return (((location.location != NSNotFound) && (newString.length <=[[dict valueForKey:@"nC"] integerValue])) || [string isEqualToString:@""]);
                }
                else
                    return NO;
            }
            else if ([stnumberofchars length]>0 || [string isEqualToString:@""]){
                if (newString.length <=[[dict valueForKey:@"nC"] integerValue]) {
                    [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
                    return (newString.length <=[[dict valueForKey:@"nC"] integerValue]);
                }else{
                    return NO;
                }
            }
        }
        
        if ([[dict valueForKey:@"dk"]integerValue]!=92){
            [self.dictDynamic setValue:newString forKey:[dict valueForKey:@"Lb"]];
            [dictJson setValue:newString forKey:[dict valueForKey:@"dk"]];
        }
        else if ([[dict valueForKey:@"dk"] integerValue] == 92){
            __block NSMutableDictionary *dictText;
            [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key integerValue]==92) {
                    dictText = obj;
                }
            }];
            
            if ([textField.placeholder isEqualToString:@"Prefix"]) {
                if([string isEqualToString:@" "]){
                    return NO;
                }
                else if ((newString.length <= 6) || [string isEqualToString:@""]) {//(location.location != NSNotFound)
                    [dictText setValue:newString forKey:@"first"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    return ((newString.length <= 6) || [string isEqualToString:@""]);
                }
                else{
                    return NO;
                }
            }else if ([textField.placeholder isEqualToString:@"From"]){
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                
                if (((location.location != NSNotFound) && ([newString length] < 10)) || [string isEqualToString:@""]) {
                    [dictText setValue:newString forKey:@"second"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    
                    return (((location.location != NSNotFound) && ([newString length] < 10)) || [string isEqualToString:@""]);
                }
                else
                    return NO;
            }
            else if ([textField.placeholder isEqualToString:@"To"]){
                NSCharacterSet *characterSet = nil;
                characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
                NSRange location = [string rangeOfCharacterFromSet:characterSet];
                
                if (((location.location != NSNotFound) && ([newString length] < 10)) || [string isEqualToString:@""]) {
                    [dictText setValue:newString forKey:@"third"];
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    
                    return (((location.location != NSNotFound) && ([newString length] < 10)) || [string isEqualToString:@""]);
                }
                else
                    return NO;
            }
        }
        
        if([string isEqualToString:@""])
            return YES;
        
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in shouldChangeCharactersInRange- %@",[exception description]);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    @try{
        
        //        for (int i=(int)indexPath.row+1;i<self.arrDynamic.count;i++) {
        //            NSDictionary *dict = [self.arrDynamic objectAtIndex:i];
        //
        //             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //
        //            NSString *strDataType  = [self getViewType:[dict valueForKey:@"datatype"]?[dict valueForKey:@"datatype"]:@""];
        //            if ([strDataType isEqualToString:@"TextField"]) {
        //                UITableViewCell *cell = [self.tblDynamic cellForRowAtIndexPath:indexPath];
        //                UITextField *txtDynamic = (UITextField*)[cell viewWithTag:2];
        //                [txtDynamic becomeFirstResponder];
        //            }
        //        }
        
        [textField resignFirstResponder];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in textFieldShouldReturn in ViewController- %@",[exception description]);
    }
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

float animatedDistance;

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeTextField = textView;
    
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        heightFraction = 0.0;
    }else if(heightFraction > 1.0){
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }else{
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // self.activeTextField = nil;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    [textField selectAll:nil];
    self.activeTextField = textField;
    
    //            UITableViewCell* cell = (UITableViewCell*)[[textField superview] superview];
    //            if (textField.tag==12){
    //                cell = [(UITableViewCell*)[[textField superview] superview] superview];
    //            }
    //            else if (textField.tag==13 || (textField.tag==14)){
    //                cell = [[(UITableViewCell*)[[textField superview] superview] superview] superview];
    //            }
    //            else if (textField.tag==100 || (textField.tag==101)){
    //                cell = [(UITableViewCell*)[[textField superview] superview] superview] ;
    //            }
    //
    //            NSIndexPath *indexPath = [self.tblDynamic indexPathForCell:cell];
    //
    //    NSIndexPath* path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    //    [self performSelector:@selector(scrollToCell:) withObject:path afterDelay:0.5f];
}

//-(void) scrollToCell:(NSIndexPath*) path {
//    [self.tblDynamic scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}

-(void)getRFID:(NSString*)transponder index:(NSInteger)index {
    @try {
        NSDictionary *dict = [self.arrDynamic objectAtIndex:index];
        
        if ([[ControlSettings sharedSettings] isNetConnected ]) {
            _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            [_customIOS7AlertView showLoaderWithMessage:strWait];
            
            //
            NSMutableDictionary *dictHeaders = [[NSMutableDictionary alloc]init];
            [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
            [dict setValue:transponder forKey:@"transponder"];
            //
            
            [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&transponder=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],transponder] idOfServiceUrl:15 headers:dictHeaders methodType:@"GET" onSucess:^(NSString *responseData) {
                [_customIOS7AlertView close];
                
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                isRFIDCalled = NO;
                
                if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]){
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }else{
                    NSLog(@"");
                    if (![[dictResponse valueForKey:@"ResultString"] isKindOfClass:[NSNull class]]) {
                        [self.dictDynamic setValue:[dictResponse valueForKey:@"ResultString"]?[dictResponse valueForKey:@"ResultString"]:@"" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:[dictResponse valueForKey:@"ResultString"]?[dictResponse valueForKey:@"ResultString"]:@"" forKey:[dict valueForKey:@"dk"]];
                        [self.tblDynamic reloadData];
                    }
                }
                
                NSLog(@"responseData=%@",responseData);
            } onFailure:^(NSMutableDictionary *responseData, NSError *error){
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                //
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                
                NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@,Descripyion=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,self.lblSelectedValue.text,@"on calling Rfid service"];
                [tracker set:kGAIScreenName value:strErr];
                
                [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                
                //
                
                //
                
                if ([responseData.allKeys containsObject:@"code"]) {
                    if ([[responseData valueForKey:@"code"]integerValue] ==401) {
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:strUnauthorised
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                        
                        // [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if ([[responseData valueForKey:@"code"]integerValue] ==408) {
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:[responseData valueForKey:@"Error"]
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 //[self.navigationController popViewControllerAnimated:YES];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                        
                        // [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
                else{
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[responseData valueForKey:@"Error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //[self.navigationController popToRootViewControllerAnimated:YES];
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                [_customIOS7AlertView close];
            }];
        } else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strNoInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in getRFID=%@",exception.description);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    @try {
        isFromKeybord = YES;
        NSDictionary *info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.tblDynamic.contentInset = contentInsets;
        _tblDynamic.scrollIndicatorInsets = contentInsets;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in keyboardWasShown in ViewController =%@",exception.description);
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    @try {
        [self.activeTextField resignFirstResponder];
        isFromKeybord = NO;
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.tblDynamic.contentInset = contentInsets;
        self.tblDynamic.scrollIndicatorInsets = contentInsets;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in keyboardWillHide in ViewController =%@",exception.description);
    }
}

#pragma mark - Other methods
- (IBAction)btnClear_tapped:(id)sender {
    @try {
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        if (![strFromDataEntry isEqualToString:@"1"]){
            [_dictDynamic removeAllObjects];
            [dictJson removeAllObjects];
            __block NSDictionary *dictBarnData,*dictForBarnRoomPen;
            dictForBarnRoomPen = [[NSDictionary alloc]init];
            dictBarnData = [[NSDictionary alloc]init];
            
            for (NSMutableDictionary *dict  in _arrDynamic){
                if ([[dict valueForKey:@"dk"] integerValue] == 92){
                    NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
                    [dictText setValue:@"" forKey:@"first"];
                    [dictText setValue:@"" forKey:@"second"];
                    [dictText setValue:@"" forKey:@"third"];
                    
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    // [_dictDynamic setObject:dictText forKey:[dict valueForKey:@"Lb"]];
                }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])){
                    NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
                    [dictText setValue:@"" forKey:@"first"];
                    [dictText setValue:@"" forKey:@"second"];
                    
                    [dictJson setObject:dictText forKey:[dict valueForKey:@"dk"]];
                    //[_dictDynamic setObject:dictText forKey:[dict valueForKey:@"Lb"]];
                }else if([[dict valueForKey:@"dk"] integerValue] == 6){
                    NSMutableDictionary *dictBarn = [[NSMutableDictionary alloc]init];
                    [dictBarn setValue:@"" forKey:@"br"];
                    [dictBarn setValue:@"" forKey:@"rm"];
                    [dictBarn setValue:@"" forKey:@"pn"];
                    
                    NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
                    [dictData setValue:@"" forKey:@"br"];
                    [dictData setValue:@"" forKey:@"rm"];
                    [dictData setValue:@"" forKey:@"pn"];
                    
                    [_dictDynamic setObject:dictBarn forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setObject:dictData forKey:[dict valueForKey:@"dk"]];
                }
                else if([[dict valueForKey:@"dk"] integerValue] != 6){
                    [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
                    [dictJson setValue:@"" forKey:[dict valueForKey:@"dk"]];
                }
            }
            
            [self fillDefaultValuesForMandatoryFields];
        }else{
            [_dictDynamic removeAllObjects];
            [dictJson removeAllObjects];
            
            NSMutableDictionary *dctReload = [[NSMutableDictionary alloc]initWithDictionary:_dictReload copyItems:YES];
//            NSMutableDictionary *dctjsn=[dctReload objectForKey:@"dataToSend"];
//            NSMutableDictionary *dctRes=[dctReload objectForKey:@"dataToDisplay"];

            NSMutableDictionary *dctjsn=[dctReload valueForKey:@"dataToSend"];
            NSMutableDictionary *dctRes=[dctReload valueForKey:@"dataToDisplay"];
            NSLog(@"  dataToSend=%@",dctjsn);
            NSLog(@"dataToDisplay=%@",dctRes);
            
            dictJson = [[NSMutableDictionary alloc]initWithDictionary:dctjsn copyItems:YES];
            _dictDynamic = [[NSMutableDictionary alloc]initWithDictionary:dctRes copyItems:YES];

           // dictJson =[dctReload objectForKey:@"dataToSend"] ;
            //_dictDynamic =[dctReload objectForKey:@"dataToDisplay"];
            NSLog(@"  dataToSend=%@",dictJson);
            NSLog(@"dataToDisplay=%@",_dictDynamic);
            
           
            //[self callEdit];
            
        }
        
        [self.tblDynamic reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnClear_tapped=%@",exception.description);
    }
}

- (IBAction)btnSave_tapped:(id)sender {
    @try {
        [self.activeTextField resignFirstResponder];
        NSString *strMustValue = @"You must enter value for ";
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"You must enter a value for ", @"Need to define range of numbers for the gilts that arrived.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1.count!=0){
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<1; i++) {
                if (i==0) {
                    if ([dictMenu objectForKey:[@"You must enter a value for " uppercaseString]] && ![[dictMenu objectForKey:[@"You must enter a value for " uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"You must enter a value for" uppercaseString]] length]>0) {
                            strMustValue = [dictMenu objectForKey:[@"You must enter a value for" uppercaseString]]?[dictMenu objectForKey:[@"You must enter a value for" uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
        
        //strMustValue = [strMustValue stringByReplacingOccurrencesOfString:@"#1" withString:@""];
        
        __block NSDictionary *dictBarnData,*dictForBarnRoomPen;
        __block NSDictionary *dictTextFieldData,*dictForGuilt,*dictPigletsData,*dictForPiglets;
        
        NSMutableArray *arrLableList = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in _arrDynamic) {
            NSString *str  = [_dictDynamic valueForKey:[dict valueForKey:@"Lb"]];
            
            if ([[dict valueForKey:@"dk"] integerValue] == 92){
                dictForGuilt = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key integerValue]==92)
                     {
                         dictTextFieldData = obj;
                     }
                 }];
            }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])){
                dictForPiglets = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key integerValue]==92){
                        dictPigletsData = obj;
                    }
                }];
            }else if([[dict valueForKey:@"dk"] integerValue] == 6){
                dictForBarnRoomPen = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"6"])
                     {
                         dictBarnData = obj;
                     }
                 }];
            }
            else {//if([[dict valueForKey:@"dk"] integerValue] != 6)
                if ([[dict valueForKey:@"co"] isEqualToString:@"1"] && str.length==0){
                    [arrLableList addObject:[dict valueForKey:@"Lb"]];
                }
            }
        }
        
        if (arrLableList.count>0) {
            NSString *strLastLbl = @"";
            if (arrLableList.count>=2) {
                strLastLbl = [@" and "stringByAppendingString:[arrLableList lastObject]];
                [arrLableList removeLastObject];
            }
            
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:[[[strMustValue stringByAppendingString:[arrLableList componentsJoinedByString:@","]] stringByAppendingString:strLastLbl] stringByAppendingString:@"."]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
            
            return;
        }
        
        NSArray *arrKeys = [dictBarnData allKeys];
        for (int i=0;i<arrKeys.count;i++){
            {
                __block NSString *strKey,*strBarn,*strRoom,*strPen;
                
                //[dictForBarnRoomPen setValue:@"1" forKey:@"co"];
                [dictBarnData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"br"]){
                        strBarn = obj?obj:@"";
                        strKey =@"barn";
                    }
                    else if ([key isEqualToString:@"rm"]) {
                        strRoom = obj?obj:@"";
                        strKey =@"room";
                    }
                    else if ([key isEqualToString:@"pn"]) {
                        strKey =@"pen";
                        strPen = obj?obj:@"";
                    }
                }];
                
                NSString *barn,*room,*pen;
                barn = @"Barn";
                room = @"Room";
                pen = @"Pen";
                
                NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Barn",@"Room",@"Pen",nil]];
                NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                
                if (resultArray1.count!=0){
                    for (int i=0; i<resultArray1.count; i++){
                        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                    }
                    
                    for (int i=0; i<1; i++) {
                        if (i==0) {
                            if ([dictMenu objectForKey:[@"Barn" uppercaseString]] && ![[dictMenu objectForKey:[@"Barn" uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[@"Barn" uppercaseString]] length]>0) {
                                    barn = [dictMenu objectForKey:[@"Barn" uppercaseString]]?[dictMenu objectForKey:[@"Barn" uppercaseString]]:@"";
                                }
                            }else if ([dictMenu objectForKey:[@"Room" uppercaseString]] && ![[dictMenu objectForKey:[@"Room" uppercaseString]] isKindOfClass:[NSNull class]]){
                                if ([[dictMenu objectForKey:[@"Room" uppercaseString]] length]>0) {
                                    room = [dictMenu objectForKey:[@"Room" uppercaseString]]?[dictMenu objectForKey:[@"Room" uppercaseString]]:@"";
                                }
                            }else if ([dictMenu objectForKey:[@"Pen" uppercaseString]] && ![[dictMenu objectForKey:[@"Pen" uppercaseString]] isKindOfClass:[NSNull class]]){
                                if ([[dictMenu objectForKey:[@"Pen" uppercaseString]] length]>0) {
                                    pen = [dictMenu objectForKey:[@"Pen" uppercaseString]]?[dictMenu objectForKey:[@"Pen" uppercaseString]]:@"";
                                }
                            }
                        }
                    }
                }
                
                //
                if ([[dictForBarnRoomPen valueForKey:@"co"] isEqualToString:@"1"] && strBarn.length==0 && strBarn!=nil){
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[[strMustValue stringByAppendingString:barn] stringByAppendingString:@"."]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    
                    return;
                }else  if ([[dictForBarnRoomPen valueForKey:@"co"] isEqualToString:@"1"] && strRoom.length==0 && strRoom!=nil){
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[[strMustValue stringByAppendingString:room] stringByAppendingString:@"."]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    
                    return;
                }
                else  if ([[dictForBarnRoomPen valueForKey:@"co"] isEqualToString:@"1"] && strPen.length==0 && strPen!=nil){
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[[strMustValue stringByAppendingString:pen] stringByAppendingString:@"."]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    
                    return;
                }
            }
        }
        
        NSArray *arrTextKeys = [dictTextFieldData allKeys];
        __block NSString *strSecond,*strThird;
        
        for (int i=0;i<arrTextKeys.count;i++){
            NSString *strFrom,*strTo;
            strFrom = @"From";
            strTo = @"To";
            
            NSString *strGiltMSg = @"Need to define range of numbers for the gilts that arrived.";
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"From",@"To",nil]];
            NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
            
            if (resultArray1.count!=0){
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                for (int i=0; i<1; i++) {
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Need to define range of numbers for the gilts that arrived." uppercaseString]] && ![[dictMenu objectForKey:[@"Need to define range of numbers for the gilts that arrived." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Need to define range of numbers for the gilts that arrived." uppercaseString]] length]>0) {
                                strGiltMSg = [dictMenu objectForKey:[@"Need to define range of numbers for the gilts that arrived." uppercaseString]]?[dictMenu objectForKey:[@"Need to define range of numbers for the gilts that arrived." uppercaseString]]:@"";
                            }
                        }
                    }
                }
            }
            
            [dictTextFieldData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                if ([key isEqualToString:@"second"]) {
                    strSecond = obj?obj:@"";
                    
                }
                else if ([key isEqualToString:@"third"]) {
                    strThird = obj?obj:@"";
                }
            }];
            
            if ([[dictForGuilt valueForKey:@"co"] isEqualToString:@"1"] && strSecond.length==0 && strSecond!=nil){
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:strGiltMSg
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
                
                return;
            }
            else  if ([[dictForGuilt valueForKey:@"co"] isEqualToString:@"1"] && strThird.length==0 && strThird!=nil){
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:strGiltMSg
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
                
                return;
            }
        }
        
        if ([[dictJson allKeys]containsObject:@"32"] && strEventCode.integerValue == 52) {
            if ([[dictJson valueForKey:@"32"] length]==0) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:@"Are you sure you want to continue without trasponder?"
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yes = [UIAlertAction
                                      actionWithTitle:strYes
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action){
                                          [self callEventSaveService];
                                      }];
                
                UIAlertAction* no = [UIAlertAction
                                     actionWithTitle:strNo
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: yes];
                [myAlertController addAction: no];
                
                [self presentViewController:myAlertController animated:YES completion:nil];
            }else{
                [self callEventSaveService];
            }
        }else {
            [self callEventSaveService];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSave_tapped=%@",exception.description);
    }
}

-(void)callEventSaveService {
    NSString *strSaved = @"Saved successfully";
    NSString *strSavedLitterNote = @"Litter Note Event added successfully";//Need to code yog
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Saved successfully",@"Litter Note Event added successfully", nil]];
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    for (int i=0; i<resultArray1.count; i++){
        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
    }
    
    for (int i=0; i<2; i++) {
        if (i==0) {
            if ([dictMenu objectForKey:[@"Saved successfully" uppercaseString]] && ![[dictMenu objectForKey:[@"Saved successfully" uppercaseString]] isKindOfClass:[NSNull class]]) {
                if ([[dictMenu objectForKey:[@"Saved successfully" uppercaseString]] length]>0) {
                    strSaved = [dictMenu objectForKey:[@"Saved successfully" uppercaseString]]?[dictMenu objectForKey:[@"Saved successfully" uppercaseString]]:@"";
                }
            }else if (i==1){
                if ([dictMenu objectForKey:[@"Litter Note Event added successfully" uppercaseString]] && ![[dictMenu objectForKey:[@"Litter Note Event added successfully" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Litter Note Event added successfully" uppercaseString]] length]>0) {
                        strSavedLitterNote = [dictMenu objectForKey:[@"Litter Note Event added successfully" uppercaseString]]?[dictMenu objectForKey:[@"Litter Note Event added successfully" uppercaseString]]:@"";
                    }
                }
            }
        }
    }
    
    @try {
        [self.activeTextField resignFirstResponder];
        
        NSString *strServiceName= @"";
        switch ([strEventCode integerValue]) {
            case 1:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTSemenPurchase?";
                break;
            case 2:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTBoar?";
                break;
            case 4:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTGilt?";
                break;
            case 5:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTGiltRetained?";
                break;
            case 6:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTSowArrival?";
                break;
            case 8:
                strServiceName = @"/SrvEVTArival.svc/SaveEVTBatchGiltArrival?";
                break;
            case 11:
                strServiceName = @"/SrvEVTDepartures.svc/SaveEVTSowDeath?";
                break;
            case 10:
                strServiceName = @"/SrvEVTDepartures.svc/SaveEVTBoarDeath?";
                break;
            case 13:
                strServiceName = @"/SrvEVTDepartures.svc/SaveEVTSowSale?";
                break;
            case 12:
                strServiceName = @"/SrvEVTDepartures.svc/SaveEVTBoarSale?";
                break;
            case 44:
                strServiceName = @"/SrvEVTDepartures.svc/SaveEVTFemaleTransfer?";
                break;
            case 21:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTAbortion?";
                break;
            case 22:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTBoarGrCreation?";
                break;
            case 23:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTBoarGrJoin?";
                break;
            case 24:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTBoarGrLeave?";
                break;
            case 17:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTGiltAvailable?";
                break;
            case 19:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTMating?";
                break;
            case 18:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTHeatCheck?";
                break;
            case 20:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTPregnancyCheck?";
                break;
            case 25:
                strServiceName = @"/SrvEVTMatings.svc/SaveEVTSemenCollection?";
                break;
            case 26:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTFarrowing?";
                break;
            case 27:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTFostering?";
                break;
            case 28:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTPartWeaning?";
                break;
            case 30:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTBatchWeaning?";
                break;
            case 31:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTNurseSow?";
                break;
            case 32:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTPigletLoss?";
                break;
            case 33:
                strServiceName = @"/SrvEVTHealth.svc/SaveEVTBoarTreatment?";
                break;
            case 34:
                strServiceName = @"/SrvEVTHealth.svc/SaveEVTSowTreatment?";
                break;
            case 35:
                strServiceName = @"/SrvEVTHealth.svc/SaveEVTPigletTreatment?";
                break;
            case 48:
                strServiceName = @"/SrvEVTHealth.svc/SaveEVTBoarBatchTreatment?";
                break;
            case 49:
                strServiceName = @"/SrvEVTHealth.svc/SaveEVTSowBatchTreatment?";
                break;
            case 36:
                strServiceName = @"/SrvEVTMiscellaneous.svc/SaveEVTBoarRetag?";
                break;
            case 37:
                strServiceName = @"/SrvEVTMiscellaneous.svc/SaveEVTFemaleRetag?";
                break;
            case 38:
                strServiceName = @"/SrvEVTMiscellaneous.svc/SaveEVTBoarMovement?";
                break;
            case 39:
                strServiceName = @"/SrvEVTMiscellaneous.svc/SaveEVTFemaleMovement?";
                break;
            case 52:
                strServiceName = @"/SrvEVTMiscellaneous.svc/SaveEVTTransponder?";
                break;
            case 40:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTBoarNote?";
                break;
            case 41:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTFemaleNote?";
                break;
            case 43:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTLitterNote?";
                break;
            case 45:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTBoarFlag?";
                break;
            case 46:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTFemaleFlag?";
                break;
            case 50:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTBoarBodyCondition?";
                break;
            case 51:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTFemaleBodyCondition?";
                break;
            case 15:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTBoarMarkForCull?";
                break;
            case 16:
                strServiceName = @"/SrvEVTNotesFlags.svc/SaveEVTFemaleMarkForCull?";
                break;
            case 29:
                strServiceName = @"/SrvEVTFarrowing.svc/SaveEVTCompleteWeaning?";
                break;
            default:
                break;
        }
        
        NSString *reqStringFUll=@"{";
        NSInteger x = 0;
        
        for (NSDictionary *dict in _arrDynamic) {
            x++;
            NSString *strKey = [dict valueForKey:@"dk"]?[dict valueForKey:@"dk"]:@"";
            NSMutableString *strValue = [dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@"";
            
            if ([strValue isKindOfClass:[NSString class]]) {
                if ([strValue rangeOfString:@"\""].location != NSNotFound) {
                    strValue = (NSMutableString*)[strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                }
            }
            
            if ([[dict valueForKey:@"dk"] integerValue] == 48){
                NSArray *arr = [strValue componentsSeparatedByString:@"\n"];
                strValue = (NSMutableString*)@"\\\"";
                strValue = (NSMutableString*)[strValue stringByAppendingString:[arr componentsJoinedByString:@"\\\"\\n\\\""]];//[arr componentsJoinedByString:@"\"\""];
                strValue = (NSMutableString*)[strValue stringByAppendingString:@"\\\""];
                reqStringFUll = (NSMutableString*)[reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",strKey,strValue]];
                
            }else if ([[dict valueForKey:@"dk"] integerValue] == 92){
                __block NSDictionary *dictTextFieldData,*dictForGuilt;
                
                dictForGuilt = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key integerValue]==92){
                        dictTextFieldData = obj;
                    }
                }];
                
                strValue = [dictTextFieldData valueForKey:@"first"];
                
                for (int i = (int)strValue.length; i<6; i++) {
                    strValue = (NSMutableString*)[strValue stringByAppendingString:@" "];
                }
                
                strValue = (NSMutableString*)[[[[strValue stringByAppendingString:@" "] stringByAppendingString:[dictTextFieldData valueForKey:@"second"]] stringByAppendingString:@"^"] stringByAppendingString:[dictTextFieldData valueForKey:@"third"]];
                
                reqStringFUll = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",strKey,strValue]];
                
            }else if (([[dict valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@"dk"] integerValue]==15 && [self isTwoText])) {
                __block NSDictionary *dictTextFieldData,*dictForGuilt;
                strValue=(NSMutableString*)@"";
                dictForGuilt = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key integerValue]==51 ||[key integerValue]==15) {
                        dictTextFieldData = obj;
                    }
                }];
                
                strValue = (NSMutableString*)[[[strValue stringByAppendingString:[dictTextFieldData valueForKey:@"first"]] stringByAppendingString:@"-"] stringByAppendingString:[dictTextFieldData valueForKey:@"second"]];
                
                reqStringFUll = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",strKey,strValue]];
            }else if([[dict valueForKey:@"dk"] integerValue] == 6) {
                __block NSMutableDictionary *dictBarn;
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"6"]) {
                        dictBarn = obj;
                    }
                }];
                
                __block NSString *strBarn,*strRoom,*strPen;
                
                [dictBarn enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"br"]){
                        strBarn = obj;
                    }
                    else if ([key isEqualToString:@"rm"]) {
                        strRoom = obj;
                    }
                    else if ([key isEqualToString:@"pn"]) {
                        strPen = obj;
                    }
                }];
                
                NSPredicate  *predicate;
                
                if (strBarn.length>0 && strRoom.length>0 && strPen.length>0) {
                    predicate= [NSPredicate predicateWithFormat:@"br = %@ AND rm = %@ AND pn=%@",strBarn?strBarn:@"", strRoom?strRoom:@"",strPen?strPen:@""];
                }else if (strRoom.length>0 && strBarn.length>0){
                    predicate= [NSPredicate predicateWithFormat:@"br = %@ AND rm = %@ AND pn=nil",strBarn?strBarn:@"", strRoom?strRoom:@""];
                }else {
                    predicate= [NSPredicate predicateWithFormat:@"br = %@ AND rm = nil AND pn=nil",strBarn?strBarn:@""];
                }
                
                NSLog(@"strRoom=%@",strPen);
                NSLog(@"strRoom=%@",strRoom);
                
                NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
                NSArray *resultArray = [[CoreDataHandler sharedHandler] getValuesBarnRoomPen:@"Locations" column:@"id" andPredicate:predicate andSortDescriptors:[[NSArray alloc] initWithObjects:sortBy, nil]];
                
                for (int count=0; count<resultArray.count; count++) {
                    strValue = [[resultArray objectAtIndex:count] valueForKey:@"id"];
                }
                
                if (resultArray.count==0) {
                    strValue=(NSMutableString*) @"";
                }
                
                reqStringFUll = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",strKey,strValue]];
            }
            else if([[dict valueForKey:@"dk"] integerValue] != 6){
                reqStringFUll = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",strKey,strValue]];
            }
            
            if (x!=_arrDynamic.count) {
                reqStringFUll  = [reqStringFUll stringByAppendingString:@","];
                
            }else {
                NSString *strFromDataEntry = [[NSUserDefaults standardUserDefaults] valueForKey:@"FromDataEntry"];
                
                if ([strFromDataEntry isEqualToString:@"1"]){
                    reqStringFUll  = [reqStringFUll stringByAppendingString:@","];
                    reqStringFUll  = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"eventid\":\"%@\"",[_dict valueForKey:@"EventKey"]]];
                }
                reqStringFUll  = [reqStringFUll stringByAppendingString:@","];
                //
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                //[dateformate setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                [dateformate setDateFormat:@"yyyyMMdd HH:mm:ss"];
                NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                //
                reqStringFUll  = [reqStringFUll stringByAppendingString:[NSString stringWithFormat:@"\"SD\":\"%@\"",strDate]];
                reqStringFUll  = [reqStringFUll stringByAppendingString:@"}"];
            }
        }
        
        NSLog(@"dictJson=%@",dictJson);
        NSLog(@"_dictDynamic=%@",_dictDynamic);
        NSLog(@"reqStringFUll=%@",reqStringFUll);
        
        //reqStringFUll = [reqStringFUll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        NSLog(@"reqStringFUll=%@",reqStringFUll);
        NSError *error;
        
        NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc]init];
        [jsonDict setObject:reqStringFUll forKey:@"arguments"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                           options:kNilOptions error:nil];
        
        if(!jsonData && error) {
            NSLog(@"Error creating JSON: %@", [error localizedDescription]);
            return;
        }
        
        // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        
        if ([[ControlSettings sharedSettings] isNetConnected ]){
            _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            [_customIOS7AlertView showLoaderWithMessage:strWait];
            
            [ServerManager sendRequestEvent:[strServiceName stringByAppendingString:[NSString stringWithFormat:@"token=%@&ignoreWarnings=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"0"]] idOfServiceUrl:jsonData methodType:@"POST" onSucess:^(NSString *responseData) {
                [_customIOS7AlertView close];
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                // [dict setValue:@"Not connected" forKey:@"ResultString"];
                if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }else if ([[dict valueForKey:@"ResultString"] localizedCaseInsensitiveContainsString:@"Not connected"])
                { //to do too
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:NSLocalizedString(@"connection_lost", @"")
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
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
                                                     
                                                     [_customIOS7AlertView close];
                                                 }];
                                             }
                                             else {
                                                 UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                            message:strNoInternet
                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                 UIAlertAction* ok = [UIAlertAction
                                                                      actionWithTitle:strOk
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
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                else if (dict!=nil){
                    if ([[dict valueForKey:@"ResultString"] localizedCaseInsensitiveContainsString:@"Are you sure?"]){
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:[dict valueForKey:@"ResultString"]
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* yes = [UIAlertAction
                                              actionWithTitle:strYes
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action){
                                                  if ([[ControlSettings sharedSettings] isNetConnected ]){
                                                      _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                      [_customIOS7AlertView showLoaderWithMessage:strWait];
                                                      [ServerManager sendRequestEvent:[strServiceName stringByAppendingString:[NSString stringWithFormat:@"token=%@&ignoreWarnings=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"1"]] idOfServiceUrl:jsonData methodType:@"POST" onSucess:^(NSString *responseData) {
                                                          
                                                          [_customIOS7AlertView close];
                                                          id dict = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                                                          
                                                          
                                                          if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])
                                                          {
                                                              UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                         message:responseData
                                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                              UIAlertAction* ok = [UIAlertAction
                                                                                   actionWithTitle:strOk
                                                                                   style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action)
                                                                                   {
                                                                                       [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                                                                       [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                   }];
                                                              
                                                              [myAlertController addAction: ok];
                                                              [self presentViewController:myAlertController animated:YES completion:nil];
                                                          }else if ([dict isKindOfClass:[NSDictionary class]]) {
                                                              if ([[dict valueForKey:@"ResultString"] isEqualToString:strSaved]) {
                                                                  UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                             message:strSaved
                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                  
                                                                  UIAlertAction* ok = [UIAlertAction
                                                                                       actionWithTitle:strOk
                                                                                       style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * action)
                                                                                       {
                                                                                           NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
                                                                                           NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
                                                                                           if ([strFromDataEntry isEqualToString:@"1"]){
                                                                                               [self.navigationController popViewControllerAnimated:YES];
                                                                                           }else{
                                                                                               [self clearFileds];
                                                                                           }
                                                                                           [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                       }];
                                                                  
                                                                  [myAlertController addAction:ok];
                                                                  [self presentViewController:myAlertController animated:YES completion:nil];
                                                              }else{
                                                                  UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                             message:[dict valueForKey:@"ResultString"]
                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                  UIAlertAction* ok = [UIAlertAction
                                                                                       actionWithTitle:strOk
                                                                                       style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * action)
                                                                                       {
                                                                                           [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                       }];
                                                                  
                                                                  [myAlertController addAction: ok];
                                                                  [self presentViewController:myAlertController animated:YES completion:nil];
                                                              }
                                                          }
                                                          
                                                          NSLog(@"responseData=%@",responseData);
                                                      } onFailure:^(NSString *responseData, NSError *error) {
                                                          
                                                          id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                          //
                                                          NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                                                          [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                          NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                                                          
                                                          NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,self.lblSelectedValue.text];
                                                          [tracker set:kGAIScreenName value:strErr];
                                                          [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                                                          
                                                          [_customIOS7AlertView close];
                                                          
                                                          if (responseData.integerValue ==401) {
                                                              
                                                              UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                         message:strUnauthorised
                                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                              UIAlertAction* ok = [UIAlertAction
                                                                                   actionWithTitle:strOk
                                                                                   style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action) {
                                                                                       [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                                                                       [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                   }];
                                                              
                                                              [myAlertController addAction: ok];
                                                              [self presentViewController:myAlertController animated:YES completion:nil];
                                                              //[self.navigationController popToRootViewControllerAnimated:YES];
                                                          }else{
                                                              UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                         message:responseData
                                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                              UIAlertAction* ok = [UIAlertAction
                                                                                   actionWithTitle:strOk
                                                                                   style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action) {
                                                                                       [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                   }];
                                                              
                                                              [myAlertController addAction: ok];
                                                              [self presentViewController:myAlertController animated:YES completion:nil];
                                                          }
                                                          
                                                      }];
                                                      
                                                      [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                      
                                                  }else{
                                                      UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                 message:strNoInternet
                                                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction* ok = [UIAlertAction
                                                                           actionWithTitle:strOk
                                                                           style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action)                                                                          {
                                                                               [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                           }];
                                                      [myAlertController addAction: ok];
                                                      [self presentViewController:myAlertController animated:YES completion:nil];
                                                  }
                                              }];
                        
                        UIAlertAction* no = [UIAlertAction
                                             actionWithTitle:strNo
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action){
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: yes];
                        [myAlertController addAction: no];
                        
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }else if ([[dict valueForKey:@"ResultString"] isEqualToString:strSaved] || [[dict valueForKey:@"ResultString"] localizedCaseInsensitiveContainsString:strSavedLitterNote]){
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:strSaved
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
                                                 NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
                                                 
                                                 if ([strFromDataEntry isEqualToString:@"1"]) {
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 }else {
                                                     [self clearFileds];
                                                 }
                                                 
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }else if ([[dict valueForKey:@"ResultString"] localizedCaseInsensitiveContainsString:@"Not connected"]) {//to do too
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:NSLocalizedString(@"connection_lost", @"")
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
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
                                                         
                                                         // [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:responseData];
                                                         
                                                         [_customIOS7AlertView close];
                                                     }];
                                                 }
                                                 else {
                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                message:strNoInternet
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction* ok = [UIAlertAction
                                                                          actionWithTitle:strOk
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
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                    else {
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:[dict valueForKey:@"ResultString"]
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                }
                
                NSLog(@"responseData=%@",responseData);
            } onFailure:^(NSString *responseData, NSError *error) {
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                //
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                
                NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,self.lblSelectedValue.text];
                [tracker set:kGAIScreenName value:strErr];
                [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                
                if (responseData.integerValue ==401) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:strUnauthorised
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                
                [_customIOS7AlertView close];
            }];
        }else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strNoInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in callEventSaveService=%@",exception.description);
    }
}

-(void)clearFileds {
    @try {
        [self btnClear_tapped:nil];
    }
    
    //        NSLog(@"strTitleInt=%@",self.strTitleInt);
    //
    //        __block NSDictionary *dictBarnData,*dictForBarnRoomPen;
    //        NSArray *arrArrivalClear = [[NSArray alloc]initWithObjects:@"23",@"67",@"6", nil];//@"35" is dob field was not getting clear prev now made c hange
    //
    //        if ([self.strTitleInt isEqualToString:@"0"]) {
    //            for (NSMutableDictionary *dict  in _arrDynamic){
    //                if(![arrArrivalClear containsObject:[dict valueForKey:@"dk"]]){
    //                    [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
    //                    [dictJson setValue:@"" forKey:[dict valueForKey:@""]];
    //
    //                    NSString *strDataType  = [self getViewType:[dict valueForKey:@"datatype"]];
    //                    if ([strDataType isEqualToString:@"DropDown"]){
    //                        [self fillDropDn:0 dict:dict];
    //                    }
    //                }
    //            }
    //        }else if([self.strTitleInt isEqualToString:@"1"]){
    //            for (NSMutableDictionary *dict  in _arrDynamic){
    //
    //                if([self ifForDeparture:dict]){
    //                    [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
    //                    [dictJson setValue:@"" forKey:[dict valueForKey:@""]];
    //
    //                    NSString *strDataType  = [self getViewType:[dict valueForKey:@"datatype"]];
    //                    if ([strDataType isEqualToString:@"DropDown"]){
    //                        [self fillDropDn:0 dict:dict];
    //                    }
    //                }
    ////                else if((strEventCode.integerValue==13 && [[dict valueForKey:@""]integerValue]!=62) || (strEventCode.integerValue==12 && [[dict valueForKey:@""]integerValue]!=62)){
    ////                        [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
    ////                        [dictJson setValue:@"" forKey:[dict valueForKey:@""]];
    ////                }
    //            }
    //        }
    //        else {
    //            for (NSMutableDictionary *dict  in _arrDynamic){
    //                if([[dict valueForKey:@""] integerValue]!=67 && [[dict valueForKey:@""] integerValue]!=6){
    //                        [_dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
    //                        [dictJson setValue:@"" forKey:[dict valueForKey:@""]];
    //
    //                    NSString *strDataType  = [self getViewType:[dict valueForKey:@"datatype"]];
    //                    if ([strDataType isEqualToString:@"DropDown"]){
    //                        [self fillDropDn:0 dict:dict];
    //                    }
    //                }
    //               else if([strEventCode integerValue]==28 || [strEventCode integerValue]==29 || [strEventCode integerValue]==30 || [strEventCode integerValue]==31 ){
    //                    [_dictDynamic setValue:@"0" forKey:[dict valueForKey:@"Lb"]];
    //
    //                   if ([[dict valueForKey:@""] integerValue]==6){
    //
    //                       [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
    //                           if ([key isEqualToString:@"6"]){
    //                               dictBarnData = obj;
    //                           }
    //                       }];
    //
    //                       [dictBarnData setValue:@"" forKey:@"pen"];
    //                       [dictJson setObject:dictBarnData forKey:[dict valueForKey:@""]];
    //                   }else
    //                    [dictJson setValue:@"0" forKey:[dict valueForKey:@""]];
    //                }
    //            }
    //        }
    //
    //        for (NSMutableDictionary *dict  in _arrDynamic){
    //            if ([[dict valueForKey:@""] integerValue]==6){
    //                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
    //                     if ([key isEqualToString:@"6"]){
    //                         dictBarnData = obj;
    //                     }
    //                 }];
    //
    //                [dictBarnData setValue:@"" forKey:@"pen"];
    //                [dictJson setObject:dictBarnData forKey:[dict valueForKey:@""]];
    //            }else if ([[dict valueForKey:@""] integerValue] == 92){
    //                    NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
    //                    [dictText setValue:@"" forKey:@"first"];
    //                    [dictText setValue:@"" forKey:@"second"];
    //                    [dictText setValue:@"" forKey:@"third"];
    //                    [dictJson setObject:dictText forKey:[dict valueForKey:@""]];
    //            }else if (([[dict valueForKey:@""] integerValue]==51 && [self isTwoText]) || ([[dict valueForKey:@""] integerValue]==15 && [self isTwoText])){
    //                NSMutableDictionary *dictText = [[NSMutableDictionary alloc]init];
    //                [dictText setValue:@"" forKey:@"first"];
    //                [dictText setValue:@"" forKey:@"second"];
    //                [dictJson setObject:dictText forKey:[dict valueForKey:@""]];
    //            }
    //        }
    //
    //        NSLog(@"_dictDynamic=%@",_dictDynamic);
    //        NSLog(@"dictJson=%@",dictJson);
    //
    //        [self.tblDynamic reloadData];
    //    }
    @catch (NSException *exception) {
        NSLog(@"Exception in clearFileds=%@",exception.description);
    }
}

-(BOOL)ifForDeparture:(NSDictionary*)dict{
    @try {
        if([[dict valueForKey:@"dk"]integerValue]==141){
            return NO;
        }else if([[dict valueForKey:@"dk"]integerValue]==6)
        {
            return NO;
        }else if((strEventCode.integerValue==13 && [[dict valueForKey:@"dk"]integerValue]==62)){
            return NO;
        } else if( (strEventCode.integerValue==12 && [[dict valueForKey:@"dk"]integerValue]==62)){
            return NO;
        }else {
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in ifForDeparture =%@",exception.description);
    }
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)btnDropdown_tapped:(id)sender {
    @try {
        [self.activeTextField resignFirstResponder];
        
        NSSortDescriptor *sortBy; // = [[NSSortDescriptor alloc] initWithKey:@"ln"
        NSArray *sortDescriptors; // = [[NSArray alloc] initWithObjects:sortBy, nil];
        
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger TapedDropDownTag = btnTapped.tag;
        
        NSLog(@"TapedDropDownTag=%ld",(long)TapedDropDownTag);
        
        UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tblDynamic indexPathForCell:cell];
        NSDictionary *dict = [_arrDynamic objectAtIndex:indexPath.row];
        
        //serviceUrl=http://pcrds.farmsstaging.com/SrvReports_2.svc/GetWarningListNotServedReport?sortFld=&sortOrd=0&DaysSinceWean=0&DueToBeServed=20170529&FromRec=1&token=95294c0db0686c91bf121e64ec84be22&ToRec=20
        __block NSString *strTitle=[dict valueForKey:@"Lb"]?[dict valueForKey:@"Lb"]:@"";
        [_arrDropDown removeAllObjects];
        
        NSString *strPrevSelectedValue= [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
        NSInteger prevSelectedIndex  = 0;
        
        switch ([[dict valueForKey:@"dk"]integerValue]) {
            case 4: {
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                // sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                //                                       ascending:YES];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                
                NSString *strPredicate;
                if ([strEventCode isEqualToString:@"33"]||[strEventCode isEqualToString:@"48"]) {
                    strPredicate = @"br != 0 AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"34"]||[strEventCode isEqualToString:@"49"]) {
                    strPredicate = @"(sg != 0 OR sp != 0 or sd != 0 ) AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"35"]) {
                    strPredicate = @"pg != 0 AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"10"]||[strEventCode isEqualToString:@"12"]) {
                    strPredicate = @"br != 0 AND ds==1";
                }
                else if ([strEventCode isEqualToString:@"11"]||[strEventCode isEqualToString:@"13"]) {
                    strPredicate = @"(sg != 0 OR sp != 0 or sd != 0 ) AND ds==1";
                }
                else if ([strEventCode isEqualToString:@"32"]) {
                    strPredicate = @"pg != 0 AND ds==1";
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Conditions" andPredicate:predicate andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0){
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue]){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
                
            case 6:{
                __block NSMutableDictionary *dictBarnDataToSend;
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"6"]) {
                         dictBarnDataToSend = obj;
                     }
                 }];
                
                __block NSString *strBarn;
                __block NSString *strRoom;
                
                [dictBarnDataToSend enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"br"]){
                        strBarn = obj;
                    }
                    else if ([key isEqualToString:@"rm"]) {
                        strRoom = obj;
                    }
                }];
                
                NSPredicate *predicate;
                NSArray* resultArray ;
                if (TapedDropDownTag==2){
                    predicate  = [NSPredicate predicateWithFormat:@"sid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictBarnDataToSend valueForKey:@"br"]?[dictBarnDataToSend valueForKey:@"br"]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"br"
                                                         ascending:YES];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesBarnRoomPen:@"Locations" column:@"br" andPredicate:predicate andSortDescriptors:[[NSArray alloc] initWithObjects:sortBy, nil]];
                }else if (TapedDropDownTag==3){
                    predicate  = [NSPredicate predicateWithFormat:@"br=%@ AND sid=%@",strBarn,[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictBarnDataToSend valueForKey:@"rm"]?[dictBarnDataToSend valueForKey:@"rm"]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"rm"
                                                         ascending:YES];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesBarnRoomPen:@"Locations" column:@"rm" andPredicate:predicate andSortDescriptors:[[NSArray alloc] initWithObjects:sortBy, nil]];
                }else if (TapedDropDownTag==4){
                    predicate  = [NSPredicate predicateWithFormat:@"br = %@ AND rm = %@ AND sid=%@",strBarn, strRoom,[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictBarnDataToSend valueForKey:@"pn"]?[dictBarnDataToSend valueForKey:@"pn"]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"pn"
                                                         ascending:YES];
                    
                    resultArray = [[CoreDataHandler sharedHandler] getValuesBarnRoomPen:@"Locations" column:@"pn" andPredicate:predicate andSortDescriptors:[[NSArray alloc] initWithObjects:sortBy, nil]];
                    
                    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
                    for (int count=0; count<resultArray.count; count++){
                        if ([[[resultArray objectAtIndex:count] valueForKey:@"br"]length]>0) {
                            [arrTemp addObject:[resultArray objectAtIndex:count]];
                        }
                    }
                    
                    //                resultArray =[NSArray arrayWithArray:arrTemp];
                }
                
                if (TapedDropDownTag==2){
                    strTitle = @"Barn";
                }else if (TapedDropDownTag==3)
                {
                    strTitle =@"Room";
                }
                else if(TapedDropDownTag==4){
                    strTitle =@"Pen";
                }
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    if (TapedDropDownTag==2){
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"br"] forKey:@"visible"];
                    }else if (TapedDropDownTag==3)
                    {
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"rm"] forKey:@"visible"];
                    }
                    else if(TapedDropDownTag==4){
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"pn"] forKey:@"visible"];
                    }
                    
                    if ([[dict valueForKey:@"visible"] length]>0){
                        [_arrDropDown addObject:dict];
                    }
                }
                for (int count=0; count<_arrDropDown.count; count++){
                    NSDictionary *dict = [_arrDropDown objectAtIndex:count];
                    if (strPrevSelectedValue.length>0){
                        if( [strPrevSelectedValue caseInsensitiveCompare:[dict valueForKey:@"visible"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
                
                NSLog(@"_arrDropDown=%@",_arrDropDown);
            }
                break;
            case 8:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Pd_Results" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)  {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"]?[[resultArray objectAtIndex:count] valueForKey:@"dT"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"]?[[resultArray objectAtIndex:count] valueForKey:@"dK"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0){
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 9:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"it != '' AND sid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ln != '' || ln != nil"];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Operator" andPredicate:predicate andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0){
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue]){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 11:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Treatments" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)
                {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 13:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Tod" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"]?[[resultArray objectAtIndex:count] valueForKey:@"dT"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"]?[[resultArray objectAtIndex:count] valueForKey:@"dK"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 23: {
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                NSArray* resultArray;
                NSPredicate *predicate;
                if ([self.strEventCode isEqualToString:@"1"] || [self.strEventCode isEqualToString:@"2"]) {
                    predicate = [NSPredicate predicateWithFormat:@"sx == 'M' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }else if ([self.strEventCode isEqualToString:@"4"] || [self.strEventCode isEqualToString:@"5"] || [self.strEventCode isEqualToString:@"8"]||[self.strEventCode isEqualToString:@"6"]){
                    predicate = [NSPredicate predicateWithFormat:@"sx == 'F' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 34:{
                NSArray* resultArray;
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                if ([self.strEventCode isEqualToString:@"1"]){
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                         ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"AI_STUDS" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
                else {
                    strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ds"
                                                         ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Origin" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++) {
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ds"]?[[resultArray objectAtIndex:count] valueForKey:@"ds"]:@"" forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"sid"]?[[resultArray objectAtIndex:count] valueForKey:@"sid"]:@"" forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        //NSLog(@"site key=%@",[[resultArray objectAtIndex:count] valueForKey:@"siteKey"]);
                        
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"sid"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                        
                    }
                }
            }
                break;
            case 37:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Halothane" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"]?[[resultArray objectAtIndex:count] valueForKey:@"dT"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"]?[[resultArray objectAtIndex:count] valueForKey:@"dK"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame)
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 62:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                NSArray* resultArray;
                if ([self.strEventCode isEqualToString:@"12"] || [self.strEventCode isEqualToString:@"13"]||[self.strEventCode isEqualToString:@"29"] ||[self.strEventCode isEqualToString:@"30"] || [self.strEventCode isEqualToString:@"31"]|| [self.strEventCode isEqualToString:@"28"]) {
                    
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                         ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Packing_Plants" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        if (strPrevSelectedValue.length>0){
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue]){
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
                else {
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ds"
                                                         ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Destination" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ds"]?[[resultArray objectAtIndex:count] valueForKey:@"ds"]:@"" forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"sid"]?[[resultArray objectAtIndex:count] valueForKey:@"sid"]:@"" forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        if (strPrevSelectedValue.length>0){
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"sid"] integerValue]){
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
            }
                break;
            case 73:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Admin_Routes" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"]?[[resultArray objectAtIndex:count] valueForKey:@"dT"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"]?[[resultArray objectAtIndex:count] valueForKey:@"dK"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
            case 67: { //case 80:case 81:case 82:case 83:case 84:case 72:
                NSArray* resultArray;
                NSPredicate *predicate;
                NSString *strcategory;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"ConditionScore" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
                //
                
            case 80: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lesion_Scores" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
                
            case 81: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lock" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 82: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Leakage" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 83: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Quality" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
                
            case 84: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Standing_Reflex" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 72: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Test_Type" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
                //
                
            case 41: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"HerdCategory" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 47:{
                NSArray* resultArray;
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                if ([self.strEventCode isEqualToString:@"45"]){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sx != 'F' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }
                else{
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:nil andSortDescriptors:sortDescriptors];
                }
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 78:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Transport_Companies" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
                
            case 150:case 141:case 74:case 28:case 70:case 33:{
                NSDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:strNo forKey:@"visible"];
                [dict setValue:@"0" forKey:@"dataTosend"];
                [_arrDropDown addObject:dict];
                
                NSDictionary *dict1 = [[NSMutableDictionary alloc]init];
                [dict1 setValue:strYes forKey:@"visible"];
                [dict1 setValue:@"1" forKey:@"dataTosend"];
                [_arrDropDown addObject:dict1];
                
                if (strPrevSelectedValue.length>0){
                    if ([strPrevSelectedValue integerValue] == 1){
                        prevSelectedIndex = 1;
                    }else if ([strPrevSelectedValue integerValue] == 0){
                        prevSelectedIndex = 0;
                    }
                }
            }
                break;
            default:{
                NSString *strDataType  = [self getViewType:[dict valueForKey:@"dt"]];
                if ([strDataType isEqualToString:@"DropDown"]){
                    if ([[dict valueForKey:@"dk"] hasPrefix:@"UDF"]){
                        if ([[dict valueForKey:@"dt"] isEqualToString:@"BL"]){
                            NSDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setValue:strNo forKey:@"visible"];
                            [dict setValue:@"0" forKey:@"dataTosend"];
                            [_arrDropDown addObject:dict];
                            
                            NSDictionary *dict1 = [[NSMutableDictionary alloc]init];
                            [dict1 setValue:strYes forKey:@"visible"];
                            [dict1 setValue:@"1" forKey:@"dataTosend"];
                            [_arrDropDown addObject:dict1];
                            
                            if (strPrevSelectedValue.length>0){
                                if ([strPrevSelectedValue integerValue] == 1){
                                    prevSelectedIndex = 1;
                                } else if ([strPrevSelectedValue integerValue] == 0){
                                    prevSelectedIndex = 0;
                                }
                            }
                        }
                        else{
                            NSString *str = [dict valueForKey:@"op"];//opt
                            str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            //NSArray *arrStringComponents = [str componentsSeparatedByString:@","];
                            NSArray *sortedStrings = [str componentsSeparatedByString:@","];
                            
                            //
                            NSArray *arrStringComponents =
                            [sortedStrings sortedArrayUsingSelector:@selector(compare:)];
                            //
                            
                            for (int count=0; count<arrStringComponents.count; count++){
                                NSDictionary *dict = [[NSMutableDictionary alloc]init];
                                [dict setValue:[arrStringComponents objectAtIndex:count] forKey:@"visible"];
                                [dict setValue:[arrStringComponents objectAtIndex:count] forKey:@"dataTosend"];
                                [_arrDropDown addObject:dict];
                                
                                if (strPrevSelectedValue.length>0){
                                    if ([strPrevSelectedValue isEqualToString:[arrStringComponents objectAtIndex:count]]){
                                        prevSelectedIndex = count;
                                    }
                                }
                            }
                        }
                    }
                }
            }
                
                break;
        }
        
        if (![[dict valueForKey:@"co"] isEqualToString:@"1"]){
            if (_arrDropDown.count>0){
                NSDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:@"" forKey:@"visible"];
                [dict setValue:@"" forKey:@"dataTosend"];
                [_arrDropDown insertObject:dict atIndex:0];
            }
        }
        
        NSLog(@"weakSelf.dictDynamic=%@",_dictDynamic);
        self.pickerDropDown = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 10, 270, 150.0)];
        [self.pickerDropDown setDelegate:self];
        // self.pickerDropDown.showsSelectionIndicator = YES;
        
        // [[self.pickerDropDown.subviews objectAtIndex:1] setBackgroundColor:[UIColor redColor]];
        // [[self.pickerDropDown.subviews objectAtIndex:2] setBackgroundColor:[UIColor redColor]];
        
        _alertForOrgName = [[CustomIOS7AlertView alloc] init];
        [_alertForOrgName setMyDelegate:self];
        [_alertForOrgName setUseMotionEffects:true];
        [_alertForOrgName setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel, nil]];
        
        __weak typeof(self) weakSelf = self;
        
        [_alertForOrgName setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            
            if(buttonIndex == 0 && weakSelf.pickerDropDown>0){
                NSInteger row = [weakSelf.pickerDropDown selectedRowInComponent:0];
                NSDictionary *dict = [weakSelf.arrDynamic objectAtIndex:indexPath.row];
                
                if ([[dict valueForKey:@"dk"] integerValue] == 6){
                    // __block NSMutableDictionary *dictBarn;
                    __block NSMutableDictionary *dictBarnDataToSend;
                    
                    [weakSelf.dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                        if ([key isEqualToString:@"6"]){
                            dictBarnDataToSend = [obj mutableCopy];
                        }
                    }];
                    
                    NSString *strVal=[[weakSelf.arrDropDown objectAtIndex:row] valueForKey:@"visible"]?[[weakSelf.arrDropDown objectAtIndex:row] valueForKey:@"visible"]:@"";
                    
                    if (TapedDropDownTag==2) {
                        [dictBarnDataToSend setValue:strVal forKey:@"br"];
                        [dictBarnDataToSend setValue:@"" forKey:@"rm"];
                        [dictBarnDataToSend setValue:@"" forKey:@"pn"];
                    }else if (TapedDropDownTag==3){
                        [dictBarnDataToSend setValue:strVal forKey:@"rm"];
                        [dictBarnDataToSend setValue:@"" forKey:@"pn"];
                    }
                    else if (TapedDropDownTag==4){
                        [dictBarnDataToSend setValue:strVal forKey:@"pn"];
                    }
                    
                    //[weakSelf.dictDynamic setObject:dictBarn forKey:[dict valueForKey:@"Lb"]];
                    [weakSelf.dictJson setObject:dictBarnDataToSend forKey:[dict valueForKey:@"dk"]];
                }else {
                    [weakSelf.dictDynamic setValue:[[weakSelf.arrDropDown objectAtIndex:row] valueForKey:@"visible"] forKey:[dict valueForKey:@"Lb"]];
                    [weakSelf.dictJson setValue:[[weakSelf.arrDropDown objectAtIndex:row] valueForKey:@"dataTosend"] forKey:[dict valueForKey:@"dk"]];
                }
                
                NSLog(@"weakSelf.dictDynamic=%@",weakSelf.dictDynamic);
                NSLog(@"dictJson=%@",weakSelf.dictJson);
                
                [weakSelf.tblDynamic reloadData];
            }
            
            [weakSelf.alertForOrgName close];
        }];
        
        // NSLog(@"weakSelf.dictJson=%@",weakSelf.dictJson);
        
        if (![[dict valueForKey:@"co"] isEqualToString:@"1"]) {
            {
                [self.pickerDropDown selectRow:prevSelectedIndex+1 inComponent:0 animated:NO];
            }
        }
        else {
            if (_arrDropDown.count>=prevSelectedIndex){
                [self.pickerDropDown selectRow:prevSelectedIndex inComponent:0 animated:NO];
            }
        }
        
        [self.pickerDropDown setShowsSelectionIndicator:YES];
        
        if (_arrDropDown.count>0){
            [weakSelf.alertForOrgName showCustomwithView:self.pickerDropDown title:strTitle];
        }
        else {
            NSLog(@"no data");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnDropdown_tapped =%@",exception.description);
    }
}

- (IBAction)btnDate_tapped:(id)sender {
    @try {
        [self.activeTextField resignFirstResponder];
        UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
        NSIndexPath* indexPath = [self.tblDynamic indexPathForCell:cell];
        NSDictionary *dict = [_arrDynamic objectAtIndex:indexPath.row];
        NSString *strPrevSelectedValue= [dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@"";
        __block NSString *strTitle=[dict valueForKey:@"Lb"]?[dict valueForKey:@"Lb"]:@"";
        
        NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init];
        [dateFormatterr setDateFormat:@"YYYYMMdd"];
        NSDate *dt2 = [dateFormatterr dateFromString:strPrevSelectedValue];//YYYYMMDD
        
        self.dtPicker= [[UIDatePicker alloc] init];
        self.dtPicker.frame=CGRectMake(15, 20, 260, 150.0);
        self.dtPicker.datePickerMode = UIDatePickerModeDate;
        
        if ([[dict valueForKey:@"dk"]integerValue]!=22) {
            self.dtPicker.maximumDate=[NSDate date];
        }
        
        if (strPrevSelectedValue.length>0) {
            [self.dtPicker setDate:dt2];
        }
        else{
            [self.dtPicker setDate:[NSDate date]];
        }
        
        //
        NSDateFormatter *dateFormatterrr = [[NSDateFormatter alloc]init];
        [dateFormatterrr setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [dateFormatterrr dateFromString:@"1/1/1900"];
        self.dtPicker.minimumDate = date;
        //
        
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        
        _alertForPickUpDate = [[CustomIOS7AlertView alloc] init];
        [_alertForPickUpDate setMyDelegate:self];
        
        if ([strFromDataEntry isEqualToString:@"0"]) {
            if ([[dict valueForKey:@"ac"] integerValue]==1 && [[dict valueForKey:@"co"] integerValue]==1){
                [_alertForPickUpDate setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel, nil]];
            }else {
                [_alertForPickUpDate setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel,strClear, nil]];//
            }
        }else {
            [_alertForPickUpDate setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel,nil]];//yogita removed Clrbtn
        }
        
        [_alertForPickUpDate showCustomwithView:self.dtPicker title:strTitle];
        __weak typeof(self) weakSelf = self;
        
        [_alertForPickUpDate setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            if(buttonIndex == 0){
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                
                NSString *strSelectedDate = [formatter stringFromDate:weakSelf.dtPicker.date];
                NSString *strBaseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZD"];
                
                if ([[dict valueForKey:@"dk"] integerValue]==2){
                    [pref setObject:strSelectedDate forKey:@"PrevSelectedDate"];
                    [pref synchronize];
                }
                
                [dateFormatterr setDateFormat:@"YYYYMMdd"];//,MMMM dd
                NSString *strSelectedDateMMM = [dateFormatterr stringFromDate:weakSelf.dtPicker.date];
                [weakSelf.dictJson setValue:strSelectedDateMMM forKey:[dict valueForKey:@"dk"]];
                [weakSelf.dictJson setValue:strSelectedDateMMM forKey:[dict valueForKey:@"dk"]];//change strSelectedDate to strSelectedDateMMM
                
                if (isThousandFormat) {
                    [formatter setDateFormat:@"MM/dd/yyyy"];
                    NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
                    [formatter setDateFormat:@"YYYYMMdd"];
                    NSDate *BaseDate = [formatter dateFromString:strBaseDate];
                    int days = [dtselectedDate timeIntervalSinceDate:BaseDate]/24/60/60;
                    
                    NSString *strDate = [NSString stringWithFormat:@"%05d",days];
                    NSString *calFormat,*strFromString;
                    
                    if (strDate.length>=2) {
                        calFormat = [strDate substringToIndex:2];
                    }else {
                        calFormat = strDate;
                    }
                    
                    if (strDate.length>=3){
                        strFromString = [strDate substringFromIndex:2];
                    }
                    
                    calFormat = [[calFormat stringByAppendingString:@"-"] stringByAppendingString:strFromString?strFromString:@""];
                    [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
                    
                    NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                    
                    [weakSelf.dictDynamic setValue:strSelectedDate100 forKey:[dict valueForKey:@"Lb"]];
                }
                else if([weakSelf.strDateFormat isEqualToString:@"6"]){
                    [formatter setDateFormat:@"MM/dd/yyyy"];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
                    NSDate *Firstdate= [weakSelf getFirstDateOfCurrentYear:dtselectedDate];
                    
                    // NSDate *BaseDate = [formatter dateFromString:strBaseDate];
                    //int days = [dtselectedDate timeIntervalSinceDate:Firstdate]/24/60/60;
                    // NSLog(@"days:%d",days);
                    NSInteger days=[weakSelf daysBetweenDate:Firstdate andDate:dtselectedDate];
                    
                    NSLog(@"days:%ld",days);
                    
                    NSString *strDate = [NSString stringWithFormat:@"%03li",days];
                    [formatter setDateFormat:@"yy"];
                    
                    NSString *strSelectedDateyearformat = [[[formatter stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
                    
                    /*********************/
                    [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
                    
                    /***************/
                    
                    NSString *strSelectedDateDayOFYear = [[strSelectedDateyearformat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                    
                    /*****************/
                    
                    
                    /*[weakSelf.dictDynamic setValue:strSelectedDateyearformat forKey:[dict valueForKey:@"Lb"]];*/
                    [weakSelf.dictDynamic setValue:strSelectedDateDayOFYear forKey:[dict valueForKey:@"Lb"]];
                }
                else {
                    [weakSelf.dictDynamic setValue:strSelectedDate forKey:[dict valueForKey:@"Lb"]];
                }
            }else if(buttonIndex == 2){
                [weakSelf.dictJson setValue:@"" forKey:[dict valueForKey:@"dk"]];
                [weakSelf.dictDynamic setValue:@"" forKey:[dict valueForKey:@"Lb"]];
            }
            
            NSLog(@"buttonIndex=%d",buttonIndex);
            NSLog(@"dictjson=%@",weakSelf.dictJson);
            
            [weakSelf.tblDynamic reloadData];
            [alertView close];
        }];
        
        [weakSelf.alertForPickUpDate setUseMotionEffects:true];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception =%@",exception.description);
    }
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    @try{
        NSDate *fromDate;
        NSDate *toDate;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                     interval:NULL forDate:fromDateTime];
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                     interval:NULL forDate:toDateTime];
        
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:fromDate toDate:toDate options:0];
        
        return [difference day]+1;
    } @catch (NSException *exception) {
        NSLog(@"Exception in fillDefaultValuesForMandatoryFields=%@",exception.description);
    }
}

-(void)fillDefaultValuesForMandatoryFields {
    @try {
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        
        __block NSDictionary *dictBarnData,*dictForBarnRoomPen;
        for (NSMutableDictionary *dict  in _arrDynamic){
            NSLog(@"compuslary=%@",dict);
            
            NSString *strDataType  = [self getViewType:[dict valueForKey:@"dt"]];
            NSLog(@"compuslary=%@",[dict valueForKey:@"co"]);
            NSLog(@"strDataType=%@",strDataType);
            
            if([[dict valueForKey:@"dk"] integerValue] == 6){
                dictForBarnRoomPen = dict;
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([key integerValue]==6){
                        dictBarnData = obj;
                    }
                }];
            }
            else if ([strDataType isEqualToString:@"DropDown"]){
                [self fillDropDn:0 dict:dict];
            }
            else if ([strDataType isEqualToString:@"Date"] && [[dict valueForKey:@"dk"] integerValue]==2){
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                
                NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
                [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
                
                NSString *prevDate=[pref valueForKey:@"PrevSelectedDate"];
                NSString *strSelectedDate;
                NSString *strSelectedDatee;
                
                // prevDate=@"24/4/2017";
                
                if (prevDate.length==0) {
                    strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
                }else{
                    strSelectedDate = prevDate;
                }
                //SDate *dt2=[NSDate date];;
                [dateFormatterr setDateFormat:@"YYYYMMdd"];
                if (prevDate.length==0) {
                    strSelectedDatee = [dateFormatterr stringFromDate:[NSDate date]];
                    // dt2=[NSDate date];
                }else{
                    [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
                    NSDate *dt2 = [dateFormatterr dateFromString:prevDate];
                    [dateFormatterr setDateFormat:@"YYYYMMdd"];
                    strSelectedDatee = [dateFormatterr stringFromDate:dt2];
                }
                
                [dictJson setValue:strSelectedDatee forKey:[dict valueForKey:@"dk"]];
                
                if (isThousandFormat) {
                    NSString *strBaseDate = [pref valueForKey:@"ZD"];
                    [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
                    NSDate *dtselectedDate = [dateFormatterr dateFromString:strSelectedDate];
                    [dateFormatterr setDateFormat:@"YYYYMMdd"];
                    NSDate *BaseDate = [dateFormatterr dateFromString:strBaseDate];
                    int days = [dtselectedDate timeIntervalSinceDate:BaseDate]/24/60/60;
                    
                    NSString *strDate = [NSString stringWithFormat:@"%05d",days];
                    NSString *calFormat,*strFromString;
                    
                    if (strDate.length>=2) {
                        calFormat = [strDate substringToIndex:2];
                    }else{
                        calFormat = strDate;
                    }
                    
                    if (strDate.length>=3){
                        strFromString = [strDate substringFromIndex:2];
                    }
                    
                    calFormat = [[calFormat stringByAppendingString:@"-"] stringByAppendingString:strFromString?strFromString:@""];
                    [dateFormatterr setDateFormat:@"EEE,dd-MMM-yyyy"];
                    
                    NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[dateFormatterr stringFromDate:dtselectedDate]];
                    [_dictDynamic setValue:strSelectedDate100 forKey:[dict valueForKey:@"Lb"]];
                }else if([self.strDateFormat isEqualToString:@"6"]){
                    // NSString *strBaseDate = [pref valueForKey:@"ZD"];
                    [dateFormatterr setDateFormat:@"YYYYMMdd"];
                    [dateFormatterr setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

                    //  [dateFormatterr setTimeZone:[NSTimeZone defaultTimeZone]];
                    NSDate *dtselectedDate = [dateFormatterr dateFromString:strSelectedDatee];
                    NSDate *Firstdate= [self getFirstDateOfCurrentYear:dtselectedDate];
                    // NSTimeZone *tz = [NSTimeZone defaultTimeZone];
                    //[dateFormatterr setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    
                    NSInteger days=[self daysBetweenDate:Firstdate andDate:dtselectedDate];
                    NSLog(@"days:%ld",days);
                    
                    NSString *strDate = [NSString stringWithFormat:@"%03li",days];
                    [dateFormatterr setDateFormat:@"yy"];
                    NSString *strSelectedDateyearformat = [[[dateFormatterr stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
                    [dateFormatterr setDateFormat:@"EEE,dd-MMM-yyyy"];

                    /***************/
                    
                     NSString *strSelectedDateDayOFYear = [[strSelectedDateyearformat stringByAppendingString:@"\n"] stringByAppendingString:[dateFormatterr stringFromDate:dtselectedDate]];
                    
                    /*****************/
                    
                    // NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[dateFormatterr stringFromDate:dtselectedDate]];
                    //[_dictDynamic setValue:strSelectedDateyearformat forKey:[dict valueForKey:@"Lb"]];
                     [_dictDynamic setValue:strSelectedDateDayOFYear forKey:[dict valueForKey:@"Lb"]];
                }
                else{
                    
                    [_dictDynamic setValue:strSelectedDate forKey:[dict valueForKey:@"Lb"]];
                }
            }
            else if ([strDataType isEqualToString:@"TextField"] && [strFromDataEntry isEqualToString:@"0"]){
                if (strEventCode.integerValue == 26){
                    if ([[dict valueForKey:@"dk"] integerValue]==15 ||[[dict valueForKey:@"dk"] integerValue]==18 ||[[dict valueForKey:@"dk"] integerValue]==19 ||[[dict valueForKey:@"dk"] integerValue]==153) {
                        [_dictDynamic setValue:@"0" forKey:[dict valueForKey:@"Lb"]];
                    }//15,18,19,153 = 0 ...-Farrowing
                }else if(strEventCode.integerValue ==27){
                    if ([[dict valueForKey:@"dk"] integerValue]==3) {
                        [_dictDynamic setValue:@"1" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"1" forKey:[dict valueForKey:@"dk"]];
                    }//3 = 1 Fostering
                }else if(strEventCode.integerValue ==28 || strEventCode.integerValue ==29){
                    if ([[dict valueForKey:@"dk"] integerValue]==51 || [[dict valueForKey:@"dk"] integerValue]==54){
                        [_dictDynamic setValue:@"0" forKey:[dict valueForKey:@"Lb"]];
                    }//51 = 0 part weaning, complete weaning
                }else if(strEventCode.integerValue ==30){
                    if ([[dict valueForKey:@"dk"] integerValue]==3){
                        [_dictDynamic setValue:@"0" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"0" forKey:[dict valueForKey:@"dk"]];
                    }//3 = 1 Batch weaning
                }else if(strEventCode.integerValue ==31){
                    if ([[dict valueForKey:@"dk"] integerValue]==51 || [[dict valueForKey:@"dk"] integerValue]==54){
                        [_dictDynamic setValue:@"0" forKey:[dict valueForKey:@"Lb"]];
                    }else if ([[dict valueForKey:@"dk"] integerValue]==57){
                        [_dictDynamic setValue:@"1" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"1" forKey:[dict valueForKey:@"dk"]];
                    }//51 = 0,57 = 1 Nurse sow wean
                }else if(strEventCode.integerValue ==32){//3=1 piglet death
                    if ([[dict valueForKey:@"dk"] integerValue]==3){
                        [_dictDynamic setValue:@"1" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"1" forKey:[dict valueForKey:@"dk"]];
                    }
                }else if(strEventCode.integerValue ==6){
                    if ([[dict valueForKey:@"dk"] integerValue]==42){
                        [_dictDynamic setValue:@"1" forKey:[dict valueForKey:@"Lb"]];
                        [dictJson setValue:@"1" forKey:[dict valueForKey:@"dk"]];
                    }
                }
                
                // NSLog(@"strEventCode=%@",strEventCode);
            }else if ([[dict valueForKey:@"dk"] integerValue]==42){
                [_dictDynamic setValue:@"1" forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:@"1" forKey:[dict valueForKey:@"dk"]];
            }
        }
        
        if (dictForBarnRoomPen!=nil) {
            NSString *strDataType  = [self getViewType:[dictForBarnRoomPen valueForKey:@"dt"]];
            if ([strDataType isEqualToString:@"DropDown"]){
                // NSArray *arrKeys = [dictBarnData allKeys];
                __block NSString *strKey,*strBarn,*strRoom;
                
                //[dictForBarnRoomPen setValue:@"1" forKey:@"co"];
                [dictBarnData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"br"]){
                        strBarn = obj?obj:@"";
                        strKey =@"br";
                    }
                    else if ([key isEqualToString:@"rm"]) {
                        strRoom = obj?obj:@"";
                        strKey =@"rm";
                    }
                }];
                
                if ([[dictForBarnRoomPen valueForKey:@"co"] isEqualToString:@"1"] && strBarn.length==0 && strBarn!=nil){
                    [self fillDropDn:2 dict:dictForBarnRoomPen];
                }
                
                if ([[dictForBarnRoomPen valueForKey:@"co"] isEqualToString:@"1"] && strRoom.length==0 && strRoom!=nil){
                    [self fillDropDn:3 dict:dictForBarnRoomPen];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in fillDefaultValuesForMandatoryFields=%@",exception.description);
    }
}

-(NSDate *)getFirstDateOfCurrentYear:(NSDate*)selecteddate
{
    //Get current year
    //NSDate *currentYear=[[NSDate alloc]init];
    // currentYear=selecteddate
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:selecteddate];
   // [formatter1 setTimeZone:[NSTimeZone defaultTimeZone]];
    //Get first date of current year
    NSString *firstDateString=[NSString stringWithFormat:@"10 01-01-%@",currentYearString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"hh dd-MM-yyyy"];
    
    NSDate *firstDate = [[NSDate alloc]init];
    firstDate = [formatter2 dateFromString:firstDateString];
    
    NSLog(@"firstDate=%@",firstDate);
    
    return firstDate;
}

-(void)fillDropDn:(NSInteger)tag dict:(NSDictionary*)dict
{
    @try {
        [_arrDropDown removeAllObjects];
        NSSortDescriptor *sortBy;
        NSArray *sortDescriptors;
        
        NSString *strPrevSelectedValue= [dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@"";
        NSInteger prevSelectedIndex  = 0;
        
        switch ([[dict valueForKey:@"dk"]integerValue]) {
            case 4:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSString *strPredicate;
                if ([strEventCode isEqualToString:@"33"]||[strEventCode isEqualToString:@"48"]) {
                    strPredicate = @"br != 0 AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"34"]||[strEventCode isEqualToString:@"49"]) {
                    strPredicate = @"(sg != 0 OR sp != 0 or sd != 0 ) AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"35"]) {
                    strPredicate = @"pg != 0 AND tr==1";
                }
                else if ([strEventCode isEqualToString:@"10"]||[strEventCode isEqualToString:@"12"]) {
                    strPredicate = @"br != 0 AND ds==1";
                }
                else if ([strEventCode isEqualToString:@"11"]||[strEventCode isEqualToString:@"13"]) {
                    strPredicate = @"(sg != 0 OR sp != 0 or sd != 0 ) AND ds==1";
                }
                else if ([strEventCode isEqualToString:@"32"]) {
                    strPredicate = @"pg != 0 AND ds==1";
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Conditions" andPredicate:predicate andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
                
            case 6:{
                
                __block NSMutableDictionary *dictBarnDataToSend;
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"6"])
                     {
                         dictBarnDataToSend = obj;
                     }
                 }];
                
                __block NSString *strBarn;
                __block NSString *strRoom;
                
                [dictBarnDataToSend enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([key isEqualToString:@"br"]){
                        strBarn = obj;
                    }
                    else if ([key isEqualToString:@"rm"]) {
                        strRoom = obj;
                    }
                }];
                
                NSPredicate *predicate;
                NSArray* resultArray ;
                if (tag==2){
                    predicate  = [NSPredicate predicateWithFormat:@"id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"br" ascending:YES];
                    
                }else if (tag==3){
                    predicate  = [NSPredicate predicateWithFormat:@"br=%@ AND id=%@",strBarn,[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"rm" ascending:YES];
                    
                }else if (tag==4){
                    predicate  = [NSPredicate predicateWithFormat:@"br = %@ AND rm = %@ AND id=%@",strBarn, strRoom,[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                    //  strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictBarnDataToSend valueForKey:@"pen"]?[dictBarnDataToSend valueForKey:@"pen"]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"pn" ascending:YES];
                }
                
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Locations" andPredicate:predicate andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    if (tag==2){
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"br"] forKey:@"visible"];
                    }else if (tag==3)
                    {
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"rm"] forKey:@"visible"];
                    }
                    else if(tag==4){
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"pn"] forKey:@"visible"];
                    }
                    
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0){
                        if ([strPrevSelectedValue isEqualToString:[dict valueForKey:@"visible"]]){
                            prevSelectedIndex = count;
                        }
                    }
                }
                
                NSLog(@"_arrDropDown=%@",_arrDropDown);
            }
                break;
            case 8:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Pd_Results" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)  {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 9:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ln != null"];
                
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Operator" andPredicate:predicate andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)
                {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue]){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 11:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Treatments" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)
                {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
            case 13:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Tod" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0){
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
                
            case 23: {
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                
                NSArray* resultArray;
                NSPredicate *predicate;
                if ([self.strEventCode isEqualToString:@"1"] || [self.strEventCode isEqualToString:@"2"]) {
                    predicate = [NSPredicate predicateWithFormat:@"sx == 'M' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }
                else if ([self.strEventCode isEqualToString:@"4"] || [self.strEventCode isEqualToString:@"5"] || [self.strEventCode isEqualToString:@"8"]||[self.strEventCode isEqualToString:@"6"]){
                    predicate = [NSPredicate predicateWithFormat:@"sx == 'F' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 34:{
                NSArray* resultArray;
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                if ([self.strEventCode isEqualToString:@"1"]){
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"AI_STUDS" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
                else {
                    strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ds" ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Origin" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++) {
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ds"] forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"sid"] forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        NSLog(@"site key=%@",[[resultArray objectAtIndex:count] valueForKey:@"sid"]);
                        
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"sid"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                        
                    }
                }
            }
                break;
            case 37:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Halothane" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 62:{
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray;
                if ([self.strEventCode isEqualToString:@"12"] || [self.strEventCode isEqualToString:@"13"]||[self.strEventCode isEqualToString:@"29"] ||[self.strEventCode isEqualToString:@"30"] || [self.strEventCode isEqualToString:@"31"]){
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Packing_Plants" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
                else{
                    sortBy = [[NSSortDescriptor alloc] initWithKey:@"ds" ascending:YES];
                    sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Destination" andPredicate:nil andSortDescriptors:sortDescriptors];
                    for (int count=0; count<resultArray.count; count++){
                        NSDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ds"] forKey:@"visible"];
                        [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"sid"] forKey:@"dataTosend"];
                        [_arrDropDown addObject:dict];
                        
                        if (strPrevSelectedValue.length>0)
                        {
                            if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"sid"] integerValue])
                            {
                                prevSelectedIndex = count;
                            }
                        }
                    }
                }
            }
                break;
            case 73:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"dT" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Admin_Routes" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dT"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"dK"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if( [strPrevSelectedValue caseInsensitiveCompare:[[resultArray objectAtIndex:count] valueForKey:@"dK"]] == NSOrderedSame){
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
            case 67: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                //predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"ConditionScore" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++)
                {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
                //
            case 80: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lesion_Scores" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 81: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lock" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 82: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Leakage" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 83: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Quality" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 84: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Standing_Reflex" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 72: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Test_Type" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                //
            case 41: {
                NSArray* resultArray;
                
                strPrevSelectedValue = [NSString stringWithFormat:@"%@",[dictJson valueForKey:[dict valueForKey:@"dk"]]?[dictJson valueForKey:[dict valueForKey:@"dk"]]:@""];
                
                // predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lookup_category ==%@",strcategory]];
                
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln"
                                                     ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"HerdCategory" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"]?[[resultArray objectAtIndex:count] valueForKey:@"ln"]:@"" forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"]?[[resultArray objectAtIndex:count] valueForKey:@"id"]:@"" forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                    
                }
            }
                break;
                
            case 47:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray;
                if ([self.strEventCode isEqualToString:@"45"]){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sx != 'F' OR sx == null"];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:predicate andSortDescriptors:sortDescriptors];
                }
                else{
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:nil andSortDescriptors:sortDescriptors];
                }
                
                for (int count=0; count<resultArray.count; count++) {
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
            case 78:{
                sortBy = [[NSSortDescriptor alloc] initWithKey:@"ln" ascending:YES];
                sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Transport_Companies" andPredicate:nil andSortDescriptors:sortDescriptors];
                
                for (int count=0; count<resultArray.count; count++){
                    NSDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"ln"] forKey:@"visible"];
                    [dict setValue:[[resultArray objectAtIndex:count] valueForKey:@"id"] forKey:@"dataTosend"];
                    [_arrDropDown addObject:dict];
                    
                    if (strPrevSelectedValue.length>0)
                    {
                        if ([strPrevSelectedValue integerValue] == [[[resultArray objectAtIndex:count] valueForKey:@"id"] integerValue])
                        {
                            prevSelectedIndex = count;
                        }
                    }
                }
            }
                break;
                
            case 150:case 141:case 74:case 28:case 70:case 33:{
                NSDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:@"No" forKey:@"visible"];
                [dict setValue:@"0" forKey:@"dataTosend"];
                [_arrDropDown addObject:dict];
                
                NSDictionary *dict1 = [[NSMutableDictionary alloc]init];
                [dict1 setValue:@"Yes" forKey:@"visible"];
                [dict1 setValue:@"1" forKey:@"dataTosend"];
                [_arrDropDown addObject:dict1];
                
                if (strPrevSelectedValue.length>0)
                {
                    if ([strPrevSelectedValue integerValue] == 1)
                    {
                        prevSelectedIndex = 1;
                    }
                    else if ([strPrevSelectedValue integerValue] == 0)
                    {
                        prevSelectedIndex = 0;
                    }
                }
            }
                break;
                
            default:
            {
                NSString *strDataType  = [self getViewType:[dict valueForKey:@"dt"]];
                if ([strDataType isEqualToString:@"DropDown"])
                {
                    if ([[dict valueForKey:@"dk"] hasPrefix:@"UDF"])
                    {
                        if ([[dict valueForKey:@"dt"] isEqualToString:@"BL"])
                        {
                            NSDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setValue:@"No" forKey:@"visible"];
                            [dict setValue:@"0" forKey:@"dataTosend"];
                            [_arrDropDown addObject:dict];
                            
                            NSDictionary *dict1 = [[NSMutableDictionary alloc]init];
                            [dict1 setValue:@"Yes" forKey:@"visible"];
                            [dict1 setValue:@"1" forKey:@"dataTosend"];
                            [_arrDropDown addObject:dict1];
                            
                            if (strPrevSelectedValue.length>0)
                            {
                                if ([strPrevSelectedValue integerValue] == 1)
                                {
                                    prevSelectedIndex = 1;
                                }
                                else if ([strPrevSelectedValue integerValue] == 0)
                                {
                                    prevSelectedIndex = 0;
                                }
                            }
                        }
                        else
                        {
                            NSString *str = [dict valueForKey:@"dfv"];
                            NSArray *arrStringComponents = [str componentsSeparatedByString:@","];
                            
                            for (int count=0; count<arrStringComponents.count; count++){
                                NSDictionary *dict = [[NSMutableDictionary alloc]init];
                                [dict setValue:[arrStringComponents objectAtIndex:count] forKey:@"visible"];
                                [dict setValue:[arrStringComponents objectAtIndex:count] forKey:@"dataTosend"];
                                [_arrDropDown addObject:dict];
                                
                                if (strPrevSelectedValue.length>0)
                                {
                                    if ([strPrevSelectedValue isEqualToString:[arrStringComponents objectAtIndex:count]])
                                    {
                                        prevSelectedIndex = count;
                                    }
                                }
                            }
                        }
                    }
                }
            }
                
                break;
        }
        
        NSLog(@"compuslary=%@",[dict valueForKey:@"co"]);
        if (_arrDropDown.count>0 && ![[dict valueForKey:@"co"] isEqualToString:@"1"])//[[dict valueForKey:@"co"] isEqualToString:@"1"]
        {
            NSDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"" forKey:@"visible"];
            [dict setValue:@"" forKey:@"dataTosend"];
            [_arrDropDown insertObject:dict atIndex:0];
        }
        
        if (_arrDropDown.count>0)
        {
            if ([[dict valueForKey:@"dk"] integerValue] == 6)
            {
                __block NSMutableDictionary *dictBarn;
                __block NSMutableDictionary *dictBarnDataToSend;
                
                //
                [_dictDynamic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"Barn-Room-Pen"])
                     {
                         dictBarn = obj;
                     }
                 }];
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"6"])
                     {
                         dictBarnDataToSend = obj;
                     }
                 }];
                
                NSString *strVal=[[_arrDropDown objectAtIndex:0] valueForKey:@"visible"]?[[_arrDropDown objectAtIndex:0] valueForKey:@"visible"]:@"";
                NSString *strValToSend=[[_arrDropDown objectAtIndex:0] valueForKey:@"dataTosend"]?[[_arrDropDown objectAtIndex:0] valueForKey:@"dataTosend"]:@"";
                
                if (tag==2) {
                    [dictBarn setValue:strVal forKey:@"br"];
                    [dictBarnDataToSend setValue:strValToSend forKey:@"br"];
                }else if (tag==3){
                    [dictBarn setValue:strVal forKey:@"room"];
                    [dictBarnDataToSend setValue:strValToSend forKey:@"room"];
                }
                else if (tag==4){
                    [dictBarn setValue:strVal forKey:@"pen"];
                    [dictBarnDataToSend setValue:strValToSend forKey:@"pen"];
                }
                
                [_dictDynamic setObject:dictBarn forKey:[dict valueForKey:@"Lb"]];
                [dictJson setObject:dictBarnDataToSend forKey:[dict valueForKey:@"dk"]];
            }
            else
            {
                [_dictDynamic setValue:[[_arrDropDown objectAtIndex:0] valueForKey:@"visible"] forKey:[dict valueForKey:@"Lb"]];
                [dictJson setValue:[[_arrDropDown objectAtIndex:0] valueForKey:@"dataTosend"] forKey:[dict valueForKey:@"dk"]];
            }
            
            //NSLog(@"weakSelf.dictDynamic=%@",_dictDynamic);
            // NSLog(@"dictJson=%@",dictJson);
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in fillDropDn =%@",exception.description);
    }
}

-(void)callEdit {
    @try {
        if ([[ControlSettings sharedSettings] isNetConnected ]){
            _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            [_customIOS7AlertView showLoaderWithMessage:strWait];
            
            NSString *strPigIdKey;
            NSString *strEventKey;
            
            if (![[_dict valueForKey:@"PigIdKey"] isKindOfClass:[NSNull class]]){
                strPigIdKey = [_dict valueForKey:@"PigIdKey"]?[_dict valueForKey:@"PigIdKey"]:@"";
            }
            
            if (![[_dict valueForKey:@"EventKey"] isKindOfClass:[NSNull class]]) {
                strEventKey = [_dict valueForKey:@"EventKey"]?[_dict valueForKey:@"EventKey"]:@"";
            }
            
            //
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
            [dict setValue:strPigIdKey forKey:@"PigIdKey"];
            [dict setValue:strEventKey forKey:@"EventKey"];
            //
            
            [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&PigIdKey=%@&EventKey=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],strPigIdKey,strEventKey] idOfServiceUrl:13  headers:dict methodType:@"POST" onSucess:^(NSString *responseData) {
                [_customIOS7AlertView close];
                
                //id dict = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]){
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                else{
                    NSArray *arrDictData =  [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    NSMutableArray *arrAvailableValues = [[NSMutableArray alloc]init];
                    for (NSDictionary *Dict in arrDictData) {
                        if (![[Dict valueForKey:@"val"] isKindOfClass:[NSNull class]]){
                            if ([[Dict valueForKey:@"val"] length]>0 && ![[Dict valueForKey:@"val"] isEqualToString:@"-9999"]){
                                [arrAvailableValues addObject:Dict];
                            }
                        }
                    }
                    
                    for (NSDictionary *DictDynamic in _arrDynamic){
                        NSString *strDataType  = [self getViewType:[DictDynamic valueForKey:@"dt"]];
                        NSLog(@"strDataType=%@",strDataType);
                        NSLog(@"dk=%@",[DictDynamic valueForKey:@"dk"]);
                        
                        for (NSDictionary *DictAvailble in arrAvailableValues) {
                            @try {
                                NSLog(@"itemkey=%@",[DictAvailble valueForKey:@"dataItemKey"]);
                                
                                if (([[DictDynamic valueForKey:@"dk"] integerValue]==51 && [self isTwoText]) || ([[DictDynamic valueForKey:@"dk"] integerValue]==15 && [self isTwoText])){
                                    if ((([DictDynamic valueForKey:@"dk"] == [DictAvailble valueForKey:@"dataItemKey"]) || ([[DictDynamic valueForKey:@"dk"] isEqualToString:[DictAvailble valueForKey:@"dataItemKey"]]) ) && [strDataType isEqualToString:@"TextField"]) {
                                        __block NSMutableDictionary *dictText; //= [[NSMutableDictionary alloc]init];
                                        __block  NSString *strVal = [DictAvailble valueForKey:@"val"];
                                        [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                            if ([key integerValue]==51 || [key integerValue]==15) {
                                                dictText = obj;
                                            }
                                        }];
                                        
                                        NSArray *explodedString = [strVal componentsSeparatedByString:@"-"];
                                        if (explodedString.count==2) {
                                            [dictText setValue:[explodedString objectAtIndex:0]?[explodedString objectAtIndex:0]:@"" forKey:@"first"];
                                            [dictText setValue:[explodedString objectAtIndex:1]?[explodedString objectAtIndex:1]:@"" forKey:@"second"];
                                        }
                                        [dictJson setObject:dictText forKey:[DictAvailble valueForKey:@"dataItemKey"]];
                                    }
                                }
                                
                                if ((([DictDynamic valueForKey:@"dk"] == [DictAvailble valueForKey:@"dataItemKey"]) || ([[DictDynamic valueForKey:@"dk"] isEqualToString:[DictAvailble valueForKey:@"dataItemKey"]])) && [strDataType isEqualToString:@"DropDown"]) {
                                    if ([[DictDynamic valueForKey:@"dk"] integerValue]!=6) {
                                        [dictJson setValue:[DictAvailble valueForKey:@"val"] forKey:[DictDynamic valueForKey:@"dk"]];
                                    }
                                    
                                    [self fillDropDownsOnEdit:[DictAvailble valueForKey:@"val"] dict:DictDynamic];
                                }else if ((([DictDynamic valueForKey:@"dk"] == [DictAvailble valueForKey:@"dataItemKey"]) || ([[DictDynamic valueForKey:@"dk"] isEqualToString:[DictAvailble valueForKey:@"dataItemKey"]]) ) && [strDataType isEqualToString:@"TextField"]) {
                                    
                                    if ([[DictDynamic valueForKey:@"dk"] integerValue]==48) {
                                        NSString *strVal = [DictAvailble valueForKey:@"val"];
                                        strVal = [strVal stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                                        strVal = [strVal stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                        
                                        [self.dictDynamic setValue:strVal forKey:[DictDynamic valueForKey:@"Lb"]];
                                        [dictJson setValue:strVal forKey:[DictDynamic valueForKey:@"dk"]];
                                    }
                                    else{
                                        [self.dictDynamic setValue:[DictAvailble valueForKey:@"val"] forKey:[DictDynamic valueForKey:@"Lb"]];
                                        [dictJson setValue:[DictAvailble valueForKey:@"val"] forKey:[DictDynamic valueForKey:@"dk"]];
                                    }
                                }else if ((([DictDynamic valueForKey:@"dk"] == [DictAvailble valueForKey:@"dataItemKey"]) || ([[DictDynamic valueForKey:@"dk"] isEqualToString:[DictAvailble valueForKey:@"dataItemKey"]]) ) && [strDataType isEqualToString:@"Date"]){
                                    
                                    NSMutableString *str = [DictAvailble valueForKey:@"val"];
                                    if (str.length>0) {
                                        NSString *strBaseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZD"];
                                        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                        if (isThousandFormat) {
                                            [formatter setDateFormat:@"YYYYMMdd"];
                                            NSDate *dtselectedDate = [formatter dateFromString:str];
                                            [formatter setDateFormat:@"YYYYMMdd"];
                                            NSDate *BaseDate = [formatter dateFromString:strBaseDate];
                                            int days = [dtselectedDate timeIntervalSinceDate:BaseDate]/24/60/60;
                                            
                                            NSString *strDate = [NSString stringWithFormat:@"%05d",days];
                                            NSString *calFormat,*strFromString;
                                            
                                            if (strDate.length>=2) {
                                                calFormat = [strDate substringToIndex:2];
                                            }else {
                                                calFormat = strDate;
                                            }
                                            
                                            if (strDate.length>=3){
                                                strFromString = [strDate substringFromIndex:2];
                                            }
                                            
                                            calFormat = [[calFormat stringByAppendingString:@"-"] stringByAppendingString:strFromString?strFromString:@""];
                                            [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
                                            
                                            NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                                            
                                            [_dictDynamic setValue:strSelectedDate100 forKey:[DictDynamic valueForKey:@"Lb"]];
                                        }
                                        else if([self.strDateFormat isEqualToString:@"6"]){
                                            [formatter setDateFormat:@"YYYYMMdd"];
                                            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

                                            NSDate *dtselectedDate = [formatter dateFromString:str];
                                            NSDate *Firstdate= [self getFirstDateOfCurrentYear:dtselectedDate];
                                            
                                            [formatter setDateFormat:@"DDD"];
                                            NSInteger days= [[formatter stringFromDate:dtselectedDate] integerValue];

                                           // NSInteger days=[self daysBetweenDate:Firstdate andDate:dtselectedDate];
                                            NSLog(@"days:%ld",days);
                                            
                                            NSString *strDate = [NSString stringWithFormat:@"%03li",days];
                                            [formatter setDateFormat:@"yy"];
                                            NSString *strSelectedDateyearformat = [[[formatter stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
                                            
                                           /* [_dictDynamic setValue:strSelectedDateyearformat forKey:[DictDynamic valueForKey:@"Lb"]];*///commented by amit
                                            
                                            /*********************/
                                            [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
                                            
                                            /***************/
                                            
                                            NSString *strSelectedDateDayOFYear = [[strSelectedDateyearformat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                                            
                                            /*****************/
                                            
                                            // NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[dateFormatterr stringFromDate:dtselectedDate]];
                                            //[_dictDynamic setValue:strSelectedDateyearformat forKey:[dict valueForKey:@"Lb"]];
                                            [_dictDynamic setValue:strSelectedDateDayOFYear forKey:[DictDynamic valueForKey:@"Lb"]];
                                            /**********************/
                                            
                                            
                                            // [_dictDynamic setValue:strSelectedDateyearformat forKey:[dict valueForKey:@"Lb"]];
                                        }
                                        else{
                                            [_dictDynamic setValue:[[[[str substringWithRange:NSMakeRange(4, [str length]-6)] stringByAppendingString:@"/"] stringByAppendingString:[[str substringWithRange:NSMakeRange(6, [str length]-6)] stringByAppendingString:@"/"]] stringByAppendingString:[str substringToIndex:4]] forKey:[DictDynamic valueForKey:@"Lb"]];
                                        }
                                        //
                                        
                                        [dictJson setValue:str forKey:[DictDynamic valueForKey:@"dk"]];
                                    }
                                }else if ([strDataType isEqualToString:@"IR"]){
                                    __block NSMutableDictionary *dictText;
                                    
                                    [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                        if ([key integerValue]==92) {
                                            dictText = obj;
                                        }
                                    }];
                                    
                                    [dictText setValue:@"" forKey:@"first"];
                                    [dictText setValue:@"" forKey:@"second"];
                                    [dictText setValue:@"" forKey:@"third"];
                                    [dictJson setObject:dictText forKey:[DictAvailble valueForKey:@"dataItemKey"]];
                                }
                            }
                            @catch (NSException *exception) {
                                
                                NSLog(@"Exception =%@",exception.description);
                            }
                        }
                    }
                    
                    NSLog(@"dictJson=%@",dictJson);
                    NSLog(@"data=%@",_dictDynamic);
                    NSLog(@"data=%@",arrAvailableValues);
                    
                    _dictReload = [[NSMutableDictionary alloc] init];
                    
                  //  NSArray *deepCopyArray=[[NSArray alloc] initWithArray:someArray copyItems:YES];

                    NSMutableDictionary *dctjson = [[NSMutableDictionary alloc]initWithDictionary:dictJson copyItems:YES];
                    NSMutableDictionary *dctDynamic = [[NSMutableDictionary alloc]initWithDictionary:_dictDynamic copyItems:YES];

                    [_dictReload setValue:dctjson forKey:@"dataToSend"];
                    [_dictReload setValue:dctDynamic forKey:@"dataToDisplay"];

                    //[_dictReload setObject:dctjson forKey:@"dataToSend"];
                   // [_dictReload setObject:dctDynamic forKey:@"dataToDisplay"];
                    
                    [self.tblDynamic reloadData];
                }
            } onFailure:^(NSMutableDictionary *responseData, NSError *error){
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
               // 5     //
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                
                NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event on Edit=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,self.lblSelectedValue.text];
                [tracker set:kGAIScreenName value:strErr];
                [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                
                if ([responseData.allKeys containsObject:@"code"]) {
                    if ([[responseData valueForKey:@"code"]integerValue] ==401) {
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:strUnauthorised
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                        
                        // [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if ([[responseData valueForKey:@"code"]integerValue] ==408) {
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:[responseData valueForKey:@"Error"]
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOk
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                        
                        // [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
                else{
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[responseData valueForKey:@"Error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //[self.navigationController popToRootViewControllerAnimated:YES];
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                [_customIOS7AlertView close];
            }];
        }
        else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strNoInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in callEdit =%@",exception.description);
    }
}

-(void)fillDropDownsOnEdit:(NSString*)Id dict:(NSDictionary*)dict{
    @try {
        // NSInteger tag=0;
        [_arrDropDown removeAllObjects];
        // NSSortDescriptor *sortBy;
        //  NSArray *sortDescriptors;
        
        // NSString *strPrevSelectedValue= [dictJson valueForKey:[dict valueForKey:@""]]?[dictJson valueForKey:[dict valueForKey:@""]]:@"";
        //  NSInteger prevSelectedIndex  = 0;
        
        switch ([[dict valueForKey:@"dk"]integerValue]){
            case 4:{
                NSString *strPredicate;
                if ([strEventCode isEqualToString:@"33"]||[strEventCode isEqualToString:@"48"]) {
                    strPredicate = [NSString stringWithFormat:@"br != 0 AND tr==1 AND id=%@",Id];
                }
                else if ([strEventCode isEqualToString:@"34"]||[strEventCode isEqualToString:@"49"]) {
                    strPredicate =[NSString stringWithFormat:@"(sg != 0 OR sp != 0 or sd != 0 ) AND tr==1 AND id=%@",Id];
                }
                else if ([strEventCode isEqualToString:@"35"]) {
                    strPredicate = [NSString stringWithFormat:@"pg != 0 AND tr==1 AND id=%@",Id];
                }
                else if ([strEventCode isEqualToString:@"10"]||[strEventCode isEqualToString:@"12"]) {
                    strPredicate =[NSString stringWithFormat:@"br != 0 AND ds==1 AND id=%@",Id];
                }
                else if ([strEventCode isEqualToString:@"11"]||[strEventCode isEqualToString:@"13"]) {
                    strPredicate = [NSString stringWithFormat:@"(sg != 0 OR sp != 0 or sd != 0 ) AND ds==1 AND id=%@",Id];
                }
                else if ([strEventCode isEqualToString:@"32"]) {
                    strPredicate = [NSString stringWithFormat:@"pg != 0 AND ds==1 AND id=%@",Id];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Conditions" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 6:{
                __block NSMutableDictionary *dictBarnDataToSend;
                
                [dictJson enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     if ([key isEqualToString:@"6"])
                     {
                         dictBarnDataToSend = obj;
                     }
                 }];
                
                //                __block NSMutableDictionary *dictBarn;
                //                [_dictDynamic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                //                 {
                //                     if ([key isEqualToString:@"Barn-Room-Pen"])
                //                     {
                //                         dictBarn = obj;
                //                     }
                //                 }];
                
                NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"id=%@",Id];
                NSArray* resultArray ;
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Locations" andPredicate:predicate andSortDescriptors:nil];
                
                for (int count=0; count<resultArray.count; count++) {
                    
                    @try {
                        [dictBarnDataToSend setValue:[[resultArray objectAtIndex:count] valueForKey:@"br"] forKey:@"br"];
                        [dictBarnDataToSend setValue:[[resultArray objectAtIndex:count] valueForKey:@"rm"] forKey:@"rm"];
                        [dictBarnDataToSend setValue:[[resultArray objectAtIndex:count] valueForKey:@"pn"] forKey:@"pn"];
                    }
                    @catch (NSException *exception) {
                        
                        NSLog(@"Exception =%@",exception.description);
                    }
                }
                
                //[_dictDynamic setObject:dictBarn forKey:[dict valueForKey:@"Lb"]];
                [dictJson setObject:dictBarnDataToSend forKey:[dict valueForKey:@""]];
            }
                break;
            case 8:{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dK=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Pd_Results" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"dT"]?[[resultArray objectAtIndex:0] valueForKey:@"dT"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 9:{
                NSLog(@"id=%@",Id);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ln != null AND id=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Operator" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 11: {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Treatments" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 13:{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dK=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Tod" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"dT"]?[[resultArray objectAtIndex:0] valueForKey:@"dT"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 23: {
                NSArray* resultArray;
                NSPredicate *predicate;
                if ([self.strEventCode isEqualToString:@"1"] || [self.strEventCode isEqualToString:@"2"]) {
                    predicate = [NSPredicate predicateWithFormat:@"(sx == 'M' OR sx == null) AND id=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:nil];
                }
                else if ([self.strEventCode isEqualToString:@"4"] || [self.strEventCode isEqualToString:@"5"] || [self.strEventCode isEqualToString:@"8"]||[self.strEventCode isEqualToString:@"6"]){
                    predicate = [NSPredicate predicateWithFormat:@"(sx == 'F' OR sx == null) AND id==%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Genetics" andPredicate:predicate andSortDescriptors:nil];
                }
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 34:{
                NSArray* resultArray;
                if ([self.strEventCode isEqualToString:@"1"]){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"AI_STUDS" andPredicate:predicate andSortDescriptors:nil];
                    
                    if (resultArray.count>0) {
                        [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                    }
                }
                else {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Origin" andPredicate:predicate andSortDescriptors:nil];
                    if (resultArray.count>0) {
                        [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ds"]?[[resultArray objectAtIndex:0] valueForKey:@"ds"]:@"" forKey:[dict valueForKey:@"Lb"]];
                    }
                }
            }
                break;
            case 37:{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dK=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Halothane" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"dT"]?[[resultArray objectAtIndex:0] valueForKey:@"dT"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 62:{
                NSArray* resultArray;
                if ([self.strEventCode isEqualToString:@"12"] || [self.strEventCode isEqualToString:@"13"]||[self.strEventCode isEqualToString:@"29"] ||[self.strEventCode isEqualToString:@"30"] || [self.strEventCode isEqualToString:@"31"]){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",Id];
                    
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Packing_Plants" andPredicate:predicate andSortDescriptors:nil];
                    
                    if (resultArray.count>0) {
                        [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                    }
                }
                else{
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteKey=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Destination" andPredicate:predicate andSortDescriptors:nil];
                    
                    if (resultArray.count>0) {
                        [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ds"]?[[resultArray objectAtIndex:0] valueForKey:@"ds"]:@"" forKey:[dict valueForKey:@"Lb"]];
                    }
                }
            }
                break;
            case 73:{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dK=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Admin_Routes" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"dT"]?[[resultArray objectAtIndex:0] valueForKey:@"dT"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 67: {
                NSArray* resultArray;
                NSPredicate *predicate;
                NSString *strcategory;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"ConditionScore" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
                //
            case 80: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lesion_Scores" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 81: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Lock" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 82: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Leakage" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 83: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Quality" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 84: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Standing_Reflex" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 72: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Test_Type" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                //
                
            case 41: {
                NSArray* resultArray;
                NSPredicate *predicate;
                
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id==%@",Id]];
                resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"HerdCategory" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 47:{
                NSArray* resultArray;
                NSPredicate *predicate;
                if ([self.strEventCode isEqualToString:@"45"]){
                    predicate = [NSPredicate predicateWithFormat:@"(sx != 'F' OR sx == null) AND id=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:predicate andSortDescriptors:nil];
                }
                else {
                    predicate = [NSPredicate predicateWithFormat:@"id=%@",Id];
                    resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Flags" andPredicate:predicate andSortDescriptors:nil];
                }
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            case 78:{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",Id];
                NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"Transport_Companies" andPredicate:predicate andSortDescriptors:nil];
                
                if (resultArray.count>0) {
                    [_dictDynamic setValue:[[resultArray objectAtIndex:0] valueForKey:@"ln"]?[[resultArray objectAtIndex:0] valueForKey:@"ln"]:@"" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
                
            case 150:case 141:case 74:case 28:case 70:case 33:{
                if ([Id isEqualToString:@"0"]){
                    [_dictDynamic setValue:@"NO" forKey:[dict valueForKey:@"Lb"]];
                }
                else if ([Id isEqualToString:@"1"]){
                    [_dictDynamic setValue:@"Yes" forKey:[dict valueForKey:@"Lb"]];
                }
            }
                break;
            default:
            {
                NSString *strDataType  = [self getViewType:[dict valueForKey:@"dt"]];
                if ([strDataType isEqualToString:@"DropDown"]){
                    if ([[dict valueForKey:@"dk"] hasPrefix:@"UDF"]){
                        if ([[dict valueForKey:@"dt"] isEqualToString:@"BL"])
                        {
                            if ([Id isEqualToString:@"0"]){
                                [_dictDynamic setValue:@"NO" forKey:[dict valueForKey:@"Lb"]];
                            }
                            else if ([Id isEqualToString:@"1"]){
                                [_dictDynamic setValue:@"Yes" forKey:[dict valueForKey:@"Lb"]];
                            }
                        }
                        else{
                            [_dictDynamic setValue:Id forKey:[dict valueForKey:@"Lb"]];
                        }
                    }
                }
            }
                
                break;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in fillDropDn =%@",exception.description);
    }
}

-(void)btnSettings_tapped
{
    @try {
        settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        [self presentViewController:settingsViewController animated:NO completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSettings_tapped =%@",exception.description);
    }
}

- (IBAction)btnSnnerType_tapped:(id)sender {
    @try {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        //NSString *strRFID = [pref valueForKey:@"isRFID"];
        NSString *strBar = [pref valueForKey:@"isBarcode"];
        
        if ([strBar isEqualToString:@"1"]){
            barcodeScannerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segueBarcode"];
            barcodeScannerViewController.delegate = self;
            
            [self.navigationController pushViewController:barcodeScannerViewController animated:NO];
        }else{
        }
    }
    @catch (NSException *exception) {
        {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:exception.description
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
        NSLog(@"Exception in btnSnnerType_tapped=%@",exception.description);
    }
}

-(void)scannedBarcode:(NSString *)barcode{
    @try {
        [_dictDynamic setValue:barcode forKey:strScan];
        [dictJson setValue:barcode forKey:@"1"];
        [self.tblDynamic reloadData];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in scannedBarcode=%@",exception.description);
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

-(void)notinRangeMessage:(NSDictionary*)dict {
    @try {
        NSString *strMustValue = @"Value entered for #1 is more than the maximum allowed, #2";
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Value entered for #1 is more than the maximum allowed, #2", nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1.count!=0)
        {
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<1; i++) {
                // if (i==0) {
                if ([dictMenu objectForKey:[@"Value entered for #1 is more than the maximum allowed, #2" uppercaseString]] && ![[dictMenu objectForKey:[@"Value entered for #1 is more than the maximum allowed, #2" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Value entered for #1 is more than the maximum allowed, #2" uppercaseString]] length]>0) {
                        NSLog(@"%@",[dictMenu objectForKey:[@"Value entered for #1 is more than the maximum allowed, #2" uppercaseString]]);
                        strMustValue = [dictMenu objectForKey:[@"Value entered for #1 is more than the maximum allowed, #2" uppercaseString]];
                    }
                }
                // }
            }
        }
        
        strMustValue = [strMustValue stringByReplacingOccurrencesOfString:@"#1" withString:[dict valueForKey:@"Lb"]];
        strMustValue = [strMustValue stringByReplacingOccurrencesOfString:@"#2" withString:[dict valueForKey:@"mxV"]];
        //
        
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                   message:strMustValue
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:strOk
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [myAlertController addAction: ok];
        [self presentViewController:myAlertController animated:YES completion:nil];
        
        return;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in =%@",exception.description);
    }
}

@end
