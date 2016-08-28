## Interface to the Rmath library emulating the d-p-q-r functions in R.
## This module is for archival purposes.  The interface in the
## Distributions module is much more effective.

__precompile__()

module Rmath

using Compat

# use dirname(@__FILE__) instead of Pkg.dir, since the latter will
# cause the package to not work if installed in some other location
depsjl = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depsjl)
    include(depsjl)
else
    error("Rmath not properly installed. Please run Pkg.build(\"Rmath\") and restart julia")
end

    export dbeta,pbeta,qbeta,rbeta     # Beta distribution (shape1, shape2)
    export dbinom,pbinom,qbinom,rbinom # Binomial distribution (size, prob)
    export dcauchy,pcauchy,qcauchy,rcauchy # Cauchy distribution (location, scale)
    export dchisq,pchisq,qchisq,rchisq # Central Chi-squared distribution (df)
    export dexp,pexp,qexp,rexp         # Exponential distribution (rate)
    export df,pf,qf,rf                 # Central F distribution (df1,df2)
    export dgamma,pgamma,qgamma,rgamma # Gamma distribution (shape, scale)
    export dgeom,pgeom,qgeom,rgeom     # Geometric distribution (prob)
    export dhyper,phyper,qhyper,rhyper # Hypergeometric (m, n, k)
    export dlnorm,plnorm,qlnorm,rlnorm # Log-normal distribution (meanlog, sdlog)
    export dlogis,plogis,qlogis,rlogis # Logistic distribution (location, scale)
    export dnbeta,pnbeta,qnbeta,rnbeta # Non-central beta (shape1, shape2, ncp)
    export dnbinom,pnbinom,qnbinom,rnbinom # Negative binomial distribution (size, prob)
    export dnbinom_mu,pnbinom_mu,qnbinom_mu,rnbinom_mu  # Negative binomial distribution (size, mu)
    export dnchisq,pnchisq,qnchisq,rnchisq # Noncentral Chi-squared distribution (df, ncp)
    export dnf,pnf,qnf,rnf             # Non-central F (df1, df2, ncp)
    export dnorm,pnorm,qnorm,rnorm     # Normal (Gaussian) distribution (mu, sigma)
    export dpois,ppois,qpois,rpois     # Poisson distribution (lambda)
    export dsignrank,psignrank,qsignrank,rsignrank
    export dt,pt,qt,rt                 # Student's t distribution (df)
    export dunif,punif,qunif,runif     # Uniform distribution (min, max)
    export dweibull,pweibull,qweibull,rweibull # Weibull distribution (shape, scale)
    export dwilcox,pwilcox,qwilcox,rwilcox # Wilcox's Rank Sum statistic (m, n)
    export ptukey, qtukey              # Studentized Range Distribution - p and q only

    macro libRmath_vectorize_3arg(f)
        quote
            global $f
            $f{T1<:Number, T2<:Number, T3<:Number}(x::AbstractArray{T1}, y::T2, z::T3) =
                reshape([$f(x[i], y, z) for i=1:length(x)], size(x))
            $f{T1<:Number, T2<:Number, T3<:Number}(x::T1, y::AbstractArray{T2}, z::T3) =
                reshape([$f(x, y[i], z) for i=1:length(y)], size(y))
            $f{T1<:Number, T2<:Number, T3<:Number}(x::T1, y::T2, z::AbstractArray{T3}) =
                reshape([$f(x, y, z[i]) for i=1:length(z)], size(z))
            function $f{T1<:Number, T2<:Number, T3<:Number}(x::AbstractArray{T1},
                                                            y::AbstractArray{T2},
                                                            z::T3)
                shp = promote_shape(size(x), size(y))
                reshape([$f(x[i], y[i], z) for i=1:length(x)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number}(x::T1,
                                                            y::AbstractArray{T2},
                                                            z::AbstractArray{T3})
                shp = promote_shape(size(y), size(z))
                reshape([$f(x, y[i], z[i]) for i=1:length(y)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number}(x::AbstractArray{T1},
                                                            y::T2,
                                                            z::AbstractArray{T3})
                shp = promote_shape(size(x), size(z))
                reshape([$f(x[i], y, z[i]) for i=1:length(x)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number}(x::AbstractArray{T1},
                                                            y::AbstractArray{T2},
                                                            z::AbstractArray{T3})
                shp = promote_shape(promote_shape(size(x), size(y)), size(z))
                reshape([$f(x[i], y, z[i]) for i=1:length(x)], shp)
            end
        end
    end

    ## Vectorize over four numeric arguments
    macro libRmath_vectorize_4arg(f)
        quote
            global $f
            $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                               a2::T2,
                                                               a3::T3,
                                                               a4::T4) =
                reshape([$f(a1[i], a2, a3, a4) for i=1:length(a1)], size(a1))
            $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                               a2::AbstractArray{T2},
                                                               a3::T3,
                                                               a4::T4) =
                reshape([$f(a1, a2[i], a3, a4) for i=1:length(a2)], size(a2))
            $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                               a2::T2,
                                                               a3::AbstractArray{T3},
                                                               a4::T4) =
                reshape([$f(a1, a2, a3[i], a4) for i=1:length(a3)], size(a3))
            $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                               a2::T2,
                                                               a3::T3,
                                                               a4::AbstractArray{T4}) =
                reshape([$f(a1, a2, a3, a4[i]) for i=1:length(a4)], size(a4))
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::AbstractArray{T2},
                                                                        a3::T3,
                                                                        a4::T4)
                shp = promote_shape(size(a1), size(a2))
                reshape([$f(a1[i], a2[i], a3, a4) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::T2,
                                                                        a3::AbstractArray{T3},
                                                                        a4::T4)
                shp = promote_shape(size(a1), size(a3))
                reshape([$f(a1[i], a2, a3[i], a4) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::T2,
                                                                        a3::T3,
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(size(a1), size(a4))
                reshape([$f(a1[i], a2, a3, a4[i]) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                                        a2::AbstractArray{T2},
                                                                        a3::AbstractArray{T3},
                                                                        a4::T4)
                shp = promote_shape(size(a2), size(a3))
                reshape([$f(a1, a2[i], a3[i], a4) for i=1:length(a2)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                                        a2::AbstractArray{T2},
                                                                        a3::T3,
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(size(a2), size(a4))
                reshape([$f(a1, a2[i], a3, a4[i]) for i=1:length(a2)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                                        a2::T2,
                                                                        a3::AbstractArray{T3},
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(size(a3), size(a4))
                reshape([$f(a1, a2, a3[i], a4[i]) for i=1:length(a3)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::AbstractArray{T2},
                                                                        a3::AbstractArray{T3},
                                                                        a4::T4)
                shp = promote_shape(promote_shape(size(a1), size(a2)), size(a3))
                reshape([$f(a1[i], a2[i], a3[i], a4) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::AbstractArray{T2},
                                                                        a3::T3,
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(promote_shape(size(a1), size(a2)), size(a4))
                reshape([$f(a1[i], a2[i], a3, a4[i]) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::T2,
                                                                        a3::AbstractArray{T3},
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(promote_shape(size(a1), size(a3)), size(a4))
                reshape([$f(a1[i], a2, a3[i], a4[i]) for i=1:length(a1)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::T1,
                                                                        a2::AbstractArray{T2},
                                                                        a3::AbstractArray{T3},
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(promote_shape(size(a2), size(a3)), size(a4))
                reshape([($f)(a1, a2[i], a3[i], a4[i]) for i=1:length(a2)], shp)
            end
            function $f{T1<:Number, T2<:Number, T3<:Number, T4<:Number}(a1::AbstractArray{T1},
                                                                        a2::AbstractArray{T2},
                                                                        a3::AbstractArray{T3},
                                                                        a4::AbstractArray{T4})
                shp = promote_shape(promote_shape(promote_shape(size(a1),size(a2)),size(a3)),size(a4))
                reshape([$f(a1[i], a2[i], a3[i], a4[i]) for i=1:length(a2)], shp)
            end
        end
    end

    ## Macro for deferring freeing data until GC for wilcox and signrank
    macro libRmath_deferred_free(base)
        libcall = Symbol(base, "_free")
        func = Symbol(base, "_deferred_free")
        quote
            let gc_tracking_obj = []
                global $func
                function $libcall(x::Vector)
                    gc_tracking_obj = []
                    ccall(($(string(libcall)),libRmathjulia), Void, ())
                end
                function $func()
                    if !isa(gc_tracking_obj, Bool)
                        finalizer(gc_tracking_obj, $libcall)
                        gc_tracking_obj = false
                    end
                end
            end
        end
    end

    ## Non-ccall functions for distributions with 1 parameter and no defaults
    macro libRmath_1par_0d_aliases(base)
        dd = Symbol("d", base)
        pp = Symbol("p", base)
        qq = Symbol("q", base)
        quote
            global $dd, $pp, $qq
            $dd{T<:Number}(x::AbstractArray{T}, p1::Number, give_log::Bool) =
                reshape([$dd(x[i], p1, give_log) for i=1:length(x)], size(x))
            $dd(x::Number, p1::Number) = $dd(x, p1, false)
            @vectorize_2arg Number $dd
            $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) =
                reshape([$pp(q[i], p1, lower_tail, log_p) for i=1:length(q)], size(q))
            $pp(q::Number, p1::Number, lower_tail::Bool) = $pp(q, p1, lower_tail, false)
            $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool) = $pp(q, p1, lower_tail, false)
            $pp(q::Number, p1::Number) = $pp(q, p1, true, false)
            @vectorize_2arg Number $pp
            $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) =
                reshape([$qq(p[i], p1, lower_tail, log_p) for i=1:length(p)], size(p))
            $qq(p::Number, p1::Number, lower_tail::Bool) = $qq(p, p1, lower_tail, false)
            $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool) = $qq(p, p1, lower_tail, false)
            $qq(p::Number, p1::Number) = $qq(p, p1, true, false)
            @vectorize_2arg Number $qq
        end
    end

    ## Distributions with 1 parameter and no default
    macro libRmath_1par_0d(base)
        dd = Symbol("d", base)
        pp = Symbol("p", base)
        qq = Symbol("q", base)
        rr = Symbol("r", base)
        quote
            global $dd, $pp, $qq, $rr
            $dd(x::Number, p1::Number, give_log::Bool) = 
                ccall(($(string(dd)),libRmathjulia), Float64,
                      (Float64,Float64,Int32), x, p1, give_log)
            $pp(q::Number, p1::Number, lower_tail::Bool, log_p::Bool) =
                ccall(($(string(pp)),libRmathjulia), Float64,
                      (Float64,Float64,Int32,Int32), q, p1, lower_tail, log_p)
            $qq(p::Number, p1::Number, lower_tail::Bool, log_p::Bool) =
                ccall(($(string(qq)),libRmathjulia), Float64,
                      (Float64,Float64,Int32,Int32), p, p1, lower_tail, log_p)
            $rr(nn::Integer, p1::Number) =
                [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,), p1) for i=1:nn]
            @libRmath_1par_0d_aliases $base
        end
    end

    @libRmath_1par_0d t    
    @libRmath_1par_0d chisq
    @libRmath_1par_0d pois
    @libRmath_1par_0d geom

    ## The d-p-q functions in Rmath for signrank allocate storage that must be freed
    ## Signrank - Wilcoxon Signed Rank statistic
    @libRmath_deferred_free signrank
    function dsignrank(x::Number, p1::Number, give_log::Bool)
        signrank_deferred_free()
        ccall((:dsignrank,libRmathjulia), Float64, (Float64,Float64,Int32), x, p1, give_log)
    end
    function psignrank(q::Number, p1::Number, lower_tail::Bool, log_p::Bool)
        signrank_deferred_free()
        ccall((:psignrank,libRmathjulia), Float64, (Float64,Float64,Int32,Int32), q, p1, lower_tail, log_p)
    end
    function qsignrank(p::Number, p1::Number, lower_tail::Bool, log_p::Bool)
        signrank_deferred_free()
        ccall((:qsignrank,libRmathjulia), Float64, (Float64,Float64,Int32,Int32), p, p1, lower_tail, log_p)
    end
    @libRmath_1par_0d_aliases signrank
    rsignrank(nn::Integer, p1::Number) =
        [ccall((:rsignrank,libRmathjulia), Float64, (Float64,), p1) for i=1:nn]

    ## Distributions with 1 parameter and a default
    macro libRmath_1par_1d(base, d1)
        dd = Symbol("d", base)
        pp = Symbol("p", base)
        qq = Symbol("q", base)
        rr = Symbol("r", base)
        quote
            global $dd, $pp, $qq, $rr
            $dd(x::Number, p1::Number, give_log::Bool) = 
                ccall(($(string(dd)),libRmathjulia), Float64, (Float64,Float64,Int32), x, p1, give_log)
            $dd{T<:Number}(x::AbstractArray{T}, p1::Number, give_log::Bool) =
                reshape([$dd(x[i], p1, give_log) for i=1:length(x)], size(x))
        $dd(x::Number, give_log::Bool) = $dd(x, $d1, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, give_log::Bool) = $dd(x, $d1, give_log)
        $dd(x::Number, p1::Number) = $dd(x, p1, false)
        @vectorize_2arg Number $dd
        $dd(x::Number) = $dd(x, $d1, false)
        $dd{T<:Number}(x::AbstractArray{T}) = $dd(x, $d1, false)

        $pp(q::Number, p1::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(pp)),libRmathjulia), Float64, (Float64,Float64,Int32,Int32), q, p1, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$pp(q[i], p1, lower_tail, log_p) for i=1:length(q)], size(q))
        $pp(q::Number, lower_tail::Bool, log_p::Bool) = $pp(q, $d1, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, lower_tail::Bool, log_p::Bool) = $pp(q, $d1, lower_tail, log_p)
        $pp(q::Number, p1::Number, lower_tail::Bool) = $pp(q, p1, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool) = $pp(q, p1, lower_tail, false)
        $pp(q::Number, lower_tail::Bool) = $pp(q, $d1, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, lower_tail::Bool) = $pp(q, $d1, lower_tail, false)
        $pp(q::Number, p1::Number) = $pp(q, p1, true, false)
        @vectorize_2arg Number $pp
        $pp(q::Number) = $pp(q, $d1, true, false)
        $pp{T<:Number}(q::AbstractArray{T}) = $pp(q, $d1, true, false)

        $qq(p::Number, p1::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(qq)),libRmathjulia), Float64, (Float64,Float64,Int32,Int32), p, p1, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$qq(p[i], p1, lower_tail, log_p) for i=1:length(p)], size(p))
        $qq(p::Number, lower_tail::Bool, log_p::Bool) = $qq(p, $d1, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, lower_tail::Bool, log_p::Bool) = $qq(p, $d1, lower_tail, log_p)
        $qq(p::Number, p1::Number, lower_tail::Bool) = $qq(p, p1, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool) = $qq(p, p1, lower_tail, false)
        $qq(p::Number, lower_tail::Bool) = $qq(p, $d1, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, lower_tail::Bool) = $qq(p, $d1, lower_tail, false)
        $qq(p::Number, p1::Number) = $qq(p, p1, true, false)
        @vectorize_2arg Number $qq
        $qq(p::Number) = $qq(p, $d1, true, false)
        $qq{T<:Number}(p::AbstractArray{T}) = $qq(p, $d1, true, false)

        $rr(nn::Integer, p1::Number) =
            [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,), p1) for i=1:nn]
        $rr(nn::Integer) = $rr(nn, $d1)
    end
end

## May need to handle this as a special case.  The Rmath library uses 1/rate, not rate
@libRmath_1par_1d exp 1      # Exponential distribution (rate)

## Non-ccall functions for distributions with 2 parameters and no defaults
macro libRmath_2par_0d_aliases(base)
    dd = Symbol("d", base)
    pp = Symbol("p", base)
    qq = Symbol("q", base)
    quote
        global $dd, $pp, $qq
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, p2::Number, give_log::Bool) =
            reshape([$dd(x[i], p1, p2, give_log) for i=1:length(x)], size(x))
        $dd(x::Number, p1::Number, p2::Number) = $dd(x, p1, p2, false)
        @libRmath_vectorize_3arg $dd

        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$pp(q[i], p1, p2, lower_tail, log_p) for i=1:length(q)], size(q))
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool) = $pp(q, p1, p2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) =
            reshape([$pp(q[i], p1, p2, lower_tail, false) for i=1:length(q)], size(q))
        $pp(q::Number, p1::Number, p2::Number) = $pp(q, p1, p2, true, false)
        @libRmath_vectorize_3arg $pp

        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$qq(p[i], p1, p2, lower_tail, log_p) for i=1:length(p)], size(p))
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool) = $qq(p, p1, p2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) =
            reshape([$qq(p[i], p1, p2, lower_tail, false) for i=1:length(p)], size(p))
        $qq(p::Number, p1::Number, p2::Number) = $qq(p, p1, p2, true, false)
        @libRmath_vectorize_3arg $qq
    end
end

## Distributions with 2 parameters and no defaults
macro libRmath_2par_0d(base)
    dd = Symbol("d", base)
    pp = Symbol("p", base)
    qq = Symbol("q", base)
    rr = Symbol("r", base)
    quote
        global $dd, $pp, $qq, $rr
        $dd(x::Number, p1::Number, p2::Number, give_log::Bool) =
            ccall(($(string(dd)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32), x, p1, p2, give_log)
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(pp)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), q, p1, p2, lower_tail, log_p)
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(qq)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), p, p1, p2, lower_tail, log_p)
        $rr(nn::Integer, p1::Number, p2::Number) =
            [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,Float64), p1, p2) for i=1:nn]
        @libRmath_2par_0d_aliases $base
    end
end

@libRmath_2par_0d beta        # Beta distribution (shape1, shape2)
@libRmath_2par_0d binom       # Binomial distribution (size, prob)
@libRmath_2par_0d f           # Central F distribution (df1, df2)
@libRmath_2par_0d nbinom      # Negative binomial distribution (size, prob)
@libRmath_2par_0d nbinom_mu   # Negative binomial distribution (size, mu)
@libRmath_2par_0d nchisq      # Noncentral Chi-squared distribution (df, ncp)

## Need to handle the d-p-q for Wilcox separately because the Rmath functions allocate storage that must be freed.
## Wilcox - Wilcox's Rank Sum statistic (m, n) - probably only makes sense for positive integers
@libRmath_deferred_free wilcox
function dwilcox(x::Number, p1::Number, p2::Number, give_log::Bool)
    wilcox_deferred_free()
    ccall((:dwilcox,libRmathjulia), Float64, (Float64,Float64,Float64,Int32), x, p1, p2, give_log)
end
function pwilcox(q::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool)
    wilcox_deferred_free()
    ccall((:pwilcox,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), q, p1, p2, lower_tail, log_p)
end
function qwilcox(p::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool)
    wilcox_deferred_free()
    ccall((:qwilcox,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), p, p1, p2, lower_tail, log_p)
end
rwilcox(nn::Integer, p1::Number, p2::Number) =
    [ccall((:rwilcox,libRmathjulia), Float64, (Float64,Float64), p1, p2) for i=1:nn]
@libRmath_2par_0d_aliases wilcox

## Distributions with 2 parameters and 1 default
macro libRmath_2par_1d(base, d2)
    dd = Symbol("d", base)
    pp = Symbol("p", base)
    qq = Symbol("q", base)
    rr = Symbol("r", base)
    quote
        global $dd, $pp, $qq, $rr
        $dd(x::Number, p1::Number, p2::Number, give_log::Bool) =
            ccall(($(string(dd)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32), x, p1, p2, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, p2::Number, give_log::Bool) =
            reshape([$dd(x[i], p1, p2, give_log) for i=1:length(x)], size(x))
        $dd(x::Number, p1::Number, give_log::Bool) = $dd(x, p1, $d2, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, give_log::Bool) = $dd(x, p1, $d2, give_log)
        $dd(x::Number, p1::Number, p2::Number) = $dd(x, p1, p2, false)
        @libRmath_vectorize_3arg $dd
        $dd(x::Number, p1::Number) = $dd(x, p1, $d2, false)        
        @vectorize_2arg Number $dd
        
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(pp)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), q, p1, p2, lower_tail, log_p)
        $pp(q::Number, p1::Number, lower_tail::Bool, log_p::Bool) = $pp(q, p1, $d2, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$pp(q[i], p1, p2, lower_tail, log_p) for i=1:length(q)], size(q))
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) = $pp(q, p1, $d2, lower_tail, log_p)
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool) = $pp(q, p1, p2, lower_tail, false)
        $pp(q::Number, p1::Number, lower_tail::Bool) = $pp(q, p1, $d2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) = $pp(q, p1, p2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool) = $pp(q, p1, $d2, lower_tail, false)
        $pp(q::Number, p1::Number, p2::Number) = $pp(q, p1, p2, true, false)
        @libRmath_vectorize_3arg $pp
        $pp(q::Number, p1::Number) = $pp(q, p1, $d2, true, false)
        @vectorize_2arg Number $pp
        
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(qq)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), p, p1, p2, lower_tail, log_p)
        $qq(p::Number, p1::Number, lower_tail::Bool, log_p::Bool) = $qq(p, p1, $d2, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$qq(p[i], p1, p2, lower_tail, log_p) for i=1:length(p)], size(p))
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) = $qq(p, p1, $d2, lower_tail, log_p)
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool) = $qq(p, p1, p2, lower_tail, false)
        $qq(p::Number, p1::Number, lower_tail::Bool) = $qq(p, p1, $d2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) = $qq(p, p1, p2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool) = $qq(p, p1, $d2, lower_tail, false)
        $qq(p::Number, p1::Number, p2::Number) = $qq(p, p1, p2, true, false)
        @libRmath_vectorize_3arg $qq
        $qq(p::Number, p1::Number) = $qq(p, p1, $d2, true, false)
        @vectorize_2arg Number $qq

        $rr(nn::Integer, p1::Number, p2::Number) =
            [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,Float64), p1, p2) for i=1:nn]
        $rr(nn::Integer, p1::Number) = $rr(nn, p1, $d2)
    end
end

@libRmath_2par_1d gamma 1     # Gamma distribution  (shape, scale)
@libRmath_2par_1d weibull 1   # Weibull distribution (shape, scale)

## Distributions with 2 parameters and 2 defaults
macro libRmath_2par_2d(base, d1, d2)
    ddsym = dd = Symbol("d", base)
    ppsym = pp = Symbol("p", base)
    qqsym = qq = Symbol("q", base)
    rr = Symbol("r", base)
    if (string(base) == "norm")
        ddsym = :dnorm4
        ppsym = :pnorm5
        qqsym = :qnorm5
    end
    quote
        global $dd, $pp, $qq, $rr
        $dd(x::Number, p1::Number, p2::Number, give_log::Bool) =
            ccall(($(string(ddsym)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32), x, p1, p2, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, p2::Number, give_log::Bool) =
            reshape([$dd(x[i], p1, p2, give_log) for i=1:length(x)], size(x))
        $dd(x::Number, p1::Number, give_log::Bool) = $dd(x, p1, $d2, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, give_log::Bool) = $dd(x, p1, $d2, give_log)
        $dd(x::Number, give_log::Bool) = $dd(x, $d1, $d2, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, give_log::Bool) = $dd(x, $d1, $d2, give_log)
        $dd(x::Number, p1::Number, p2::Number) = $dd(x, p1, p2, false)
        @libRmath_vectorize_3arg $dd
        $dd(x::Number, p1::Number) = $dd(x, p1, $d2, false)
        @vectorize_2arg Number $dd
        $dd(x::Number) = $dd(x, $d1, $d2, false)
        $dd{T<:Number}(x::AbstractArray{T}) = $dd(x, $d1, $d2, give_log)

        
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(ppsym)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), q, p1, p2, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$pp(q[i], p1, p2, lower_tail, log_p) for i=1:length(q)], size(q))
        $pp(q::Number, p1::Number, lower_tail::Bool, log_p::Bool) = $pp(q, p1, $d2, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) = $pp(q, p1, $d2, lower_tail, log_p)
        $pp(q::Number, lower_tail::Bool, log_p::Bool) = $pp(q, $d1, $d2, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, lower_tail::Bool, log_p::Bool) = $pp(q, $d1, $d2, lower_tail, log_p)
        $pp(q::Number, p1::Number, p2::Number, lower_tail::Bool) = $pp(q, p1, p2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) = $pp(q, p1, p2, lower_tail, false)
        $pp(q::Number, p1::Number, lower_tail::Bool) = $pp(q, p1, $d2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, lower_tail::Bool) = $pp(q, p1, $d2, lower_tail, false)
        $pp(q::Number, lower_tail::Bool) = $pp(q, $d1, $d2, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, lower_tail::Bool) = $pp(q, $d1, $d2, lower_tail, false)
        $pp(q::Number, p1::Number, p2::Number) = $pp(q, p1, p2, true, false)
        @libRmath_vectorize_3arg $pp
        $pp(q::Number, p1::Number) = $pp(q, p1, $d2, true, false)
        @vectorize_2arg Number $pp
        $pp(q::Number) = $pp(q, $d1, $d2, true, false)
        $pp{T<:Number}(q::AbstractArray{T}) = $pp(q, $d1, $d2, true, false)
        
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(qqsym)),libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32), p, p1, p2, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$qq(p[i], p1, p2, lower_tail, log_p) for i=1:length(p)], size(p))
        $qq(p::Number, p1::Number, lower_tail::Bool, log_p::Bool) = $qq(p, p1, $d2, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool, log_p::Bool) = $qq(p, p1, $d2, lower_tail, log_p)
        $qq(p::Number, lower_tail::Bool, log_p::Bool) = $qq(p, $d1, $d2, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, lower_tail::Bool, log_p::Bool) = $qq(p, $d1, $d2, lower_tail, log_p)
        $qq(p::Number, p1::Number, p2::Number, lower_tail::Bool) = $qq(p, p1, p2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, lower_tail::Bool) = $qq(p, p1, p2, lower_tail, false)
        $qq(p::Number, p1::Number, lower_tail::Bool) = $qq(p, p1, $d2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, lower_tail::Bool) = $qq(p, p1, $d2, lower_tail, false)
        $qq(p::Number, lower_tail::Bool) = $qq(p, $d1, $d2, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, lower_tail::Bool) = $qq(p, $d1, $d2, lower_tail, false)
        $qq(p::Number, p1::Number, p2::Number) = $qq(p, p1, p2, true, false)
        @libRmath_vectorize_3arg $qq
        $qq(p::Number, p1::Number) = $qq(p, p1, $d2, true, false)
        @vectorize_2arg Number $qq
        $qq(p::Number) = $qq(p, $d1, $d2, true, false)
        $qq{T<:Number}(p::AbstractArray{T}) = $qq(p, $d1, $d2, true, false)

        $rr(nn::Integer, p1::Number, p2::Number) =
            [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,Float64), p1, p2) for i=1:nn]
        $rr(nn::Integer, p1::Number) = $rr(nn, p1, $d2)
        $rr(nn::Integer) = $rr(nn, $d1, $d2)
    end
end

@libRmath_2par_2d cauchy 0 1  # Cauchy distribution (location, scale)
@libRmath_2par_2d lnorm  0 1  # Log-normal distribution (meanlog, sdlog)
@libRmath_2par_2d logis  0 1  # Logistic distribution (location, scale)
@libRmath_2par_2d norm   0 1  # Normal (Gaussian) distribution (mu, sd)
@libRmath_2par_2d unif   0 1  # Uniform distribution (min, max)

## Distributions with 3 parameters and no defaults
macro libRmath_3par_0d(base)
    dd = Symbol("d", base)
    pp = Symbol("p", base)
    qq = Symbol("q", base)
    rr = Symbol("r", base)
    quote
        global $dd, $pp, $qq, $rr
        $dd(x::Number, p1::Number, p2::Number, p3::Number, give_log::Bool) =
            ccall(($(string(dd)),libRmathjulia), Float64, (Float64,Float64,Float64,Float64,Int32), x, p1, p2, p3, give_log)
        $dd{T<:Number}(x::AbstractArray{T}, p1::Number, p2::Number, p3::Number, give_log::Bool) =
            reshape([$dd(x[i], p1, p2, p3, give_log) for i=1:length(x)], size(x))
        $dd(x::Number, p1::Number, p2::Number, p3::Number) = $dd(x, p1, p2, p3, false)
        @libRmath_vectorize_4arg $dd

        $pp(q::Number, p1::Number, p2::Number, p3::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(pp)),libRmathjulia), Float64, (Float64,Float64,Float64,Float64,Int32,Int32), q, p1, p2, p3, lower_tail, log_p)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, p3::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$pp(q[i], p1, p2, p3, lower_tail, log_p) for i=1:length(q)], size(q))
        $pp(q::Number, p1::Number, p2::Number, p3::Number, lower_tail::Bool) = $pp(q, p1, p2, p3, lower_tail, false)
        $pp{T<:Number}(q::AbstractArray{T}, p1::Number, p2::Number, p3::Number, lower_tail::Bool) =
            reshape([$pp(q[i], p1, p2, p3, lower_tail, false) for i=1:length(q)], size(q))
        $pp(q::Number, p1::Number, p2::Number, p3::Number) = $pp(q, p1, p2, p3, true, false)
        @libRmath_vectorize_4arg $pp

        $qq(p::Number, p1::Number, p2::Number, p3::Number, lower_tail::Bool, log_p::Bool) =
            ccall(($(string(qq)),libRmathjulia), Float64, (Float64,Float64,Float64,Float64,Int32,Int32), p, p1, p2, p3, lower_tail, log_p)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, p3::Number, lower_tail::Bool, log_p::Bool) =
            reshape([$qq(p[i], p1, p2, p3, lower_tail, log_p) for i=1:length(p)], size(p))
        $qq(p::Number, p1::Number, p2::Number, p3::Number, lower_tail::Bool) = $qq(p, p1, p2, p3, lower_tail, false)
        $qq{T<:Number}(p::AbstractArray{T}, p1::Number, p2::Number, p3::Number, lower_tail::Bool) =
            reshape([$qq(p[i], p1, p2, p3, lower_tail, false) for i=1:length(p)], size(p))
        $qq(p::Number, p1::Number, p2::Number, p3::Number) = $qq(p, p1, p2, p3, true, false)
        @libRmath_vectorize_4arg $qq

        $rr(nn::Integer, p1::Number, p2::Number, p3::Number) =
            [ccall(($(string(rr)),libRmathjulia), Float64, (Float64,Float64,Float64), p1, p2, p3) for i=1:nn]
    end
end

@libRmath_3par_0d hyper       # Hypergeometric (m, n, k)
@libRmath_3par_0d nbeta       # Non-central beta (shape1, shape2, ncp)
@libRmath_3par_0d nf          # Non-central F (df1, df2, ncp)

## tukey (Studentized Range Distribution - p and q only - 3pars)
ptukey(q::Number, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool, log_p::Bool) =
    ccall((:ptukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),q,nranges,nmeans,df,lower_tail,log_p)
ptukey(q::Number, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool) =
    ccall((:ptukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),q,nranges,nmeans,df,lower_tail,false)
ptukey(q::Number, nmeans::Number, df::Number, nranges::Number) =
    ccall((:ptukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),q,nranges,nmeans,df,true,false)
ptukey{T<:Number}(q::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool, log_p::Bool) =
    reshape([ptukey(q[i],nmeans,df,nranges,lower_tail,log_p) for i=1:length(q)], size(q))
ptukey{T<:Number}(q::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool) =
    reshape([ptukey(q[i],nmeans,df,nranges,lower_tail,false) for i=1:length(q)], size(q))
ptukey{T<:Number}(q::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number) =
    reshape([ptukey(q[i],nmeans,df,nranges,true,false) for i=1:length(q)], size(q))
ptukey{T<:Number}(q::AbstractArray{T}, nmeans::Number, df::Number) =
    reshape([ptukey(q[i],nmeans,df,1.,true,false) for i=1:length(q)], size(q))

qtukey(q::Number, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool, log_p::Bool) =
    ccall((:qtukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),p,nranges,nmeans,df,lower_tail,log_p)
qtukey(p::Number, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool) =
    ccall((:qtukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),p,nranges,nmeans,df,lower_tail,false)
qtukey(p::Number, nmeans::Number, df::Number, nranges::Number) =
    ccall((:qtukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),p,nranges,nmeans,df,true,false)
qtukey(p::Number, nmeans::Number, df::Number) =
    ccall((:qtukey,libRmathjulia), Float64, (Float64,Float64,Float64,Int32,Int32),p,nranges,1.,df,true,false)
qtukey{T<:Number}(p::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool, log_p::Bool) =
    reshape([qtukey(p[i],nmeans,df,nranges,lower_tail,log_p) for i=1:length(p)], size(p))
qtukey{T<:Number}(p::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number, lower_tail::Bool) =
    reshape([qtukey(p[i],nmeans,df,nranges,lower_tail,false) for i=1:length(p)], size(p))
qtukey{T<:Number}(p::AbstractArray{T}, nmeans::Number, df::Number, nranges::Number) =
    reshape([qtukey(p[i],nmeans,df,nranges,true,false) for i=1:length(p)], size(p))
qtukey{T<:Number}(p::AbstractArray{T}, nmeans::Number, df::Number) =
    reshape([qtukey(p[i],nmeans,df,1.,true,false) for i=1:length(p)], size(p))

end #module
