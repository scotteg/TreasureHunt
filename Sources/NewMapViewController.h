
// The form that lets you add new maps and edit existing ones.
//
@interface NewMapViewController : UITableViewController 

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *instructions;
@property (nonatomic, copy) NSString *awardType;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) UIImage *photo;

@end
