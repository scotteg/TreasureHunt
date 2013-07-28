
#import "SharedMapsViewController.h"
#import "DataModel.h"
#import "MapDetailViewController.h"

@interface SharedMapsViewController () <UIAlertViewDelegate, UISearchDisplayDelegate>

@end

@implementation SharedMapsViewController
{
	NSArray *_searchResults;
	UIView *_swipeMenuView;
	UITableViewCell *_cellForSwipe;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		#if CUSTOM_APPEARANCE
		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"SharedMapsBarIcon-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"SharedMapsBarIcon-Unselected"]];
		#endif
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// This is only a sample project but in a typical app of this kind, you'd
	// have a pull-to-refresh control that gets used to download an updated
	// list of items from the server.
	[self.refreshControl addTarget:self action:@selector(downloadNewMaps) forControlEvents:UIControlEventValueChanged];

	// Add two swipe gesture recognizers to the view. A swipe to the right will
	// show the special swipe menu; a swipe to the left closes it.
	UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
	swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.tableView addGestureRecognizer:swipeRightGestureRecognizer];

	UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
	swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.tableView addGestureRecognizer:swipeLeftGestureRecognizer];

	#if CUSTOM_APPEARANCE
	UIImageView *tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBackground"]];
	tableImageView.contentMode = UIViewContentModeBottom;
	self.tableView.backgroundView = tableImageView;
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	// Put a background image behind the refresh control.
	UIImageView *refreshImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBackground"]];
	CGRect frame = self.tableView.bounds;
	frame.origin.y = -frame.size.height;
	refreshImageView.frame = frame;
	[self.tableView insertSubview:refreshImageView atIndex:0];

	// This hides a gray line that otherwise appears on top of the search bar.
	self.searchDisplayController.searchBar.barStyle = UIBarStyleBlackTranslucent;
	#endif
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [_searchResults count];
	} else {
		#if CUSTOM_APPEARANCE
		return [self.dataModel.allMaps count] + 1;
		#else
		return [self.dataModel.allMaps count];
		#endif
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		static NSString *CellIdentifier = @"SearchCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

		TreasureMap *map = _searchResults[indexPath.row];
		cell.textLabel.text = map.name;

		return cell;
	}

#if CUSTOM_APPEARANCE
	else if (indexPath.row == (NSInteger)[_dataModel.allMaps count]) {
		// Add a torn piece of paper to the bottom of the table. This is a new
		// cell that just shows an image; it does nothing else.
	
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FooterCell"];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FooterCell"];
			
			UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableFooter"]];
			[cell.contentView addSubview:imageView];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return cell;
	}
#endif

	else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];

		TreasureMap *map = _dataModel.allMaps[indexPath.row];
		cell.textLabel.text = map.name;
		cell.detailTextLabel.text = map.sharedBy;
		cell.imageView.image = map.thumbnail;

		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// The storyboard has a ShowMap segue that is already connected to the
	// regular cells. But the search's table view uses different cells, so
	// for those we need to trigger the segue manually.

	if (tableView == self.searchDisplayController.searchResultsTableView) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[self performSegueWithIdentifier:@"ShowMap" sender:cell];
	} else {
		[self hideSwipeMenuAnimated];
	}
}

#if CUSTOM_APPEARANCE
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == (NSInteger)[_dataModel.allMaps count]) {
		return nil;
	} else {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return;
	}

	if (indexPath.row == (NSInteger)[_dataModel.allMaps count]) {
		return;
	}

	if (indexPath.row % 2 == 0) {
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellBackground-Even"]];
	} else {
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellBackground-Odd"]];
	}

	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellSelection"]];
	cell.backgroundColor = [UIColor clearColor];
}
#endif

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowMap"]) {
		MapDetailViewController *controller = segue.destinationViewController;
		controller.dataModel = self.dataModel;

		// Is this a segue from the search results table?
		if ([sender isDescendantOfView:self.searchDisplayController.searchResultsTableView]) {
			NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
			TreasureMap *map = _searchResults[indexPath.row];
			controller.map = map;
		} else {
			NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
			TreasureMap *map = self.dataModel.allMaps[indexPath.row];
			controller.map = map;
		}
	}
}

#pragma mark - Pull-to-Refresh

- (void)downloadNewMaps
{
	// To keep this app simple, it doesn't do any actual networking. But to
	// make the refresh control feel right we can sleep for 2 seconds.

	[self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
}

#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	_searchResults = [self.dataModel filterMaps:searchString];
	return YES;
}

#pragma mark - Swiping

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	// Hide the swipe menu once the user begins scrolling the table view.
	[self hideSwipeMenuAnimated];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
	// Ignore the swipe if the user is currently searching.
	if (self.searchDisplayController.active) {
		return;
	}

	if (recognizer.state == UIGestureRecognizerStateEnded) {
		// Get the cell in which the user swiped.
		CGPoint location = [recognizer locationInView:self.tableView];
		NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

		#if CUSTOM_APPEARANCE
		if (indexPath.row == (NSInteger)[_dataModel.allMaps count]) {
			return;
		}
		#endif

		// Ignore if this cell is already showing the menu.
		if (_cellForSwipe == cell) {
			return;
		}

		// If another cell is still showing the menu, then restore that cell.
		if (_cellForSwipe != nil) {
			CGRect cellFrame = _cellForSwipe.frame;
			_cellForSwipe.frame = CGRectMake(0.0f, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
			[self.swipeMenuView removeFromSuperview];
		}

		// Place the menu view below this cell.
		_cellForSwipe = cell;
		self.swipeMenuView.frame = _cellForSwipe.frame;
		[self.tableView insertSubview:self.swipeMenuView belowSubview:_cellForSwipe];

		// And animate the cell away to reveal the menu.
		[UIView animateWithDuration:0.2 animations:^{
			CGRect newFrame = _cellForSwipe.frame;
			newFrame.origin.x = newFrame.size.width;
			_cellForSwipe.frame = newFrame;
		}];
	}
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		[self hideSwipeMenuAnimated];
	}
}

- (void)hideSwipeMenuAnimated
{
	if (_cellForSwipe != nil) {
	
		[UIView animateWithDuration:0.1 animations:^{
			CGRect newFrame = _cellForSwipe.frame;
			newFrame.origin.x = 0.0f;
			_cellForSwipe.frame = newFrame;

		} completion:^(BOOL finished) {
			[self.swipeMenuView removeFromSuperview];
			_cellForSwipe = nil;
		}];
	}
}

- (UIView *)swipeMenuView
{
	// This lazily creates the menu view that appears behind the cell.

	if (_swipeMenuView == nil) {
		_swipeMenuView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
		_swipeMenuView.backgroundColor = [UIColor blackColor];

		#if CUSTOM_APPEARANCE
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwipeBackground"]];
		[_swipeMenuView addSubview:imageView];
		#endif

		UIButton *claimButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[claimButton setTitle:@"Claim Treasure" forState:UIControlStateNormal];
		[claimButton addTarget:self action:@selector(claimTreasure) forControlEvents:UIControlEventTouchUpInside];
		[claimButton sizeToFit];
		claimButton.center = CGPointMake(160.5f, 40.5f);
		[_swipeMenuView addSubview:claimButton];

		#if CUSTOM_APPEARANCE
		[claimButton setBackgroundImage:[UIImage imageNamed:@"SwipeButton"] forState:UIControlStateNormal];
		[claimButton setTitleColor:DarkTextColor forState:UIControlStateNormal];
		[claimButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.25f] forState:UIControlStateNormal];
		[claimButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
		claimButton.bounds = CGRectMake(0.0f, 0.0f, 173.0f, 39.0f);
		claimButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		claimButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		claimButton.titleEdgeInsets = UIEdgeInsetsMake(-2.0f, 40.0f, 0.0f, 0.0f);
		#endif
	}
	return _swipeMenuView;
}

- (void)claimTreasure
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Claim Treasure" message:@"Fill in your email address to verify your claim with the map's creator." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Make Me Rich!", nil];

	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// Nothing actually happens when you claim the treasure. If this were a
	// real app, doing this would send a message to the server and then let the
	// owner of the treasure map know through a push notification or something.

	[self hideSwipeMenuAnimated];
}

@end
