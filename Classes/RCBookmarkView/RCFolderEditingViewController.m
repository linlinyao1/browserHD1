//
//  RCFolderEditingViewController.m
//  browserHD
//
//  Created by imac on 12-9-11.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderEditingViewController.h"
#import "RCFolderButton.h"
#import "RCSimpleFolderViewController.h"
#import "RCFolderEditngSelectViewController.h"


@interface RCFolderEditingViewController ()
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) RCFolderButton *folderButton;
@end

@implementation RCFolderEditingViewController
@synthesize navBar = _navBar;
@synthesize titleField = _titleField;
@synthesize folderButton = _folderButton;
@synthesize folder = _folder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.folder = [[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]];
        self.backupFolder = self.folder;
    }
    return self;
}

-(void)setFolder:(Folder *)folder
{
//    if (_folder != folder) {
        _folder = folder;
        if (folder.parent) {
            if (self.editingMode == FolderEditingModeEdit) {
                [self.folderButton.button setTitle:folder.parent.title forState:UIControlStateNormal];
            }else{
                [self.folderButton.button setTitle:folder.title forState:UIControlStateNormal];
            }
        }else{
            [self.folderButton.button setTitle:folder.title forState:UIControlStateNormal];
        }
//    }
}

-(void)setupViews
{
    
//    NSLog(@"self.parentViewController : %@",[self.navigationController.topViewController class]);
    
    UIButton* buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    //    buttonAdd.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonCancle.frame = CGRectMake(5, 9, 73, 32);
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_navEdit_normal"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_navEdit_hite"] forState:UIControlStateHighlighted];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    buttonCancle.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonCancle addTarget:self action:@selector(handleButtonCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonCancle];
    
    UIButton* buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDone.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonDone.frame = CGRectMake(self.navBar.bounds.size.width-73-5, 9, 73, 32);
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmark_leftDone_normal"] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmark_leftDone_hite"] forState:UIControlStateHighlighted];
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    buttonDone.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonDone addTarget:self action:@selector(handleButtonDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonDone];
        
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.navBar.bounds.size.width*0.82, 27)];
    self.titleField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.center = CGPointMake(self.navBar.bounds.size.width/2, 100);
    [self.view addSubview:self.titleField];

    
    
    RCFolderButton* folderButton = [[RCFolderButton alloc] initWithFrame:CGRectOffset(self.titleField.frame, 0, 50)];
    folderButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [folderButton.button addTarget:self action:@selector(handleFolderButton:) forControlEvents:UIControlEventTouchUpInside];
    self.folderButton = folderButton;

    [self.view addSubview:folderButton];
    
    if (self.editingMode == FolderEditingModeCreat) {
        self.titleField.text = nil;
//        if (self.folder.parent) {
//            [folderButton.button setTitle:self.folder.parent.title forState:UIControlStateNormal];
//        }else{
            [folderButton.button setTitle:self.folder.title forState:UIControlStateNormal];
//        }
    }else{
        self.titleField.text = self.folder.title;
        [self.folderButton.button setTitle:self.folder.title forState:UIControlStateNormal];
    }
}



-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_leftTableBG"]];
    
    ////////////start of navBar////////////
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_cellBG_lv1"]];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


-(void)handleButtonCancle:(UIButton*)sender
{
    [[CoreDataManager defaultManager].managedObjectContext rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleButtonDone:(UIButton*)sender
{
    if (!self.titleField.text.length) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"文件夹名字不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //TODO
    if (self.editingMode == FolderEditingModeCreat) {
        NSNumber* unique = [[CoreDataManager defaultManager] generateValidFolderUnique];
//        if (self.folder.parent) {
            [[CoreDataManager defaultManager] creatFolderWithTitle:self.titleField.text Unique:unique Parent:self.folder];
//        }else{
//            [[CoreDataManager defaultManager] creatFolderWithTitle:self.titleField.text Unique:unique Parent:[[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]]];
//        }
    }else{
        self.folder.title = self.titleField.text;
        [[CoreDataManager defaultManager] saveContext];
    }
    [self.mainVC viewWillAppear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleFolderButton:(UIButton*)sender
{
    RCFolderEditngSelectViewController*vc = [[RCFolderEditngSelectViewController alloc] init];
    vc.mainVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
