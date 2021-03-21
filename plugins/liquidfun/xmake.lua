



target("plugin-liquidfun")
    set_kind("shared")
    add_rules("gideros_plugin")
    set_basename("liquidfun")
    add_deps("gidlua", "gideros", "gid")
    add_files("source/common/*.cpp", "source/liquidfun/Box2D/Box2D/**/*.cpp")
    add_includedirs("source/common", "source/liquidfun/Box2D",
        "../../2dsg", "../../2dsg/gfxbackends"
    )
    add_files("../../2dsg/Matrices.cpp",
        "../../luabinding/binder.cpp"
    )
    add_includedirs("../../luabinding")
