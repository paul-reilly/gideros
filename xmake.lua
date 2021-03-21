--[[

   gideros xmake build system
  
   Build instructions (assumes compiler and make available):
  
        # install Qt via their online installer
        xmake f --qt=PATH_TO_QT_INSTALL/X.XX.X
        xmake build
        xmake package
  
   Binaries are built and copied to the `./Build.{PLATFORM}` directory.

   Non-source files are copied there with `xmake package`.

   n.b.
        For working with your favourite tools, you can create:

            compile_commands.json: xmake project -k compile_commands
            CMakeLists.txt: xmake project -k cmake


   TODO: copy libqscintilla2.15.so (or whatever) to Linux dir
         or maybe static link

--]]


set_project("Gideros")
add_rules("mode.debug", "mode.release")

add_repositories("local ./xmake-pkgs")
includes("xmake-scripts/platform.lua")
includes("**/xmake.lua")

target("all",
    {
        kind = "phony",
        default = true,
        deps = { "desktop", "plugins" },
        --after_build = function(target) cprint("${red}%d", getFortyTwo()) end
    }
)

target("libs", 
    {  
        kind = "phony", 
        default = false,
        deps = { "gvfs", "gidlua", "gideros" }
    }
)

target("desktop",
    {
        kind = "phony",
        default = false,
        deps = { "libs", "GiderosStudio", "GiderosPlayer", "gdrbridge" },
        rundir = "./Build.Linux"
    }
)

-------------------------------------------------------------------------------


includes("xmake-scripts/plugin_rules.lua")
includes("plugins/**/xmake.lua")

target("plugins",
    {
        kind = "phony",
        default = false,
        optimize = "fastest",
        deps  = { 
            "plugin-threads", "plugin-virtualpad", "plugin-require", 
            "plugin-liquidfun"
        }
    }
)

--
--  Android, x86_64 and ARM targets
--      "private" target for build script use only
--

target("private-plugins-android",
    {
        plat = "android",
        kind = "phony",
        default = false,
        optimize = "fastest",
        deps  = { 
            "plugin-threads", "plugin-virtualpad", "plugin-require", 
            "plugin-liquidfun"
        }
    }
)

target("plugins-android-x86_64",
    {
        kind = "phony",
        default = false,
        arch = "x86_64",
        deps = { "private-plugins-android" }
    }
)

target("plugins-android-arm",
    {
        kind = "phony",
        default = false,
        arch = "arm",
        deps = { "private-plugins-android" }
    }
)

target("plugins-android",
    {
        kind = "phony",
        default = false,
        plat = "android",
        optimize = "fastest",
        deps = { "plugins-android-x86_64", "plugins-android-arm" }
    }
)


--
--  iOS targets
--

--target("plugins-ios",
--    {
--        kind = "phony",
--        default = false,
--        plat = "ios",
--        optimize = "fastest",
--        deps = {
--            "ios", "plugins"
--        }
--    }
--)
