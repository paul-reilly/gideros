

target("pystring")
    set_kind("shared")
    add_files("*.cpp")
    add_includedirs("./", { public = true })
    add_defines("PYSTRING_LIBRARY")
    after_build(function(target)
        local dest = "../Build.Linux/"
        os.cp(target:targetfile(), path.join(os.scriptdir(), dest))
    end)
