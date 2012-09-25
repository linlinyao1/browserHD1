//
//  RCConfigueNavIconsViewController.m
//  browserHD
//
//  Created by imac on 12-8-20.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCConfigueNavIconsViewController.h"
#import "JSONKit.h"
#import "UIImage+Thumbnail.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+HexValue.h"
#import "RCRecordData.h"


//@interface UITableViewCell (RCConfigueNavIconsViewController)
//
//@end
//
//@implementation UITableViewCell (RCConfigueNavIconsViewController)
//
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(0, 0, 30, 30);
//}
//
//@end


@interface RCConfigueNavIconsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIView *navBar;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *leftTable;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *rightTable;

@property (nonatomic,strong) NSMutableArray *leftContentList;
@property (nonatomic,strong) NSMutableArray *rightContentList;

@property (nonatomic,strong) NSArray *contentList;
@property (nonatomic,strong) NSMutableArray *quickLinks;

@property (nonatomic,strong) UITextField *titleInput;
@property (nonatomic,strong) UITextField *urlInput;
@property (strong, nonatomic) IBOutlet UIView *keyboardAccessory;

@end

@implementation RCConfigueNavIconsViewController
@synthesize navBar;
@synthesize leftTable;
@synthesize rightTable;
@synthesize leftContentList = _leftContentList;
@synthesize rightContentList = _rightContentList;
@synthesize contentList = _contentList;
@synthesize quickLinks = _quickLinks;
@synthesize mainVC = _mainVC;
@synthesize titleInput = _titleInput;
@synthesize urlInput = _urlInput;
@synthesize keyboardAccessory = _keyboardAccessory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"configure_NavBG"]];
    
    self.leftTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"configure_leftBG"]];
    self.rightTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"configure_rightBG"]];

    self.leftContentList = [NSMutableArray array];
    self.rightContentList = [NSMutableArray array];
    [self reloadData];
    

}



- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setLeftTable:nil];
    [self setRightTable:nil];
    [self setKeyboardAccessory:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (IBAction)finishConfigaration {    
    [self dismissModalViewControllerAnimated:YES];
    [self.mainVC.homePage reloadData];
}


-(void)reloadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *quickLinkArray = [QuickLinkDataBase sharedQuickLinkDB];
        if (quickLinkArray) {
            self.contentList = quickLinkArray;
            for (NSDictionary *quickLinkDic in quickLinkArray) {
                [self.leftContentList addObject:[quickLinkDic objectForKey:QuickLink_Title]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.leftTable reloadData];
                [self.rightTable reloadData];
                NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.leftTable selectRowAtIndexPath:indexPathZero animated:NO scrollPosition:UITableViewScrollPositionTop];
                [self tableView:self.leftTable didSelectRowAtIndexPath:indexPathZero];
            });
            self.quickLinks = [RCRecordData recordDataWithKey:RCRD_QUICKLINK];
        }
        
    });
    
//    NSArray *quickLinkArray = [QuickLinkDataBase sharedQuickLinkDB];
//    if (quickLinkArray) {
//        self.contentList = quickLinkArray;
//        for (NSDictionary *quickLinkDic in quickLinkArray) {
//            [self.leftContentList addObject:[quickLinkDic objectForKey:QuickLink_Title]];
//        }
//        [self.leftTable reloadData];
//        [self.rightTable reloadData];
//        NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.leftTable selectRowAtIndexPath:indexPathZero animated:NO scrollPosition:UITableViewScrollPositionTop];
//        [self tableView:self.leftTable didSelectRowAtIndexPath:indexPathZero];
//    }
//    
//    self.quickLinks = [RCRecordData recordDataWithKey:RCRD_QUICKLINK];
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.leftTable) {
        count = self.leftContentList.count+1;
    }
    if (tableView == self.rightTable) {
        count = self.rightContentList.count;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        static NSString* leftTableCellIdentifier = @"left cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:leftTableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftTableCellIdentifier];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"configure_leftSelected"]];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"configure_leftStrips"]];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        
        if (indexPath.row == self.leftContentList.count) {
            cell.textLabel.text = @"手动添加";
        }else{
            cell.textLabel.text = [self.leftContentList objectAtIndex:indexPath.row];
        }

        return cell;
    }
    if (tableView == self.rightTable) {
        
        if (self.rightContentList.count == 3) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"manul cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"manul cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (indexPath.row != 2) {
                UITextField * urlInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 49, 329, 39)];
                if (indexPath.row == 0) {
                    urlInput.center = CGPointMake(tableView.bounds.size.width/2, urlInput.center.y);
                }else{
                    urlInput.center = CGPointMake(tableView.bounds.size.width/2, urlInput.center.y-15);
                }
                urlInput.borderStyle = UITextBorderStyleRoundedRect;
                urlInput.clearButtonMode = UITextFieldViewModeWhileEditing;
                urlInput.placeholder = [self.rightContentList objectAtIndex:indexPath.row];
                urlInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                urlInput.font = [UIFont systemFontOfSize:20];
                [cell addSubview:urlInput];
                if (indexPath.row == 0) {
                    self.titleInput = urlInput;
                }else{
                    self.urlInput = urlInput;
                    self.keyboardAccessory.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyBoardAccessoryBG"]];
                    urlInput.inputAccessoryView = self.keyboardAccessory;
                }
                
            }else{
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"quicklink_manualButton_normal"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"quicklink_manualButton_hite"] forState:UIControlStateHighlighted];
                [button setTitle:@"添加" forState:UIControlStateNormal];
                button.frame = CGRectMake(0, 0, 202, 39);
                button.center = CGPointMake(tableView.bounds.size.width/2, tableView.rowHeight/2-15);
                [button addTarget:self action:@selector(handleManualButtonTap:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
            return cell;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        static NSString* rightTableCellIdentifier = @"right cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:rightTableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rightTableCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"configure_rightStrips"]];
        
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            actionButton.frame = CGRectMake(0, 0, 77, 37);
            [actionButton addTarget:self action:@selector(handleActionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_add"] forState:UIControlStateNormal];
//            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_cancle"] forState:UIControlStateSelected];
            cell.accessoryView = actionButton;
            
            cell.imageView.layer.borderColor = [UIColor colorWithHexValue:@"acacac"].CGColor;
            cell.imageView.layer.borderWidth = 1;
            
        }
        
        
        
        NSDictionary *urlDic = [self.rightContentList objectAtIndex:indexPath.row];
        cell.textLabel.text = [urlDic objectForKey:URL_Title];
        cell.imageView.image = [[UIImage imageNamed:[urlDic objectForKey:URL_Icon]] makeThumbnailOfSize:CGSizeMake(90, 56)];
        cell.detailTextLabel.text = [urlDic objectForKey:URL_Intro];

        
        UIButton *actionButton = (UIButton*)cell.accessoryView;
        BOOL selected = NO;
        for (BookmarkObject* quicklink in self.quickLinks) {
            if ([quicklink.url.absoluteString isEqualToString:[urlDic objectForKey:URL_Link]]) {
                selected = YES;
                break;
            }
        }
        if (selected) {
            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_cancle"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_cancle_hite"] forState:UIControlStateHighlighted];

        }else{
            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_add"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"configure_add_hite"] forState:UIControlStateHighlighted];

        }

        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        if (indexPath.row == self.leftContentList.count) {
            self.rightContentList = [NSMutableArray arrayWithObjects:@"标题",@"网址",@"确认", nil];
            [self.rightTable reloadData];
            return;
        }
        
        NSDictionary* quickLinkDic = [self.contentList objectAtIndex:indexPath.row];
        self.rightContentList = [quickLinkDic objectForKey:QuickLink_Content];
        [self.rightTable reloadData];
        [self.rightTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:NO];
    }
}


- (void)handleActionButtonTap:(UIButton *)sender
{
    CGPoint location = [self.rightTable convertPoint:sender.frame.origin fromView:sender.superview];
    NSIndexPath* indexPath = [self.rightTable indexPathForRowAtPoint:location];
    NSDictionary *urlDic = [self.rightContentList objectAtIndex:indexPath.row];
    
    BOOL selected = NO;
    for (BookmarkObject* quicklink in self.quickLinks) {
        NSString *string = [urlDic objectForKey:URL_Link];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if ([quicklink.url.absoluteString isEqualToString:string]) {
            selected = YES;
            [self.quickLinks removeObject:quicklink];
            break;
        }
    }
    if (selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"configure_add"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"configure_add_hite"] forState:UIControlStateHighlighted];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"configure_cancle"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"configure_cancle_hite"] forState:UIControlStateHighlighted];
        
        NSString* url = [urlDic objectForKey:URL_Link];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self.quickLinks addObject:[[BookmarkObject alloc] initWithName:[urlDic objectForKey:URL_Title] andURL:[NSURL URLWithString:url]]];
    }
    
    [RCRecordData updateRecord:self.quickLinks ForKey:RCRD_QUICKLINK];
    
}


-(void)handleManualButtonTap:(UIButton*)sender
{
    if (!self.titleInput.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入快速链接的标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.urlInput.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入快速链接的网址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString* string = self.urlInput.text;
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:string];
    BOOL valid = NO;
    if (!url) {
        NSLog(@"invalid url");
    }else{
        if (!url.scheme.length) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:url.absoluteString]];
        }
        if (url.host.length) {
            NSString * regex        =  @"^([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";//@"^(\\w)+(\\.)+(\\w)+$";//
            NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([pred evaluateWithObject:url.host]) {
                NSLog(@"valid url");
                valid = YES;
            }else{
                NSLog(@"invalid url");
            }
        }
    }
    if (valid) {
        BOOL exist = NO;
        for (BookmarkObject* quicklink in self.quickLinks) {
            if ([quicklink.url.absoluteString isEqualToString:url.absoluteString]) {
                exist = YES;
                break;
            }
        }
        if (exist) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该快速链接已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }else{
            [self.quickLinks addObject:[[BookmarkObject alloc] initWithName:self.titleInput.text andURL:url]];
            [RCRecordData updateRecord:self.quickLinks ForKey:RCRD_QUICKLINK];
            self.urlInput.text = nil;
            self.titleInput.text = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
            
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入有效的网址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

- (IBAction)key:(UIButton*)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"www."] ||
        [sender.titleLabel.text isEqualToString:@"hd."]) {
        self.urlInput.text = [sender.titleLabel.text stringByAppendingString:self.urlInput.text];
    }else if ([sender.titleLabel.text isEqualToString:@".com"]||
              [sender.titleLabel.text isEqualToString:@".cn"]||
              [sender.titleLabel.text isEqualToString:@".net"]){
        self.urlInput.text = [self.urlInput.text stringByAppendingString:sender.titleLabel.text];
    }else if ([sender.titleLabel.text isEqualToString:@"清空"]){
        self.urlInput.text = nil;
    }
}





@end
