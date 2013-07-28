
// A popup that lets the user choose a date.
//
@interface DatePickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, copy) NSDate *date;

@end
