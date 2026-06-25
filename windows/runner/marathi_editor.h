#ifndef RUNNER_MARATHI_EDITOR_H_
#define RUNNER_MARATHI_EDITOR_H_

#include <windows.h>

#include <optional>
#include <string>

// Shows a modal native Windows text editor (a real OS edit control, so any
// keyboard / IME — InScript, ISM typewriter, Godrej, phonetic — types correctly
// just like Notepad/Word). Text is UTF-8 in and out.
//
// Returns the edited text on OK, or std::nullopt if the user cancelled.
std::optional<std::string> ShowMarathiEditor(HWND parent,
                                             const std::string& initial_utf8,
                                             const std::string& title_utf8);

#endif  // RUNNER_MARATHI_EDITOR_H_
