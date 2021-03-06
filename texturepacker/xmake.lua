


target("texturepacker")
    add_rules("qt.widgetapp")
    add_files("mainwindow.h", "canvas.h", "librarytreewidget.h", "newprojectdialog.h")
    add_files("optionswidget.h", "projectproperties.h")
    add_files("*.cpp", "*.ui")
    if is_plat("windows") or is_plat("mingw") then
        add_files("*.rc")
    end
    add_frameworks("QtCore", "QtGui", "QtWidgets", "QtXml")
    add_rpathdirs(is_plat("linux") and "$ORIGIN")
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
    
