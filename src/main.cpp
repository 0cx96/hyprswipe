#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/helpers/Color.hpp>
#include <hyprland/src/config/ConfigManager.hpp>
#include <hyprland/src/managers/KeybindManager.hpp>
#include <string>

inline HANDLE PHANDLE = nullptr;

// State to track current row and column (1-indexed)
int currentRow = 2;
int currentCol = 2;

// Function to generate the workspace name from coordinates
std::string getWorkspaceName(int r, int c) {
    return std::to_string(r) + "-" + std::to_string(c);
}

// Synchronize plugin state with the actual current workspace
void syncState() {
    auto pMonitor = g_pCompositor->getMonitorFromCursor();
    if (!pMonitor || !pMonitor->m_activeWorkspace) return;

    std::string name = pMonitor->m_activeWorkspace->m_name;
    // Fast path: check if name matches "R-C" format (e.g., "1-1")
    if (name.length() == 3 && name[1] == '-' && 
        name[0] >= '1' && name[0] <= '3' && 
        name[2] >= '1' && name[2] <= '3') {
        currentRow = name[0] - '0';
        currentCol = name[2] - '0';
    }
}

// Function to switch to a workspace
void switchToWorkspace(std::string name) {
    g_pKeybindManager->m_dispatchers["workspace"](name);
}

// Dispatchers
SDispatchResult handleRight(std::string arg) {
    syncState();
    if (currentCol < 3) {
        currentCol++;
        switchToWorkspace(getWorkspaceName(currentRow, currentCol));
    }
    return {};
}

SDispatchResult handleLeft(std::string arg) {
    syncState();
    if (currentCol > 1) {
        currentCol--;
        switchToWorkspace(getWorkspaceName(currentRow, currentCol));
    }
    return {};
}

SDispatchResult handleDown(std::string arg) {
    syncState();
    if (currentRow < 3) {
        currentRow++;
        switchToWorkspace(getWorkspaceName(currentRow, currentCol));
    }
    return {};
}

SDispatchResult handleUp(std::string arg) {
    syncState();
    if (currentRow > 1) {
        currentRow--;
        switchToWorkspace(getWorkspaceName(currentRow, currentCol));
    }
    return {};
}

SDispatchResult handleDiagonal(std::string arg) {
    // Toggle special workspace
    g_pKeybindManager->m_dispatchers["togglespecialworkspace"]("");
    return {};
}

// Versioning and Init
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    const std::string COMPOSITOR_HASH = __hyprland_api_get_hash();
    const std::string CLIENT_HASH = __hyprland_api_get_client_hash();

    if (COMPOSITOR_HASH != CLIENT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Mismatched headers! Version mismatch.", CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        throw std::runtime_error("[HyprSwipe] Version mismatch");
    }

    // Register dispatchers
    HyprlandAPI::addDispatcherV2(PHANDLE, "hyprswipe:right", handleRight);
    HyprlandAPI::addDispatcherV2(PHANDLE, "hyprswipe:left", handleLeft);
    HyprlandAPI::addDispatcherV2(PHANDLE, "hyprswipe:up", handleUp);
    HyprlandAPI::addDispatcherV2(PHANDLE, "hyprswipe:down", handleDown);
    HyprlandAPI::addDispatcherV2(PHANDLE, "hyprswipe:diagonal", handleDiagonal);

    HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Plugin loaded! Initializing...", CHyprColor{0.2, 1.0, 0.2, 1.0}, 5000);

    return {"HyprSwipe", "2D Workspace Grid Swipe Plugin", "Antigravity", "0.1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    // Cleanup if needed
}
