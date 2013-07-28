
#import "CluesViewController.h"
#import "Clue.h"

@implementation CluesViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

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

	CGSize size = [self sizeForText:clue.text];
	textLabel.frame = CGRectMake(20.0f, 10.0f, size.width, size.height);

	UILabel *usernameLabel = (UILabel *)[cell viewWithTag:101];
	usernameLabel.text = clue.sharedBy;
	usernameLabel.frame = CGRectMake(20.0f, 10.0f + size.height + 10.0f, 280.0f, 18.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Clue *clue = self.clues[indexPath.row];
	CGSize size = [self sizeForText:clue.text];
	CGFloat height = 10.0f + size.height + 10.0f + 18.0f + 10.0f;
	return height;
}

- (CGSize)sizeForText:(NSString *)text
{
	UIFont *font = [UIFont systemFontOfSize:17.0f];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(280.0f, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
	return size;
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
