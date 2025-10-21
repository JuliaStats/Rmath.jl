import Aqua
using Random, Rmath, Statistics, Test

Random.seed!(124)

function allEq(target::Vector{Float64}, current::Vector{Float64}, tolerance::Float64)
    @test length(target) == length(current)
    if all(target == current)
        return true
    end
    xy = mean(abs.(target .- current))
    xn = mean(abs.(target))
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

# define gammaR from Rmath to avoid introducing dependency on SpecialFunctions
# where gamma is located starting with Julia 0.7
gammaR(x::Float64) = ccall((:gammafn, Rmath.libRmath), Float64, (Float64,), x)

# dchisq
@test abs(dchisq(1, 1) - let x = 1; k = 1; (x^((k / 2) - 1) * exp(-(x / 2))) / (2^(k / 2) * gammaR(k / 2)) end) < 10e-8
@test abs(dchisq(2, 3) - let x = 2; k = 3; (x^((k / 2) - 1) * exp(-(x / 2))) / (2^(k / 2) * gammaR(k / 2)) end) < 10e-8

# dexp
@test abs(dexp(1, 2) - (1 / 2) * exp(-(1 / 2) * 1)) < 10e-8
@test abs(dexp(1, 3) - (1 / 3) * exp(-(1 / 3) * 1)) < 10e-8
@test abs(dexp(2, 3) - (1 / 3) * exp(-(1 / 3) * 2)) < 10e-8

const n = 26

const Rbeta     = [rbeta(.8, 2) for _ in 1:n]
const Rbinom    = [rbinom(55, pi/16) for _ in 1:n]
const Rcauchy   = [rcauchy(12, 2) for _ in 1:n]
const Rchisq    = [rchisq(3) for _ in 1:n]
const Rexp      = [rexp(2) for _ in 1:n]
const Rf        = [rf(12, 6) for _ in 1:n]
const Rgamma    = [rgamma(2, 5) for _ in 1:n]
const Rgeom     = [rgeom(pi/16) for _ in 1:n]
const Rhyper    = [rhyper(40, 30, 20) for _ in 1:n]
const Rlnorm    = [rlnorm(-1, 3) for _ in 1:n]
const Rlogis    = [rlogis(12, 2) for _ in 1:n]
const Rnbinom   = [rnbinom(7, .01) for _ in 1:n]
const Rnorm     = [rnorm(-1, 3) for _ in 1:n]
const Rpois     = [rpois(12) for _ in 1:n]
const Rsignrank = [rsignrank(47) for _ in 1:n]
const Rt        = [rt(11) for _ in 1:n]
## Rt2 below (to preserve the following random numbers!)
const Runif     = [runif(.2, 2) for _ in 1:n]
const Rweibull  = [rweibull(3, 2) for _ in 1:n]
const Rwilcox   = [rwilcox(13, 17) for _ in 1:n]
const Rt2       = [rt(1.01) for _ in 1:n]
const Rnt       = [rnorm(2.1, 1) / sqrt(rchisq(11) / 11) for _ in 1:n]
const Rnt2      = [rnorm(-1.5, 1) / sqrt(rchisq(1.01) / 1.01) for _ in 1:n]
const Rtukey    = map(1:n) do _
    minz, maxz = extrema(rnorm(0, 1) for _ in 1:10)
    return 3 * (maxz - minz) / sqrt(rchisq(3))
end

const Pbeta     = pbeta.(Rbeta, .8, 2)
const Pbinom    = pbinom.(Rbinom, 55, pi/16)
const Pcauchy   = pcauchy.(Rcauchy, 12, 2)
const Pchisq    = pchisq.(Rchisq, 3)
const Pexp      = pexp.(Rexp, 2)
const Pf        = pf.(Rf, 12, 6)
const Pgamma    = pgamma.(Rgamma, 2, 5)
const Pgeom     = pgeom.(Rgeom, pi/16)
const Phyper    = phyper.(Rhyper, 40, 30, 20)
const Plnorm    = plnorm.(Rlnorm, -1, 3)
const Plogis    = plogis.(Rlogis, 12, 2)
const Pnbinom   = pnbinom.(Rnbinom, 7, .01)
const Pnorm     = pnorm.(Rnorm, -1, 3)
const Pnt       = pnt.(Rnt, 11, 2.1)
const Pnt2      = pnt.(Rnt2, 1.01, -1.5)
const Ppois     = ppois.(Rpois, 12)
const Psignrank = psignrank.(Rsignrank, 47)
const Pt        = pt.(Rt, 11)
const Pt2       = pt.(Rt2, 1.01)
const Ptukey    = ptukey.(Rtukey, 10, 3)
const Punif     = punif.(Runif, .2, 2)
const Pweibull  = pweibull.(Rweibull, 3, 2)
const Pwilcox   = pwilcox.(Rwilcox, 13, 17)

## Check q*(p*(.)) = identity
allEq(Rbeta,      qbeta.(Pbeta, .8, 2))
allEq(Rbinom,      qbinom.(Pbinom, 55, pi/16))
allEq(Rcauchy,      qcauchy.(Pcauchy, 12, 2))
allEq(Rchisq,      qchisq.(Pchisq, 3))
allEq(Rexp,      qexp.(Pexp, 2))
allEq(Rf,      qf.(Pf, 12, 6))
allEq(Rgamma,      qgamma.(Pgamma, 2, 5))
allEq(Rgeom,      qgeom.(Pgeom, pi/16))
allEq(Rhyper,      qhyper.(Phyper, 40, 30, 20))
allEq(Rlnorm,      qlnorm.(Plnorm, -1, 3))
allEq(Rlogis,      qlogis.(Plogis, 12, 2))
allEq(Rnbinom,      qnbinom.(Pnbinom, 7, .01))
allEq(Rnorm,      qnorm.(Pnorm, -1, 3))
allEq(Rnt,      qnt.(Pnt, 11, 2.1))
allEq(Rnt2,      qnt.(Pnt2, 1.01, -1.5))
allEq(Rpois,      qpois.(Ppois, 12))
allEq(Rsignrank,  qsignrank.(Psignrank, 47))
allEq(Rt,      qt.(Pt,    11))
allEq(Rt2,      qt.(Pt2, 1.01), 1e-2)
allEq(Rtukey,      qtukey.(Ptukey, 10, 3))
allEq(Runif,      qunif.(Punif, .2, 2))
allEq(Rweibull,   qweibull.(Pweibull, 3, 2))
allEq(Rwilcox,      qwilcox.(Pwilcox, 13, 17))

## Same with "upper tail":
allEq(Rbeta,      qbeta.(1 .- Pbeta, .8, 2, false))
allEq(Rbinom,      qbinom.(1 .- Pbinom, 55, pi/16, false))
allEq(Rcauchy,      qcauchy.(1 .- Pcauchy, 12, 2, false))
allEq(Rchisq,      qchisq.(1 .- Pchisq, 3, false))
allEq(Rexp,      qexp.(1 .- Pexp, 2, false))
allEq(Rf,      qf.(1 .- Pf, 12, 6, false))
allEq(Rgamma,      qgamma.(1 .- Pgamma, 2, 5, false))
allEq(Rgeom,      qgeom.(1 .- Pgeom, pi/16, false))
allEq(Rhyper,      qhyper.(1 .- Phyper, 40, 30, 20, false))
allEq(Rlnorm,      qlnorm.(1 .- Plnorm, -1, 3, false))
allEq(Rlogis,      qlogis.(1 .- Plogis, 12, 2, false))
allEq(Rnbinom,      qnbinom.(1 .- Pnbinom, 7, .01, false))
allEq(Rnorm,      qnorm.(1 .- Pnorm, -1, 3,false))
allEq(Rnt,      qnt.(1 .- Pnt, 11, 2.1, false))
allEq(Rnt2,      qnt.(1 .- Pnt2, 1.01, -1.5, false))
allEq(Rpois,      qpois.(1 .- Ppois, 12, false))
allEq(Rsignrank,  qsignrank.(1 .- Psignrank, 47, false))
allEq(Rt,      qt.(1 .- Pt,  11,   false))
allEq(Rt2,      qt.(1 .- Pt2, 1.01, false), 1e-2)
allEq(Rtukey,      qtukey.(1 .- Ptukey, 10, 3, 1, false))
allEq(Runif,      qunif.(1 .- Punif, .2, 2, false))
allEq(Rweibull,   qweibull.(1 .- Pweibull, 3, 2, false))
allEq(Rwilcox,      qwilcox.(1 .- Pwilcox, 13, 17, false))

const logPbinom = pbinom.(Rbinom, 55, pi/16, true, true)
const logPnbinom = pnbinom.(Rnbinom, 7, .01, true, true)
const logPpois = ppois.(Rpois, 12, true, true)
const logcPbinom = pbinom.(Rbinom, 55, pi/16, false, true)
const logcPnbinom = pnbinom.(Rnbinom, 7, .01, false, true)
const logcPpois = ppois.(Rpois, 12, false, true)


## Check q*(p* ( log ), log) = identity
allEq(Rbeta,      qbeta.(log.(Pbeta), .8, 2, true, true))
allEq(Rbinom,      qbinom.(logPbinom, 55, pi/16, true, true))
allEq(Rcauchy,      qcauchy.(log.(Pcauchy), 12, 2, true, true))
allEq(Rchisq,     qchisq.(log.(Pchisq), 3, true, true), 1e-14)
allEq(Rexp,      qexp.(log.(Pexp), 2, true, true))
allEq(Rf,      qf.(log.(Pf), 12, 6, true, true))
allEq(Rgamma,      qgamma.(log.(Pgamma), 2, 5, true, true))
allEq(Rgeom,      qgeom.(log.(Pgeom), pi/16, true, true))
allEq(Rhyper,      qhyper.(log.(Phyper), 40, 30, 20, true, true))
allEq(Rlnorm,      qlnorm.(log.(Plnorm), -1, 3, true, true))
allEq(Rlogis,      qlogis.(log.(Plogis), 12, 2, true, true))
allEq(Rnbinom,      qnbinom.(logPnbinom, 7, .01, true, true))
allEq(Rnorm,      qnorm.(log.(Pnorm), -1, 3, true, true))
allEq(Rnt,      qnt.(log.(Pnt), 11, 2.1, true, true))
allEq(Rnt2,      qnt.(log.(Pnt2), 1.01, -1.5, true, true))
allEq(Rpois,      qpois.(logPpois, 12, true, true))
allEq(Rsignrank,  qsignrank.(log.(Psignrank), 47, true, true))
allEq(Rt,      qt.(log.(Pt), 11, true, true))
allEq(Rt2,      qt.(log.(Pt2), 1.01, true, true), 1e-2)
allEq(Rtukey,      qtukey.(log.(Ptukey), 10, 3, 1, true, true))
allEq(Runif,      qunif.(log.(Punif), .2, 2, true, true))
allEq(Rweibull,   qweibull.(log.(Pweibull), 3, 2, true, true))
allEq(Rwilcox,      qwilcox.(log.(Pwilcox), 13, 17, true, true))

## same q*(p* (log) log) with upper tail:
allEq(Rbeta,      qbeta.(log.(1 .- Pbeta), .8, 2, false, true))
allEq(Rbinom,      qbinom.(logcPbinom, 55, pi/16, false, true))
allEq(Rcauchy,      qcauchy.(log.(1 .- Pcauchy), 12, 2, false, true))
allEq(Rchisq,      qchisq.(log.(1 .- Pchisq), 3, false, true))
allEq(Rexp,      qexp.(log.(1 .- Pexp), 2, false, true))
allEq(Rf,      qf.(log.(1 .- Pf), 12, 6, false, true))
allEq(Rgamma,      qgamma.(log.(1 .- Pgamma), 2, 5, false, true))
allEq(Rgeom,      qgeom.(log.(1 .- Pgeom), pi/16, false, true))
allEq(Rhyper,      qhyper.(log.(1 .- Phyper), 40, 30, 20, false, true))
allEq(Rlnorm,      qlnorm.(log.(1 .- Plnorm), -1, 3, false, true))
allEq(Rlogis,      qlogis.(log.(1 .- Plogis), 12, 2, false, true))
allEq(Rnbinom,      qnbinom.(logcPnbinom, 7, .01, false, true))
allEq(Rnorm,      qnorm.(log.(1 .- Pnorm), -1, 3, false, true))
allEq(Rnt,      qnt.(log1p.(.-Pnt), 11, 2.1, false, true))
allEq(Rnt2,      qnt.(log1p.(.-Pnt2), 1.01, -1.5, false, true))
allEq(Rpois,      qpois.(logcPpois, 12, false, true))
allEq(Rsignrank,  qsignrank.(log.(1 .- Psignrank), 47, false, true))
allEq(Rt,      qt.(log.(1 .- Pt ), 11,   false, true))
allEq(Rt2,      qt.(log.(1 .- Pt2), 1.01, false, true), 1e-2)
allEq(Rtukey,      qtukey.(log1p.(.-Ptukey), 10, 3, 1, false, true))
allEq(Runif,      qunif.(log.(1 .- Punif), .2, 2, false, true))
allEq(Rweibull,   qweibull.(log.(1 .- Pweibull), 3, 2, false, true))
allEq(Rwilcox,      qwilcox.(log.(1 .- Pwilcox), 13, 17, false, true))

## Test if seed! working correctly
Random.seed!(124)
allEq(Rbeta, [rbeta(.8, 2) for _ in 1:n])
allEq(Rbinom, [rbinom(55, pi/16) for _ in 1:n])
allEq(Rcauchy, [rcauchy(12, 2) for _ in 1:n])
allEq(Rchisq, [rchisq(3) for _ in 1:n])
allEq(Rexp, [rexp(2) for _ in 1:n])
allEq(Rf, [rf(12, 6) for _ in 1:n])
allEq(Rgamma, [rgamma(2, 5) for _ in 1:n])
allEq(Rgeom, [rgeom(pi/16) for _ in 1:n])
allEq(Rhyper, [rhyper(40, 30, 20) for _ in 1:n])
allEq(Rlnorm, [rlnorm(-1, 3) for _ in 1:n])
allEq(Rlogis, [rlogis(12, 2) for _ in 1:n])
allEq(Rnbinom, [rnbinom(7, .01) for _ in 1:n])
allEq(Rnorm, [rnorm(-1, 3) for _ in 1:n])
allEq(Rpois, [rpois(12) for _ in 1:n])
allEq(Rsignrank, [rsignrank(47) for _ in 1:n])

# Aqua tests
@testset "Aqua.jl" begin
    Aqua.test_all(Rmath)
end
