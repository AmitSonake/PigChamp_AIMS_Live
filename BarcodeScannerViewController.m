//
//  BarcodeScannerViewController.m
//  PigChamp
//
//  Created by Venturelabour on 22/12/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "BarcodeScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    __weak IBOutlet UIView *highlightView;
    __weak IBOutlet UILabel *lbel;
}
@end

@implementation BarcodeScannerViewController
@synthesize delegate;

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"About"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem=barButton;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FromSetting"];
        _session = [[AVCaptureSession alloc] init];
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        
        if (_input) {
            [_session addInput:_input];
        } else {
            NSLog(@"Error: %@", error);
        }
        
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:_output];
        
        AVCaptureConnection *connection =
        [_output connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoOrientation:[self interfaceOrientationToVideoOrientation:[UIApplication sharedApplication].statusBarOrientation]];
        _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
        
        _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _prevLayer.frame = CGRectMake(highlightView.bounds.origin.x, highlightView.bounds.origin.y, highlightView.bounds.size.width, highlightView.bounds.size.height);
        _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_prevLayer];
        
        _prevLayer.zPosition = -1;
        [_session startRunning];
    }
    @catch (NSException *exception) {
        
        [self ShowAlert:exception.description];
        NSLog(@"Exception =%@",exception.description);
    }
}

- (void)viewWillLayoutSubviews{
    @try {
        _prevLayer.frame = highlightView.bounds;
    }
    @catch (NSException *exception) {
        [self ShowAlert:exception.description];

        NSLog(@"Exception =%@",exception.description);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    @try {
        if (_prevLayer.connection.supportsVideoOrientation) {
            _prevLayer.connection.videoOrientation = [self interfaceOrientationToVideoOrientation:toInterfaceOrientation];
        }
    }
    @catch (NSException *exception) {
        [self ShowAlert:exception.description];

        NSLog(@"Exception =%@",exception.description);
    }
}

-(AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation {
    @try {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                return AVCaptureVideoOrientationPortrait;
            case UIInterfaceOrientationPortraitUpsideDown:
                return AVCaptureVideoOrientationPortraitUpsideDown;
            case UIInterfaceOrientationLandscapeLeft:
                return AVCaptureVideoOrientationLandscapeLeft ;
            case UIInterfaceOrientationLandscapeRight:
                return AVCaptureVideoOrientationLandscapeRight;
            default:
                break;
        }
        
        return AVCaptureVideoOrientationPortrait;
        
    }
    @catch (NSException *exception) {
        [self ShowAlert:exception.description];

        NSLog(@"Exception =%@",exception.description);
    }

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    @try {
        NSString *detectionString = nil;
        NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                  AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barCodeTypes) {
                if ([metadata.type isEqualToString:type]){
                    // barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    // highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    [_session stopRunning];
                    break;
                }
            }
            
            if (detectionString != nil){
                lbel.text = detectionString;
                [delegate scannedBarcode:detectionString];
                // [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
            else
                lbel.text = @"(none)";
        }
    }
    @catch (NSException *exception) {
        [self ShowAlert:exception.description];
        NSLog(@"Exception =%@",exception.description);
    }
}

- (IBAction)btnCancle_tapped:(id)sender {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnCancle_tapped =%@",exception.description);
    }
}

- (IBAction)btnBack_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)ShowAlert:(NSString*)strMsg{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                               message:strMsg
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

@end
