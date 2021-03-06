

target("gdrbridge")
    add_rules("qt.console")
    add_frameworks("QtCore", "QtNetwork")
    add_files("main.cpp")
    if is_plat("linux") then
        add_rpathdirs("$ORIGIN")
    end
    after_build(function(target)
        os.cp(target:targetfile(), path.join(os.scriptdir(), "../Build.Linux/Tools/"))
    end)
