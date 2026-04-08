package utils.system;

#if (cpp && windows)
@:buildXml('
	<target id="haxe">
		<lib name="dwmapi.lib" if="windows"/>
		<lib name="shell32.lib" if="windows"/>
		<lib name="gdi32.lib" if="windows"/>
	</target>
')
@:cppFileCode('
	#include <windows.h>
	#include <stdio.h>
	#include <iostream>
	#include <dwmapi.h> // DwmSetWindowAttribute

	#define attributeDarkMode 20
	#define attributeDarkModeFallback 19

	#define attributeCaptionColor 34
	#define attributeTextColor 35
	#define attributeBorderColor 36

	struct HandleData {
		DWORD pid = 0;
		HWND handle = 0;
	};

	BOOL CALLBACK findByPID(HWND handle, LPARAM lParam) {
		DWORD targetPID = ((HandleData*)lParam)->pid;
		DWORD curPID = 0;

		GetWindowThreadProcessId(handle, &curPID);
		if (targetPID != curPID || GetWindow(handle, GW_OWNER) != (HWND)0 || !IsWindowVisible(handle)) {
			return TRUE;
		}

		((HandleData*)lParam)->handle = handle;
		return FALSE;
	}

	HWND curHandle = 0;
	void getHandle() {
		if (curHandle == (HWND)0) {
			HandleData data;
			data.pid = GetCurrentProcessId();
			EnumWindows(findByPID, (LPARAM)&data);
			curHandle = data.handle;
		}
	}
')
#end
class PlatformUtil {
	#if (cpp && windows)
	@:functionCode('return MessageBox(GetActiveWindow(), message, caption, icon | MB_SETFOREGROUND);')
	#end
	public static function showMessageBox(caption:String, message:String, icon:MessageBoxIcon = MSG_WARNING):Int
		return 0;

	/**
	 * Allocates a new console window for the current process on Windows (cpp target only).
	 *
	 * Opens `stdin`, `stdout`, and `stderr` streams to the allocated console,
	 * and sets the console's input/output code page to UTF-8 (CP 65001).
	 *
	 * This is useful for attaching a debug console to a GUI application at runtime.
	 * Only compiled and functional on `cpp` Windows targets, and is a no-op elsewhere.
	 */
	#if (cpp && windows)
	@:functionCode('
		if (!AllocConsole()) return;

		freopen("CONIN$", "r", stdin);
		freopen("CONOUT$", "w", stdout);
		freopen("CONOUT$", "w", stderr);

		SetConsoleOutputCP(65001);
		SetConsoleCP(65001);
	')
	#end
	public static function allocConsole():Void {}

	#if windows
	@:functionCode('
		system("CLS");
		std::cout << "" << std::flush;
	')
	#end
	public static function clearScreen():Void {}

	/**
	 * Enables or disables dark mode support for the title bar.
	 * Only works on Windows.
	 * 
	 * @param enable Whether to enable or disable dark mode support.
	 * @param instant Whether to skip the transition tween.
	 */
	public static function setWindowDarkMode(enable:Bool = true, instant:Bool = false):Void {
		#if (cpp && windows)
		var success:Bool = false;
		untyped __cpp__('
			getHandle();
			if (curHandle != (HWND)0) {
				const BOOL darkMode = enable ? TRUE : FALSE;
				if (S_OK == DwmSetWindowAttribute(curHandle, attributeDarkMode, (LPCVOID)&darkMode, (DWORD)sizeof(darkMode)) || S_OK == DwmSetWindowAttribute(curHandle, attributeDarkModeFallback, (LPCVOID)&darkMode, (DWORD)sizeof(darkMode))) {
					success = true;
				}

				UpdateWindow(curHandle);
			}
		');

		if (instant && success) {
			final curBarColor:Null<FlxColor> = windowBarColor;
			windowBarColor = FlxColor.BLACK;
			windowBarColor = curBarColor;
		}
		#end
	}

	/**
	 * The color of the window title bar. If `null`, the default is used.
	 * Only works on Windows.
	 */
	public static var windowBarColor(default, set):Null<FlxColor> = null;

	public static function set_windowBarColor(value:Null<FlxColor>):Null<FlxColor> {
		#if (cpp && windows)
		final intColor:Int = Std.isOfType(value, Int) ? cast FlxColor.fromRGB(value.blue, value.green, value.red, value.alpha) : 0xffffffff;
		untyped __cpp__('
			getHandle();
			if (curHandle != (HWND)0) {
				const COLORREF targetColor = (COLORREF)intColor;
				if (S_OK != DwmSetWindowAttribute(curHandle, attributeCaptionColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor))) {
					DwmSetWindowAttribute(curHandle, attributeCaptionColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor));
				}
				UpdateWindow(curHandle);
			}
		');
		#end

		return windowBarColor = value;
	}

	/**
	 * The color of the window title bar text. If `null`, the default is used.
	 * Only works on Windows.
	 */
	public static var windowTextColor(default, set):Null<FlxColor> = null;

	public static function set_windowTextColor(value:Null<FlxColor>):Null<FlxColor> {
		#if (cpp && windows)
		final intColor:Int = Std.isOfType(value, Int) ? cast FlxColor.fromRGB(value.blue, value.green, value.red, value.alpha) : 0xffffffff;
		untyped __cpp__('
			getHandle();
			if (curHandle != (HWND)0) {
				const COLORREF targetColor = (COLORREF)intColor;
				if (S_OK != DwmSetWindowAttribute(curHandle, attributeTextColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor))) {
					DwmSetWindowAttribute(curHandle, attributeTextColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor));
				}
				UpdateWindow(curHandle);
			}
		');
		#end

		return windowTextColor = value;
	}

	/**
	 * The color of the window border. If `null`, the default is used.
	 * Only works on Windows.
	 */
	public static var windowBorderColor(default, set):Null<FlxColor> = null;

	public static function set_windowBorderColor(value:Null<FlxColor>):Null<FlxColor> {
		#if (cpp && windows)
		final intColor:Int = Std.isOfType(value, Int) ? cast FlxColor.fromRGB(value.blue, value.green, value.red, value.alpha) : 0xffffffff;
		untyped __cpp__('
			getHandle();
			if (curHandle != (HWND)0) {
				const COLORREF targetColor = (COLORREF)intColor;
				if (S_OK != DwmSetWindowAttribute(curHandle, attributeBorderColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor))) {
					DwmSetWindowAttribute(curHandle, attributeBorderColor, (LPCVOID)&targetColor, (DWORD)sizeof(targetColor));
				}
				UpdateWindow(curHandle);
			}
		');
		#end

		return windowBorderColor = value;
	}
}

enum abstract MessageBoxIcon(Int) {
	var MSG_ERROR:MessageBoxIcon = 0x00000010;
	var MSG_QUESTION:MessageBoxIcon = 0x00000020;
	var MSG_WARNING:MessageBoxIcon = 0x00000030;
	var MSG_INFORMATION:MessageBoxIcon = 0x00000040;
}
