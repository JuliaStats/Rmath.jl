using BinDeps, Compat

@BinDeps.setup

libRmath = library_dependency("libRmathjulia", aliases=["libRmath-julia"])
version = v"0.2.0"
# Best practice to use a fixed version here, either a version number tag or a git sha
# Please don't download "latest master" because the version that works today might not work tomorrow

provides(Sources, URI("https://github.com/JuliaLang/Rmath-julia/archive/v$version.tar.gz"),
    [libRmath], unpacked_dir="Rmath-julia-$version")

prefix = joinpath(BinDeps.depsdir(libRmath), "usr")
srcdir = joinpath(BinDeps.srcdir(libRmath), "Rmath-julia-$version")

if Compat.Sys.iswindows()
    WIN_SHA = if Sys.ARCH === :x86_64
        "87e46273e503a9c5b65cf8d920006cb0771d24e38a1c2181e91c84a07cd27f58"
    else
        "955bc52329bb9240d71cf31e9eca3ece5ee4bca5d32605de68a6e10d9e91010e"
    end
else
    WIN_SHA = ""
end

# These Windows binaries were built on AppVeyor using Cygwin cross-compile
provides(Binaries,
    URI("https://github.com/JuliaLang/Rmath-julia/releases/download/v$version/" *
        "libRmath-julia-win-$(Sys.ARCH)-v$version.zip"),
    [libRmath], unpacked_dir="bin$(Sys.WORD_SIZE)",
    SHA=WIN_SHA,
    os = :Windows)

# If your library uses configure or cmake, good idea to do an
# out-of-tree build - see examples in JuliaOpt and JuliaWeb
provides(SimpleBuild,
    (@build_steps begin
        GetSources(libRmath)
        CreateDirectory(joinpath(prefix, "lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            `$MAKE_CMD USE_DSFMT=1 DSFMT_includedir="$(joinpath(BinDeps.depsdir(libRmath),"dSFMT"))"
                DSFMT_libdir="$(dirname(Libdl.dlpath("libdSFMT")))"`
            `mv src/libRmath-julia.$(Libdl.dlext) "$prefix/lib"`
        end
    end), [libRmath], os = :Unix)

@BinDeps.install Dict(:libRmathjulia => :libRmath)
