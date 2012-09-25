//
//  RCUrlInputViewController.m
//  browserHD
//
//  Created by imac on 12-8-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCUrlInputViewController.h"
#import "JSONKit.h"
#import "RCRecordData.h"

#define JSON_KEY_TITLE @"urltitle"
#define JSON_KEY_LINK @"urllink"
#define JSON_KEY_ICON @"urlico"



@interface RCUrlInputViewController ()
@property (nonatomic,strong) NSMutableArray *listContent;
@end

@implementation RCUrlInputViewController
@synthesize listContent = _listContent;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listContent = [NSMutableArray arrayWithCapacity:1];
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
	return YES;
}


-(BOOL)checkTextPrefix:(NSString*)text
{
    if ([@"w" rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length||
        [@"ww" rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length||
        [@"www" rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length||
        [@"wwww." rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length) {
        return YES;
    }
    if ([@"h" rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length||
        [@"hd" rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length||
        [@"hd." rangeOfString:text options:NSAnchoredSearch|NSCaseInsensitiveSearch].length) {
        return YES;
    }
    
    return NO;
}

-(BOOL)checkTextSuffix:(NSString*)text
{
    if ([text rangeOfString:@".com" options:NSCaseInsensitiveSearch].length ||
        [text rangeOfString:@".cn" options:NSCaseInsensitiveSearch].length) {
        return YES;
    }
    
    return NO;
}


-(void)loadURLSuggestionWithText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];

        if (text.length) {
            if (![self checkTextSuffix:text]) {
                [tempArray addObject:[NSString stringWithFormat:@"%@.com",text]];
                [tempArray addObject:[NSString stringWithFormat:@"%@.cn",text]];
            }
            
            // history
            NSMutableArray* historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
            NSInteger count = tempArray.count;
            for (BookmarkObject* history in historyArray) {
                if ([history.url.absoluteString rangeOfString:text].length) {
                    [tempArray addObject:history];
                    count++;
                    if (count>=10) {
                        break;
                    }
                }
            }
        }
        

        
        
        
        //hot sites
        NSString *hotSitesString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hotSites" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        if (hotSitesString) {
            NSArray *hotSitesArray = [hotSitesString objectFromJSONString];
            [tempArray addObjectsFromArray:hotSitesArray];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listContent = tempArray;
            [self.tableView reloadData];
        }); 
    });
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.listContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    
    id contentObj = [self.listContent objectAtIndex:indexPath.row];
    if ([contentObj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = contentObj;
        cell.detailTextLabel.text = nil;
    }else if ([contentObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *hotsite = (NSDictionary *)contentObj;
        cell.textLabel.text = [hotsite objectForKey:JSON_KEY_TITLE];
        cell.detailTextLabel.text = [hotsite objectForKey:JSON_KEY_LINK];
    }else if([contentObj isKindOfClass:[BookmarkObject class]]){
        BookmarkObject* history = (BookmarkObject* )contentObj;
        cell.textLabel.text = history.name;
        cell.detailTextLabel.text = history.url.absoluteString;
    }
    
//    cell.textLabel.text = [self.listContent objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.detailTextLabel.text.length) {
        url = [NSURL URLWithString:cell.detailTextLabel.text];
    }else{
        url = [NSURL URLWithString:cell.textLabel.text];
    }
    
    if (url && [self.delegate respondsToSelector:@selector(urlSuggestionSelected:)]) {
        [self.delegate urlSuggestionSelected:url];
    }
}

@end
