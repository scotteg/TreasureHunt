
#import "AppDelegate.h"
#import "DataModel.h"
#import "MyMapsViewController.h"
#import "SharedMapsViewController.h"

@implementation AppDelegate
{
	DataModel *_dataModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	#if CUSTOM_APPEARANCE
	[self customizeAppearance];
	#endif

	// The app delegate creates and owns the data model. It passes the same
	// data model object to all the top-level view controllers that need to
	// access the data.
	_dataModel = [[DataModel alloc] init];

	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

	// The view controller for the "My Maps" tab.
	UINavigationController *navigationController = tabBarController.viewControllers[0];
	MyMapsViewController *myMapsViewController = navigationController.viewControllers[0];
	myMapsViewController.dataModel = _dataModel;

	// The view controller for the "Shared Maps" tab.
	navigationController = tabBarController.viewControllers[1];
	SharedMapsViewController *sharedMapsViewController = navigationController.viewControllers[0];
	sharedMapsViewController.dataModel = _dataModel;

	return YES;
}

#if CUSTOM_APPEARANCE

UIColor *DarkTextColor;
UIColor *LightTextColor;
UIColor *SeparatorColor;
UIColor *TableColor;

- (void)customizeAppearance
{
	// Colors
	
	DarkTextColor = [UIColor colorWithRed:59/255.0f green:29/255.0f blue:19/255.0f alpha:1.0f];
	LightTextColor = [UIColor colorWithRed:195/255.0f green:143/255.0f blue:89/255.0f alpha:1.0f];
	SeparatorColor = [UIColor colorWithRed:209/255.0f green:184/255.0f blue:157/255.0f alpha:1.0f];
	TableColor = [UIColor colorWithRed:240/255.0f green:227/255.0f blue:213/255.0f alpha:1.0f];

	// Navigation Bar
	
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBarBackground-Portrait"] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBarBackground-Landscape"] forBarMetrics:UIBarMetricsLandscapePhone];

	[[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"ShadowDown"]];
	
	[[UINavigationBar appearance] setTitleTextAttributes:@{
		UITextAttributeTextColor : [UIColor whiteColor],
		UITextAttributeTextShadowColor : [UIColor blackColor],
		UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)],
	}];

	// Buttons for Navigation Bar

	UIImage *barButtonPortrait = [[UIImage imageNamed:@"BarButtonItem-Portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)];
	UIImage *barButtonLandscape = [[UIImage imageNamed:@"BarButtonItem-Landscape"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)];

	[[UIBarButtonItem appearance] setBackgroundImage:barButtonPortrait forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackgroundImage:barButtonLandscape forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
 
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{
		UITextAttributeTextColor : [UIColor whiteColor],
		UITextAttributeTextShadowColor : [UIColor blackColor],
		UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)],
	}
	forState:UIControlStateNormal];

	UIImage *backButtonPortrait = [[UIImage imageNamed:@"BackButton-Portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 18.0f, 0.0f, 7.0f)];
	UIImage *backButtonLandscape = [[UIImage imageNamed:@"BackButton-Landscape"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 18.0f, 0.0f, 7.0f)];

	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonPortrait forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonLandscape forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];

	// Tab Bar

	[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBarBackground"]];
	[[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"ShadowUp"]];
	[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarSelection"]];

	[[UITabBarItem appearance] setTitleTextAttributes:@{
		UITextAttributeTextColor : [UIColor colorWithRed:206/255.0f green:161/255.0f blue:109/255.0f alpha:1.0f],
		UITextAttributeTextShadowColor : [UIColor colorWithWhite:0.0f alpha:0.5f],
		UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
	}
	forState:UIControlStateNormal];

	[[UITabBarItem appearance] setTitleTextAttributes:@{
		UITextAttributeTextColor : [UIColor colorWithRed:219/255.0f green:202/255.0f blue:184/255.0f alpha:1.0f],
		UITextAttributeTextShadowColor : [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f],
		UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)],
	}
	forState:UIControlStateSelected];
	
	// Toolbar
	
	[[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"ToolbarBackground"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	[[UIToolbar appearance] setShadowImage:[UIImage imageNamed:@"ShadowUp"] forToolbarPosition:UIToolbarPositionBottom];
	
	// Search Bar

	[[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"SearchBarBackground"]];
	
	// Segmented Control
	
	UIImage *segmentImage = [[UIImage imageNamed:@"SegmentedControl"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f)];

	[[UISegmentedControl appearance] setBackgroundImage:segmentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

	[[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"SegmentedControlDivider"]
		forLeftSegmentState:UIControlStateNormal
		rightSegmentState:UIControlStateNormal
		barMetrics:UIBarMetricsDefault];
}

#endif

@end
