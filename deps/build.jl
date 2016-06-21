using BinDeps

@BinDeps.setup

libRmath = library_dependency("libRmath", aliases=["libRmath-julia2"])
version = "0.1"

# TODO replace tkelman with JuliaLang later
provides(Sources, URI("https://github.com/tkelman/Rmath-julia/archive/v$version.tar.gz"),
    [libRmath], unpacked_dir="Rmath-julia-$version")

prefix = joinpath(BinDeps.depsdir(libRmath), "usr")
srcdir = joinpath(BinDeps.srcdir(libRmath), "Rmath-julia-$version")

# If your library uses configure or cmake, good idea to do an
# out-of-tree build - see examples in JuliaOpt and JuliaWeb
provides(SimpleBuild,
    (@build_steps begin
        GetSources(libRmath)
        CreateDirectory(joinpath(prefix, "lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            `make`
            `mv src/libRmath-julia.$(Libdl.dlext) $prefix/lib/libRmath-julia2.$(Libdl.dlext)`
        end
    end), [libRmath], os = :Unix)

@BinDeps.install Dict(:libRmath => :libRmath)
