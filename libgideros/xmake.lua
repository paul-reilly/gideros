


target("gideros")  ;   add_deps("gid", "gidlua", "pystring")
    set_default(false)
    set_kind("shared")
    add_files("*.cpp")
    add_includedirs("./", { public = true })
    add_includedirs("../lua/src", "../libpystring")
    add_linkdirs("../Build.Linux", "../lua", "../libpystring")
    add_links("gid", "lua", "pystring")
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
