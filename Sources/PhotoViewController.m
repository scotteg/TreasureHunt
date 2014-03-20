
#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Center the scroll view on the image.
	self.scrollView.contentOffset = CGPointMake(
		(self.photo.size.width - self.view.bounds.size.width)/2.0f,
		(self.photo.size.height - self.view.bounds.size.height)/2.0f);

	self.imageView.image = self.photo;
}

@end
