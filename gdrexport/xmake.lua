


target("gdrexport")
    add_rules("qt.console")
    add_frameworks("QtGui", "QtCore", "QtNetwork", "QtXml")
    add_deps("lua")
    add_syslinks("z")
    add_defines("DESKTOP_TOOLS")

    add_files("main.cpp", "GAppFormat.cpp", "Utilities.cpp", "WinRTExport.cpp",
        "MacOSXExport.cpp",	"ExportCommon.cpp", "ExportBuiltin.cpp", 
        "ExportXml.cpp", "ExportLua.cpp",
        "filedownloader.cpp", 
        "filedownloader.h",
        "../ui/projectproperties.cpp",
        "../ui/projectproperties.h",
        "../ui/dependencygraph.cpp",
        "../libnetwork/bytebuffer.cpp"
    )
    add_includedirs("./luaext", "../ui", "../libnetwork/", "../2dsg/")
    add_files( "./luaext/lfs.cpp")

    if is_plat("mingw") then
        add_sources("./luaext/hkey.cpp")
    elseif is_plat("macos") then
        add_frameworks("CoreFoundation", "IOKit")
    end
    after_build(function(target)
        os.cp(target:targetfile(), path.join(os.scriptdir(), "../Build.Linux/Tools/"))
    end)
