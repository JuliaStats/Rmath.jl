using BinDeps, Compat

@BinDeps.setup

function validate_Rmath(name,handle)
    f = Libdl.dlsym_e(handle, "unif_rand_ptr")
    return f != C_NULL
end

libRmath = library_dependency("libRmathjulia", aliases=["libRmath-julia"], validate = validate_Rmath)
version = "0.2.0"
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
    URI("https://github.com/JuliaLang/Rmath-julia/releases/download/v$version/libRmath-julia-win-$(Sys.ARCH)-v$version.zip"),
    [libRmath], unpacked_dir=".",
    SHA = Sys.ARCH == :i686 ? "955bc52329bb9240d71cf31e9eca3ece5ee4bca5d32605de68a6e10d9e91010e" :
                              "87e46273e503a9c5b65cf8d920006cb0771d24e38a1c2181e91c84a07cd27f58" ,
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
            `$make`
            `mv src/libRmath-julia.$(Libdl.dlext) "$prefix/lib"`
        end
    end), [libRmath], os = :Unix)

@BinDeps.install Dict(:libRmathjulia => :libRmath)
