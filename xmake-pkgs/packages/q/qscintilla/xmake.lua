package("qscintilla")

    set_homepage("https://www.riverbankcomputing.com/software/qscintilla/intro")
    set_description("QScintilla is a port to Qt of Neil Hodgson's Scintilla C++ editor control.")

    set_urls("https://www.riverbankcomputing.com/static/Downloads/QScintilla/$(version)/QScintilla-$(version).zip")

    add_versions("2.11.6", "ddd0945d90bbf9394e0d4a41cfeb5bd7c1a6b918c827aa90d4396ea3da0be9a9")

    on_install("linux", function(package)
        local qtdir = get_config("qt")
        local qtdir = qtdir ~= nil and (path.join(path.translate(qtdir), "gcc_64/bin/")) or ""
        os.execv(qtdir .. "qmake", { }, { curdir = "./Qt4Qt5"})
        os.execv("make", { "-j8" }, { curdir = "./Qt4Qt5" })
        os.cp("./Qt4Qt5/libqscintilla2_qt5.so.15.0.0", path.join(package:installdir("lib"), "libqscintilla2_qt5.so")) 
        os.cp("./Qt4Qt5/libqscintilla2_qt5.so.15.0.0", path.join(package:installdir("lib"), "libqscintilla2_qt5.so.15.0.0")) 
        os.cp("./Qt4Qt5/libqscintilla2_qt5.so.15.0.0", path.join(package:installdir("lib"), "libqscintilla2_qt5.so.15")) 
        os.cp("./Qt4Qt5/Qsci/*.h", package:installdir("include/Qsci")) 
    end)
