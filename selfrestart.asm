.386
.MODEL	FLAT, STDCALL
OPTION	CASEMAP :NONE

include		windows.inc
include		user32.inc
include		kernel32.inc
includelib	user32.lib
includelib	kernel32.lib

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data
startInfo 		STARTUPINFO 		<>
processInfo 	PROCESS_INFORMATION <>
programname 	db 	"selfrestart.exe",0

.data?
hInstance		dd		?

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

	DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		.if uMsg==WM_INITDIALOG
			invoke	SetTimer,hWin,WM_USER,5000,NULL
		.elseif uMsg == WM_TIMER
			.if processInfo.hProcess!=0
				invoke CloseHandle,processInfo.hProcess
				mov processInfo.hProcess,0
			.endif
			invoke GetStartupInfo,ADDR startInfo
			invoke CreateProcess,ADDR programname,NULL,NULL,NULL,FALSE,\
								NORMAL_PRIORITY_CLASS,NULL,NULL,ADDR startInfo,ADDR processInfo
			invoke CloseHandle,processInfo.hThread
			invoke ExitProcess,0
		.elseif	uMsg == WM_CLOSE
			invoke	EndDialog,hWin,0
		.endif
		xor	eax,eax
		ret
	DlgProc	endp

end start
