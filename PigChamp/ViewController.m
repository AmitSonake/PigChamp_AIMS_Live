//
//  ViewController.m
//  PigChamp
//
//  Created by Venturelabour on 20/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreDataHandler.h"
//#import "FarmSelectionViewController.h"
#import "ServerManager.h"
#import <Google/Analytics.h>

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        [self.txtPasswordtextField addPasswordField]; // call a method
        self.navigationController.navigationBar.translucent = NO;

        //contentInsetsScroll = self.scrBackground.contentInset;
        //self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
        
        _btnSubmit.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnSubmit.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _btnSubmit.layer.shadowOpacity = 1.0f;
        _btnSubmit.layer.shadowRadius = 3.0f;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        _pref = [NSUserDefaults standardUserDefaults];
        [self.btnLanguage setTitle:[_pref valueForKey:@"selectedLanguage"] forState:UIControlStateNormal];
      //  self.txtLogintextField.text = [_pref valueForKey:@"userName"];
        
        NSString *str = [[NSLocalizedString(@"baseUrl" , @"") stringByAppendingString:@"lngmin/"] stringByAppendingString:[NSString stringWithFormat:@"%@.lng",[_pref valueForKey:@"selectedLanguage"]]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:str]];/// this above 2 line commented by amit dated on 19th march  4.30 pm
        /**********added below lines of code by ami as on 19th march 2018*/
    /*    NSString *encodedParam = [[_pref valueForKey:@"selectedLanguage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];// Amit Added this line of code
        
        NSString *strencoded = [[NSLocalizedString(@"baseUrl" , @"") stringByAppendingString:@"lngmin/"] stringByAppendingString:[NSString stringWithFormat:@"%@.lng",encodedParam]];//modified existing parameter
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strencoded]];*/
        /***************************************************************/
       
        NSString *gameFileContents = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
        
//from
//        NSString *alanSugarFilePath =
//        [[NSBundle mainBundle] pathForResource:@"Francais"
//                                        ofType:@"lng"];
//        
//        NSError *readError = nil;
//        NSData *dataForFile =
//        [[NSData alloc] initWithContentsOfFile:alanSugarFilePath
//                                       options:NSMappedRead
//                                         error:&readError];
//
//        gameFileContents = [[NSString alloc] initWithData:dataForFile encoding:NSUTF16StringEncoding];
       //to
        
        NSLog(@"gameFileContents%@", gameFileContents);
        
        NSMutableArray* allLinedStrings = (NSMutableArray*)[gameFileContents componentsSeparatedByString:@"\r\n"];
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        _arrayEnglish = [[NSMutableArray alloc]init];
        
        for (NSString *line in allLinedStrings){
            @autoreleasepool {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                newArray = (NSMutableArray*)[line componentsSeparatedByString:@"="];
                
                if (newArray.count==2){
                    [dict setValue:[newArray objectAtIndex:0] forKey:@"englishText"];
                    [dict setValue:[newArray objectAtIndex:1] forKey:@"translatedText"];
                }
                
                [_arrayEnglish addObject:dict];
            }
        }
        
        self.title = @"PigCHAMP";
        self.btnLanguage.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
        _arrLanguage=[[NSMutableArray alloc]init];

            if ([[ControlSettings sharedSettings] isNetConnected ]){
                //_customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                //[_customIOS7AlertView showLoaderWithMessage:NSLocalizedString(@"Loging in...", "")];
                
                [ServerManager sendRequestForLanguageList:^(NSString *responseData) {
                    
                    if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]){
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:responseData
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
              //[[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }else{
                        NSArray *yourArray = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                        
                    //
                        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                        _arrLanguage= (NSMutableArray*)[yourArray sortedArrayUsingDescriptors:@[sortDesc]];
                    //
                        NSLog(@"_arrLanguage=%@",_arrLanguage);
                    }
                } onFailure:^(NSString *responseData, NSError *error) {
                    [_customIOS7AlertView close];
                    
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                    
                    NSString *strErr = [NSString stringWithFormat:@"User Name = %@,,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],error.description,strDate,@"Simple Report"];
                    [tracker set:kGAIScreenName value:strErr];
                    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                }];
            }
            else {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:@"You must be online for the app to function."
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
        
            [self registerForKeyboardNotifications];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLoad in ViewController =%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        self.txtPasswordtextField.secureTextEntry = TRUE;
       // self.txtPasswordtextField.text = @"";
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewWillAppear=%@",exception.description);
    }
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        [self.scrBackground setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 500)];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLayoutSubviews in ViewController=%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------------------------------------

#pragma mark - picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    @try {
        return 1;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfComponentsInPickerView in FArm Selection =%@",exception.description);
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    @try {
        if (pickerView==self.pickerLanguage) {
            return [_arrLanguage count];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in numberOfRowsInComponent- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    @try {
        [[self.pickerLanguage.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerLanguage.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        if (pickerView==self.pickerLanguage) {
            return [[_arrLanguage objectAtIndex:row] valueForKey:@"name"];
        }
    }
    @catch (NSException *exception){
        NSLog(@"Exception in titleForRow- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    @try
    {
        [[self.pickerLanguage.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerLanguage.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        UILabel *lblSortText = (id)view;
        
        if (!lblSortText){
            lblSortText= [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView rowSizeForComponent:component].width-15, [pickerView rowSizeForComponent:component].height)];
        }
        
        lblSortText.font = [UIFont boldSystemFontOfSize:16];
        lblSortText.textAlignment = NSTextAlignmentCenter;
        lblSortText.tintColor = [UIColor clearColor];

        if (pickerView==self.pickerLanguage)
        {
            lblSortText.text = [[_arrLanguage objectAtIndex:row] valueForKey:@"name"];
            return lblSortText;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in viewForRow- %@",[exception description]);
    }
}

#pragma mark - AlertView Delegate
- (IBAction)btnSubmit_tapped:(id)sender
{
    @try {
        [self.scrBackground setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

       // [self performSegueWithIdentifier:@"SegueLogin" sender:self];
       
        [self.txtPasswordtextField resignFirstResponder];
        [self.txtLogintextField resignFirstResponder];
        
        if ([self.txtLogintextField.text isEqualToString:@""] || [self.txtLogintextField.text isEqual:nil] || self.txtLogintextField.text == nil){
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:@"Please enter User Name."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [self.txtLogintextField becomeFirstResponder];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
        else if ([self.txtPasswordtextField.text isEqualToString:@""] || [self.txtPasswordtextField.text isEqual:nil] || self.txtPasswordtextField.text == nil){
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:@"Please enter Password."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [self.txtPasswordtextField becomeFirstResponder];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
        else {
            if ([[ControlSettings sharedSettings] isNetConnected ]) {
                _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                [_customIOS7AlertView showLoaderWithMessage:NSLocalizedString(@"Please Wait...", "")];
                
                [ServerManager sendRequestForLogin:self.txtLogintextField.text password:self.txtPasswordtextField.text language:[_pref valueForKey:@"selectedLanguage"] onSucess:^(NSString *responseData) {
                   
                    NSDictionary *dictreponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    
                    NSString* message = [dictreponse objectForKey:@"error"];
                    if ([message isEqualToString:@"Login Successful."]){
                        NSString *token = [dictreponse valueForKey:@"token"];
                        [_pref setObject:token forKey:@"token"];
                       // [_pref setObject:self.txtLogintextField.text forKey:@"userName"];
                        [_pref synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                        [self updateMasterDataBase];
                    }else if ([message isEqualToString:@"Incorrect Password, Please note passwords are case sensitive."]){
                         [_customIOS7AlertView close];
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:message
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 self.txtPasswordtextField.text = @"";
                                                 [self.txtPasswordtextField becomeFirstResponder];
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }else if([message rangeOfString:@"Please enter a valid username"].location !=NSNotFound) {
                         [_customIOS7AlertView close];
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:message
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 self.txtPasswordtextField.text = @"";
                                                 self.txtLogintextField.text = @"";
                                                 [self.txtLogintextField becomeFirstResponder];
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                    else if ([message isEqualToString:@"Your previous session was active and has been closed. A new session has been created."])
                    {
                        [_customIOS7AlertView close];

                         NSString *token = [dictreponse valueForKey:@"token"];
                        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
                        [pref setObject:token forKey:@"token"];
                        [pref synchronize];
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:message
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                 [_customIOS7AlertView showLoaderWithMessage:NSLocalizedString(@"Loading...", "")];
                                                 
                                                 [self updateMasterDataBase];
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                    else // to to
                    {
                        [_customIOS7AlertView close];
                        NSString *token = [dictreponse valueForKey:@"token"];
                        
                        NSUserDefaults *pref1 =[NSUserDefaults standardUserDefaults];
                        [pref1 setObject:token forKey:@"token"];
                        [pref1 synchronize];
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:message
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
                } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
                    [_customIOS7AlertView close];
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                    
                    NSString *strErr = [NSString stringWithFormat:@"User Name = %@,error = %@,DateTime=%@,Event(On Language selection) =%@",self.txtLogintextField.text,error.description.description,strDate, @"Login"];
                    [tracker set:kGAIScreenName value:strErr];
                    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                    
                    if ([responseData.allKeys containsObject:@"code"]) {
                        
                        NSString *path = [[NSBundle mainBundle] pathForResource:@"StatusCodes" ofType:@"plist"];
                        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:[dict valueForKey:[responseData valueForKey:@"code"]]
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                    else{
                  
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:responseData
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 //[self.navigationController popToRootViewControllerAnimated:YES];
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }

                }];
            }
            else{
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:@"You must be online for the app to function."
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
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSubmit_tapped =%@",exception.description);
    }
}

-(void)updateMasterDataBase {
    @try {
        //NSError *error = nil;
        if ([[ControlSettings sharedSettings] isNetConnected ]) {
            [ServerManager sendRequestForGetmasterData:^(NSString *responseData) {
                [_customIOS7AlertView close];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //[self.navigationController popToRootViewControllerAnimated:YES];
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }else{
                    NSArray *adminRoutes;
                    if (![[dict objectForKey:@"_ADMIN_ROUTES"] isKindOfClass:[NSNull class]]) {
                        adminRoutes = [dict objectForKey:@"_ADMIN_ROUTES"];
                    }
                    
                    NSArray *aistuds;
                    if (![[dict objectForKey:@"_AI_STUDS"] isKindOfClass:[NSNull class]]){
                        aistuds= [dict objectForKey:@"_AI_STUDS"]?[dict objectForKey:@"_AI_STUDS"]:@"";
                    }
                    
                    NSArray *breedingcompanies;
                    if (![[dict objectForKey:@"_BREEDING_COMPANIES"] isKindOfClass:[NSNull class]]){
                        breedingcompanies = [dict objectForKey:@"_BREEDING_COMPANIES"];
                    }
                    
                    NSArray *halothane;
                    if (![[dict objectForKey:@"_Halothane"] isKindOfClass:[NSNull class]]){
                        halothane = [dict objectForKey:@"_Halothane"];
                    }
                    
                    NSArray *pdResults;
                    if (![[dict objectForKey:@"_PD_RESULTS"] isKindOfClass:[NSNull class]]){
                        pdResults = [dict objectForKey:@"_PD_RESULTS"];
                    }
                    
                    NSArray *sex;
                    if (![[dict objectForKey:@"_SEX"] isKindOfClass:[NSNull class]]){
                        sex = [dict objectForKey:@"_SEX"];
                    }
                    
                    NSArray *tod;
                    if (![[dict objectForKey:@"_TOD"] isKindOfClass:[NSNull class]])
                    {
                        tod = [dict objectForKey:@"_TOD"];
                    }
                    
                    NSArray *commonLookupsArray;
                    if (![[dict objectForKey:@"_COMMON_LOOKUPS"] isKindOfClass:[NSNull class]])
                    {
                        commonLookupsArray = [dict objectForKey:@"_COMMON_LOOKUPS"];
                    }
                    
                    NSArray *dataEntryItemsArray;
                    if (![[dict objectForKey:@"_DATA_ENTRY_ITEMS"] isKindOfClass:[NSNull class]])
                    {
                        dataEntryItemsArray = [dict objectForKey:@"_DATA_ENTRY_ITEMS"];
                    }
                    
                    NSArray *userParametersArray;
                    if (![[dict objectForKey:@"_User_Parameters"] isKindOfClass:[NSNull class]])
                    {
                        userParametersArray = [dict objectForKey:@"_User_Parameters"];
                    }
                    
                    NSArray *farmsArray;
                    if (![[dict objectForKey:@"_farms"] isKindOfClass:[NSNull class]]) {
                        farmsArray = [dict objectForKey:@"_farms"];
                    }
                    
                    NSMutableArray *arrFilteredFarms = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dict in farmsArray){
                        if (![[dict valueForKey:@"f_No"] isKindOfClass:[NSNull class]]){
                            [arrFilteredFarms addObject:dict];
                        }
                    }
                    
                    NSArray *geneticsArray;
                    if (![[dict objectForKey:@"_GENETICS"] isKindOfClass:[NSNull class]])
                    {
                        geneticsArray = [dict objectForKey:@"_GENETICS"];
                    }
                    
                    NSArray *locationsArray;
                    if (![[dict objectForKey:@"_LOCATIONS"] isKindOfClass:[NSNull class]]){
                        locationsArray = [dict objectForKey:@"_LOCATIONS"];
                    }
                    
                    // new additions
                    NSArray* operatorArray;
                    if (![[dict objectForKey:@"_Operators"] isKindOfClass:[NSNull class]]){
                        operatorArray = [dict objectForKey:@"_Operators"];
                    }
                    
                    //
                        NSMutableArray *arrOperatorArray = [[NSMutableArray alloc] init];
                        
                        for (NSDictionary *dict in operatorArray)
                        {
                            NSMutableDictionary *dt  = [[NSMutableDictionary alloc]init];
//                            if (![[dict objectForKey:@"fn"] isKindOfClass:[NSNull class]]){
//                                [dt setValue:[dict objectForKey:@"fn"] forKey:@"fn"];
//                            }
                            if (![[dict objectForKey:@"id"] isKindOfClass:[NSNull class]]){
                                [dt setValue:[dict valueForKey:@"id"] forKey:@"id"];
                            }
                            if (![[dict objectForKey:@"sn"] isKindOfClass:[NSNull class]]){
                                [dt setValue:[dict valueForKey:@"sn"] forKey:@"sn"];
                            }
                            if (![[dict objectForKey:@"ln"] isKindOfClass:[NSNull class]]){
                                [dt setValue:[dict valueForKey:@"ln"] forKey:@"ln"];
                            }
                            
//                            if (![[dict objectForKey:@"sid"] isKindOfClass:[NSNull class]]){
//                                [dt setValue:[dict valueForKey:@"sid"] forKey:@"sid"];
//                            }
                            
                            [arrOperatorArray addObject:dt];
                        }
                    //
                    
                    NSArray* breeedingCompaniesArray;
                    if (![[dict objectForKey:@"_BREEDING_COMPANIES"] isKindOfClass:[NSNull class]]){
                        breeedingCompaniesArray = [dict objectForKey:@"_BREEDING_COMPANIES"];
                    }
                    
                    NSArray* conditionsArray;
                    if (![[dict objectForKey:@"_CONDITIONS"] isKindOfClass:[NSNull class]]){
                        conditionsArray = [dict objectForKey:@"_CONDITIONS"];
                    }
                    
                    NSArray* conditionsScoreArray;
                    if (![[dict objectForKey:@"_ConditionScore"] isKindOfClass:[NSNull class]]){
                        conditionsScoreArray = [dict objectForKey:@"_ConditionScore"];
                    }
                    
                    NSArray* _herdCategoryArray;
                    if (![[dict objectForKey:@"_HerdCategory"] isKindOfClass:[NSNull class]]){
                        _herdCategoryArray = [dict objectForKey:@"_HerdCategory"];
                    }
                    
                    //
                    NSArray* _LesionScoreArray;
                    if (![[dict objectForKey:@"_LESION_SCORES"] isKindOfClass:[NSNull class]]){
                        _LesionScoreArray = [dict objectForKey:@"_LESION_SCORES"];
                    }
                    
                    NSArray* _LockArray;
                    if (![[dict objectForKey:@"_MATINGLOCK"] isKindOfClass:[NSNull class]]){
                        _LockArray = [dict objectForKey:@"_MATINGLOCK"];
                    }
                    
                    NSArray* _LeakageArray;
                    if (![[dict objectForKey:@"_MATINGLEAK"] isKindOfClass:[NSNull class]]){
                        _LeakageArray = [dict objectForKey:@"_MATINGLEAK"];
                    }
                    
                    NSArray* _QualityArray;
                    if (![[dict objectForKey:@"_MATINGQUALITY"] isKindOfClass:[NSNull class]]){
                        _QualityArray = [dict objectForKey:@"_MATINGQUALITY"];
                    }
                    
                    NSArray* _StandingReflexArray;
                    if (![[dict objectForKey:@"_MATINGSTANDREFLEX"] isKindOfClass:[NSNull class]]){
                        _StandingReflexArray = [dict objectForKey:@"_MATINGSTANDREFLEX"];
                    }
                    
                    NSArray* _TestTypeArray;
                    if (![[dict objectForKey:@"_TESTTYPE"] isKindOfClass:[NSNull class]]){
                        _TestTypeArray = [dict objectForKey:@"_TESTTYPE"];
                    }
                    //
                    
                    NSArray* flagsArray;
                    if (![[dict objectForKey:@"_FLAGS"] isKindOfClass:[NSNull class]]){
                        flagsArray = [dict objectForKey:@"_FLAGS"];
                    }
                    
                    NSArray* transportCompaniesArray;
                    if (![[dict objectForKey:@"_TRANSPORT_COMPANIES"] isKindOfClass:[NSNull class]]){
                        transportCompaniesArray = [dict objectForKey:@"_TRANSPORT_COMPANIES"];
                    }
                    NSArray* packingPlantsArray;

                    if (![[dict objectForKey:@"_PACKING_PLANTS"] isKindOfClass:[NSNull class]]){
                        packingPlantsArray = [dict objectForKey:@"_PACKING_PLANTS"];
                    }
                    
                    NSArray* treatmentsArray;
                    if (![[dict objectForKey:@"_TREATMENTS"] isKindOfClass:[NSNull class]]){
                        treatmentsArray = [dict objectForKey:@"_TREATMENTS"];
                    }
                    
                    NSMutableArray *arrFilteredDestination = [[NSMutableArray alloc]init];
                    NSArray* destinartionArray;
                    if (![[dict objectForKey:@"_DESTINATION"] isKindOfClass:[NSNull class]]) {
                        destinartionArray = [dict objectForKey:@"_DESTINATION"];
                        //
                        
                        @try {
                            for (NSDictionary *dict in destinartionArray)
                            {
                                NSMutableDictionary *dt  = [[NSMutableDictionary alloc]init];
                                [dt setValue:[dict objectForKey:@"Ds"] forKey:@"Ds"];
                                [dt setValue:[dict valueForKey:@"fC"] forKey:@"fC"];
                                [dt setValue:[dict valueForKey:@"sid"] forKey:@"sid"];
                                [dt setValue:[dict valueForKey:@"zD"] forKey:@"zD"];
                                
                                [arrFilteredDestination addObject:dt];
                            }
                        }
                        @catch (NSException *exception) {
                            
                            NSLog(@"Exception =%@",exception.description);
                        }
                    }
                    
                    //discription
                    NSMutableArray *arrFilteredOrigin = [[NSMutableArray alloc]init];
                    
                    NSArray* originArray;
                    if (![[dict objectForKey:@"_ORIGIN"] isKindOfClass:[NSNull class]])
                    {
                        originArray = [dict objectForKey:@"_ORIGIN"];
                        
                        @try {
                            for (NSDictionary *dict in originArray)
                            {
                                NSMutableDictionary *dt  = [[NSMutableDictionary alloc]init];
                                [dt setValue:[dict objectForKey:@"Ds"] forKey:@"Ds"];
                                [dt setValue:[dict valueForKey:@"fC"] forKey:@"fC"];
                                [dt setValue:[dict valueForKey:@"sid"] forKey:@"sid"];
                                [dt setValue:[dict valueForKey:@"zD"] forKey:@"zD"];
                                
                                [arrFilteredOrigin addObject:dt];
                            }
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Exception =%@",exception.description);
                        }
                    }
                    
                    [[CoreDataHandler sharedHandler] removeAllmanagedObject];
                    {
                        BOOL isSucess = [[CoreDataHandler sharedHandler] insertBulkValuesWithCommonLookupArray:commonLookupsArray andFarmsArray:arrFilteredFarms andDataEntryArray:dataEntryItemsArray andGeneticsArray:geneticsArray andUserParameters:userParametersArray andLocations:locationsArray andOperatorArray:arrOperatorArray andBreedingComapniesArray:breeedingCompaniesArray andCondistionsArray:conditionsArray andFlagsArray:flagsArray andTransportArray:transportCompaniesArray andPackingPlantsArray:packingPlantsArray andTreatmentsArray:treatmentsArray andAdminRoutes:adminRoutes andAiStuds:aistuds  andHalothane:halothane andPdResults:pdResults andSex:sex andTod:tod andOrigin:arrFilteredOrigin andDestination:arrFilteredDestination translated:_arrayEnglish conditionScore:conditionsScoreArray herdCategory:_herdCategoryArray lesionScoreArray:_LesionScoreArray lockArray:_LockArray leakageArray:_LeakageArray qualityArray:_QualityArray standingReflexArray:_StandingReflexArray testTypeArray:_TestTypeArray];
                        
                        if (arrFilteredFarms.count==0) {
                            {
                                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                           message:@"User does not have access to any farm/Or problem loading data, Please try again."
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction* ok = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         if ([[ControlSettings sharedSettings] isNetConnected ]){
                                                             _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                             [_customIOS7AlertView showLoaderWithMessage:@"Signing off."];
                                                             
                                                             [ServerManager sendRequestForLogout:^(NSString *responseData) {
                                                                 NSLog(@"%@",responseData);
                                                                 self.txtPasswordtextField.text = @"";
                                                                 [_customIOS7AlertView close];
                                                                 if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])
                                                                 {
                                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                                message:responseData
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
                                                                 }else if ([responseData isEqualToString:@"\"Loged out\""]){
                                                                     //[self.navigationController popToRootViewControllerAnimated:YES];
                                                                 }
                                                                 
                                                             } onFailure:^(NSString *responseData, NSError *error) {
                                                                 if (responseData.integerValue ==401) {
                                                                     
                                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                                message:@"Your session has been expired. Please login again."
                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                     UIAlertAction* ok = [UIAlertAction
                                                                                          actionWithTitle:@"OK"
                                                                                          style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action) {
                                                                                              // [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                              [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                          }];
                                                                     
                                                                     [myAlertController addAction: ok];
                                                                     [self presentViewController:myAlertController animated:YES completion:nil];
                                                                     //[self.navigationController popToRootViewControllerAnimated:YES];
                                                                 }else{
                                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                                message:@"Server Error"
                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                     UIAlertAction* ok = [UIAlertAction
                                                                                          actionWithTitle:@"OK"
                                                                                          style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action) {
                                                                                              //[self.navigationController popToRootViewControllerAnimated:YES];
                                                                                              [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                          }];
                                                                     
                                                                     [myAlertController addAction: ok];
                                                                     [self presentViewController:myAlertController animated:YES completion:nil];
                                                                 }
                                                                 
                                                                 id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                                 NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                                                                 [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                                 NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                                                                 
                                                                 NSString *strErr = [NSString stringWithFormat:@"User Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],error.description,strDate,@"Simple Report"];
                                                                 [tracker set:kGAIScreenName value:strErr];
                                                                 [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                                                                 
                                                                 [_customIOS7AlertView close];
                                                             }];
                                                         }
                                                         else{
                                                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                        message:@"You must be online for the app to function."
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
                                                         
                                                         
                                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
                                
                                [myAlertController addAction: ok];
                                [self presentViewController:myAlertController animated:YES completion:nil];
                            }
                        }else if (arrFilteredFarms.count==1) {
                            
                            if (dataEntryItemsArray.count==0) {//to do
                                
                                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                           message:@"Please login again."
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction* ok = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         if ([[ControlSettings sharedSettings] isNetConnected ]){
                                                             _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                             [_customIOS7AlertView showLoaderWithMessage:@"Signing off."];
                                                             
                                                             [ServerManager sendRequestForLogout:^(NSString *responseData) {
                                                                 NSLog(@"%@",responseData);
                                                                 [_customIOS7AlertView close];
                                                                 
                                                                 if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                                                                     //[[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:responseData];
                                                                     
                                                                     //                                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                     //                                                                                                                        message:responseData
                                                                     //                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                     //                                             UIAlertAction* ok = [UIAlertAction
                                                                     //                                                                  actionWithTitle:strOK
                                                                     //                                                                  style:UIAlertActionStyleDefault
                                                                     //                                                                  handler:^(UIAlertAction * action)                                                              {
                                                                     //
                                                                     //
                                                                     //                                                                      [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                                                     //                                                                      //[self.navigationController popToRootViewControllerAnimated:YES];
                                                                     //                                                                      [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                     //                                                                  }];
                                                                     //
                                                                     //                                             [myAlertController addAction: ok];
                                                                     //                                             [self presentViewController:myAlertController animated:YES completion:nil];
                                                                 } else if ([responseData isEqualToString:@"\"Loged out\""] || [responseData isEqualToString:@""]){
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
                                                                 
                                                                 /*
                                                                  if (responseData.integerValue ==401) {
                                                                  
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
                                                                  
                                                                  }else {
                                                                  // [self.navigationController popToRootViewControllerAnimated:YES];
                                                                  
                                                                  //                                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                  //                                                                                                                        message:strServerErr
                                                                  //                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                  //                                             UIAlertAction* ok = [UIAlertAction
                                                                  //                                                                  actionWithTitle:strOK
                                                                  //                                                                  style:UIAlertActionStyleDefault
                                                                  //                                                                  handler:^(UIAlertAction * action) {
                                                                  //                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                  //                                                                      [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                  //                                                                  }];
                                                                  //
                                                                  //                                             [myAlertController addAction: ok];
                                                                  //                                             [self presentViewController:myAlertController animated:YES completion:nil];
                                                                  }
                                                                  */
                                                                 
                                                                 [_customIOS7AlertView close];
                                                             }];
                                                         }
                                                         else {
                                                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                        message:@"You must be online for the app to function."
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
                                                         
                                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
                                
                                [myAlertController addAction: ok];
                                [self presentViewController:myAlertController animated:YES completion:nil];
                            }
                            else{
                                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                NSLog(@"username=%@",[_pref valueForKey:@"userName"]);

                                    [user setValue:[[arrFilteredFarms objectAtIndex:0] valueForKey:@"id"] forKey:@"id"];
                                    [user setValue:[[arrFilteredFarms objectAtIndex:0] valueForKey:@"f_nm"] forKey:@"f_nm"];
                                    [user setValue:[[arrFilteredFarms objectAtIndex:0] valueForKey:@"ZD"] forKey:@"ZD"];
                                    [user setValue:[[arrFilteredFarms objectAtIndex:0] valueForKey:@"SSL"] forKey:@"SSL"];
                                    [user setValue:[[arrFilteredFarms objectAtIndex:0] valueForKey:@"SSW"] forKey:@"SSW"];
                                
                                [user setValue:self.txtLogintextField.text forKey:@"userName"];
                                [user synchronize];
                                
                                if (isSucess){
                                    [self performSegueWithIdentifier:@"segueFarmSelection" sender:self];
                                }
                            }
                       }
                        else {
                            NSLog(@"username=%@",[_pref valueForKey:@"userName"]);
                            if (![[_pref valueForKey:@"userName"] isEqualToString:self.txtLogintextField.text]){
                                [_pref setValue:@"" forKey:@"id"];
                                [_pref setValue:@"" forKey:@"f_nm"];
                                [_pref setValue:@"" forKey:@"ZD"];
                                [_pref setValue:@"" forKey:@"SSL"];
                                [_pref setValue:@"" forKey:@"SSW"];
                            }
                            
                            [[NSUserDefaults standardUserDefaults] setObject:self.txtLogintextField.text forKey:@"userName"];
                            
                            if (isSucess) {
                                [_customIOS7AlertView close];
                                [self performSegueWithIdentifier:@"SegueLogin" sender:self];
                            }
                        }
                    }
                }
            } onFailure:^(NSString *responseData, NSError *error) {
                [_customIOS7AlertView close];
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                
                NSString *strErr = [NSString stringWithFormat:@"User Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],error.description,strDate,@"Simple Report"];
                [tracker set:kGAIScreenName value:strErr];
                [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            }];
        }
        else {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:@"You must be online for the app to function."
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
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in updateMasterDataBase=%@",exception.description);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        NSLog(@"PrePare for segue");
       
        if ([segue.identifier isEqualToString:@"segueFarmSelection"])
        {
           // InitialViewController *toDoViewController = //segue.destinationViewController;
            //toDoViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segueDataEntry"];
        }
        else
        {
            //FarmSelectionViewController *farmSelectionViewController = segue.destinationViewController;
            //farmSelectionViewController.arrlanguage = _arrayEnglish;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in prepareForSegue in FarmSelection =%@",exception.description);
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
        NSLog(@"Exception in registerForKeyboardNotifications =%@",exception.description);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    @try{
        [self.scrBackground setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

        if (textField == self.txtLogintextField){
            [textField resignFirstResponder];
            [self.txtPasswordtextField becomeFirstResponder];
        }else{
            [textField resignFirstResponder];
        }
        
        return YES;
    }
    @catch (NSException *exception){
        NSLog(@"Exception in textFieldShouldReturn in ViewController- %@",[exception description]);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    @try {
        self.automaticallyAdjustsScrollViewInsets = YES;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.scrBackground.contentInset = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin))
        {
           [self.scrBackground scrollRectToVisible:self.activeTextField.frame animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in keyboardWasShown in ViewController =%@",exception.description);
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    @try {
        [self.scrBackground scrollRectToVisible:CGRectMake(0, 0, self.activeTextField.frame.size.width, self.activeTextField.frame.size.height) animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in keyboardWillHide in ViewController =%@",exception.description);
    }
}

#pragma mark - Other methods
- (IBAction)btnLanguage_tapped:(id)sender {
    @try {
        [self.activeTextField resignFirstResponder];
        self.pickerLanguage = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 10, 270, 150.0)];
        [self.pickerLanguage setDelegate:self];
       // self.pickerLanguage.showsSelectionIndicator = YES;
        [self.pickerLanguage setShowsSelectionIndicator:YES];

        _alertForLanguage = [[CustomIOS7AlertView alloc] init];
        [_alertForLanguage setMyDelegate:self];
        [_alertForLanguage setUseMotionEffects:true];
        [_alertForLanguage setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",@"Cancel", nil]];
        
        [self.pickerLanguage reloadAllComponents];
        [self.pickerLanguage selectRow:0 inComponent:0 animated:YES];
        //
        __weak typeof(self) weakSelf = self;
        [_alertForLanguage setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            
            if(buttonIndex == 0) {
                if (weakSelf.arrLanguage.count>0) {
                    NSInteger row = [weakSelf.pickerLanguage selectedRowInComponent:0];
                    [weakSelf.btnLanguage setTitle:[[weakSelf.arrLanguage objectAtIndex:row] valueForKey:@"name"] forState:UIControlStateNormal];
                    
                    //http://192.168.20.40/PigchampWeb/ //http://rdstest.pigchamp.com/
                    
                    NSString *str = [[NSLocalizedString(@"baseUrl" , @"") stringByAppendingString:@"lngmin/"] stringByAppendingString:[NSString stringWithFormat:@"%@.lng",[[weakSelf.arrLanguage objectAtIndex:row] valueForKey:@"name"]]];
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:str]]; //commented by amit as on dated 19th march 2018
                   /**********added below lines of code by ami as on 19th march 2018*/
                   /* NSString *encodedParam = [[_pref valueForKey:@"selectedLanguage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];// Amit Added this line of code
                    
                    NSString *strencoded = [[NSLocalizedString(@"baseUrl" , @"") stringByAppendingString:@"lngmin/"] stringByAppendingString:[NSString stringWithFormat:@"%@.lng",encodedParam]];//modified existing parameter
                    
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strencoded]];*/
                    /*********************************************************************/
                    NSString *gameFileContents = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
                    //  NSLog(@"gameFileContents%@", gameFileContents);
                    
                    NSMutableArray *allLinedStrings = (NSMutableArray*)[gameFileContents componentsSeparatedByString:@"\r\n"];
                    NSMutableArray *newArray;// = [[NSMutableArray alloc]init];
                    _arrayEnglish = [[NSMutableArray alloc]init];
                    
                    for (NSString *line in allLinedStrings) {
                        @autoreleasepool {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            newArray = (NSMutableArray*)[line componentsSeparatedByString:@"="];
                            
                            if (newArray.count==2) {
                                [dict setValue:[newArray objectAtIndex:0] forKey:@"englishText"];
                                [dict setValue:[newArray objectAtIndex:1] forKey:@"translatedText"];
                            }
                            
                            [weakSelf.arrayEnglish addObject:dict];
                        }
                    }
                    
                    [weakSelf.pref setValue:[[weakSelf.arrLanguage objectAtIndex:row] valueForKey:@"name"] forKey:@"selectedLanguage"];
                    [weakSelf.pref synchronize];
                }
                
                [weakSelf.alertForLanguage close];
            }
            }];
        
            NSString *strPrevSelectedValue = [weakSelf.pref valueForKey:@"selectedLanguage"];
        
            for (int count=0;count<weakSelf.arrLanguage.count;count++) {
            if (strPrevSelectedValue.length>0){
                if( [strPrevSelectedValue caseInsensitiveCompare:[[weakSelf.arrLanguage objectAtIndex:count] valueForKey:@"name"]] == NSOrderedSame){
                    [self.pickerLanguage selectRow:count inComponent:0 animated:NO];
                    [self.pickerLanguage setShowsSelectionIndicator:YES];
                }
            }
        }
        
        [weakSelf.alertForLanguage showCustomwithView:self.pickerLanguage title:@"Select Language"];
    }
    @catch (NSException *exception) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateformate stringFromDate:[NSDate date]];
        
        NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event(On Language selection) =%@",self.txtLogintextField.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],exception.description,strDate, @"Login"];
        [tracker set:kGAIScreenName value:strErr];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        NSLog(@"Exception in btnLanguage_tapped =%@",exception.description);
    }
}

@end
