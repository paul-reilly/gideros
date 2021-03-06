

target("gidlibxmp")
    set_default(false)
    set_kind("shared")
    add_deps("gvfs")
    add_defines("_REENTRANT", "LIBXMP_CORE_PLAYER")
    if not is_plat("windows") then
        add_shflags("-fPIC")
    end
    add_files("libxmp-4.3/src/*.c|hmn*|med*|format*|extras*")
    add_files("libxmp-4.3/src/loaders/xm_load.c", "libxmp-4.3/src/loaders/s3m_load.c")
    add_files("libxmp-4.3/src/loaders/it_load.c", "libxmp-4.3/src/loaders/common.c")
    add_files("libxmp-4.3/src/loaders/itsex.c", "libxmp-4.3/src/loaders/sample.c")
    add_files("libxmp-4.3/lite/src/format.c")
    add_files("libxmp-4.3/lite/src/loaders/mod_load.c")
    add_includedirs("libxmp-4.3/include", { public = true }) 
    add_includedirs("libxmp-4.3/src", "libxmp-4.3/src/loaders")
    


target("gidfreetype")
    set_default(false)
    set_kind("static")
    add_defines("FT2_BUILD_LIBRARY", "FT_CONFIG_OPTION_SYSTEM_ZLIB",
        "DARWIN_NO_CARBON"
    )
    local ft_ver = "./freetype-2.7.1/"
    add_includedirs(ft_ver .. "include", { public = true })
    add_files(
        ft_ver .. "src/base/ftbbox.c",
        ft_ver .. "src/base/ftbitmap.c",
        ft_ver .. "src/base/ftglyph.c",
        ft_ver .. "src/base/ftlcdfil.c",
        ft_ver .. "src/base/ftstroke.c",
        ft_ver .. "src/base/ftbase.c",
        ft_ver .. "src/base/ftsystem.c",
        ft_ver .. "src/base/ftinit.c",
        ft_ver .. "src/base/ftgasp.c",
        ft_ver .. "src/raster/raster.c",
        ft_ver .. "src/sfnt/sfnt.c",
        ft_ver .. "src/smooth/smooth.c",
        ft_ver .. "src/autofit/autofit.c",
        ft_ver .. "src/truetype/truetype.c",
        ft_ver .. "src/cff/cff.c",
        ft_ver .. "src/gzip/ftgzip.c",
        ft_ver .. "src/psnames/psnames.c",
        ft_ver .. "src/pshinter/pshinter.c"
    )

