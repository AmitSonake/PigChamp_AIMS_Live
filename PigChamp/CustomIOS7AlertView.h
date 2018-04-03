

#import <UIKit/UIKit.h>

@protocol CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomIOS7AlertView : UIView<CustomIOS7AlertViewDelegate>
{
    UIActivityIndicatorView *vwActivityIndicatorObj;
}

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<CustomIOS7AlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign)id myDelegate;

@property (copy) void (^onButtonTouchUpInside)(CustomIOS7AlertView *alertView, int buttonIndex) ;

- (id)init;
- (void)show;
- (void)close;
- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(CustomIOS7AlertView *alertView, int buttonIndex))onButtonTouchUpInside;
- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;
- (void)HideCloseButton:(BOOL)Hide;
- (void)showLoadingView;
- (void)showCustomwithView:(UIView *)vw title:(NSString*)title;
- (void)showLoaderWithMessage:(NSString *)message title:(NSString*)title;
- (void)showLoaderWithMessage:(NSString *)message;

@end
