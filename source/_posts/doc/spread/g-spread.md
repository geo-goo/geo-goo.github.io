---
layout:     post
title:      g spread
date:       2022-04-23
author:     geo
catalog: true
tags:
    - spread
    - cfa
---

<!-- 可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
``` -->

# G spread 定義
G-spread is the yield spread in basis point over interpolated government bond

# G spread 案例

A 5% annual coupon corporate bond with 3 years remaining to maturity is trading at 100.175 . the 3 year , 3% annual payment government benchmark bond is trading at 100.50 . the 1 year and 2 year goverment spot rates are 2.05% and 3.425% respectively . 

calculate the G-spread , the spread between the yields-to maturity on the corporate bond and the government bond having the same maturity.

根據 corporate bond 

PV = -100.175, PMT = 5 , FV = 100 , N = 3 , CPT I/Y = 4.936%

根據 government bond 

PV = -100.5 , PMT = 3 , FV = 100 , N = 3 , CPT I/Y = 2.824% 

So the g-spread is 4.936% - 2.824% = 2.11% or 211 bps

where : 

PV 

> 現值 

PMT 

> 每一期的現金流

FV

> 終值

N

> 年限(到期時間)

CPT I/Y

> the yield to maturity 

# references

[1] https://ift.world/booklets/fixed-income-introduction-to-fixed-income-valuation-part7/

