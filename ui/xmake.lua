--
-- builds Gideros Studio, the IDE/debugger
--


add_requires("qscintilla", { configs = { shared = true }})

target("GiderosStudio")
    add_rules("qt.widgetapp")
    add_packages("qscintilla")
    add_frameworks("QtGui", "QtCore", "QtXml", "QtNetwork", "QtWidgets", "QtWebSockets")
    set_rundir("../Build.Linux")
    add_files("ui.qrc")
    add_includedirs("./")
    add_files("*.ui")
    add_files("main.cpp",
        "mainwindow.cpp",
        "librarywidget.cpp",
        "outlinewidget.cpp",
        "giderosnetworkclient2.cpp",
        "finddialog.cpp",
        "replacedialog.cpp",
        "findinfilesdialog.cpp",
        "newprojectdialog.cpp",
        "fileassociationsdialog.cpp",
        "fileassociationeditdialog.cpp",
        "pluginselector.cpp",
        "plugineditor.cpp",
        "textedit.cpp",
        "playersettingsdialog.cpp",
        "gotolinedialog.cpp",
        "savechangesdialog.cpp",
        "librarytreewidget.cpp",
        "codedependenciesdialog.cpp",
        "addnewfiledialog.cpp",
        "../libpreviewwidget/previewwidget.cpp",
        "../iconlibrary/iconlibrary.cpp",
        "../libnetwork/bytebuffer.cpp",
        "exportprojectdialog.cpp",
        "exportprogress.cpp",
        "aboutdialog.cpp",
        "projectpropertiesdialog.cpp",
        "startpagewidget2.cpp",
        "recentprojectswidget.cpp",
        "exampleprojectswidget.cpp",
        "projectproperties.cpp",
        "propertyeditingtable.cpp",
        "mdiarea.cpp",
        "mdisubwindow.cpp",
        "dependencygraph.cpp",
        "addons.cpp",
        "qtutils.cpp",
        "preferencesdialog.cpp",
        "profilerreport.cpp"
    )
    add_files("mainwindow.h",
        "librarywidget.h",
        "giderosnetworkclient2.h",
        "finddialog.h",
        "replacedialog.h",
        "findinfilesdialog.h",
        "newprojectdialog.h",
        "fileassociationsdialog.h",
        "fileassociationeditdialog.h",
        "textedit.h",
        "playersettingsdialog.h",
        "gotolinedialog.h",
        "savechangesdialog.h",
        "librarytreewidget.h",
        "outlinewidget.h",
        "codedependenciesdialog.h",
        "addnewfiledialog.h",
        "../libpreviewwidget/previewwidget.h",
        "exportprojectdialog.h",
        "exportprogress.h",
        "aboutdialog.h",
        "projectpropertiesdialog.h",
        "projectproperties.h",
        "propertyeditingtable.h",
        "startpagewidget2.h",
        "recentprojectswidget.h",
        "exampleprojectswidget.h",
        "mdiarea.h",
        "mdisubwindow.h",
        "pluginselector.h",
        "plugineditor.h",
        "dependencygraph.h",
        "addons.h",
        "qtutils.h",
        "preferencesdialog.h",
        "settingskeys.h",
        "profilerreport.h"
    )
    add_files("../libgid/src/platformutil.cpp", 
        "../libgid/src/aes.c",
		"../libgid/src/md5.c"
    )
    
    add_includedirs("../iconlibrary", "../libpreviewwidget",
        "../libnetwork", "../libgid/src/qt",
        "../libpvrt", "../libgid/include", "../libgideros"
    )

    -- lua functionality
    add_defines("DESKTOP_TOOLS")
    add_includedirs("../lua/src")
    add_files("../lua/src/lapi.c",
	    "../lua/src/lauxlib.c",
	    "../lua/src/lcode.c",
	    "../lua/src/ldebug.c",
	    "../lua/src/ldo.c",
	    "../lua/src/ldump.c",
	    "../lua/src/lfunc.c",
	    "../lua/src/llex.c",
	    "../lua/src/lmem.c",
	    "../lua/src/lobject.c",
	    "../lua/src/lopcodes.c",
	    "../lua/src/lparser.c",
	    "../lua/src/lstate.c",
	    "../lua/src/lstring.c",
	    "../lua/src/ltable.c",
	    "../lua/src/ltm.c",
	    "../lua/src/lundump.c",
	    "../lua/src/lvm.c",
	    "../lua/src/lzio.c",
	    "../lua/src/lgc.c",
	    "../lua/src/linit.c",
	    "../lua/src/lbaselib.c",
	    "../lua/src/ldblib.c",
	    "../lua/src/liolib.c",
	    "../lua/src/lmathlib.c",
	    "../lua/src/loslib.c",
	    "../lua/src/ltablib.c",
	    "../lua/src/lstrlib.c",
	    "../lua/src/lutf8lib.c",
	    "../lua/src/lint64.c",
	    "../lua/src/loadlib.c"
    )

    add_files("../plugins/json/source/strbuf.c",
        "../plugins/json/source/fpconv.c",
        "../plugins/json/source/lua_cjson.c"
    )
    if is_plat("mingw") then 
        add_syslinks("iphlpapi")
    elseif is_plat("linux") then 
        add_rpathdirs("$ORIGIN")
    end
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)

    on_package(function(target)
        local dest = "../Build.Linux/"
        os.cp(path.join(os.scriptdir(), "/Resources/"), path.join(os.scriptdir(), dest .. "Resources/"))
        os.cp(path.join(os.scriptdir(), "../Library/"), path.join(os.scriptdir(), dest .. "Library/"))
        os.cp(path.join(os.scriptdir(), "/Templates/"), path.join(os.scriptdir(), dest .. "Templates/"))
        os.cp(path.join(os.scriptdir(), "/Tools/"), path.join(os.scriptdir(), dest .. "Tools/"))
        os.cp(path.join(os.scriptdir(), "../samplecode/*"), path.join(os.scriptdir(), dest .. "Examples/"))
    end)
