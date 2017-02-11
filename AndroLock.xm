#import "AndroLock.h"

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;

	if (![[NSFileManager defaultManager] fileExistsAtPath:Obfuscate.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.d.p.k.g.forward_slash.i.n.f.o.forward_slash.o.r.g.dot.t.h.e.b.i.g.b.o.s.s.dot.a.n.d.r.o.l.o.c.k.dot.l.i.s.t] || access([Obfuscate.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.d.p.k.g.forward_slash.i.n.f.o.forward_slash.o.r.g.dot.t.h.e.b.i.g.b.o.s.s.dot.a.n.d.r.o.l.o.c.k.dot.l.i.s.t UTF8String], F_OK) == -1) {
		FILE *tmp = fopen([Obfuscate.forward_slash.v.a.r.forward_slash.m.o.b.i.l.e.forward_slash.L.i.b.r.a.r.y.forward_slash.P.r.e.f.e.r.e.n.c.e.s.forward_slash.c.o.m.dot.s.a.u.r.i.k.dot.m.o.b.i.l.e.s.u.b.s.t.r.a.t.e.dot.d.a.t UTF8String], [Obfuscate.w UTF8String]);
        fclose(tmp);

        [[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}
%end

%hook SBLockScreenViewController
- (void)_handleDisplayTurnedOnWhileUILocked:(id)arg1 {
	%orig;

	[self.view layoutSubviews];

	if (!ALAddedToLockScreen) {
		if (ALUnlock) {
			ALUnlockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ALUnlockButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width + (([[UIScreen mainScreen] bounds].size.width - 29) / 2), [[UIScreen mainScreen] bounds].size.height - 36, 29, 29);
			ALUnlockButton.backgroundColor = [UIColor clearColor];
			ALUnlockButton.tintColor = [UIColor whiteColor];
			[ALUnlockButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/unlock.png"] _flatImageWithColor:[UIColor colorWithWhite:1 alpha:0.85]] forState:UIControlStateNormal];
			[ALUnlockButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[ALUnlockButton addTarget:self action:@selector(ALUnlock:) forControlEvents:UIControlEventTouchUpInside];
			[[self lockScreenScrollView] addSubview:ALUnlockButton];
			[[self lockScreenScrollView] bringSubviewToFront:ALUnlockButton];
		}

		if (ALPasscodeBackground) {
			ALOverscrollView = [[UIView alloc] initWithFrame:CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
			ALOverscrollView.backgroundColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:0.85];
			[[self lockScreenScrollView] addSubview:ALOverscrollView];
			[[self lockScreenScrollView] sendSubviewToBack:ALOverscrollView];
		}

		if (ALMiniplayer && [[%c(SBMediaController) sharedInstance] isPlaying]) {
			ALBackgroundDimView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width * 2, [[UIScreen mainScreen] bounds].size.height)];
			ALBackgroundDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5]; 
			[[self lockScreenScrollView] addSubview:ALBackgroundDimView];
			[[self lockScreenScrollView] sendSubviewToBack:ALBackgroundDimView];

			ALBackgroundArtworkImage = [[UIImageView alloc] initWithImage:nil];
			ALBackgroundArtworkImage.frame = [[UIScreen mainScreen] bounds];
			ALBackgroundArtworkImage.contentMode = UIViewContentModeScaleAspectFill;
			[self.view addSubview:ALBackgroundArtworkImage];
			[self.view sendSubviewToBack:ALBackgroundArtworkImage];

			UIView *dateView = MSHookIvar<UIView *>(self.view, "_dateView");
			UILabel *dateLabel = MSHookIvar<UILabel *>(dateView, "_dateLabel");
			UILabel *timeLabel = MSHookIvar<UILabel *>(dateView, "_timeLabel");

			ALMainView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width + 7.5, dateLabel.frame.size.height + timeLabel.frame.size.height + 36, [[UIScreen mainScreen] bounds].size.width - 15, 60)];
			ALMainView.backgroundColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:0.85];
			[[ALMainView layer] setCornerRadius:3];
			[[self lockScreenScrollView] addSubview:ALMainView];
			[[self lockScreenScrollView] bringSubviewToFront:ALMainView];
		    
			ALArtworkImage = [[UIImageView alloc] initWithImage:nil];
			ALArtworkImage.frame = CGRectMake(0, 0, 60, 60);
			[ALMainView addSubview:ALArtworkImage];

			UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:ALArtworkImage.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
			CAShapeLayer *maskLayer = [CAShapeLayer layer];
			maskLayer.frame = ALArtworkImage.bounds;
			maskLayer.path = maskPath.CGPath;
			ALArtworkImage.layer.mask = maskLayer;
			
			ALNowPlayingSongLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(65, 5, [[UIScreen mainScreen] bounds].size.width - 190, 30)];
			ALNowPlayingSongLabel.textColor = [UIColor whiteColor]; 
			ALNowPlayingSongLabel.textAlignment = NSTextAlignmentLeft;
			ALNowPlayingSongLabel.font = [UIFont systemFontOfSize:18];
			ALNowPlayingSongLabel.backgroundColor = [UIColor clearColor];
			ALNowPlayingSongLabel.text = @"Song Title";
			ALNowPlayingSongLabel.fadeLength = 3;
			ALNowPlayingSongLabel.labelSpacing = 20; 
			ALNowPlayingSongLabel.pauseInterval = 1.7;
			ALNowPlayingSongLabel.scrollSpeed = 30;
			ALNowPlayingSongLabel.scrollDirection = CBAutoScrollDirectionLeft;
			[ALNowPlayingSongLabel observeApplicationNotifications];
			[ALMainView addSubview:ALNowPlayingSongLabel];

			ALNowPlayingArtistLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(65, 25, [[UIScreen mainScreen] bounds].size.width - 190, 30)];
			ALNowPlayingArtistLabel.textColor = [UIColor grayColor];
			ALNowPlayingArtistLabel.textAlignment = NSTextAlignmentLeft;
			ALNowPlayingArtistLabel.font = [UIFont systemFontOfSize:16];
			ALNowPlayingArtistLabel.backgroundColor = [UIColor clearColor];
			ALNowPlayingArtistLabel.text = @"Artist";
			ALNowPlayingArtistLabel.fadeLength = 3;
			ALNowPlayingArtistLabel.labelSpacing = 20; 
			ALNowPlayingArtistLabel.pauseInterval = 1.7;
			ALNowPlayingArtistLabel.scrollSpeed = 30;
			ALNowPlayingArtistLabel.scrollDirection = CBAutoScrollDirectionLeft;
			[ALNowPlayingArtistLabel observeApplicationNotifications];
			[ALMainView addSubview:ALNowPlayingArtistLabel];

			ALRewindButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ALRewindButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 120, ALMainView.frame.size.height / 2 - 16, 32, 32);
			ALRewindButton.backgroundColor = [UIColor clearColor];
			ALRewindButton.tintColor = [UIColor whiteColor];
			[ALRewindButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/rewind.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
			[ALRewindButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[ALRewindButton addTarget:self action:@selector(ALRewind:) forControlEvents:UIControlEventTouchUpInside];
			[ALMainView addSubview:ALRewindButton];

			ALPlayPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ALPlayPauseButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 85, ALMainView.frame.size.height / 2 - 17.5, 35, 35);
			ALPlayPauseButton.backgroundColor = [UIColor clearColor];
			ALPlayPauseButton.tintColor = [UIColor whiteColor];
			[ALPlayPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/play.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
			[ALPlayPauseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[ALPlayPauseButton addTarget:self action:@selector(ALPlayPause:) forControlEvents:UIControlEventTouchUpInside];
			[ALMainView addSubview:ALPlayPauseButton];

			ALFastForwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ALFastForwardButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 50, ALMainView.frame.size.height / 2 - 16, 32, 32);
			ALFastForwardButton.backgroundColor = [UIColor clearColor];
			ALFastForwardButton.tintColor = [UIColor whiteColor];
			[ALFastForwardButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/fastforward.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
			[ALFastForwardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[ALFastForwardButton addTarget:self action:@selector(ALFastForward:) forControlEvents:UIControlEventTouchUpInside];
			[ALMainView addSubview:ALFastForwardButton];

			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ALUpdateMiniplayerInfo:) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ALUpdateMiniplayerStatus:) name:@"kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification" object:nil];

			[self ALUpdateMiniplayerInfo:nil];
			[self ALUpdateMiniplayerStatus:nil];

			ALMiniplayerAddedToLockScreen = YES;			
		}

		ALAddedToLockScreen = YES;
	}
}

- (void)finishUIUnlockFromSource:(int)arg1 {
	%orig;

	ALAddedToLockScreen = NO;
	ALMiniplayerAddedToLockScreen = NO;
}

- (void)notificationListBecomingVisible:(BOOL)arg1 {
	%orig;

	[self.view layoutSubviews];
}

%new
- (void)ALUnlock:(id)sender {
	if ([[%c(SBDeviceLockController) sharedController] deviceHasPasscodeSet]) {
		[self setPasscodeLockVisible:YES animated:YES completion:nil];
	}

	else {
		[[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:0 withOptions:nil];
	}
}

%new
- (void)ALRewind:(id)sender {
    [[%c(SBMediaController) sharedInstance] changeTrack:-1];
}

%new
- (void)ALPlayPause:(id)sender {
    [[%c(SBMediaController) sharedInstance] togglePlayPause];
}

%new
- (void)ALFastForward:(id)sender {
    [[%c(SBMediaController) sharedInstance] changeTrack:1];
}

%new
- (void)ALUpdateMiniplayerInfo:(id)sender {
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		NSDictionary *dict = (NSDictionary *)result;

		ALBackgroundArtworkImage.image = [UIImage imageWithData:[dict objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
		ALArtworkImage.image = [UIImage imageWithData:[dict objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
		ALNowPlayingSongLabel.text = (NSString *)[dict objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
		ALNowPlayingArtistLabel.text = (NSString *)[dict objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
	});
}

%new
- (void)ALUpdateMiniplayerStatus:(id)sender {
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
		if ((BOOL)isPlaying) {
      		[ALPlayPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/pause.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    	}

    	else {
			[ALPlayPauseButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/play.png"] _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    	}
    });
}
%end
	
%hook SBLockScreenView
- (void)layoutSubviews {
  	%orig;

	if ((ALNotifications && ALMiniplayer) || ((ALNotifications && !ALMiniplayer) && [[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] lockScreenIsShowingBulletins]) || ((!ALNotifications && ALMiniplayer) && ([[%c(SBMediaController) sharedInstance] isPlaying] || ALMiniplayerAddedToLockScreen))) {
		MSHookIvar<UIView *>(self, "_foregroundLockUnderlayView").hidden = YES;
	}

	else {
		MSHookIvar<UIView *>(self, "_foregroundLockUnderlayView").hidden = NO;
	}

	if (ALPasscodeBackground) {
		MSHookIvar<UIView *>(self, "_passcodeOverscrollBackgroundView").hidden = YES;
	}

  	if (ALPushDownDate && !([[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] lockScreenIsShowingBulletins] || [[%c(SBMediaController) sharedInstance] isPlaying] || ALMiniplayerAddedToLockScreen)) {
  		[self pushDateDown:YES];
  	}

  	else {
  		[self pushDateDown:NO];
  	}
}

%new
- (void)pushDateDown:(BOOL)down {
	if (down) {
		UIView *dateView = MSHookIvar<UIView *>(self, "_dateView");
		UIView *batteryChargingView = MSHookIvar<UIView *>(self, "_batteryChargingView");

	  	CGRect newDateViewFrame = dateView.frame;
	  	CGRect newBatteryChargingViewFrame = batteryChargingView.frame;

	  	newDateViewFrame.origin.y = [[UIScreen mainScreen] bounds].size.height / 5;
	  	newBatteryChargingViewFrame.origin.y = ([[UIScreen mainScreen] bounds].size.height / 5) - 28.5;

        dateView.frame = newDateViewFrame;
        batteryChargingView.frame = newBatteryChargingViewFrame;
	}

	else {
		UIView *dateView = MSHookIvar<UIView *>(self, "_dateView");
		UIView *batteryChargingView = MSHookIvar<UIView *>(self, "_batteryChargingView");

	  	CGRect newDateViewFrame = dateView.frame;
	  	CGRect newBatteryChargingViewFrame = batteryChargingView.frame;

	  	newDateViewFrame.origin.y = 28.5;
	  	newBatteryChargingViewFrame.origin.y = 0;

        dateView.frame = newDateViewFrame;
        batteryChargingView.frame = newBatteryChargingViewFrame;
	}
}

- (CGFloat)hintDisplacement {
	if (ALNotifications || ALMiniplayer) {
		return 0;
	}

	else {
		return %orig;
	}
}

- (void)setMediaControlsHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (ALMiniplayer) {
		%orig(YES, arg2);
	}

	else {
		%orig;
	}
}

- (void)setPluginViewHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (ALMiniplayer) {
		%orig(YES, arg2);
	}

	else {
		%orig;
	}
}

- (void)setTopGrabberHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (ALHideExtraViews) {
		%orig(YES, arg2);
	}
	
	else {
		%orig;
	}
}

- (void)setBottomGrabberHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (ALHideExtraViews) {
		%orig(YES, arg2);
	}
	
	else {
		%orig;
	}
}

- (void)_layoutSlideToUnlockView {
	if (ALHideExtraViews) {
		return;
	}

	else {
		return %orig;
	}
}

- (void)_showFakeWallpaperBlurWithAlpha:(CGFloat)arg1 withFactory:(id)arg2 {
	if ((ALNotifications && ALMiniplayer) || ((ALNotifications && !ALMiniplayer) && [[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] lockScreenIsShowingBulletins]) || ((!ALNotifications && ALMiniplayer) && ([[%c(SBMediaController) sharedInstance] isPlaying] || ALMiniplayerAddedToLockScreen))) {
		%orig(0, arg2);
	}

	else {
		%orig;
	}
}
%end

%hook SBLockScreenNotificationListView
- (void)layoutSubviews {
	%orig;

	UIView *containerView = MSHookIvar<UIView *>(self, "_containerView");

	if (ALNotifications) {
		((UIView*)[containerView subviews][1]).hidden = YES;
		((UIView*)[containerView subviews][2]).hidden = YES;
		MSHookIvar<UITableView *>(self, "_tableView").separatorStyle = UITableViewCellSeparatorStyleNone;
	}

	if (ALMiniplayer && [[%c(SBMediaController) sharedInstance] isPlaying]) {
		CGRect newContainerViewFrame = containerView.frame;

		newContainerViewFrame.origin.y = newContainerViewFrame.origin.y + 60;
		newContainerViewFrame.size.height = newContainerViewFrame.size.height - 60;
		containerView.frame = newContainerViewFrame;
	}
}
%end

%hook SBTableViewCellActionButton
- (void)layoutSubviews {
	%orig;

	if (ALNotifications) {
		[self layer].backgroundColor = [[UIColor clearColor] CGColor];
		MSHookIvar<UIView *>(self, "_backgroundView").backgroundColor = [UIColor clearColor];
	}
}
%end

%hook SBLockScreenBulletinCell
- (void)layoutSubviews {
	%orig;

	if (ALNotifications) {
		UIView *realContentView = MSHookIvar<UIView *>(self, "_realContentView");
	
		MSHookIvar<UILabel *>(self, "_primaryLabel").textColor = [UIColor blackColor];
		
		MSHookIvar<UILabel *>(self, "_secondaryLabel").textColor = [UIColor blackColor];
		
		MSHookIvar<UILabel *>(self, "_subtitleLabel").textColor = [UIColor blackColor];

		MSHookIvar<UILabel *>(self, "_eventDateLabel").textColor = [UIColor blackColor];

		UIImageView *iconImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		CGRect newIconImageViewFrame = iconImageView.frame;
		newIconImageViewFrame.origin.y = (self.frame.size.height - newIconImageViewFrame.size.height) / 2;
		iconImageView.frame = newIconImageViewFrame;

		iconImageView.layer.cornerRadius = iconImageView.frame.size.height / 2;
		iconImageView.layer.masksToBounds = YES;

		UIView *attachmentView = MSHookIvar<UIView *>(self, "_attachmentView");

		CGRect newAttachmentViewFrame = attachmentView.frame;
		newAttachmentViewFrame.origin.y = (self.frame.size.height - newAttachmentViewFrame.size.height) / 2;
		attachmentView.frame = newAttachmentViewFrame;

		[[attachmentView layer] setCornerRadius:3];

		for (UIView *view in [realContentView subviews]) {
			if (view.tag == 1000) {
				[view removeFromSuperview];
			}
		}

		UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 3, self.frame.size.width - 15, self.frame.size.height - 6)];
		backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
		backgroundView.tag = 1000;
		[[backgroundView layer] setCornerRadius:3];
		[realContentView addSubview:backgroundView];
		[realContentView sendSubviewToBack:backgroundView];

		UILabel *oldRelevanceDateLabel = MSHookIvar<UILabel *>(self, "_relevanceDateLabel");
		oldRelevanceDateLabel.hidden = YES;

		UILabel *newRelevanceDateLabel = [[UILabel alloc] initWithFrame:oldRelevanceDateLabel.frame];
		newRelevanceDateLabel.text = oldRelevanceDateLabel.text;
		newRelevanceDateLabel.textColor = [UIColor blackColor];
		newRelevanceDateLabel.font = oldRelevanceDateLabel.font;
		newRelevanceDateLabel.tag = 1000;
		[realContentView addSubview:newRelevanceDateLabel];
		[realContentView bringSubviewToFront:newRelevanceDateLabel];

		UILabel *oldUnlockTextLabel = MSHookIvar<UILabel *>(self, "_unlockTextLabel");
		oldRelevanceDateLabel.hidden = YES;

		UILabel *newUnlockTextLabel = [[UILabel alloc] initWithFrame:oldUnlockTextLabel.frame];
		newUnlockTextLabel.text = oldUnlockTextLabel.text;
		newUnlockTextLabel.textColor = [UIColor blackColor];
		newUnlockTextLabel.font = oldUnlockTextLabel.font;
		newUnlockTextLabel.tag = 1000;
		[realContentView addSubview:newUnlockTextLabel];
		[realContentView bringSubviewToFront:newUnlockTextLabel];
	}
}

- (void)setContentAlpha:(CGFloat)arg1 {
	if (ALNotifications) {
		%orig(1);
	}

	else {
		%orig;
	}
}
%end

%hook SBLockScreenSlideUpToAppController
- (void)setTargetApp:(SBApplication *)arg1 withAppSuggestion:(id)arg2 {
	if (ALGrabbers && !arg1) {
		SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.mobilephone"];

		%orig(application, arg2);

		CGSize size = CGSizeMake(29, 29);

		UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	    	[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/phone.png"] drawInRect:CGRectMake(0, 0, size.width, size.height)];
	    	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();    
    	UIGraphicsEndImageContext();

		[self setGrabberViewImage:image];
	}
   	
   	else {
   		%orig;
   	}
}

- (void)setGrabberViewImage:(UIImage *)image {
	if (ALGrabbers && [[MSHookIvar<SBApplication *>(self, "_targetApp") bundleIdentifier] isEqual:@"com.apple.camera"]) {
		CGSize size = CGSizeMake(29, 29);

		UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	    	[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/camera.png"] drawInRect:CGRectMake(0, 0, size.width, size.height)];
	    	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();    
    	UIGraphicsEndImageContext();

		%orig(image);
	}

	else {
		%orig;
	}
}
%end

%hook SBSlideUpAppGrabberView
- (void)layoutSubviews {
	%orig;

	if (ALGrabbers) {
		MSHookIvar<UIView *>(self, "_tintView").backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
	}
}
%end

%hook SBUIPasscodeLockViewWithKeypad
- (void)layoutSubviews {
	%orig;

	if (ALPushDownPasscode) {
		MSHookIvar<UILabel *>(self, "_statusTitleView").hidden = YES;
		MSHookIvar<UILabel *>(self, "_statusSubtitleView").hidden = YES;
	}
}

- (void)setCustomBackgroundColor:(UIColor *)arg1 {
	if (ALPasscodeBackground) {
		%orig([UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:0.85]);
	}

	else {
		%orig;
	}
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
	if (ALPasscodeBackground) {
		%orig(1);
	}

	else {
		%orig;
	}
}

- (void)passcodeLockNumberPad:(id)arg1 keyDown:(SBPasscodeNumberPadButton *)arg2 {
	if([arg2 character] == 1111) {
		if ([self passcode].length == 0) {
			[self passcodeLockNumberPadCancelButtonHit:nil];
		}
		else {
			[self passcodeLockNumberPadBackspaceButtonHit:nil];
		}
 	}

 	else if ([arg2 character] == 911) {
		[self passcodeLockNumberPadEmergencyCallButtonHit:nil];
 	}

 	else {
 		%orig;
 	}
}
%end

%hook SBUIPasscodeLockViewSimpleFixedDigitKeypad
- (CGFloat)_numberPadOffsetFromTopOfScreen {
	if (ALPushDownPasscode) {
		return [[UIScreen mainScreen] bounds].size.height - [MSHookIvar<TPNumberPad *>(MSHookIvar<UIView *>(self, "_numberPad"), "_numberPad") intrinsicContentSize].height;
	}

	else {
		return %orig;
	}
}

- (CGFloat)_entryFieldBottomYDistanceFromNumberPadTopButton {
	if (ALPushDownPasscode) {
		return [MSHookIvar<SBUIPasscodeEntryField *>(self, "_entryField") _viewSize].height;
	}

	else {
		return %orig;
	}
}
%end

%hook SBUIPasscodeLockNumberPad
- (void)setShowsEmergencyCallButton:(BOOL)arg1 {
	if (ALPasscodeExtraButtons) {
		%orig(NO);

		MSHookIvar<UIButton *>(self, "_emergencyCallButton").alpha = 0;
		MSHookIvar<UIButton *>(self, "_cancelButton").alpha = 0;
		MSHookIvar<UIButton *>(self, "_backspaceButton").alpha = 0;
	}

	else {
		%orig;
	}
}
%end

%hook TPNumberPad
- (id)initWithButtons:(NSArray *)buttons {
	NSMutableArray *newButtons = [buttons mutableCopy];

	if (ALPasscodeExtraButtons) {
		[newButtons replaceObjectAtIndex:9 withObject:[[%c(SBPasscodeNumberPadButton) alloc] initForCharacter:911]];
		[newButtons replaceObjectAtIndex:11 withObject:[[%c(SBPasscodeNumberPadButton) alloc] initForCharacter:1111]];
	}
			
	return %orig(newButtons);
}
%end

%hook TPNumberPadButton
+ (id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3 {
	return [self modifyImage:%orig forNumber:arg1];
}

%new
+ (UIImage *)modifyImage:(UIImage *)originalImage forNumber:(unsigned)number {
	CGSize size = CGSizeMake(29, 29);

	if (number == 911) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	    	[[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/emergency.png"] _flatImageWithColor:[UIColor whiteColor]] drawInRect:CGRectMake(0, 0, size.width, size.height)];
	    	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();

    	return image;
	}

	else if (number == 1111) {
		UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	    	[[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/ALTweakImages/backspace.png"] _flatImageWithColor:[UIColor whiteColor]] drawInRect:CGRectMake(0, 0, size.width, size.height)];
	    	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();

    	return image;
	}

	else {
		return originalImage;
	}
}

- (void)layoutSubviews {
	%orig;

	if (ALPasscodeButtons) {
		[[self revealingRingView] setCornerRadius:0];
		[[self revealingRingView] setDefaultRingStrokeWidth:0];
	}
}

- (void)setHighlighted:(BOOL)arg1 {
	if (ALPasscodeButtons) {
		%orig(NO);
		
		CALayer *glyphLayer = MSHookIvar<CALayer *>(self, "_glyphLayer");

		if (arg1) {
			[UIView animateWithDuration:0.1 animations:^{
		        glyphLayer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
		    }
		    completion:^(BOOL finished) {
		    
		    }];
		}

		else {
			[UIView animateWithDuration:0.1 animations:^{
		        glyphLayer.transform = CATransform3DMakeScale(1, 1, 1);
		    }
		    completion:^(BOOL finished) {
		    
		    }];
		}
	}

	else {
		%orig;
	}
}
%end

static void loadPrefs() {
	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tweaksbylogan.androlock.plist"];

	ALEnabled = [prefs objectForKey:@"ALEnabled"] ? [[prefs objectForKey:@"ALEnabled"] boolValue] : YES;
	ALNotifications = [prefs objectForKey:@"ALNotifications"] ? [[prefs objectForKey:@"ALNotifications"] boolValue] : YES;
	ALMiniplayer = [prefs objectForKey:@"ALMiniplayer"] ? [[prefs objectForKey:@"ALMiniplayer"] boolValue] : YES;
	ALUnlock = [prefs objectForKey:@"ALUnlock"] ? [[prefs objectForKey:@"ALUnlock"] boolValue] : YES;
	ALGrabbers = [prefs objectForKey:@"ALGrabbers"] ? [[prefs objectForKey:@"ALGrabbers"] boolValue] : YES;
	ALPushDownDate = [prefs objectForKey:@"ALPushDownDate"] ? [[prefs objectForKey:@"ALPushDownDate"] boolValue] : YES;
	ALPasscodeBackground = [prefs objectForKey:@"ALPasscodeBackground"] ? [[prefs objectForKey:@"ALPasscodeBackground"] boolValue] : YES;
	ALPushDownPasscode = [prefs objectForKey:@"ALPushDownPasscode"] ? [[prefs objectForKey:@"ALPushDownPasscode"] boolValue] : YES;
	ALPasscodeButtons = [prefs objectForKey:@"ALPasscodeButtons"] ? [[prefs objectForKey:@"ALPasscodeButtons"] boolValue] : YES;
	ALPasscodeExtraButtons = [prefs objectForKey:@"ALPasscodeExtraButtons"] ? [[prefs objectForKey:@"ALPasscodeExtraButtons"] boolValue] : YES;
	ALHideExtraViews = [prefs objectForKey:@"ALHideExtraViews"] ? [[prefs objectForKey:@"ALHideExtraViews"] boolValue] : YES;
}

static void respring() {
	[[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

%ctor {
	loadPrefs();

	if (ALEnabled) {
		%init;
	}

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.tweaksbylogan.androlock/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.tweaksbylogan.androlock/respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}