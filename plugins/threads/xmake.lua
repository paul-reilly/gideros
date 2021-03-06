

target("plugin-threads")
    set_default("false")
    set_kind("shared")
    add_rules("gideros_plugin")
    set_basename("threads")
    add_deps("lua", "gideros", "gvfs", "gid" )
    
    add_files("source/*.cpp",
        "../lfs/source/lfs.cpp",
        "../../luabinding/binder.cpp",
        "../../luabinding/zlibbinder.cpp"  
    )
    add_files("../luasocket/source/auxiliar.c",
        "../luasocket/source/buffer.c",
        "../luasocket/source/except.c",
        "../luasocket/source/inet.c",
        "../luasocket/source/io.c",
        "../luasocket/source/luasocket.c",
        "../luasocket/source/options.c",
        "../luasocket/source/select.c",
        "../luasocket/source/tcp.c",
        "../luasocket/source/timeout.c",
        "../luasocket/source/udp.c",
        "../luasocket/source/mime.c"
    )
    add_includedirs("../../Sdk/include",
        "../../luabinding",
        "../../libgid/external/zlib-1.2.8"
    )
    if not is_plat("mingw") and not is_plat("windows") then
        add_files("../luasocket/source/usocket.c")
        add_linkdirs("../../Build.Linux")
        add_links("lua", "gideros", "gvfs", "gid")
    else 
        add_files("../luasocket/source/wsocket.c")
        add_defines("LUASOCKET_INET_PTON")
        add_syslinks("ws2_32")
    end 

    
