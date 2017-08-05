//
//  URLDefine.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** Server URL ***/
#pragma mark  ip+端口

//#define URL_Server @"http://103.210.236.195:50001/"
#define URL_Server @"http://27.155.120.197:50001/"
//#define URL_Server @"http://www.pcgg28.com/"

#define HttpSecret @"sh3pcdd"

#define  EncryptPublicKey @"RP3ee12CnCibO5VQ"

/*** h5 页面 ***/
#pragma mark  h5 页面

//回水规则
#define  Wap_HuiShuiGuiZe @"pcdd-wap/views/module/index/huishui.html?game_type=1"

//走势图
#define  Wap_ZouShiTu @"pcdd-wap/views/module/index/zoushi.html?game_type="

//banner详情
#define  Wap_Banner @"pcdd-wap/views/module/index/bannerDetails.html?banner_id="

//加拿大玩法说明
#define  Wap_JNDWFSM @"pcdd-wap/views/module/index/jndDetails.html"

//北京快8玩法说明
#define  Wap_BJWFSM @"pcdd-wap/views/module/index/beijingDetails.html"

//消息详情 notice_id=1&user_id=1
#define  Wap_MessageDetail @"pcdd-wap/views/module/index/noticeDetails.html?"

//客服中心
#define  Wap_KefuCenter @"http://kefu.easemob.com/webim/im.html?tenantId=36922"

//赔率说明
#define  Wap_PeiLvShuoMing @"pcdd-wap/views/module/index/peilv.html?room_id="

//用户协议
#define  Wap_YongHuXieYi @"pcdd-wap/views/module/index/yonghuXieyi.html"


/*** 公共模块 ***/

#pragma mark  公共模块

//上传图片
#define  URL_UpdateImageUrl @"pcdd-api-client-interface/file/upload"

//获取验证码
#define URL_GetVerificationCode @"pcdd-api-client-interface/sendSMSVerification"

//获取banner
#define URL_GeBannerInfo @"pcdd-api-client-interface/banner/list"

//绑定手机号
#define URL_BangDingPhone @"pcdd-api-client-interface/user/band"

/*** 登录接口 ***/
#pragma mark  登录注册模块

//注册
#define URL_Register @"pcdd-api-client-interface/user/register"

//登陆
#define URL_Login @"pcdd-api-client-interface/user/login"

//快速登陆
#define URL_QuickLogin @"oneCity-api-client-interface/oneCity/service/userFastLogin"

//第三方登录
#define URL_OtherLogin @"pcdd-api-client-interface/user3rd/login"

//忘记密码
#define URL_ForgetPwd @"pcdd-api-client-interface/user/password/find"

/*** 首页数据 ***/
#pragma mark  首页

//检测接口
#define URL_CheckVersion @"pcdd-api-client-interface/version"

//获取首页数据
#define URL_GetHomePageData @"pcdd-api-client-interface/home/page"

//游戏区域
#define URL_GetHouseAreaListInfo @"pcdd-api-client-interface/gameArea/list"

//房间列表
#define URL_GetHouseListInfo @"pcdd-api-client-interface/room/list"

//加入房间
#define URL_JoinGameRoom @"pcdd-api-client-interface/room/user/add"

//通知服务器已进入房间
#define URL_PutNotif @"pcdd-api-client-interface/room/user/sendMsg"

//离开房间
#define URL_LeaveGameRoom @"pcdd-api-client-interface/room/user/del"

//获取游戏比例
#define URL_GetGameBiLi @"pcdd-api-client-interface/room/bili/list"

//下注
#define URL_XiaZhu @"pcdd-api-client-interface/room/point/add"

//获取倒计时和最近开奖结果
#define URL_GetDJSORHistory @"pcdd-api-client-interface/room/open/info"

//获取客服问题列表
#define URL_GetKeFuRequestList @"pcdd-api-client-interface/quest/list"

/*** 充值 ***/
#pragma mark  充值
//转账账号列表
#define URL_GetZhuanZhangAccountList @"pcdd-api-client-interface/account/list"

//新增转账记录
#define URL_AddZhuanZhangList @"pcdd-api-client-interface/account/user/add"

//转账记录
#define URL_ZZRecordList @"pcdd-api-client-interface/account/user/list"

//获取订单号
#define URL_GetOrderNo @"pcdd-api-client-interface/user/recharge"

//爱益支付
#define URL_AiYiPay @"pcdd-api-client-interface/aiyi/pay/url"


//检测是否支付成功
#define  URL_CheckIsPaySuccess @"pcdd-api-client-interface/user/pay/check"

/*** 动态 ***/
#pragma mark  动态

//消息列表
#define URL_GetNoticeListInfo @"pcdd-api-client-interface/notice/list"

//未读消息
#define URL_GetUnreadNoticeNum @"pcdd-api-client-interface/notice/count"


/*** 个人中心接口 ***/
#pragma mark 个人中心

//更新用户信息
#define URL_UpdateUserInfo @"pcdd-api-client-interface/user/update"

//获取用户信息
#define URL_GetUserInfo @"pcdd-api-client-interface/user/details"

//获取充值记录
#define URL_GetCZRecordListInfo @"pcdd-api-client-interface/game/charge/list"

//获取提现记录
#define URL_GetTXRecordListInfo @"pcdd-api-client-interface/withdrawals/list"

//获取账变记录
#define URL_GetZBRecordListInfo @"pcdd-api-client-interface/point/change/list"

//获取游戏记录
#define URL_GetYXRecordListInfo @"pcdd-api-client-interface/game/choice/list"

//银行卡绑定
#define URL_BankBangding @"pcdd-api-client-interface//withdrawals/bank/update"

//提现接口
#define URL_TiXian @"pcdd-api-client-interface/withdrawals/add"

//提现提示接口
#define URL_TiXianWarn @"pcdd-api-client-interface/tixian/params"

//礼物列表
#define URL_GiftList @"pcdd-api-client-interface/gift/list"

//兑换礼物
#define URL_ExchangeGift @"pcdd-api-client-interface/gift/exchange"

//兑换记录
#define URL_ExchangeGiftRecord @"pcdd-api-client-interface/exchange/list"

//回水记录
#define URL_HuiShuiRecord @"pcdd-api-client-interface/huishui/list"

//关于我们
#define URL_GetPTInfo @"pcdd-api-client-interface/kefu/list"

//获取分享内容
#define URL_GetShareInfo @"pcdd-api-client-interface/share/list"

//我的收益
#define URL_GetMyShouYi @"pcdd-api-client-interface/fenxiao/list"

//分销规则
#define URL_GetShareRule @"pcdd-api-client-interface/share/bili/list"

@interface URLDefine : NSObject

@end


