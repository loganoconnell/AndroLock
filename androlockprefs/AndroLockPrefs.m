#import "AndroLockPrefs.h"

@interface AndroLockListController: PSListController
- (void)respring;
- (void)followLogan;
@end

@implementation AndroLockListController
- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AndroLockPrefs" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/AndroLockTwitter.png"] style:UIBarButtonItemStyleDone target:self action:@selector(share:)], nil];
}

- (void)viewDidAppear:(BOOL)arg1 {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/AndroLockPrefs.png"]];
    imageView.frame = CGRectMake(0, 0, 29, 29);
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.navigationItem.titleView = imageView;

    [super viewDidAppear:arg1];
}

- (void)respring {
    [[[UIAlertView alloc] initWithTitle:@"Respring?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
}

- (void)followLogan {
	NSString *user = @"logandev22";

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	}
	
	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	}
}

- (void)share:(id)sender {
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setInitialText:@"#AndroLock - An Android-inspired lock screen! Developed by @logandev22"];
    
    [self.navigationController presentViewController:tweetComposeViewController animated:YES completion:^{
    	
    }];
}

- (void)alertView:(UIAlertView *)arg1 clickedButtonAtIndex:(NSInteger)arg2 {
	if (arg2 == 1) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.tweaksbylogan.androlock/respring"), NULL, NULL, YES);
    }
}
@end

@interface AndroLockSettingsController: PSListController
@end

@implementation AndroLockSettingsController
- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AndroLockSettings" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidAppear:(BOOL)arg1 {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/AndroLockSettings.png"]];
    imageView.frame = CGRectMake(0, 0, 29, 29);
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.navigationItem.titleView = imageView;

    [super viewDidAppear:arg1];
}
@end

@interface AndroLockSupportController : PSListController <MFMailComposeViewControllerDelegate> {
    MFMailComposeViewController *mailComposeViewController;
}
@end

@implementation AndroLockSupportController
- (id)specifiers {
	if ([MFMailComposeViewController canSendMail]) {
		mailComposeViewController = [[MFMailComposeViewController alloc] init];
	    mailComposeViewController.mailComposeDelegate = self;
	    [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:@"Logan O'Connell <logan.developeremail@gmail.com>", nil]];
	    [mailComposeViewController setSubject:[NSString stringWithFormat:@"AndroLock Support"]];
	    [mailComposeViewController setMessageBody:[NSString stringWithFormat:@"\n\n\nDevice: %@ on iOS %@", (NSString *)MGCopyAnswer(CFSTR("ProductType")), (NSString *)MGCopyAnswer(CFSTR("ProductVersion"))] isHTML:NO];

	    [self.navigationController presentViewController:mailComposeViewController animated:YES completion:^{

	    }];
	}

	else {
		[self.navigationController popViewControllerAnimated:YES];
	}

    return nil;
}

- (void)viewWillAppear:(BOOL)arg1 {
	[self.navigationItem setTitle:@""];

	[super viewWillAppear:arg1];
}

- (void)viewDidAppear:(BOOL)arg1 {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AndroLockPrefs.bundle/AndroLockSupport.png"]];
    imageView.frame = CGRectMake(0, 0, 29, 29);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;

    [super viewDidAppear:arg1];
}

- (void)mailComposeController:(MFMailComposeViewController *)arg1 didFinishWithResult:(id)arg2 error:(NSError *)arg3 {
    [arg1 dismissViewControllerAnimated:YES completion:^{

    }];

    [self.navigationController popViewControllerAnimated:YES];
}
@end

@interface AndroLockPrefsCustomCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *firstLabel;
	UILabel *secondLabel;
	UILabel *thirdLabel;
}
@end

@implementation AndroLockPrefsCustomCell
- (id)initWithSpecifier:(id)arg1 {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]) {
		firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, [[UIScreen mainScreen] bounds].size.width, 60)];
		[firstLabel setNumberOfLines:1];
		firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36];
		[firstLabel setText:@"AndroLock"];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		firstLabel.textColor = [UIColor blackColor];
		firstLabel.textAlignment = NSTextAlignmentCenter;
		[firstLabel startShimmering];
		[self addSubview:firstLabel];

		secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 60)];
		[secondLabel setNumberOfLines:1];
		secondLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[secondLabel setText:@"An Android-inspired lock screen!"];
		[secondLabel setBackgroundColor:[UIColor clearColor]];
		secondLabel.textColor = [UIColor grayColor];
		secondLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:secondLabel];

		thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 60)];
		[thirdLabel setNumberOfLines:1];
		thirdLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[thirdLabel setText:@"Created by Logan O’Connell"];
		[thirdLabel setBackgroundColor:[UIColor clearColor]];
		thirdLabel.textColor = [UIColor grayColor];
		thirdLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:thirdLabel];
	}
	
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 90;
}
@end

@interface AndroLockSettingsCustomCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *firstLabel;
}
@end

@implementation AndroLockSettingsCustomCell
- (id)initWithSpecifier:(id)arg1 {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]) {
		firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, [[UIScreen mainScreen] bounds].size.width, 60)];
		[firstLabel setNumberOfLines:1];
		firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36];
		[firstLabel setText:@"Settings"];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		firstLabel.textColor = [UIColor blackColor];
		firstLabel.textAlignment = NSTextAlignmentCenter;
		[firstLabel startShimmering];
		[self addSubview:firstLabel];
	}
	
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 60;
}
@end

@interface AndroLockCustomSwitchCell : PSSwitchTableCell
@end

@implementation AndroLockCustomSwitchCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
   	if (self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3]) {
        [[self control] setOnTintColor:[UIColor blackColor]];
    }
    
    return self;
}
@end


@interface AndroLockCustomSliderCell : PSSliderTableCell {
	UIButton *button;
	UIAlertView *alert;
    UIAlertView *errorAlert;
}
@end

@implementation AndroLockCustomSliderCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
    if (self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3]) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(presentAlert:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

    return self;
}

- (void)presentAlert:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please enter a value between %.1f and %.1f.", [[[self specifier] propertyForKey:@"min"] floatValue], [[[self specifier] propertyForKey:@"max"] floatValue]] message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000;

    [[alert textFieldAtIndex:0] setPlaceholder:[NSString stringWithFormat:@"%.1f", [[PSRootController readPreferenceValue:[self specifier]] floatValue]]];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];

    [alert show];

    [[alert textFieldAtIndex:0] becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)arg1 clickedButtonAtIndex:(NSInteger)arg2 {
    if (arg1.tag == 1000 && arg2 == 1) {
        CGFloat value = [[arg1 textFieldAtIndex:0].text floatValue];

        [[arg1 textFieldAtIndex:0] resignFirstResponder];

        if (value <= [[[self specifier] propertyForKey:@"max"] floatValue] && value >= [[[self specifier] propertyForKey:@"min"] floatValue]) {
            [PSRootController setPreferenceValue:[NSNumber numberWithInt:value] specifier:[self specifier]];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setValue:[NSNumber numberWithInt:value]];
        }

        else {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid value." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlert.tag = 1001;

            [errorAlert show];
        }
    }

    else if (arg1.tag == 1001) {
        [self presentAlert:nil];
    }
}
@end