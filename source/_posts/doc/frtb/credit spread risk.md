---
layout:     post
title:      credit spreak risk
date:       2021-04-08
author:     geo
catalog: true
tags:
    - Python
    - Financial
    - Term-structure
---
<!-- 
可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
``` -->


先判断三种信用价差属于哪一种? 

判断流程 : 

![](pic/csr.PNG)

# delta

## $S_k$的计算

对应的风险因子是信用利差曲线特定利率期限上的利率 , 信用利差风险 delta 的敏感性指标为金融工具i关于无风险收益率曲线特定期限点t的CS01

Remark : 如果利率曲线计算girr有考虑信用风险时,csr也要一起计算

$$S_{k,cs_t}=\frac{V_i(r_t , cs_t)-V_i(r_t,cs_t+0.0001)}{0.0001}$$

其中:

$r_t$

> 无风险收益率曲线上期限点t对应的无风险利率V

$cs_t$

> 信用价差曲线上期限点t对应的信用价差

$V_i$

> 金融工具的市值 , 其为无风险利率曲线和信用价差曲线的函数

期限点为 0.5年 , 1年 , 3年 , 5年 , 10年 

## 求得$S_k$后加权敏感度 : 

加权敏感度 : 

$$WS_k=RW_k * S_k$$

Remark : $RW_k$ , $\rho$ 和 $\gamma$ 可以参考 `frtb案例-geo.xlsx`

## 对于相同的风险组别的计算 :

对于相同的风险组别的计算 :

$$K_b=\sqrt{max\bigg(0,\sum_kWS_k^2+\sum_k\sum_{k\neq l}\rho_{kl}WS_kWS_l\bigg)}$$

## 对于跨风险组别的计算 : 

对于跨风险组别的计算 : 

delta的风险资本要求 :

$$\sqrt{\sum_b K_b^2 + \sum_b\sum_{c\neq b}\gamma_{bc}S_bS_c}$$

其中 : 

$S_b=\sum_k{WS_k}$ 基于风险组 b

$S_c=\sum_k{WS_k}$ 基于风险组 c 

Remark : 风险组别 b , c 只为代表两者是跨组别

假设$\sum_b K_b^2 + \sum_b\sum_{c\neq b}\gamma_{bc}S_bS_c<0$ 

对于 $S_b = \max\bigg[ \min\bigg(\sum_kWS_k,K_b\bigg) ,-K_b\bigg]$

对于 $S_c = \max\bigg[ \min\bigg(\sum_kWS_k,K_c\bigg) ,-K_c\bigg]$

再重新计算风险资本要求

# vega

根据 21.26-3

对于没有隐含波动率的ctp-sec, 不用计算`vega`风险资本要求 , 但是需要计算`delta`和`curvature`的风险资本要求

Remark : 但是并不是表示ctp-sec都是没有隐含波动率的,只是对于特定情况下ctp-sec没有隐含波动率的时可以这样处理

## $S_k$的计算

$vega$ 可认为估值函数v对于标的资产价格的波动率的一阶偏导数

$$v = \frac{\partial V}{\partial\sigma}=\lim_{h_k\to0}\frac{V(\sigma+h_k)-V(\sigma)}{h_k}$$

期权类产品的vega敏感度v可以定义为期权产品估值函数v对于标的资产价格波动率的一阶偏导数,衡量标的资产价格波动率的变化带来的期权估值的变化

FRTB框架下的$vega$ 

在FRTB计量框架下,针对给定风险类型,vega风险敏感性指标为希腊字母vega和对应期权隐含波动率的乘积 

$$S_k=vega * \sigma_i = \frac{\partial V_i}{\partial \sigma_i} * \sigma_i$$

其中:

$vega$

> 上式 $v$ 

$\sigma_i$ 

> 隐含波动率

Remark : i 是金融工具i , k 是 risk bucket

- 风险组别 `risk bucket` 与 delta 中 `risk bucket` 定义一样

- 流动性期限 liquidity horizon 

体现不同风险分类的非流动性与对冲难度的差异

流动性越高,流动期限越短 

| risk class | $LH_{risk\ class}$
| -- | -- |
| GIRR | 60 | 
| CSR non-securitisations | 60 |
| CSR securitisations (CTP) | 120 |
| CSR securitisations (non-CTP) | 120 |
| Equity (large cap) | 20 |
| Equity (small cap) | 60 | 
| commodity | 120 | 
| FX | 40 |
||

- 风险权重 (对于某个vega风险因子k)

$$RW_k=min\bigg\{RW_\sigma*\frac{\sqrt{LH_{risk\ class}}}{\sqrt{10}},100\%\bigg\}$$

其中: 

$RW_\sigma$

> 0.55

- $\rho_{kl}$ : bucket 内相关性

    -  GIRR : $\rho=min(\rho_{kl}\ option\ maturity * \rho_{kl}\ underlying\ maturity , 1)$

    - 非 GIRR : $\rho=min(\rho_{kl}\ option\ maturity * \rho_{kl}\ delta , 1)$

其中: 

$\rho_{kl}\ option\ maturity$

> $exp(-\alpha\frac{|T_k-T_j|}{min(T_k,T_j)})$

$\rho_{kl}\ underlying\ maturity$

> $exp(-\alpha\frac{|T_k^U-T_j^U|}{min(T_k^U,T^U_j)})$

$\rho_{kl}\ delta$

> delta 风险因子与 vega的风险因子之间的相关性

- $\gamma_{bc}$

> 在同一个资产大类(asset class)内部 , 不同buckets之间 , vega的$\gamma_{bc}$与 delta 一样 , 例如在GIRR的不同bucket之间 , $\gamma_{bc} = 0.5$

![](pic/vega.PNG)

Remark : 小于0.5年直接算0.5年 , 0.5~1 , 1~3 年才做 linear interpolation , 标准线性插值

根据时间做权重 , 如果是0.75年,0.5年与1年各占50%

## 求得$S_k$后加权敏感度 : 

$$WS_k=RW_k * S_k$$

## 对于相同的风险组别的计算 :

$$K_b=\sqrt{max\bigg(0,\sum_kWS_k^2+\sum_k\sum_{k\neq l}\rho_{kl}WS_kWS_l\bigg)}$$

## 对于跨风险组别的计算 : 

vega的风险资本要求 :

$$\sqrt{\sum_b K_b^2 + \sum_b\sum_{c\neq b}\gamma_{bc}S_bS_c}$$

其中 : 

$S_b=\sum_k{WS_k}$ 基于风险组 b

$S_c=\sum_k{WS_k}$ 基于风险组 c 

Remark : 风险组别 b , c 只为代表两者是跨组别

假设$\sum_b K_b^2 + \sum_b\sum_{c\neq b}\gamma_{bc}S_bS_c<0$ 

对于 $S_b = \max\bigg[ \min\bigg(\sum_kWS_k,K_b\bigg) ,-K_b\bigg]$

对于 $S_c = \max\bigg[ \min\bigg(\sum_kWS_k,K_c\bigg) ,-K_c\bigg]$

再重新计算风险资本要求

<!-- # curvature

根据`21.100`  适用于

在计算同一风险组内的`curvature` ， 凸度风险相关系数 = `delta`相关系数的平方 -->