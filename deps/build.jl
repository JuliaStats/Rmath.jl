using BinDeps, Compat

@BinDeps.setup

libRmath = library_dependency("libRmathjulia", aliases=["libRmath-julia"])
version = "0.1"
# Best practice to use a fixed version here, either a version number tag or a git sha
# Please don't download "latest master" because the version that works today might not work tomorrow

provides(Sources, URI("https://github.com/JuliaLang/Rmath-julia/archive/v$version.tar.gz"),
    [libRmath], unpacked_dir="Rmath-julia-$version")

prefix = joinpath(BinDeps.depsdir(libRmath), "usr")
srcdir = joinpath(BinDeps.srcdir(libRmath), "Rmath-julia-$version")

# These Windows binaries were taken from `make -C deps install-Rmath-julia`
# in a Cygwin cross-compile from the release-0.4 branch of julia
# Future work: standalone cross-compiled binaries using openSUSE docker container
provides(Binaries,
    URI("https://dl.bintray.com/tkelman/generic/libRmath-julia.7z"),
    [libRmath], unpacked_dir="bin$(Sys.WORD_SIZE)",
    SHA="d70db19ce7c1aa11015ff9e25e08d068bb80d1237570c9d60ece372712dd3754",
    os = :Windows)

# BSD systems (other than macOS) use BSD Make rather than GNU Make by default
# We need GNU Make, and on such systems GNU make is invoked as `gmake`
make = is_bsd() && !is_apple() ? "gmake" : "make"

# If your library uses configure or cmake, good idea to do an
# out-of-tree build - see examples in JuliaOpt and JuliaWeb
provides(SimpleBuild,
    (@build_steps begin
        GetSources(libRmath)
        CreateDirectory(joinpath(prefix, "lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            `$make USE_DSFMT=1 DSFMT_includedir="$(joinpath(BinDeps.depsdir(libRmath),"dSFMT"))"
                DSFMT_libdir="$(dirname(Libdl.dlpath("libdSFMT")))"`
            `mv src/libRmath-julia.$(Libdl.dlext) "$prefix/lib"`
        end
    end), [libRmath], os = :Unix)

@BinDeps.install Dict(:libRmathjulia => :libRmath)
