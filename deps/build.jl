using BinDeps

@BinDeps.setup

libRmath = library_dependency("libRmath", aliases=["libRmath-julia"])
version = "0.1"
# Best practice to use a fixed version here, either a version number tag or a git sha
# Please don't download "latest master" because the version that works today might not work tomorrow

provides(Sources, URI("https://github.com/JuliaLang/Rmath-julia/archive/v$version.tar.gz"),
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
            `mv src/libRmath-julia.$(Libdl.dlext) $prefix/lib`
        end
    end), [libRmath], os = :Unix)

@BinDeps.install Dict(:libRmath => :libRmath)
