
#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation DatePickerViewController

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	#if CUSTOM_APPEARANCE
	// Undo any of the appearance customizations for this toolbar and button.

	[self.toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];

	[self.doneButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[self.doneButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
	[self.doneButton setTitleTextAttributes:@{} forState:UIControlStateNormal];
	#endif
}

- (void)setDate:(NSDate *)date
{
	[self.datePicker setDate:date animated:NO];
}

- (NSDate *)date
{
	return self.datePicker.date;
}

@end
