#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

// Window class + title of the already-running copy, used to find and raise it.
constexpr wchar_t kWindowTitle[] = L"crms";

// One machine-wide name. Local\ (not Global\) scopes it per login session, so
// two different Windows users on the same PC each get their own copy.
constexpr wchar_t kSingleInstanceMutex[] = L"Local\\CRMS-SingleInstance-DBSquare";

// Brings the first instance's window to the front, so launching again feels
// like "switch to it" rather than nothing happening.
static BOOL CALLBACK RaiseExistingWindow(HWND hwnd, LPARAM /*param*/) {
  wchar_t title[256];
  if (::GetWindowTextW(hwnd, title, 256) == 0) {
    return TRUE;  // keep looking
  }
  if (::wcscmp(title, kWindowTitle) != 0) {
    return TRUE;
  }
  if (::IsIconic(hwnd)) {
    ::ShowWindow(hwnd, SW_RESTORE);
  }
  ::SetForegroundWindow(hwnd);
  return FALSE;  // found it — stop enumerating
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Single instance. Two copies of CRMS would open the SAME local database
  // twice: edits made in one window are invisible to the other, and whichever
  // saves last silently wins. Refuse the second launch and raise the first.
  //
  // The handle is deliberately never closed — Windows releases it when the
  // process exits, including on a crash, so a dead copy can't lock the app out.
  HANDLE instance_lock = ::CreateMutexW(nullptr, TRUE, kSingleInstanceMutex);
  if (instance_lock != nullptr && ::GetLastError() == ERROR_ALREADY_EXISTS) {
    // Fail OPEN, and only after looking for a real window.
    //
    // A silent auto-update closes the running copy, swaps the files, then
    // relaunches immediately. If the old process is still winding down it
    // still holds this mutex, and refusing the launch outright would leave
    // the station with no app at all after an update. So: if we can find the
    // other copy's window, it is genuinely running -- raise it and step
    // aside. If no window appears within ~3s, the holder is a dying process,
    // so start normally. One extra window once is recoverable; an app that
    // won't reopen on 18 police PCs is not.
    for (int attempt = 0; attempt < 20; ++attempt) {
      if (::EnumWindows(RaiseExistingWindow, 0) == FALSE) {
        return EXIT_SUCCESS;  // enumeration stopped early == window raised
      }
      if (::WaitForSingleObject(instance_lock, 150) == WAIT_OBJECT_0) {
        break;  // the old process exited and handed us the mutex
      }
    }
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(kWindowTitle, origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
