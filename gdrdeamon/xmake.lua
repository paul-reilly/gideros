


target("gdrdaemon")
    add_rules("qt.console")
    add_frameworks("QtCore", "QtNetwork", "QtXml", "QtWebSockets")
    add_files("main.cpp",
        "application.cpp",
        "../ui/giderosnetworkclient2.cpp",
        "../libnetwork/bytebuffer.cpp",
        "qtsinglecoreapplication.cpp",
        --"qtlockedfile.cpp",
        "qtlocalpeer.cpp",
        "../ui/projectproperties.cpp",
        "../libgid/src/md5.c",
        "../ui/dependencygraph.cpp"
    )
    add_files("*.h", "../ui/giderosnetworkclient2.h")
    add_includedirs("./", "../libnetwork", "../ui", "../libgid/include")
    if is_plat("linux") then
        add_rpathdirs("$ORIGIN")
        --add_files("qtlockedfile_unix.cpp")
    elseif is_plat("windows") or is_plat("mingw") then
        add_files("qtlockedfile_win.cpp")
    end
    after_build(function(target)
        os.cp(target:targetfile(), path.join(os.scriptdir(), "../Build.Linux/Tools/"))
    end)