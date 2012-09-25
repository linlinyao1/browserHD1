//
//  RCSearchEngineSwitchViewController.m
//  browserHD
//
//  Created by imac on 12-8-20.
//  Copyright (c) 2012年 2345. All rights reserved.
//




#import "RCSearchEngineSwitchViewController.h"






@interface RCSearchEngineSwitchViewController ()
//@property (nonatomic,strong) NSMutableArray *listContent;
@end

@implementation RCSearchEngineSwitchViewController
//@synthesize listContent = _listContent;
@synthesize engineDelegate = _engineDelegate;



+(NSString*)nameForSEtype:(SETypes)type
{
    NSString *name = nil;
    switch (type) {
        case SETypeBaidu:
            name = @"百度";
            break;
        case SETypeGoogle:
            name = @"谷歌";
            break;
        case SETypeSoso:
            name = @"搜搜";
            break;
        case SETypeSougou:
            name = @"搜狗";
            break;
        case SETypeTaobao:
            name = @"淘宝";
            break;
    }
    
    return name;
}

+(UIImage*)imageForSEtype:(SETypes)type isFull:(BOOL)full
{
    NSString *imgName = nil;
    switch (type) {
        case SETypeBaidu:
            imgName = @"baidu";
            break;
        case SETypeGoogle:
            imgName = @"google";
            break;
        case SETypeSoso:
            imgName = @"soso";
            break;
        case SETypeSougou:
            imgName = @"sougou";
            break;
        case SETypeTaobao:
            imgName = @"taobao";
            break;
    }
    if (full) {
        imgName = [NSString stringWithFormat:@"%@_full",imgName];
    }
    
    return [UIImage imageNamed:imgName];
}

//百度：http://www.baidu.com/s?word=关键字&tn=site888_pg&ct=&lm=-1&kw=&ch=1
//谷歌：https://www.google.com.hk/search?q=关键字&client=aff-9991&ie=GB2312&oe=utf8&hl=zh-CN&newwindow=1&channel=searchbutton
//搜搜：http://www.soso.com/q?w=关键字
//搜狗：http://www.sogou.com/web?query=关键字  // http://www.sogou.com/sogou?query=%E5%95%8A%E9%A3%92%E9%A3%92&_ast=1282184986&w=01019900&p=40040100&pid=AQlDA&nsns=sogou
//淘宝：http://s.taobao.com/search?q=关键字
+(NSURL *)searchUrlForSEtype:(SETypes)type keyWord:(NSString *)key
{ 
    NSString *url = nil;
    switch (type) {
        case SETypeBaidu:
            url = [NSString stringWithFormat:@"http://www.baidu.com/s?word=%@&tn=site888_pg&ct=&lm=-1&kw=&ch=1",key];
            break;
        case SETypeGoogle:
            url = [NSString stringWithFormat:@"https://www.google.com.hk/search?q=%@&client=aff-9991",key];
            break;
        case SETypeSoso:
            url = [NSString stringWithFormat:@"http://www.soso.com/q?w=%@",key];
            break;
        case SETypeSougou:
//            url = [NSString stringWithFormat:@"http://www.sogou.com/web?query=%@",key];
            url = [NSString stringWithFormat:@"http://www.sogou.com/sogou?query=%@&_ast=1282184986&w=01019900&p=40040100&pid=AQlDA&nsns=sogou",key];
            break;
        case SETypeTaobao:
            url = [NSString stringWithFormat:@"http://s.taobao.com/search?q=%@",key];
            break;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:url];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        self.listContent = [NSMutableArray arrayWithObjects:@"百度",@"谷歌",@"搜搜",@"搜狗",@"淘宝" nil];//,@"宜搜",@"易查"
        self.contentSizeForViewInPopover = CGSizeMake(300, 220);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor clearColor];
    
    self.title = @"选择搜索引擎";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  SETypeCount;//self.listContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [RCSearchEngineSwitchViewController nameForSEtype:indexPath.row];
    cell.imageView.image = [RCSearchEngineSwitchViewController imageForSEtype:indexPath.row isFull:NO];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"] intValue] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"searchEngine"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.engineDelegate respondsToSelector:@selector(updateSearchEngine)]) {
        [self.engineDelegate updateSearchEngine];
    }
}

@end
