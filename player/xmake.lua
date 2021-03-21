add_rules("mode.debug", "mode.release")

target("GiderosPlayer")
    add_deps("gvfs", "gidlua", "gid", "gideros", "pystring", "gidfreetype")
    --add_deps("2dsg")--, { configs = { opengl2 = true }})
    set_default(true)
    add_rules("qt.widgetapp")
    add_frameworks("QtCore", "QtWidgets", "QtGui", "QtOpenGL", "QtNetwork", "qtmultimedia5")
    add_defines("USE_FILE32API")
    add_syslinks("pthread")
    if is_plat("linux") then
        add_ldflags("-std=gnu++11")
        add_defines("STRICT_LINUX")
        add_syslinks("z")
        add_rpathdirs("$ORIGIN")
        add_linkdirs("../libgid/external/zlib-1.2.8/build/gcc484_64",
            "../libgid/external/glew-1.10.0/lib/gcc484_64",
            "../libgid/external/openal-soft-1.13/build/gcc484_64"
        )
        add_links("zlibx", "GLEW", "openal")
    elseif is_plat("windows") or is_plat("mingw") then
        add_files("./Other_files/player.rc")
        add_syslinks("ws2_32", "iphlpapi")
        if is_plat("mingw") then
            add_ldflags("-Wl,-Map=LinkerMap.txt")
        end
    end
    add_links("gvfs", "gid", "gideros")
    add_files("Forms/*.ui")
    add_files("Headers/mainwindow.h",
        "Headers/errordialog.h",
        "Headers/glcanvas.h",
        "Headers/settingsdialog.h",
        "../luabinding/*.h"
    )
    add_files("Sources/main.cpp",
        "Sources/mainwindow.cpp",
        "Sources/errordialog.cpp",
        "Sources/glcanvas.cpp",
        "Sources/settingsdialog.cpp",
        "../luabinding/*.cpp",
        "../luabinding/tlsf.c",
        "../libnetwork/*.cpp",
        
        "../2dsg/*.cpp",
        "../2dsg/gfxbackends/*.cpp",
        "../2dsg/gfxbackends/gl2/*.cpp",
        "../2dsg/paths/*.cpp", 
        "../2dsg/paths/ft-path.c",
        "../2dsg/paths/svg-path.c",

        "../libpvrt/*.cpp",
        "../external/glu/libtess/*.c",
        "../external/minizip-1.1/source/ioapi.c",
        "../external/minizip-1.1/source/unzip.c",
        "../libpvrt/*.h",

        -- libgid stuff - use lib?
        "../libgid/src/aes.c",
        "../libgid/src/md5.c",
        "../libgid/src/platformutil.cpp",
        "../libgid/src/utf8.c",
        "../libgid/src/drawinfo.cpp",
        "../libgid/src/qt/platform-qt.cpp",
        "../libgid/src/gtimer.cpp",
        
        --"../libgid/src/qt/gui-qt.cpp",
        --"../libgid/include/qt/gui-qt.h",

        --"../libgid/src/qt/ghttp-qt.cpp",
        --"../libgid/include/qt/ghttp-qt.h",
        "../libgid/src/qt/gapplication-qt.cpp",
        
        "../libgid/include/gui.h",

        "../libgid/src/drawinfo.cpp",
        "../libgid/src/aes.c",
        "../libgid/src/md5.c",
        "../libgid/src/platformutil.cpp",
        "../libgid/src/utf8.c",
        "../libgid/src/gtimer.cpp"
    )
    add_includedirs("Headers", "Sources", "Forms", 
        "../2dsg", "../2dsg/gfxbackends", "../2dsg/gfxbackends/gl2", "../2dsg/paths",
        "../libnetwork", "../luabinding",
        "../libpvrt",
        "../external/glu",
        "../external/minizip-1.1/source",
        --"../libraries/themes",
        "../libraries/constants",
        "../libgid/include/qt/"
    )

    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
    


