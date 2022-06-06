---
layout:     post
title:      chapter 29 negative rates
date:       2022-05-08
author:     geo
catalog: true
tags:
    - tidy
    - john hull 
---

# shifted lognormal model
(standard market model)

用於處理 swaption 估值出現負利率可能性

known , 

holder 有權利 pay
$$LA[S_FN(d_1)-S_kN(d_2)]$$

holder 有權利 received
$$LA[S_kN(-d_2)-S_FN(-d_1)]$$

$S_F = S_F + \alpha$

$S_k = S_k + \alpha$

其中 : 

$A = \frac{1}{m}\sum_{i=1}^{mn}P(0,T_i)$

# bachelier normal model

- 比 black scholes 古老的模型

- 没有考虑利率

- 假定股价而不是收益率服从正态分布

holder right pay

$$LA[(S_F-S_k)N(d)+\sigma^*\sqrt{T}N'(d)]$$

holder right receive

$$LA[(S_k-S_F)N(-d)+\sigma^*\sqrt{T}N'(d)]$$

其中 : 

$d = \frac{S_F-S_k}{\sigma^*\sqrt{T}}$

By the paper "on the option pricing formula based on the bachelier model"

$r \neq 0$

$$c_t = S_t - Ke^{-r(T-t)}\Phi(z)+\sigma\sqrt{\frac{1-e^{-2r(T-t)}}{2r}}\phi(z)$$

其中 : 

$z = \frac{S_t - ke^{-r(T-t)}}{\sigma\sqrt{\frac{1-e^{-2r(T-t)}}{2r}}}$

$r=0$

$$c_t = (S_t-k)\Phi(z) = \sigma\sqrt{T-t}\phi(z)$$

其中 : 

$z = \frac{S_t-k}{\sigma\sqrt{T-t}}$

對於 bachelier normal model 選擇權定價可以參考

- https://www.zybuluo.com/1007477689/note/1697864

- https://fincad.com/blog/interest-rate-models-and-negative-rates

- https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3428994

對於 bachelier normal model 選擇權例子可以參考

**基於 sabr model**
https://www.mathworks.com/help/fininst/normalvolbysabr.html
