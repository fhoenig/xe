#include <vector>
#include <cstdio>
#include <SDL2/SDL.h>
#include <SDL2/SDL_syswm.h>


#define VOLK_IMPLEMENTATION
#include <volk.h>
#include <vulkan/vulkan.h>
#if __APPLE__
#include <vulkan/vulkan_metal.h>
#endif


VkInstance createVulkanInstance()
{
    VkInstance instance = 0;
    VkApplicationInfo appInfo {
        .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pNext = nullptr,
        .apiVersion = VK_API_VERSION_1_2,
        .pApplicationName = "xengine",
    };

    std::vector<const char*> enabledExtensions = {
        VK_KHR_SURFACE_EXTENSION_NAME,
        #ifdef __APPLE__
        VK_EXT_METAL_SURFACE_EXTENSION_NAME,
        VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME,
        #else
        VK_KHR_WIN32_SURFACE_EXTENSION_NAME,
        #endif
        VK_EXT_DEBUG_REPORT_EXTENSION_NAME
    };

    std::vector<const char*> instance_layer_names = {
        "VK_LAYER_KHRONOS_validation",
    };

    VkInstanceCreateInfo instanceCreateInfo {
        .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pNext = nullptr,
        .pApplicationInfo = &appInfo,
    };
    
    if (enabledExtensions.size() > 0)
    {
        instanceCreateInfo.enabledExtensionCount = (uint32_t)enabledExtensions.size();
        instanceCreateInfo.ppEnabledExtensionNames = enabledExtensions.data();
    }
    
    if (instance_layer_names.size() > 0)
    {
        instanceCreateInfo.enabledLayerCount = (uint32_t)instance_layer_names.size();
        instanceCreateInfo.ppEnabledLayerNames = instance_layer_names.data();
    }
    instanceCreateInfo.flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
    VkResult res = vkCreateInstance(&instanceCreateInfo, nullptr, &instance);
    if (res != VK_SUCCESS)
    {
        throw std::runtime_error("Failed to create Vulkan instance");
    }

    volkLoadInstance(instance);
    return instance;
}

int main(int argc, char** argv)
{
    volkInitialize();
    VkInstance instance = createVulkanInstance();
    
    // physical devices
    uint32_t deviceCount = 0;
    vkEnumeratePhysicalDevices(instance, &deviceCount, nullptr);

    if (deviceCount == 0)
    {
        throw std::runtime_error("Failed to find GPUs with Vulkan support");
    }
    std::vector<VkPhysicalDevice> gpus;
    gpus.resize(deviceCount);
    vkEnumeratePhysicalDevices(instance, &deviceCount, gpus.data());
    for (auto& gpu : gpus)
    {
        VkPhysicalDeviceProperties deviceProperties;
        VkPhysicalDeviceFeatures deviceFeatures;

        vkGetPhysicalDeviceProperties(gpu, &deviceProperties);
        vkGetPhysicalDeviceFeatures(gpu, &deviceFeatures);
        
        printf("Device name %s\n", deviceProperties.deviceName);
    }

    int windowFlags = SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI;
    SDL_Window *window = SDL_CreateWindow("xengine", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, windowFlags);
        
    bool running = true;
    while (running)
    {
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT)
            {
                running = false;
                break;
            }
        }
    }

    SDL_DestroyWindow(window);
    return 0;
}
