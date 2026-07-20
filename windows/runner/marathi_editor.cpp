#include "marathi_editor.h"

#include <windows.h>

#include <string>

namespace {

std::wstring Utf8ToWide(const std::string& s) {
  if (s.empty()) return std::wstring();
  int len = MultiByteToWideChar(CP_UTF8, 0, s.c_str(),
                                static_cast<int>(s.size()), nullptr, 0);
  std::wstring w(len, L'\0');
  MultiByteToWideChar(CP_UTF8, 0, s.c_str(), static_cast<int>(s.size()), &w[0],
                      len);
  return w;
}

std::string WideToUtf8(const std::wstring& w) {
  if (w.empty()) return std::string();
  int len = WideCharToMultiByte(CP_UTF8, 0, w.c_str(),
                                static_cast<int>(w.size()), nullptr, 0, nullptr,
                                nullptr);
  std::string s(len, '\0');
  WideCharToMultiByte(CP_UTF8, 0, w.c_str(), static_cast<int>(w.size()), &s[0],
                      len, nullptr, nullptr);
  return s;
}

struct EditorState {
  HWND edit = nullptr;
  HWND ok = nullptr;
  HWND cancel = nullptr;
  HFONT font = nullptr;
  bool done = false;
  bool accepted = false;
  std::wstring result;
};

const wchar_t kClassName[] = L"CrmsMarathiEditorWindow";
const int kIdEdit = 1001;
// Use the standard IDOK / IDCANCEL so IsDialogMessage maps Esc -> cancel.

void LayoutControls(HWND hwnd, EditorState* st) {
  RECT rc;
  GetClientRect(hwnd, &rc);
  const int margin = 12;
  const int btnH = 30;
  const int btnW = 96;
  const int gap = 10;
  int width = rc.right - rc.left;
  int height = rc.bottom - rc.top;

  MoveWindow(st->edit, margin, margin, width - 2 * margin,
             height - btnH - 2 * margin - gap, TRUE);
  int by = height - margin - btnH;
  MoveWindow(st->ok, width - margin - btnW, by, btnW, btnH, TRUE);
  MoveWindow(st->cancel, width - margin - 2 * btnW - gap, by, btnW, btnH, TRUE);
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
  auto* st = reinterpret_cast<EditorState*>(
      GetWindowLongPtr(hwnd, GWLP_USERDATA));
  switch (msg) {
    case WM_SIZE:
      if (st && st->edit) LayoutControls(hwnd, st);
      return 0;
    case WM_COMMAND: {
      if (!st) break;
      int id = LOWORD(wp);
      if (id == IDOK) {
        int n = GetWindowTextLengthW(st->edit);
        std::wstring buf(static_cast<size_t>(n) + 1, L'\0');
        GetWindowTextW(st->edit, &buf[0], n + 1);
        buf.resize(static_cast<size_t>(n));
        st->result = buf;
        st->accepted = true;
        st->done = true;
        DestroyWindow(hwnd);
        return 0;
      }
      if (id == IDCANCEL) {
        st->done = true;
        DestroyWindow(hwnd);
        return 0;
      }
      break;
    }
    case WM_CLOSE:
      if (st) st->done = true;
      DestroyWindow(hwnd);
      return 0;
  }
  return DefWindowProc(hwnd, msg, wp, lp);
}

void EnsureClass(HINSTANCE hinst) {
  static bool registered = false;
  if (registered) return;
  WNDCLASSW wc = {};
  wc.lpfnWndProc = WndProc;
  wc.hInstance = hinst;
  wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
  wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
  wc.lpszClassName = kClassName;
  RegisterClassW(&wc);
  registered = true;
}

}  // namespace

std::optional<std::string> ShowMarathiEditor(HWND parent,
                                             const std::string& initial_utf8,
                                             const std::string& title_utf8) {
  HINSTANCE hinst = GetModuleHandle(nullptr);
  EnsureClass(hinst);

  std::wstring title = Utf8ToWide(title_utf8);
  if (title.empty()) title = L"Type Marathi";

  const int w = 660;
  const int h = 440;
  int x = CW_USEDEFAULT, y = CW_USEDEFAULT;
  RECT pr;
  if (parent && GetWindowRect(parent, &pr)) {
    x = pr.left + ((pr.right - pr.left) - w) / 2;
    y = pr.top + ((pr.bottom - pr.top) - h) / 2;
  }

  EditorState state;

  HWND hwnd = CreateWindowExW(
      WS_EX_DLGMODALFRAME, kClassName, title.c_str(),
      WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME, x, y, w, h, parent,
      nullptr, hinst, nullptr);
  if (!hwnd) return std::nullopt;

  SetWindowLongPtr(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(&state));

  // A Devanagari-capable UI font for the popup (present on Windows 8+).
  state.font = CreateFontW(-20, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
                           DEFAULT_CHARSET, OUT_DEFAULT_PRECIS,
                           CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY,
                           DEFAULT_PITCH | FF_DONTCARE, L"Nirmala UI");

  std::wstring initial = Utf8ToWide(initial_utf8);
  state.edit = CreateWindowExW(
      WS_EX_CLIENTEDGE, L"EDIT", initial.c_str(),
      WS_CHILD | WS_VISIBLE | WS_VSCROLL | WS_TABSTOP | ES_MULTILINE |
          ES_AUTOVSCROLL | ES_WANTRETURN,
      0, 0, 10, 10, hwnd,
      reinterpret_cast<HMENU>(static_cast<INT_PTR>(kIdEdit)), hinst, nullptr);

  state.ok = CreateWindowExW(
      0, L"BUTTON", L"OK",
      WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_PUSHBUTTON, 0, 0, 10, 10, hwnd,
      reinterpret_cast<HMENU>(static_cast<INT_PTR>(IDOK)), hinst, nullptr);
  state.cancel = CreateWindowExW(
      0, L"BUTTON", L"Cancel",
      WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_PUSHBUTTON, 0, 0, 10, 10, hwnd,
      reinterpret_cast<HMENU>(static_cast<INT_PTR>(IDCANCEL)), hinst, nullptr);

  if (state.font) {
    SendMessage(state.edit, WM_SETFONT, reinterpret_cast<WPARAM>(state.font),
                TRUE);
    SendMessage(state.ok, WM_SETFONT, reinterpret_cast<WPARAM>(state.font),
                TRUE);
    SendMessage(state.cancel, WM_SETFONT,
                reinterpret_cast<WPARAM>(state.font), TRUE);
  }

  LayoutControls(hwnd, &state);
  ShowWindow(hwnd, SW_SHOW);
  UpdateWindow(hwnd);

  // Select-all + focus so typing replaces the placeholder text.
  SetFocus(state.edit);
  SendMessage(state.edit, EM_SETSEL, 0, -1);

  // Modal loop: disable the parent and pump messages until dismissed.
  if (parent) EnableWindow(parent, FALSE);
  SetForegroundWindow(hwnd);

  MSG msg;
  while (!state.done && GetMessage(&msg, nullptr, 0, 0)) {
    if (!IsDialogMessage(hwnd, &msg)) {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }

  if (parent) {
    EnableWindow(parent, TRUE);
    SetForegroundWindow(parent);
  }
  if (state.font) DeleteObject(state.font);

  if (state.accepted) return WideToUtf8(state.result);
  return std::nullopt;
}
