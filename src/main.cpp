#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/helpers/Color.hpp>
#include <hyprland/src/config/ConfigManager.hpp>
#include <hyprland/src/managers/KeybindManager.hpp>
#include <string>

inline HANDLE PHANDLE = nullptr;

/*
Workspace Grid Mapping (1-indexed rows/cols):
Column:  1  2  3
Row 1:   1  2  3
Row 2:   4  5  6
Row 3:   7  8  9
*/

// State to track current row and column (1-indexed)
int currentRow = 2;
int currentCol = 2;

// Function to generate the workspace name from coordinates
std::string getWorkspaceName(int r, int c) {
    int ws = (r - 1) * 3 + c;
    return std::to_string(ws);
}

// Synchronize plugin state with the actual current workspace
void syncState() {
    auto pMonitor = g_pCompositor->getMonitorFromCursor();
    if (!pMonitor || !pMonitor->m_activeWorkspace) return;

    std::string name = pMonitor->m_activeWorkspace->m_name;
    
    // Check if name is a single digit 1-9
    if (name.length() == 1 && name[0] >= '1' && name[0] <= '9') {
        int ws = name[0] - '0';
        currentRow = (ws - 1) / 3 + 1;
        currentCol = (ws - 1) % 3 + 1;
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
        std::string name = getWorkspaceName(currentRow, currentCol);
        HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Swiping to " + name, CHyprColor{0.2, 0.8, 0.2, 1.0}, 2000);
        switchToWorkspace(name);
    }
    return {};
}

SDispatchResult handleLeft(std::string arg) {
    syncState();
    if (currentCol > 1) {
        currentCol--;
        std::string name = getWorkspaceName(currentRow, currentCol);
        HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Swiping to " + name, CHyprColor{0.2, 0.8, 0.2, 1.0}, 2000);
        switchToWorkspace(name);
    }
    return {};
}

SDispatchResult handleDown(std::string arg) {
    syncState();
    if (currentRow < 3) {
        currentRow++;
        std::string name = getWorkspaceName(currentRow, currentCol);
        HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Swiping to " + name, CHyprColor{0.2, 0.8, 0.2, 1.0}, 2000);
        switchToWorkspace(name);
    }
    return {};
}

SDispatchResult handleUp(std::string arg) {
    syncState();
    if (currentRow > 1) {
        currentRow--;
        std::string name = getWorkspaceName(currentRow, currentCol);
        HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Swiping to " + name, CHyprColor{0.2, 0.8, 0.2, 1.0}, 2000);
        switchToWorkspace(name);
    }
    return {};
}

SDispatchResult handleDiagonal(std::string arg) {
    HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Toggling Special", CHyprColor{0.2, 0.2, 0.8, 1.0}, 2000);
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

    HyprlandAPI::addNotification(PHANDLE, "[HyprSwipe] Plugin loaded! (Workspace 1-9)", CHyprColor{0.2, 1.0, 0.2, 1.0}, 5000);

    return {"HyprSwipe", "2D Workspace Grid Swipe Plugin", "Antigravity", "0.1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    // Cleanup if needed
}
