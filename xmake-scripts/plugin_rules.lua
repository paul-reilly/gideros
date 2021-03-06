--[[

    Each plugin has its own xmake file, which should all have:

        add_rules("gideros_plugin")
    
    ... in its main target.


    Plugin install directory structure:
            
        +---bump
        |   bump.gplugin
        |   
        +---bin
        |   +---Android
        |   |   \---libs
        |   |       +---arm64-v8a
        |   |       |       libbump.so
        |   |       |       
        |   |       +---armeabi-v7a
        |   |       |       libbump.so
        |   |       |       
        |   |       +---x86
        |   |       |       libbump.so
        |   |       \---x86_64
        |   |               libbump.so
        |   |               
        |   +---Html5
        |   |       bump.wasm
        |   |       
        |   +---MacOSX
        |   |       libbump.dylib
        |   |       
        |   +---win32
        |   |       bump.dll
        |   |       
        |   \---Windows
        |           bump.dll
        |           
        \---source
            |   bump.cpp
            |   bump.pro
            |   
            +---emscripten
            |       Make:file
            |       
            +---jni
            |       Android.mk
            |       Application.mk
            |       
            \---win32
                    Makefile
]]--

local function getGidPlat()
    if is_plat("linux") then return "Linux" end 
    if is_plat("mingw") then return "Windows" end
    if is_plat("android") then return "Android" end
    return false
end


rule("gideros_plugin")
    on_load(function(target)
        assert(getGidPlat(), "\n\n\t${red}Cannot build plugin '" .. target:basename() .. "' on this platform.") 
    end)
    after_build(function(target)
        -- handle lua or other plugins not having binary component
        if target:get("kind") == "phony" then return end

        if is_plat("android") then 
            cprint("${yellow}Building for Android... returning for now.")
            return 
        end        
        local targetdir = target:scriptdir()
        local dest_root = path.join(targetdir, "/../../Build." .. getGidPlat() .. "/")
        local dest_bin = path.join(dest_root, "All Plugins/" 
            .. target:basename() .. "/bin/Linux/")
        cprint("${green}Copying '" .. target:basename() .. "' plugin binary to: " .. dest_bin)
        os.cp(target:targetfile(), dest_bin)
        -- TODO: if desktop
        local plugins_dir = path.join(dest_root, "Plugins") .. "/"
        cprint("${green}Copying '" .. target:basename() .. "' plugin binary to: " .. plugins_dir)
        os.cp(target:targetfile(), plugins_dir)
    end)

    on_package(function(target)
        local targetdir = target:scriptdir()
        local dest_root = path.join(targetdir, "/../../Build.Linux/")
        local dest = path.join(dest_root, "All Plugins/" .. target:basename()) .. "/"
        cprint("${green}Copying '" .. target:basename() .. "' plugin file(s) to: " .. dest)
        os.cp(path.join(targetdir, "*.gplugin"), dest)
        
        if os.exists(path.join(targetdir, "luaplugin/")) then 
            cprint("${green}Copying '" .. target:basename() .. "' luaplugin dir to: " .. dest)
            os.cp(path.join(targetdir, "luaplugin/"), dest)
        end
    end)
