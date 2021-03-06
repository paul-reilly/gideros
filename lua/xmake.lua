
includes("../libgvfs")

target("lua")  ;  add_deps("gvfs")
    set_default(false)
    set_kind("shared")
    if is_plat("windows") or is_plat("mingw") then
        add_defines("LUA_BUILD_AS_DLL")
    end
    add_includedirs("src", { public = true })
    add_files("etc/all_lua.c")
    add_linkdirs("./../Build.Linux")
    add_links("gvfs")
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
