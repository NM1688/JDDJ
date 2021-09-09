/*
新版京东试用，误传

⚠️ 非常耗时的脚本。一个账号可能执行1小时！
自行根据账号数量修改脚本超时时间
每天最多关注300个商店，但用户商店关注上限为500个。
请配合取关脚本试用，使用 jd_unsubscribe.js 提前取关至少250个商店确保京东试用脚本正常运行。

 */
const $ = new Env("京东试用");
let cookiesArr = [],
  cookie = "",
  jdNotify = false,
  jdDebug = false,
  notify;
// notifyMsg = "";
// default params
$.pageSize = 12;
let tabList = [
  // { tabName: "精选", tabId: "1" },
  // { tabName: "闪电试", tabId: "2" },
  // { tabName: "家用电器", tabId: "3" },
  // { tabName: "手机数码", tabId: "4" },
  // { tabName: "电脑办公", tabId: "5" },
  // { tabName: "家居家装", tabId: "6" },
  // { tabName: "美妆护肤", tabId: "7" },
  // { tabName: "服饰鞋包", tabId: "8" },
  // { tabName: "母婴玩具", tabId: "9" },
  // { tabName: "生鲜美食", tabId: "10" },
  // { tabName: "图书音像", tabId: "11" },
  // { tabName: "钟表奢品", tabId: "12" },
  { tabName: "个人护理", tabId: "13" },
  // { tabName: "家庭清洁", tabId: "14" },
  // { tabName: "食品饮料", tabId: "15" },
  // { tabName: "更多惊喜", tabId: "16" },
];
let goodFilters =
  "脚气@卷尺@种子@档案袋@癣@中年@老太太@妇女@私处@孕妇@卫生巾@卫生条@课@培训@阴道@生殖器@肛门@狐臭@少女内衣@胸罩@少女@女孩@鱼饵@童装@吊带@黑丝@钢圈@婴儿@儿童@玩具@幼儿@娃娃@网课@网校@电商@手机壳@钢化膜@车载充电器@网络课程@女纯棉@三角裤@美少女@纸尿裤@英语@俄语@四级@六级@四六级@在线网络@在线@阴道炎@宫颈@糜烂@打底裤@手机膜@鱼@狗@电话卡@门票@活动一@活动二@活动三@活动四@活动五@活动六@活动七@活动八@活动九@活动十@教育@看房@教程@软件@辅导@到店福利@飞机杯@震动棒@自慰器".split(
    "@"
  );
let minPrice = 201; // 最低价格
let feedsList = []; // 所有试用商品

!(async () => {
  await requireConfig();
  if (!cookiesArr[0]) {
    $.msg(
      $.name,
      "【提示】请先获取京东账号一cookie\n直接使用NobyDa的京东签到获取",
      "https://bean.m.jd.com/",
      {
        "open-url": "https://bean.m.jd.com/",
      }
    );
    return;
  }
  // 获取列表
  await try_tabList();
  console.log(tabList);
  if (tabList.length > 0) {
    for (let i = 0; i < tabList.length; i++) {
      await try_feedsList(tabList[i]);
    }
  }
  await filterGoodList();

  for (let i = 0; i < cookiesArr.length; i++) {
    if (cookiesArr[i]) {
      cookie = cookiesArr[i];
      $.UserName = decodeURIComponent(
        cookie.match(/pt_pin=(.+?);/) && cookie.match(/pt_pin=(.+?);/)[1]
      );
      $.index = i + 1;
      $.isLogin = true;
      $.nickName = "";
      await TotalBean();
      console.log(`\n开始【京东账号${$.index}】${$.nickName || $.UserName}\n`);
      if (!$.isLogin) {
        $.msg(
          $.name,
          `【提示】cookie已失效`,
          `京东账号${$.index} ${
            $.nickName || $.UserName
          }\n请重新登录获取\nhttps://bean.m.jd.com/bean/signIndex.action`,
          {
            "open-url": "https://bean.m.jd.com/bean/signIndex.action",
          }
        );

        if ($.isNode()) {
          await notify.sendNotify(
            `${$.name}cookie已失效 - ${$.UserName}`,
            `京东账号${$.index} ${$.UserName}\n请重新登录获取cookie`
          );
        }
        continue;
      }
      $.successList = [];

      $.totalTry = 0;
      $.totalGoods = $.goodList.length;
      await tryGoodList();
      await getSuccessList();

      await showMsg();
    }
  }

  // notify.sendNotify(`${$.name}`, notifyMsg);
})()
  .catch((e) => {
    console.log(`❗️ ${$.name} 运行错误！\n${e}`);
    if (eval(jdDebug)) $.msg($.name, ``, `${e}`);
  })
  .finally(() => $.done());

function requireConfig() {
  return new Promise((resolve) => {
    console.log("开始获取配置文件\n");
    notify = $.isNode() ? require("./sendNotify") : "";
    //Node.js用户请在jdCookie.js处填写京东ck;
    if ($.isNode()) {
      const jdCookieNode = $.isNode() ? require("./jdCookie.js") : "";
      Object.keys(jdCookieNode).forEach((item) => {
        if (jdCookieNode[item]) {
          cookiesArr.push(jdCookieNode[item]);
        }
      });
      if (process.env.JD_DEBUG && process.env.JD_DEBUG === "false")
        console.log = () => {};
    } else {
      //IOS等用户直接用NobyDa的jd cookie
      let cookiesData = $.getdata("CookiesJD") || "[]";
      cookiesData = jsonParse(cookiesData);
      cookiesArr = cookiesData.map((item) => item.cookie);
      cookiesArr.reverse();
      cookiesArr.push(...[$.getdata("CookieJD2"), $.getdata("CookieJD")]);
      cookiesArr.reverse();
      cookiesArr = cookiesArr.filter(
        (item) => item !== "" && item !== null && item !== undefined
      );
    }
    console.log(`共${cookiesArr.length}个京东账号\n`);

    if ($.isNode()) {
      if (process.env.JD_TRY_CIDS_KEYS) {
        cidsList = process.env.JD_TRY_CIDS_KEYS.split("@").filter((key) => {
          return Object.keys(cidsMap).includes(key);
        });
      }
      if (process.env.JD_TRY_TYPE_KEYS) {
        typeList = process.env.JD_TRY_CIDS_KEYS.split("@").filter((key) => {
          return Object.keys(typeMap).includes(key);
        });
      }
      if (process.env.JD_TRY_GOOD_FILTERS) {
        goodFilters = process.env.JD_TRY_GOOD_FILTERS.split("@");
      }
      if (process.env.JD_TRY_MIN_PRICE) {
        minPrice = process.env.JD_TRY_MIN_PRICE * 1;
      }
      if (process.env.JD_TRY_PAGE_SIZE) {
        $.pageSize = process.env.JD_TRY_PAGE_SIZE * 1;
      }
    } else {
      let qxCidsList = [];
      let qxTypeList = [];
      const cidsKeys = Object.keys(cidsMap);
      const typeKeys = Object.keys(typeMap);
      for (let key of cidsKeys) {
        const open = $.getdata(key);
        if (open == "true") qxCidsList.push(key);
      }
      for (let key of typeKeys) {
        const open = $.getdata(key);
        if (open == "true") qxTypeList.push(key);
      }
      if (qxCidsList.length != 0) cidsList = qxCidsList;
      if (qxTypeList.length != 0) typeList = qxTypeList;
      if ($.getdata("filter")) goodFilters = $.getdata("filter").split("&");
      if ($.getdata("min_price")) minPrice = Number($.getdata("min_price"));
      if ($.getdata("page_size")) $.pageSize = Number($.getdata("page_size"));
      if ($.pageSize == 0) $.pageSize = 12;
    }
    resolve();
  });
}

function try_feedsList(tab, page = 1) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      tabId: `${tab.tabId}`,
      page,
      previewTime: "",
    });
    let option = taskGETUrl("newtry", "try_feedsList", body);
    delete option.headers["Cookie"];

    $.get(option, async (err, resp, data) => {
      if (err) {
        console.log(`try_feedsList ${err}`);
        reject(err);
      }
      data = JSON.parse(data);
      if (data.success) {
        console.log(`${tab.tabName}第${page}页获取成功`);
        feedsList = feedsList.concat(data.data.feedList);

        if (data.data.page * data.data.pageSize < data.data.total) {
          await $.wait(6000);
          resolve(await try_feedsList(tab, page + 1));
        } else {
          resolve();
        }
      }
    });
  });
}

async function filterGoodList() {
  console.log(`⏰ 过滤商品列表，当前共有${feedsList.length}个商品`);
  const now = Date.now();
  const oneMoreDay = now + 24 * 60 * 60 * 1000;
  $.goodList = feedsList.filter((good) => {
    // 1. good 有问题
    // 2. good 距离结束不到10min
    // 3. good 距离结束时间超过2天，不然商品会太多
    // 4. good 的结束时间大于一天
    // 5. good 的价格小于最小的限制
    if (
      !good ||
      good.endTime < now + 10 * 60 * 1000 ||
      good.endTime > now + 2 * 24 * 60 * 60 * 1000 ||
      good.endTime > oneMoreDay ||
      good.jdPrice < minPrice
    ) {
      return false;
    }
    // 过滤种草
    if (good.tagList && good.tagList.length !== 0) {
      for (let itemTag of good.tagList) {
        if (itemTag.tagType === 3) {
          return false;
        }
      }
    }
    // 过滤名字
    if (good.skuTitle && good.skuTitle.includes(goodFilters)) {
      return false;
    }
    return true;
  });
  // console.log($.goodList);
  console.log("执行优选商品价格从高到低进行排序");
  $.goodList = $.goodList.sort((a, b) => {
    return b.jdPrice - a.jdPrice;
  });
  console.log(`基础过滤排序完成，已筛选出${$.goodList.length}个商品`);
}

async function tryGoodList() {
  console.log(`⏰ 即将申请 ${$.goodList.length} 个商品`);
  $.running = true;
  $.stopMsg = "申请完毕";

  for (let i = 0; i < $.goodList.length && $.running; i++) {
    let good = $.goodList[i];
    const waitTime = generateRandomInteger(5000, 10000);
    console.log(`随机等待${waitTime}秒后继续执行`);
    await $.wait(waitTime);
    await try_apply(good);
  }
}

 const generateRandomInteger = (min, max = 0) => {
   if (min > max) {
     let temp = min;
     min = max;
     max = temp;
   }
   var Range = max - min;
   var Rand = Math.random();
   return Min + Math.round(Rand * Range);
 };

async function try_apply(good) {
  console.log(
    `尝试申请${good.skuTitle} 【价值￥${good.jdPrice}】【id为：${good.trialActivityId}】`
  );
  $.wait(6000)
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      activityId: good.trialActivityId,
      previewTime: "",
    });

    let option = taskGETUrl("newtry", "try_apply", body);
    option.headers["Origin"] = "https://pro.m.jd.com";
    option.headers[
      "Referer"
    ] = `https://pro.m.jd.com/mall/active/3mpGVQDhvLsMvKfZZumWPQyWt83L/index.html?has_native=0&activityId=${good.trialActivityId}`;

    $.get(option, (err, resp, data) => {
      try {
        if (err) {
          console.log(
            `🚫 ${arguments.callee.name.toString()} API请求失败，请检查网路\n${JSON.stringify(
              err
            )}`
          );
        } else {
          data = JSON.parse(data);
          // console.log(data);
          if (data.success && data.code === "1") {
            $.totalTry += 1;
            console.log(
              `🥳 ${good.trialActivityId} 🛒${good.skuTitle}🛒 ${data.message}`
            );
          } else if (data.code == "-131") {
            // 每日300个商品
            $.stopMsg = data.message;
            $.running = false;
          } else {
            console.log(
              `🤬 ${good.trialActivityId} 🛒${
                good.trialName
              }🛒 ${JSON.stringify(data)}`
            );
          }
          resolve();
        }
      } catch (e) {
        reject(
          `⚠️ ${arguments.callee.name.toString()} API返回结果解析出错\n${e}\n${JSON.stringify(
            data
          )}`
        );
      }
    });
  });
}

// 获取 try_tabList
function try_tabList() {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      previewTime: "",
    });
    let option = taskGETUrl("newtry", "try_tabList", body);
    $.get(option, (err, resp, data) => {
      try {
        if (err) {
          console.log(
            `🚫 ${arguments.callee.name.toString()} API请求失败，请检查网络\n${JSON.stringify(
              err
            )}`
          );
        } else {
          data = JSON.parse(data);
          if (data.success) {
            tabList = data.data.tabList;
          } else {
            console.log("获取失败", data);
          }
        }
      } catch (e) {
        reject(
          `⚠️ ${arguments.callee.name.toString()} API返回结果解析出错\n${e}\n${JSON.stringify(
            data
          )}`
        );
      } finally {
        resolve();
      }
    });
  });
}

function taskGETUrl(appid, functionId, body = JSON.stringify({})) {
  return {
    url: `https://api.m.jd.com/client.action?appid=${appid}&functionId=${functionId}&clientVersion=10.1.2&client=wh5&body=${encodeURIComponent(
      body
    )}`,
    headers: {
      Host: "api.m.jd.com",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "zh-cn",
      Cookie: cookie,
      Origin: "https://prodev.m.jd.com",
      Connection: "keep-alive",
      "Content-Type": "application/x-www-form-urlencoded",
      UserAgent:
        "jdapp;iPhone;10.1.2;14.7.1;e012d4d2bdbd153538afedc564b6ef59fce3e0d2;network/wifi;model/iPhone12,1;addressid/0;appBuild/167802;jdSupportDarkMode/0;Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
      "Accept-Language": "zh-cn",
      "Accept-Encoding": "gzip, deflate, br",
      Accept: "application/json, text/plain, */*",
      Referer: `https://prodev.m.jd.com/mall/active/3mpGVQDhvLsMvKfZZumWPQyWt83L/index.html?activityId=${
        JSON.parse(body).activityId
      }&tttparams=oNnzSixJeyJnTG5nIjoiMTE4LjcxNzY3NSIsImdMYXQiOiIzMS45ODkxNDIifQ8%3D%3D&un_area=12_904_3376_57874&lng=118.7176193562527&lat=31.98916265951646`,
    },
  };
}

async function getSuccessList() {
  // 一页12个商品，不会吧不会吧，不会有人一次性中奖12个商品吧？！🤔
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      page: 1,
      selected: 2, // 1 - 已申请 2 - 成功列表，3 - 失败列表
      previewTime: "",
    });
    let option = taskGETUrl("newtry", "try_MyTrials", body);
    option.headers.Referer = "https://pro.m.jd.com/";

    $.get(option, (err, resp, data) => {
      try {
        if (err) {
          console.log(
            `🚫 ${arguments.callee.name.toString()} API请求失败，请检查网路\n${JSON.stringify(
              err
            )}`
          );
        } else {
          data = JSON.parse(data);
          if (data.success && data.data) {
            $.successList = data.data.list.filter((item) => {
              return item.text.text.indexOf("请尽快领取") != -1;
            });
          } else {
            console.log(`💩 获得成功列表失败: ${data.message}`);
          }
        }
      } catch (e) {
        reject(
          `⚠️ ${arguments.callee.name.toString()} API返回结果解析出错\n${e}\n${JSON.stringify(
            data
          )}`
        );
      } finally {
        resolve();
      }
    });
  });
}

async function showMsg() {
  let message = `京东账号${$.index} ${$.nickName || $.UserName}\n🎉 本次申请：${
    $.totalTry
  }/${$.totalGoods}个商品🛒\n🎉 ${
    $.successList.length
  }个商品待领取🤩\n🎉 结束原因：${$.stopMsg}`;
  if (!jdNotify || jdNotify === "false") {
    $.msg($.name, ``, message, {
      "open-url": "https://try.jd.com/user",
    });
    if ($.isNode()) {
      // notifyMsg += `${message}\n\n`;
      notify.sendNotify(`${$.name}`, message);
    }
  } else {
    console.log(message);
  }
}

function taskurl(url, goodId) {
  return {
    url: url,
    headers: {
      Host: "try.jd.com",
      "Accept-Encoding": "gzip, deflate, br",
      Cookie: cookie,
      Connection: "keep-alive",
      Accept: "*/*",
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36",
      "Accept-Language": "zh-CN,zh;q=0.9",
      Referer: goodId ? `https://try.jd.com/${goodId}.html` : undefined,
    },
  };
}

function TotalBean() {
  return new Promise(async (resolve) => {
    const options = {
      url: `https://wq.jd.com/user/info/QueryJDUserInfo?sceneval=2`,
      headers: {
        Accept: "application/json,text/plain, */*",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "zh-cn",
        Connection: "keep-alive",
        Cookie: cookie,
        Referer: "https://wqs.jd.com/my/jingdou/my.shtml?sceneval=2",
        "User-Agent": $.isNode()
          ? process.env.JD_USER_AGENT
            ? process.env.JD_USER_AGENT
            : require("./USER_AGENTS").USER_AGENT
          : $.getdata("JDUA")
          ? $.getdata("JDUA")
          : "jdapp;iPhone;9.2.2;14.2;%E4%BA%AC%E4%B8%9C/9.2.2 CFNetwork/1206 Darwin/20.1.0",
      },
      timeout: 10000,
    };
    $.post(options, (err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`);
          console.log(`${$.name} API请求失败，请检查网路重试`);
        } else {
          if (data) {
            data = JSON.parse(data);
            if (data["retcode"] === 13) {
              $.isLogin = false; //cookie过期
              return;
            }
            if (data["retcode"] !== 101) {
              $.nickName = data["base"].nickname;
            }
          } else {
            console.log(`京东服务器返回空数据`);
          }
        }
      } catch (e) {
        $.logErr(e, resp);
      } finally {
        resolve();
      }
    });
  });
}

function jsonParse(str) {
  if (typeof str == "string") {
    try {
      return JSON.parse(str);
    } catch (e) {
      console.log(e);
      $.msg(
        $.name,
        "",
        "请勿随意在BoxJs输入框修改内容\n建议通过脚本去获取cookie"
      );
      return [];
    }
  }
}

// 来自 @chavyleung 大佬
// https://raw.githubusercontent.com/chavyleung/scripts/master/Env.js
function Env(name, opts) {
  class Http {
    constructor(env) {
      this.env = env;
    }

    send(opts, method = "GET") {
      opts =
        typeof opts === "string"
          ? {
              url: opts,
            }
          : opts;
      let sender = this.get;
      if (method === "POST") {
        sender = this.post;
      }
      return new Promise((resolve, reject) => {
        sender.call(this, opts, (err, resp, body) => {
          if (err) reject(err);
          else resolve(resp);
        });
      });
    }

    get(opts) {
      return this.send.call(this.env, opts);
    }

    post(opts) {
      return this.send.call(this.env, opts, "POST");
    }
  }

  return new (class {
    constructor(name, opts) {
      this.name = name;
      this.http = new Http(this);
      this.data = null;
      this.dataFile = "box.dat";
      this.logs = [];
      this.isMute = false;
      this.isNeedRewrite = false;
      this.logSeparator = "\n";
      this.startTime = new Date().getTime();
      Object.assign(this, opts);
      this.log("", `🔔${this.name}, 开始!`);
    }

    isNode() {
      return "undefined" !== typeof module && !!module.exports;
    }

    isQuanX() {
      return "undefined" !== typeof $task;
    }

    isSurge() {
      return "undefined" !== typeof $httpClient && "undefined" === typeof $loon;
    }

    isLoon() {
      return "undefined" !== typeof $loon;
    }

    toObj(str, defaultValue = null) {
      try {
        return JSON.parse(str);
      } catch {
        return defaultValue;
      }
    }

    toStr(obj, defaultValue = null) {
      try {
        return JSON.stringify(obj);
      } catch {
        return defaultValue;
      }
    }

    getjson(key, defaultValue) {
      let json = defaultValue;
      const val = this.getdata(key);
      if (val) {
        try {
          json = JSON.parse(this.getdata(key));
        } catch {}
      }
      return json;
    }

    setjson(val, key) {
      try {
        return this.setdata(JSON.stringify(val), key);
      } catch {
        return false;
      }
    }

    getScript(url) {
      return new Promise((resolve) => {
        this.get(
          {
            url,
          },
          (err, resp, body) => resolve(body)
        );
      });
    }

    runScript(script, runOpts) {
      return new Promise((resolve) => {
        let httpapi = this.getdata("@chavy_boxjs_userCfgs.httpapi");
        httpapi = httpapi ? httpapi.replace(/\n/g, "").trim() : httpapi;
        let httpapi_timeout = this.getdata(
          "@chavy_boxjs_userCfgs.httpapi_timeout"
        );
        httpapi_timeout = httpapi_timeout ? httpapi_timeout * 1 : 20;
        httpapi_timeout =
          runOpts && runOpts.timeout ? runOpts.timeout : httpapi_timeout;
        const [key, addr] = httpapi.split("@");
        const opts = {
          url: `http://${addr}/v1/scripting/evaluate`,
          body: {
            script_text: script,
            mock_type: "cron",
            timeout: httpapi_timeout,
          },
          headers: {
            "X-Key": key,
            Accept: "*/*",
          },
        };
        this.post(opts, (err, resp, body) => resolve(body));
      }).catch((e) => this.logErr(e));
    }

    loaddata() {
      if (this.isNode()) {
        this.fs = this.fs ? this.fs : require("fs");
        this.path = this.path ? this.path : require("path");
        const curDirDataFilePath = this.path.resolve(this.dataFile);
        const rootDirDataFilePath = this.path.resolve(
          process.cwd(),
          this.dataFile
        );
        const isCurDirDataFile = this.fs.existsSync(curDirDataFilePath);
        const isRootDirDataFile =
          !isCurDirDataFile && this.fs.existsSync(rootDirDataFilePath);
        if (isCurDirDataFile || isRootDirDataFile) {
          const datPath = isCurDirDataFile
            ? curDirDataFilePath
            : rootDirDataFilePath;
          try {
            return JSON.parse(this.fs.readFileSync(datPath));
          } catch (e) {
            return {};
          }
        } else return {};
      } else return {};
    }

    writedata() {
      if (this.isNode()) {
        this.fs = this.fs ? this.fs : require("fs");
        this.path = this.path ? this.path : require("path");
        const curDirDataFilePath = this.path.resolve(this.dataFile);
        const rootDirDataFilePath = this.path.resolve(
          process.cwd(),
          this.dataFile
        );
        const isCurDirDataFile = this.fs.existsSync(curDirDataFilePath);
        const isRootDirDataFile =
          !isCurDirDataFile && this.fs.existsSync(rootDirDataFilePath);
        const jsondata = JSON.stringify(this.data);
        if (isCurDirDataFile) {
          this.fs.writeFileSync(curDirDataFilePath, jsondata);
        } else if (isRootDirDataFile) {
          this.fs.writeFileSync(rootDirDataFilePath, jsondata);
        } else {
          this.fs.writeFileSync(curDirDataFilePath, jsondata);
        }
      }
    }

    lodash_get(source, path, defaultValue = undefined) {
      const paths = path.replace(/\[(\d+)\]/g, ".$1").split(".");
      let result = source;
      for (const p of paths) {
        result = Object(result)[p];
        if (result === undefined) {
          return defaultValue;
        }
      }
      return result;
    }

    lodash_set(obj, path, value) {
      if (Object(obj) !== obj) return obj;
      if (!Array.isArray(path)) path = path.toString().match(/[^.[\]]+/g) || [];
      path
        .slice(0, -1)
        .reduce(
          (a, c, i) =>
            Object(a[c]) === a[c]
              ? a[c]
              : (a[c] = Math.abs(path[i + 1]) >> 0 === +path[i + 1] ? [] : {}),
          obj
        )[path[path.length - 1]] = value;
      return obj;
    }

    getdata(key) {
      let val = this.getval(key);
      // 如果以 @
      if (/^@/.test(key)) {
        const [, objkey, paths] = /^@(.*?)\.(.*?)$/.exec(key);
        const objval = objkey ? this.getval(objkey) : "";
        if (objval) {
          try {
            const objedval = JSON.parse(objval);
            val = objedval ? this.lodash_get(objedval, paths, "") : val;
          } catch (e) {
            val = "";
          }
        }
      }
      return val;
    }

    setdata(val, key) {
      let issuc = false;
      if (/^@/.test(key)) {
        const [, objkey, paths] = /^@(.*?)\.(.*?)$/.exec(key);
        const objdat = this.getval(objkey);
        const objval = objkey
          ? objdat === "null"
            ? null
            : objdat || "{}"
          : "{}";
        try {
          const objedval = JSON.parse(objval);
          this.lodash_set(objedval, paths, val);
          issuc = this.setval(JSON.stringify(objedval), objkey);
        } catch (e) {
          const objedval = {};
          this.lodash_set(objedval, paths, val);
          issuc = this.setval(JSON.stringify(objedval), objkey);
        }
      } else {
        issuc = this.setval(val, key);
      }
      return issuc;
    }

    getval(key) {
      if (this.isSurge() || this.isLoon()) {
        return $persistentStore.read(key);
      } else if (this.isQuanX()) {
        return $prefs.valueForKey(key);
      } else if (this.isNode()) {
        this.data = this.loaddata();
        return this.data[key];
      } else {
        return (this.data && this.data[key]) || null;
      }
    }

    setval(val, key) {
      if (this.isSurge() || this.isLoon()) {
        return $persistentStore.write(val, key);
      } else if (this.isQuanX()) {
        return $prefs.setValueForKey(val, key);
      } else if (this.isNode()) {
        this.data = this.loaddata();
        this.data[key] = val;
        this.writedata();
        return true;
      } else {
        return (this.data && this.data[key]) || null;
      }
    }

    initGotEnv(opts) {
      this.got = this.got ? this.got : require("got");
      this.cktough = this.cktough ? this.cktough : require("tough-cookie");
      this.ckjar = this.ckjar ? this.ckjar : new this.cktough.CookieJar();
      if (opts) {
        opts.headers = opts.headers ? opts.headers : {};
        if (undefined === opts.headers.Cookie && undefined === opts.cookieJar) {
          opts.cookieJar = this.ckjar;
        }
      }
    }

    get(opts, callback = () => {}) {
      if (opts.headers) {
        delete opts.headers["Content-Type"];
        delete opts.headers["Content-Length"];
      }
      if (this.isSurge() || this.isLoon()) {
        if (this.isSurge() && this.isNeedRewrite) {
          opts.headers = opts.headers || {};
          Object.assign(opts.headers, {
            "X-Surge-Skip-Scripting": false,
          });
        }
        $httpClient.get(opts, (err, resp, body) => {
          if (!err && resp) {
            resp.body = body;
            resp.statusCode = resp.status;
          }
          callback(err, resp, body);
        });
      } else if (this.isQuanX()) {
        if (this.isNeedRewrite) {
          opts.opts = opts.opts || {};
          Object.assign(opts.opts, {
            hints: false,
          });
        }
        $task.fetch(opts).then(
          (resp) => {
            const { statusCode: status, statusCode, headers, body } = resp;
            callback(
              null,
              {
                status,
                statusCode,
                headers,
                body,
              },
              body
            );
          },
          (err) => callback(err)
        );
      } else if (this.isNode()) {
        this.initGotEnv(opts);
        this.got(opts)
          .on("redirect", (resp, nextOpts) => {
            try {
              if (resp.headers["set-cookie"]) {
                const ck = resp.headers["set-cookie"]
                  .map(this.cktough.Cookie.parse)
                  .toString();
                if (ck) {
                  this.ckjar.setCookieSync(ck, null);
                }
                nextOpts.cookieJar = this.ckjar;
              }
            } catch (e) {
              this.logErr(e);
            }
            // this.ckjar.setCookieSync(resp.headers['set-cookie'].map(Cookie.parse).toString())
          })
          .then(
            (resp) => {
              const { statusCode: status, statusCode, headers, body } = resp;
              callback(
                null,
                {
                  status,
                  statusCode,
                  headers,
                  body,
                },
                body
              );
            },
            (err) => {
              const { message: error, response: resp } = err;
              callback(error, resp, resp && resp.body);
            }
          );
      }
    }

    post(opts, callback = () => {}) {
      // 如果指定了请求体, 但没指定`Content-Type`, 则自动生成
      if (opts.body && opts.headers && !opts.headers["Content-Type"]) {
        opts.headers["Content-Type"] = "application/x-www-form-urlencoded";
      }
      if (opts.headers) delete opts.headers["Content-Length"];
      if (this.isSurge() || this.isLoon()) {
        if (this.isSurge() && this.isNeedRewrite) {
          opts.headers = opts.headers || {};
          Object.assign(opts.headers, {
            "X-Surge-Skip-Scripting": false,
          });
        }
        $httpClient.post(opts, (err, resp, body) => {
          if (!err && resp) {
            resp.body = body;
            resp.statusCode = resp.status;
          }
          callback(err, resp, body);
        });
      } else if (this.isQuanX()) {
        opts.method = "POST";
        if (this.isNeedRewrite) {
          opts.opts = opts.opts || {};
          Object.assign(opts.opts, {
            hints: false,
          });
        }
        $task.fetch(opts).then(
          (resp) => {
            const { statusCode: status, statusCode, headers, body } = resp;
            callback(
              null,
              {
                status,
                statusCode,
                headers,
                body,
              },
              body
            );
          },
          (err) => callback(err)
        );
      } else if (this.isNode()) {
        this.initGotEnv(opts);
        const { url, ..._opts } = opts;
        this.got.post(url, _opts).then(
          (resp) => {
            const { statusCode: status, statusCode, headers, body } = resp;
            callback(
              null,
              {
                status,
                statusCode,
                headers,
                body,
              },
              body
            );
          },
          (err) => {
            const { message: error, response: resp } = err;
            callback(error, resp, resp && resp.body);
          }
        );
      }
    }

    /**
     *
     * 示例:$.time('yyyy-MM-dd qq HH:mm:ss.S')
     *    :$.time('yyyyMMddHHmmssS')
     *    y:年 M:月 d:日 q:季 H:时 m:分 s:秒 S:毫秒
     *    其中y可选0-4位占位符、S可选0-1位占位符，其余可选0-2位占位符
     * @param {*} fmt 格式化参数
     *
     */
    time(fmt) {
      let o = {
        "M+": new Date().getMonth() + 1,
        "d+": new Date().getDate(),
        "H+": new Date().getHours(),
        "m+": new Date().getMinutes(),
        "s+": new Date().getSeconds(),
        "q+": Math.floor((new Date().getMonth() + 3) / 3),
        S: new Date().getMilliseconds(),
      };
      if (/(y+)/.test(fmt))
        fmt = fmt.replace(
          RegExp.$1,
          (new Date().getFullYear() + "").substr(4 - RegExp.$1.length)
        );
      for (let k in o)
        if (new RegExp("(" + k + ")").test(fmt))
          fmt = fmt.replace(
            RegExp.$1,
            RegExp.$1.length == 1
              ? o[k]
              : ("00" + o[k]).substr(("" + o[k]).length)
          );
      return fmt;
    }

    /**
     * 系统通知
     *
     * > 通知参数: 同时支持 QuanX 和 Loon 两种格式, EnvJs根据运行环境自动转换, Surge 环境不支持多媒体通知
     *
     * 示例:
     * $.msg(title, subt, desc, 'twitter://')
     * $.msg(title, subt, desc, { 'open-url': 'twitter://', 'media-url': 'https://github.githubassets.com/images/modules/open_graph/github-mark.png' })
     * $.msg(title, subt, desc, { 'open-url': 'https://bing.com', 'media-url': 'https://github.githubassets.com/images/modules/open_graph/github-mark.png' })
     *
     * @param {*} title 标题
     * @param {*} subt 副标题
     * @param {*} desc 通知详情
     * @param {*} opts 通知参数
     *
     */
    msg(title = name, subt = "", desc = "", opts) {
      const toEnvOpts = (rawopts) => {
        if (!rawopts) return rawopts;
        if (typeof rawopts === "string") {
          if (this.isLoon()) return rawopts;
          else if (this.isQuanX())
            return {
              "open-url": rawopts,
            };
          else if (this.isSurge())
            return {
              url: rawopts,
            };
          else return undefined;
        } else if (typeof rawopts === "object") {
          if (this.isLoon()) {
            let openUrl = rawopts.openUrl || rawopts.url || rawopts["open-url"];
            let mediaUrl = rawopts.mediaUrl || rawopts["media-url"];
            return {
              openUrl,
              mediaUrl,
            };
          } else if (this.isQuanX()) {
            let openUrl = rawopts["open-url"] || rawopts.url || rawopts.openUrl;
            let mediaUrl = rawopts["media-url"] || rawopts.mediaUrl;
            return {
              "open-url": openUrl,
              "media-url": mediaUrl,
            };
          } else if (this.isSurge()) {
            let openUrl = rawopts.url || rawopts.openUrl || rawopts["open-url"];
            return {
              url: openUrl,
            };
          }
        } else {
          return undefined;
        }
      };
      if (!this.isMute) {
        if (this.isSurge() || this.isLoon()) {
          $notification.post(title, subt, desc, toEnvOpts(opts));
        } else if (this.isQuanX()) {
          $notify(title, subt, desc, toEnvOpts(opts));
        }
      }
      if (!this.isMuteLog) {
        let logs = ["", "==============📣系统通知📣=============="];
        logs.push(title);
        subt ? logs.push(subt) : "";
        desc ? logs.push(desc) : "";
        console.log(logs.join("\n"));
        this.logs = this.logs.concat(logs);
      }
    }

    log(...logs) {
      if (logs.length > 0) {
        this.logs = [...this.logs, ...logs];
      }
      console.log(logs.join(this.logSeparator));
    }

    logErr(err, msg) {
      const isPrintSack = !this.isSurge() && !this.isQuanX() && !this.isLoon();
      if (!isPrintSack) {
        this.log("", `❗️${this.name}, 错误!`, err);
      } else {
        this.log("", `❗️${this.name}, 错误!`, err.stack);
      }
    }

    wait(time) {
      return new Promise((resolve) => setTimeout(resolve, time));
    }

    done(val = {}) {
      const endTime = new Date().getTime();
      const costTime = (endTime - this.startTime) / 1000;
      this.log("", `🔔${this.name}, 结束! 🕛 ${costTime} 秒`);
      this.log();
      if (this.isSurge() || this.isQuanX() || this.isLoon()) {
        $done(val);
      }
    }
  })(name, opts);
}
