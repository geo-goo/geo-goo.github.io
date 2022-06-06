---
layout:     post
title:      cash-flow mapping
date:       2020-10-16
author:     geo
catalog: true
tags:
    - Python
---

可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
```

现金流映射(cash-flow mapping) 目的在于映射到可用的节点计算其风险价值

一种将固定收益结构产品分解为每个债卷现金流量(风险因子)方法 , 
所有现金流的折现值映射到相同期限"等于0的风险因子"上

可以显示其现值与现金流的波动 , 且分配现金流到邻近的零息票息 (`adjacent zero-coupon`)

数据尽可能具有较好流动性 和 标准的期限

控制risk factor数目不会使得出现 `singular matrix` 和 `position` 等于 0 (`risk of zero`)

假如市场上出现了一个0.8年固定收益的产品,基于是新的资产,利用现金流映射至标准期限可使得风险值可视且确定现金流

以下介绍现金流分配的方法

# risk metrics map

J.P morgan 提出的方法

应用 john hull , technical note 25 书中例子

名目本金 1百万 (1,000,000) 0.8年后到期 半年付息一次 , 票息率10%

代表 0.3年 , 0.8年 两个现金流 , 但是市场的节点是 3个月 , 6个月 , 1年

`0.3`年的零息债卷映射到等值的`0.25`年与`0.5`年的零息债卷

`0.3`的零息债卷的现金流为 :

$$1,000,000 * 0.05 = 50,000$$

`0.8`年的零息债卷映射到等值的`0.5`年与`1`年的零息债卷

$$1,000,000 * 1.05 = 1,050,000$$

已知表格资讯如下 :

Table 1.1

| Maturity | 0.25Y | 0.5Y | 1Y |
| -------- | ----- | ---- | -- |
| Zero rate % | 5.50 | 6 | 7 |
| Bond price vol % | 0.06 | 0.1 | 0.2 | 
|
|

Table 1.2

| Correlation between daily return | 0.25Y | 0.5Y | 1Y |
| -------------------------------- | ----- | ---- | -- |
| 0.25Y | 1 | 0.9 | 0.6 |  
| 0.5Y |  0.9 | 1 | 0.7 |
| 1Y | 0.6 | 0.7 | 1 | 
|
|

利用Table 1.1 资讯用线性插值法 `linear interpolation` 求

`0.3`年与`0.8`年的波动率,分别得出 `0.00148` 与 `0.0016`

`0.3`年与`0.8`年的`zero rate`后计算其折现值 , 分别求出 `49190` , `997662` 

计算公式如下 :

$$\frac{cash\ flow}{(1+zero\ rate)^T}=present\ value \ at \ T \ time$$

$$\frac{1,050,000}{1.066^{0.8}}=997,662$$

已知现金流分配的公式 : 

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 非节点上的 p 年的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的现金流的比重

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

利用 Table 1.1 , table 1.2 资讯

计算其 $\alpha$ 

计算0.3年的现金流分配权重 :

$$0.00148^2 = 0.0006^2\alpha^2 + 0.001^2(1-\alpha)^2 + 2 * 0.0006 * 0.001 * 0.9 * \alpha * (1-\alpha)$$

计算0.8年的现金流分配权重 :

$$0.0016^2 = 0.001^2\alpha^2 + 0.002^2(1-\alpha)^2 + 2 * 0.001 * 0.002 * 0.7 * \alpha * (1-\alpha)$$

已知$\alpha_1$求根如下 : 

$$\alpha_1=\frac{-b \pm \sqrt{b^2-4ac}}{2a}$$

$$\alpha_2 = 1 - \alpha_1$$

根据 $ax^2+bx+c=0$

其中 :

$$x=\alpha_1$$

可得 :

$a$

> $\sigma_1^2-2\rho\sigma_1\sigma_2+\sigma_2^2$

$b$

> $2\rho\sigma_1\sigma_2-2\sigma_2^2$

$c$

> $\sigma_2^2-\sigma^2$

或者使用数值方法逼近结果 , 例如 `secant` , `newton` , `bisection` , 我使用数值方法逼近

获得对应的分配现金流权重后乘于标准期限的折现值

得出 :

Table 2 The Cash Flow Mapping Result

| -- | 50,000 received in 0.3Y | 50,000 received in 0.3Y | total | 
| -- | ----------------------- | ----------------------- | ----- |
| position in 3-month bond | 37,397 |  | 37,397
| position in 6-month bond | 11,793 | 319,589 | 331,382
| position in 1-year bond |  | 678,074 | 678,074
|
|

利用 Table 2 的值计算组合的风险值`VaR`

已知组合的标准差计算公式如下 :

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 组合的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的折现值

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

代入数值可得以下公式 :

$$0.0006^2*37397^2+0.001^2*331382^2+0.002^2*678074^2+2*0.9*0.0006*0.001*37397*331382+2*0.6*0.0006*0.002*37397*678074+2*0.7*0.001*0.002*331382*678074$$

经 `python` 验证得出 :

```python
0.0006**2*37397**2+0.001**2*331382**2+0.002**2*678074**2+2*0.9*0.0006*0.001*37397*331382+2*0.6*0.0006*0.002*37397*678074+2*0.7*0.001*0.002*331382*678074

>> 2628518.68392828

np.sqrt(2628518.68392828)

>> 1621.2707003854355
```

已知 : 

$$VaR = \sigma Z\sqrt T$$

其中 : 

$\sigma$

> 投资组合的波动率

$Z$

> 信心水准下的临界值(单尾)

$T$

> VaR of T-day 

计算 `10-day 99% VaR` :

$$1621.3*2.33*\sqrt{10}=11946$$

or about `11,950`

## 实验结果

如果考虑小数点位数很多其值 :

```
VaR = -11927
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 37396.6210299574 | 331381.44663577 | 678073.493870196 | 

# elementary map

依据 [3] paper 常作为基准指标来测试其他 map 的效果
$$\alpha_1=\frac{t_2-t}{t_2-t_1}$$

已知 : 

$$\alpha_1+\alpha_2=1$$

经化简后可得 :

$$\alpha_2=\frac{t-t_1}{t_2-t_1}$$

且 $r_t$ 的公式为 :

$$r_t=x\frac{t_1}{t}r_1+(1-x)\frac{t_2}{t}r_2$$

其中 :  

$x$

> $\frac{t_2-t}{t_2-t_1}$

$t_*$

> $\in [t_1,t_2]$

>  期限(年) , term

$r_*$

> interest rate

Remark : * 表示为任意变数 , 在此使用 * 为说明 $t_*$ 涵盖 $t_1$ , $t_2$ , $t$

求出 $r_t$ 后代入

$$P_t = e^{-r_tt}$$

可以因此求出 `term t` 的折现值

假设求VaR的过程可以使用 `Risk Metrics mapping` 的方法进行估计

则满足以下公式 :

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 组合的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的折现值

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

计算 $\sigma_p$ 后计算其 VaR : 

$$VaR = \sigma Z\sqrt T$$

其中 : 

$\sigma$

> 投资组合的波动率

$Z$

> 信心水准下的临界值(单尾)

$T$

> VaR of T-day 

应用 `risk metrics mapping` 的例子套用公式可获得

## 实验结果

```
VaR = -11235.3256037532
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 39344.0070376104 | 408452.237308081 | 597924.353323018 | 


<!-- - 问题在于说这个主要想要求什么,不是权重才是目的 ? 

> 权重求完后想要折现值才能求对应的现金流 , risk metrics $P_t$ 的折现值的利率是通过 `linear interpolation` 插值获得 -->

# rates map

> the result is obtained by interpolating interest rates 

因为这个理由所以我们称作为 `rates map`

$$r_t = x r_1 + (1-x) r_2$$

其中 :

$x=\frac{t_2-t}{t_2-t_1}$

> 单单只是计算公式 , 并非分配现金流权重

$r_*$

> interest rate

求出 $r_t$ 后代入

$$P_t = e^{-r_tt}$$

可以因此求出 `term t` 的折现值

$$\alpha_1=\frac{t}{t_1}\frac{t_2-t}{t_2-t_1}$$

$$\alpha_2=\frac{t}{t_2}\frac{t-t_1}{t_2-t_1}$$

这映射保留在标准期限的敏感度

且 : 

$$\alpha_1 + \alpha_2 \neq 1$$

<!-- Note also that the map is singular when $t_1$ = 0. A very short term rate for a period different from 0 shuold be chosen. -->

假设求VaR的过程可以使用 `Risk Metrics mapping` 的方法进行估计

则满足以下公式 :

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 组合的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的折现值

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

计算 $\sigma_p$ 后计算其 VaR : 

$$VaR = \sigma Z\sqrt T$$

其中 : 

$\sigma$

> 投资组合的波动率

$Z$

> 信心水准下的临界值(单尾)

$T$

> VaR of T-day 

## 实验结果

```
VaR = -11066.28824589
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 47221.7482898394 | 644406.552392661 | 478877.875392324 | 


# schaller's map

<!-- 与 `risk metrics` 用途一样为估计 $\sigma$ -->

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 非节点上的 p 年的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的现金流的比重

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

公式解如下:

$$\alpha_1=\frac{\sigma}{\sqrt{\sigma_1^2+\sigma_2^2\tau^2+2\sigma_1\sigma_2\rho\tau}}$$

$$\alpha_2=\frac{\sigma}{\sqrt{\frac{\sigma_1^2}{\tau^2}+\sigma_2^2+\frac{2\sigma_1\sigma_2\rho}{\tau}}}$$

其中 : 

$\tau$

> $\frac{t-t_1}{t_2-t}$

且 : 

$$\alpha_1 + \alpha_2 \neq 1$$

因为论文并没有提到零息利率的求解部分 , 我们皆使用线性插值获得

假设求VaR的过程可以使用 `Risk Metrics mapping` 的方法进行估计

则满足以下公式 :

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 组合的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的折现值

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

计算 $\sigma_p$ 后计算其 VaR : 

$$VaR = \sigma Z\sqrt T$$

其中 : 

$\sigma$

> 投资组合的波动率

$Z$

> 信心水准下的临界值(单尾)

$T$

> VaR of T-day 

## 实验结果

```
VaR = -11931.9675828255
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 40194.7982100037 | 433652.010326256 | 635404.966160633 | 


# polar coordinates map

`linear interpolation` 估计 $\sigma$ :

$$\sigma = \sigma_1 + \frac{t-t_1}{t_2-t_1}(\sigma_2-\sigma_1)$$

分配的现金流权重 : 

$$\alpha_1=\frac{\sin(x-\beta)}{\sqrt{1-\rho^2}}\frac{\sigma}{\sigma_1}$$

$$\alpha_2=\frac{\sin(\beta)}{\sqrt{1-\rho^2}}\frac{\sigma}{\sigma_2}$$

其中 : 

$x$

> $cos^{-1}(\rho)$

$\beta$

> $\frac{t-t_1}{t_2-t_1}x$

且 : 

$$\alpha_1 + \alpha_2 \neq 1$$

因为论文并没有提到零息利率的求解部分 , 我们皆使用线性插值获得

假设求VaR的过程可以使用 `Risk Metrics mapping` 的方法进行估计

则满足以下公式 :

$$\sigma_p^2 = \sum_{i=1}\sigma_i^2\alpha_i^2+\sum_{i=1}\sum_{i\neq j}\sigma_i\sigma_j\alpha_i\alpha_j\rho_{ij}$$

其中 : 

$\sigma_p$

> 组合的波动率

$\sigma_i$

> 第 i 年的波动率

$\alpha_i$

> 第 i 年的分配的折现值

$\rho_{ij}$

> 第 i 年与 j 年之间的相关性(correlation)

计算 $\sigma_p$ 后计算其 VaR : 

$$VaR = \sigma Z\sqrt T$$

其中 : 

$\sigma$

> 投资组合的波动率

$Z$

> 信心水准下的临界值(单尾)

$T$

> VaR of T-day 

<!-- ## polar coordinates map 问题

在于说 $\rho$ 要怎么计算出来 ? 是否为邻近两个标准期限之间的相关性 对的 因为只考虑左右边临近的零息债卷 所以 $\rho$ 只有一个值 -->

## 实验结果

```
VaR = -11944.4787215154
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 45152.2275017992 | 706128.971385928 | 513348.157058166 | 

# three dimensional map

需要估计两个vector 的协方差(covariance 共变异数)

$$\rho_i=1+\frac{t-t_i}{t_{1-i}-t_i}(\rho-1)$$

其中 : 

$t_{1-i}$

> 互倒 , 指的是 i = 1时 , $t_{1-i}$ 为 $t_2$

Remark : 上述的定义是我提出的解决方案 

`linear interpolation` 估计 $\sigma$ :

$$\sigma = \sigma_1+\frac{t-t_1}{t_2-t_1}(\sigma_2-\sigma_1)$$

$$\alpha_1=\frac{\sigma}{\sigma_1}(\frac{\rho_1-\rho_2\rho}{1-\rho^2})$$

$$\alpha_2=\frac{\sigma}{\sigma_2}(\frac{\rho_2-\rho_1\rho}{1-\rho^2})$$

且 : 

$$\alpha_1 + \alpha_2 \neq 1$$

因为论文并没有提到零息利率的求解部分 , 我们皆使用线性插值获得

<!-- # three dimensional map 问题

$\rho_i$ 是? 

有点问题 , 因为还没搞懂 three dimesional map 
建构问题 -->

## 实验结果

```
VaR = -11062.3423346661
```

现金流分配结果 : 

| 0.25 | 0.5 | 1.0|
| ---- | --- | -- |
| 44598.3178292928 | 645193.581530825 | 478877.875392324 |

# mapping 的排名与结果

根据 [3] paper 实验证明

To summarize, the various methods could be ranked as follows, with the best at the top.

1. rates mapping

2. elementary mapping

3. three dimensional mapping

4. polar coordinates mapping

5. schaller mapping

6. risk metrics mapping

(1) , (2) , (3) , (4) 由使风险因子多头的情况其实都是一样的 , 在 [3] paper 中作者排列是主观的 

`rates mapping` 最快速 , 结果最佳 且求取 $r_t$ 用论文[3] 的公式与做线性插值的结果是相容的 

`elementary` 相似

更多实验结果可以参考 `results/` 文件夹的资料

- 0.25-0.5 拆解权重
    - 0.25年与0.5年每项map的拆解权重状况

- 0.5-1.0 拆解权重 
    - 0.5年与1年每项map的拆解权重状况

- Value at Risk each map
    - 每项map的在险价值(VaR)

- 差异情况
    - 以 `elementary mapping` 为基准与其他mapping 相减做差异

- 现金流分配
    - 每项mapping 的现金流拆解状况

Remark : 风险因子多头涵盖的意义是尾部风险较风险因子空头小$^{[4]}$ , 所以合理假设作者使用风险因子多头作为指标

<!-- # 风险因子的意义在VaR 

因为很难估计全部金融工具的分布情况 , 这使得投资组合收益分布的推算成为整个VAR法中最重要也是最难解决的一个问题 -->

# 探讨

假设其中一个期限落在标准期限上其他并没有,那现金流在怎么设计呢?

以我个人经验而言,并没有这种情况,债卷不可能不定时的发放股息,所以只要到期日不是在标准期限上,全部现金流都皆在非节点上

# 问题

- 为什么5年的利率不能在市场直接观察? 提出的理由是bonds 是 fixed maturity , the standard risk factor have a fixed term

这个要看情况,取决于怎么定义这个问题

- fixed income 对于 risk metrics 的意义?

基于 fixed income struturce 作 cash flow mapping 

- cash flows 除了 fixed present value 还有那些啊?

cash flow 本身就是那个点上的值 没有分 fixed 或者  float

# References

[1] John Hull , TechnicalNote25.pdf

[2] J.P.Morgan/Reuters , RiskMetricsTM—Technical Document

[3] COMPARISONS OF CASHFLOW MAPS FOR VALUE-AT-RISK , MARC HENRARD.pdf

[4] https://zhuanlan.zhihu.com/p/103480336