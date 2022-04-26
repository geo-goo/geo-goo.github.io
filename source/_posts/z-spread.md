---
layout:     post
title:      z spread
date:       2022-04-20
author:     geo
catalog: true
tags:
    - spread
---

<!-- 可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
``` -->

<!-- 一檔債券的到期收益率(Yield to maturity, YTM)可以拆成基準利率(Benchmark)與利差(Spread)兩部分，基準利率定義為投資者投資非公債時所預期的最小利率，如LIBOR或央行重貼現率等；而利差則有多種表達與衡量方式

簡單利差公式：利差＝債券殖利率(bond yield)－指標債券殖利率(benchmark yield) -->
<!-- 
如果此基準利率來自政府公債，則得到的便是「政府利差」(Government spread, G-Spread) -->
<!-- 
與其相似的還有T-Spread，差別在於G-Spread是採內插法(如20年期債剛好沒有對應的公債券次)，而T-Spread則以同年期券次計算
如果此基準利率來自為Swap rate(透過內插法)，則此利差稱為Interpolated spread,也就是 I-Spread

然而，以上的簡單利差方法都未能反映一件事：基準殖利率在各個年期未必都一樣，也就是說只有在殖利率曲線(Yield Curve)平坦或差異不大之情況才不致失真。為此，所謂的Zero-Volatility Spread (Z-spread)便應運而生，期透過設算債券各期現金流之折現值，使之與當前價格相等，回推隱含的利率，再扣除coupon便得到Z-Spread。 -->

# Z-spred 定義

- 折現利率是在spot rate的基礎上再增加Z-spread

- 計算債卷現值等於其市場價值

- Z spread 也稱爲靜態點差 , 因爲其在所有時期都是恆定的

$$P = \frac{c}{(1+z_1 + Z)^1}+\frac{c}{(1+z_2 + Z)^2}+...+\frac{c+p}{(1+z_n + Z)^n}$$

其中 : 

$p$

> principal

$c$

> coupon

$z_1$

> zero rate

$Z$

> z-spread

# Z spread 案例

CPA 一級題目

10-2-1 A corporate bond offers a 5% coupon rate and has exactly 3 years remaining to maturity. Interest is paid annually. The following rates are from the benchmark spot curve:

Time-to-Maturity Spot Rate

1 year          4.86%

2 years          4.95%

3 years          5.65%

The bond is currently trading at a Z-spread of 234 basis points. The value of the bond is closest to:

A. 92.38.

B. 98.35.

C. 106.56.

答案：A

```
import numpy as np

n = 3
p = 0
Z = 234/10000 # z spread
principal = 100
r = np.zeros(n)
r[0] = 4.86/100
r[1] = 4.95/100
r[2] = 5.65/100
c = 5*principal/100
for i in range(1,n+1):
    p += c / (1+r[i-1]+Z)**i
p += principal / (1+r[i-1]+Z)**i

print(p)

92.38333903585564
```
