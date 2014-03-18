
#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Set the content size to the scroll view to the dimensions of the image.
	self.scrollView.contentSize = self.photo.size;
	
	// Center the scroll view on the image.
	self.scrollView.contentOffset = CGPointMake(
		(self.photo.size.width - self.view.bounds.size.width)/2.0f,
		(self.photo.size.height - self.view.bounds.size.height)/2.0f);

	// The image view is always the same size as the content area of the scroll view.
	self.imageView.frame = (CGRect){ .origin = CGPointZero, .size = self.photo.size };
	self.imageView.image = self.photo;
}

@end
