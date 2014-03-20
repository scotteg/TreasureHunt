
#import "CluesViewController.h"
#import "Clue.h"

@implementation CluesViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
  
  // Content is provided by child VCs (it doesn't have a scroll view), so adjust insets manually
  self.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 44.0f, 0.0f);

	#if CUSTOM_APPEARANCE
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBackground"]];
	self.tableView.separatorColor = SeparatorColor;
	
	UIView *hideSeparators = [[UIView alloc] initWithFrame:CGRectZero];
	hideSeparators.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = hideSeparators;
	#endif
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.clues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClueCell" forIndexPath:indexPath];

	[self configureCell:cell forIndexPath:indexPath];

	return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	Clue *clue = self.clues[indexPath.row];

	UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
	textLabel.text = clue.text;
  
	UILabel *usernameLabel = (UILabel *)[cell viewWithTag:101];
	usernameLabel.text = clue.sharedBy;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static UITableViewCell *cell;
  
  if (!cell) {
  cell = [tableView dequeueReusableCellWithIdentifier:@"ClueCell"];
  }
  
  [self configureCell:cell forIndexPath:indexPath];
  return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#if CUSTOM_APPEARANCE
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellSelection"]];
	cell.backgroundColor = TableColor;

	UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
	textLabel.textColor = DarkTextColor;

	UILabel *usernameLabel = (UILabel *)[cell viewWithTag:101];
	usernameLabel.textColor = LightTextColor;
}
#endif

@end
