
// This is the "clue sheet" that lets users add clues or other comments to a
// treasure map.
//
@interface NewClueViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
