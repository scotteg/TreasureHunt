
// This is a child view controller that is used by MapDetailViewController
// to show the photo of the treasure map.
//
@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImage *photo;

@end
