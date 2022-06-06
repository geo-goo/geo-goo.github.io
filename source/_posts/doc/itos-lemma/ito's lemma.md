---
layout:     post
title:      ito's lemma
date:       2020-09-10 00:00:00 +0800
author:     GEo
catalog: true
tagS_t:
    - Financial
---

可使用下述程式碼把markdown格式轉成word

```
pandoc -o output.docx -f markdown -t docx input.md
```

# 基本性质

给定标底物的动态走势(随机方程式) $\Rightarrow$ 衍生品的随机方程式

# 推导过程

$F(S_t,t)$ 为标底物衍生品商品价格则透过`Ito's lemma` 可知该商品之价格变动过程 :

$$dF(S_t,t)=(\frac{\partial{F}}{\partial{t}}+\frac{\partial{F}}{\partial{S_t}}\mu{S_t}+\frac{1}{2}\frac{\partial^2{F}}{\partial{S_t^2}}\sigma^2S_t^2)\,dt+\frac{\partial{F}}{\partial{S_t}}\sigma{S_t}\,dW_t$$

Remark : 上述推导过程可参考附录

令 $F = ln(S_t)$ 则 $\frac{\partial{F}}{\partial{t}}=0$ , $\frac{\partial{F}}{\partial{S_t}}=\frac{1}{S_t}$ , $\frac{\partial^2{F}}{\partial{S_t^2}}=-\frac{1}{S_t^2}$ 整理上式可得: 

$$d\,lnS_t = (\frac{1}{S_t}\mu{S_t}-\frac{1}{2{S_t}^2}\sigma^2{S_t}^2)dt+\frac{1}{S_t}\sigma{S_t}dW_t$$

$$d\,lnS_t =(\mu-\frac{1}{2}\sigma^2)dt+\sigma{dW_t}$$

$$\int_0^Td\,lnS_t =\int_0^T(\mu-\frac{1}{2}\sigma^2)dt+\int_0^T\sigma{dW_t}$$

已知 $\int d\,(x) = x+c$ :

$$lnS_T-lnS_0 = (\mu-\frac{1}{2}\sigma^2)T+\sigma{W_T}$$

$$ln\frac{S_T}{S_0}=(\mu-\frac{1}{2}\sigma^2)T+\sigma{W_T}$$

$$\frac{S_T}{S_0}=e^{(\mu-\frac{1}{2}\sigma^2)T+\sigma{W_T}}$$

$$S_T=S_0e^{(\mu-\frac{1}{2}\sigma^2)T+\sigma{W_T}}$$

其中 $W_t$~$N(0,t)$ = $\varepsilon\sqrt{t}$~$N(0,1)$

$$S_T=S_0e^{(\mu-\frac{1}{2}\sigma^2)T+\sigma\varepsilon\sqrt{T}}$$

# 附录

$F(S_t,t)$ 为标底物衍生品商品价格

为简略描写将 $F(S_t,t)$ 替代成 $F(S,t)$ 过程如下 :

$$dF(S,t)=\frac{\partial{F}}{\partial{S}}dS+\frac{\partial{F}}{\partial{t}}dt+\frac{1}{2}\frac{\partial^2{F}}{\partial{S^2}}(dS)^2+\frac{1}{2}\frac{\partial^2{F}}{\partial{t^2}}(dt)^2+\frac{\partial^2{F}}{\partial{t}\partial{S}}(dt)(dS)+\ldots$$

已知 $dS = \mu{S}dt+\sigma{S}dW$ , $dt^2=0$ , $dWdt=0$ , $dW^2=dt$ 代入上式可得 :

$$dF(S_t,t)=(\frac{\partial{F}}{\partial{t}}+\frac{\partial{F}}{\partial{S_t}}\mu{S_t}+\frac{1}{2}\frac{\partial^2{F}}{\partial{S_t^2}}\sigma^2S_t^2)\,dt+\frac{\partial{F}}{\partial{S_t}}\sigma{S_t}\,dW_t$$

# 二元函数泰勒展开式

$$f(x,y) = f(x_0,y_0)+f^{\prime}_x(x_0,y_0)h+f^{\prime}_y(x_0,y_0)k+\frac{1}{2!}f^{\prime\prime}_x(x_0,y_0)h^2+\frac{1}{2!}f^{\prime\prime}_y(x_0,y_0)k^2+2\frac{1}{2!}f^{\prime\prime}_{xy}(x_0,y_0)hk+o(\rho)$$

其中 : 

$h = x-x_0$

$k = y-y_0$

$\rho=\sqrt{h^2+k^2}$ 且为佩亚偌余项

# 问题

$dW^2=dt$ 为什么呢?

> 因为$dW^2$ 为一直线所以等值于$dt$?