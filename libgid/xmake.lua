
includes("external")

target("gid")
    add_rules("qt.shared")
    add_deps("gvfs", "gidlibxmp")
    add_frameworks("QtGui", "QtOpenGL", "QtNetwork", "QtWidgets")
    add_defines("GIDEROS_LIBRARY")
    add_links("gvfs")-- "gidlibxmp")
    if is_plat("linux") then 
        add_rpathdirs("$ORIGIN")
    end
    
    add_files("libgid.cpp", 
        "src/gvfs-native.cpp",
        "src/gimage-png.cpp",
        "src/gimage-jpg.cpp",
        "src/gimage.cpp",
        "src/gtexture.cpp",
        "src/gevent.cpp",
        "src/glog.cpp",
        "src/gglobal.cpp",
        "src/qt/gui-qt.cpp",
        "include/qt/gui-qt.h",
        "src/qt/ginput-qt.cpp",
        "include/qt/ginput-qt.h",
        "src/qt/ggeolocation-qt.cpp",
        "src/qt/ghttp-qt.cpp",
        "include/qt/ghttp-qt.h",
        "src/qt/gaudio-qt.cpp",
        "src/gaudio.cpp",
        "src/gaudio-sample-openal.cpp",
        "src/gaudio-stream-openal.cpp",
        "src/gaudio-loader-wav.cpp",
        "src/gaudio-loader-xmp.cpp",
        "src/gaudio-loader-mp3.cpp"
    )

    add_includedirs("include", "include/qt", { public = true })
    add_includedirs("../2dsg/gfxbackends", "../2dsg")

    add_files("external/snappy-1.1.0/snappy*.cc|snappy*test*")
    add_includedirs("external/snappy-1.1.0")

    add_includedirs("external/libpng-1.6.2", "external/jpeg-9", "external/glew-1.10.0/include")
    add_includedirs("external/mpg123-1.15.3/src/libmpg123", "external/openal-soft-1.13/include")

    local dir = ""
    if is_plat("linux") then -- maybe android/ios too (unix!macx in .pro)
        add_defines("OPENAL_SUBDIR_AL", "STRICT_LINUX")
        dir = "gcc484_64"
    elseif is_plat("mingw") then
        add_defines("OPENAL_SUBDIR_AL")
        dir = "mingw48_32"
    elseif is_plat("macos") then
        add_defines("OPENAL_SUBDIR_OPENAL")
        dir = "clang_64"
        add_frameworks("OpenAL, OpenGL", "CoreFoundation")
    end
    
    add_linkdirs("external/libpng-1.6.2/build/" .. dir)
    add_linkdirs("external/openal-soft-1.13/build/" .. dir)
    add_linkdirs("external/glew-1.10.0/lib/" .. dir)
    add_linkdirs("external/jpeg-9/build/" .. dir)
    add_linkdirs("external/mpg123-1.15.3/lib/" .. dir)
    add_linkdirs("external/zlib-1.2.8/build/" .. dir)
    add_links("png", "openal", "GLEW", "jpeg", "mpg123", "zlibx")
    add_syslinks("pthread")

    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
