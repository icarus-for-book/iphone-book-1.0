//
//  MemoryInfoViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MemoryInfoViewController.h"
#import "MemoryInfo.h"
#import "PieChart.h"

#import "CPUInfo.h"

#pragma mark - MemorInfoViewController private 메소드 선언
@interface MemoryInfoViewController()

// 메모리 정보를 표시하기 위한 함수
- (void) updateInfo;
// register update timer
- (void) registerUpdateTimer;
// unregister update timer
- (void) unregisterUpdateTimer;

@property (nonatomic, retain) NSTimer *updateTimer;

@end

@implementation MemoryInfoViewController
@synthesize activeSize = _activeSize;
@synthesize wiredPercent = _wiredPercent;
@synthesize activePercent = _activePercent;
@synthesize inactiveSize = _inactiveSize;
@synthesize inactivePercent = _inactivePercent;
@synthesize freeSize = _freeSize;
@synthesize freePercent = _freePercent;
@synthesize totalSize = _totalSize;
@synthesize usedSize = _usedSize;
@synthesize freeBriefSize = _freeBriefSize;
@synthesize wiredSize = _wiredSize;
@synthesize pieChart = _pieChart;

@synthesize updateTimer = _updateTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _memoryInfo = [[MemoryInfo alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterUpdateTimer];
    [_memoryInfo release];
    [_updateTimer release];
    [_wiredSize release];
    [_wiredPercent release];
    [_activeSize release];
    [_activePercent release];
    [_inactiveSize release];
    [_inactivePercent release];
    [_freeSize release];
    [_freePercent release];
    [_totalSize release];
    [_usedSize release];
    [_freeBriefSize release];
    [_pieChart release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWiredSize:nil];
    [self setWiredPercent:nil];
    [self setActiveSize:nil];
    [self setActivePercent:nil];
    [self setInactiveSize:nil];
    [self setInactivePercent:nil];
    [self setFreeSize:nil];
    [self setFreePercent:nil];
    [self setTotalSize:nil];
    [self setUsedSize:nil];
    [self setFreeBriefSize:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerUpdateTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self unregisterUpdateTimer];
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[MemoryInfoViewController alloc] initWithNibName:@"MemoryInfoViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Memory";
}

+ (BOOL) isEnableDevice
{
    return YES;
}


#pragma mark - private methods


- (void) registerUpdateTimer
{
    [self.updateTimer invalidate];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    [self updateInfo];
}

- (void) unregisterUpdateTimer
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void) updateInfo
{
    // 메모리 정보 조회
    [_memoryInfo update];
    
    // 메모리 정보 화면에 표시 
    self.totalSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.totalMemory / (1024.0f * 1024.0f) ];
    self.usedSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.usedMemory / (1024.0f * 1024.0f) ];
    self.freeBriefSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.freeMemory / (1024.0f * 1024.0f) ];
    
    self.wiredPercent.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.wiredMemory / _memoryInfo.totalMemory * 100.0f ];
    self.activePercent.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.activeMemory / _memoryInfo.totalMemory * 100.0f ];
    self.inactivePercent.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.inactiveMemory / _memoryInfo.totalMemory * 100.0f ];
    self.freePercent.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.freeMemory / _memoryInfo.totalMemory * 100.0f ];
    
    self.activeSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.activeMemory / (1024.0f * 1024.0f) ];
    self.wiredSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.wiredMemory / (1024.0f * 1024.0f)];
    self.inactiveSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.inactiveMemory / (1024.0f * 1024.0f)];
    self.freeSize.text = [NSString stringWithFormat:@"%.1f", _memoryInfo.freeMemory / (1024.0f * 1024.0f)];
    
    // 파이 챠트에 정보를 표시
    [self.pieChart clearData];
    [self.pieChart addPercent:_memoryInfo.wiredMemory / _memoryInfo.totalMemory color:[UIColor redColor]];
    [self.pieChart addPercent:_memoryInfo.activeMemory / _memoryInfo.totalMemory color:[UIColor greenColor]];
    [self.pieChart addPercent:_memoryInfo.inactiveMemory / _memoryInfo.totalMemory color:[UIColor magentaColor]];
    [self.pieChart addPercent:_memoryInfo.freeMemory / _memoryInfo.totalMemory color:[UIColor cyanColor]];
    [self.pieChart setNeedsDisplay];
}


@end