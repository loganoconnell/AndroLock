#import "CBAutoScrollLabel/CBAutoScrollLabel.h"
#import "UAObfuscatedString/UAObfuscatedString.h"

UIButton *ALUnlockButton;
UIView *ALOverscrollView;

UIView *ALBackgroundDimView;
UIImageView *ALBackgroundArtworkImage;

UIView *ALMainView;

UIImageView *ALArtworkImage;
UIButton *ALRewindButton;
UIButton *ALPlayPauseButton;
UIButton *ALFastForwardButton;

CBAutoScrollLabel *ALNowPlayingSongLabel;
CBAutoScrollLabel *ALNowPlayingArtistLabel;

static BOOL ALAddedToLockScreen = NO;
static BOOL ALMiniplayerAddedToLockScreen = NO;

static BOOL ALEnabled;
static BOOL ALNotifications;
static BOOL ALMiniplayer;
static BOOL ALUnlock;
static BOOL ALGrabbers;
static BOOL ALPushDownDate;
static BOOL ALPasscodeBackground;
static BOOL ALPushDownPasscode;
static BOOL ALPasscodeButtons;
static BOOL ALPasscodeExtraButtons;
static BOOL ALHideExtraViews;

extern "C" void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, void (^MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef information));
extern "C" void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t queue, void (^MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion)(Boolean isPlaying));

@interface UIApplication (AndroLock)
- (void)_relaunchSpringBoardNow;
@end

@interface UIImage (AndroLock)
- (UIImage *)_flatImageWithColor:(UIColor *)arg1;
@end

@interface SpringBoard : UIApplication
- (void)applicationDidFinishLaunching:(id)arg1;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)changeTrack:(int)arg1;
- (BOOL)togglePlayPause;
@end

@interface SBDeviceLockController : NSObject
+ (id)sharedController;
- (BOOL)deviceHasPasscodeSet;
@end

@interface SBLockScreenViewController : UIViewController
- (UIScrollView *)lockScreenScrollView;
- (void)setPasscodeLockVisible:(BOOL)arg1 animated:(BOOL)arg2 completion:(id)arg3;
- (void)ALUpdateMiniplayerInfo:(id)sender;
- (void)ALUpdateMiniplayerStatus:(id)sender;
- (void)_handleDisplayTurnedOnWhileUILocked:(id)arg1;
- (void)finishUIUnlockFromSource:(int)arg1;
- (void)notificationListBecomingVisible:(BOOL)arg1;
- (BOOL)lockScreenIsShowingBulletins;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
- (SBLockScreenViewController *)lockScreenViewController;
@end

@interface SBFLockScreenDateView : UIView
@end

@interface SBLockScreenView : UIView
- (void)pushDateDown:(BOOL)down;
- (CGFloat)hintDisplacement;
- (void)setMediaControlsHidden:(BOOL)arg1 forRequester:(id)arg1;
- (void)setTopGrabberHidden:(BOOL)arg1 forRequester:(id)arg2;
- (void)setBottomGrabberHidden:(BOOL)arg1 forRequester:(id)arg2;
- (void)setPluginViewHidden:(BOOL)arg1 forRequester:(id)arg2;
- (void)_layoutSlideToUnlockView;
- (void)_showFakeWallpaperBlurWithAlpha:(CGFloat)arg1 withFactory:(id)arg2;
@end

@interface SBLockScreenNotificationListView : UIView
@end

@interface SBTableViewCellActionButton : UIView
@end

@interface SBLockScreenBulletinCell : UIView
- (void)setContentAlpha:(CGFloat)arg1;
@end

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)arg1;
@end

@interface SBLockScreenSlideUpToAppController : NSObject
- (void)setTargetApp:(SBApplication *)arg1 withAppSuggestion:(id)arg2;
- (void)setGrabberViewImage:(UIImage *)arg1;
@end

@interface SBSlideUpAppGrabberView : UIView
@end

@interface SBPasscodeNumberPadButton : UIView
- (unsigned)character;
- (id)initForCharacter:(unsigned)arg1;
@end

@interface SBUIPasscodeLockViewWithKeypad : UIView
- (NSString *)passcode;
- (void)passcodeLockNumberPadCancelButtonHit:(id)arg1;
- (void)passcodeLockNumberPadBackspaceButtonHit:(id)arg1;
- (void)passcodeLockNumberPadEmergencyCallButtonHit:(id)arg1;
- (void)setCustomBackgroundColor:(UIColor *)arg1;
- (void)setBackgroundAlpha:(CGFloat)arg1;
- (void)passcodeLockNumberPad:(id)arg1 keyDown:(SBPasscodeNumberPadButton  *)arg2;
@end

@interface SBUIPasscodeEntryField : UIView
- (CGSize)_viewSize;
@end

@interface SBUIPasscodeLockViewSimpleFixedDigitKeypad : UIView
- (CGFloat)_numberPadOffsetFromTopOfScreen;
- (CGFloat)_entryFieldBottomYDistanceFromNumberPadTopButton;
@end

@interface SBUIPasscodeLockNumberPad : UIView
- (void)setShowsEmergencyCallButton:(BOOL)arg1;
@end

@interface TPNumberPad : UIView
- (id)initWithButtons:(NSArray *)arg1;
- (CGSize)intrinsicContentSize;
@end

@interface TPRevealingRingView : UIView
- (void)setCornerRadius:(CGFloat)arg1;
- (void)setDefaultRingStrokeWidth:(CGFloat)arg1;
@end

@interface TPNumberPadButton : UIView
+ (id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3;
+ (UIImage *)modifyImage:(UIImage *)originalImage forNumber:(unsigned)number;
- (TPRevealingRingView *)revealingRingView;
- (void)setHighlighted:(BOOL)arg1;
@end