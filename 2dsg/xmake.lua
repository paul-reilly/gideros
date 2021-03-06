



target("2dsg")
    set_kind("static")
    set_default(false)
    add_deps("gidfreetype")
    add_files("*.cpp", "paths/*.c", "paths/*.cpp")
    add_includedirs("./", "./paths/", { public = true })
    add_includedirs("../libgideros/", "../libgid/include/")
    if true then --has_config("opengl2") then
        add_files("gfxbackends/gl2/*.cpp")
    elseif has_config("dx11") then 
        add_files("gfxbackends/dx11/*.cpp")
    elseif has_config("metal") then 
        add_files("gfxbackends/metal/*.mm")
    else
        --assert(false, "2dsg - please set gfxbackend")
    end 
    add_files("gfxbackends/Shaders.cpp")
    add_includedirs("gfxbackends/", { public = true })