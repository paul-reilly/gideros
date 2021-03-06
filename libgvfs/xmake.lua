


target("gvfs")
    set_default(false)
    set_kind("shared")
    add_files("*.c", "*.cpp")
    add_defines("GIDEROS_LIBRARY")
    add_includedirs("./", { public = true })
    add_includedirs("./private")
    if is_plat("linux") then
        add_defines("STRICT_LINUX")
    end
    add_syslinks("pthread") 
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
