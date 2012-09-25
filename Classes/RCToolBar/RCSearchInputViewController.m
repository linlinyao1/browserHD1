//
//  RCSearchInputViewController.m
//  browserHD
//
//  Created by imac on 12-8-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCSearchInputViewController.h"
#import "JSONKit.h"
#import "RCSearchEngineSwitchViewController.h"

@interface RCSearchInputViewController ()
@property (nonatomic,strong) NSMutableArray *listContent;

@end

@implementation RCSearchInputViewController
@synthesize listContent = _listContent;
@synthesize searchDelegate = _searchDelegate;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listContent = [NSMutableArray array];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)loadSearchSuggestionWithText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        //baidu suggestion
        if (text.length) {
            NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
            if (searchEngine.intValue == SETypeTaobao) {
                NSString *query = [NSString stringWithFormat:@"http://suggest.taobao.com/sug?extras=1&code=utf-8&callback=KISSY.Suggest.callback&q=%@",text];
                query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];
                if (data) {
                    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (string) {
                        string = [string stringByReplacingCharactersInRange:[string rangeOfString:@"KISSY.Suggest.callback("] withString:@""];
                        string = [string substringToIndex:string.length-2];
                        
                        NSDictionary *jsonDic = [string mutableObjectFromJSONString];
                        NSMutableArray *taobaoArray = [jsonDic objectForKey:@"result"];

                        NSMutableArray *newTaobaoArray = [NSMutableArray array];
                        for (NSArray *array in taobaoArray) {
                            [newTaobaoArray addObject:[NSString stringWithFormat:@"%@",[array objectAtIndex:0]]];
                        }
                        [tempArray addObjectsFromArray:newTaobaoArray];
                    };
                }
            }else{
                
                NSString *query = [NSString stringWithFormat:@"http://unionsug.baidu.com/su?wd=%@",text];
                query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];
                if (data) {
                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);//
                    NSString* string = [[NSString alloc] initWithData:data encoding:enc];
                    if (string) {
                        string = [string stringByReplacingCharactersInRange:[string rangeOfString:@"window.baidu.sug("] withString:@""];
                        string = [string stringByReplacingCharactersInRange:[string rangeOfString:@");"] withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"q:" withString:@"\"q\":"];
                        string = [string stringByReplacingOccurrencesOfString:@"p:" withString:@"\"p\":"];
                        string = [string stringByReplacingOccurrencesOfString:@"s:" withString:@"\"s\":"];
                        NSDictionary *jsonDic = [string mutableObjectFromJSONString];
                        NSArray *baiduArray = [jsonDic objectForKey:@"s"];
                        [tempArray addObjectsFromArray:baiduArray];
                    };
                }
            }
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
    cell.textLabel.text = [self.listContent objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchDelegate respondsToSelector:@selector(loadSearchResult: keyWord:)]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString* searchWords = cell.textLabel.text;
        NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
        [self.searchDelegate loadSearchResult:[RCSearchEngineSwitchViewController searchUrlForSEtype:searchEngine.intValue keyWord:searchWords] keyWord:searchWords];
    }
}

@end
