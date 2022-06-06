---
layout:     post
title:      frtb
date:       2020-09-26
author:     GEo
catalog: true
tags:
    - Python
    - Financial
---

可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
```

培训三天整理的笔记

# 录制影片整理

`frtb-2` 23.17 才是正式开始 前面都是讨论与补充实施在大中小型银行的难处以及要考虑的点 

# 摘要

Fundamental Review of the traning book , 简称为 `FRTB`

一种规范基于实践上考虑,非考虑实验环境

计量会牵涉到 `risk factor`

a银行定义的风险与b银行定义的风险实施不一样

衡量风险管理以及资本充足

评估市场风险以及资本金,衡量两者之间的平衡

考虑风险存钱以及考虑把钱移出去赚更多的钱之间计算一个金额

巴塞尔资本协定

为什么需要frtb , 在美国金融风暴后, 认识到后尾是不可以忽略的 

VaR 是使用过去的历史数据计算的 , 不满足struc VaR? , 于是产生 struc VaR 的

后尾考虑不周 所以对于计算出来的VaR不够结构化 监管烦恼的一点

(猜的)对于不同的 portfolio 计算出来的VaR 都不同

大型银行都做 Struc VaR 

# coherent risk measure  

中文翻译为 `一致性风险测度`

两个 position 叠加情况发生

期望保证现金第一步? 加大到两倍?

风险分散化 

只做股票的VaR 与 只做债卷的VaR 相加起来小

# Struc VaR

全名是 structural VaR , 简称 SVaR

与VaR具有很多硬性的规定

(何) 与VaR计算方法一样 但是对于区间的取值敏感 (尚未完善)

VaR 本身不是一个好的 risk measure 

# banking book vs trading book 

两个的区分 , FRTB 有严格的区分标准 

# market risk capital

<!-- # credit

# market -->

# ES

expected shortfall

因为后尾效应 

# CVaR

conditional value at risk 

<!-- # IRC

# CVA

# operational

# tenor basis spread

# sensitivities-based risk charge -->


# 更新 frtb 原因

了解 base2/2.5 VaR 与 Stressed VaR 不足 , 包括 inconsistent risk measure , heavy tail

1. jump to default

2. incremental risk charge and incremental default risk

3. 

# sa

standardiesd approach

1. 

# girr 

## 一般利率风险

###  delta 

#### 只有一条 curve

#### 一条 curve 以上 （以2条不同curve为例,但都在同一个风险组别)

### vega

### curvature 

# SBA or SBM?

$$SBA=K_{delta} + K_{vega} + K_{curvature}$$

需要区分 `risk class` 以及参考表格以获得

## $K_{delta}$

同一个风险组别在同一个 $K_b$

## $K_{vega}$

## $K_{curvature}$

# 问题

1. 标准法是 一定要的 , 内模法可以不要 

2. 

# References

[1] FRTB 培训文件

[2] https://en.wikipedia.org/wiki/Coherent_risk_measure

[3] FRTB - steven


