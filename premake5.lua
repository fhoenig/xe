workspace "XE"
    location            "Build"
	language            "C++"
	cppdialect          "C++20"
    architecture        "x86_64"
    vectorextensions    "AVX"
    staticruntime       "On" 
    startproject        "xengine"
	
    flags {
        "MultiProcessorCompile", 
        --"LinkTimeOptimization",
        "NoBufferSecurityCheck",
        "NoIncrementalLink",
        "NoManifest",
        "NoMinimalRebuild",
        "NoPCH",
        
    }
	targetdir ("Build/%{prj.name}/%{cfg.longname}")
	objdir ("Build/Temp/%{prj.name}/%{cfg.longname}")
        
    configurations { 
        "Dev-Debug", 
        "Dev-Run",
        "Rel-xengine"
    }

    defines{
        "_CRT_SECURE_NO_WARNINGS",
        "GLM_FORCE_DEPTH_ZERO_TO_ONE=1",
    }
	
	filter { "configurations:Dev-Debug" }
        optimize "Off"
        symbols  "On"
        defines{
            "_DEBUG",
        }
	
	filter { "configurations:Dev-Run" }
        symbols  "On"
        optimize "Speed"
        defines{
            "NDEBUG",
        }

    filter { "configurations:Rel-*" }
        symbols  "Off"
        optimize "Speed"
        defines {
			"NDEBUG",
        }

    filter { "configurations:Tst-*" }
        symbols  "On"
        optimize "Speed"
        defines {
			"_DEBUG",
        }    

project "xengine"
	
    kind "WindowedApp"
    targetname "xengine"

    links {
    }

	files {
        "Source/**.mm",
        "Source/**.cpp",
        "Source/**.c",
        "Source/**.hpp",
        "Source/**.h",
        "Source/**.glsl",
        "Source/**.inl",
        "Source/**.rc",
        "Source/**.rc",
        "Source/**.ico",
        "Source/**.ispc",
        "Source/**.plist",
    }

    includedirs {
        "$(VULKAN_SDK)/Include",
    }

	sysincludedirs {
        "/usr/local/include",
        "External/VulkanMemoryAllocator/include",
        "External/glm",
        "External/sdl2/win64/include",
        "Source/",
        "Source/Framework",
        "%{cfg.objdir}",
    }
    
    libdirs { 
        "$(VULKAN_SDK)/Lib",
        "/usr/local/lib",
        "%{cfg.objdir}",
    }
    
	filter { "configurations:Dev-Debug" }
        defines{
        }
	
	filter { "configurations:Dev-Run" }
        defines{
        }

    filter { "configurations:Rel-*" }
        defines {
        }
        
    filter { "system:windows", "configurations:Rel-*"}
        prelinkcommands {
        }
        links {
        }
	
	filter { "system:windows" }
    
        libdirs { 
            "External/sdl2/win64/lib",
        }

        includedirs {
        }
        
        defines {
            "VK_USE_PLATFORM_WIN32_KHR",
        }
    
		links { 
            "vulkan-1.lib",   
            "ws2_32.lib",
            "winmm.lib",
            "sdl2.lib",
            "sdl2main.lib",
        }
        		                
        postbuildcommands {
        }
        
    filter {"system:macosx"}
    
        defines {
            "VK_USE_PLATFORM_MACOS_MVK",
        }
        libdirs { 
        }

        linkoptions {
        }

        frameworkdirs {
            "External/sdl2/macos/",
        }
        
        links {
            "IOKit.framework",
            "QuartzCore.framework",
            "Metal.framework",
            "Security.framework",
            "Cocoa.framework",
            "CoreVideo.framework",
            "External/sdl2/macos/SDL2.framework",
            "vulkan",
        }

        embedAndSign  {
            "SDL2.framework",
        }        
    
                        
        postbuildcommands {
        }

        xcodebuildsettings {
            LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/../Frameworks",
            MACOSX_DEPLOYMENT_TARGET = "11.00",
            INSTALL_PATH = "",
            SKIP_INSTALL = "YES",
            PRODUCT_NAME = "xengine",
            PRODUCT_BUNDLE_IDENTIFIER = "com.rianflo.xengine",
            INFOPLIST_FILE = "$(SRCROOT)/../Source/Info.plist",
            CODE_SIGN_ENTITLEMENTS = "$(SRCROOT)/../Source/xe.entitlements";
            DEVELOPMENT_TEAM = "C7FSB7MCN2",
            ENABLE_HARDENED_RUNTIME = "YES",
        }
        
    filter {"system:macosx", "configurations:Dev-*"}
        xcodebuildsettings {
            COPY_PHASE_STRIP = "NO",
            CODE_SIGN_IDENTITY = "Apple Development",
            CODE_SIGN_STYLE = "Automatic",
            PROVISIONING_PROFILE_SPECIFIER = "",   
        }
    
    filter {"system:macosx", "configurations:Tst-*"}
        xcodebuildsettings {
        }
        
    filter {"system:macosx", "configurations:Rel-*"}
        xcodebuildsettings {
        }

