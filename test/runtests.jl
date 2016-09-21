using Base.Test
using Rmath
using Compat

srand(124)

function allEq(target::Vector{Float64}, current::Vector{Float64}, tolerance::Float64)
    @test length(target) == length(current)
    if all(target == current)
        return true
    end
    xy = @compat mean(abs.(target .- current))
    xn = @compat mean(abs.(target))
    if (isfinite(xn) && xn > tolerance)
        xy /= xn
    end
    @test xy < tolerance
    return true
end

allEq(target::Vector{Float64}, current::Vector{Float64}) =
    allEq(target, current, sqrt(eps()))

# dbeta
@test abs(dbeta(-1, 1, 1) - 0.0) < 10e-8
@test abs(dbeta(0, 1, 1) - 1.0) < 10e-8
@test abs(dbeta(1, 1, 1) - 1.0) < 10e-8

# dbinom
@test abs(dbinom(0, 2, 0.5) - 0.25) < 10e-8
@test abs(dbinom(1, 2, 0.5) - 0.5) < 10e-8
@test abs(dbinom(2, 2, 0.5) - 0.25) < 10e-8

# dcauchy
@test abs(dcauchy(0, 0, 1) - (1 / pi) * (1 / ((0 - 0)^2 + 1^2))) < 10e-8
@test abs(dcauchy(0, 1, 2) - (1 / pi) * (2 / ((0 - 1)^2 + 2^2))) < 10e-8

# dchisq
@test abs(dchisq(1, 1) - let x = 1; k = 1; (x^((k / 2) - 1) * exp(-(x / 2))) / (2^(k / 2) * gamma(k / 2)) end) < 10e-8
@test abs(dchisq(2, 3) - let x = 2; k = 3; (x^((k / 2) - 1) * exp(-(x / 2))) / (2^(k / 2) * gamma(k / 2)) end) < 10e-8

# dexp
@test abs(dexp(1, 2) - (1 / 2) * exp(-(1 / 2) * 1)) < 10e-8
@test abs(dexp(1, 3) - (1 / 3) * exp(-(1 / 3) * 1)) < 10e-8
@test abs(dexp(2, 3) - (1 / 3) * exp(-(1 / 3) * 2)) < 10e-8

const n = 26

const Rbeta	  = rbeta(n, .8, 2)
const Rbinom	  = rbinom(n, 55, pi/16)
const Rcauchy     = rcauchy(n, 12, 2)
const Rchisq	  = rchisq(n, 3)
const Rexp	  = rexp(n, 2)
const Rf	  = rf(n, 12, 6)
const Rgamma	  = rgamma(n, 2, 5)
const Rgeom	  = rgeom(n, pi/16)
const Rhyper	  = rhyper(n, 40, 30, 20)
const Rlnorm	  = rlnorm(n, -1, 3)
const Rlogis	  = rlogis(n, 12, 2)
const Rnbinom     = rnbinom(n, 7, .01)
const Rnorm	  = rnorm(n, -1, 3)
const Rpois	  = rpois(n, 12)
const Rsignrank   = rsignrank(n, 47)
const Rt	  = rt(n, 11)
## Rt2 below (to preserve the following random numbers!)
const Runif	  = runif(n, .2, 2)
const Rweibull    = rweibull(n, 3, 2)
const Rwilcox     = rwilcox(n, 13, 17)
const Rt2	  = rt(n, 1.01)

const Pbeta	  = @compat pbeta.(Rbeta, .8, 2)
const Pbinom	  = @compat pbinom.(Rbinom, 55, pi/16)
const Pcauchy     = @compat pcauchy.(Rcauchy, 12, 2)
const Pchisq	  = @compat pchisq.(Rchisq, 3)
const Pexp	  = @compat pexp.(Rexp, 2)
const Pf	  = @compat pf.(Rf, 12, 6)
const Pgamma	  = @compat pgamma.(Rgamma, 2, 5)
const Pgeom	  = @compat pgeom.(Rgeom, pi/16)
const Phyper	  = @compat phyper.(Rhyper, 40, 30, 20)
const Plnorm	  = @compat plnorm.(Rlnorm, -1, 3)
const Plogis	  = @compat plogis.(Rlogis, 12, 2)
const Pnbinom     = @compat pnbinom.(Rnbinom, 7, .01)
const Pnorm	  = @compat pnorm.(Rnorm, -1, 3)
const Ppois	  = @compat ppois.(Rpois, 12)
const Psignrank   = @compat psignrank.(Rsignrank, 47)
const Pt	  = @compat pt.(Rt, 11)
const Pt2	  = @compat pt.(Rt2, 1.01)
const Punif	  = @compat punif.(Runif, .2, 2)
const Pweibull    = @compat pweibull.(Rweibull, 3, 2)
const Pwilcox     = @compat pwilcox.(Rwilcox, 13, 17)

@compat dbeta.(Rbeta, .8, 2)
@compat dbinom.(Rbinom, 55, pi/16)
@compat dcauchy.(Rcauchy, 12, 2)
@compat dchisq.(Rchisq, 3)
@compat dexp.(Rexp, 2)
@compat df.(Rf, 12, 6)
@compat dgamma.(Rgamma, 2, 5)
@compat dgeom.(Rgeom, pi/16)
@compat dhyper.(Rhyper, 40, 30, 20)
@compat dlnorm.(Rlnorm, -1, 3)
@compat dlogis.(Rlogis, 12, 2)
@compat dnbinom.(Rnbinom, 7, .01)
@compat dnorm.(Rnorm, -1, 3)
@compat dpois.(Rpois, 12)
@compat dsignrank.(Rsignrank, 47)
@compat dt.(Rt, 11)
@compat dunif.(Runif, .2, 2)
@compat dweibull.(Rweibull, 3, 2)
@compat dwilcox.(Rwilcox, 13, 17)

## Check q*(p*(.)) = identity
@compat allEq(Rbeta,	  qbeta.(Pbeta, .8, 2))
@compat allEq(Rbinom,	  qbinom.(Pbinom, 55, pi/16))
@compat allEq(Rcauchy,	  qcauchy.(Pcauchy, 12, 2))
@compat allEq(Rchisq,	  qchisq.(Pchisq, 3))
@compat allEq(Rexp,	  qexp.(Pexp, 2))
@compat allEq(Rf,	  qf.(Pf, 12, 6))
@compat allEq(Rgamma,	  qgamma.(Pgamma, 2, 5))
@compat allEq(Rgeom,	  qgeom.(Pgeom, pi/16))
@compat allEq(Rhyper,	  qhyper.(Phyper, 40, 30, 20))
@compat allEq(Rlnorm,	  qlnorm.(Plnorm, -1, 3))
@compat allEq(Rlogis,	  qlogis.(Plogis, 12, 2))
@compat allEq(Rnbinom,	  qnbinom.(Pnbinom, 7, .01))
@compat allEq(Rnorm,	  qnorm.(Pnorm, -1, 3))
@compat allEq(Rpois,	  qpois.(Ppois, 12))
@compat allEq(Rsignrank,  qsignrank.(Psignrank, 47))
@compat allEq(Rt,	  qt.(Pt,	11))
@compat allEq(Rt2,	  qt.(Pt2, 1.01), 1e-2)
@compat allEq(Runif,	  qunif.(Punif, .2, 2))
@compat allEq(Rweibull,   qweibull.(Pweibull, 3, 2))
@compat allEq(Rwilcox,	  qwilcox.(Pwilcox, 13, 17))

## Same with "upper tail":
@compat allEq(Rbeta,	  qbeta.(1 .- Pbeta, .8, 2, false))
@compat allEq(Rbinom,	  qbinom.(1 .- Pbinom, 55, pi/16, false))
@compat allEq(Rcauchy,	  qcauchy.(1 .- Pcauchy, 12, 2, false))
@compat allEq(Rchisq,	  qchisq.(1 .- Pchisq, 3, false))
@compat allEq(Rexp,	  qexp.(1 .- Pexp, 2, false))
@compat allEq(Rf,	  qf.(1 .- Pf, 12, 6, false))
@compat allEq(Rgamma,	  qgamma.(1 .- Pgamma, 2, 5, false))
@compat allEq(Rgeom,	  qgeom.(1 .- Pgeom, pi/16, false))
@compat allEq(Rhyper,	  qhyper.(1 .- Phyper, 40, 30, 20, false))
@compat allEq(Rlnorm,	  qlnorm.(1 .- Plnorm, -1, 3, false))
@compat allEq(Rlogis,	  qlogis.(1 .- Plogis, 12, 2, false))
@compat allEq(Rnbinom,	  qnbinom.(1 .- Pnbinom, 7, .01, false))
@compat allEq(Rnorm,	  qnorm.(1 .- Pnorm, -1, 3,false))
@compat allEq(Rpois,	  qpois.(1 .- Ppois, 12, false))
@compat allEq(Rsignrank,  qsignrank.(1 .- Psignrank, 47, false))
@compat allEq(Rt,	  qt.(1 .- Pt,  11,   false))
@compat allEq(Rt2,	  qt.(1 .- Pt2, 1.01, false), 1e-2)
@compat allEq(Runif,	  qunif.(1 .- Punif, .2, 2, false))
@compat allEq(Rweibull,   qweibull.(1 .- Pweibull, 3, 2, false))
@compat allEq(Rwilcox,	  qwilcox.(1 .- Pwilcox, 13, 17, false))

## Check q*(p* ( log ), log) = identity
@compat allEq(Rbeta,	  qbeta.(log.(Pbeta), .8, 2, true, true))
@compat allEq(Rbinom,	  qbinom.(log.(Pbinom), 55, pi/16, true, true))
@compat allEq(Rcauchy,	  qcauchy.(log.(Pcauchy), 12, 2, true, true))
@compat allEq(Rchisq,     qchisq.(log.(Pchisq), 3, true, true), 1e-14)
@compat allEq(Rexp,	  qexp.(log.(Pexp), 2, true, true))
@compat allEq(Rf,	  qf.(log.(Pf), 12, 6, true, true))
@compat allEq(Rgamma,	  qgamma.(log.(Pgamma), 2, 5, true, true))
@compat allEq(Rgeom,	  qgeom.(log.(Pgeom), pi/16, true, true))
@compat allEq(Rhyper,	  qhyper.(log.(Phyper), 40, 30, 20, true, true))
@compat allEq(Rlnorm,	  qlnorm.(log.(Plnorm), -1, 3, true, true))
@compat allEq(Rlogis,	  qlogis.(log.(Plogis), 12, 2, true, true))
@compat allEq(Rnbinom,	  qnbinom.(log.(Pnbinom), 7, .01, true, true))
@compat allEq(Rnorm,	  qnorm.(log.(Pnorm), -1, 3, true, true))
@compat allEq(Rpois,	  qpois.(log.(Ppois), 12, true, true))
@compat allEq(Rsignrank,  qsignrank.(log.(Psignrank), 47, true, true))
@compat allEq(Rt,	  qt.(log.(Pt), 11, true, true))
@compat allEq(Rt2,	  qt.(log.(Pt2), 1.01, true, true), 1e-2)
@compat allEq(Runif,	  qunif.(log.(Punif), .2, 2, true, true))
@compat allEq(Rweibull,   qweibull.(log.(Pweibull), 3, 2, true, true))
@compat allEq(Rwilcox,	  qwilcox.(log.(Pwilcox), 13, 17, true, true))

## same q*(p* (log) log) with upper tail:
@compat allEq(Rbeta,	  qbeta.(log.(1 .- Pbeta), .8, 2, false, true))
@compat allEq(Rbinom,	  qbinom.(log.(1 .- Pbinom), 55, pi/16, false, true))
@compat allEq(Rcauchy,	  qcauchy.(log.(1 .- Pcauchy), 12, 2, false, true))
@compat allEq(Rchisq,	  qchisq.(log.(1 .- Pchisq), 3, false, true))
@compat allEq(Rexp,	  qexp.(log.(1 .- Pexp), 2, false, true))
@compat allEq(Rf,	  qf.(log.(1 .- Pf), 12, 6, false, true))
@compat allEq(Rgamma,	  qgamma.(log.(1 .- Pgamma), 2, 5, false, true))
@compat allEq(Rgeom,	  qgeom.(log.(1 .- Pgeom), pi/16, false, true))
@compat allEq(Rhyper,	  qhyper.(log.(1 .- Phyper), 40, 30, 20, false, true))
@compat allEq(Rlnorm,	  qlnorm.(log.(1 .- Plnorm), -1, 3, false, true))
@compat allEq(Rlogis,	  qlogis.(log.(1 .- Plogis), 12, 2, false, true))
@compat allEq(Rnbinom,	  qnbinom.(log.(1 .- Pnbinom), 7, .01, false, true))
@compat allEq(Rnorm,	  qnorm.(log.(1 .- Pnorm), -1, 3, false, true))
@compat allEq(Rpois,	  qpois.(log.(1 .- Ppois), 12, false, true))
@compat allEq(Rsignrank,  qsignrank.(log.(1 .- Psignrank), 47, false, true))
@compat allEq(Rt,	  qt.(log.(1 .- Pt ), 11,   false, true))
@compat allEq(Rt2,	  qt.(log.(1 .- Pt2), 1.01, false, true), 1e-2)
@compat allEq(Runif,	  qunif.(log.(1 .- Punif), .2, 2, false, true))
@compat allEq(Rweibull,   qweibull.(log.(1 .- Pweibull), 3, 2, false, true))
@compat allEq(Rwilcox,	  qwilcox.(log.(1 .- Pwilcox), 13, 17, false, true))

## Test if srand working correctly
srand(124)
allEq(Rbeta, rbeta(n, .8, 2))
allEq(Rbinom, rbinom(n, 55, pi/16))
allEq(Rcauchy, rcauchy(n, 12, 2))
allEq(Rchisq, rchisq(n, 3))
allEq(Rexp, rexp(n, 2))
allEq(Rf, rf(n, 12, 6))
allEq(Rgamma, rgamma(n, 2, 5))
allEq(Rgeom, rgeom(n, pi/16))
allEq(Rhyper, rhyper(n, 40, 30, 20))
allEq(Rlnorm, rlnorm(n, -1, 3))
allEq(Rlogis, rlogis(n, 12, 2))
allEq(Rnbinom, rnbinom(n, 7, .01))
allEq(Rnorm, rnorm(n, -1, 3))
allEq(Rpois, rpois(n, 12))
allEq(Rsignrank, rsignrank(n, 47))
