---
layout:     post
title:      chapter 29 proof
date:       2022-05-08
author:     geo
catalog: true
tags:
    - tidy
    - john hull 
---

$$\frac{L\delta_k}{1+R_k\delta_k}\max{(R_k-R_K,0)}$$

$$ = \max{(\frac{L\delta_kR_k}{1+R_k\delta_k}-\frac{L\delta_kR_K}{1+R_k\delta_k},0)}$$

$$ = \max{(\frac{L\delta_kR_k-L\delta_kR_K}{1+R_k\delta_k},0)}$$

$$ = \max{(\frac{L\delta_kR_k-L\delta_kR_K+L-L}{1+R_k\delta_k},0)}$$

$$ = \max{(\frac{L\delta_kR_k+L-L-L\delta_kR_K}{1+R_k\delta_k},0)}$$

$$ = \max{(\frac{L(1+\delta_kR_k)-L(1+\delta_kR_K)}{1+R_k\delta_k},0)}$$

$$ = \max{(L - \frac{L(1+\delta_kR_K)}{1+R_k\delta_k},0)}$$


